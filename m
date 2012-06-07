From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv3 3/3] opensm: Add enum for FILE_ID for per module logging
Date: Wed, 06 Jun 2012 20:35:05 -0400
Message-ID: <4FCFF739.9010006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From e1230ff977e5a3412a83e11d26c4fb2c0765ce31 Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 7 Jun 2012 03:19:15 +0300
Subject: [PATCHv3 3/3] opensm: Add enum for FILE_ID for per module logging

An osm_file_ids_enum was added to new osm_file_ids_enum.h
and a FILE_ID const definition to each source file.

Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v2:
Put osm_file_ids_enum into own header file rather than
osm_sm.h

Changes since v1:
opensm/osm_log.c: Use file_id rather than FILE_ID in
osm_log_is_active_v2 call in osm_log_msg_box_v2 function
---
 include/opensm/osm_file_ids.h       |  156 +++++++++++++++++++++++++++++++++++
 libvendor/osm_vendor_ibumad.c       |    3 +-
 opensm/Makefile.am                  |    1 +
 opensm/main.c                       |    3 +-
 opensm/osm_console.c                |    3 +-
 opensm/osm_console_io.c             |    3 +-
 opensm/osm_db_files.c               |    3 +-
 opensm/osm_db_pack.c                |    3 +-
 opensm/osm_drop_mgr.c               |    3 +-
 opensm/osm_dump.c                   |    3 +-
 opensm/osm_event_plugin.c           |    3 +-
 opensm/osm_guid_info_rcv.c          |    3 +-
 opensm/osm_guid_mgr.c               |    3 +-
 opensm/osm_helper.c                 |    3 +-
 opensm/osm_inform.c                 |    3 +-
 opensm/osm_lid_mgr.c                |    3 +-
 opensm/osm_lin_fwd_rcv.c            |    3 +-
 opensm/osm_link_mgr.c               |    3 +-
 opensm/osm_log.c                    |    3 +-
 opensm/osm_mad_pool.c               |    3 +-
 opensm/osm_mcast_fwd_rcv.c          |    3 +-
 opensm/osm_mcast_mgr.c              |    3 +-
 opensm/osm_mcast_tbl.c              |    3 +-
 opensm/osm_mcm_port.c               |    3 +-
 opensm/osm_mesh.c                   |    3 +-
 opensm/osm_mlnx_ext_port_info_rcv.c |    3 +-
 opensm/osm_mtree.c                  |    3 +-
 opensm/osm_multicast.c              |    3 +-
 opensm/osm_node.c                   |    3 +-
 opensm/osm_node_desc_rcv.c          |    3 +-
 opensm/osm_node_info_rcv.c          |    3 +-
 opensm/osm_opensm.c                 |    3 +-
 opensm/osm_perfmgr.c                |    3 +-
 opensm/osm_perfmgr_db.c             |    3 +-
 opensm/osm_pkey.c                   |    3 +-
 opensm/osm_pkey_mgr.c               |    3 +-
 opensm/osm_pkey_rcv.c               |    3 +-
 opensm/osm_port.c                   |    3 +-
 opensm/osm_port_info_rcv.c          |    3 +-
 opensm/osm_prtn.c                   |    3 +-
 opensm/osm_prtn_config.c            |    3 +-
 opensm/osm_qos.c                    |    3 +-
 opensm/osm_qos_parser_l.l           |    3 +-
 opensm/osm_qos_parser_y.y           |    3 +-
 opensm/osm_qos_policy.c             |    3 +-
 opensm/osm_remote_sm.c              |    3 +-
 opensm/osm_req.c                    |    3 +-
 opensm/osm_resp.c                   |    3 +-
 opensm/osm_router.c                 |    3 +-
 opensm/osm_sa.c                     |    3 +-
 opensm/osm_sa_class_port_info.c     |    3 +-
 opensm/osm_sa_guidinfo_record.c     |    3 +-
 opensm/osm_sa_informinfo.c          |    3 +-
 opensm/osm_sa_lft_record.c          |    3 +-
 opensm/osm_sa_link_record.c         |    3 +-
 opensm/osm_sa_mad_ctrl.c            |    3 +-
 opensm/osm_sa_mcmember_record.c     |    3 +-
 opensm/osm_sa_mft_record.c          |    3 +-
 opensm/osm_sa_multipath_record.c    |    3 +-
 opensm/osm_sa_node_record.c         |    3 +-
 opensm/osm_sa_path_record.c         |    3 +-
 opensm/osm_sa_pkey_record.c         |    3 +-
 opensm/osm_sa_portinfo_record.c     |    3 +-
 opensm/osm_sa_service_record.c      |    3 +-
 opensm/osm_sa_slvl_record.c         |    3 +-
 opensm/osm_sa_sminfo_record.c       |    3 +-
 opensm/osm_sa_sw_info_record.c      |    3 +-
 opensm/osm_sa_vlarb_record.c        |    3 +-
 opensm/osm_service.c                |    3 +-
 opensm/osm_slvl_map_rcv.c           |    3 +-
 opensm/osm_sm.c                     |    3 +-
 opensm/osm_sm_mad_ctrl.c            |    3 +-
 opensm/osm_sm_state_mgr.c           |    3 +-
 opensm/osm_sminfo_rcv.c             |    3 +-
 opensm/osm_state_mgr.c              |    3 +-
 opensm/osm_subnet.c                 |    3 +-
 opensm/osm_sw_info_rcv.c            |    3 +-
 opensm/osm_switch.c                 |    3 +-
 opensm/osm_torus.c                  |    3 +-
 opensm/osm_trap_rcv.c               |    3 +-
 opensm/osm_ucast_cache.c            |    3 +-
 opensm/osm_ucast_dfsssp.c           |    3 +-
 opensm/osm_ucast_dnup.c             |    3 +-
 opensm/osm_ucast_file.c             |    3 +-
 opensm/osm_ucast_ftree.c            |    3 +-
 opensm/osm_ucast_lash.c             |    3 +-
 opensm/osm_ucast_mgr.c              |    3 +-
 opensm/osm_ucast_updn.c             |    3 +-
 opensm/osm_vl15intf.c               |    3 +-
 opensm/osm_vl_arb_rcv.c             |    3 +-
 opensm/st.c                         |    3 +-
 91 files changed, 335 insertions(+), 89 deletions(-)
 create mode 100644 include/opensm/osm_file_ids.h

