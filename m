From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 14/27] opensm/osm_sa_mcmember_record.c: In mcmr_rcv_join_mgrp, add MGID to log message
Date: Tue, 31 Jul 2012 19:04:42 +0300
Message-ID: <1343750695-28063-14-git-send-email-alexne@mellanox.com>
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
 opensm/osm_sa_mcmember_record.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index e591801..79d99ea 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -1124,13 +1124,16 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 				       p_sa_mad->comp_mask)
 	    || !validate_port_caps(sa->p_log, p_mgrp, p_physp)
 	    || !(join_state != 0)) {
+		char gid_str[INET6_ADDRSTRLEN];
 		/* since we might have created the new group we need to cleanup */
 		osm_mgrp_cleanup(sa->p_subn, p_mgrp);
 		CL_PLOCK_RELEASE(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B12: "
 			"validate_more_comp_fields, validate_port_caps, "
-			"or JoinState = 0 failed from port 0x%016" PRIx64
+			"or JoinState = 0 failed for MGID: %s port 0x%016" PRIx64
 			" (%s), " "sending IB_SA_MAD_STATUS_REQ_INVALID\n",
+			   inet_ntop(AF_INET6, p_mgrp->mcmember_rec.mgid.raw,
+				     gid_str, sizeof gid_str),
 			cl_ntoh64(portguid), p_port->p_node->print_desc);
 		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_REQ_INVALID);
 		goto Exit;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
