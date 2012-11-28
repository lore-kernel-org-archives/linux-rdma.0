From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 5/8] opensm/osm_torus.c: Improve QoS configuration
Date: Wed, 28 Nov 2012 14:03:26 -0500
Message-ID: <50B65FFE.6020304@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


There are two basic VLArb checks:
- the endport check, that weights for VLs 2-7 are zero
- the switch external check, with uniform weights for
     VLs 0-3 and also 4-7

So that the user can learn what exactly needs fixing when
bad configuration is found, it should correctly discriminate
between:
- bad user-supplied config for a specific port type
- user-supplied default config that is bad as applied
     to a specific port type
- OpenSM default config that is bad as applied to a
     specific port type

For the config below:

qos_vlarb_high 0:0,1:0,2:0,3:0,4:0,5:0,6:0,7:0,8:0
qos_vlarb_low 0:64,1:64,2:64,3:64,4:64,5:64,6:64,7:64,8:64
qos_ca_vlarb_low 0:64,1:64

it should produce the VLs 2-7 VLArb warning for qos_vlarb_low
as used for qos_sw0_vlarb_low, qos_rtr_vlarb_low.

This config should produce no warnings:

qos_vlarb_high 0:0,1:0,2:0,3:0,4:0,5:0,6:0,7:0
qos_vlarb_low  0:32,1:64
qos_swe_vlarb_low  0:32,1:32,2:32,3:32,4:64,5:64,6:64,7:64

Finally, a config with no VLArb data at all should warn
about the default qos_vlarb_low, qos_vlarb_high values as used for
qos_swe_vlarb_low, qos_swe_vlarb_high.  It should also warn
about the default qos_vlarb_low values as used for qos_ca_vlarb_low
and other endpoint types.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_torus.c |  189 ++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 147 insertions(+), 42 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 9d41297..b52cdfb 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -9254,13 +9254,11 @@ out:
 }
 
 static
