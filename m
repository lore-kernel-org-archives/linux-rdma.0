From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Change LFT event to be per block/per switch rather
 than just per switch
Date: Thu, 04 Apr 2013 07:10:29 -0400
Message-ID: <515D5FA5.1000809@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Eliminates expensive LFT comparison to determine changed blocks

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_event_plugin.h b/include/opensm/osm_event_plugin.h
index c9a904b..3ece2f0 100644
--- a/include/opensm/osm_event_plugin.h
+++ b/include/opensm/osm_event_plugin.h
@@ -39,6 +39,7 @@
 #include <iba/ib_types.h>
 #include <complib/cl_qlist.h>
 #include <opensm/osm_config.h>
+#include <opensm/osm_switch.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -87,6 +88,18 @@ typedef struct osm_epi_port_id {
 	char node_name[OSM_EPI_NODE_NAME_LEN];
 } osm_epi_port_id_t;
 
+typedef enum {
+	LFT_CHANGED_LFT_TOP = (1 << 0),
+	LFT_CHANGED_BLOCK = (1 << 1)
+} osm_epi_lft_change_flags_t;
+
+typedef struct osm_epi_lft_change_event {
+	osm_switch_t *p_sw;
+	osm_epi_lft_change_flags_t flags;
+	uint16_t lft_top;
+	uint32_t block_num;
+} osm_epi_lft_change_event_t;
+
 /** =========================================================================
  * Port error event
  * OSM_EVENT_ID_PORT_COUNTER
diff --git a/include/opensm/osm_madw.h b/include/opensm/osm_madw.h
index 5d78eaa..fd6ba7f 100644
--- a/include/opensm/osm_madw.h
+++ b/include/opensm/osm_madw.h
@@ -229,6 +229,7 @@ typedef struct osm_si_context {
 	ib_net64_t node_guid;
 	boolean_t set_method;
 	boolean_t light_sweep;
+	boolean_t lft_top_change;
 } osm_si_context_t;
 /*********/
 
