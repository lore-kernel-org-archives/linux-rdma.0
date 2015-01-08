From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm 1/5] osm_ucast_mgr.c: Force unicast routing to fail
 when lft allocations fail
Date: Thu, 08 Jan 2015 07:49:41 -0500
Message-ID: <54AE7CE5.20203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Force unicast routing to fail when OpenSM fails to allocate memory for
new_lft buffers for all the switches.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_mgr.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 9f435c6..a52b044 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -1096,7 +1096,7 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
 	osm_opensm_t *p_osm;
 	struct osm_routing_engine *p_routing_eng;
 	cl_qmap_t *p_sw_guid_tbl;
-	int failed = 0;
+	int failed = -1;
 
 	OSM_LOG_ENTER(p_mgr->p_log);
 
@@ -1113,7 +1113,6 @@ int osm_ucast_mgr_process(IN osm_ucast_mgr_t * p_mgr)
 	    ucast_mgr_setup_all_switches(p_mgr->p_subn) < 0)
 		goto Exit;
 
-	failed = -1;
 	p_osm->routing_engine_used = NULL;
 	while (p_routing_eng) {
 		failed = ucast_mgr_route(p_routing_eng, p_osm);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
