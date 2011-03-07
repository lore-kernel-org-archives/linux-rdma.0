From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fixed potential memory leak in osm_ucast_ftree()
Date: Mon, 7 Mar 2011 12:03:59 +0200
Message-ID: <20110307100359.GK5577@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Need to free all the allocated variables in case of error.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_ftree.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 11980cc..51e252a 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -554,25 +554,40 @@ static ftree_sw_t *sw_create(IN ftree_fabric_t * p_ftree,
 	p_sw->down_port_groups =
 	    (ftree_port_group_t **) malloc(ports_num *
 					   sizeof(ftree_port_group_t *));
+	if (p_sw->down_port_groups == NULL)
+		goto FREE_P_SW;
+
 	p_sw->up_port_groups =
 	    (ftree_port_group_t **) malloc(ports_num *
 					   sizeof(ftree_port_group_t *));
+	if (p_sw->sibling_port_groups == NULL)
+		goto FREE_DOWN;
+
 	p_sw->sibling_port_groups =
 	    (ftree_port_group_t **) malloc(ports_num *
 					   sizeof(ftree_port_group_t *));
-
-	if (!p_sw->down_port_groups || !p_sw->up_port_groups
-	    || !p_sw->sibling_port_groups)
-		return NULL;
+	if (p_sw->sibling_port_groups == NULL)
+		goto FREE_UP;
 
 	/* initialize lft buffer */
 	memset(p_osm_sw->new_lft, OSM_NO_PATH, p_osm_sw->lft_size);
 	p_sw->hops = malloc((p_osm_sw->max_lid_ho + 1) * sizeof(*(p_sw->hops)));
 	if (p_sw->hops == NULL)
-		return NULL;
+		goto FREE_SIBLING;
+
 	memset(p_sw->hops, OSM_NO_PATH, p_osm_sw->max_lid_ho + 1);
 
 	return p_sw;
+
+FREE_SIBLING:
+	free(p_sw->sibling_port_groups);
+FREE_UP:
+	free(p_sw->up_port_groups);
+FREE_DOWN:
+	free(p_sw->down_port_groups);
+FREE_P_SW:
+	free(p_sw);
+	return NULL;
 }				/* sw_create() */
 
 /***************************************************/
@@ -1662,6 +1677,7 @@ static int fabric_create_leaf_switch_array(IN ftree_fabric_t * p_ftree)
 	if (!p_ftree->leaf_switches) {
 		osm_log(&p_ftree->p_osm->log, OSM_LOG_SYS,
 			"Fat-tree routing: Memory allocation failed\n");
+		free(all_switches_at_leaf_level);
 		res = -1;
 		goto Exit;
 	}
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
