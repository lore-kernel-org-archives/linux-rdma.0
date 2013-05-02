From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 1/1] OpenSM: dfsssp - add support for multicast
Date: Thu,  2 May 2013 21:15:26 +0900
Message-ID: <1367496926-6824-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Recent tests on a large system revealed a problem with loops in the multicast routing.
Using DFSSSP together with the default mcast routing algorithm of OpenSM can
produce loops in the fabric.

This patch adds the mcast_build_stree function to the DFSSSP routing algorithm,
so that DFSSSP is able to calculate the correct mcast forwarding tables for the
subnet.

It almost does the same steps as the default mcast routing, except that it
uses the Dijkstra algorithm to generate the spanning tree instead of using the
hop count information given by the unicast routing.

General overview of the algorithm in pseudo-code:
1) identify the ports, which are part of the multicast group
2) find the 'best' switch (depending on the hop count) for the mcast group,
   which can be used as a root of the spanning tree
3) perform a dijkstra step with the root switch as starting point
   to generate a spanning tree to all other switches in the subnet
4) build the mcast forwarding tables for relevant switches:
   4.1) select a switch which has mcast member ports connected to it
   4.2) set the downstream ports for the mcast member ports in the mcft
   4.3) traverse towards the root of the spanning tree and set up-/downstream
        ports on this path for all involved switches
   4.4) goto 4.1 until all switches have been processed

The same mcast algorithm will be used for SSSP, because SSSP has the potential to
produce loops in the mcast forwarding table as well.

Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 include/opensm/osm_mcast_mgr.h |   72 +++++++++++++++
 opensm/Makefile.am             |    1 +
 opensm/osm_mcast_mgr.c         |   35 ++++----
 opensm/osm_ucast_dfsssp.c      |  194 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 283 insertions(+), 19 deletions(-)
 create mode 100644 include/opensm/osm_mcast_mgr.h

diff --git a/include/opensm/osm_mcast_mgr.h b/include/opensm/osm_mcast_mgr.h
new file mode 100644
index 0000000..291a478
--- /dev/null
+++ b/include/opensm/osm_mcast_mgr.h
@@ -0,0 +1,72 @@
+/*
+ * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
+ * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2009-2011 ZIH, TU Dresden, Federal Republic of Germany. All rights reserved.
+ * Copyright (C) 2012-2013 Tokyo Institute of Technology. All rights reserved.
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
+ * 	Declaration of osm_mcast_work_obj_t.
+ * 	Provide access to a mcast function which searches the root swicth for
+ * 	a spanning tree.
+ */
+
+#ifndef _OSM_MCAST_MGR_H_
+#define _OSM_MCAST_MGR_H_
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
+typedef struct osm_mcast_work_obj {
+	cl_list_item_t list_item;
+	osm_port_t *p_port;
+	cl_map_item_t map_item;
+} osm_mcast_work_obj_t;
+
+int osm_mcast_make_port_list_and_map(cl_qlist_t * list, cl_qmap_t * map,
+				     osm_mgrp_box_t * mbox);
+
+void osm_mcast_drop_port_list(cl_qlist_t * list);
+
+osm_switch_t * osm_mcast_mgr_find_root_switch(osm_sm_t * sm, cl_qlist_t * list);
+
+END_C_DECLS
+#endif				/* _OSM_MCAST_MGR_H_ */
diff --git a/opensm/Makefile.am b/opensm/Makefile.am
index 7fd6bc6..20318cc 100644
--- a/opensm/Makefile.am
+++ b/opensm/Makefile.am
@@ -116,6 +116,7 @@ opensminclude_HEADERS = \
 	$(srcdir)/../include/opensm/osm_subnet.h \
 	$(srcdir)/../include/opensm/osm_switch.h \
 	$(srcdir)/../include/opensm/osm_ucast_mgr.h \
+	$(srcdir)/../include/opensm/osm_mcast_mgr.h \
 	$(srcdir)/../include/opensm/osm_ucast_cache.h \
 	$(srcdir)/../include/opensm/osm_vl15intf.h \
 	$(top_builddir)/include/opensm/osm_version.h \
diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
index fea0a69..58e36ac 100644
--- a/opensm/osm_mcast_mgr.c
+++ b/opensm/osm_mcast_mgr.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
  * Copyright (c) 2010 HNR Consulting. All rights reserved.
+ * Copyright (C) 2012-2013 Tokyo Institute of Technology. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -59,12 +60,7 @@
 #include <opensm/osm_switch.h>
 #include <opensm/osm_helper.h>
 #include <opensm/osm_msgdef.h>
-
-typedef struct osm_mcast_work_obj {
-	cl_list_item_t list_item;
-	osm_port_t *p_port;
-	cl_map_item_t map_item;
-} osm_mcast_work_obj_t;
+#include <opensm/osm_mcast_mgr.h>
 
 static osm_mcast_work_obj_t *mcast_work_obj_new(IN osm_port_t * p_port)
 {
@@ -89,16 +85,16 @@ static void mcast_work_obj_delete(IN osm_mcast_work_obj_t * p_wobj)
 	free(p_wobj);
 }
 
-static int make_port_list(cl_qlist_t * list, osm_mgrp_box_t * mbox)
+int osm_mcast_make_port_list_and_map(cl_qlist_t * list, cl_qmap_t * map,
+				     osm_mgrp_box_t * mbox)
 {
-	cl_qmap_t map;
 	cl_map_item_t *map_item;
 	cl_list_item_t *list_item;
 	osm_mgrp_t *mgrp;
 	osm_mcm_port_t *mcm_port;
 	osm_mcast_work_obj_t *wobj;
 
-	cl_qmap_init(&map);
+	cl_qmap_init(map);
 	cl_qlist_init(list);
 
 	for (list_item = cl_qlist_head(&mbox->mgrp_list);
@@ -111,21 +107,21 @@ static int make_port_list(cl_qlist_t * list, osm_mgrp_box_t * mbox)
 			/* Acquire the port object for this port guid, then
 			   create the new worker object to build the list. */
 			mcm_port = cl_item_obj(map_item, mcm_port, map_item);
-			if (cl_qmap_get(&map, mcm_port->port->guid) !=
-			    cl_qmap_end(&map))
+			if (cl_qmap_get(map, mcm_port->port->guid) !=
+			    cl_qmap_end(map))
 				continue;
 			wobj = mcast_work_obj_new(mcm_port->port);
 			if (!wobj)
 				return -1;
 			cl_qlist_insert_tail(list, &wobj->list_item);
-			cl_qmap_insert(&map, mcm_port->port->guid,
+			cl_qmap_insert(map, mcm_port->port->guid,
 				       &wobj->map_item);
 		}
 	}
 	return 0;
 }
 
-static void drop_port_list(cl_qlist_t * list)
+void osm_mcast_drop_port_list(cl_qlist_t * list)
 {
 	while (cl_qlist_count(list))
 		mcast_work_obj_delete((osm_mcast_work_obj_t *)
@@ -330,7 +326,7 @@ static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
 /**********************************************************************
    This function returns the existing or optimal root switch for the tree.
 **********************************************************************/
-static osm_switch_t *mcast_mgr_find_root_switch(osm_sm_t * sm, cl_qlist_t *list)
+osm_switch_t *osm_mcast_mgr_find_root_switch(osm_sm_t * sm, cl_qlist_t *list)
 {
 	osm_switch_t *p_sw = NULL;
 
@@ -494,7 +490,7 @@ static void mcast_mgr_purge_list(osm_sm_t * sm, cl_qlist_t * list)
 				osm_port_get_guid(wobj->p_port));
 		}
 	}
