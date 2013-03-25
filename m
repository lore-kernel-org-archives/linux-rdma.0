From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: fix dfsssp uninitialized value
Date: Mon, 25 Mar 2013 08:08:05 -0400
Message-ID: <51503E25.4000608@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jens Domke <domke.j.aa@m.titech.ac.jp>, Ammar Haj Hamad <AHamad-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 032d4100467cb1b3e1ed5dc81911aaa704f709dc Mon Sep 17 00:00:00 2001
From: Ammar Haj Hamad <AHamad-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
Date: Mon, 25 Mar 2013 12:41:35 +0200
Subject: [PATCH] opensm: fix dfsssp uninitialized value

in dfsssp_context_create dfsssp_ctx->adj_list_size is not initialized.
and might cause segmentation fault when destroying the routing engine.

Signed-off-by: Ammar Haj Hamad <AHamad-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_dfsssp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index 803d0e1..01ad03b 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -2240,6 +2240,7 @@ static dfsssp_context_t *dfsssp_context_create(osm_opensm_t * p_osm,
 		dfsssp_ctx->routing_type = routing_type;
 		dfsssp_ctx->p_mgr = (osm_ucast_mgr_t *) & (p_osm->sm.ucast_mgr);
 		dfsssp_ctx->adj_list = NULL;
+		dfsssp_ctx->adj_list_size = 0;
 		dfsssp_ctx->srcdest2vl_table = NULL;
 	} else {
 		OSM_LOG(p_osm->sm.ucast_mgr.p_log, OSM_LOG_ERROR,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
