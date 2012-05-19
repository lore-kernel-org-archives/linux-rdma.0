From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/3] opensm/osm_ucast_dfsssp.c: Fix memory leak on
 dfsssp_context_destroy()
Date: Sat, 19 May 2012 22:48:58 +0300
Message-ID: <20120519194858.GD2110@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
---
 opensm/osm_ucast_dfsssp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index e4cf017..1e3ade1 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -2137,6 +2137,8 @@ static void dfsssp_context_destroy(void *context)
 	/* free srcdest2vl table (can be done because, dfsssp_context_destroy is called after osm_get_dfsssp_sl) */
 	vltable_dealloc(&(dfsssp_ctx->srcdest2vl_table));
 	dfsssp_ctx->srcdest2vl_table = NULL;
+
+	free(context);
 }
 
 static void delete(void *context)
-- 
1.7.7.6


-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
