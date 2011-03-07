From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fixed sizeof of pointer allocation in
 osm_ucast_lash()
Date: Mon, 7 Mar 2011 13:24:23 +0200
Message-ID: <20110307112423.GL5577@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This fix is a cosmetic one, but this is the corect way to define sizeof in malloc.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_lash.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_ucast_lash.c b/opensm/osm_ucast_lash.c
index 0bd1827..739eedd 100644
--- a/opensm/osm_ucast_lash.c
+++ b/opensm/osm_ucast_lash.c
@@ -710,13 +710,13 @@ static int init_lash_structures(lash_t * p_lash)
 
 	/* initialise cdg_vertex_matrix[num_switches][num_switches][num_switches] */
 	p_lash->cdg_vertex_matrix =
-	    (cdg_vertex_t ****) malloc(vl_min * sizeof(cdg_vertex_t ****));
+	    (cdg_vertex_t ****) malloc(vl_min * sizeof(cdg_vertex_t ***));
 	if (p_lash->cdg_vertex_matrix == NULL)
 		goto Exit_Mem_Error;
 	for (i = 0; i < vl_min; i++) {
 		p_lash->cdg_vertex_matrix[i] =
 		    (cdg_vertex_t ***) malloc(num_switches *
-					      sizeof(cdg_vertex_t ***));
+					      sizeof(cdg_vertex_t **));
 
 		if (p_lash->cdg_vertex_matrix[i] == NULL)
 			goto Exit_Mem_Error;
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
