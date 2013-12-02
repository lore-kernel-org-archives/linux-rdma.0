From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] osm_mcast_mgr.c: fixed missing error message number
Date: Mon, 02 Dec 2013 10:04:13 -0500
Message-ID: <529CA16D.3070507@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Added number to error message on osm_mcast_mgr.c\mcast_mgr_branch
when multicast tree depth is more than 64.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_mcast_mgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
index 65df552..a3c6185 100644
--- a/opensm/osm_mcast_mgr.c
+++ b/opensm/osm_mcast_mgr.c
@@ -811,7 +811,7 @@ static osm_mtree_node_t *mcast_mgr_branch(osm_sm_t * sm, uint16_t mlid_ho,
 	depth++;
 
 	if (depth >= 64) {
-		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A21: "
 			"Maximal hops number is reached for MLID 0x%x."
 			" Break processing.", mlid_ho);
 		mcast_mgr_purge_list(sm, p_list);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
