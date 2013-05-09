From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_dfsssp.c: Fix unused variable in update_mcft()
Date: Thu,  9 May 2013 18:48:09 +0300
Message-ID: <1368114489-20424-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

counter isn't being used.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_dfsssp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index be13458..7b77eed 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -1611,8 +1611,6 @@ static int update_mcft(osm_sm_t * p_sm, vertex_t * adj_list,
 		   the downstream port of the next switch to the mcast table
 		   until we reach the root_sw
 		 */
-		int counter;
-		counter = 0;
 		curr_adj = &adj_list[i];
 		while (curr_adj->sw != root_sw) {
 			/* the used_link is the link that was used in dijkstra to reach this node,
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
