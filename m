From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 11/12] opensm: Implement multicast support for
 torus-2QoS.
Date: Fri, 18 Dec 2009 13:51:00 -0700
Message-ID: <1261169461-2516-11-git-send-email-jaschut@sandia.gov>
References: <1258744509-11148-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1258744509-11148-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Every multicast spanning tree used by torus-2QoS is a subset
of the master spanning tree built when unicast routing is
computed.  This is required because when QoS is enabled,
torus-2QoS needs to use the same SLs for unicast and multicast.
Thus, the multicast spanning trees must have special properties
to avoid credit loops between unicast and multicast traffic.

To build a spanning tree for a particular MLID, torus-2QoS just
needs to mark all the ports that participate in that multicast
group, then walk the master spanning tree and add switches
hosting the marked ports to the multicast group spanning tree.
Use a depth-first search of the master spanning tree for this.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_ucast_torus.c |  250 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 239 insertions(+), 11 deletions(-)

diff --git a/opensm/opensm/osm_ucast_torus.c b/opensm/opensm/osm_ucast_torus.c
index 082fcf5..e2eb324 100644
--- a/opensm/opensm/osm_ucast_torus.c
+++ b/opensm/opensm/osm_ucast_torus.c
@@ -300,6 +300,7 @@ struct torus {
 
 	struct coord_dirs *origin;
 	struct t_switch ****sw;
+	struct t_switch *master_stree_root;
 
 	unsigned flags;
 	int debug;
@@ -8515,6 +8516,241 @@ bool torus_lft(struct torus *t, struct t_switch *sw)
 }
 
 static
