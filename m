From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_ftree.c: fix opensm segfault in osm_ucast_ftree.c
Date: Mon,  4 Feb 2013 15:20:09 +0200
Message-ID: <1359984011-30753-8-git-send-email-alexne@mellanox.com>
References: <1359984011-30753-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359984011-30753-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>

Instead of unconditionnally assigning valid port numbers to the lft table, it now leaves 'holes' filled with the default value OSM_NO_PATH (=255)
Accessing these invalid/unassigned LFT entries yields invalid addresses starting with 0xff as in the above example.

After reverting commit 81dade3aeb1d5c80472a4f9fef55e9916bb38d3a and applying the above patch, we have not observed any multicast loop nor any segmentation fault.

Reproducing this bug using ibsim is easy:
1/ Load a fat-tree topology
2/ Unlink a leaf switch
3/ Start opensm (configured with the ftree routing engine)
4/ Relink the leaf switch

Signed-off-by: Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_ftree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index c81e7a3..932ec6a 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -4171,6 +4171,9 @@ static int construct_fabric(IN void *context)
 	OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
 		"Max LID in switch LFTs: %u\n", p_ftree->lft_max_lid);
 
+	/* Build the full lid matrices needed for multicast routing */
+	osm_ucast_mgr_build_lid_matrices(&p_ftree->p_osm->sm.ucast_mgr);
+
 Exit:
 	if (status != 0) {
 		OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_VERBOSE,
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
