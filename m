From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 12/13] opensm: Some cosmetic formatting changes
Date: Fri, 29 Apr 2011 09:28:03 -0400
Message-ID: <4DBABCE3.8020608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From ab2bd33678cbeaee545b43184e951732148e5e27 Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Fri, 29 Apr 2011 13:45:27 +0300
Subject: [PATCH] opensm: Some cosmetic formatting changes

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_multicast.c |    6 +++---
 opensm/osm_state_mgr.c |   14 ++++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/opensm/osm_multicast.c b/opensm/osm_multicast.c
index c539bb2..cde2589 100644
--- a/opensm/osm_multicast.c
+++ b/opensm/osm_multicast.c
@@ -85,7 +85,7 @@ void mgrp_delete(IN osm_mgrp_t * p_mgrp)
 		p_next_mcm_alias_guid =
 		    (osm_mcm_alias_guid_t *) cl_qmap_next(&p_mcm_alias_guid->map_item);
 		osm_mcm_alias_guid_delete(&p_mcm_alias_guid);
-        }
+	}
 
 	p_next_mcm_port =
 	    (osm_mcm_port_t *) cl_qmap_head(&p_mgrp->mcm_port_tbl);
@@ -214,7 +214,7 @@ static boolean_t is_qmap_empty_for_port(IN const cl_qmap_t * const p_map,
 	cl_map_item_t *item;
 	osm_mcm_alias_guid_t *mcm_alias_guid;
 
-        for (item = cl_qmap_head(p_map); item != cl_qmap_end(p_map);
+	for (item = cl_qmap_head(p_map); item != cl_qmap_end(p_map);
 	     item = cl_qmap_next(item)) {
 		mcm_alias_guid = (osm_mcm_alias_guid_t *) item;
 		if (mcm_alias_guid->p_base_mcm_port->port == port) {
@@ -380,7 +380,7 @@ void osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
 		OSM_LOG(log, OSM_LOG_DEBUG, "removing alias GUID 0x%" PRIx64 "\n",
 			cl_ntoh64(mcm_alias_guid->alias_guid));
 		cl_qmap_remove_item(&mgrp->mcm_alias_port_tbl,
-				    &mcm_alias_guid->map_item);		
+				    &mcm_alias_guid->map_item);
 		if (is_qmap_empty_for_port(&mgrp->mcm_alias_port_tbl,
 					   mcm_alias_guid->p_base_mcm_port->port)) { /* last alias in mcast group for this port */
 			OSM_LOG(log, OSM_LOG_DEBUG, "removing port 0x%" PRIx64 "\n",
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index dd308f2..131242d 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1113,7 +1113,8 @@ static void do_sweep(osm_sm_t * sm)
 			if (sm->p_subn->opt.sa_db_dump &&
 			    !osm_sa_db_file_dump(sm->p_subn->p_osm))
 				osm_opensm_report_event(sm->p_subn->p_osm,
-					OSM_EVENT_ID_SA_DB_DUMPED, NULL);
+							OSM_EVENT_ID_SA_DB_DUMPED,
+							NULL);
 			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
 					"LIGHT SWEEP COMPLETE");
 			return;
@@ -1162,7 +1163,8 @@ static void do_sweep(osm_sm_t * sm)
 			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
 					"REROUTE COMPLETE");
 			osm_opensm_report_event(sm->p_subn->p_osm,
-				OSM_EVENT_ID_UCAST_ROUTING_DONE, NULL);
+						OSM_EVENT_ID_UCAST_ROUTING_DONE,
+						NULL);
 			return;
 		}
 	}
@@ -1205,10 +1207,10 @@ repeat_discovery:
 		osm_drop_mgr_process(sm);
 
 		/* Move to DISCOVERING state */
-		 if (sm->p_subn->sm_state != IB_SMINFO_STATE_DISCOVERING)
+		if (sm->p_subn->sm_state != IB_SMINFO_STATE_DISCOVERING)
 			osm_sm_state_mgr_process(sm, OSM_SM_SIGNAL_DISCOVER);
 		osm_opensm_report_event(sm->p_subn->p_osm,
-				OSM_EVENT_ID_STATE_CHANGE, NULL);
+					OSM_EVENT_ID_STATE_CHANGE, NULL);
 		return;
 	}
 
@@ -1230,7 +1232,7 @@ repeat_discovery:
 		/* notify master SM about us */
 		osm_send_trap144(sm, 0);
 		osm_opensm_report_event(sm->p_subn->p_osm,
-				OSM_EVENT_ID_STATE_CHANGE, NULL);
+					OSM_EVENT_ID_STATE_CHANGE, NULL);
 		return;
 	}
 
@@ -1346,7 +1348,7 @@ repeat_discovery:
 	OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
 			"SWITCHES CONFIGURED FOR UNICAST");
 	osm_opensm_report_event(sm->p_subn->p_osm,
-			OSM_EVENT_ID_UCAST_ROUTING_DONE, NULL);
+				OSM_EVENT_ID_UCAST_ROUTING_DONE, NULL);
 
 	if (!sm->p_subn->opt.disable_multicast) {
 		osm_mcast_mgr_process(sm);
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
