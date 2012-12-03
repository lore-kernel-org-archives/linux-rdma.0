From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_ftree.c: Eliminate unneeded NULL pointer
 checks prior to calls to free
Date: Mon, 03 Dec 2012 10:26:07 -0500
Message-ID: <50BCC48F.4070705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_ftree.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 133fd4f..d58fff1 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -341,8 +341,6 @@ static ftree_sw_tbl_element_t *sw_tbl_element_create(IN ftree_sw_t * p_sw)
 
 static void sw_tbl_element_destroy(IN ftree_sw_tbl_element_t * p_element)
 {
-	if (!p_element)
-		return;
 	free(p_element);
 }
 
@@ -370,8 +368,7 @@ static ftree_port_t *port_create(IN uint8_t port_num,
 
 static void port_destroy(IN ftree_port_t * p_port)
 {
-	if (p_port)
-		free(p_port);
+	free(p_port);
 }
 
 /***************************************************
@@ -609,12 +606,9 @@ static void sw_destroy(IN ftree_fabric_t * p_ftree, IN ftree_sw_t * p_sw)
 		port_group_destroy(p_sw->sibling_port_groups[i]);
 	for (i = 0; i < p_sw->up_port_groups_num; i++)
 		port_group_destroy(p_sw->up_port_groups[i]);
-	if (p_sw->down_port_groups)
-		free(p_sw->down_port_groups);
-	if (p_sw->sibling_port_groups)
-		free(p_sw->sibling_port_groups);
-	if (p_sw->up_port_groups)
-		free(p_sw->up_port_groups);
+	free(p_sw->down_port_groups);
+	free(p_sw->sibling_port_groups);
+	free(p_sw->up_port_groups);
 
 	free(p_sw);
 }				/* sw_destroy() */
@@ -829,8 +823,7 @@ static void hca_destroy(IN ftree_hca_t * p_hca)
 	for (i = 0; i < p_hca->up_port_groups_num; i++)
 		port_group_destroy(p_hca->up_port_groups[i]);
 
-	if (p_hca->up_port_groups)
-		free(p_hca->up_port_groups);
+	free(p_hca->up_port_groups);
 
 	free(p_hca);
 }
@@ -1702,8 +1695,7 @@ static int fabric_create_leaf_switch_array(IN ftree_fabric_t * p_ftree)
 		p_ftree->leaf_switches_num);
 
 Exit:
-	if (all_switches_at_leaf_level)
-		free(all_switches_at_leaf_level);
+	free(all_switches_at_leaf_level);
 	OSM_LOG_EXIT(&p_ftree->p_osm->log);
 	return res;
 }				/* fabric_create_leaf_switch_array() */
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