diff --git a/include/opensm/osm_file_ids.h b/include/opensm/osm_file_ids.h
new file mode 100644
index 0000000..713a0f9
--- /dev/null
+++ b/include/opensm/osm_file_ids.h
@@ -0,0 +1,156 @@
+/*
+ * Copyright (c) 2012 Mellanox Technologies LTD. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+/*
+ * Abstract:
+ * 	Declaration of osm_file_ids_enum.
+ *	This object is part of the OpenSM family of objects.
+ */
+
+#ifndef _OSM_FILE_ID_H_
+#define _OSM_FILE_ID_H_
+
+#ifdef __cplusplus
+#  define BEGIN_C_DECLS extern "C" {
+#  define END_C_DECLS   }
+#else				/* !__cplusplus */
+#  define BEGIN_C_DECLS
+#  define END_C_DECLS
+#endif				/* __cplusplus */
+
+BEGIN_C_DECLS
+
+/****d* OpenSM: osm_file_ids_enum
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
+END_C_DECLS
+#endif				/* _OSM_FILE_ID_H_ */
diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index 6d63b05..99d8ab9 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -61,7 +61,8 @@
 #include <complib/cl_qlist.h>
 #include <complib/cl_math.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 84
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_VENDOR_IBUMAD_C
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
 #include <opensm/osm_mad_pool.h>
diff --git a/opensm/Makefile.am b/opensm/Makefile.am
index cc27893..855042c 100644
--- a/opensm/Makefile.am
+++ b/opensm/Makefile.am
@@ -76,6 +76,7 @@ opensminclude_HEADERS = \
 	$(srcdir)/../include/opensm/osm_db_pack.h \
 	$(srcdir)/../include/opensm/osm_event_plugin.h \
 	$(srcdir)/../include/opensm/osm_errors.h \
+	$(srcdir)/../include/opensm/osm_file_ids.h \
 	$(srcdir)/../include/opensm/osm_guid.h \
 	$(srcdir)/../include/opensm/osm_helper.h \
 	$(srcdir)/../include/opensm/osm_inform.h \
diff --git a/opensm/main.c b/opensm/main.c
index e00f721..4218cc6 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -55,7 +55,8 @@
 #include <fcntl.h>
 #include <complib/cl_types.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 0
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_MAIN_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_version.h>
 #include <opensm/osm_opensm.h>
diff --git a/opensm/osm_console.c b/opensm/osm_console.c
index 7cc701c..ad3a4d7 100644
--- a/opensm/osm_console.c
+++ b/opensm/osm_console.c
@@ -52,7 +52,8 @@
 #include <errno.h>
 #include <ctype.h>
 #include <sys/time.h>
-#define FILE_ID 1
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_CONSOLE_C
 #include <opensm/osm_console.h>
 #include <complib/cl_passivelock.h>
 #include <opensm/osm_perfmgr.h>
diff --git a/opensm/osm_console_io.c b/opensm/osm_console_io.c
index 9782b00..167562c 100644
--- a/opensm/osm_console_io.c
+++ b/opensm/osm_console_io.c
@@ -55,7 +55,8 @@
 #include <unistd.h>
 #include <errno.h>
 #include <signal.h>
-#define FILE_ID 2
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_CONSOLE_IO_C
 #include <opensm/osm_console_io.h>
 #include <stdlib.h>
 
diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
index f42fbba..7ab6b56 100644
--- a/opensm/osm_db_files.c
+++ b/opensm/osm_db_files.c
@@ -46,7 +46,8 @@
 #include <sys/types.h>
 #include <stdlib.h>
 #include <string.h>
-#define FILE_ID 3
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_DB_FILES_C
 #include <opensm/st.h>
 #include <opensm/osm_db.h>
 
