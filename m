From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 13/13] opensm: Handle SubnSet GUIDInfo asynchronously from
 GUIDInfoRecord handling
Date: Sat, 21 May 2011 10:22:17 -0400
Message-ID: <4DD7CA99.3080808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 4eb5e77f5f29432a587ae1da2a4e2e56b52174fc Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sat, 21 May 2011 17:17:34 +0300
Subject: [PATCH] opensm: Handle SubnSet GUIDInfo asynchronously from GUIDInfoRecord handling

Rather than initiate SubnSet of GUIDInfo when SubAdmSet/Delete GUIDInfoRecord
occurs, queue these for processing at appropriate time as determined by the
state manager. This allows for better operation when there are SMPs already
queued.

Also, issue SubnSet GUIDInfo when restoring SA database with GUIDInfoRecords
stored.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_base.h       |    3 +-
 include/opensm/osm_guid.h       |   66 ++++++++++++++++++
 include/opensm/osm_subnet.h     |    1 +
 opensm/Makefile.am              |    3 +-
 opensm/osm_drop_mgr.c           |   17 +++++-
 opensm/osm_guid_mgr.c           |  140 +++++++++++++++++++++++++++++++++++++++
 opensm/osm_helper.c             |    3 +-
 opensm/osm_sa.c                 |    5 +-
 opensm/osm_sa_guidinfo_record.c |   33 ++--------
 opensm/osm_state_mgr.c          |   15 ++++
 opensm/osm_subnet.c             |    5 ++
 11 files changed, 258 insertions(+), 33 deletions(-)
 create mode 100644 include/opensm/osm_guid.h
 create mode 100644 opensm/osm_guid_mgr.c

