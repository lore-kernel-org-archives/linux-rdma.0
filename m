From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] osm_mlid_box: infrastructure for mgid compression
Date: Thu, 12 Nov 2009 02:03:27 +0200
Message-ID: <20091112000327.GA7192@me>
References: <4AC2114E.3010303@Voltaire.COM>
 <20091111235959.GY7192@me>
 <20091112000224.GZ7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091112000224.GZ7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Slava Strebkov <slavas-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Now each MLID value is represented by collection of multicast groups
- osm_mgrp_box object. All multicast routing calculation and setup
operations are performed using those MLID indexed objects. Multicast
groups are kept as linked list in osm_mgrp_box and as before are globally
indexed by its MGIDs in SM DB, so SA operations are unchanged.

This model let us to implement an actual MGID to MLID compression by
just having multiple multicast groups placed in the list under same
osm_mgrp_box object.

All current functionality is preserved.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_multicast.h  |   66 ++++++-----
 opensm/include/opensm/osm_subnet.h     |   17 ++--
 opensm/opensm/osm_mcast_mgr.c          |  210 ++++++++++++++++----------------
 opensm/opensm/osm_multicast.c          |   57 ++++++++--
 opensm/opensm/osm_sa.c                 |   16 +--
 opensm/opensm/osm_sa_mcmember_record.c |   17 +--
 opensm/opensm/osm_subnet.c             |   10 +-
 7 files changed, 215 insertions(+), 178 deletions(-)

