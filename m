From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_lash.c: small bug in calculating allocated
	size
Date: Tue, 7 Sep 2010 18:15:09 +0300
Message-ID: <4C8656FD.8090100@mellanox.co.il>
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
 opensm/opensm/osm_ucast_lash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_ucast_lash.c b/opensm/opensm/osm_ucast_lash.c
index 4669946..2081296 100644
--- a/opensm/opensm/osm_ucast_lash.c
+++ b/opensm/opensm/osm_ucast_lash.c
@@ -726,7 +726,7 @@ static int init_lash_structures(lash_t * p_lash)
 		for (j = 0; j < num_switches; j++) {
 			p_lash->cdg_vertex_matrix[i][j] =
 			    (cdg_vertex_t **) malloc(num_switches *
-						     sizeof(cdg_vertex_t **));
+						     sizeof(cdg_vertex_t *));
 			if (p_lash->cdg_vertex_matrix[i][j] == NULL)
 				goto Exit_Mem_Error;

-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
