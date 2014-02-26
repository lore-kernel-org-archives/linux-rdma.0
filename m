From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_path_record.c: Search for requester port should be under lock
Date: Wed, 26 Feb 2014 12:52:01 +0200
Message-ID: <1393411921-25229-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It might colide with the sweep operations.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_path_record.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index d9c59b8..203cfc0 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -1727,23 +1727,6 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 		goto Exit;
 	}
 
-	/* update the requester physical port */
-	requester_port = osm_get_port_by_mad_addr(sa->p_log, sa->p_subn,
-						  osm_madw_get_mad_addr_ptr
-						  (p_madw));
-	if (requester_port == NULL) {
-		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F16: "
-			"Cannot find requester physical port\n");
-		goto Exit;
-	}
-
-	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
-		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
-			"Requester port GUID 0x%" PRIx64 "\n",
-			cl_ntoh64(osm_port_get_guid(requester_port)));
-		osm_dump_path_record_v2(sa->p_log, p_pr, FILE_ID, OSM_LOG_DEBUG);
-	}
-
 	/* Validate rate if supplied */
 	if ((p_sa_mad->comp_mask & IB_PR_COMPMASK_RATESELEC) &&
 	    (p_sa_mad->comp_mask & IB_PR_COMPMASK_RATE)) {
@@ -1781,6 +1764,24 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 	 */
 	cl_plock_acquire(sa->p_lock);
 
+	/* update the requester physical port */
+	requester_port = osm_get_port_by_mad_addr(sa->p_log, sa->p_subn,
+						  osm_madw_get_mad_addr_ptr
+						  (p_madw));
+	if (requester_port == NULL) {
+		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F16: "
+			"Cannot find requester physical port\n");
+		cl_plock_release(sa->p_lock);
+		goto Exit;
+	}
+
+	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Requester port GUID 0x%" PRIx64 "\n",
+			cl_ntoh64(osm_port_get_guid(requester_port)));
+		osm_dump_path_record_v2(sa->p_log, p_pr, FILE_ID, OSM_LOG_DEBUG);
+	}
+
 	/* Handle multicast destinations separately */
 	if ((p_sa_mad->comp_mask & IB_PR_COMPMASK_DGID) &&
 	    ib_gid_is_multicast(&p_pr->dgid)) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
