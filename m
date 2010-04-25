From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_lid_mgr.c: fix memory leak
Date: Sun, 25 Apr 2010 17:06:32 +0300
Message-ID: <20100425140632.GP23994@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When during LIDs assignment process free lid range is consumed its
memory should be freed (as well as removing from free ranges list).

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_lid_mgr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/opensm/opensm/osm_lid_mgr.c b/opensm/opensm/osm_lid_mgr.c
index f14d377..9896196 100644
--- a/opensm/opensm/osm_lid_mgr.c
+++ b/opensm/opensm/osm_lid_mgr.c
@@ -636,11 +636,12 @@ static void lid_mgr_find_free_lid_range(IN osm_lid_mgr_t * p_mgr,
 		/* but we can be out of the range */
 		if (lid + num_lids - 1 <= p_range->max_lid) {
 			/* ok let us use that range */
-			if (lid + num_lids - 1 == p_range->max_lid)
+			if (lid + num_lids - 1 == p_range->max_lid) {
 				/* we consumed the entire range */
 				cl_qlist_remove_item(&p_mgr->free_ranges,
 						     p_item);
-			else
+				free(p_item);
+			} else
 				/* only update the available range */
 				p_range->min_lid = lid + num_lids;
 
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
