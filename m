From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fix crash in DFSSSP routing engine on reroute
Date: Sun, 12 Aug 2012 09:44:33 +0300
Message-ID: <20120812064433.GA14539@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Cc: Torsten Hoefler <htor-nzINlOoChub2fBVCVOL8/A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Routing engine should delete the context only when calling delete
function.

Found-and-fixed-by: Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_dfsssp.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index d6d65b1..ffc317f 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -2135,12 +2135,11 @@ static void dfsssp_context_destroy(void *context)
 	}
 	free(adj_list);
 	dfsssp_ctx->adj_list = NULL;
+	dfsssp_ctx->adj_list_size = 0;
 
 	/* free srcdest2vl table (can be done because, dfsssp_context_destroy is called after osm_get_dfsssp_sl) */
 	vltable_dealloc(&(dfsssp_ctx->srcdest2vl_table));
 	dfsssp_ctx->srcdest2vl_table = NULL;
-
-	free(context);
 }
 
 static void delete(void *context)
@@ -2148,6 +2147,8 @@ static void delete(void *context)
 	if (!context)
 		return;
 	dfsssp_context_destroy(context);
+
+	free(context);
 }
 
 int osm_ucast_dfsssp_setup(struct osm_routing_engine *r, osm_opensm_t * p_osm)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
