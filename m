From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 08/10] OpenSM: dfsssp - avoid unnecessary nested loop in vltable_print for OSM_LOG_INFO
Date: Wed, 23 Jan 2013 01:41:31 +0900
Message-ID: <1358872891-17049-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>, Jens Domke <domke.j.aa@m.titech.ac.jp>
List-Id: linux-rdma@vger.kernel.org

for OSM_LOG_INFO the debug function vltable_print was called, which
iterates in a nested loop over all LIDs and only prints stuff for OSM_LOG_DEBUG;
therefor we move vltable_print into a separated if clause

Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index b82d8c8..32bc8f1 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -1940,10 +1940,13 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 		goto ERROR;
 	}
 	/* else { no balancing } */
-	if (OSM_LOG_IS_ACTIVE_V2(p_mgr->p_log, OSM_LOG_INFO)) {
+
+	if (OSM_LOG_IS_ACTIVE_V2(p_mgr->p_log, OSM_LOG_DEBUG)) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 			"Virtual Lanes per src/dest combination after balancing:\n");
 		vltable_print(p_mgr, srcdest2vl_table);
+	}
+	if (OSM_LOG_IS_ACTIVE_V2(p_mgr->p_log, OSM_LOG_INFO)) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
 			"Paths per VL (after balancing):\n");
 		for (i = 0; i < vl_avail; i++)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
