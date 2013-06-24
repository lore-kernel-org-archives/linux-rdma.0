From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_ucast_mgr.c: Fix duplicated code for fallback
 routing engine
Date: Mon, 24 Jun 2013 10:33:05 -0400
Message-ID: <51C858A1.2050307@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_mgr.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 611c5bc..aea69ef 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -1537,14 +1537,7 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
 	if (!p_osm->routing_engine_used &&
 	    p_osm->no_fallback_routing_engine != TRUE) {
 		/* If configured routing algorithm failed, use default MinHop */
-		struct osm_routing_engine *r = p_osm->default_routing_engine;
-
-		r->build_lid_matrices(r->context);
-		failed = r->ucast_build_fwd_tables(r->context);
-		if (!failed) {
-			p_osm->routing_engine_used = r;
-			osm_ucast_mgr_set_fwd_tables(p_mgr);
-		}
+		failed = ucast_mgr_route(p_osm->default_routing_engine, p_osm);
 	}
 
 	/* if for some reason different routing engine is used */
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