-void check_vlarb_config(const char *vlarb_str, bool is_default,
-			const char *str, const char *pri, osm_log_t *log)
+void sum_vlarb_weights(const char *vlarb_str,
+		       unsigned total_weight[IB_MAX_NUM_VLS])
 {
-	unsigned total_weight[IB_MAX_NUM_VLS] = {0,};
 	unsigned i = 0, v, vl = 0;
 	char *end;
-	bool uniform;
 
 	while (*vlarb_str && i++ < 2 * IB_NUM_VL_ARB_ELEMENTS_IN_BLOCK) {
 		v = strtoul(vlarb_str, &end, 0);
@@ -9272,15 +9270,29 @@ void check_vlarb_config(const char *vlarb_str, bool is_default,
 		else
 			total_weight[vl] += v & 0xff;
 	}
-	uniform = true;
-	v = total_weight[0];
-	for (i = 1; i < 8; i++) {
-		if (i == 4)
-			v = total_weight[i];
-		if (total_weight[i] != v)
-			uniform = false;
+}
+
+static
+int uniform_vlarb_weight_value(unsigned *weight, unsigned count)
+{
+	int i, v = weight[0];
+
+	for (i = 1; i < count; i++) {
+		if (v != weight[i])
+			return -1;
 	}
-	if (!uniform)
+	return v;
+}
+
+static
+void check_vlarb_config(const char *vlarb_str, bool is_default,
+			const char *str, const char *pri, osm_log_t *log)
+{
+	unsigned total_weight[IB_MAX_NUM_VLS] = {0,};
+
+	sum_vlarb_weights(vlarb_str, total_weight);
+	if (!(uniform_vlarb_weight_value(&total_weight[0], 4) >= 0 &&
+	      uniform_vlarb_weight_value(&total_weight[4], 4) >= 0))
 		OSM_LOG(log, OSM_LOG_INFO,
 			"Warning: torus-2QoS requires same VLarb weights for "
 			"VLs 0-3; also for VLs 4-7: not true for %s "
@@ -9288,47 +9300,136 @@ void check_vlarb_config(const char *vlarb_str, bool is_default,
 			(is_default ? "default" : "configured"), str, pri);
 }
 
+/*
+ * Use this to check the qos_config for switch external ports.
+ */
 static
-void check_qos_config(osm_qos_options_t *opt, bool tgt_is_default,
+void check_qos_config(osm_qos_options_t *opt, osm_qos_options_t *def,
 		      const char *str, osm_log_t *log)
 {
-	const char *vlarb_str;
+	const char *vlarb_str, *tstr;
 	bool is_default;
+	unsigned max_vls;
 
-	if (opt->max_vls > 0 && opt->max_vls < 8)
+	max_vls = def->max_vls;
+	if (opt->max_vls > 0)
+		max_vls = opt->max_vls;
+
+	if (max_vls > 0 && max_vls < 8)
 		OSM_LOG(log, OSM_LOG_INFO,
 			"Warning: full torus-2QoS functionality not available "
-			"for configured %s_max_vls = %d\n", str, opt->max_vls);
+			"for configured %s_max_vls = %d\n",
+			(opt->max_vls > 0 ? str : "qos"), opt->max_vls);
 
-	if (!strcmp(str, "qos_ca"))
-		goto check_sl2vl;
+	vlarb_str = opt->vlarb_high;
+	is_default = false;
+	tstr = "qos_swe";
+	if (!vlarb_str) {
+		vlarb_str = def->vlarb_high;
+		tstr = "qos";
+	}
+	if (!vlarb_str) {
+		vlarb_str = OSM_DEFAULT_QOS_VLARB_HIGH;
+		is_default = true;
+	}
+	check_vlarb_config(vlarb_str, is_default, tstr, "high", log);
 
-	if (opt->vlarb_high) {
-		is_default = false;
-		vlarb_str = opt->vlarb_high;
-	} else {
+	vlarb_str = opt->vlarb_low;
+	is_default = false;
+	tstr = "qos_swe";
+	if (!vlarb_str) {
+		vlarb_str = def->vlarb_low;
+		tstr = "qos";
+	}
+	if (!vlarb_str) {
+		vlarb_str = OSM_DEFAULT_QOS_VLARB_LOW;
 		is_default = true;
-		vlarb_str = OSM_DEFAULT_QOS_VLARB_HIGH;
 	}
-	/*
-	 * Only check values that were actually configured, or the overall
-	 * defaults that target-specific (CA, switch port, etc) defaults
-	 * are set from.
-	 */
-	if (!is_default || tgt_is_default)
-		check_vlarb_config(vlarb_str, is_default, str, "high", log);
+	check_vlarb_config(vlarb_str, is_default, tstr, "low", log);
 
-	if (opt->vlarb_low) {
-		is_default = false;
-		vlarb_str = opt->vlarb_low;
-	} else {
+	if (opt->sl2vl)
+		OSM_LOG(log, OSM_LOG_INFO,
+			"Warning: torus-2QoS must override configured "
+			"%s_sl2vl to generate deadlock-free routes\n", str);
+}
+
+static
+void check_ep_vlarb_config(const char *vlarb_str,
+			   bool is_default, bool is_specific,
+			   const char *str, const char *pri, osm_log_t *log)
+{
+	unsigned i, total_weight[IB_MAX_NUM_VLS] = {0,};
+	int val = 0;
+
+	sum_vlarb_weights(vlarb_str, total_weight);
+	for (i = 2; i < 8; i++) {
+		val += total_weight[i];
+	}
+	if (!val)
+		return;
+
+	if (is_specific)
+		OSM_LOG(log, OSM_LOG_INFO,
+			"Warning: torus-2QoS recommends 0 VLarb weights"
+			" for VLs 2-7 on endpoint links; not true for "
+			" configured %s_vlarb_%s\n", str, pri);
+	else
+		OSM_LOG(log, OSM_LOG_INFO,
+			"Warning: torus-2QoS recommends 0 VLarb weights "
+			"for VLs 2-7 on endpoint links; not true for %s "
+			"qos_vlarb_%s values used for %s_vlarb_%s\n",
+			(is_default ? "default" : "configured"), pri, str, pri);
+}
+
+/*
+ * Use this to check the qos_config for endports
+ */
+static
+void check_qos_ep_config(osm_qos_options_t *opt, osm_qos_options_t *def,
+			 const char *str, osm_log_t *log)
+{
+	const char *vlarb_str;
+	bool is_default, is_specific;
+	unsigned max_vls;
+
+	max_vls = def->max_vls;
+	if (opt->max_vls > 0)
+		max_vls = opt->max_vls;
+
+	if (max_vls > 0 && max_vls < 2)
+		OSM_LOG(log, OSM_LOG_INFO,
+			"Warning: full torus-2QoS functionality not available "
+			"for configured %s_max_vls = %d\n",
+			(opt->max_vls > 0 ? str : "qos"), opt->max_vls);
+
+	vlarb_str = opt->vlarb_high;
+	is_default = false;
+	is_specific = true;
+	if (!vlarb_str) {
+		vlarb_str = def->vlarb_high;
+		is_specific = false;
+	}
+	if (!vlarb_str) {
+		vlarb_str = OSM_DEFAULT_QOS_VLARB_HIGH;
 		is_default = true;
+	}
+	check_ep_vlarb_config(vlarb_str, is_default, is_specific,
+			      str, "high", log);
+
+	vlarb_str = opt->vlarb_low;
+	is_default = false;
+	is_specific = true;
+	if (!vlarb_str) {
+		vlarb_str = def->vlarb_low;
+		is_specific = false;
+	}
+	if (!vlarb_str) {
 		vlarb_str = OSM_DEFAULT_QOS_VLARB_LOW;
+		is_default = true;
 	}
-	if (!is_default || tgt_is_default)
-		check_vlarb_config(vlarb_str, is_default, str, "low", log);
+	check_ep_vlarb_config(vlarb_str, is_default, is_specific,
+			      str, "low", log);
 
-check_sl2vl:
 	if (opt->sl2vl)
 		OSM_LOG(log, OSM_LOG_INFO,
 			"Warning: torus-2QoS must override configured "
@@ -9417,11 +9518,15 @@ out:
 			teardown_torus(ctx->torus);
 		ctx->torus = torus;
 
-		check_qos_config(&opt->qos_options, 1, "qos", log);
-		check_qos_config(&opt->qos_ca_options, 0, "qos_ca", log);
-		check_qos_config(&opt->qos_sw0_options, 0, "qos_sw0", log);
-		check_qos_config(&opt->qos_swe_options, 0, "qos_swe", log);
-		check_qos_config(&opt->qos_rtr_options, 0, "qos_rtr", log);
+		check_qos_config(&opt->qos_swe_options,
+				 &opt->qos_options, "qos_swe", log);
+
+		check_qos_ep_config(&opt->qos_ca_options,
+				    &opt->qos_options, "qos_ca", log);
+		check_qos_ep_config(&opt->qos_sw0_options,
+				    &opt->qos_options, "qos_sw0", log);
+		check_qos_ep_config(&opt->qos_rtr_options,
+				    &opt->qos_options, "qos_rtr", log);
 	}
 	teardown_fabric(fabric);
 	return status;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