diff --git a/include/opensm/osm_base.h b/include/opensm/osm_base.h
index 17de12d..43653b9 100644
--- a/include/opensm/osm_base.h
+++ b/include/opensm/osm_base.h
@@ -847,7 +847,8 @@ typedef enum _osm_thread_state {
 #define OSM_SIGNAL_SWEEP			1
 #define OSM_SIGNAL_IDLE_TIME_PROCESS_REQUEST	2
 #define OSM_SIGNAL_PERFMGR_SWEEP		3
-#define OSM_SIGNAL_MAX				4
+#define OSM_SIGNAL_GUID_PROCESS_REQUEST		4
+#define OSM_SIGNAL_MAX				5
 
 typedef unsigned int osm_signal_t;
 /***********/
diff --git a/include/opensm/osm_guid.h b/include/opensm/osm_guid.h
new file mode 100644
index 0000000..2fa5f7f
--- /dev/null
+++ b/include/opensm/osm_guid.h
@@ -0,0 +1,66 @@
+/*
+ * Copyright (c) 2011 Mellanox Technologies LTD. All rights reserved.
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
+#ifndef _OSM_GUID_H_
+#define _OSM_GUID_H_
+
+#include <iba/ib_types.h>
+#include <complib/cl_list.h>
+#include <opensm/osm_sa.h>
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
+typedef struct osm_guidinfo_work_obj {
+	cl_list_item_t list_item;
+	osm_port_t *p_port;
+	uint8_t block_num;
+} osm_guidinfo_work_obj_t;
+
+osm_guidinfo_work_obj_t *osm_guid_work_obj_new(IN osm_port_t * p_port,
+					       IN uint8_t block_num);
+
+void osm_guid_work_obj_delete(IN osm_guidinfo_work_obj_t * p_wobj);
+
+int osm_queue_guidinfo(IN osm_sa_t *sa, IN osm_port_t *p_port,
+		       IN uint8_t block_num);
+
+END_C_DECLS
+#endif				/* _OSM_GUID_H_ */
diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 1205846..04cad82 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -534,6 +534,7 @@ typedef struct osm_subn {
 	cl_qmap_t sm_guid_tbl;
 	cl_qlist_t sa_sr_list;
 	cl_qlist_t sa_infr_list;
+	cl_qlist_t alias_guid_list;
 	cl_ptr_vector_t port_lid_tbl;
 	ib_net16_t master_sm_base_lid;
 	ib_net16_t sm_base_lid;
diff --git a/opensm/Makefile.am b/opensm/Makefile.am
index ec626bb..eee6fe2 100644
--- a/opensm/Makefile.am
+++ b/opensm/Makefile.am
@@ -29,7 +29,7 @@ opensm_LDFLAGS = -rdynamic
 opensm_DEPENDENCIES = libopensm.la
 opensm_SOURCES = main.c osm_console_io.c osm_console.c osm_db_files.c \
 		 osm_db_pack.c osm_drop_mgr.c osm_guid_info_rcv.c \
-		 osm_inform.c osm_lid_mgr.c osm_lin_fwd_rcv.c \
+		 osm_guid_mgr.c osm_inform.c osm_lid_mgr.c osm_lin_fwd_rcv.c \
 		 osm_link_mgr.c osm_mcast_fwd_rcv.c \
 		 osm_mcast_mgr.c osm_mcast_tbl.c \
 		 osm_mcm_port.c osm_mesh.c osm_mtree.c osm_multicast.c osm_node.c \
@@ -75,6 +75,7 @@ opensminclude_HEADERS = \
 	$(srcdir)/../include/opensm/osm_db_pack.h \
 	$(srcdir)/../include/opensm/osm_event_plugin.h \
 	$(srcdir)/../include/opensm/osm_errors.h \
+	$(srcdir)/../include/opensm/osm_guid.h \
 	$(srcdir)/../include/opensm/osm_helper.h \
 	$(srcdir)/../include/opensm/osm_inform.h \
 	$(srcdir)/../include/opensm/osm_ucast_lash.h \
diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index 9dba310..b339386 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  *
@@ -56,6 +56,7 @@
 #include <opensm/osm_router.h>
 #include <opensm/osm_switch.h>
 #include <opensm/osm_node.h>
+#include <opensm/osm_guid.h>
 #include <opensm/osm_helper.h>
 #include <opensm/osm_multicast.h>
 #include <opensm/osm_remote_sm.h>
@@ -162,6 +163,8 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
 	osm_node_t *p_node;
 	osm_remote_sm_t *p_sm;
 	osm_alias_guid_t *p_alias_guid, *p_alias_guid_check;
+	osm_guidinfo_work_obj_t *wobj;
+	cl_list_item_t *item, *next_item;
 	ib_gid_t port_gid;
 	ib_mad_notice_attr_t notice;
 	ib_api_status_t status;
@@ -209,6 +212,18 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
 			ib_get_err_str(status));
 	}
 