diff --git a/opensm/osm_db_pack.c b/opensm/osm_db_pack.c
index fa0b08b..c1ec4ab 100644
--- a/opensm/osm_db_pack.c
+++ b/opensm/osm_db_pack.c
@@ -39,7 +39,8 @@
 
 #include <stdlib.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 4
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_DB_PACK_C
 #include <opensm/osm_db_pack.h>
 
 static inline void pack_guid(uint64_t guid, char *p_guid_str)
diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index b99b0da..ab3b2b3 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -52,7 +52,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_ptr_vector.h>
-#define FILE_ID 5
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_DROP_MGR_C
 #include <opensm/osm_sm.h>
 #include <opensm/osm_router.h>
 #include <opensm/osm_switch.h>
diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index bfd799f..daaa98e 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -50,7 +50,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_qmap.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 6
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_DUMP_C
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_log.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_event_plugin.c b/opensm/osm_event_plugin.c
index 971b6cb..ae73783 100644
--- a/opensm/osm_event_plugin.c
+++ b/opensm/osm_event_plugin.c
@@ -49,7 +49,8 @@
 
 #include <stdlib.h>
 #include <dlfcn.h>
-#define FILE_ID 7
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_EVENT_PLUGIN_C
 #include <opensm/osm_event_plugin.h>
 #include <opensm/osm_opensm.h>
 
diff --git a/opensm/osm_guid_info_rcv.c b/opensm/osm_guid_info_rcv.c
index 963bcf7..a50f5f4 100644
--- a/opensm/osm_guid_info_rcv.c
+++ b/opensm/osm_guid_info_rcv.c
@@ -50,7 +50,8 @@
 #include <complib/cl_qmap.h>
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 8
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_GUID_INFO_RCV_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_guid_mgr.c b/opensm/osm_guid_mgr.c
index 5d5d88f..5bb2c67 100644
--- a/opensm/osm_guid_mgr.c
+++ b/opensm/osm_guid_mgr.c
@@ -48,7 +48,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 9
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_GUID_MGR_C
 #include <opensm/osm_port.h>
 #include <opensm/osm_node.h>
 #include <opensm/osm_guid.h>
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index 480fc0a..1ff2426 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -50,7 +50,8 @@
 #include <arpa/inet.h>
 #include <complib/cl_debug.h>
 #include <iba/ib_types.h>
-#define FILE_ID 10
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_HELPER_C
 #include <opensm/osm_helper.h>
 #include <opensm/osm_log.h>
 
diff --git a/opensm/osm_inform.c b/opensm/osm_inform.c
index a124350..8444baa 100644
--- a/opensm/osm_inform.c
+++ b/opensm/osm_inform.c
@@ -47,7 +47,8 @@
 #include <string.h>
 #include <arpa/inet.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 11
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_INFORM_C
 #include <opensm/osm_helper.h>
 #include <opensm/osm_inform.h>
 #include <vendor/osm_vendor_api.h>
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index 926c9d4..cb7ff0b 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -85,7 +85,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_qmap.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 12
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_LID_MGR_C
 #include <opensm/osm_lid_mgr.h>
 #include <opensm/osm_sm.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_lin_fwd_rcv.c b/opensm/osm_lin_fwd_rcv.c
index b155593..f13b9a8 100644
--- a/opensm/osm_lin_fwd_rcv.c
+++ b/opensm/osm_lin_fwd_rcv.c
@@ -47,7 +47,8 @@
 
 #include <string.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 13
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_LIN_FWD_RCV_C
 #include <opensm/osm_switch.h>
 #include <opensm/osm_sm.h>
 
diff --git a/opensm/osm_link_mgr.c b/opensm/osm_link_mgr.c
index f457041..8301643 100644
--- a/opensm/osm_link_mgr.c
+++ b/opensm/osm_link_mgr.c
@@ -48,7 +48,8 @@
 #include <string.h>
 #include <iba/ib_types.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 14
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_LINK_MGR_C
 #include <opensm/osm_sm.h>
 #include <opensm/osm_node.h>
 #include <opensm/osm_switch.h>
diff --git a/opensm/osm_log.c b/opensm/osm_log.c
index f4ea8f4..94f0d03 100644
--- a/opensm/osm_log.c
+++ b/opensm/osm_log.c
@@ -44,7 +44,8 @@
 #  include <config.h>
 #endif				/* HAVE_CONFIG_H */
 
-#define FILE_ID 15
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_LOG_C
 #include <opensm/osm_log.h>
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/opensm/osm_mad_pool.c b/opensm/osm_mad_pool.c
index b89338f..9bd9a4b 100644
--- a/opensm/osm_mad_pool.c
+++ b/opensm/osm_mad_pool.c
@@ -46,7 +46,8 @@
 
 #include <stdlib.h>
 #include <string.h>
-#define FILE_ID 16
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_MAD_POOL_C
 #include <opensm/osm_mad_pool.h>
 #include <opensm/osm_madw.h>
 #include <vendor/osm_vendor_api.h>
