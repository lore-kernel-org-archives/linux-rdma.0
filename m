From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 05/13] opensm: Cause torus-2QoS to warn if QoS
 configuration will cause issues.
Date: Fri, 12 Nov 2010 15:11:14 -0700
Message-ID: <1289599882-15165-6-git-send-email-jaschut@sandia.gov>
References: <1289599882-15165-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289599882-15165-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Torus-2QoS needs 8 VLs, and complete control over sl2vl maps, in order
to provide 2 QoS levels with routing that is free of credit loops on torus
fabrics.  Warn to this effect if an insufficient max_vls configuration
or a non-default qos_sl2vl configuration is detected.

Also, torus-2QoS needs to use VLs 0-3 to implement one QoS level, and
VLs 4-7 to implement the other.  The VLarb weights for VLs 0-3 should
all have the same value, and similarly for the weights for VLs 4-7.
Otherwise, differences in data rates for different paths may cause
hard-to-diagnose application issues.  Warn to this effect when
detected.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_torus.c |   87 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_torus.c b/opensm/opensm/osm_torus.c
index aeb4fe6..784955d 100644
--- a/opensm/opensm/osm_torus.c
+++ b/opensm/opensm/osm_torus.c
@@ -9038,6 +9038,84 @@ out:
 }
 
 static
+void check_vlarb_config(const char *vlarb_str, bool is_default,
+			const char *str, const char *pri, osm_log_t *log)
+{
+	unsigned total_weight[IB_MAX_NUM_VLS] = {0,};
+	unsigned i = 0, v, vl = 0;
+	char *end;
+	bool uniform;
+
+	while (*vlarb_str && i++ < 2 * IB_NUM_VL_ARB_ELEMENTS_IN_BLOCK) {
+		v = strtoul(vlarb_str, &end, 0);
+		if (*end)
+			end++;
+		vlarb_str = end;
+		if (i & 0x1)
+			vl = v & 0xf;
+		else
+			total_weight[vl] += v & 0xff;
+	}
+	uniform = true;
+	v = total_weight[0];
+	for (i = 1; i < 8; i++) {
+		if (i == 4)
+			v = total_weight[i];
+		if (total_weight[i] != v)
+			uniform = false;
+	}
+	if (!uniform)
+		OSM_LOG(log, OSM_LOG_INFO,
+			"Warning: torus-2QoS requires same VLarb weights for "
+			"VLs 0-3; also for VLs 4-7: not true for %s "
+			"%s_vlarb_%s\n",
+			(is_default ? "default" : "configured"), str, pri);
+}
+
+static
+void check_qos_config(osm_qos_options_t *opt, bool tgt_is_default,
+		      const char *str, osm_log_t *log)
+{
+	const char *vlarb_str;
+	bool is_default;
+
+	if (opt->max_vls > 0 && opt->max_vls < 8)
+		OSM_LOG(log, OSM_LOG_INFO,
+			"Warning: full torus-2QoS functionality not available "
+			"for configured %s_max_vls = %d\n", str, opt->max_vls);
+
+	if (opt->vlarb_high) {
+		is_default = false;
+		vlarb_str = opt->vlarb_high;
+	} else{
+		is_default = true;
+		vlarb_str = OSM_DEFAULT_QOS_VLARB_HIGH;
+	}
+	/*
+	 * Only check values that were actually configured, or the overall
+	 * defaults that target-specific (CA, switch port, etc) defaults
+	 * are set from.
+	 */
+	if (!is_default || tgt_is_default)
+		check_vlarb_config(vlarb_str, is_default, str, "high", log);
+
+	if (opt->vlarb_low) {
+		is_default = false;
+		vlarb_str = opt->vlarb_low;
+	} else {
+		is_default = true;
+		vlarb_str = OSM_DEFAULT_QOS_VLARB_LOW;
+	}
+	if (!is_default || tgt_is_default)
+		check_vlarb_config(vlarb_str, is_default, str, "low", log);
+
+	if (opt->sl2vl)
+		OSM_LOG(log, OSM_LOG_INFO,
+			"Warning: torus-2QoS must override configured "
+			"%s_sl2vl to generate deadlock-free routes\n", str);
+}
+
+static
 int torus_build_lfts(void *context)
 {
 	int status = -1;
@@ -9111,9 +9189,18 @@ out:
 		if (torus)
 			teardown_torus(torus);
 	} else {
+		osm_subn_opt_t *opt = &torus->osm->subn.opt;
+		osm_log_t *log = &torus->osm->log;
+
 		if (ctx->torus)
 			teardown_torus(ctx->torus);
 		ctx->torus = torus;
+
+		check_qos_config(&opt->qos_options, 1, "qos", log);
+		check_qos_config(&opt->qos_ca_options, 0, "qos_ca", log);
+		check_qos_config(&opt->qos_sw0_options, 0, "qos_sw0", log);
+		check_qos_config(&opt->qos_swe_options, 0, "qos_swe", log);
+		check_qos_config(&opt->qos_rtr_options, 0, "qos_rtr", log);
 	}
 	teardown_fabric(fabric);
 	return status;
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
