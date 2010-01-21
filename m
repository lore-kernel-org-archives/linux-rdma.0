From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osmeventplugin: added couple of events to monitor
 SM
Date: Thu, 21 Jan 2010 18:04:10 +0200
Message-ID: <4B587AFA.9020102@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

I've added a couple of new events that allow event
plug-in to see what SM is doing, when it is sweeping
and when it updates dump files:

  OSM_EVENT_ID_L_SWEEP_STARTED,
  OSM_EVENT_ID_L_SWEEP_DONE,
  OSM_EVENT_ID_H_SWEEP_STARTED,
  OSM_EVENT_ID_H_SWEEP_DONE,
  OSM_EVENT_ID_REROUTE_DONE,
  OSM_EVENT_ID_ENTERING_STANDBY,
  OSM_EVENT_ID_SM_PORT_DOWN,
  OSM_EVENT_ID_SA_DB_DUMPED

The last event is reported when SA DB was actually dumped.
I'm thinking of similar optimization for guid2lid file - it
doesn't have to be dumped at the end of each heavy sweep,
as many heavy sweeps don't really happen because of nodes
appearing/disappearing.

Stay tuned... :)

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/opensm/osm_event_plugin.h   |   10 +++++++++-
 opensm/opensm/osm_state_mgr.c              |   19 ++++++++++++++++++-
 opensm/osmeventplugin/src/osmeventplugin.c |   24 ++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/opensm/include/opensm/osm_event_plugin.h b/opensm/include/opensm/osm_event_plugin.h
index 33d1920..f5a57d7 100644
--- a/opensm/include/opensm/osm_event_plugin.h
+++ b/opensm/include/opensm/osm_event_plugin.h
@@ -72,7 +72,15 @@ typedef enum {
 	OSM_EVENT_ID_PORT_SELECT,
 	OSM_EVENT_ID_TRAP,
 	OSM_EVENT_ID_SUBNET_UP,
-	OSM_EVENT_ID_MAX
+	OSM_EVENT_ID_MAX,
+	OSM_EVENT_ID_L_SWEEP_STARTED,
+	OSM_EVENT_ID_L_SWEEP_DONE,
+	OSM_EVENT_ID_H_SWEEP_STARTED,
+	OSM_EVENT_ID_H_SWEEP_DONE,
+	OSM_EVENT_ID_REROUTE_DONE,
+	OSM_EVENT_ID_ENTERING_STANDBY,
+	OSM_EVENT_ID_SM_PORT_DOWN,
+	OSM_EVENT_ID_SA_DB_DUMPED
 } osm_epi_event_id_t;

 typedef struct osm_epi_port_id {
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index e43463f..7e64f37 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1076,6 +1076,9 @@ static void do_sweep(osm_sm_t * sm)
 	    sm->p_subn->sm_state != IB_SMINFO_STATE_DISCOVERING)
 		return;

+	osm_opensm_report_event(sm->p_subn->p_osm,
+				OSM_EVENT_ID_L_SWEEP_STARTED, NULL);
+
 	if (sm->p_subn->coming_out_of_standby)
 		/*
 		 * Need to force re-write of sm_base_lid to all ports
@@ -1111,6 +1114,8 @@ static void do_sweep(osm_sm_t * sm)
 				osm_sa_db_file_dump(sm->p_subn->p_osm);
 			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
 					"LIGHT SWEEP COMPLETE");
+			osm_opensm_report_event(sm->p_subn->p_osm,
+				OSM_EVENT_ID_L_SWEEP_DONE, NULL);
 			return;
 		}
 	}
@@ -1151,6 +1156,8 @@ static void do_sweep(osm_sm_t * sm)
 		if (!sm->p_subn->subnet_initialization_error) {
 			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
 					"REROUTE COMPLETE");
+			osm_opensm_report_event(sm->p_subn->p_osm,
+				OSM_EVENT_ID_REROUTE_DONE, NULL);
 			return;
 		}
 	}
@@ -1158,6 +1165,9 @@ static void do_sweep(osm_sm_t * sm)
 	/* go to heavy sweep */
 repeat_discovery:

+	osm_opensm_report_event(sm->p_subn->p_osm,
+				OSM_EVENT_ID_H_SWEEP_STARTED, NULL);
+
 	/* First of all - unset all flags */
 	sm->p_subn->force_heavy_sweep = FALSE;
 	sm->p_subn->force_reroute = FALSE;
@@ -1185,6 +1195,8 @@ repeat_discovery:

 		/* Move to DISCOVERING state */
 		osm_sm_state_mgr_process(sm, OSM_SM_SIGNAL_DISCOVER);
+		osm_opensm_report_event(sm->p_subn->p_osm,
+					OSM_EVENT_ID_SM_PORT_DOWN, NULL);
 		return;
 	}

@@ -1205,6 +1217,8 @@ repeat_discovery:
 				"ENTERING STANDBY STATE");
 		/* notify master SM about us */
 		osm_send_trap144(sm, 0);
+		osm_opensm_report_event(sm->p_subn->p_osm,
+				OSM_EVENT_ID_ENTERING_STANDBY, NULL);
 		return;
 	}

@@ -1375,7 +1389,10 @@ repeat_discovery:

 		if (osm_log_is_active(sm->p_log, OSM_LOG_VERBOSE) ||
 		    sm->p_subn->opt.sa_db_dump)
-			osm_sa_db_file_dump(sm->p_subn->p_osm);
+			if (!osm_sa_db_file_dump(sm->p_subn->p_osm))
+				osm_opensm_report_event(sm->p_subn->p_osm,
+					OSM_EVENT_ID_SA_DB_DUMPED, NULL);
+
 	}

 	/*
diff --git a/opensm/osmeventplugin/src/osmeventplugin.c b/opensm/osmeventplugin/src/osmeventplugin.c
index b4d9ce9..5029be2 100644
--- a/opensm/osmeventplugin/src/osmeventplugin.c
+++ b/opensm/osmeventplugin/src/osmeventplugin.c
@@ -176,6 +176,30 @@ static void report(void *_log, osm_epi_event_id_t event_id, void *event_data)
 	case OSM_EVENT_ID_SUBNET_UP:
 		fprintf(log->log_file, "Subnet up reported\n");
 		break;
+	case OSM_EVENT_ID_L_SWEEP_STARTED:
+		fprintf(log->log_file, "Light sweep started\n");
+		break;
+	case OSM_EVENT_ID_L_SWEEP_DONE:
+		fprintf(log->log_file, "Light sweep completed\n");
+		break;
+	case OSM_EVENT_ID_H_SWEEP_STARTED:
+		fprintf(log->log_file, "Heavy sweep started\n");
+		break;
+	case OSM_EVENT_ID_H_SWEEP_DONE:
+		fprintf(log->log_file, "Heavy sweep completed\n");
+		break;
+	case OSM_EVENT_ID_REROUTE_DONE:
+		fprintf(log->log_file, "Re-route completed\n");
+		break;
+	case OSM_EVENT_ID_ENTERING_STANDBY:
+		fprintf(log->log_file, "Entering stand-by state\n");
+		break;
+	case OSM_EVENT_ID_SM_PORT_DOWN:
+		fprintf(log->log_file, "SM port is down\n");
+		break;
+	case OSM_EVENT_ID_SA_DB_DUMPED:
+		fprintf(log->log_file, "SA DB dump file updated\n");
+		break;
 	case OSM_EVENT_ID_MAX:
 	default:
 		osm_log(log->osmlog, OSM_LOG_ERROR,
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