+osm_mtree_node_t *mcast_stree_branch(struct t_switch *sw, osm_switch_t *osm_sw,
+				     osm_mgrp_box_t *mgb, unsigned depth,
+				     unsigned *port_cnt, unsigned *max_depth)
+{
+	osm_mtree_node_t *mtn = NULL;
+	osm_mcast_tbl_t *mcast_tbl, *ds_mcast_tbl;
+	osm_node_t *ds_node;
+	struct t_switch *ds_sw;
+	struct port_grp *ptgrp;
+	struct link *link;
+	struct endpoint *port;
+	unsigned g, p;
+	unsigned mcast_fwd_ports = 0, mcast_end_ports = 0;
+
+	depth++;
+
+	if (osm_sw->priv != sw) {
+		OSM_LOG(&sw->torus->osm->log, OSM_LOG_INFO,
+			"Error: osm_sw (GUID 0x%04llx) "
+			"not in our fabric description\n",
+			ntohllu(osm_node_get_node_guid(osm_sw->p_node)));
+		goto out;
+	}
+	if (!osm_switch_supports_mcast(osm_sw)) {
+		OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
+			"Error: osm_sw (GUID 0x%04llx) "
+			"does not support multicast\n",
+			ntohllu(osm_node_get_node_guid(osm_sw->p_node)));
+		goto out;
+	}
+	mtn = osm_mtree_node_new(osm_sw);
+	if (!mtn) {
+		OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
+			"Insufficient memory to build multicast tree\n");
+		goto out;
+	}
+	mcast_tbl = osm_switch_get_mcast_tbl_ptr(osm_sw);
+	/*
+	 * Recurse to downstream switches, i.e. those closer to master
+	 * spanning tree branch tips.
+	 *
+	 * Note that if there are multiple ports in this port group, i.e.,
+	 * multiple parallel links, we can pick any one of them to use for
+	 * any individual MLID without causing loops.  Pick one based on MLID
+	 * for now, until someone turns up evidence we need to be smarter.
+	 *
+	 * Also, it might be we got called in a window between a switch getting
+	 * removed from the fabric, and torus-2QoS getting to rebuild its
+	 * fabric representation.  If that were to happen, our next hop
+	 * osm_switch pointer might be stale.  Look it up via opensm's fabric
+	 * description to be sure it's not.
+	 */
+	for (g = 0; g < 2 * TORUS_MAX_DIM; g++) {
+		ptgrp = &sw->ptgrp[g];
+		if (!ptgrp->to_stree_tip)
+			continue;
+
+		p = mgb->mlid % ptgrp->port_cnt;/* port # in port group */
+		p = ptgrp->port[p]->port;	/* now port # in switch */
+
+		ds_node = osm_node_get_remote_node(osm_sw->p_node, p, NULL);
+		ds_sw = ptgrp->to_stree_tip->sw;
+
+		if (!(ds_node && ds_node->sw &&
+		      ds_sw->osm_switch == ds_node->sw)) {
+			OSM_LOG(&sw->torus->osm->log, OSM_LOG_ERROR,
+				"Error: stale pointer to osm_sw "
+				"(GUID 0x%04llx)\n", ntohllu(ds_sw->n_id));
+			continue;
+		}
+		mtn->child_array[p] =
+			mcast_stree_branch(ds_sw, ds_node->sw, mgb,
+					   depth, port_cnt, max_depth);
+		if (!mtn->child_array[p])
+			continue;
+
+		osm_mcast_tbl_set(mcast_tbl, mgb->mlid, p);
+		mcast_fwd_ports++;
+		/*
+		 * Since we forward traffic for this multicast group on this
+		 * port, cause the switch on the other end of the link
+		 * to forward traffic back to us.  Do it now since have at
+		 * hand the link used; otherwise it'll be hard to figure out
+		 * later, and if we get it wrong we get a MC routing loop.
+		 */
+		link = sw->port[p]->link;
+		ds_mcast_tbl = osm_switch_get_mcast_tbl_ptr(ds_node->sw);
+
+		if (&link->end[0] == sw->port[p])
+			osm_mcast_tbl_set(ds_mcast_tbl, mgb->mlid,
+					  link->end[1].port);
+		else
+			osm_mcast_tbl_set(ds_mcast_tbl, mgb->mlid,
+					  link->end[0].port);
+	}
+	/*
+	 * Add any host ports marked as in mcast group into spanning tree.
+	 */
+	ptgrp = &sw->ptgrp[2 * TORUS_MAX_DIM];
+	for (p = 0; p < ptgrp->port_cnt; p++) {
+		port = ptgrp->port[p];
+		if (port->tmp) {
+			port->tmp = NULL;
+			mtn->child_array[port->port] = OSM_MTREE_LEAF;
+			osm_mcast_tbl_set(mcast_tbl, mgb->mlid, port->port);
+			mcast_end_ports++;
+		}
+	}
+	if (!(mcast_end_ports || mcast_fwd_ports)) {
+		free(mtn);
+		mtn = NULL;
+	} else if (depth > *max_depth)
+		*max_depth = depth;
+
+	*port_cnt += mcast_end_ports;
+out:
+	return mtn;
+}
+
+static
+osm_port_t *next_mgrp_box_port(osm_mgrp_box_t *mgb,
+			       cl_list_item_t **list_iterator,
+			       cl_map_item_t **map_iterator)
+{
+	osm_mgrp_t *mgrp;
+	osm_mcm_port_t *mcm_port;
+	osm_port_t *osm_port = NULL;
+	cl_map_item_t *m_item = *map_iterator;
+	cl_list_item_t *l_item = *list_iterator;
+
+next_mgrp:
+	if (!l_item)
+		l_item = cl_qlist_head(&mgb->mgrp_list);
+	if (l_item == cl_qlist_end(&mgb->mgrp_list)) {
+		l_item = NULL;
+		goto out;
+	}
+	mgrp = cl_item_obj(l_item, mgrp, list_item);
+
+	if (!m_item)
+		m_item = cl_qmap_head(&mgrp->mcm_port_tbl);
+	if (m_item == cl_qmap_end(&mgrp->mcm_port_tbl)) {
+		m_item = NULL;
+		l_item = cl_qlist_next(l_item);
+		goto next_mgrp;
+	}
+	mcm_port = cl_item_obj(m_item, mcm_port, map_item);
+	m_item = cl_qmap_next(m_item);
+	osm_port = mcm_port->port;
+out:
+	*list_iterator = l_item;
+	*map_iterator = m_item;
+	return osm_port;
+}
+
+static
+ib_api_status_t torus_mcast_stree(void *context, osm_mgrp_box_t *mgb)
+{
+	struct torus_context *ctx = context;
+	struct torus *t = ctx->torus;
+	cl_map_item_t *m_item = NULL;
+	cl_list_item_t *l_item = NULL;
+	osm_port_t *osm_port;
+	osm_switch_t *osm_sw;
+	struct endpoint *port;
+	unsigned port_cnt = 0, max_depth = 0;
+
+	osm_purge_mtree(&ctx->osm->sm, mgb);
+
+	/*
+	 * Build a spanning tree for a multicast group by first marking
+	 * the torus endpoints that are participating in the group.
+	 * Then do a depth-first search of the torus master spanning
+	 * tree to build up the spanning tree specific to this group.
+	 *
+	 * Since the torus master spanning tree is constructed specifically
+	 * to guarantee that multicast will not deadlock against unicast
+	 * when they share VLs, we can be sure that any multicast group
+	 * spanning tree constructed this way has the same property.
+	 */
+	while ((osm_port = next_mgrp_box_port(mgb, &l_item, &m_item))) {
+		port = osm_port->priv;
+		if (!(port && port->osm_port == osm_port)) {
+			port = osm_port_relink_endpoint(osm_port);
+			if (!port) {
+				guid_t id;
+				id = osm_node_get_node_guid(osm_port->p_node);
+				OSM_LOG(&ctx->osm->log, OSM_LOG_ERROR,
+					"Error: osm_port (GUID 0x%04llx) "
+					"not in our fabric description\n",
+					ntohllu(id));
+				continue;
+			}
+		}
+		/*
+		 * If this is a CA port, mark the switch port at the
+		 * other end of this port's link.
+		 *
+		 * By definition, a CA port is connected to end[1] of a link,
+		 * and the switch port is end[0].  See build_ca_link() and
+		 * link_srcsink().
+		 */
+		if (port->link)
+			port = &port->link->end[0];
+		port->tmp = osm_port;
+	}
+	/*
+	 * It might be we got called in a window between a switch getting
+	 * removed from the fabric, and torus-2QoS getting to rebuild its
+	 * fabric representation.  If that were to happen, our
+	 * master_stree_root->osm_switch pointer might be stale.  Look up
+	 * the osm_switch by GUID to be sure it's not.
+	 *
+	 * Also, call into mcast_stree_branch with depth = -1, because
+	 * depth at root switch needs to be 0.
+	 */
+	osm_sw = (osm_switch_t *)cl_qmap_get(&ctx->osm->subn.sw_guid_tbl,
+					     t->master_stree_root->n_id);
+	if (!(osm_sw && t->master_stree_root->osm_switch == osm_sw)) {
+		OSM_LOG(&ctx->osm->log, OSM_LOG_ERROR,
+			"Error: stale pointer to osm_sw (GUID 0x%04llx)\n",
+			ntohllu(t->master_stree_root->n_id));
+		return IB_ERROR;
+	}
+	mgb->root = mcast_stree_branch(t->master_stree_root, osm_sw,
+				       mgb, -1, &port_cnt, &max_depth);
+
+	OSM_LOG(&ctx->osm->log, OSM_LOG_VERBOSE,
+		"Configured MLID 0x%X for %u ports, max tree depth = %u\n",
+		mgb->mlid, port_cnt, max_depth);
+
+	return IB_SUCCESS;
+}
+
+static
 bool good_xy_ring(struct torus *t, int x, int y, int z)
 {
 	struct t_switch ****sw = t->sw;
@@ -8740,6 +8976,7 @@ bool torus_master_stree(struct torus *t)
 			if (t->sw[i][j][k])
 				build_master_stree_branch(t->sw[i][j][k], 2);
 	}