-	drop_port_list(list);
+	osm_mcast_drop_port_list(list);
 }
 
 /**********************************************************************
@@ -725,6 +721,7 @@ static ib_api_status_t mcast_mgr_build_spanning_tree(osm_sm_t * sm,
 						     osm_mgrp_box_t * mbox)
 {
 	cl_qlist_t port_list;
+	cl_qmap_t port_map;
 	uint32_t num_ports;
 	osm_switch_t *p_sw;
 	ib_api_status_t status = IB_SUCCESS;
@@ -741,7 +738,7 @@ static ib_api_status_t mcast_mgr_build_spanning_tree(osm_sm_t * sm,
 	osm_purge_mtree(sm, mbox);
 
 	/* build the first "subset" containing all member ports */
-	if (make_port_list(&port_list, mbox)) {
+	if (osm_mcast_make_port_list_and_map(&port_list, &port_map, mbox)) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A10: "
 			"Insufficient memory to make port list\n");
 		status = IB_ERROR;
@@ -753,7 +750,7 @@ static ib_api_status_t mcast_mgr_build_spanning_tree(osm_sm_t * sm,
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"MLID 0x%X has %u members - nothing to do\n",
 			mbox->mlid, num_ports);
-		drop_port_list(&port_list);
+		osm_mcast_drop_port_list(&port_list);
 		goto Exit;
 	}
 
@@ -773,12 +770,12 @@ static ib_api_status_t mcast_mgr_build_spanning_tree(osm_sm_t * sm,
 	   Locate the switch around which to create the spanning
 	   tree for this multicast group.
 	 */
-	p_sw = mcast_mgr_find_root_switch(sm, &port_list);
+	p_sw = osm_mcast_mgr_find_root_switch(sm, &port_list);
 	if (p_sw == NULL) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A08: "
 			"Unable to locate a suitable switch for group 0x%X\n",
 			mbox->mlid);
-		drop_port_list(&port_list);
+		osm_mcast_drop_port_list(&port_list);
 		status = IB_ERROR;
 		goto Exit;
 	}
diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index fd3b4c0..98c3f7c 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009-2011 ZIH, TU Dresden, Federal Republic of Germany. All rights reserved.
+ * Copyright (C) 2012-2013 Tokyo Institute of Technology. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -52,6 +53,8 @@
 #include <opensm/osm_ucast_mgr.h>
 #include <opensm/osm_opensm.h>
 #include <opensm/osm_node.h>
+#include <opensm/osm_multicast.h>
+#include <opensm/osm_mcast_mgr.h>
 
 /* "infinity" for dijkstra */
 #define INF      0x7FFFFFFF
@@ -1537,6 +1540,103 @@ static int update_lft(osm_ucast_mgr_t * p_mgr, vertex_t * adj_list,
 	return 0;
 }
 
