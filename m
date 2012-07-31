From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 02/27] Add support to reread configuration file when stacked in rediscovery loop.
Date: Tue, 31 Jul 2012 19:04:30 +0300
Message-ID: <1343750695-28063-2-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If SM is stucked in continuous rediscovery loop, it will never reach
rereading the configuration files.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_state_mgr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 4d762a3..e8c76c0 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1251,8 +1251,10 @@ repeat_discovery:
 	}
 
 	/* if new sweep requested - don't bother with the rest */
-	if (sm->p_subn->force_heavy_sweep)
+	if (sm->p_subn->force_heavy_sweep) {
+		config_parsed = 0;
 		goto repeat_discovery;
+	}
 
 	osm_opensm_report_event(sm->p_subn->p_osm,
 				OSM_EVENT_ID_HEAVY_SWEEP_DONE, NULL);
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