diff --git a/include/opensm/osm_switch.h b/include/opensm/osm_switch.h
index 6e8a87e..41ac959 100644
--- a/include/opensm/osm_switch.h
+++ b/include/opensm/osm_switch.h
@@ -104,7 +104,6 @@ typedef struct osm_switch {
 	uint8_t *lft;
 	uint8_t *new_lft;
 	uint16_t lft_size;
-	unsigned lft_change;
 	osm_mcast_tbl_t mcast_tbl;
 	int32_t mft_block_num;
 	uint32_t mft_position;
diff --git a/opensm/osm_lin_fwd_rcv.c b/opensm/osm_lin_fwd_rcv.c
index f13b9a8..dd18c09 100644
--- a/opensm/osm_lin_fwd_rcv.c
+++ b/opensm/osm_lin_fwd_rcv.c
@@ -51,6 +51,8 @@
 #define FILE_ID OSM_FILE_LIN_FWD_RCV_C
 #include <opensm/osm_switch.h>
 #include <opensm/osm_sm.h>
+#include <opensm/osm_event_plugin.h>
+#include <opensm/osm_opensm.h>
 
 void osm_lft_rcv_process(IN void *context, IN void *data)
 {
@@ -62,6 +64,7 @@ void osm_lft_rcv_process(IN void *context, IN void *data)
 	osm_lft_context_t *p_lft_context;
 	uint8_t *p_block;
 	ib_net64_t node_guid;
+	osm_epi_lft_change_event_t lft_change;
 	ib_api_status_t status;
 
 	CL_ASSERT(sm);
@@ -89,7 +92,17 @@ void osm_lft_rcv_process(IN void *context, IN void *data)
 			"0x%" PRIx64 "\n", cl_ntoh64(node_guid));
 	} else {
 		status = osm_switch_set_lft_block(p_sw, p_block, block_num);
-		if (status != IB_SUCCESS) {
+		if (status == IB_SUCCESS) {
+			if (sm->p_subn->first_time_master_sweep == FALSE) {
+				lft_change.p_sw = p_sw;
+				lft_change.flags = LFT_CHANGED_BLOCK;
+				lft_change.lft_top = 0;
+				lft_change.block_num = block_num;
+				osm_opensm_report_event(sm->p_subn->p_osm,
+							OSM_EVENT_ID_LFT_CHANGE,
+							&lft_change);
+			}
+		} else {
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0402: "
 				"Setting forwarding table block failed (%s)"
 				", Switch 0x%" PRIx64 " %s\n",
diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
index fea0a69..135b174 100644
--- a/opensm/osm_mcast_mgr.c
+++ b/opensm/osm_mcast_mgr.c
@@ -1070,6 +1070,7 @@ static void mcast_mgr_set_mfttop(IN osm_sm_t * sm, IN osm_switch_t * p_sw)
 		context.si_context.light_sweep = FALSE;
 		context.si_context.node_guid = osm_node_get_node_guid(p_node);
 		context.si_context.set_method = TRUE;
+		context.si_context.lft_top_change = FALSE;
 
 		status = osm_req_set(sm, p_path, (uint8_t *) & si,
 				     sizeof(si), IB_MAD_ATTR_SWITCH_INFO,
diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index cb96f29..592f2de 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -552,6 +552,7 @@ static void ni_rcv_process_switch(IN osm_sm_t * sm, IN osm_node_t * p_node,
 	context.si_context.node_guid = osm_node_get_node_guid(p_node);
 	context.si_context.set_method = FALSE;
 	context.si_context.light_sweep = FALSE;
+	context.si_context.lft_top_change = FALSE;
 
 	/* Request a SwitchInfo attribute */
 	status = osm_req_get(sm, path, IB_MAD_ATTR_SWITCH_INFO,
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 8229b06..1b73834 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -138,6 +138,7 @@ static void state_mgr_get_sw_info(IN cl_map_item_t * p_object, IN void *context)
 	mad_context.si_context.node_guid = osm_node_get_node_guid(p_node);
 	mad_context.si_context.set_method = FALSE;
 	mad_context.si_context.light_sweep = TRUE;
+	mad_context.si_context.lft_top_change = FALSE;
 
 	status = osm_req_get(sm, p_dr_path, IB_MAD_ATTR_SWITCH_INFO, 0,
 			     OSM_MSG_LIGHT_SWEEP_FAIL, &mad_context);
diff --git a/opensm/osm_sw_info_rcv.c b/opensm/osm_sw_info_rcv.c
index 84e7fe0..4381cbe 100644
--- a/opensm/osm_sw_info_rcv.c
+++ b/opensm/osm_sw_info_rcv.c
@@ -288,6 +288,7 @@ static boolean_t si_rcv_process_existing(IN osm_sm_t * sm,
 	ib_switch_info_t *p_si;
 	osm_si_context_t *p_si_context;
 	ib_smp_t *p_smp;
+	osm_epi_lft_change_event_t lft_change;
 	boolean_t is_change_detected = FALSE;
 
 	OSM_LOG_ENTER(sm->p_log);
@@ -317,6 +318,17 @@ static boolean_t si_rcv_process_existing(IN osm_sm_t * sm,
 		}
 	}
 
+	if (sm->p_subn->first_time_master_sweep == FALSE &&
+	    p_si_context->set_method && p_si_context->lft_top_change) {
+		lft_change.p_sw = p_sw;
+		lft_change.flags = LFT_CHANGED_LFT_TOP;
+		lft_change.lft_top = cl_ntoh16(p_si->lin_top);
+		lft_change.block_num = 0;
+		osm_opensm_report_event(sm->p_subn->p_osm,
+					OSM_EVENT_ID_LFT_CHANGE,
+					&lft_change);
+	}
+
 	OSM_LOG_EXIT(sm->p_log);
 	return is_change_detected;
 }
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 7130ccf..12db434 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -918,8 +918,6 @@ static void ucast_mgr_set_fwd_top(IN cl_map_item_t * p_map_item,
 
 	p_path = osm_physp_get_dr_path_ptr(osm_node_get_physp_ptr(p_node, 0));
 
-	p_sw->lft_change = 0;
-
 	/*
 	   Set the top of the unicast forwarding table.
 	 */
@@ -928,8 +926,9 @@ static void ucast_mgr_set_fwd_top(IN cl_map_item_t * p_map_item,
 	if (lin_top != si.lin_top) {
 		set_swinfo_require = TRUE;
 		si.lin_top = lin_top;
-		p_sw->lft_change = 1;
-	}
+		context.si_context.lft_top_change = TRUE;
+	} else
+		context.si_context.lft_top_change = FALSE;
 
 	/* check to see if the change state bit is on. If it is - then we
 	   need to clear it. */
@@ -966,7 +965,7 @@ static void ucast_mgr_set_fwd_top(IN cl_map_item_t * p_map_item,
 }
 
 static int set_lft_block(IN osm_switch_t *p_sw, IN osm_ucast_mgr_t *p_mgr,
-			 IN uint16_t block_id_ho, IN unsigned last_block)
+			 IN uint16_t block_id_ho)
 {
 	uint8_t block[IB_SMP_DATA_SIZE];
 	osm_madw_context_t context;
@@ -996,8 +995,6 @@ static int set_lft_block(IN osm_switch_t *p_sw, IN osm_ucast_mgr_t *p_mgr,
 		     IB_SMP_DATA_SIZE)))
 		return 0;
 
-	p_sw->lft_change = 1;
-
 	OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 		"Writing FT block %u to switch 0x%" PRIx64 "\n", block_id_ho,
 		cl_ntoh64(context.lft_context.node_guid));
@@ -1008,11 +1005,6 @@ static int set_lft_block(IN osm_switch_t *p_sw, IN osm_ucast_mgr_t *p_mgr,
 			     cl_hton32(block_id_ho),
 			     CL_DISP_MSGID_NONE, &context);
 
-	if (!p_mgr->p_subn->first_time_master_sweep &&
-	    block_id_ho == last_block && p_sw->lft_change)
-		osm_opensm_report_event(p_mgr->p_subn->p_osm,
-					OSM_EVENT_ID_LFT_CHANGE, p_sw);
-
 	if (status != IB_SUCCESS) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR, "ERR 3A05: "
 			"Sending linear fwd. tbl. block failed (%s)\n",
@@ -1033,8 +1025,7 @@ static void ucast_mgr_pipeline_fwd_tbl(osm_ucast_mgr_t * p_mgr)
 	for (i = 0; i < max_block; i++)
 		for (item = cl_qmap_head(tbl); item != cl_qmap_end(tbl);
 		     item = cl_qmap_next(item))
-			set_lft_block((osm_switch_t *)item, p_mgr,
-				      i, max_block - 1);
+			set_lft_block((osm_switch_t *)item, p_mgr, i);
 }
 
 void osm_ucast_mgr_set_fwd_tables(osm_ucast_mgr_t * p_mgr)
diff --git a/osmeventplugin/src/osmeventplugin.c b/osmeventplugin/src/osmeventplugin.c
index fed2bac..fc27c5a 100644
--- a/osmeventplugin/src/osmeventplugin.c
+++ b/osmeventplugin/src/osmeventplugin.c
@@ -156,11 +156,13 @@ static void handle_trap_event(_log_events_t *log, ib_mad_notice_attr_t *p_ntc)
 
 /** =========================================================================
  */
-static void handle_lft_change_event(_log_events_t *log, osm_switch_t *p_sw)
+static void handle_lft_change_event(_log_events_t *log,
+				    osm_epi_lft_change_event_t *lft_change)
 {
 	fprintf(log->log_file,
-		"LFT changed for switch 0x%" PRIx64 "\n",
-		cl_ntoh64(osm_node_get_node_guid(p_sw->p_node)));
+		"LFT changed for switch 0x%" PRIx64 " flags 0x%x LFTTop %u block %d\n",
+		cl_ntoh64(osm_node_get_node_guid(lft_change->p_sw->p_node)),
+		lft_change->flags, lft_change->lft_top, lft_change->block_num);
 }
 
 /** =========================================================================
@@ -201,7 +203,7 @@ static void report(void *_log, osm_epi_event_id_t event_id, void *event_data)
 		fprintf(log->log_file, "SA DB dump file updated\n");
 		break;
 	case OSM_EVENT_ID_LFT_CHANGE:
-		handle_lft_change_event(log, (osm_switch_t *) event_data);
+		handle_lft_change_event(log, (osm_epi_lft_change_event_t *) event_data);
 		break;
 	case OSM_EVENT_ID_MAX:
 	default:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