+/* update the multicast forwarding tables of all switches with the informations
+   from the previous dijsktra step for the current mlid
+*/
+static int update_mcft(osm_sm_t * p_sm, vertex_t * adj_list,
+		       uint32_t adj_list_size, uint16_t mlid_ho,
+		       cl_qmap_t * port_map, osm_switch_t * root_sw)
+{
+	uint32_t i = 0;
+	uint8_t port = 0, remote_port = 0;
+	uint8_t upstream_port = 0, downstream_port = 0;
+	ib_net64_t guid = 0;
+	osm_switch_t *p_sw = NULL;
+	osm_node_t *remote_node = NULL;
+	osm_physp_t *p_physp = NULL;
+	osm_mcast_tbl_t *p_tbl = NULL;
+	vertex_t *curr_adj = NULL;
+
+	OSM_LOG_ENTER(p_sm->p_log);
+
+	for (i = 1; i < adj_list_size; i++) {
+		p_sw = adj_list[i].sw;
+		OSM_LOG(p_sm->p_log, OSM_LOG_VERBOSE,
+			"Processing switch 0x%016" PRIx64
+			" (%s) for MLID 0x%X\n", cl_ntoh64(adj_list[i].guid),
+			p_sw->p_node->print_desc, mlid_ho);
+
+		/* if a) no route goes thru this switch  or
+		      b) the switch does not support mcast  or
+		      c) no ports of this switch are part or the mcast group
+		   then cycle
+		 */
+		if (!(adj_list[i].used_link) ||
+		    osm_switch_supports_mcast(p_sw) == FALSE ||
+		    (p_sw->num_of_mcm == 0 && !(p_sw->is_mc_member)))
+			continue;
+
+		p_tbl = osm_switch_get_mcast_tbl_ptr(p_sw);
+
+		/* add all ports of this sw to the mcast table,
+		   if they are part of the mcast grp
+		 */
+		if (p_sw->is_mc_member)
+			osm_mcast_tbl_set(p_tbl, mlid_ho, 0);
+		for (port = 1; port < p_sw->num_ports; port++) {
+			/* get the node behind the port */
+			remote_node =
+				osm_node_get_remote_node(p_sw->p_node, port,
+							 &remote_port);
+			/* check if connected and its not the same switch */
+			if (!remote_node || remote_node->sw == p_sw)
+				continue;
+			/* make sure the link is healthy */
+			p_physp = osm_node_get_physp_ptr(p_sw->p_node, port);
+			if (!p_physp || !osm_link_is_healthy(p_physp))
+				continue;
+			/* we don't add upstream ports in this step */
+			if (osm_node_get_type(remote_node) != IB_NODE_TYPE_CA)
+				continue;
+
+			guid = osm_physp_get_port_guid(osm_node_get_physp_ptr(
+						       remote_node,
+						       remote_port));
+			if (cl_qmap_get(port_map, guid)
+			    != cl_qmap_end(port_map))
+				osm_mcast_tbl_set(p_tbl, mlid_ho, port);
+		}
+
+		/* now we have to add the upstream port of 'this' switch and
+		   the downstream port of the next switch to the mcast table
+		   until we reach the root_sw
+		 */
+		int counter;
+		counter = 0;
+		curr_adj = &adj_list[i];
+		while (curr_adj->sw != root_sw) {
+			/* the used_link is the link that was used in dijkstra to reach this node,
+			   so the to_port is the local (upstream) port on curr_adj->sw
+			 */
+			upstream_port = curr_adj->used_link->to_port;
+			osm_mcast_tbl_set(p_tbl, mlid_ho, upstream_port);
+
+			/* now we go one step in direction root_sw and add the
+			   downstream port for the spanning tree
+			 */
+			downstream_port = curr_adj->used_link->from_port;
+			p_tbl = osm_switch_get_mcast_tbl_ptr(
+				adj_list[curr_adj->used_link->from].sw);
+			osm_mcast_tbl_set(p_tbl, mlid_ho, downstream_port);
+
+			curr_adj = &adj_list[curr_adj->used_link->from];
+		}
+	}
+
+	OSM_LOG_EXIT(p_sm->p_log);
+	return 0;
+}
+
 /* increment the edge weights of the df-/sssp graph which represent the number
    of paths on this link
 */
@@ -2181,6 +2281,98 @@ static int dfsssp_do_dijkstra_routing(void *context)
 	return 0;
 }
 
