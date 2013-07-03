From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Add flags to OSM_EVENT_ID_UCAST_ROUTING_DONE
Date: Wed, 03 Jul 2013 13:05:41 -0400
Message-ID: <51D459E5.5020709@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


to be able to discern between ucast routing done when rerouting
versus heavy sweep.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_event_plugin.h b/include/opensm/osm_event_plugin.h
index 6b060e7..ca5a719 100644
--- a/include/opensm/osm_event_plugin.h
+++ b/include/opensm/osm_event_plugin.h
@@ -94,6 +94,12 @@ typedef enum {
 	LFT_CHANGED_BLOCK = (1 << 1)
 } osm_epi_lft_change_flags_t;
 
+typedef enum {
+	UCAST_ROUTING_NONE,
+	UCAST_ROUTING_HEAVY_SWEEP,
+	UCAST_ROUTING_REROUTE
+} osm_epi_ucast_routing_flags_t;
+
 typedef struct osm_epi_lft_change_event {
 	osm_switch_t *p_sw;
 	osm_epi_lft_change_flags_t flags;
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 1b73834..0cc8162 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1190,7 +1190,7 @@ static void do_sweep(osm_sm_t * sm)
 					"REROUTE COMPLETE");
 			osm_opensm_report_event(sm->p_subn->p_osm,
 						OSM_EVENT_ID_UCAST_ROUTING_DONE,
-						NULL);
+						(void *) UCAST_ROUTING_REROUTE);
 			return;
 		}
 	}
@@ -1387,7 +1387,8 @@ repeat_discovery:
 	OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
 			"SWITCHES CONFIGURED FOR UNICAST");
 	osm_opensm_report_event(sm->p_subn->p_osm,
-				OSM_EVENT_ID_UCAST_ROUTING_DONE, NULL);
+				OSM_EVENT_ID_UCAST_ROUTING_DONE,
+				(void *) UCAST_ROUTING_HEAVY_SWEEP);
 
 	if (!sm->p_subn->opt.disable_multicast) {
 		osm_mcast_mgr_process(sm, TRUE);
diff --git a/osmeventplugin/src/osmeventplugin.c b/osmeventplugin/src/osmeventplugin.c
index c5655fe..1eaf7ea 100644
--- a/osmeventplugin/src/osmeventplugin.c
+++ b/osmeventplugin/src/osmeventplugin.c
@@ -195,7 +195,7 @@ static void report(void *_log, osm_epi_event_id_t event_id, void *event_data)
 		fprintf(log->log_file, "Heavy sweep completed\n");
 		break;
 	case OSM_EVENT_ID_UCAST_ROUTING_DONE:
-		fprintf(log->log_file, "Unicast routing completed\n");
+		fprintf(log->log_file, "Unicast routing completed %d\n", event_data);
 		break;
 	case OSM_EVENT_ID_STATE_CHANGE:
 		fprintf(log->log_file, "SM state changed\n");
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
