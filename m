From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 opensm] Add support for LFT changed event
Date: Mon, 18 Mar 2013 08:41:37 -0400
Message-ID: <51470B81.6060701@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Determine LFT changes whenever LFT block or LFTTop changes.

Don't issue event on first time master sweep as use SUBNET UP event there.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v1:
Use lft_change flag rather than lft_epoch/lft_epoch_prev

diff --git a/include/opensm/osm_event_plugin.h b/include/opensm/osm_event_plugin.h
index 6a99ed9..c9a904b 100644
--- a/include/opensm/osm_event_plugin.h
+++ b/include/opensm/osm_event_plugin.h
@@ -77,6 +77,7 @@ typedef enum {
 	OSM_EVENT_ID_UCAST_ROUTING_DONE,
 	OSM_EVENT_ID_STATE_CHANGE,
 	OSM_EVENT_ID_SA_DB_DUMPED,
+	OSM_EVENT_ID_LFT_CHANGE,
 	OSM_EVENT_ID_MAX
 } osm_epi_event_id_t;
 
diff --git a/include/opensm/osm_switch.h b/include/opensm/osm_switch.h
index 41ac959..6e8a87e 100644
--- a/include/opensm/osm_switch.h
+++ b/include/opensm/osm_switch.h
@@ -104,6 +104,7 @@ typedef struct osm_switch {
 	uint8_t *lft;
 	uint8_t *new_lft;
 	uint16_t lft_size;
+	unsigned lft_change;
 	osm_mcast_tbl_t mcast_tbl;
 	int32_t mft_block_num;
 	uint32_t mft_position;
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index b4cf0f2..7130ccf 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -918,6 +918,8 @@ static void ucast_mgr_set_fwd_top(IN cl_map_item_t * p_map_item,
 
 	p_path = osm_physp_get_dr_path_ptr(osm_node_get_physp_ptr(p_node, 0));
 
+	p_sw->lft_change = 0;
+
 	/*
 	   Set the top of the unicast forwarding table.
 	 */
@@ -926,6 +928,7 @@ static void ucast_mgr_set_fwd_top(IN cl_map_item_t * p_map_item,
 	if (lin_top != si.lin_top) {
 		set_swinfo_require = TRUE;
 		si.lin_top = lin_top;
+		p_sw->lft_change = 1;
 	}
 
 	/* check to see if the change state bit is on. If it is - then we
@@ -963,7 +966,7 @@ static void ucast_mgr_set_fwd_top(IN cl_map_item_t * p_map_item,
 }
 
 static int set_lft_block(IN osm_switch_t *p_sw, IN osm_ucast_mgr_t *p_mgr,
-			 IN uint16_t block_id_ho)
+			 IN uint16_t block_id_ho, IN unsigned last_block)
 {
 	uint8_t block[IB_SMP_DATA_SIZE];
 	osm_madw_context_t context;
@@ -993,6 +996,8 @@ static int set_lft_block(IN osm_switch_t *p_sw, IN osm_ucast_mgr_t *p_mgr,
 		     IB_SMP_DATA_SIZE)))
 		return 0;
 
+	p_sw->lft_change = 1;
+
 	OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 		"Writing FT block %u to switch 0x%" PRIx64 "\n", block_id_ho,
 		cl_ntoh64(context.lft_context.node_guid));
@@ -1002,6 +1007,12 @@ static int set_lft_block(IN osm_switch_t *p_sw, IN osm_ucast_mgr_t *p_mgr,
 			     IB_SMP_DATA_SIZE, IB_MAD_ATTR_LIN_FWD_TBL,
 			     cl_hton32(block_id_ho),
 			     CL_DISP_MSGID_NONE, &context);
+
+	if (!p_mgr->p_subn->first_time_master_sweep &&
+	    block_id_ho == last_block && p_sw->lft_change)
+		osm_opensm_report_event(p_mgr->p_subn->p_osm,
+					OSM_EVENT_ID_LFT_CHANGE, p_sw);
+
 	if (status != IB_SUCCESS) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR, "ERR 3A05: "
 			"Sending linear fwd. tbl. block failed (%s)\n",
@@ -1022,7 +1033,8 @@ static void ucast_mgr_pipeline_fwd_tbl(osm_ucast_mgr_t * p_mgr)
 	for (i = 0; i < max_block; i++)
 		for (item = cl_qmap_head(tbl); item != cl_qmap_end(tbl);
 		     item = cl_qmap_next(item))
-			set_lft_block((osm_switch_t *)item, p_mgr, i);
+			set_lft_block((osm_switch_t *)item, p_mgr,
+				      i, max_block - 1);
 }
 
 void osm_ucast_mgr_set_fwd_tables(osm_ucast_mgr_t * p_mgr)
diff --git a/osmeventplugin/src/osmeventplugin.c b/osmeventplugin/src/osmeventplugin.c
index aaf7e80..fed2bac 100644
--- a/osmeventplugin/src/osmeventplugin.c
+++ b/osmeventplugin/src/osmeventplugin.c
@@ -156,6 +156,15 @@ static void handle_trap_event(_log_events_t *log, ib_mad_notice_attr_t *p_ntc)
 
 /** =========================================================================
  */
+static void handle_lft_change_event(_log_events_t *log, osm_switch_t *p_sw)
+{
+	fprintf(log->log_file,
+		"LFT changed for switch 0x%" PRIx64 "\n",
+		cl_ntoh64(osm_node_get_node_guid(p_sw->p_node)));
+}
+
+/** =========================================================================
+ */
 static void report(void *_log, osm_epi_event_id_t event_id, void *event_data)
 {
 	_log_events_t *log = (_log_events_t *) _log;
@@ -191,6 +200,9 @@ static void report(void *_log, osm_epi_event_id_t event_id, void *event_data)
 	case OSM_EVENT_ID_SA_DB_DUMPED:
 		fprintf(log->log_file, "SA DB dump file updated\n");
 		break;
+	case OSM_EVENT_ID_LFT_CHANGE:
+		handle_lft_change_event(log, (osm_switch_t *) event_data);
+		break;
 	case OSM_EVENT_ID_MAX:
 	default:
 		osm_log(log->osmlog, OSM_LOG_ERROR,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