diff --git a/opensm/include/opensm/osm_multicast.h b/opensm/include/opensm/osm_multicast.h
index 59e4d0d..1da575d 100644
--- a/opensm/include/opensm/osm_multicast.h
+++ b/opensm/include/opensm/osm_multicast.h
@@ -97,8 +97,8 @@ BEGIN_C_DECLS
 */
 typedef struct osm_mgrp {
 	cl_fmap_item_t map_item;
+	cl_list_item_t list_item;
 	ib_net16_t mlid;
-	osm_mtree_node_t *p_root;
 	cl_qmap_t mcm_port_tbl;
 	ib_member_rec_t mcmember_rec;
 	boolean_t well_known;
@@ -109,15 +109,13 @@ typedef struct osm_mgrp {
 *	map_item
 *		Map Item for fmap linkage.  Must be first element!!
 *
+*	list_item
+*		List item for linkage in osm_mgrp_box's mgrp_list qlist.
+*
 *	mlid
 *		The network ordered LID of this Multicast Group (must be
 *		>= 0xC000).
 *
-*	p_root
-*		Pointer to the root "tree node" in the single spanning tree
-*		for this multicast group.  The nodes of the tree represent
-*		switches.  Member ports are not represented in the tree.
-*
 *	mcm_port_tbl
 *		Table (sorted by port GUID) of osm_mcm_port_t objects
 *		representing the member ports of this multicast group.
@@ -133,6 +131,37 @@ typedef struct osm_mgrp {
 * SEE ALSO
 *********/
 
+/****s* OpenSM: Multicast Group/osm_mgrp_box_t
+* NAME
+*	osm_mgrp_box_t
+*
+* DESCRIPTION
+*	Multicast structure which holds all multicast groups with same MLID.
+*
+* SYNOPSIS
+*/
+typedef struct osm_mgrp_box {
+	uint16_t mlid;
+	cl_qlist_t mgrp_list;
+	osm_mtree_node_t *root;
+} osm_mgrp_box_t;
+/*
+* FIELDS
+*	mlid
+*		The host ordered LID of this Multicast Group (must be
+*		>= 0xC000).
+*
+*	p_root
+*		Pointer to the root "tree node" in the single spanning tree
+*		for this multicast group.  The nodes of the tree represent
+*		switches.  Member ports are not represented in the tree.
+*
+*	mgrp_list
+*		List of multicast groups (mpgr object) having same MLID value.
+*
+* SEE ALSO
+*********/
+
 /****f* OpenSM: Multicast Group/osm_mgrp_new
 * NAME
 *	osm_mgrp_new
@@ -164,30 +193,6 @@ osm_mgrp_t *osm_mgrp_new(IN osm_subn_t * subn, IN ib_net16_t mlid,
 *	Multicast Group, osm_mgrp_delete
 *********/
 
-/****f* OpenSM: Multicast Group/osm_mgrp_delete
-* NAME
-*	osm_mgrp_delete
-*
-* DESCRIPTION
-*	Destroys and deallocates a Multicast Group.
-*
-* SYNOPSIS
-*/
-void osm_mgrp_delete(IN osm_mgrp_t * p_mgrp);
-/*
-* PARAMETERS
-*	p_mgrp
-*		[in] Pointer to an osm_mgrp_t object.
-*
-* RETURN VALUES
-*	None.
-*
-* NOTES
-*
-* SEE ALSO
-*	Multicast Group, osm_mgrp_new
-*********/
-
 /****f* OpenSM: Multicast Group/osm_mgrp_is_guid
 * NAME
 *	osm_mgrp_is_guid
@@ -378,6 +383,7 @@ void osm_mgrp_delete_port(IN osm_subn_t * subn, IN osm_log_t * log,
 void osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
 			  osm_mcm_port_t * mcm_port, ib_member_rec_t * mcmr);
 void osm_mgrp_cleanup(osm_subn_t * subn, osm_mgrp_t * mpgr);
+void osm_mgrp_box_delete(osm_mgrp_box_t *mbox);
 
 END_C_DECLS
 #endif				/* _OSM_MULTICAST_H_ */
diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 0302f91..fc60ced 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -518,7 +518,7 @@ typedef struct osm_subn {
 	boolean_t coming_out_of_standby;
 	unsigned need_update;
 	cl_fmap_t mgrp_mgid_tbl;
-	void *mgroups[IB_LID_MCAST_END_HO - IB_LID_MCAST_START_HO + 1];
+	void *mboxes[IB_LID_MCAST_END_HO - IB_LID_MCAST_START_HO + 1];
 } osm_subn_t;
 /*
 * FIELDS
@@ -643,9 +643,9 @@ typedef struct osm_subn {
 *		Container of pointers to all Multicast group objects in
 *		the subnet. Indexed by MGID.
 *
-*	mgroups
-*		Array of pointers to all Multicast Group objects in the subnet.
-*		Indexed by MLID offset from base MLID.
+*	mboxes
+*		Array of pointers to all Multicast MLID box objects in the
+*		subnet. Indexed by MLID offset from base MLID.
 *
 * SEE ALSO
 *	Subnet object
@@ -967,9 +967,9 @@ struct osm_port *osm_get_port_by_lid(const osm_subn_t * subn, ib_net16_t lid);
 *       Subnet object, osm_port_t
 *********/
 
-/****f* OpenSM: Subnet/osm_get_mgrp_by_mlid
+/****f* OpenSM: Subnet/osm_get_mbox_by_mlid
 * NAME
-*	osm_get_mgrp_by_mlid
+*	osm_get_mbox_by_mlid
 *
 * DESCRIPTION
 *	The looks for the given multicast group in the subnet table by mlid.
@@ -978,10 +978,9 @@ struct osm_port *osm_get_port_by_lid(const osm_subn_t * subn, ib_net16_t lid);
 *
 * SYNOPSIS
 */
-static inline
-struct osm_mgrp *osm_get_mgrp_by_mlid(osm_subn_t const *p_subn, ib_net16_t mlid)
+static inline struct osm_mgrp_box *osm_get_mbox_by_mlid(osm_subn_t const *p_subn, ib_net16_t mlid)
 {
-	return p_subn->mgroups[cl_ntoh16(mlid) - IB_LID_MCAST_START_HO];
+	return p_subn->mboxes[cl_ntoh16(mlid) - IB_LID_MCAST_START_HO];
 }
 /*
 * PARAMETERS
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index 7bd7add..8f08bb8 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -59,6 +59,7 @@
 typedef struct osm_mcast_work_obj {
 	cl_list_item_t list_item;
 	osm_port_t *p_port;
+	cl_map_item_t map_item;
 } osm_mcast_work_obj_t;
 
 static osm_mcast_work_obj_t *mcast_work_obj_new(IN const osm_port_t * p_port)
@@ -84,6 +85,49 @@ static void mcast_work_obj_delete(IN osm_mcast_work_obj_t * p_wobj)
 	free(p_wobj);
 }
 
+static int make_port_list(cl_qlist_t *list, osm_mgrp_box_t *mbox)
+{
+	cl_qmap_t map;
+	cl_map_item_t *map_item;
+	cl_list_item_t *list_item;
+	osm_mgrp_t *mgrp;
+	osm_mcm_port_t *mcm_port;
+	osm_mcast_work_obj_t *wobj;
+
+	cl_qmap_init(&map);
+	cl_qlist_init(list);
+
+	for (list_item = cl_qlist_head(&mbox->mgrp_list);
+	     list_item != cl_qlist_end(&mbox->mgrp_list);
+	     list_item = cl_qlist_next(list_item)) {
+		mgrp = cl_item_obj(list_item, mgrp, list_item);
+		for (map_item = cl_qmap_head(&mgrp->mcm_port_tbl);
+		     map_item != cl_qmap_end(&mgrp->mcm_port_tbl);
+		     map_item = cl_qmap_next(map_item)) {
+			/* Acquire the port object for this port guid, then
+			   create the new worker object to build the list. */
+			mcm_port = cl_item_obj(map_item, mcm_port, map_item);
+			if (cl_qmap_get(&map, mcm_port->port->guid) !=
+			    cl_qmap_end(&map))
+				continue;
+			wobj = mcast_work_obj_new(mcm_port->port);
+			if (!wobj)
+				return -1;
+			cl_qlist_insert_tail(list, &wobj->list_item);
+			cl_qmap_insert(&map, mcm_port->port->guid,
+				       &wobj->map_item);
+		}
+	}
+	return 0;
+}
+
+static void drop_port_list(cl_qlist_t * list)
+{
+	while (cl_qlist_count(list))
+		mcast_work_obj_delete(
+			(osm_mcast_work_obj_t *)cl_qlist_remove_head(list));
+}
+
 /**********************************************************************
  Recursively remove nodes from the tree
  *********************************************************************/
