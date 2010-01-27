From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] opensm: Multicast root switch calculation
Date: Wed, 27 Jan 2010 12:45:03 +0200
Message-ID: <20100127104503.GM26338@me>
References: <4B17C712.9010109@Voltaire.COM>
 <20100120102703.GB25576@me>
 <39C75744D164D948A170E9792AF8E7CA01F6FA8A@exil.voltaire.com>
 <20100120115936.GC25576@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100120115936.GC25576@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13:59 Wed 20 Jan     , Sasha Khapyorsky wrote:
> On 13:32 Wed 20 Jan     , Slava Strebkov wrote:
> > "average hops" was chosen instead of "max hops" because in root weight
> > calculation the number of ports is also important, not only the distance
> > (hops).
> 
> But this patch is declared as root switch calculation optimization, not
> as algorithm change (actually I even missed this part in V1).

I reworked this patch preserving original ("max hops") calculation
method. Please look at this.

The next step is to evaluate "max hops" -> "average hops" switch and to
cleanup OSM_VENDOR_INTF_ANAFA macro.

Sasha


From: Slava Strebkov <slavas-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Date: Thu, 3 Dec 2009 16:11:30 +0200
Subject: [PATCH] opensm: Multicast root switch calculation

Proposed new algorithm for calculation of root switch for multicast
spanning tree. Only edge switches(those connected to hosts) and
switches - multicast members themselves are involved in root calculation.
This gives improvement, especially on large fabrics, since number of
switches usually much less then the number of ports, shared same mcast
group.

Signed-off-by: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_switch.h |   12 +++
 opensm/opensm/osm_mcast_mgr.c      |  149 ++++++++++++++++++++++++++---------
 2 files changed, 122 insertions(+), 39 deletions(-)

diff --git a/opensm/include/opensm/osm_switch.h b/opensm/include/opensm/osm_switch.h
index 205896d..cb6e5ac 100644
--- a/opensm/include/opensm/osm_switch.h
+++ b/opensm/include/opensm/osm_switch.h
@@ -109,6 +109,9 @@ typedef struct osm_switch {
 	unsigned endport_links;
 	unsigned need_update;
 	void *priv;
+	cl_map_item_t mgrp_item;
+	uint32_t num_of_mcm;
+	uint8_t is_mc_member;
 } osm_switch_t;
 /*
 * FIELDS
@@ -151,6 +154,15 @@ typedef struct osm_switch {
 *		When set indicates that switch was probably reset, so
 *		fwd tables and rest cached data should be flushed
 *
+*	mgrp_item
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
index dce9f2b..5c9d0bc 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -157,50 +157,119 @@ static void mcast_mgr_purge_tree(osm_sm_t * sm, IN osm_mgrp_box_t * mbox)
 	OSM_LOG_EXIT(sm->p_log);
 }
 
-static float osm_mcast_mgr_compute_avg_hops(osm_sm_t * sm, cl_qlist_t * l,
-					    const osm_switch_t * p_sw)
+static void mcast_mgr_build_switch_map(osm_sm_t * sm,
+				       const cl_qlist_t * port_list,
+				       cl_qmap_t * p_mcast_member_sw_tbl)
 {
-	float avg_hops = 0;
-	uint32_t hops = 0;
-	uint32_t num_ports = 0;
-	cl_list_item_t *i;
+	osm_switch_t *remote_sw;
+	cl_list_item_t *list_item;
+	osm_port_t *p_port;
+	ib_net64_t port_guid;
+	osm_physp_t *p_physp_remote;
+	osm_node_t *remote_node;
 	osm_mcast_work_obj_t *wobj;
 
 	OSM_LOG_ENTER(sm->p_log);
 
-	/*
-	   For each member of the multicast group, compute the
-	   number of hops to its base LID.
-	 */
-	for (i = cl_qlist_head(l); i != cl_qlist_end(l); i = cl_qlist_next(i)) {
-		wobj = cl_item_obj(i, wobj, list_item);
-		hops += osm_switch_get_port_least_hops(p_sw, wobj->p_port);
-		num_ports++;
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
+				cl_qmap_insert(p_mcast_member_sw_tbl, port_guid, &remote_sw->mgrp_item);
+				/* New element in the table */
+				if (osm_node_get_type(p_port->p_node) == IB_NODE_TYPE_CA)
+					/* for HCA update the MC count on the remote switch */
+					remote_sw->num_of_mcm++;
+				else
+					/* the switch is MC memeber */
+					remote_sw->is_mc_member = 1;
+		}
 	}
+	OSM_LOG_EXIT(sm->p_log);
+}
 
-	/*
-	   We should be here if there aren't any ports in the group.
-	 */
-	CL_ASSERT(num_ports);
+static void mcast_mgr_destroy_switch_map(osm_sm_t * sm,
+			cl_qmap_t *p_mcast_member_sw_tbl)
+{
+	cl_map_item_t *p_item;
+	osm_switch_t *p_sw;
 
-	if (num_ports != 0)
-		avg_hops = (float)(hops / num_ports);
+	OSM_LOG_ENTER(sm->p_log);
 
+	p_item = cl_qmap_head(p_mcast_member_sw_tbl);
+	while (p_item != cl_qmap_end(p_mcast_member_sw_tbl)) {
+		p_sw = PARENT_STRUCT(p_item, osm_switch_t, mgrp_item);
+		p_sw->num_of_mcm = 0;
+		p_sw->is_mc_member = 0;
+		p_item = cl_qmap_next(p_item);
+	}
+	cl_qmap_remove_all(p_mcast_member_sw_tbl);
 	OSM_LOG_EXIT(sm->p_log);
-	return avg_hops;
 }
 
 /**********************************************************************
  Calculate the maximal "min hops" from the given switch to any
  of the group HCAs
  **********************************************************************/
