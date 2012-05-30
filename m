From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Add enum for FILE_ID for per module logging
Date: Wed, 30 May 2012 18:57:49 -0400
Message-ID: <4FC6A5ED.7030504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


An osm_file_ids_enum was added to the SM header and
a FILE_ID const definition to each source file.

This patch follows patch to add per module logging.

Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_sm.h b/include/opensm/osm_sm.h
index 4c7b120..a7b2556 100644
--- a/include/opensm/osm_sm.h
+++ b/include/opensm/osm_sm.h
@@ -90,6 +90,109 @@ BEGIN_C_DECLS
 *	Steve King, Intel
 *
 *********/
+
+/****d* OpenSM: Subnet/osm_file_ids_enum
+* NAME
+*	osm_file_ids_enum
+*
+* DESCRIPTION
+*	Enumerates all FILE_IDs used for logging support.
+*
+* SYNOPSIS
+*/
+typedef enum _osm_file_ids_enum {
+	OSM_FILE_MAIN_C = 0,
+	OSM_FILE_CONSOLE_C,
+	OSM_FILE_CONSOLE_IO_C,
+	OSM_FILE_DB_FILES_C,
+	OSM_FILE_DB_PACK_C,
+	OSM_FILE_DROP_MGR_C,
+	OSM_FILE_DUMP_C,
+	OSM_FILE_EVENT_PLUGIN_C,
+	OSM_FILE_GUID_INFO_RCV_C,
+	OSM_FILE_GUID_MGR_C,
+	OSM_FILE_HELPER_C,
+	OSM_FILE_INFORM_C,
+	OSM_FILE_LID_MGR_C,
+	OSM_FILE_LIN_FWD_RCV_C,
+	OSM_FILE_LINK_MGR_C,
+	OSM_FILE_LOG_C,
+	OSM_FILE_MAD_POOL_C,
+	OSM_FILE_MCAST_FWD_RCV_C,
+	OSM_FILE_MCAST_MGR_C,
+	OSM_FILE_MCAST_TBL_C,
+	OSM_FILE_MCM_PORT_C,
+	OSM_FILE_MESH_C,
+	OSM_FILE_MLNX_EXT_PORT_INFO_RCV_C,
+	OSM_FILE_MTREE_C,
+	OSM_FILE_MULTICAST_C,
+	OSM_FILE_NODE_C,
+	OSM_FILE_NODE_DESC_RCV_C,
+	OSM_FILE_NODE_INFO_RCV_C,
+	OSM_FILE_OPENSM_C,
+	OSM_FILE_PERFMGR_C,
+	OSM_FILE_PERFMGR_DB_C,
+	OSM_FILE_PKEY_C,
+	OSM_FILE_PKEY_MGR_C,
+	OSM_FILE_PKEY_RCV_C,
+	OSM_FILE_PORT_C,
+	OSM_FILE_PORT_INFO_RCV_C,
+	OSM_FILE_PRTN_C,
+	OSM_FILE_PRTN_CONFIG_C,
+	OSM_FILE_QOS_C,
+	OSM_FILE_QOS_PARSER_L_L,
+	OSM_FILE_QOS_PARSER_Y_Y,
+	OSM_FILE_QOS_POLICY_C,
+	OSM_FILE_REMOTE_SM_C,
+	OSM_FILE_REQ_C,
+	OSM_FILE_RESP_C,
+	OSM_FILE_ROUTER_C,
+	OSM_FILE_SA_C,
+	OSM_FILE_SA_CLASS_PORT_INFO_C,
+	OSM_FILE_SA_GUIDINFO_RECORD_C,
+	OSM_FILE_SA_INFORMINFO_C,
+	OSM_FILE_SA_LFT_RECORD_C,
+	OSM_FILE_SA_LINK_RECORD_C,
+	OSM_FILE_SA_MAD_CTRL_C,
+	OSM_FILE_SA_MCMEMBER_RECORD_C,
+	OSM_FILE_SA_MFT_RECORD_C,
+	OSM_FILE_SA_MULTIPATH_RECORD_C,
+	OSM_FILE_SA_NODE_RECORD_C,
+	OSM_FILE_SA_PATH_RECORD_C,
+	OSM_FILE_SA_PKEY_RECORD_C,
+	OSM_FILE_SA_PORTINFO_RECORD_C,
+	OSM_FILE_SA_SERVICE_RECORD_C,
+	OSM_FILE_SA_SLVL_RECORD_C,
+	OSM_FILE_SA_SMINFO_RECORD_C,
+	OSM_FILE_SA_SW_INFO_RECORD_C,
+	OSM_FILE_SA_VLARB_RECORD_C,
+	OSM_FILE_SERVICE_C,
+	OSM_FILE_SLVL_MAP_RCV_C,
+	OSM_FILE_SM_C,
+	OSM_FILE_SMINFO_RCV_C,
+	OSM_FILE_SM_MAD_CTRL_C,
+	OSM_FILE_SM_STATE_MGR_C,
+	OSM_FILE_STATE_MGR_C,
+	OSM_FILE_SUBNET_C,
+	OSM_FILE_SW_INFO_RCV_C,
+	OSM_FILE_SWITCH_C,
+	OSM_FILE_TORUS_C,
+	OSM_FILE_TRAP_RCV_C,
+	OSM_FILE_UCAST_CACHE_C,
+	OSM_FILE_UCAST_DNUP_C,
+	OSM_FILE_UCAST_FILE_C,
+	OSM_FILE_UCAST_FTREE_C,
+	OSM_FILE_UCAST_LASH_C,
+	OSM_FILE_UCAST_MGR_C,
+	OSM_FILE_UCAST_UPDN_C,
+	OSM_FILE_VENDOR_IBUMAD_C,
+	OSM_FILE_VL15INTF_C,
+	OSM_FILE_VL_ARB_RCV_C,
+	OSM_FILE_ST_C,
+	OSM_FILE_UCAST_DFSSSP_C,
+} osm_file_ids_enum;
+/***********/
+
 /****s* OpenSM: SM/osm_sm_t
 * NAME
 *  osm_sm_t
diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index b0be770..e35dcce 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -65,9 +65,10 @@
 #include <opensm/osm_log.h>
 #include <opensm/osm_mad_pool.h>
 #include <opensm/osm_helper.h>
+#include <opensm/osm_sm.h>
 #include <vendor/osm_vendor_api.h>
 
-#define FILE_ID 84
+#define FILE_ID OSM_FILE_VENDOR_IBUMAD_C
 
 /****s* OpenSM: Vendor UMAD/osm_umad_bind_info_t
  * NAME
diff --git a/opensm/main.c b/opensm/main.c
index 102237e..9957fc3 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -62,7 +62,7 @@
 #include <opensm/osm_console_io.h>
 #include <opensm/osm_perfmgr.h>
 
-#define FILE_ID 0
+#define FILE_ID OSM_FILE_MAIN_C
 
 volatile unsigned int osm_exit_flag = 0;
 
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 1a2e845..d894116 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -57,7 +57,7 @@
 #include <opensm/osm_perfmgr.h>
 #include <opensm/osm_subnet.h>
 
-#define FILE_ID 1
+#define FILE_ID OSM_FILE_CONSOLE_c
 
 extern void osm_update_node_desc(IN osm_opensm_t *osm);
 
diff --git a/opensm/osm_console_io.c b/opensm/osm_console_io.c
index c02d7ba..be8c02c 100644
--- a/opensm/osm_console_io.c
+++ b/opensm/osm_console_io.c
@@ -58,7 +58,7 @@
 #include <opensm/osm_console_io.h>
 #include <stdlib.h>
 
-#define FILE_ID 2
+#define FILE_ID OSM_FILE_CONSOLE_IO_C
 
 static int is_local(char *str)
 {
diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
index ba37b4e..4a2d71c 100644
--- a/opensm/osm_db_files.c
+++ b/opensm/osm_db_files.c
@@ -48,8 +48,9 @@
 #include <string.h>
 #include <opensm/st.h>
 #include <opensm/osm_db.h>
+#include <opensm/osm_sm.h>
 
-#define FILE_ID 3
+#define FILE_ID OSM_FILE_DB_FILES_C
 
 /****d* Database/OSM_DB_MAX_LINE_LEN
  * NAME
diff --git a/opensm/osm_db_pack.c b/opensm/osm_db_pack.c
index e3f2299..0f52f5f 100644
--- a/opensm/osm_db_pack.c
+++ b/opensm/osm_db_pack.c
@@ -41,7 +41,7 @@
 #include <complib/cl_debug.h>
 #include <opensm/osm_db_pack.h>
 
-#define FILE_ID 4
+#define FILE_ID OSM_FILE_DB_PACK_C
 
 static inline void pack_guid(uint64_t guid, char *p_guid_str)
 {
diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index 02d6ab1..645a17d 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -63,7 +63,7 @@
 #include <opensm/osm_inform.h>
 #include <opensm/osm_ucast_mgr.h>
 
-#define FILE_ID 5
+#define FILE_ID OSM_FILE_DROP_MGR_C
 
 static void drop_mgr_remove_router(osm_sm_t * sm, IN const ib_net64_t portguid)
 {
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index 2ba256f..7aa2ecd 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -58,7 +58,7 @@
 #include <opensm/osm_msgdef.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 6
+#define FILE_ID OSM_FILE_DUMP_C
 
 static void dump_ucast_path_distribution(cl_map_item_t * item, FILE * file,
 					 void *cxt)
diff --git a/opensm/osm_event_plugin.c b/opensm/osm_event_plugin.c
index 2a1ac7f..4a2402c 100644
--- a/opensm/osm_event_plugin.c
+++ b/opensm/osm_event_plugin.c
@@ -52,7 +52,7 @@
 #include <opensm/osm_event_plugin.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 7
+#define FILE_ID OSM_FILE_EVENT_PLUGIN_C
 
 #if defined(PATH_MAX)
 #define OSM_PATH_MAX	(PATH_MAX + 1)
diff --git a/opensm/osm_guid_info_rcv.c b/opensm/osm_guid_info_rcv.c
index 184599d..ebabeb0 100644
--- a/opensm/osm_guid_info_rcv.c
+++ b/opensm/osm_guid_info_rcv.c
@@ -61,7 +61,7 @@
 #include <opensm/osm_remote_sm.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 8
+#define FILE_ID OSM_FILE_GUID_INFO_RCV_C
 
 void osm_gi_rcv_process(IN void *context, IN void *data)
 {
diff --git a/opensm/osm_guid_mgr.c b/opensm/osm_guid_mgr.c
index cbf48a2..b52bb9f 100644
--- a/opensm/osm_guid_mgr.c
+++ b/opensm/osm_guid_mgr.c
@@ -53,7 +53,7 @@
 #include <opensm/osm_guid.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 9
+#define FILE_ID OSM_FILE_GUID_MGR_C
 
 static void guidinfo_set(IN osm_sa_t *sa, IN osm_port_t *p_port,
 			 IN uint8_t block_num)
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index 1ef4f6a..2ca3e81 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -53,7 +53,7 @@
 #include <opensm/osm_helper.h>
 #include <opensm/osm_log.h>
 
-#define FILE_ID 10
+#define FILE_ID OSM_FILE_HELPER_C
 
 #define LINE_LENGTH 256
 
diff --git a/opensm/osm_inform.c b/opensm/osm_inform.c
index 1cd4c48..a9190ed 100644
--- a/opensm/osm_inform.c
+++ b/opensm/osm_inform.c
@@ -54,7 +54,7 @@
 #include <opensm/osm_sa.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 11
+#define FILE_ID OSM_FILE_INFORM_C
 
 typedef struct osm_infr_match_ctxt {
 	cl_list_t *p_remove_infr_list;
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index c82c8a2..addf449 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -95,7 +95,7 @@
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_db_pack.h>
 
-#define FILE_ID 12
+#define FILE_ID OSM_FILE_LID_MGR_C
 
 /**********************************************************************
   lid range item of qlist
diff --git a/opensm/osm_lin_fwd_rcv.c b/opensm/osm_lin_fwd_rcv.c
index 57a34cf..4a54678 100644
--- a/opensm/osm_lin_fwd_rcv.c
+++ b/opensm/osm_lin_fwd_rcv.c
@@ -50,7 +50,7 @@
 #include <opensm/osm_switch.h>
 #include <opensm/osm_sm.h>
 
-#define FILE_ID 13
+#define FILE_ID OSM_FILE_LIN_FWD_RCV_C
 
 void osm_lft_rcv_process(IN void *context, IN void *data)
 {
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index 9de1dab..2f71b08 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -55,7 +55,7 @@
 #include <opensm/osm_msgdef.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 14
+#define FILE_ID OSM_FILE_LINK_MGR_C
 
 static uint8_t link_mgr_get_smsl(IN osm_sm_t * sm, IN osm_physp_t * p_physp)
 {
diff --git a/opensm/osm_log.c b/opensm/osm_log.c
index 54a2315..fd00fd9 100644
--- a/opensm/osm_log.c
+++ b/opensm/osm_log.c
@@ -45,6 +45,7 @@
 #endif				/* HAVE_CONFIG_H */
 
 #include <opensm/osm_log.h>
