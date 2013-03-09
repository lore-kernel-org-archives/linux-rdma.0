From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] opensm/osm_torus.c: clarify log messages on stale priv
 pointers
Date: Sat, 09 Mar 2013 08:26:58 -0500
Message-ID: <513B38A2.8010603@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 4eccc4b7d6e7356a39ea535480b880e95f7b2880 Mon Sep 17 00:00:00 2001
From: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Date: Fri, 8 Mar 2013 09:31:10 -0700
Subject: [PATCH 2/2] opensm/osm_torus.c: clarify log messages on stale priv pointers


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/osm_torus.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index bc3c0b8..1d7a505 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -8071,8 +8071,8 @@ void torus_update_osm_sl2vl(void *context, osm_physp_t *osm_phys_port,
 
 			guid = osm_node_get_node_guid(node);
 			OSM_LOG(log, OSM_LOG_INFO,
-				"Error: osm_switch (GUID 0x%04"PRIx64") "
-				"not in our fabric description\n",
+				"Note: osm_switch (GUID 0x%04"PRIx64") "
+				"not in torus fabric description\n",
 				cl_ntoh64(guid));
 			return;
 		}
@@ -8101,8 +8101,8 @@ void torus_update_osm_vlarb(void *context, osm_physp_t *osm_phys_port,
 
 			guid = osm_node_get_node_guid(node);
 			OSM_LOG(log, OSM_LOG_INFO,
-				"Error: osm_switch (GUID 0x%04"PRIx64") "
-				"not in our fabric description\n",
+				"Note: osm_switch (GUID 0x%04"PRIx64") "
+				"not in torus fabric description\n",
 				cl_ntoh64(guid));
 			return;
 		}
@@ -8694,7 +8694,7 @@ osm_mtree_node_t *mcast_stree_branch(struct t_switch *sw, osm_switch_t *osm_sw,
 	if (osm_sw->priv != sw) {
 		OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
 			"ERR 4E3E: osm_sw (GUID 0x%04"PRIx64") "
-			"not in our fabric description\n",
+			"not in torus fabric description\n",
 			cl_ntoh64(osm_node_get_node_guid(osm_sw->p_node)));
 		goto out;
 	}
@@ -8864,7 +8864,7 @@ ib_api_status_t torus_mcast_stree(void *context, osm_mgrp_box_t *mgb)
 				id = osm_node_get_node_guid(osm_port->p_node);
 				OSM_LOG(&ctx->osm->log, OSM_LOG_ERROR,
 					"ERR 4E41: osm_port (GUID 0x%04"PRIx64") "
-					"not in our fabric description\n",
+					"not in torus fabric description\n",
 					cl_ntoh64(id));
 				continue;
 			}
@@ -9201,8 +9201,8 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 		if (!sport) {
 			guid = osm_node_get_node_guid(osm_sport->p_node);
 			OSM_LOG(log, OSM_LOG_INFO,
-				"Error: osm_sport (GUID 0x%04"PRIx64") "
-				"not in our fabric description\n",
+				"Note: osm_sport (GUID 0x%04"PRIx64") "
+				"not in torus fabric description\n",
 				cl_ntoh64(guid));
 			goto out;
 		}
@@ -9213,8 +9213,8 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 		if (!dport) {
 			guid = osm_node_get_node_guid(osm_dport->p_node);
 			OSM_LOG(log, OSM_LOG_INFO,
-				"Error: osm_dport (GUID 0x%04"PRIx64") "
-				"not in our fabric description\n",
+				"Note: osm_dport (GUID 0x%04"PRIx64") "
+				"not in torus fabric description\n",
 				cl_ntoh64(guid));
 			goto out;
 		}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