-static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qlist_t * l,
-					    const osm_switch_t * p_sw)
+#ifdef OSM_VENDOR_INTF_ANAFA
+static float osm_mcast_mgr_compute_avg_hops(osm_sm_t * sm, cl_qmap_t * m,
+					    const osm_switch_t * this_sw)
 {
-	uint32_t max_hops = 0;
+	float avg_hops = 0;
 	uint32_t hops = 0;
-	cl_list_item_t *i;
-	osm_mcast_work_obj_t *wobj;
+	uint32_t num_ports = 0;
+	uint16_t lid;
+	uint32_t least_hops;
+	cl_map_item_t *i;
+	osm_switch_t *sw;
+
+	OSM_LOG_ENTER(sm->p_log);
+
+	for (i = cl_qmap_head(m); i != cl_qmap_end(m); i = cl_qmap_next(i)) {
+		sw = cl_item_obj(i, sw, mcast_item);
+		lid = cl_ntoh16(osm_node_get_base_lid(sw->p_node, 0));
+		least_hops = osm_switch_get_least_hops(this_sw, lid);
+		/* for all host that are MC members and attached to the switch,
+		   we should add the (least_hops + 1) * number_of_such_hosts.
+		   If switch itself is in the MC, we should add the least_hops only */
+		hops += (least_hops + 1) * sw->num_of_mcm +
+		    least_hops * sw->is_mc_member;
+		num_ports += sw->num_of_mcm + sw->is_mc_member;
+	}
+
+	/* We should be here if there aren't any ports in the group. */
+	CL_ASSERT(num_ports);
+
+	avg_hops = (float)(hops / num_ports);
+
+	OSM_LOG_EXIT(sm->p_log);
+	return avg_hops;
+}
+#else
+static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qmap_t * m,
+					    const osm_switch_t * this_sw)
+{
+	uint32_t max_hops = 0, hops;
+	uint16_t lid;
+	cl_map_item_t *i;
+	osm_switch_t *sw;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -208,9 +277,11 @@ static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qlist_t * l,
 	   For each member of the multicast group, compute the
 	   number of hops to its base LID.
 	 */
-	for (i = cl_qlist_head(l); i != cl_qlist_end(l); i = cl_qlist_next(i)) {
-		wobj = cl_item_obj(i, wobj, list_item);
-		hops = osm_switch_get_port_least_hops(p_sw, wobj->p_port);
+	for (i = cl_qmap_head(m); i != cl_qmap_end(m); i = cl_qmap_next(i)) {
+		sw = cl_item_obj(i, sw, mgrp_item);
+		lid = cl_ntoh16(osm_node_get_base_lid(sw->p_node, 0));
+		hops = osm_switch_get_least_hops(this_sw, lid);
+		hops = (hops + 1) * sw->num_of_mcm + hops * sw->is_mc_member;
 		if (hops > max_hops)
 			max_hops = hops;
 	}
@@ -222,6 +293,7 @@ static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qlist_t * l,
 	OSM_LOG_EXIT(sm->p_log);
 	return (float)max_hops;
 }
+#endif
 
 /**********************************************************************
    This function attempts to locate the optimal switch for the
@@ -230,32 +302,30 @@ static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qlist_t * l,
    of the multicast group.
 **********************************************************************/
 static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
-						   cl_qlist_t *list)
+						   cl_qlist_t * list)
 {
+	cl_qmap_t mgrp_sw_map;
 	cl_qmap_t *p_sw_tbl;
 	osm_switch_t *p_sw, *p_best_sw = NULL;
 	float hops = 0;
 	float best_hops = 10000;	/* any big # will do */
-#ifdef OSM_VENDOR_INTF_ANAFA
-	boolean_t use_avg_hops = TRUE;	/* anafa2 - bug hca on switch *//* use max hops for root */
-#else
-	boolean_t use_avg_hops = FALSE;	/* use max hops for root */
-#endif
 
 	OSM_LOG_ENTER(sm->p_log);
 
 	p_sw_tbl = &sm->p_subn->sw_guid_tbl;
 
+	mcast_mgr_build_switch_map(sm, list, &mgrp_sw_map);
 	for (p_sw = (osm_switch_t *) cl_qmap_head(p_sw_tbl);
 	     p_sw != (osm_switch_t *) cl_qmap_end(p_sw_tbl);
 	     p_sw = (osm_switch_t *) cl_qmap_next(&p_sw->map_item)) {
 		if (!osm_switch_supports_mcast(p_sw))
 			continue;
 
-		if (use_avg_hops)
-			hops = osm_mcast_mgr_compute_avg_hops(sm, list, p_sw);
-		else
-			hops = osm_mcast_mgr_compute_max_hops(sm, list, p_sw);
+#ifdef OSM_VENDOR_INTF_ANAFA
+		hops = osm_mcast_mgr_compute_avg_hops(sm, &mgrp_sw_map, p_sw);
+#else
+		hops = osm_mcast_mgr_compute_max_hops(sm, &mgrp_sw_map, p_sw);
+#endif
 
 		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 			"Switch 0x%016" PRIx64 ", hops = %f\n",
@@ -276,6 +346,7 @@ static osm_switch_t *mcast_mgr_find_optimal_switch(osm_sm_t * sm,
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"No multicast capable switches detected\n");
 
+	mcast_mgr_destroy_switch_map(sm, &mgrp_sw_map);
 	OSM_LOG_EXIT(sm->p_log);
 	return p_best_sw;
 }
-- 
1.6.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