+#include <opensm/osm_sm.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <stdarg.h>
@@ -53,7 +54,7 @@
 #include <sys/stat.h>
 #include <errno.h>
 
-#define FILE_ID 15
+#define FILE_ID OSM_FILE_LOG_C
 
 static int log_exit_count = 0;
 
@@ -387,7 +388,7 @@ void osm_log_msg_box_v2(IN osm_log_t * log, osm_log_level_t level,
 	char buf[MSG_BOX_LENGTH + 1];
 	int i, n;
 
-	if (!osm_log_is_active(log, level))
+	if (!osm_log_is_active_v2(log, level, FILE_ID))
 		return;
 
 	n = (MSG_BOX_LENGTH - strlen(msg)) / 2 - 1;
diff --git a/opensm/osm_mad_pool.c b/opensm/osm_mad_pool.c
index 9d719d4..fadf862 100644
--- a/opensm/osm_mad_pool.c
+++ b/opensm/osm_mad_pool.c
@@ -50,7 +50,7 @@
 #include <opensm/osm_madw.h>
 #include <vendor/osm_vendor_api.h>
 
-#define FILE_ID 16
+#define FILE_ID OSM_FILE_MAD_POOL_C
 
 void osm_mad_pool_construct(IN osm_mad_pool_t * p_pool)
 {
diff --git a/opensm/osm_mcast_fwd_rcv.c b/opensm/osm_mcast_fwd_rcv.c
index ac8f6b9..e6df3d6 100644
--- a/opensm/osm_mcast_fwd_rcv.c
+++ b/opensm/osm_mcast_fwd_rcv.c
@@ -56,7 +56,7 @@
 #include <opensm/osm_subnet.h>
 #include <opensm/osm_sm.h>
 
-#define FILE_ID 17
+#define FILE_ID OSM_FILE_MCAST_FWD_RCV_C
 
 void osm_mft_rcv_process(IN void *context, IN void *data)
 {
diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
index b30e839..ce9c2fe 100644
--- a/opensm/osm_mcast_mgr.c
+++ b/opensm/osm_mcast_mgr.c
@@ -58,7 +58,7 @@
 #include <opensm/osm_helper.h>
 #include <opensm/osm_msgdef.h>
 
-#define FILE_ID 18
+#define FILE_ID OSM_FILE_MCAST_MGR_C
 
 typedef struct osm_mcast_work_obj {
 	cl_list_item_t list_item;
diff --git a/opensm/osm_mcast_tbl.c b/opensm/osm_mcast_tbl.c
index a8fbce7..0ea0d1f 100644
--- a/opensm/osm_mcast_tbl.c
+++ b/opensm/osm_mcast_tbl.c
@@ -51,7 +51,7 @@
 #include <iba/ib_types.h>
 #include <opensm/osm_mcast_tbl.h>
 
-#define FILE_ID 19
+#define FILE_ID OSM_FILE_MCAST_TBL_C
 
 void osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl, IN uint8_t num_ports,
 			IN uint16_t capacity)
diff --git a/opensm/osm_mcm_port.c b/opensm/osm_mcm_port.c
index b31ffc6..23bc3b7 100644
--- a/opensm/osm_mcm_port.c
+++ b/opensm/osm_mcm_port.c
@@ -49,7 +49,7 @@
 #include <opensm/osm_mcm_port.h>
 #include <opensm/osm_multicast.h>
 
-#define FILE_ID 20
+#define FILE_ID OSM_FILE_MCM_PORT_C
 
 osm_mcm_port_t *osm_mcm_port_new(IN osm_port_t *port, IN osm_mgrp_t *mgrp)
 {
diff --git a/opensm/osm_mesh.c b/opensm/osm_mesh.c
index 54e8e92..472306c 100644
--- a/opensm/osm_mesh.c
+++ b/opensm/osm_mesh.c
@@ -49,7 +49,7 @@
 #include <opensm/osm_mesh.h>
 #include <opensm/osm_ucast_lash.h>
 
-#define FILE_ID 21
+#define FILE_ID OSM_FILE_MESH_C
 
 #define MAX_DEGREE	(8)
 #define MAX_DIMENSION	(8)
diff --git a/opensm/osm_mlnx_ext_port_info_rcv.c b/opensm/osm_mlnx_ext_port_info_rcv.c
index 985226a..bc0b212 100644
--- a/opensm/osm_mlnx_ext_port_info_rcv.c
+++ b/opensm/osm_mlnx_ext_port_info_rcv.c
@@ -58,7 +58,7 @@
 #include <opensm/osm_helper.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 22
+#define FILE_ID OSM_FILE_MLNX_EXT_PORT_INFO_RCV_C
 
 void osm_mlnx_epi_rcv_process(IN void *context, IN void *data)
 {
diff --git a/opensm/osm_mtree.c b/opensm/osm_mtree.c
index 7b67415..aa970b0 100644
--- a/opensm/osm_mtree.c
+++ b/opensm/osm_mtree.c
@@ -47,7 +47,7 @@
 #include <complib/cl_debug.h>
 #include <opensm/osm_mtree.h>
 
-#define FILE_ID 23
+#define FILE_ID OSM_FILE_MTREE_C
 
 osm_mtree_node_t *osm_mtree_node_new(IN const osm_switch_t * p_sw)
 {
diff --git a/opensm/osm_multicast.c b/opensm/osm_multicast.c
index e13d87f..11dfba3 100644
--- a/opensm/osm_multicast.c
+++ b/opensm/osm_multicast.c
@@ -51,7 +51,7 @@
 #include <opensm/osm_inform.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 24
+#define FILE_ID OSM_FILE_MULTICAST_C
 
 static osm_mgrp_box_t *mgrp_box_new(uint16_t mlid)
 {
diff --git a/opensm/osm_node.c b/opensm/osm_node.c
index 07d87a6..74e94c7 100644
--- a/opensm/osm_node.c
+++ b/opensm/osm_node.c
@@ -49,7 +49,7 @@
 #include <opensm/osm_node.h>
 #include <opensm/osm_madw.h>
 
-#define FILE_ID 25
+#define FILE_ID OSM_FILE_NODE_C
 
 void osm_node_init_physp(IN osm_node_t * p_node, uint8_t port_num,
 			 IN const osm_madw_t * p_madw)
diff --git a/opensm/osm_node_desc_rcv.c b/opensm/osm_node_desc_rcv.c
index 4fc65e1..f7e7bfc 100644
--- a/opensm/osm_node_desc_rcv.c
+++ b/opensm/osm_node_desc_rcv.c
@@ -55,7 +55,7 @@
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_subnet.h>
 
-#define FILE_ID 26
+#define FILE_ID OSM_FILE_NODE_DESC_RCV_C
 
 static void nd_rcv_process_nd(IN osm_sm_t * sm, IN osm_node_t * p_node,
 			      IN const ib_node_desc_t * p_nd)
diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index 989da10..5cdf377 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -62,7 +62,7 @@
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_ucast_mgr.h>
 
-#define FILE_ID 27
+#define FILE_ID OSM_FILE_NODE_INFO_RCV_C
 
 static void report_duplicated_guid(IN osm_sm_t * sm, osm_physp_t * p_physp,
 				   osm_node_t * p_neighbor_node,
diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
index 3e5d014..46f52ff 100644
--- a/opensm/osm_opensm.c
+++ b/opensm/osm_opensm.c
@@ -60,7 +60,7 @@
 #include <opensm/osm_vl15intf.h>
 #include <opensm/osm_event_plugin.h>
 
-#define FILE_ID 28
+#define FILE_ID OSM_FILE_OPENSM_C
 
 struct routing_engine_module {
 	const char *name;
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index ef07b6a..01dad70 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -66,7 +66,7 @@
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_helper.h>
 
-#define FILE_ID 29
+#define FILE_ID OSM_FILE_PERFMGR_C
 
 #define PERFMGR_INITIAL_TID_VALUE 0xcafe
 
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index e23a1c1..d2ac822 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -49,7 +49,7 @@
 #include <opensm/osm_perfmgr.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 30
+#define FILE_ID OSM_FILE_PERFMGR_DB_C
 
 static void free_node(db_node_t * node);
 
diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index a7897d9..6a1c353 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -53,8 +53,9 @@
 #include <opensm/osm_node.h>
 #include <opensm/osm_switch.h>
 #include <opensm/osm_helper.h>
+#include <opensm/osm_sm.h>
 
-#define FILE_ID 31
+#define FILE_ID OSM_FILE_PKEY_C
 
 void osm_pkey_tbl_construct(IN osm_pkey_tbl_t * p_pkey_tbl)
 {
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index d238a3a..11c4c93 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -53,7 +53,7 @@
 #include <opensm/osm_partition.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 32
+#define FILE_ID OSM_FILE_PKEY_MGR_C
 
 /*
   The max number of pkeys/pkey blocks for a physical port is located
diff --git a/opensm/osm_pkey_rcv.c b/opensm/osm_pkey_rcv.c
index 4037e85..08b5ba5 100644
--- a/opensm/osm_pkey_rcv.c
+++ b/opensm/osm_pkey_rcv.c
@@ -48,7 +48,7 @@
 #include <opensm/osm_helper.h>
 #include <opensm/osm_sm.h>
 
-#define FILE_ID 33
+#define FILE_ID OSM_FILE_PKEY_RCV_C
 
 /*
  * WE ONLY RECEIVE GET or SET responses
diff --git a/opensm/osm_port.c b/opensm/osm_port.c
index d95819c..c5aa14d 100644
--- a/opensm/osm_port.c
+++ b/opensm/osm_port.c
@@ -52,8 +52,9 @@
 #include <opensm/osm_node.h>
 #include <opensm/osm_madw.h>
 #include <opensm/osm_switch.h>
+#include <opensm/osm_sm.h>
 
-#define FILE_ID 34
+#define FILE_ID OSM_FILE_PORT_C
 
 void osm_physp_construct(IN osm_physp_t * p_physp)
 {
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index b794f21..daa5a1a 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -64,7 +64,7 @@
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_ucast_mgr.h>
 
-#define FILE_ID 35
+#define FILE_ID OSM_FILE_PORT_INFO_RCV_C
 
 static void pi_rcv_check_and_fix_lid(osm_log_t * log, ib_port_info_t * pi,
 				     osm_physp_t * p)
diff --git a/opensm/osm_prtn.c b/opensm/osm_prtn.c
index 450a3f6..903859d 100644
--- a/opensm/osm_prtn.c
+++ b/opensm/osm_prtn.c
@@ -57,7 +57,7 @@
 #include <arpa/inet.h>
 #include <errno.h>
 
-#define FILE_ID 36
+#define FILE_ID OSM_FILE_PRTN_C
 
 extern int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 				      const char *file_name);
diff --git a/opensm/osm_prtn_config.c b/opensm/osm_prtn_config.c
index 52d53fc..fc22f33 100644
--- a/opensm/osm_prtn_config.c
+++ b/opensm/osm_prtn_config.c
@@ -54,7 +54,7 @@
 #include <opensm/osm_log.h>
 #include <arpa/inet.h>
 
-#define FILE_ID 37
+#define FILE_ID OSM_FILE_PRTN_CONFIG_C
 
 typedef enum {
 	LIMITED,
diff --git a/opensm/osm_qos.c b/opensm/osm_qos.c
index 40b18e2..8e8e21c 100644
--- a/opensm/osm_qos.c
+++ b/opensm/osm_qos.c
@@ -51,7 +51,7 @@
 #include <opensm/osm_subnet.h>
 #include <opensm/osm_qos_policy.h>
 
-#define FILE_ID 38
+#define FILE_ID OSM_FILE_QOS_C
 
 struct qos_config {
 	uint8_t max_vls;
diff --git a/opensm/osm_qos_parser_l.l b/opensm/osm_qos_parser_l.l
index f6a3986..21f7637 100644
--- a/opensm/osm_qos_parser_l.l
+++ b/opensm/osm_qos_parser_l.l
@@ -48,7 +48,7 @@
 #include <opensm/osm_qos_policy.h>
 #include "osm_qos_parser_y.h"
 
-#define FILE_ID 39
+#define FILE_ID OSM_FILE_QOS_PARSER_L_L
 
 #define HANDLE_IF_IN_DESCRIPTION   if (in_description) { yylval = strdup(yytext); return TK_TEXT; }
 
diff --git a/opensm/osm_qos_parser_y.y b/opensm/osm_qos_parser_y.y
index b083256..06d15e1 100644
--- a/opensm/osm_qos_parser_y.y
+++ b/opensm/osm_qos_parser_y.y
@@ -56,7 +56,7 @@
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_qos_policy.h>
 
-#define FILE_ID 40
+#define FILE_ID OSM_FILE_QOS_PARSER_Y_Y
 
 #define OSM_QOS_POLICY_MAX_LINE_LEN         1024*10
 #define OSM_QOS_POLICY_SL2VL_TABLE_LEN      IB_MAX_NUM_VLS
diff --git a/opensm/osm_qos_policy.c b/opensm/osm_qos_policy.c
index 18a776c..d0f036d 100644
--- a/opensm/osm_qos_policy.c
+++ b/opensm/osm_qos_policy.c
@@ -56,7 +56,7 @@
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_qos_policy.h>
 
-#define FILE_ID 41
+#define FILE_ID OSM_FILE_QOS_POLICY_C
 
 extern osm_qos_level_t __default_simple_qos_level;
 
diff --git a/opensm/osm_remote_sm.c b/opensm/osm_remote_sm.c
index 85033e5..251f1ae 100644
--- a/opensm/osm_remote_sm.c
+++ b/opensm/osm_remote_sm.c
@@ -47,7 +47,7 @@
 #include <string.h>
 #include <opensm/osm_remote_sm.h>
 
-#define FILE_ID 42
+#define FILE_ID OSM_FILE_REMOTE_SM_C
 
 void osm_remote_sm_construct(IN osm_remote_sm_t * p_sm)
 {
diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index 43928d1..b95430d 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -57,7 +57,7 @@
 #include <opensm/osm_msgdef.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 43
+#define FILE_ID OSM_FILE_REQ_C
 
 /**********************************************************************
   The plock MAY or MAY NOT be held before calling this function.
diff --git a/opensm/osm_resp.c b/opensm/osm_resp.c
index 5a72d05..1f2e5d2 100644
--- a/opensm/osm_resp.c
+++ b/opensm/osm_resp.c
@@ -56,7 +56,7 @@
 #include <opensm/osm_msgdef.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 44
+#define FILE_ID OSM_FILE_RESP_C
 
 static void resp_make_resp_smp(IN osm_sm_t * sm, IN const ib_smp_t * p_src_smp,
 			       IN ib_net16_t status,
diff --git a/opensm/osm_router.c b/opensm/osm_router.c
index 2f48bd1..b27c93e 100644
--- a/opensm/osm_router.c
+++ b/opensm/osm_router.c
@@ -49,7 +49,7 @@
 #include <iba/ib_types.h>
 #include <opensm/osm_router.h>
 
-#define FILE_ID 45
+#define FILE_ID OSM_FILE_ROUTER_C
 
 void osm_router_delete(IN OUT osm_router_t ** pp_rtr)
 {
diff --git a/opensm/osm_sa.c b/opensm/osm_sa.c
index 9a08903..01333b4 100644
--- a/opensm/osm_sa.c
+++ b/opensm/osm_sa.c
@@ -69,7 +69,7 @@
 #include <opensm/osm_helper.h>
 #include <vendor/osm_vendor_api.h>
 
-#define FILE_ID 46
+#define FILE_ID OSM_FILE_SA_C
 
 #define  OSM_SA_INITIAL_TID_VALUE 0xabc
 
diff --git a/opensm/osm_sa_class_port_info.c b/opensm/osm_sa_class_port_info.c
index 9cc9e78..79eccee 100644
--- a/opensm/osm_sa_class_port_info.c
+++ b/opensm/osm_sa_class_port_info.c
@@ -54,7 +54,7 @@
 #include <opensm/osm_helper.h>
 #include <opensm/osm_sa.h>
 
-#define FILE_ID 47
+#define FILE_ID OSM_FILE_SA_CLASS_PORT_INFO_C
 
 #define MAX_MSECS_TO_RTV 24
 /* Precalculated table in msec (index is related to encoded value) */
diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index 6c57ad4..9c1fabb 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -58,7 +58,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-#define FILE_ID 48
+#define FILE_ID OSM_FILE_SA_GUIDINFO_RECORD_C
 
 #define MOD_GIR_COMP_MASK (IB_GIR_COMPMASK_LID | IB_GIR_COMPMASK_BLOCKNUM)
 
diff --git a/opensm/osm_sa_informinfo.c b/opensm/osm_sa_informinfo.c
index 2f87fae..4801465 100644
--- a/opensm/osm_sa_informinfo.c
+++ b/opensm/osm_sa_informinfo.c
@@ -61,7 +61,7 @@
 #include <opensm/osm_inform.h>
 #include <opensm/osm_pkey.h>
 
-#define FILE_ID 49
+#define FILE_ID OSM_FILE_SA_INFORMINFO_C
 
 typedef struct osm_iir_item {
 	cl_list_item_t list_item;
diff --git a/opensm/osm_sa_lft_record.c b/opensm/osm_sa_lft_record.c
index c7d4f49..9748fd4 100644
--- a/opensm/osm_sa_lft_record.c
+++ b/opensm/osm_sa_lft_record.c
@@ -54,7 +54,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-#define FILE_ID 50
+#define FILE_ID OSM_FILE_SA_LFT_RECORD_C
 
 typedef struct osm_lftr_item {
 	cl_list_item_t list_item;
diff --git a/opensm/osm_sa_link_record.c b/opensm/osm_sa_link_record.c
index 524bb66..b91d0bc 100644
--- a/opensm/osm_sa_link_record.c
+++ b/opensm/osm_sa_link_record.c
@@ -55,7 +55,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-#define FILE_ID 51
+#define FILE_ID OSM_FILE_SA_LINK_RECORD_C
 
 typedef struct osm_lr_item {
 	cl_list_item_t list_item;
diff --git a/opensm/osm_sa_mad_ctrl.c b/opensm/osm_sa_mad_ctrl.c
index b1bf661..20c18ef 100644
--- a/opensm/osm_sa_mad_ctrl.c
+++ b/opensm/osm_sa_mad_ctrl.c
@@ -53,7 +53,7 @@
 #include <opensm/osm_helper.h>
 #include <opensm/osm_sa.h>
 
-#define FILE_ID 52
+#define FILE_ID OSM_FILE_SA_MAD_CTRL_C
 
 /****f* opensm: SA/sa_mad_ctrl_disp_done_callback
  * NAME
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index c5015ea..8e7f74d 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -64,7 +64,7 @@
 #include <opensm/osm_inform.h>
 #include <opensm/osm_sa.h>
 
-#define FILE_ID 53
+#define FILE_ID OSM_FILE_SA_MCMEMBER_RECORD_C
 
 #define JOIN_MC_COMP_MASK (IB_MCR_COMPMASK_MGID | \
 				IB_MCR_COMPMASK_PORT_GID | \
diff --git a/opensm/osm_sa_mft_record.c b/opensm/osm_sa_mft_record.c
index ca7110a..c71916a 100644
--- a/opensm/osm_sa_mft_record.c
+++ b/opensm/osm_sa_mft_record.c
@@ -54,7 +54,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-#define FILE_ID 54
+#define FILE_ID OSM_FILE_SA_MFT_RECORD_C
 
 typedef struct osm_mftr_item {
 	cl_list_item_t list_item;
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index e641884..89fb64a 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -61,7 +61,7 @@
 #include <opensm/osm_qos_policy.h>
 #include <opensm/osm_sa.h>
 
-#define FILE_ID 55
+#define FILE_ID OSM_FILE_SA_MULTIPATH_RECORD_C
 
 #define OSM_SA_MPR_MAX_NUM_PATH        127
 #define MAX_HOPS 64
diff --git a/opensm/osm_sa_node_record.c b/opensm/osm_sa_node_record.c
index d089e60..4b2cc52 100644
--- a/opensm/osm_sa_node_record.c
+++ b/opensm/osm_sa_node_record.c
@@ -54,7 +54,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-#define FILE_ID 56
+#define FILE_ID OSM_FILE_SA_NODE_RECORD_C
 
 typedef struct osm_nr_item {
 	cl_list_item_t list_item;
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 75fc2c4..56e7604 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -71,7 +71,7 @@
 #include <opensm/osm_prefix_route.h>
 #include <opensm/osm_ucast_lash.h>
 
-#define FILE_ID 57
+#define FILE_ID OSM_FILE_SA_PATH_RECORD_C
 
 #define MAX_HOPS 64
 
diff --git a/opensm/osm_sa_pkey_record.c b/opensm/osm_sa_pkey_record.c
index b127174..1777132 100644
--- a/opensm/osm_sa_pkey_record.c
+++ b/opensm/osm_sa_pkey_record.c
@@ -50,7 +50,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-#define FILE_ID 58
+#define FILE_ID OSM_FILE_SA_PKEY_RECORD_C
 
 typedef struct osm_pkey_item {
 	cl_list_item_t list_item;
diff --git a/opensm/osm_sa_portinfo_record.c b/opensm/osm_sa_portinfo_record.c
index 08b5681..e320842 100644
--- a/opensm/osm_sa_portinfo_record.c
+++ b/opensm/osm_sa_portinfo_record.c
@@ -58,7 +58,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-#define FILE_ID 59
+#define FILE_ID OSM_FILE_SA_PORTINFO_RECORD_C
 
 typedef struct osm_pir_item {
 	cl_list_item_t list_item;
diff --git a/opensm/osm_sa_service_record.c b/opensm/osm_sa_service_record.c
index 1fd98aa..6f6edf1 100644
--- a/opensm/osm_sa_service_record.c
+++ b/opensm/osm_sa_service_record.c
@@ -59,7 +59,7 @@
 #include <opensm/osm_service.h>
 #include <opensm/osm_pkey.h>
 
-#define FILE_ID 60
+#define FILE_ID OSM_FILE_SA_SERVICE_RECORD_C
 
 typedef struct osm_sr_item {
 	cl_list_item_t list_item;
diff --git a/opensm/osm_sa_slvl_record.c b/opensm/osm_sa_slvl_record.c
index 3faa192..c618c90 100644
--- a/opensm/osm_sa_slvl_record.c
+++ b/opensm/osm_sa_slvl_record.c
@@ -57,7 +57,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-#define FILE_ID 61
+#define FILE_ID OSM_FILE_SA_SLVL_RECORD_C
 
 typedef struct osm_slvl_item {
 	cl_list_item_t list_item;
diff --git a/opensm/osm_sa_sminfo_record.c b/opensm/osm_sa_sminfo_record.c
index 042cea2..bc7018d 100644
--- a/opensm/osm_sa_sminfo_record.c
+++ b/opensm/osm_sa_sminfo_record.c
@@ -63,7 +63,7 @@
 #include <opensm/osm_sa.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 62
+#define FILE_ID OSM_FILE_SA_SMINFO_RECORD_C
 
 typedef struct osm_smir_item {
 	cl_list_item_t list_item;
diff --git a/opensm/osm_sa_sw_info_record.c b/opensm/osm_sa_sw_info_record.c
index 7cd12d5..09ef13d 100644
--- a/opensm/osm_sa_sw_info_record.c
+++ b/opensm/osm_sa_sw_info_record.c
@@ -54,7 +54,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-#define FILE_ID 63
+#define FILE_ID OSM_FILE_SA_SW_INFO_RECORD_C
 
 typedef struct osm_sir_item {
 	cl_list_item_t list_item;
diff --git a/opensm/osm_sa_vlarb_record.c b/opensm/osm_sa_vlarb_record.c
index 73f1889..5562639 100644
--- a/opensm/osm_sa_vlarb_record.c
+++ b/opensm/osm_sa_vlarb_record.c
@@ -57,7 +57,7 @@
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
 
-#define FILE_ID 64
+#define FILE_ID OSM_FILE_SA_VLARB_RECORD_C
 
 typedef struct osm_vl_arb_item {
 	cl_list_item_t list_item;
diff --git a/opensm/osm_service.c b/opensm/osm_service.c
index 0f854b3..947527d 100644
--- a/opensm/osm_service.c
+++ b/opensm/osm_service.c
@@ -48,7 +48,7 @@
 #include <opensm/osm_service.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 65
+#define FILE_ID OSM_FILE_SERVICE_C
 
 void osm_svcr_delete(IN osm_svcr_t * p_svcr)
 {
diff --git a/opensm/osm_slvl_map_rcv.c b/opensm/osm_slvl_map_rcv.c
index c2723da..e60ab7f 100644
--- a/opensm/osm_slvl_map_rcv.c
+++ b/opensm/osm_slvl_map_rcv.c
@@ -56,7 +56,7 @@
 #include <opensm/osm_helper.h>
 #include <opensm/osm_sm.h>
 
-#define FILE_ID 66
+#define FILE_ID OSM_FILE_SLVL_MAP_RCV_C
 
 /*
  * WE ONLY RECEIVE GET or SET responses
diff --git a/opensm/osm_sm.c b/opensm/osm_sm.c
index add1fab..a0535f1 100644
--- a/opensm/osm_sm.c
+++ b/opensm/osm_sm.c
@@ -60,7 +60,7 @@
 #include <opensm/osm_perfmgr.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 67
+#define FILE_ID OSM_FILE_SM_C
 
 #define  OSM_SM_INITIAL_TID_VALUE 0x1233
 
diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
index aba6fcd..b2d8c2a 100644
--- a/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/osm_sm_mad_ctrl.c
@@ -56,7 +56,7 @@
 #include <opensm/osm_helper.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 69
+#define FILE_ID OSM_FILE_SM_MAD_CTRL_C
 
 /****f* opensm: SM/sm_mad_ctrl_retire_trans_mad
  * NAME
diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index 8dc1df8..fe863ba 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -61,7 +61,7 @@
 #include <opensm/osm_helper.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 70
+#define FILE_ID OSM_FILE_SM_STATE_MGR_C
 
 void osm_report_sm_state(osm_sm_t * sm)
 {
diff --git a/opensm/osm_sminfo_rcv.c b/opensm/osm_sminfo_rcv.c
index 3a5c108..b829027 100644
--- a/opensm/osm_sminfo_rcv.c
+++ b/opensm/osm_sminfo_rcv.c
@@ -58,7 +58,7 @@
 #include <opensm/osm_sm.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 68
+#define FILE_ID OSM_FILE_SMINFO_RCV_C
 
 /**********************************************************************
  Return TRUE if the remote sm given (by ib_sm_info_t) is higher,
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index de2d926..5566557 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -65,7 +65,7 @@
 #include <opensm/osm_inform.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 71
+#define FILE_ID OSM_FILE_STATE_MGR_C
 
 extern void osm_drop_mgr_process(IN osm_sm_t * sm);
 extern int osm_qos_setup(IN osm_opensm_t * p_osm);
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 7e77baf..d6a6a78 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -74,7 +74,7 @@
 #include <opensm/osm_qos_policy.h>
 #include <opensm/osm_service.h>
 
-#define FILE_ID 72
+#define FILE_ID OSM_FILE_SUBNET_C
 
 static const char null_str[] = "(null)";
 
diff --git a/opensm/osm_sw_info_rcv.c b/opensm/osm_sw_info_rcv.c
index 180a700..ad3e1dd 100644
--- a/opensm/osm_sw_info_rcv.c
+++ b/opensm/osm_sw_info_rcv.c
@@ -56,7 +56,7 @@
 #include <opensm/osm_helper.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 73
+#define FILE_ID OSM_FILE_SW_INFO_RCV_C
 
 #if 0
 /**********************************************************************
diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index 0e6e011..4b1af60 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -51,7 +51,7 @@
 #include <iba/ib_types.h>
 #include <opensm/osm_switch.h>
 
-#define FILE_ID 74
+#define FILE_ID OSM_FILE_SWITCH_C
 
 struct switch_port_path {
 	uint8_t port_num;
diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index af34327..4242e00 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -56,7 +56,7 @@
 #include <opensm/osm_node.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 75
+#define FILE_ID OSM_FILE_TORUS_C
 
 #define TORUS_MAX_DIM        3
 #define PORTGRP_MAX_PORTS    16
diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index d16c115..7135b0c 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -57,7 +57,7 @@
 #include <opensm/osm_inform.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 76
+#define FILE_ID OSM_FILE_TRAP_RCV_C
 
 extern void osm_req_get_node_desc(IN osm_sm_t * sm, osm_physp_t *p_physp);
 
diff --git a/opensm/osm_ucast_cache.c b/opensm/osm_ucast_cache.c
index a5be8ae..62d40b7 100644
--- a/opensm/osm_ucast_cache.c
+++ b/opensm/osm_ucast_cache.c
@@ -60,7 +60,7 @@
 #include <opensm/osm_node.h>
 #include <opensm/osm_port.h>
 
-#define FILE_ID 77
+#define FILE_ID OSM_FILE_UCAST_CACHE_C
 
 typedef struct cache_port {
 	boolean_t is_leaf;
diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index 9c255cd..f837bcd 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -51,7 +51,7 @@
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_node.h>
 
-#define FILE_ID 88
+#define FILE_ID OSM_FILE_UCAST_DFSSSP_C
 
 /* "infinity" for dijkstra */
 #define INF      0x7FFFFFFF
diff --git a/opensm/osm_ucast_dnup.c b/opensm/osm_ucast_dnup.c
index 324739c..7c38ce8 100644
--- a/opensm/osm_ucast_dnup.c
+++ b/opensm/osm_ucast_dnup.c
@@ -53,7 +53,7 @@
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_ucast_mgr.h>
 
-#define FILE_ID 78
+#define FILE_ID OSM_FILE_UCAST_DNUP_C
 
 /* //////////////////////////// */
 /*  Local types                 */
diff --git a/opensm/osm_ucast_file.c b/opensm/osm_ucast_file.c
index f8bec48..f6d4e09 100644
--- a/opensm/osm_ucast_file.c
+++ b/opensm/osm_ucast_file.c
@@ -53,7 +53,7 @@
 #include <opensm/osm_switch.h>
 #include <opensm/osm_log.h>
 
-#define FILE_ID 79
+#define FILE_ID OSM_FILE_UCAST_FILE_C
 
 static uint16_t remap_lid(osm_opensm_t * p_osm, uint16_t lid, ib_net64_t guid)
 {
diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 53f5ba1..c97810d 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -54,7 +54,7 @@
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_switch.h>
 
-#define FILE_ID 80
+#define FILE_ID OSM_FILE_UCAST_FTREE_C
 
 /*
  * FatTree rank is bounded between 2 and 8:
diff --git a/opensm/osm_ucast_lash.c b/opensm/osm_ucast_lash.c
index 8ac3b64..8f97bb3 100644
--- a/opensm/osm_ucast_lash.c
+++ b/opensm/osm_ucast_lash.c
@@ -58,7 +58,7 @@
 #include <opensm/osm_mesh.h>
 #include <opensm/osm_ucast_lash.h>
 
-#define FILE_ID 81
+#define FILE_ID OSM_FILE_UCAST_LASH_C
 
 typedef struct _reachable_dest {
 	int switch_id;
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 5a721fd..bc0b145 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -60,7 +60,7 @@
 #include <opensm/osm_msgdef.h>
 #include <opensm/osm_opensm.h>
 
-#define FILE_ID 82
+#define FILE_ID OSM_FILE_UCAST_MGR_C
 
 void osm_ucast_mgr_construct(IN osm_ucast_mgr_t * p_mgr)
 {
diff --git a/opensm/osm_ucast_updn.c b/opensm/osm_ucast_updn.c
index dcc54f1..ed56405 100644
--- a/opensm/osm_ucast_updn.c
+++ b/opensm/osm_ucast_updn.c
@@ -52,7 +52,7 @@
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_ucast_mgr.h>
 
-#define FILE_ID 83
+#define FILE_ID OSM_FILE_UCAST_UPDN_C
 
 /* //////////////////////////// */
 /*  Local types                 */
diff --git a/opensm/osm_vl15intf.c b/opensm/osm_vl15intf.c
index 722fec8..197df17 100644
--- a/opensm/osm_vl15intf.c
+++ b/opensm/osm_vl15intf.c
@@ -53,8 +53,9 @@
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
 #include <opensm/osm_helper.h>
+#include <opensm/osm_sm.h>
 
-#define FILE_ID 85
+#define FILE_ID OSM_FILE_VL15INTF_C
 
 static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
 {
diff --git a/opensm/osm_vl_arb_rcv.c b/opensm/osm_vl_arb_rcv.c
index 9369e5a..9ee22e9 100644
--- a/opensm/osm_vl_arb_rcv.c
+++ b/opensm/osm_vl_arb_rcv.c
@@ -57,7 +57,7 @@
 #include <opensm/osm_helper.h>
 #include <opensm/osm_sm.h>
 
-#define FILE_ID 86
+#define FILE_ID OSM_FILE_VL_ARB_RCV_C
 
 /*
  * WE ONLY RECEIVE GET or SET responses
diff --git a/opensm/st.c b/opensm/st.c
index c604a8f..b0853f7 100644
--- a/opensm/st.c
+++ b/opensm/st.c
@@ -43,7 +43,7 @@
 #include <string.h>
 #include <opensm/st.h>
 
-#define FILE_ID 87
+#define FILE_ID OSM_FILE_ST_C
 
 typedef struct st_table_entry st_table_entry;
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
