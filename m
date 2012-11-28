From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 8/8] opensm/osm_torus.c: Minor simplification to check_qos_config
Date: Wed, 28 Nov 2012 14:03:44 -0500
Message-ID: <50B66010.2000307@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Eliminate unneeded argument from check_qos_config
and rename to check_qos_swe_config

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_torus.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index b2a8832..43343c7 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -9304,8 +9304,8 @@ void check_vlarb_config(const char *vlarb_str, bool is_default,
  * Use this to check the qos_config for switch external ports.
  */
 static
-void check_qos_config(osm_qos_options_t *opt, osm_qos_options_t *def,
-		      const char *str, osm_log_t *log)
+void check_qos_swe_config(osm_qos_options_t *opt,
+			  osm_qos_options_t *def, osm_log_t *log)
 {
 	const char *vlarb_str, *tstr;
 	bool is_default;
@@ -9319,7 +9319,7 @@ void check_qos_config(osm_qos_options_t *opt, osm_qos_options_t *def,
 		OSM_LOG(log, OSM_LOG_INFO,
 			"Warning: full torus-2QoS functionality not available "
 			"for configured %s_max_vls = %d\n",
-			(opt->max_vls > 0 ? str : "qos"), opt->max_vls);
+			(opt->max_vls > 0 ? "qos_swe" : "qos"), opt->max_vls);
 
 	vlarb_str = opt->vlarb_high;
 	is_default = false;
@@ -9350,7 +9350,7 @@ void check_qos_config(osm_qos_options_t *opt, osm_qos_options_t *def,
 	if (opt->sl2vl)
 		OSM_LOG(log, OSM_LOG_INFO,
 			"Warning: torus-2QoS must override configured "
-			"%s_sl2vl to generate deadlock-free routes\n", str);
+			"qos_swe_sl2vl to generate deadlock-free routes\n");
 }
 
 static
@@ -9518,8 +9518,8 @@ out:
 			teardown_torus(ctx->torus);
 		ctx->torus = torus;
 
-		check_qos_config(&opt->qos_swe_options,
-				 &opt->qos_options, "qos_swe", log);
+		check_qos_swe_config(&opt->qos_swe_options, &opt->qos_options,
+				     log);
 
 		check_qos_ep_config(&opt->qos_ca_options,
 				    &opt->qos_options, "qos_ca", log);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