diff --git a/opensm/osm_mcast_fwd_rcv.c b/opensm/osm_mcast_fwd_rcv.c
index 466a58f..d855cbb 100644
--- a/opensm/osm_mcast_fwd_rcv.c
+++ b/opensm/osm_mcast_fwd_rcv.c
@@ -50,7 +50,8 @@
 #include <complib/cl_qmap.h>
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 17
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_MCAST_FWD_RCV_C
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
 #include <opensm/osm_switch.h>
diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
index f85f991..fea0a69 100644
--- a/opensm/osm_mcast_mgr.c
+++ b/opensm/osm_mcast_mgr.c
@@ -50,7 +50,8 @@
 #include <string.h>
 #include <iba/ib_types.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 18
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_MCAST_MGR_C
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_sm.h>
 #include <opensm/osm_multicast.h>
diff --git a/opensm/osm_mcast_tbl.c b/opensm/osm_mcast_tbl.c
index 31890c4..c4a64e2 100644
--- a/opensm/osm_mcast_tbl.c
+++ b/opensm/osm_mcast_tbl.c
@@ -49,7 +49,8 @@
 #include <string.h>
 #include <complib/cl_math.h>
 #include <iba/ib_types.h>
-#define FILE_ID 19
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_MCAST_TBL_C
 #include <opensm/osm_mcast_tbl.h>
 
 void osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl, IN uint8_t num_ports,
diff --git a/opensm/osm_mcm_port.c b/opensm/osm_mcm_port.c
index dfeae13..65cef0b 100644
--- a/opensm/osm_mcm_port.c
+++ b/opensm/osm_mcm_port.c
@@ -46,7 +46,8 @@
 
 #include <stdlib.h>
 #include <string.h>
-#define FILE_ID 20
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_MCM_PORT_C
 #include <opensm/osm_mcm_port.h>
 #include <opensm/osm_multicast.h>
 
diff --git a/opensm/osm_mesh.c b/opensm/osm_mesh.c
index aede1db..8f84e53 100644
--- a/opensm/osm_mesh.c
+++ b/opensm/osm_mesh.c
@@ -43,7 +43,8 @@
 
 #include <stdio.h>
 #include <stdlib.h>
-#define FILE_ID 21
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_MESH_C
 #include <opensm/osm_switch.h>
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_mlnx_ext_port_info_rcv.c b/opensm/osm_mlnx_ext_port_info_rcv.c
index 719fd97..abf6fd4 100644
--- a/opensm/osm_mlnx_ext_port_info_rcv.c
+++ b/opensm/osm_mlnx_ext_port_info_rcv.c
@@ -48,7 +48,8 @@
 #include <complib/cl_qmap.h>
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 22
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_MLNX_EXT_PORT_INFO_RCV_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_mtree.c b/opensm/osm_mtree.c
index aaefa9a..12acd7b 100644
--- a/opensm/osm_mtree.c
+++ b/opensm/osm_mtree.c
@@ -44,7 +44,8 @@
 #endif				/* HAVE_CONFIG_H */
 
 #include <stdlib.h>
-#define FILE_ID 23
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_MTREE_C
 #include <complib/cl_debug.h>
 #include <opensm/osm_mtree.h>
 
diff --git a/opensm/osm_multicast.c b/opensm/osm_multicast.c
index 9e788ec..c43d58d 100644
--- a/opensm/osm_multicast.c
+++ b/opensm/osm_multicast.c
@@ -45,7 +45,8 @@
 #include <stdlib.h>
 #include <string.h>
 #include <arpa/inet.h>
-#define FILE_ID 24
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_MULTICAST_C
 #include <opensm/osm_multicast.h>
 #include <opensm/osm_mcm_port.h>
 #include <opensm/osm_mtree.h>
diff --git a/opensm/osm_node.c b/opensm/osm_node.c
index 5494a1b..fc71e0f 100644
--- a/opensm/osm_node.c
+++ b/opensm/osm_node.c
@@ -46,7 +46,8 @@
 
 #include <stdlib.h>
 #include <iba/ib_types.h>
-#define FILE_ID 25
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_NODE_C
 #include <opensm/osm_node.h>
 #include <opensm/osm_madw.h>
 
diff --git a/opensm/osm_node_desc_rcv.c b/opensm/osm_node_desc_rcv.c
index 7812e3f..741c944 100644
--- a/opensm/osm_node_desc_rcv.c
+++ b/opensm/osm_node_desc_rcv.c
@@ -49,7 +49,8 @@
 #include <complib/cl_qmap.h>
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 26
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_NODE_DESC_RCV_C
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index 7e11905..dcf2456 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -51,7 +51,8 @@
 #include <complib/cl_qmap.h>
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 27
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_NODE_INFO_RCV_C
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
index 08394c9..429108a 100644
--- a/opensm/osm_opensm.c
+++ b/opensm/osm_opensm.c
@@ -50,7 +50,8 @@
 #include <string.h>
 #include <complib/cl_dispatcher.h>
 #include <complib/cl_passivelock.h>
