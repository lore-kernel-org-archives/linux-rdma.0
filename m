From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_ftree.c: fixing another memory leak at
	error path
Date: Tue, 7 Sep 2010 18:11:55 +0300
Message-ID: <4C86563B.4070007@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_ucast_ftree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/opensm/osm_ucast_ftree.c b/opensm/opensm/osm_ucast_ftree.c
index fb46d0f..d161bc8 100644
--- a/opensm/opensm/osm_ucast_ftree.c
+++ b/opensm/opensm/osm_ucast_ftree.c
@@ -1670,13 +1670,13 @@ static int fabric_create_leaf_switch_array(IN ftree_fabric_t * p_ftree)
 	       &(all_switches_at_leaf_level[first_leaf_idx]),
 	       p_ftree->leaf_switches_num * sizeof(ftree_sw_t *));

-	free(all_switches_at_leaf_level);
-
 	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
 		"Created array of %u leaf switches\n",
 		p_ftree->leaf_switches_num);

 Exit:
+	if (all_switches_at_leaf_level)
+		free(all_switches_at_leaf_level);
 	OSM_LOG_EXIT(&p_ftree->p_osm->log);
 	return res;
 }				/* fabric_create_leaf_switch_array() */
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
