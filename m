From: Slava Strebkov <slavas-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: [PATCH v2] opensm: Multicast root switch calculation
Date: Thu, 03 Dec 2009 16:11:30 +0200
Message-ID: <4B17C712.9010109@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Proposed new algorithm for calculation of root switch for multicast
spanning tree. Only edge switches(those connected to hosts) and
switches - multicast members themselves are involved in root calculation.
This gives improvement, especially on large fabrics, since number of
switches usually much less then the number of ports, shared same mcast
group.

Signed-off-by: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_switch.h |   12 ++++
 opensm/opensm/osm_mcast_mgr.c      |  129 ++++++++++++++++++++++++++++++++---
 2 files changed, 130 insertions(+), 11 deletions(-)

diff --git a/opensm/include/opensm/osm_switch.h b/opensm/include/opensm/osm_switch.h
index 205896d..51c4251 100644
--- a/opensm/include/opensm/osm_switch.h
+++ b/opensm/include/opensm/osm_switch.h
@@ -109,6 +109,9 @@ typedef struct osm_switch {
 	unsigned endport_links;
 	unsigned need_update;
 	void *priv;
+	cl_map_item_t mcast_item;
+	uint32_t num_of_mcm;
+	uint8_t is_mc_member;
 } osm_switch_t;
 /*
 * FIELDS
@@ -151,6 +154,15 @@ typedef struct osm_switch {
 *		When set indicates that switch was probably reset, so
 *		fwd tables and rest cached data should be flushed
 *
+*	mcast_item
+*		map item for switch in building mcast tree
+*
+*	num_of_mcm
+*		number of mcast members(ports) connected to switch
+*
+*	is_mc_member
+*		whether switch is a mcast member itself
+*
 * SEE ALSO
 *	Switch object
 *********/
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index 616584f..f40709f 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -224,6 +224,117 @@ static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qlist_t * l,
 	return (float)max_hops;
 }
 
+static void mcast_mgr_build_switch_map(osm_sm_t * sm,
+				       const cl_qlist_t * port_list,
+				       cl_qmap_t * p_mcast_member_sw_tbl)
+{
+	osm_switch_t *remote_sw;
+	cl_list_item_t *list_item;
+	osm_port_t *p_port;
+	ib_net64_t port_guid;
+	osm_physp_t *p_physp_remote;
+	osm_node_t *remote_node;
+	osm_mcast_work_obj_t *wobj;
+
+	OSM_LOG_ENTER(sm->p_log);
+
+	cl_qmap_init(p_mcast_member_sw_tbl);
+	for (list_item = cl_qlist_head(port_list);
+	     list_item != cl_qlist_end(port_list);
+	     list_item = cl_qlist_next(list_item)) {
+		wobj = cl_item_obj(list_item, wobj, list_item);
+		p_port = wobj->p_port;
+		if (!p_port)
+			continue;
+		if (p_port->p_node->sw) {
+			/* for switches - remote switch would be the switch itself */
+			remote_node = osm_physp_get_node_ptr(p_port->p_physp);
+		} else {
+			p_physp_remote = osm_physp_get_remote(p_port->p_physp);
+			remote_node = osm_physp_get_node_ptr(p_physp_remote);
+		}
+		/* get the remote switch of the mcmember */
+		remote_sw = remote_node->sw;
+		port_guid = osm_node_get_node_guid(remote_node);
+		if (cl_qmap_get(p_mcast_member_sw_tbl, port_guid) ==
+			cl_qmap_end(p_mcast_member_sw_tbl)) {
+				/* insert switch to table */
+				cl_qmap_insert(p_mcast_member_sw_tbl, port_guid, &remote_sw->mcast_item);
+				/* New element in the table */
+				if (osm_node_get_type(p_port->p_node) == IB_NODE_TYPE_CA)
+					/* for HCA update the MC count on the remote switch */
+					remote_sw->num_of_mcm++;
+				else
+					/* the switch is MC memeber */
+					remote_sw->is_mc_member = 1;
+		}
+	}
+	OSM_LOG_EXIT(sm->p_log);
+}
+
+static void mcast_mgr_destroy_switch_map(osm_sm_t * sm,
+			cl_qmap_t *p_mcast_member_sw_tbl)
+{
+	cl_map_item_t *p_item;
+	osm_switch_t *p_sw;
+
+	OSM_LOG_ENTER(sm->p_log);
+
+	p_item = cl_qmap_head(p_mcast_member_sw_tbl);
+	while (p_item != cl_qmap_end(p_mcast_member_sw_tbl)) {
+		p_sw = PARENT_STRUCT(p_item, osm_switch_t, mcast_item);
+		p_sw->num_of_mcm = 0;
+		p_sw->is_mc_member = 0;
+		p_item = cl_qmap_next(p_item);
+	}
+	cl_qmap_remove_all(p_mcast_member_sw_tbl);
+	OSM_LOG_EXIT(sm->p_log);
+}
+
+static float
+osm_mcast_mgr_compute_avg_hops_weight(osm_sm_t * sm,
+				      const osm_switch_t * const p_sw_cur,
+				      const cl_qmap_t * p_sw_tbl)
+{
+	float avg_hops_weight = 0;
+	uint32_t hops = 0;
+	uint32_t num_ports = 0;
+	uint16_t base_lid_ho;
+	uint32_t tmp_hops;
+	uint32_t least_hops;
+	osm_switch_t *p_sw;
+	cl_map_item_t *p_item;
+
+	OSM_LOG_ENTER(sm->p_log);
+	/*
+	   For each member of the multicast group, compute the
+	   number of hops to its base LID.
+	 */
+	for (p_item = cl_qmap_head(p_sw_tbl);
+	     p_item != cl_qmap_end(p_sw_tbl); p_item = cl_qmap_next(p_item)) {
+		p_sw =
+		    (osm_switch_t *) PARENT_STRUCT(p_item, osm_switch_t,
+						   mcast_item);
+		base_lid_ho = cl_ntoh16(osm_node_get_base_lid(p_sw->p_node, 0));
+		least_hops = osm_switch_get_least_hops(p_sw_cur, base_lid_ho);
+		/* for all host that are MC members and attached to the switch,
+		   we should add the (least_hops + 1) * number_of_such_hosts.
+		   If switch itself is in the MC, we should add the least_hops only */
+		tmp_hops =
+		    (least_hops + 1) * p_sw->num_of_mcm +
+		    least_hops * p_sw->is_mc_member;
+		hops += tmp_hops;
+		num_ports += p_sw->num_of_mcm + p_sw->is_mc_member;
+	}
+
+	CL_ASSERT(num_ports);
+	if (num_ports != 0)
+		avg_hops_weight = (hops) / num_ports;
+
+	OSM_LOG_EXIT(sm->p_log);
+	return (avg_hops_weight);
+}
+
 /**********************************************************************
    This function attempts to locate the optimal switch for the
    center of the spanning tree.  The current algorithm chooses
@@ -231,32 +342,27 @@ static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qlist_t * l,
    of the multicast group.
 **********************************************************************/
 static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