-#define FILE_ID 28
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_OPENSM_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_version.h>
 #include <opensm/osm_base.h>
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index f9f5eca..234ac64 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -59,7 +59,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_thread.h>
-#define FILE_ID 29
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_PERFMGR_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_perfmgr.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_perfmgr_db.c b/opensm/osm_perfmgr_db.c
index ef2b68a..a472287 100644
--- a/opensm/osm_perfmgr_db.c
+++ b/opensm/osm_perfmgr_db.c
@@ -45,7 +45,8 @@
 #include <dlfcn.h>
 #include <sys/stat.h>
 
-#define FILE_ID 30
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_PERFMGR_DB_C
 #include <opensm/osm_perfmgr_db.h>
 #include <opensm/osm_perfmgr.h>
 #include <opensm/osm_opensm.h>
diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index fa3178e..1ae9f4e 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -47,7 +47,8 @@
 #include <string.h>
 #include <complib/cl_debug.h>
 #include <iba/ib_types.h>
-#define FILE_ID 31
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_PKEY_C
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_log.h>
 #include <opensm/osm_port.h>
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index cf4e7b3..7a1f31c 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -48,7 +48,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_qmap.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 32
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_PKEY_MGR_C
 #include <opensm/osm_node.h>
 #include <opensm/osm_switch.h>
 #include <opensm/osm_partition.h>
diff --git a/opensm/osm_pkey_rcv.c b/opensm/osm_pkey_rcv.c
index 558eaa0..6682c5a 100644
--- a/opensm/osm_pkey_rcv.c
+++ b/opensm/osm_pkey_rcv.c
@@ -41,7 +41,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 33
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_PKEY_RCV_C
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_port.c b/opensm/osm_port.c
index c11b296..d7c0f75 100644
--- a/opensm/osm_port.c
+++ b/opensm/osm_port.c
@@ -48,7 +48,8 @@
 #include <string.h>
 #include <complib/cl_debug.h>
 #include <iba/ib_types.h>
-#define FILE_ID 34
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_PORT_C
 #include <opensm/osm_port.h>
 #include <opensm/osm_node.h>
 #include <opensm/osm_madw.h>
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index 3a73c8d..ca2808c 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -51,7 +51,8 @@
 #include <complib/cl_qmap.h>
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 35
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_PORT_INFO_RCV_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_prtn.c b/opensm/osm_prtn.c
index 129fe51..b4ee965 100644
--- a/opensm/osm_prtn.c
+++ b/opensm/osm_prtn.c
@@ -49,7 +49,8 @@
 #include <sys/stat.h>
 #include <complib/cl_debug.h>
 #include <iba/ib_types.h>
-#define FILE_ID 36
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_PRTN_C
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_partition.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_prtn_config.c b/opensm/osm_prtn_config.c
index 7c318ea..6798979 100644
--- a/opensm/osm_prtn_config.c
+++ b/opensm/osm_prtn_config.c
@@ -48,7 +48,8 @@
 #include <ctype.h>
 
 #include <iba/ib_types.h>
-#define FILE_ID 37
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_PRTN_CONFIG_C
 #include <opensm/osm_base.h>
 #include <opensm/osm_partition.h>
 #include <opensm/osm_subnet.h>
diff --git a/opensm/osm_qos.c b/opensm/osm_qos.c
index 31842b6..429660b 100644
--- a/opensm/osm_qos.c
+++ b/opensm/osm_qos.c
@@ -47,7 +47,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_qmap.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 38
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_QOS_C
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_subnet.h>
 #include <opensm/osm_qos_policy.h>
diff --git a/opensm/osm_qos_parser_l.l b/opensm/osm_qos_parser_l.l
index 3d978d8..6054397 100644
--- a/opensm/osm_qos_parser_l.l
+++ b/opensm/osm_qos_parser_l.l
@@ -45,7 +45,8 @@
  *    Yevgeny Kliteynik, Mellanox
  */
 
-#define FILE_ID 39
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_QOS_PARSER_L_L
 #include <opensm/osm_qos_policy.h>
 #include "osm_qos_parser_y.h"
 
diff --git a/opensm/osm_qos_parser_y.y b/opensm/osm_qos_parser_y.y
index d383748..4e01ed4 100644
--- a/opensm/osm_qos_parser_y.y
+++ b/opensm/osm_qos_parser_y.y
@@ -53,7 +53,8 @@
 #include <string.h>
 #include <ctype.h>
 #include <errno.h>
-#define FILE_ID 40
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_QOS_PARSER_Y_Y
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_qos_policy.h>
 
diff --git a/opensm/osm_qos_policy.c b/opensm/osm_qos_policy.c
index d272ee8..c8526b9 100644
--- a/opensm/osm_qos_policy.c
+++ b/opensm/osm_qos_policy.c
@@ -49,7 +49,8 @@
 #include <string.h>
 #include <ctype.h>
 #include <arpa/inet.h>
-#define FILE_ID 41
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_QOS_POLICY_C
 #include <opensm/osm_log.h>
 #include <opensm/osm_node.h>
 #include <opensm/osm_port.h>
diff --git a/opensm/osm_remote_sm.c b/opensm/osm_remote_sm.c
index 1d2c746..a0562ac 100644
--- a/opensm/osm_remote_sm.c
+++ b/opensm/osm_remote_sm.c
@@ -45,7 +45,8 @@
 #endif				/* HAVE_CONFIG_H */
 
 #include <string.h>