+	next_item = cl_qlist_head(&sm->p_subn->alias_guid_list);
+	while (next_item != cl_qlist_end(&sm->p_subn->alias_guid_list)) {
+		item = next_item;
+		next_item = cl_qlist_next(item);
+		wobj = cl_item_obj(item, wobj, list_item);
+		if (wobj->p_port == p_port) {
+			cl_qlist_remove_item(&sm->p_subn->alias_guid_list,
+					     &wobj->list_item);
+			osm_guid_work_obj_delete(wobj);
+		}
+	}
+
 	while (!cl_is_qlist_empty(&p_port->mcm_list)) {
 		mcm_port = cl_item_obj(cl_qlist_head(&p_port->mcm_list),
 				       mcm_port, list_item);
diff --git a/opensm/osm_guid_mgr.c b/opensm/osm_guid_mgr.c
new file mode 100644
index 0000000..7e43272
--- /dev/null
+++ b/opensm/osm_guid_mgr.c
@@ -0,0 +1,140 @@
+/*
+ * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
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
+ *    Implementation of osm_guid_mgr_t.
+ * This object implements the GUID manager object.
+ * This object is part of the opensm family of objects.
+ */
+
+#if HAVE_CONFIG_H
+#  include <config.h>
+#endif				/* HAVE_CONFIG_H */
+
+#include <string.h>
+#include <iba/ib_types.h>
+#include <complib/cl_debug.h>
+#include <complib/cl_qlist.h>
+#include <opensm/osm_port.h>
+#include <opensm/osm_node.h>
+#include <opensm/osm_guid.h>
+#include <opensm/osm_opensm.h>
+
+static void guidinfo_set(IN osm_sa_t *sa, IN osm_port_t *p_port,
+			 IN uint8_t block_num)
+{
+	uint8_t payload[IB_SMP_DATA_SIZE];
+	osm_madw_context_t context;
+	ib_api_status_t status;
+
+	memcpy(payload,
+	       &((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES]),
+	       sizeof(ib_guid_info_t));
+
+	context.gi_context.node_guid = osm_node_get_node_guid(p_port->p_node);
+	context.gi_context.port_guid = osm_physp_get_port_guid(p_port->p_physp);
+	context.gi_context.set_method = TRUE;
+	context.gi_context.port_num = osm_physp_get_port_num(p_port->p_physp);
+
+	status = osm_req_set(sa->sm, osm_physp_get_dr_path_ptr(p_port->p_physp),
+			     payload, sizeof(payload), IB_MAD_ATTR_GUID_INFO,
+			     cl_hton32((uint32_t)block_num),
+			     CL_DISP_MSGID_NONE, &context);
+	if (status != IB_SUCCESS)
+		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5109: "
+			"Failure initiating GUIDInfo request (%s)\n",
+			ib_get_err_str(status));
+}
+
+osm_guidinfo_work_obj_t *osm_guid_work_obj_new(IN osm_port_t * p_port,
+					       IN uint8_t block_num)
+{
+	osm_guidinfo_work_obj_t *p_obj;
+
+	/*
+	   clean allocated memory to avoid assertion when trying to insert to
+	   qlist.
+	   see cl_qlist_insert_tail(): CL_ASSERT(p_list_item->p_list != p_list)
+	*/
+	p_obj = calloc(1, sizeof(*p_obj));
+	if (p_obj) {
+		p_obj->p_port = p_port;
+		p_obj->block_num = block_num;
+	}
+
+	return p_obj;
+}
+
+void osm_guid_work_obj_delete(IN osm_guidinfo_work_obj_t * p_wobj)
+{
+	free(p_wobj);
+}
+
+int osm_queue_guidinfo(IN osm_sa_t *sa, IN osm_port_t *p_port,
+			IN uint8_t block_num)
+{
+	osm_guidinfo_work_obj_t *p_obj;
+	int status = 1;
+
+	p_obj = osm_guid_work_obj_new(p_port, block_num);
+	if (p_obj)
+		cl_qlist_insert_tail(&sa->p_subn->alias_guid_list,
+				     &p_obj->list_item);
+	else {
+		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 510F: "
+			"Memory allocation of guid work object failed\n");
+		status = 0;
+	}
+
+	return status;
+}
+
+void osm_guid_mgr_process(IN osm_sm_t * sm) {
+	osm_guidinfo_work_obj_t *p_obj;
+
+	OSM_LOG_ENTER(sm->p_log);
+
+	OSM_LOG(sm->p_log, OSM_LOG_DEBUG, "Processing alias guid list\n");
+
+	while (cl_qlist_count(&sm->p_subn->alias_guid_list)) {
+		p_obj = (osm_guidinfo_work_obj_t *) cl_qlist_remove_head(&sm->p_subn->alias_guid_list);
+		guidinfo_set(&sm->p_subn->p_osm->sa, p_obj->p_port,
+			     p_obj->block_num);
+		osm_guid_work_obj_delete(p_obj);
+	}
+
+	OSM_LOG_EXIT(sm->p_log);
+}
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index f7e80ea..50d3412 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -2015,7 +2015,8 @@ static const char *sm_signal_str[] = {
 	"OSM_SIGNAL_SWEEP",	/* 1 */
 	"OSM_SIGNAL_IDLE_TIME_PROCESS_REQUEST",	/* 2 */
 	"OSM_SIGNAL_PERFMGR_SWEEP",	/* 3 */
-	"UNKNOWN SIGNAL!!"	/* 4 */
+	"OSM_SIGNAL_GUID_PROCESS_REQUEST",	/* 4 */
+	"UNKNOWN SIGNAL!!"	/* 5 */
 };
 
 const char *osm_get_sm_signal_str(IN osm_signal_t signal)
