From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/3] opensm: connect switches in tree - implemented in up/down
Date: Tue, 27 Oct 2009 10:56:46 +0200
Message-ID: <4AE6B5CE.8060100@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch implements connect_switches option in up/down
routing. Also, connect_roots is now handled as a special
case of connect_switches.

The idea is the following: when clearing hops, preserve
the entries for switches that are above the highest leaf
in the tree.
So if the highest leaf in the tree has rank N, preserve
hops to all the switches with ranks 0 to (N-1).
When connecting roots (--connect_roots option), just set
N to 1.

Signed-off-by:  Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---
 opensm/opensm/osm_ucast_updn.c |   83 ++++++++++++++++++++++++++++++---------
 1 files changed, 64 insertions(+), 19 deletions(-)

diff --git a/opensm/opensm/osm_ucast_updn.c b/opensm/opensm/osm_ucast_updn.c
index e567a46..846b892 100644
--- a/opensm/opensm/osm_ucast_updn.c
+++ b/opensm/opensm/osm_ucast_updn.c
@@ -285,26 +285,78 @@ static int updn_subn_rank(IN updn_t * p_updn)

 /**********************************************************************
  **********************************************************************/
-/* hack: preserve min hops entries to any other root switches */
-static void updn_clear_non_root_hops(updn_t * p_updn, osm_switch_t * p_sw)
+/* Preserve min hops entries to any switch
+ * above certain level in the tree */
+static void updn_switch_clear_hops_below_rank(updn_t * p_updn,
+	osm_switch_t * p_sw, unsigned min_leaf_rank)
 {
 	osm_port_t *p_port;
 	unsigned i;

 	for (i = 0; i < p_sw->num_hops; i++)
 		if (p_sw->hops[i]) {
-			p_port =
-			    cl_ptr_vector_get(&p_updn->p_osm->subn.port_lid_tbl,
-					      i);
-			if (!p_port || !p_port->p_node->sw
-			    || ((struct updn_node *)p_port->p_node->sw->priv)->
-			    rank != 0)
+			p_port = cl_ptr_vector_get(
+				&p_updn->p_osm->subn.port_lid_tbl, i);
+			if (!p_port || !p_port->p_node->sw ||
+			    ((struct updn_node *)
+			    p_port->p_node->sw->priv)->rank >= min_leaf_rank)
 				memset(p_sw->hops[i], 0xff, p_sw->num_ports);
 		}
 }

 /**********************************************************************
  **********************************************************************/
+static void updn_clear_hops(IN updn_t * p_updn)
+{
+	osm_subn_t *p_subn = &p_updn->p_osm->subn;
+	osm_switch_t *p_sw;
+	struct updn_node * p_updn_sw;
+	osm_physp_t * p_physp;
+	osm_port_t * p_port;
+	cl_map_item_t *item;
+	unsigned min_leaf_rank = 0xff;
+
+	if (p_subn->opt.connect_switches) {
+		/*
+		 * Preserve roots to switches above the highest leaf
+		 * switch (leaf switch with the lowest rank).
+		 *
+		 * Need to find the minimal rank of leaf switch.
+		 * The fastest way would be to go through all the
+		 * CA ports in the fabric and check the switch that
+		 * is connected to them.
+		 */
+		for (item = cl_qmap_head(&p_updn->p_osm->subn.port_guid_tbl);
+		     item != cl_qmap_end(&p_updn->p_osm->subn.port_guid_tbl);
+		     item = cl_qmap_next(item)) {
+			p_port = (osm_port_t *)item;
+			if (p_port->p_node->sw)
+				continue;
+			p_physp = p_port->p_physp->p_remote_physp;
+			if (!p_physp || !p_physp->p_node->sw)
+				continue;
+
+			p_updn_sw = (struct updn_node*)p_physp->p_node->sw->priv;
+			if (p_updn_sw->rank < min_leaf_rank)
+				min_leaf_rank = p_updn_sw->rank;
+		}
+	} else if (p_subn->opt.connect_roots)
+		min_leaf_rank = 1;
+
+	for (item = cl_qmap_head(&p_updn->p_osm->subn.sw_guid_tbl);
+	     item != cl_qmap_end(&p_updn->p_osm->subn.sw_guid_tbl);
+	     item = cl_qmap_next(item)) {
+		p_sw = (osm_switch_t *)item;
+		if (p_subn->opt.connect_switches || p_subn->opt.connect_roots)
+			updn_switch_clear_hops_below_rank(
+				p_updn, p_sw, min_leaf_rank);
+		else
+			osm_switch_clear_hops(p_sw);
+	}
+}
+
+/**********************************************************************
+ **********************************************************************/
 static int updn_set_min_hop_table(IN updn_t * p_updn)
 {
 	osm_subn_t *p_subn = &p_updn->p_osm->subn;
@@ -319,16 +371,8 @@ static int updn_set_min_hop_table(IN updn_t * p_updn)
 	OSM_LOG(p_log, OSM_LOG_VERBOSE,
 		"Init Min Hop Table of all switches [\n");

-	for (item = cl_qmap_head(&p_updn->p_osm->subn.sw_guid_tbl);
-	     item != cl_qmap_end(&p_updn->p_osm->subn.sw_guid_tbl);
-	     item = cl_qmap_next(item)) {
-		p_sw = (osm_switch_t *)item;
-		/* Clear Min Hop Table */
-		if (p_subn->opt.connect_roots)
-			updn_clear_non_root_hops(p_updn, p_sw);
-		else
-			osm_switch_clear_hops(p_sw);
-	}
+	/* Clear Min Hop Table */
+	updn_clear_hops(p_updn);

 	OSM_LOG(p_log, OSM_LOG_VERBOSE,
 		"Init Min Hop Table of all switches ]\n");
@@ -614,7 +658,8 @@ static int updn_lid_matrices(void *ctx)
 			OSM_LOG(&p_updn->p_osm->log, OSM_LOG_ERROR, "ERR : "
 				"cannot parse root guids file \'%s\'\n",
 				p_updn->p_osm->subn.opt.root_guid_file);
-		if (p_updn->p_osm->subn.opt.connect_roots &&
+		if ((p_updn->p_osm->subn.opt.connect_roots ||
+		     p_updn->p_osm->subn.opt.connect_switches) &&
 		    p_updn->num_roots > 1)
 			osm_ucast_mgr_build_lid_matrices(&p_updn->p_osm->sm.ucast_mgr);
 	} else {
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
