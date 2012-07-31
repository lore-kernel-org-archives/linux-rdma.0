From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 16/27] opensm/osm_sa_path_record.c: Log requester port GUID at DEBUG level
Date: Tue, 31 Jul 2012 19:04:44 +0300
Message-ID: <1343750695-28063-16-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_path_record.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index f06696d..e426ce7 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -1720,8 +1720,12 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 		goto Exit;
 	}
 
-	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG))
+	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Requester port GUID 0x%" PRIx64 "\n",
+			cl_ntoh64(osm_port_get_guid(requester_port)));
 		osm_dump_path_record_v2(sa->p_log, p_pr, FILE_ID, OSM_LOG_DEBUG);
+	}
 
 	/* Validate rate if supplied */
 	if ((p_sa_mad->comp_mask & IB_PR_COMPMASK_RATESELEC) &&
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