diff --git a/opensm/osm_sa.c b/opensm/osm_sa.c
index 09d1423..54a1279 100644
--- a/opensm/osm_sa.c
+++ b/opensm/osm_sa.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  *
@@ -65,6 +65,7 @@
 #include <opensm/osm_multicast.h>
 #include <opensm/osm_inform.h>
 #include <opensm/osm_service.h>
+#include <opensm/osm_guid.h>
 #include <opensm/osm_helper.h>
 #include <vendor/osm_vendor_api.h>
 
@@ -940,6 +941,8 @@ static int load_guidinfo(osm_opensm_t * p_osm, ib_net64_t base_guid,
 	memcpy(&(*p_port->p_physp->p_guids)[gir->block_num * GUID_TABLE_MAX_ENTRIES],
 	       &gir->guid_info, sizeof(ib_guid_info_t));
 
+	osm_queue_guidinfo(&p_osm->sa, p_port, gir->block_num);
+
 _out:
 	cl_plock_release(&p_osm->lock);
 
diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index 1135f46..c792943 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -53,6 +53,7 @@
 #include <vendor/osm_vendor_api.h>
 #include <opensm/osm_port.h>
 #include <opensm/osm_node.h>
+#include <opensm/osm_guid.h>
 #include <opensm/osm_helper.h>
 #include <opensm/osm_pkey.h>
 #include <opensm/osm_sa.h>
@@ -368,32 +369,6 @@ static ib_net64_t sm_assigned_guid(uint8_t assigned_byte)
 			 (((uint64_t) OSM_VENDOR_ID_OPENIB) << 40));
 }
 
-static void guidinfo_set(IN osm_sa_t *sa, IN osm_port_t *p_port,
-			 IN uint8_t block_num)
-{
-	uint8_t payload[IB_SMP_DATA_SIZE];
-	osm_madw_context_t context;
-	ib_api_status_t status;
-
-	memcpy(payload,
-	       &((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES]),
-	       sizeof(ib_guid_info_t));
-
-	context.gi_context.node_guid = osm_node_get_node_guid(p_port->p_node);
-	context.gi_context.port_guid = osm_physp_get_port_guid(p_port->p_physp);
-	context.gi_context.set_method = TRUE;
-	context.gi_context.port_num = osm_physp_get_port_num(p_port->p_physp);
-
-	status = osm_req_set(sa->sm, osm_physp_get_dr_path_ptr(p_port->p_physp),
-			     payload, sizeof(payload), IB_MAD_ATTR_GUID_INFO,
-			     cl_hton32((uint32_t)block_num),
-			     CL_DISP_MSGID_NONE, &context);
-	if (status != IB_SUCCESS)
-		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5109: "
-			"Failure initiating GUIDInfo request (%s)\n",
-			ib_get_err_str(status));
-}
-
 static void del_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 			 IN osm_port_t *p_port, IN uint8_t block_num)
 {
@@ -476,7 +451,8 @@ static void del_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 	}
 
 	if (dirty) {
-		guidinfo_set(sa, p_port, block_num);
+		if (osm_queue_guidinfo(sa, p_port, block_num))
+			osm_sm_signal(sa->sm, OSM_SIGNAL_GUID_PROCESS_REQUEST);
 		sa->dirty = TRUE;
 	}
 