@@ -103,41 +147,36 @@ static void mcast_mgr_purge_tree_node(IN osm_mtree_node_t * p_mtn)
 	free(p_mtn);
 }
 
-static void mcast_mgr_purge_tree(osm_sm_t * sm, IN osm_mgrp_t * p_mgrp)
+static void mcast_mgr_purge_tree(osm_sm_t * sm, IN osm_mgrp_box_t * mbox)
 {
 	OSM_LOG_ENTER(sm->p_log);
 
-	if (p_mgrp->p_root)
-		mcast_mgr_purge_tree_node(p_mgrp->p_root);
+	if (mbox->root)
+		mcast_mgr_purge_tree_node(mbox->root);
 
-	p_mgrp->p_root = NULL;
+	mbox->root = NULL;
 
 	OSM_LOG_EXIT(sm->p_log);
 }
 
-static float osm_mcast_mgr_compute_avg_hops(osm_sm_t * sm,
-					    const osm_mgrp_t * p_mgrp,
+static float osm_mcast_mgr_compute_avg_hops(osm_sm_t * sm, cl_qlist_t * l,
 					    const osm_switch_t * p_sw)
 {
 	float avg_hops = 0;
 	uint32_t hops = 0;
 	uint32_t num_ports = 0;
-	const osm_mcm_port_t *p_mcm_port;
-	const cl_qmap_t *p_mcm_tbl;
+	cl_list_item_t *i;
+	osm_mcast_work_obj_t *wobj;
 
 	OSM_LOG_ENTER(sm->p_log);
 
-	p_mcm_tbl = &p_mgrp->mcm_port_tbl;
-
 	/*
 	   For each member of the multicast group, compute the
 	   number of hops to its base LID.
 	 */
-	for (p_mcm_port = (osm_mcm_port_t *) cl_qmap_head(p_mcm_tbl);
-	     p_mcm_port != (osm_mcm_port_t *) cl_qmap_end(p_mcm_tbl);
-	     p_mcm_port =
-	     (osm_mcm_port_t *) cl_qmap_next(&p_mcm_port->map_item)) {
-		hops += osm_switch_get_port_least_hops(p_sw, p_mcm_port->port);
+	for (i = cl_qlist_head(l); i != cl_qlist_end(l); i = cl_qlist_next(i)) {
+		wobj = cl_item_obj(i, wobj, list_item);
+		hops += osm_switch_get_port_least_hops(p_sw, wobj->p_port);
 		num_ports++;
 	}
 
@@ -157,28 +196,23 @@ static float osm_mcast_mgr_compute_avg_hops(osm_sm_t * sm,
  Calculate the maximal "min hops" from the given switch to any
  of the group HCAs
  **********************************************************************/
-static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm,
-					    const osm_mgrp_t * p_mgrp,
+static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qlist_t * l,
 					    const osm_switch_t * p_sw)
 {
 	uint32_t max_hops = 0;
 	uint32_t hops = 0;
-	const osm_mcm_port_t *p_mcm_port;
-	const cl_qmap_t *p_mcm_tbl;
+	cl_list_item_t *i;
+	osm_mcast_work_obj_t *wobj;
 
 	OSM_LOG_ENTER(sm->p_log);
 
-	p_mcm_tbl = &p_mgrp->mcm_port_tbl;
-
 	/*
 	   For each member of the multicast group, compute the
 	   number of hops to its base LID.
 	 */
-	for (p_mcm_port = (osm_mcm_port_t *) cl_qmap_head(p_mcm_tbl);
-	     p_mcm_port != (osm_mcm_port_t *) cl_qmap_end(p_mcm_tbl);
-	     p_mcm_port =
-	     (osm_mcm_port_t *) cl_qmap_next(&p_mcm_port->map_item)) {
-		hops = osm_switch_get_port_least_hops(p_sw, p_mcm_port->port);
+	for (i = cl_qlist_head(l); i != cl_qlist_end(l); i = cl_qlist_next(i)) {
+		wobj = cl_item_obj(i, wobj, list_item);
+		hops = osm_switch_get_port_least_hops(p_sw, wobj->p_port);
 		if (hops > max_hops)
 			max_hops = hops;
 	}
@@ -200,7 +234,7 @@ static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm,
    of the multicast group.
 **********************************************************************/
 static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
-						   const osm_mgrp_t * p_mgrp)
+						   cl_qlist_t *list)
 {
 	cl_qmap_t *p_sw_tbl;
 	const osm_switch_t *p_sw;
@@ -217,8 +251,6 @@ static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
 
 	p_sw_tbl = &sm->p_subn->sw_guid_tbl;
 
-	CL_ASSERT(!osm_mgrp_is_empty(p_mgrp));
-
 	for (p_sw = (osm_switch_t *) cl_qmap_head(p_sw_tbl);
 	     p_sw != (osm_switch_t *) cl_qmap_end(p_sw_tbl);
 	     p_sw = (osm_switch_t *) cl_qmap_next(&p_sw->map_item)) {
@@ -226,9 +258,9 @@ static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
 			continue;
 
 		if (use_avg_hops)
-			hops = osm_mcast_mgr_compute_avg_hops(sm, p_mgrp, p_sw);
+			hops = osm_mcast_mgr_compute_avg_hops(sm, list, p_sw);
 		else
-			hops = osm_mcast_mgr_compute_max_hops(sm, p_mgrp, p_sw);
+			hops = osm_mcast_mgr_compute_max_hops(sm, list, p_sw);
 
 		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 			"Switch 0x%016" PRIx64 ", hops = %f\n",
@@ -256,8 +288,7 @@ static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
 /**********************************************************************
    This function returns the existing or optimal root swtich for the tree.
 **********************************************************************/
-static osm_switch_t *mcast_mgr_find_root_switch(osm_sm_t * sm,
-						const osm_mgrp_t * p_mgrp)
+static osm_switch_t *mcast_mgr_find_root_switch(osm_sm_t * sm, cl_qlist_t *list)
 {
 	const osm_switch_t *p_sw = NULL;
 
@@ -269,7 +300,7 @@ static osm_switch_t *mcast_mgr_find_root_switch(osm_sm_t * sm,
 	   the root will be always on the first switch attached to it.
 	   - Very bad ...
 	 */
-	p_sw = mcast_mgr_find_optimal_switch(sm, p_mgrp);
+	p_sw = mcast_mgr_find_optimal_switch(sm, list);
 
 	OSM_LOG_EXIT(sm->p_log);
 	return (osm_switch_t *) p_sw;
@@ -342,19 +373,16 @@ static int mcast_mgr_set_mft_block(osm_sm_t * sm, IN osm_switch_t * p_sw,
   spanning tree that emanate from this switch.  On input, the p_list
   contains the group members that must be routed from this switch.
 **********************************************************************/
-static void mcast_mgr_subdivide(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
+static void mcast_mgr_subdivide(osm_sm_t * sm, uint16_t mlid_ho,
 				osm_switch_t * p_sw, cl_qlist_t * p_list,
 				cl_qlist_t * list_array, uint8_t array_size)
 {
 	uint8_t port_num;
-	uint16_t mlid_ho;
 	boolean_t ignore_existing;
 	osm_mcast_work_obj_t *p_wobj;
 
 	OSM_LOG_ENTER(sm->p_log);
 
-	mlid_ho = cl_ntoh16(osm_mgrp_get_mlid(p_mgrp));
-
 	/*
 	   For Multicast Groups, we don't want to count on previous
 	   configurations - since we can easily generate a storm
@@ -417,21 +445,20 @@ static void mcast_mgr_subdivide(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 	OSM_LOG_EXIT(sm->p_log);
 }
 
-static void mcast_mgr_purge_list(osm_sm_t * sm, cl_qlist_t * p_list)
+static void mcast_mgr_purge_list(osm_sm_t * sm, cl_qlist_t * list)
 {
-	osm_mcast_work_obj_t *p_wobj;
-
-	OSM_LOG_ENTER(sm->p_log);
-
-	while ((p_wobj = (osm_mcast_work_obj_t *) cl_qlist_remove_head(p_list))
-	       != (osm_mcast_work_obj_t *) cl_qlist_end(p_list)) {
-		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A06: "
-			"Unable to route for port 0x%" PRIx64 "\n",
-			osm_port_get_guid(p_wobj->p_port));
-		mcast_work_obj_delete(p_wobj);
+	if (osm_log_is_active(sm->p_log, OSM_LOG_ERROR)) {
+		osm_mcast_work_obj_t *wobj;
+		cl_list_item_t *i;
+		for (i = cl_qlist_head(list); i != cl_qlist_end(list);
+		     i = cl_qlist_next(i)) {
+			wobj = cl_item_obj(i, wobj, list_item);
+			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A06: "
+				"Unable to route for port 0x%" PRIx64 "\n",
+				osm_port_get_guid(wobj->p_port));
+		}
 	}
-
-	OSM_LOG_EXIT(sm->p_log);
+	drop_port_list(list);
 }
 
 /**********************************************************************
@@ -441,7 +468,7 @@ static void mcast_mgr_purge_list(osm_sm_t * sm, cl_qlist_t * p_list)
 
   The function returns the newly created mtree node element.
 **********************************************************************/
-static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
+static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, uint16_t mlid_ho,
 					  osm_switch_t * p_sw,
 					  cl_qlist_t * p_list, uint8_t depth,
 					  uint8_t upstream_port,
@@ -456,7 +483,6 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 	osm_mcast_work_obj_t *p_wobj;
 	cl_qlist_t *p_port_list;
 	size_t count;
-	uint16_t mlid_ho;
 	osm_mcast_tbl_t *p_tbl;
 
 	OSM_LOG_ENTER(sm->p_log);
@@ -467,7 +493,6 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 
 	node_guid = osm_node_get_node_guid(p_sw->p_node);
 	node_guid_ho = cl_ntoh64(node_guid);
-	mlid_ho = cl_ntoh16(osm_mgrp_get_mlid(p_mgrp));
 
 	OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 		"Routing MLID 0x%X through switch 0x%" PRIx64
@@ -544,7 +569,7 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 	for (i = 0; i < max_children; i++)
 		cl_qlist_init(&list_array[i]);
 
-	mcast_mgr_subdivide(sm, p_mgrp, p_sw, p_list, list_array, max_children);
+	mcast_mgr_subdivide(sm, mlid_ho, p_sw, p_list, list_array, max_children);
 
 	p_tbl = osm_switch_get_mcast_tbl_ptr(p_sw);
 
@@ -627,7 +652,7 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, osm_mgrp_t * p_mgrp,
 			CL_ASSERT(p_remote_physp);
 
 			p_mtn->child_array[i] =
-			    mcast_mgr_branch(sm, p_mgrp, p_remote_node->sw,
+			    mcast_mgr_branch(sm, mlid_ho, p_remote_node->sw,
 					     p_port_list, depth,
 					     osm_physp_get_port_num
 					     (p_remote_physp), p_max_depth);
@@ -661,36 +686,37 @@ Exit:
 }
 
 static ib_api_status_t mcast_mgr_build_spanning_tree(osm_sm_t * sm,
-						     osm_mgrp_t * p_mgrp)
+						     osm_mgrp_box_t * mbox)
 {
-	const cl_qmap_t *p_mcm_tbl;
-	const osm_mcm_port_t *p_mcm_port;
-	uint32_t num_ports;
 	cl_qlist_t port_list;
+	uint32_t num_ports;
 	osm_switch_t *p_sw;
-	osm_mcast_work_obj_t *p_wobj;
 	ib_api_status_t status = IB_SUCCESS;
 	uint8_t max_depth = 0;
-	uint32_t count;
 
 	OSM_LOG_ENTER(sm->p_log);
 
-	cl_qlist_init(&port_list);
-
 	/*
 	   TO DO - for now, just blow away the old tree.
 	   In the future we'll need to construct the tree based
 	   on multicast forwarding table information if the user wants to
 	   preserve existing multicast routes.
 	 */
-	mcast_mgr_purge_tree(sm, p_mgrp);
+	mcast_mgr_purge_tree(sm, mbox);
+
+	/* build the first "subset" containing all member ports */
+	if (make_port_list(&port_list, mbox)) {
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A10: "
+			"Insufficient memory to make port list\n");
+		status = IB_ERROR;
+		goto Exit;
+	}
 
-	p_mcm_tbl = &p_mgrp->mcm_port_tbl;
-	num_ports = cl_qmap_count(p_mcm_tbl);
+	num_ports = cl_qlist_count(&port_list);
 	if (num_ports == 0) {
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"MLID 0x%X has no members - nothing to do\n",
-			cl_ntoh16(osm_mgrp_get_mlid(p_mgrp)));
+			mbox->mlid);
 		goto Exit;
 	}
 
@@ -710,46 +736,22 @@ static ib_api_status_t mcast_mgr_build_spanning_tree(osm_sm_t * sm,
 	   Locate the switch around which to create the spanning
 	   tree for this multicast group.
 	 */
-	p_sw = mcast_mgr_find_root_switch(sm, p_mgrp);
+	p_sw = mcast_mgr_find_root_switch(sm, &port_list);
 	if (p_sw == NULL) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A08: "
 			"Unable to locate a suitable switch for group 0x%X\n",
-			cl_ntoh16(osm_mgrp_get_mlid(p_mgrp)));
+			mbox->mlid);
+		drop_port_list(&port_list);
 		status = IB_ERROR;
 		goto Exit;
 	}
 
-	/*
-	   Build the first "subset" containing all member ports.
-	 */
-	for (p_mcm_port = (osm_mcm_port_t *) cl_qmap_head(p_mcm_tbl);
-	     p_mcm_port != (osm_mcm_port_t *) cl_qmap_end(p_mcm_tbl);
-	     p_mcm_port =
-	     (osm_mcm_port_t *) cl_qmap_next(&p_mcm_port->map_item)) {
-		/*
-		   Acquire the port object for this port guid, then create
-		   the new worker object to build the list.
-		 */
-		p_wobj = mcast_work_obj_new(p_mcm_port->port);
-		if (p_wobj == NULL) {
-			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A10: "
-				"Insufficient memory to route port 0x%016"
-				PRIx64 "\n",
-				cl_ntoh64(osm_port_get_guid(p_mcm_port->port)));
-			continue;
-		}
-
-		cl_qlist_insert_tail(&port_list, &p_wobj->list_item);
-	}
-
-	count = cl_qlist_count(&port_list);
-	p_mgrp->p_root = mcast_mgr_branch(sm, p_mgrp, p_sw, &port_list, 0, 0,
-					  &max_depth);
+	mbox->root = mcast_mgr_branch(sm, mbox->mlid, p_sw, &port_list, 0, 0,
+				      &max_depth);
 
 	OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 		"Configured MLID 0x%X for %u ports, max tree depth = %u\n",
-		cl_ntoh16(osm_mgrp_get_mlid(p_mgrp)), count, max_depth);
-
+		mbox->mlid, num_ports, max_depth);
 Exit:
 	OSM_LOG_EXIT(sm->p_log);
 	return status;
@@ -951,7 +953,7 @@ Exit:
 static ib_api_status_t mcast_mgr_process_mlid(osm_sm_t * sm, uint16_t mlid)
 {
 	ib_api_status_t status = IB_SUCCESS;
-	osm_mgrp_t *mgrp;
+	osm_mgrp_box_t *mbox;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -963,9 +965,9 @@ static ib_api_status_t mcast_mgr_process_mlid(osm_sm_t * sm, uint16_t mlid)
 	   port in the group. */
 	mcast_mgr_clear(sm, mlid);
 
-	mgrp = osm_get_mgrp_by_mlid(sm->p_subn, cl_hton16(mlid));
-	if (mgrp) {
-		status = mcast_mgr_build_spanning_tree(sm, mgrp);
+	mbox = osm_get_mbox_by_mlid(sm->p_subn, cl_hton16(mlid));
+	if (mbox) {
+		status = mcast_mgr_build_spanning_tree(sm, mbox);
 		if (status != IB_SUCCESS)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A17: "
 				"Unable to create spanning tree (%s) for mlid "
@@ -1029,7 +1031,7 @@ static int alloc_mfts(osm_sm_t * sm)
 
 	for (i = sm->p_subn->max_mcast_lid_ho - IB_LID_MCAST_START_HO; i >= 0;
 	     i--)
-		if (sm->p_subn->mgroups[i])
+		if (sm->p_subn->mboxes[i])
 			break;
 	if (i < 0)
 		return 0;
@@ -1072,7 +1074,7 @@ int osm_mcast_mgr_process(osm_sm_t * sm)
 
 	for (i = 0; i <= sm->p_subn->max_mcast_lid_ho - IB_LID_MCAST_START_HO;
 	     i++)
-		if (sm->p_subn->mgroups[i] || sm->mlids_req[i])
+		if (sm->p_subn->mboxes[i] || sm->mlids_req[i])
 			mcast_mgr_process_mlid(sm, i + IB_LID_MCAST_START_HO);
 
 	memset(sm->mlids_req, 0, sm->mlids_req_max);
diff --git a/opensm/opensm/osm_multicast.c b/opensm/opensm/osm_multicast.c
index ff607e1..89f4b28 100644
--- a/opensm/opensm/osm_multicast.c
+++ b/opensm/opensm/osm_multicast.c
@@ -51,7 +51,26 @@
 #include <opensm/osm_inform.h>
 #include <opensm/osm_opensm.h>
 
-void osm_mgrp_delete(IN osm_mgrp_t * p_mgrp)
+static osm_mgrp_box_t *mgrp_box_new(uint16_t mlid)
+{
+	osm_mgrp_box_t *mbox = malloc(sizeof(*mbox));
+	if (!mbox)
+		return NULL;
+
+	memset(mbox, 0, sizeof(*mbox));
+	mbox->mlid = mlid;
+	cl_qlist_init(&mbox->mgrp_list);
+
+	return mbox;
+}
+
+void mgrp_box_delete(osm_mgrp_box_t *mbox)
+{
+	osm_mtree_destroy(mbox->root);
+	free(mbox);
+}
+
+void mgrp_delete(IN osm_mgrp_t * p_mgrp)
 {
 	osm_mcm_port_t *p_mcm_port;
 	osm_mcm_port_t *p_next_mcm_port;
@@ -67,16 +86,26 @@ void osm_mgrp_delete(IN osm_mgrp_t * p_mgrp)
 		    (osm_mcm_port_t *) cl_qmap_next(&p_mcm_port->map_item);
 		osm_mcm_port_delete(p_mcm_port);
 	}
-	/* destroy the mtree_node structure */
-	osm_mtree_destroy(p_mgrp->p_root);
 
 	free(p_mgrp);
 }
 
+void osm_mgrp_box_delete(osm_mgrp_box_t *mbox)
+{
+	osm_mgrp_t *mgrp;
+	while(cl_qlist_count(&mbox->mgrp_list)) {
+		mgrp = cl_item_obj(cl_qlist_remove_head(&mbox->mgrp_list),
+				   mgrp, list_item);
+		mgrp_delete(mgrp);
+	}
+	mgrp_box_delete(mbox);
+}
+
 osm_mgrp_t *osm_mgrp_new(IN osm_subn_t * subn, IN ib_net16_t mlid,
 			 IN ib_member_rec_t * mcmr)
 {
 	osm_mgrp_t *p_mgrp;
+	osm_mgrp_box_t *mbox;
 
 	p_mgrp = (osm_mgrp_t *) malloc(sizeof(*p_mgrp));
 	if (!p_mgrp)
@@ -87,23 +116,29 @@ osm_mgrp_t *osm_mgrp_new(IN osm_subn_t * subn, IN ib_net16_t mlid,
 	p_mgrp->mlid = mlid;
 	p_mgrp->mcmember_rec = *mcmr;
 
+	mbox = osm_get_mbox_by_mlid(subn, p_mgrp->mlid);
+	if (!mbox && !(mbox = mgrp_box_new(cl_ntoh16(p_mgrp->mlid)))) {
+		free(p_mgrp);
+		return NULL;
+	}
+
+	cl_qlist_insert_tail(&mbox->mgrp_list, &p_mgrp->list_item);
+	subn->mboxes[mbox->mlid - IB_LID_MCAST_START_HO] = mbox;
+
 	cl_fmap_insert(&subn->mgrp_mgid_tbl, &p_mgrp->mcmember_rec.mgid,
 		       &p_mgrp->map_item);
-	subn->mgroups[cl_ntoh16(p_mgrp->mlid) - IB_LID_MCAST_START_HO] = p_mgrp;
 
 	return p_mgrp;
 }
 
 void osm_mgrp_cleanup(osm_subn_t * subn, osm_mgrp_t * mgrp)
 {
+	osm_mgrp_box_t *mbox;
 	osm_mcm_port_t *mcm_port;
 
 	if (mgrp->full_members)
 		return;
 
-	osm_mtree_destroy(mgrp->p_root);
-	mgrp->p_root = NULL;
-
 	while (cl_qmap_count(&mgrp->mcm_port_tbl)) {
 		mcm_port = (osm_mcm_port_t *)cl_qmap_head(&mgrp->mcm_port_tbl);
 		cl_qmap_remove_item(&mgrp->mcm_port_tbl, &mcm_port->map_item);
@@ -116,7 +151,13 @@ void osm_mgrp_cleanup(osm_subn_t * subn, osm_mgrp_t * mgrp)
 		return;
 
 	cl_fmap_remove_item(&subn->mgrp_mgid_tbl, &mgrp->map_item);
-	subn->mgroups[cl_ntoh16(mgrp->mlid) - IB_LID_MCAST_START_HO] = NULL;
+
+	mbox = osm_get_mbox_by_mlid(subn, mgrp->mlid);
+	cl_qlist_remove_item(&mbox->mgrp_list, &mgrp->list_item);
+	if (cl_is_qlist_empty(&mbox->mgrp_list)) {
+		subn->mboxes[cl_ntoh16(mgrp->mlid) - IB_LID_MCAST_START_HO] = NULL;
+		mgrp_box_delete(mbox);
+	}
 	free(mgrp);
 }
 
diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index 2db8ba2..c4d86c7 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -684,18 +684,15 @@ static void sa_dump_all_sa(osm_opensm_t * p_osm, FILE * file)
 {
 	struct opensm_dump_context dump_context;
 	osm_mgrp_t *p_mgrp;
-	int i;
 
 	dump_context.p_osm = p_osm;
 	dump_context.file = file;
 	OSM_LOG(&p_osm->log, OSM_LOG_DEBUG, "Dump multicast\n");
 	cl_plock_acquire(&p_osm->lock);
-	for (i = 0; i <= p_osm->subn.max_mcast_lid_ho - IB_LID_MCAST_START_HO;
-	     i++) {
-		p_mgrp = p_osm->subn.mgroups[i];
-		if (p_mgrp)
-			sa_dump_one_mgrp(p_mgrp, &dump_context);
-	}
+	for (p_mgrp = (osm_mgrp_t *) cl_fmap_head(&p_osm->subn.mgrp_mgid_tbl);
+	     p_mgrp != (osm_mgrp_t *) cl_fmap_end(&p_osm->subn.mgrp_mgid_tbl);
+	     p_mgrp = (osm_mgrp_t *) cl_fmap_next(&p_mgrp->map_item))
+		sa_dump_one_mgrp(p_mgrp, &dump_context);
 	OSM_LOG(&p_osm->log, OSM_LOG_DEBUG, "Dump inform\n");
 	cl_qlist_apply_func(&p_osm->subn.sa_infr_list,
 			    sa_dump_one_inform, &dump_context);
@@ -722,10 +719,9 @@ static osm_mgrp_t *load_mcgroup(osm_opensm_t * p_osm, ib_net16_t mlid,
 
 	cl_plock_excl_acquire(&p_osm->lock);
 
-	p_mgrp = osm_get_mgrp_by_mlid(&p_osm->subn, mlid);
+	p_mgrp = osm_get_mgrp_by_mgid(&p_osm->sa, &p_mcm_rec->mgid);
 	if (p_mgrp) {
-		if (!memcmp(&p_mgrp->mcmember_rec.mgid, &p_mcm_rec->mgid,
-			    sizeof(ib_gid_t))) {
+		if (p_mgrp->mlid == mlid) {
 			OSM_LOG(&p_osm->log, OSM_LOG_DEBUG,
 				"mgrp %04x is already here.", cl_ntoh16(mlid));
 			goto _out;
diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index 357e6ab..477483f 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -121,12 +121,12 @@ static ib_net16_t get_new_mlid(osm_sa_t * sa, ib_net16_t requested_mlid)
 
 	if (requested_mlid && cl_ntoh16(requested_mlid) >= IB_LID_MCAST_START_HO
 	    && cl_ntoh16(requested_mlid) <= p_subn->max_mcast_lid_ho
-	    && !osm_get_mgrp_by_mlid(p_subn, requested_mlid))
+	    && !osm_get_mbox_by_mlid(p_subn, requested_mlid))
 		return requested_mlid;
 
 	max = p_subn->max_mcast_lid_ho - IB_LID_MCAST_START_HO + 1;
 	for (i = 0; i < max; i++)
-		if (!sa->p_subn->mgroups[i])
+		if (!sa->p_subn->mboxes[i])
 			return cl_hton16(i + IB_LID_MCAST_START_HO);
 
 	return 0;
@@ -1356,7 +1356,6 @@ static void mcmr_query_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	osm_physp_t *p_req_physp;
 	boolean_t trusted_req;
 	osm_mgrp_t *p_mgrp;
-	int i;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -1385,13 +1384,11 @@ static void mcmr_query_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	CL_PLOCK_ACQUIRE(sa->p_lock);
 
 	/* simply go over all MCGs and match */
-	for (i = 0; i <= sa->p_subn->max_mcast_lid_ho - IB_LID_MCAST_START_HO;
-	     i++) {
-		p_mgrp = sa->p_subn->mgroups[i];
-		if (p_mgrp)
-			mcmr_by_comp_mask(sa, p_rcvd_rec, comp_mask, p_mgrp,
-					  p_req_physp, trusted_req, &rec_list);
-	}
+	for (p_mgrp = (osm_mgrp_t *) cl_fmap_head(&sa->p_subn->mgrp_mgid_tbl);
+	     p_mgrp != (osm_mgrp_t *) cl_fmap_end(&sa->p_subn->mgrp_mgid_tbl);
+	     p_mgrp = (osm_mgrp_t *) cl_fmap_next(&p_mgrp->map_item))
+		mcmr_by_comp_mask(sa, p_rcvd_rec, comp_mask, p_mgrp,
+				  p_req_physp, trusted_req, &rec_list);
 
 	CL_PLOCK_RELEASE(sa->p_lock);
 
diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index cac5e94..53347ca 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -426,7 +426,6 @@ void osm_subn_destroy(IN osm_subn_t * p_subn)
 	osm_switch_t *p_sw, *p_next_sw;
 	osm_remote_sm_t *p_rsm, *p_next_rsm;
 	osm_prtn_t *p_prtn, *p_next_prtn;
-	osm_mgrp_t *p_mgrp;
 	osm_infr_t *p_infr, *p_next_infr;
 
 	/* it might be a good idea to de-allocate all known objects */
@@ -472,12 +471,9 @@ void osm_subn_destroy(IN osm_subn_t * p_subn)
 	cl_fmap_remove_all(&p_subn->mgrp_mgid_tbl);
 
 	for (i = 0; i <= p_subn->max_mcast_lid_ho - IB_LID_MCAST_START_HO;
-	     i++) {
-		p_mgrp = p_subn->mgroups[i];
-		p_subn->mgroups[i] = NULL;
-		if (p_mgrp)
-			osm_mgrp_delete(p_mgrp);
-	}
+	     i++)
+		if (p_subn->mboxes[i])
+			osm_mgrp_box_delete(p_subn->mboxes[i]);
 
 	p_next_infr = (osm_infr_t *) cl_qlist_head(&p_subn->sa_infr_list);
 	while (p_next_infr !=
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