+/* meta function which calls subfunctions for finding the optimal switch
+   for the spanning tree, performing a dijkstra step with this sw as root,
+   and calculating the mcast table for MLID
+*/
+static ib_api_status_t dfsssp_do_mcast_routing(void * context,
+					       osm_mgrp_box_t * mbox)
+{
+	dfsssp_context_t *dfsssp_ctx = (dfsssp_context_t *) context;
+	osm_ucast_mgr_t *p_mgr = (osm_ucast_mgr_t *) dfsssp_ctx->p_mgr;
+	osm_sm_t *sm = (osm_sm_t *) p_mgr->sm;
+	vertex_t *adj_list = (vertex_t *) dfsssp_ctx->adj_list;
+	uint32_t adj_list_size = dfsssp_ctx->adj_list_size;
+	cl_qlist_t mcastgrp_port_list;
+	cl_qmap_t mcastgrp_port_map;
+	osm_switch_t *root_sw = NULL;
+	osm_port_t *port = NULL;
+	ib_net16_t lid = 0;
+	uint32_t err = 0, num_ports = 0;
+	ib_api_status_t status = IB_SUCCESS;
+
+	OSM_LOG_ENTER(sm->p_log);
+
+	/* create a map and a list of all ports which are member in the mcast
+	   group; map for searching elements and list for iteration
+	 */
+	if (osm_mcast_make_port_list_and_map(&mcastgrp_port_list,
+					     &mcastgrp_port_map, mbox)) {
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR AD50: "
+                        "Insufficient memory to make port list\n");
+                status = IB_ERROR;
+                goto Exit;
+        }
+
+	num_ports = cl_qlist_count(&mcastgrp_port_list);
+	if (num_ports < 2) {
+		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
+			"MLID 0x%X has %u members - nothing to do\n",
+			mbox->mlid, num_ports);
+		goto Exit;
+	}
+
+	/* find the root switch for the spanning tree, which has the smallest
+	   hops count to all LIDs in the mcast group
+	 */
+	root_sw = osm_mcast_mgr_find_root_switch(sm, &mcastgrp_port_list);
+	if (!root_sw) {
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR AD51: "
+			"Unable to locate a suitable switch for group 0x%X\n",
+			mbox->mlid);
+		status = IB_ERROR;
+		goto Exit;
+	}
+
+	/* a) start one dijkstra step from the root switch to generate a
+	   spanning tree
+	   b) this might be a bit of an overkill to span the whole
+	   network, if there are only a few ports in the mcast group, but
+	   its only one dijkstra step for each mcast group and we did many
+	   steps before in the ucast routing for each LID in the subnet;
+	   c) we can use the subnet structure from the ucast routing, and
+	   don't even have to reset the link weights (=> therefore the mcast
+	   spanning tree will use less 'growded' links in the network)
+	   d) the mcast dfsssp algorithm will not change the link weights
+	 */
+	lid = osm_node_get_base_lid(root_sw->p_node, 0);
+	port = osm_get_port_by_lid(sm->p_subn, lid);
+	err = dijkstra(p_mgr, adj_list, adj_list_size, port, lid);
+	if (err) {
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR AD52: "
+			"Dijkstra step for mcast failed for group 0x%X\n",
+			mbox->mlid);
+		status = IB_ERROR;
+		goto Exit;
+	}
+
+	/* update the mcast forwarding tables of the switches */
+	err = update_mcft(sm, adj_list, adj_list_size, mbox->mlid,
+			  &mcastgrp_port_map, root_sw);
+	if (err) {
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR AD53: "
+			"Update of mcast forwarding tables failed for group 0x%X\n",
+			mbox->mlid);
+		status = IB_ERROR;
+		goto Exit;
+	}
+
+Exit:
+	osm_mcast_drop_port_list(&mcastgrp_port_list);
+	OSM_LOG_EXIT(sm->p_log);
+	return status;
+}
+
 /* called from extern in QP creation process to gain the the service level and
    the virtual lane respectively for a <s,d> pair
 */
@@ -2290,6 +2482,7 @@ int osm_ucast_dfsssp_setup(struct osm_routing_engine *r, osm_opensm_t * p_osm)
 	r->context = (void *)dfsssp_context;
 	r->build_lid_matrices = dfsssp_build_graph;
 	r->ucast_build_fwd_tables = dfsssp_do_dijkstra_routing;
+	r->mcast_build_stree = dfsssp_do_mcast_routing;
 	r->path_sl = get_dfsssp_sl;
 	r->destroy = delete;
 
@@ -2309,6 +2502,7 @@ int osm_ucast_sssp_setup(struct osm_routing_engine *r, osm_opensm_t * p_osm)
 	r->context = (void *)dfsssp_context;
 	r->build_lid_matrices = dfsssp_build_graph;
 	r->ucast_build_fwd_tables = dfsssp_do_dijkstra_routing;
+	r->mcast_build_stree = dfsssp_do_mcast_routing;
 	r->destroy = delete;
 
 	return 0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
