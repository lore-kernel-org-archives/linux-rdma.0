From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: implement 'connect_roots' option in fat-tree routing
Date: Sun, 06 Dec 2009 11:19:51 +0200
Message-ID: <4B1B7737.3010408@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Implement 'connect_roots' option in fat-tree routing
and mention this fact in all the help/usage/man messages.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/opensm/osm_subnet.h |    4 +-
 opensm/man/opensm.8.in             |    4 +-
 opensm/opensm/main.c               |    4 +-
 opensm/opensm/osm_ucast_ftree.c    |   90 ++++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+), 6 deletions(-)

diff --git a/opensm/include/opensm/osm_subnet.h b/opensm/include/opensm/osm_subnet.h
index 3c08689..fce1862 100644
--- a/opensm/include/opensm/osm_subnet.h
+++ b/opensm/include/opensm/osm_subnet.h
@@ -374,8 +374,8 @@ typedef struct osm_subn_opt {
 *
 *	connect_roots
 *		The option which will enforce root to root connectivity with
-*		up/down routing engine (even if this violates "pure" deadlock
-*		free up/down algorithm)
+*		up/down and fat-tree routing engines (even if this violates
+*		"pure" deadlock free up/down or fat-tree algorithm)
 *
 *	use_ucast_cache
 *		When TRUE enables unicast routing cache.
diff --git a/opensm/man/opensm.8.in b/opensm/man/opensm.8.in
index 0baee7d..e66b946 100644
--- a/opensm/man/opensm.8.in
+++ b/opensm/man/opensm.8.in
@@ -171,8 +171,8 @@ recalculations: one when the host goes down, and the other when
 the host comes back online.
 .TP
 \fB\-z\fR, \fB\-\-connect_roots\fR
-This option enforces a routing engine (currently up/down
-only) to make connectivity between root switches and in
+This option enforces routing engines (up/down and
+fat-tree) to make connectivity between root switches and in
 this way to be fully IBA complaint. In many cases this can
 violate "pure" deadlock free algorithm, so use it carefully.
 .TP
diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
index fc002d8..cf38577 100644
--- a/opensm/opensm/main.c
+++ b/opensm/opensm/main.c
@@ -186,8 +186,8 @@ static void show_usage(void)
 	printf("--sm_sl <sl number>\n"
 	       "          Sets the SL to use to communicate with the SM/SA. Defaults to 0.\n\n");
 	printf("--connect_roots, -z\n"
-	       "          This option enforces a routing engine (currently\n"
-	       "          up/down only) to make connectivity between root switches\n"
+	       "          This option enforces routing engines (up/down and \n"
+	       "          fat-tree) to make connectivity between root switches\n"
 	       "          and in this way be IBA compliant. In many cases,\n"
 	       "          this can violate \"pure\" deadlock free algorithm, so\n"
 	       "          use it carefully.\n\n");
diff --git a/opensm/opensm/osm_ucast_ftree.c b/opensm/opensm/osm_ucast_ftree.c
index e1effd0..39268eb 100644
--- a/opensm/opensm/osm_ucast_ftree.c
+++ b/opensm/opensm/osm_ucast_ftree.c
@@ -2949,6 +2949,89 @@ static void fabric_route_to_switches(IN ftree_fabric_t * p_ftree)
 /***************************************************
  ***************************************************/

+static void fabric_route_roots(IN ftree_fabric_t * p_ftree)
+{
+	uint16_t lid;
+	uint8_t port_num;
+	osm_port_t *p_port;
+	ftree_sw_t *p_sw;
+	ftree_sw_t *p_leaf_sw;
+
+	OSM_LOG_ENTER(&p_ftree->p_osm->log);
+
+	/*
+	 * We need a switch that will accomodate all the down/up turns in
+	 * the fabric. Having these turn in a single place in the fabric
+	 * will not create credit loops.
+	 * So we need to select this switch.
+	 * The idea here is to chose leaf with the highest index. I don't
+	 * have any theory to back me up on this. It's just a general thought
+	 * that this way the switch that might be a bottleneck for many mcast
+	 * groups will be far away from the OpenSM, so it will draw the
+	 * multicast traffic away from the SM.
+	 */
+
+	p_leaf_sw = p_ftree->leaf_switches[p_ftree->leaf_switches_num-1];
+
+	/*
+	 * Now go over all the switches in the fabric that
+	 * have lower rank, and route the missing LIDs to
+	 * the selected leaf switch.
+	 * In short, this leaf switch now poses a target
+	 * for all those missing LIDs.
+	 */
+
+	for (p_sw = (ftree_sw_t *) cl_qmap_head(&p_ftree->sw_tbl);
+	     p_sw != (ftree_sw_t *) cl_qmap_end(&p_ftree->sw_tbl);
+	     p_sw = (ftree_sw_t *) cl_qmap_next(&p_sw->map_item)) {
+
+		if (p_sw->rank >= p_ftree->leaf_switch_rank)
+			continue;
+
+		for (lid = 1; lid <= p_leaf_sw->p_osm_sw->max_lid_ho; lid ++) {
+
+			if (p_sw->p_osm_sw->new_lft[lid] != OSM_NO_PATH ||
+			    p_leaf_sw->hops[lid] == OSM_NO_PATH)
+				continue;
+
+			p_port = cl_ptr_vector_get(
+				&p_ftree->p_osm->subn.port_lid_tbl, lid);
+
+			/* we're interested only in switches */
+			if (!p_port || !p_port->p_node->sw)
+				continue;
+
+			/*
+			 * the missing LID will be routed through the same
+			 * port that routes to the selected leaf switch
+			 */
+			port_num = p_sw->p_osm_sw->new_lft[p_leaf_sw->base_lid];
+
+			OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
+				"Switch %s: setting path to LID %u "
+				"through port %u\n",
+				tuple_to_str(p_sw->tuple), lid, port_num);
+
+			/* set local lft */
+			p_sw->p_osm_sw->new_lft[lid] = port_num;
+
+			/*
+			 * Set local min hop table.
+			 * The distance to the target LID is a distance
+			 * to the selected leaf switch plus the distance
+			 * from the leaf to the target LID.
+			 */
+			sw_set_hops(p_sw, lid, port_num,
+				p_sw->hops[p_leaf_sw->base_lid] +
+				p_leaf_sw->hops[lid], TRUE);
+		}
+	}
+
+	OSM_LOG_EXIT(&p_ftree->p_osm->log);
+}				/* fabric_route_roots() */
+
+/***************************************************/
+
 static int fabric_populate_nodes(IN ftree_fabric_t * p_ftree)
 {
 	osm_node_t *p_osm_node;
@@ -3978,6 +4061,13 @@ static int do_routing(IN void *context)
 		"Filling switch forwarding tables for switch-to-switch paths\n");
 	fabric_route_to_switches(p_ftree);

+	if (p_ftree->p_osm->subn.opt.connect_roots) {
+		OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
+			"Connecting switches that are unreachable within "
+			"Up/Down rules\n");
+		fabric_route_roots(p_ftree);
+	}
+
 	/* for each switch, set its fwd table */
 	cl_qmap_apply_func(&p_ftree->sw_tbl, set_sw_fwd_table, (void *)p_ftree);

-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