-#define FILE_ID 42
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_REMOTE_SM_C
 #include <opensm/osm_remote_sm.h>
 
 void osm_remote_sm_construct(IN osm_remote_sm_t * p_sm)
diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index 04174af..5ee904a 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -48,7 +48,8 @@
 #include <string.h>
 #include <iba/ib_types.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 43
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_REQ_C
 #include <opensm/osm_madw.h>
 #include <opensm/osm_attrib_req.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_resp.c b/opensm/osm_resp.c
index 0adf8a6..59a73e0 100644
--- a/opensm/osm_resp.c
+++ b/opensm/osm_resp.c
@@ -47,7 +47,8 @@
 #include <string.h>
 #include <iba/ib_types.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 44
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_RESP_C
 #include <opensm/osm_madw.h>
 #include <opensm/osm_attrib_req.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_router.c b/opensm/osm_router.c
index 6ed5de5..af5fff5 100644
--- a/opensm/osm_router.c
+++ b/opensm/osm_router.c
@@ -47,7 +47,8 @@
 #include <stdlib.h>
 #include <string.h>
 #include <iba/ib_types.h>
-#define FILE_ID 45
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_ROUTER_C
 #include <opensm/osm_router.h>
 
 void osm_router_delete(IN OUT osm_router_t ** pp_rtr)
diff --git a/opensm/osm_sa.c b/opensm/osm_sa.c
index 817ac43..1af9fdf 100644
--- a/opensm/osm_sa.c
+++ b/opensm/osm_sa.c
@@ -55,7 +55,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <iba/ib_types.h>
-#define FILE_ID 46
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_C
 #include <opensm/osm_sa.h>
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_sa_class_port_info.c b/opensm/osm_sa_class_port_info.c
index 916768f..c384b37 100644
--- a/opensm/osm_sa_class_port_info.c
+++ b/opensm/osm_sa_class_port_info.c
@@ -50,7 +50,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 47
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_CLASS_PORT_INFO_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_helper.h>
 #include <opensm/osm_sa.h>
diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index a19d526..83ce990 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -50,7 +50,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 48
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_GUIDINFO_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_port.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_sa_informinfo.c b/opensm/osm_sa_informinfo.c
index b8d0130..eaffcd5 100644
--- a/opensm/osm_sa_informinfo.c
+++ b/opensm/osm_sa_informinfo.c
@@ -52,7 +52,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 49
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_INFORMINFO_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_port.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_sa_lft_record.c b/opensm/osm_sa_lft_record.c
index e895a9f..113b9a8 100644
--- a/opensm/osm_sa_lft_record.c
+++ b/opensm/osm_sa_lft_record.c
@@ -48,7 +48,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 50
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_LFT_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_switch.h>
 #include <opensm/osm_helper.h>
diff --git a/opensm/osm_sa_link_record.c b/opensm/osm_sa_link_record.c
index de7ea32..69b0b1a 100644
--- a/opensm/osm_sa_link_record.c
+++ b/opensm/osm_sa_link_record.c
@@ -48,7 +48,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_qmap.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 51
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_LINK_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_node.h>
 #include <opensm/osm_switch.h>
diff --git a/opensm/osm_sa_mad_ctrl.c b/opensm/osm_sa_mad_ctrl.c
index e39698c..a1a430d 100644
--- a/opensm/osm_sa_mad_ctrl.c
+++ b/opensm/osm_sa_mad_ctrl.c
@@ -47,7 +47,8 @@
 #include <string.h>
 #include <complib/cl_debug.h>
 #include <iba/ib_types.h>
-#define FILE_ID 52
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_MAD_CTRL_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_sa_mad_ctrl.h>
 #include <opensm/osm_msgdef.h>
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index f6c9669..a4a7573 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -53,7 +53,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 53
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_MCMEMBER_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_sa_mft_record.c b/opensm/osm_sa_mft_record.c
index 2d792d8..9823d31 100644
--- a/opensm/osm_sa_mft_record.c
+++ b/opensm/osm_sa_mft_record.c
@@ -48,7 +48,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 54
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_MFT_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_switch.h>
 #include <opensm/osm_helper.h>
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index 30954d6..e80bfc2 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -52,7 +52,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 55
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_MULTIPATH_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_port.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_sa_node_record.c b/opensm/osm_sa_node_record.c
index db4c955..441fe76 100644
--- a/opensm/osm_sa_node_record.c
+++ b/opensm/osm_sa_node_record.c
@@ -48,7 +48,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 56
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_NODE_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_node.h>
 #include <opensm/osm_helper.h>
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 0094950..e205694 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -55,7 +55,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 57
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_PATH_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_base.h>
 #include <opensm/osm_port.h>