+	t->master_stree_root = stree_root;
 	/*
 	 * At this point we should have a master spanning tree that contains
 	 * every present switch, for all fabrics that torus-2QoS can route
@@ -8855,17 +9092,7 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 
 	/*
 	 * If QoS was not requested by user, force path SLs into 8-15 range.
-	 * This leaves SL 0 available for multicast, and SL2VL mappings
-	 * will keep multicast traffic from deadlocking with unicast traffic.
-	 *
-	 * However, multicast might still deadlock against itself if multiple
-	 * multicast groups each use their own spanning tree.
-	 *
-	 * FIXME: it is possible to construct a spanning tree that can
-	 * overlay the DOR routing used for unicast in a way that multicast
-	 * and unicast can share VLs but cannot deadlock against each other.
-	 * Need to implement that and cause it to be used whenever the
-	 * torus-2QoS routing engine is used.
+	 * This leaves SL 0 available for multicast.
 	 */
 	if (t->flags & QOS_ENABLED)
 		sl |= sl_set_qos(sl_get_qos(path_sl_hint));
@@ -8963,6 +9190,7 @@ int osm_ucast_torus2QoS_setup(struct osm_routing_engine *r,
 	r->ucast_build_fwd_tables = torus_build_lfts;
 	r->update_sl2vl = torus_update_osm_sl2vl;
 	r->path_sl = torus_path_sl;
+	r->mcast_build_stree = torus_mcast_stree;
 	r->delete = torus_context_delete;
 	return 0;
 }
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