@@ -663,7 +639,8 @@ add_alias_guid:
 	}
 
 	if (dirty) {
-		guidinfo_set(sa, p_port, block_num);
+		if (osm_queue_guidinfo(sa, p_port, block_num))
+			osm_sm_signal(sa->sm, OSM_SIGNAL_GUID_PROCESS_REQUEST);
 		sa->dirty = TRUE;
 	}
 
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 131242d..069cea7 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -70,6 +70,7 @@ extern int osm_qos_setup(IN osm_opensm_t * p_osm);
 extern int osm_pkey_mgr_process(IN osm_opensm_t * p_osm);
 extern int osm_mcast_mgr_process(IN osm_sm_t * sm);
 extern int osm_link_mgr_process(IN osm_sm_t * sm, IN uint8_t state);
+extern void osm_guid_mgr_process(IN osm_sm_t * sm);
 
 static void state_mgr_up_msg(IN const osm_sm_t * sm)
 {
@@ -1358,6 +1359,11 @@ repeat_discovery:
 				"SWITCHES CONFIGURED FOR MULTICAST");
 	}
 
+	osm_guid_mgr_process(sm);
+	if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
+		return;
+	OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE, "ALIAS GUIDS CONFIGURED");
+
 	/*
 	 * The LINK_PORTS state is required since we cannot count on
 	 * the port state change MADs to succeed. This is an artifact
@@ -1438,6 +1444,12 @@ static void do_process_mgrp_queue(osm_sm_t * sm)
 	}
 }
 
+static void do_process_guid_queue(osm_sm_t *sm)
+{
+	osm_guid_mgr_process(sm);
+	wait_for_pending_transactions(&sm->p_subn->p_osm->stats);
+}
+
 void osm_state_mgr_process(IN osm_sm_t * sm, IN osm_signal_t signal)
 {
 	CL_ASSERT(sm);
@@ -1461,6 +1473,9 @@ void osm_state_mgr_process(IN osm_sm_t * sm, IN osm_signal_t signal)
 	case OSM_SIGNAL_IDLE_TIME_PROCESS_REQUEST:
 		do_process_mgrp_queue(sm);
 		break;
+	case OSM_SIGNAL_GUID_PROCESS_REQUEST:
+		do_process_guid_queue(sm);
+		break;
 	default:
 		CL_ASSERT(FALSE);
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3320: "
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index e8d5646..db59d36 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -64,6 +64,7 @@
 #include <opensm/osm_remote_sm.h>
 #include <opensm/osm_partition.h>
 #include <opensm/osm_node.h>
+#include <opensm/osm_guid.h>
 #include <opensm/osm_multicast.h>
 #include <opensm/osm_inform.h>
 #include <opensm/osm_console.h>
@@ -424,6 +425,7 @@ void osm_subn_construct(IN osm_subn_t * p_subn)
 	cl_qmap_init(&p_subn->sm_guid_tbl);
 	cl_qlist_init(&p_subn->sa_sr_list);
 	cl_qlist_init(&p_subn->sa_infr_list);
+	cl_qlist_init(&p_subn->alias_guid_list);
 	cl_qlist_init(&p_subn->prefix_routes_list);
 	cl_qmap_init(&p_subn->rtr_guid_tbl);
 	cl_qmap_init(&p_subn->prtn_pkey_tbl);
@@ -468,6 +470,9 @@ void osm_subn_destroy(IN osm_subn_t * p_subn)
 		osm_alias_guid_delete(&p_alias_guid);
 	}
 
+	while (cl_qlist_count(&p_subn->alias_guid_list))
+		osm_guid_work_obj_delete((osm_guidinfo_work_obj_t *) cl_qlist_remove_head(&p_subn->alias_guid_list));
+
 	p_next_port = (osm_port_t *) cl_qmap_head(&p_subn->port_guid_tbl);
 	while (p_next_port !=
 	       (osm_port_t *) cl_qmap_end(&p_subn->port_guid_tbl)) {
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