diff --git a/opensm/osm_sa_pkey_record.c b/opensm/osm_sa_pkey_record.c
index d91f8b9..fdbb3bf 100644
--- a/opensm/osm_sa_pkey_record.c
+++ b/opensm/osm_sa_pkey_record.c
@@ -43,7 +43,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 58
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_PKEY_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_port.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_sa_portinfo_record.c b/opensm/osm_sa_portinfo_record.c
index b24041c..4a97ef2 100644
--- a/opensm/osm_sa_portinfo_record.c
+++ b/opensm/osm_sa_portinfo_record.c
@@ -50,7 +50,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 59
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_PORTINFO_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_port.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_sa_service_record.c b/opensm/osm_sa_service_record.c
index 78eae37..781792a 100644
--- a/opensm/osm_sa_service_record.c
+++ b/opensm/osm_sa_service_record.c
@@ -50,7 +50,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 60
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_SERVICE_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_port.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_sa_slvl_record.c b/opensm/osm_sa_slvl_record.c
index 4d97fa0..253f82d 100644
--- a/opensm/osm_sa_slvl_record.c
+++ b/opensm/osm_sa_slvl_record.c
@@ -50,7 +50,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 61
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_SLVL_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_port.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_sa_sminfo_record.c b/opensm/osm_sa_sminfo_record.c
index 77a90bd..852fb9e 100644
--- a/opensm/osm_sa_sminfo_record.c
+++ b/opensm/osm_sa_sminfo_record.c
@@ -50,7 +50,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 62
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_SMINFO_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_sa_sw_info_record.c b/opensm/osm_sa_sw_info_record.c
index 2a635cb..e1161d8 100644
--- a/opensm/osm_sa_sw_info_record.c
+++ b/opensm/osm_sa_sw_info_record.c
@@ -48,7 +48,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 63
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_SW_INFO_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_node.h>
 #include <opensm/osm_helper.h>
diff --git a/opensm/osm_sa_vlarb_record.c b/opensm/osm_sa_vlarb_record.c
index 3357066..98c23a7 100644
--- a/opensm/osm_sa_vlarb_record.c
+++ b/opensm/osm_sa_vlarb_record.c
@@ -50,7 +50,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 64
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SA_VLARB_RECORD_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_port.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_service.c b/opensm/osm_service.c
index 8d34f2b..f4644d5 100644
--- a/opensm/osm_service.c
+++ b/opensm/osm_service.c
@@ -45,7 +45,8 @@
 #include <stdlib.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_timer.h>
-#define FILE_ID 65
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SERVICE_C
 #include <opensm/osm_service.h>
 #include <opensm/osm_opensm.h>
 
diff --git a/opensm/osm_slvl_map_rcv.c b/opensm/osm_slvl_map_rcv.c
index 83a28b1..fd8681e 100644
--- a/opensm/osm_slvl_map_rcv.c
+++ b/opensm/osm_slvl_map_rcv.c
@@ -49,7 +49,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 66
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SLVL_MAP_RCV_C
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_sm.c b/opensm/osm_sm.c
index 376b4ca..6f88f59 100644
--- a/opensm/osm_sm.c
+++ b/opensm/osm_sm.c
@@ -52,7 +52,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_thread.h>
-#define FILE_ID 67
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SM_C
 #include <opensm/osm_sm.h>
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
index 03a5c68..fbc551d 100644
--- a/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/osm_sm_mad_ctrl.c
@@ -49,7 +49,8 @@
 #include <string.h>
 #include <complib/cl_debug.h>
 #include <iba/ib_types.h>
-#define FILE_ID 69
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SM_MAD_CTRL_C
 #include <opensm/osm_sm_mad_ctrl.h>
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_madw.h>
diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index 5fb7a1f..e826f1f 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -48,7 +48,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 70
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SM_STATE_MGR_C
 #include <opensm/osm_sm.h>
 #include <opensm/osm_madw.h>
 #include <opensm/osm_switch.h>
diff --git a/opensm/osm_sminfo_rcv.c b/opensm/osm_sminfo_rcv.c
index d537b16..b474932 100644
--- a/opensm/osm_sminfo_rcv.c
+++ b/opensm/osm_sminfo_rcv.c
@@ -50,7 +50,8 @@
 #include <complib/cl_qmap.h>
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 68
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SMINFO_RCV_C
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 7d00248..a2b2b96 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -52,7 +52,8 @@
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qmap.h>
-#define FILE_ID 71
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_STATE_MGR_C
 #include <opensm/osm_sm.h>
 #include <opensm/osm_madw.h>
 #include <opensm/osm_switch.h>
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 0d7a439..603b528 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -56,7 +56,8 @@
 #include <ctype.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_log.h>
-#define FILE_ID 72
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SUBNET_C
 #include <opensm/osm_subnet.h>
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_sw_info_rcv.c b/opensm/osm_sw_info_rcv.c
index cc8df64..398b5a4 100644
--- a/opensm/osm_sw_info_rcv.c
+++ b/opensm/osm_sw_info_rcv.c
@@ -50,7 +50,8 @@
 #include <complib/cl_qmap.h>
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 73
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SW_INFO_RCV_C
 #include <opensm/osm_log.h>
 #include <opensm/osm_switch.h>
 #include <opensm/osm_subnet.h>
diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index eaa7012..acc7b26 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -49,7 +49,8 @@
 #include <string.h>
 #include <complib/cl_math.h>
 #include <iba/ib_types.h>
