From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_mtree.c: removing useless 'if' statement
Date: Tue, 7 Sep 2010 17:53:54 +0300
Message-ID: <4C865202.9020105@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

p_mtn->max_children is an array - no point checking if it is NULL.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_mtree.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/opensm/opensm/osm_mtree.c b/opensm/opensm/osm_mtree.c
index b5ce73b..693d0d5 100644
--- a/opensm/opensm/osm_mtree.c
+++ b/opensm/opensm/osm_mtree.c
@@ -73,11 +73,10 @@ void osm_mtree_destroy(IN osm_mtree_node_t * p_mtn)
 	if (p_mtn == NULL)
 		return;

-	if (p_mtn->child_array != NULL)
-		for (i = 0; i < p_mtn->max_children; i++)
-			if ((p_mtn->child_array[i] != NULL) &&
-			    (p_mtn->child_array[i] != OSM_MTREE_LEAF))
-				osm_mtree_destroy(p_mtn->child_array[i]);
+	for (i = 0; i < p_mtn->max_children; i++)
+		if ((p_mtn->child_array[i] != NULL) &&
+		    (p_mtn->child_array[i] != OSM_MTREE_LEAF))
+			osm_mtree_destroy(p_mtn->child_array[i]);

 	free(p_mtn);
 }
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
