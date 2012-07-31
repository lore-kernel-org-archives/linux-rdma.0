From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 17/27] opensm/osm_sa_mcmember_record.c: Log requester port GUID at DEBUG level
Date: Tue, 31 Jul 2012 19:04:45 +0300
Message-ID: <1343750695-28063-17-git-send-email-alexne@mellanox.com>
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
 opensm/osm_sa_mcmember_record.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 79d99ea..c6069d6 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -913,6 +913,18 @@ static void mcmr_rcv_leave_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	mcmember_rec = *p_recvd_mcmember_rec;
 
 	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
+		osm_physp_t *p_req_physp;
+
+		p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
+							osm_madw_get_mad_addr_ptr(p_madw));
+		if (p_req_physp == NULL) {
+			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B02: "
+				"Cannot find requester physical port\n");
+		} else {
+			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+				"Requester port GUID 0x%" PRIx64 "\n",
+				cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
+		}
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Dump of record\n");
 		osm_dump_mc_record_v2(sa->p_log, &mcmember_rec, FILE_ID, OSM_LOG_DEBUG);
 	}
@@ -988,6 +1000,18 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	mcmember_rec = *p_recvd_mcmember_rec;
 
 	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
+		osm_physp_t *p_req_physp;
+
+		p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
+							osm_madw_get_mad_addr_ptr(p_madw));
+		if (p_req_physp == NULL) {
+			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B03: "
+				"Cannot find requester physical port\n");
+		} else {
+			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+				"Requester port GUID 0x%" PRIx64 "\n",
+				cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
+		}
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Dump of incoming record\n");
 		osm_dump_mc_record_v2(sa->p_log, &mcmember_rec, FILE_ID, OSM_LOG_DEBUG);
 	}
@@ -1398,7 +1422,7 @@ static void mcmr_query_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	 */
 	trusted_req = (p_rcvd_mad->sm_key != 0);
 
-	/* update the requester physical port. */
+	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
@@ -1409,6 +1433,9 @@ static void mcmr_query_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	}
 
 	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Requester port GUID 0x%" PRIx64 "\n",
+			cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Dump of record\n");
 		osm_dump_mc_record(sa->p_log, p_rcvd_rec, OSM_LOG_DEBUG);
 	}
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