-#define FILE_ID 74
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_SWITCH_C
 #include <opensm/osm_switch.h>
 
 struct switch_port_path {
diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index e157229..addda89 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -50,7 +50,8 @@
 #  include <config.h>
 #endif				/* HAVE_CONFIG_H */
 
-#define FILE_ID 75
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_TORUS_C
 #include <opensm/osm_log.h>
 #include <opensm/osm_port.h>
 #include <opensm/osm_switch.h>
diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index 07c9622..f79bb6b 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -49,7 +49,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_qmap.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 76
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_TRAP_RCV_C
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_ucast_cache.c b/opensm/osm_ucast_cache.c
index 3a6eda5..701b8a8 100644
--- a/opensm/osm_ucast_cache.c
+++ b/opensm/osm_ucast_cache.c
@@ -53,7 +53,8 @@
 #include <complib/cl_qmap.h>
 #include <complib/cl_pool.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 77
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_UCAST_CACHE_C
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_ucast_mgr.h>
 #include <opensm/osm_ucast_cache.h>
diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index 20b02cb..d6d65b1 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -47,7 +47,8 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#define FILE_ID 88
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_UCAST_DFSSSP_C
 #include <opensm/osm_ucast_mgr.h>
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/osm_ucast_dnup.c b/opensm/osm_ucast_dnup.c
index 2afff79..d3e5383 100644
--- a/opensm/osm_ucast_dnup.c
+++ b/opensm/osm_ucast_dnup.c
@@ -49,7 +49,8 @@
 #include <ctype.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qmap.h>
-#define FILE_ID 78
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_UCAST_DNUP_C
 #include <opensm/osm_switch.h>
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_ucast_mgr.h>
diff --git a/opensm/osm_ucast_file.c b/opensm/osm_ucast_file.c
index 9e0c951..6eeb144 100644
--- a/opensm/osm_ucast_file.c
+++ b/opensm/osm_ucast_file.c
@@ -49,7 +49,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_qmap.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 79
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_UCAST_FILE_C
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_switch.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 225f248..532a29f 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -51,7 +51,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_qmap.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 80
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_UCAST_FTREE_C
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_switch.h>
 
diff --git a/opensm/osm_ucast_lash.c b/opensm/osm_ucast_lash.c
index ad3e04a..6de7d31 100644
--- a/opensm/osm_ucast_lash.c
+++ b/opensm/osm_ucast_lash.c
@@ -52,7 +52,8 @@
 #include <errno.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qmap.h>
-#define FILE_ID 81
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_UCAST_LASH_C
 #include <opensm/osm_switch.h>
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index aa0e78a..f33cc4c 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -51,7 +51,8 @@
 #include <complib/cl_qmap.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qlist.h>
-#define FILE_ID 82
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_UCAST_MGR_C
 #include <opensm/osm_ucast_mgr.h>
 #include <opensm/osm_sm.h>
 #include <opensm/osm_log.h>
diff --git a/opensm/osm_ucast_updn.c b/opensm/osm_ucast_updn.c
index 5ae48a8..d6877fe 100644
--- a/opensm/osm_ucast_updn.c
+++ b/opensm/osm_ucast_updn.c
@@ -48,7 +48,8 @@
 #include <ctype.h>
 #include <complib/cl_debug.h>
 #include <complib/cl_qmap.h>
-#define FILE_ID 83
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_UCAST_UPDN_C
 #include <opensm/osm_switch.h>
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_ucast_mgr.h>
diff --git a/opensm/osm_vl15intf.c b/opensm/osm_vl15intf.c
index ddcff45..3f19c5c 100644
--- a/opensm/osm_vl15intf.c
+++ b/opensm/osm_vl15intf.c
@@ -48,7 +48,8 @@
 #include <string.h>
 #include <iba/ib_types.h>
 #include <complib/cl_thread.h>
-#define FILE_ID 85
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_VL15INTF_C
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_vl15intf.h>
 #include <opensm/osm_madw.h>
diff --git a/opensm/osm_vl_arb_rcv.c b/opensm/osm_vl_arb_rcv.c
index 557f6a6..b8b6136 100644
--- a/opensm/osm_vl_arb_rcv.c
+++ b/opensm/osm_vl_arb_rcv.c
@@ -50,7 +50,8 @@
 #include <iba/ib_types.h>
 #include <complib/cl_passivelock.h>
 #include <complib/cl_debug.h>
-#define FILE_ID 86
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_VL_ARB_RCV_C
 #include <opensm/osm_madw.h>
 #include <opensm/osm_log.h>
 #include <opensm/osm_node.h>
diff --git a/opensm/st.c b/opensm/st.c
index ed8af34..754648c 100644
--- a/opensm/st.c
+++ b/opensm/st.c
@@ -41,7 +41,8 @@
 
 #include <stdio.h>
 #include <string.h>
-#define FILE_ID 87
+#include <opensm/osm_file_ids.h>
+#define FILE_ID OSM_FILE_ST_C
 #include <opensm/st.h>
 
 typedef struct st_table_entry st_table_entry;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
