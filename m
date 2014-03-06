From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_state_mgr.c: Remove redundant unset to first_time_master_sweep
Date: Thu, 06 Mar 2014 08:59:27 -0500
Message-ID: <53187F3F.7000306@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 18 Jul 2013 11:08:14 +0300

We should clear first_time_master_sweep anyway during the first sweep.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_state_mgr.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 0dd89e9..06cb763 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -2213,7 +2213,6 @@ repeat_discovery:
 		sm->p_subn->need_update = 0;
 		osm_dump_all(sm->p_subn->p_osm);
 		state_mgr_up_msg(sm);
-		sm->p_subn->first_time_master_sweep = FALSE;
 
 		if (OSM_LOG_IS_ACTIVE_V2(sm->p_log, OSM_LOG_VERBOSE) ||
 		    sm->p_subn->opt.sa_db_dump)
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