-						   cl_qlist_t *list)
+						   cl_qlist_t * list)
 {
 	cl_qmap_t *p_sw_tbl;
 	osm_switch_t *p_sw, *p_best_sw = NULL;
 	float hops = 0;
 	float best_hops = 10000;	/* any big # will do */
-#ifdef OSM_VENDOR_INTF_ANAFA
-	boolean_t use_avg_hops = TRUE;	/* anafa2 - bug hca on switch *//* use max hops for root */
-#else
-	boolean_t use_avg_hops = FALSE;	/* use max hops for root */
-#endif
-
+	cl_qmap_t mcast_member_sw_tbl;
 	OSM_LOG_ENTER(sm->p_log);
 
 	p_sw_tbl = &sm->p_subn->sw_guid_tbl;
 
+	mcast_mgr_build_switch_map(sm, list, &mcast_member_sw_tbl);
 	for (p_sw = (osm_switch_t *) cl_qmap_head(p_sw_tbl);
 	     p_sw != (osm_switch_t *) cl_qmap_end(p_sw_tbl);
 	     p_sw = (osm_switch_t *) cl_qmap_next(&p_sw->map_item)) {
 		if (!osm_switch_supports_mcast(p_sw))
 			continue;
 
-		if (use_avg_hops)
-			hops = osm_mcast_mgr_compute_avg_hops(sm, list, p_sw);
-		else
-			hops = osm_mcast_mgr_compute_max_hops(sm, list, p_sw);
+		hops =
+		    osm_mcast_mgr_compute_avg_hops_weight(sm, p_sw,
+							  &mcast_member_sw_tbl);
 
 		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 			"Switch 0x%016" PRIx64 ", hops = %f\n",
@@ -277,6 +383,7 @@ static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"No multicast capable switches detected\n");
 
+	mcast_mgr_destroy_switch_map(sm, &mcast_member_sw_tbl);
 	OSM_LOG_EXIT(sm->p_log);
 	return p_best_sw;
 }
-- 
1.6.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
