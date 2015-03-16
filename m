From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sa_mcmember_record.c: Extend P_Pkey validation
 on MCMemberRecord(Join)
Date: Mon, 16 Mar 2015 13:09:19 -0400
Message-ID: <55070E3F.2030005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Verify that a port that joins a multicast group is in
the partition for that MC group.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_mcmember_record.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 227742a..8d7938d 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -1197,6 +1197,24 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 		goto Exit;
 	}
 
+	/* verify that the joining port is in the partition of the group */
+	if (!osm_physp_has_pkey(sa->p_log, p_mgrp->mcmember_rec.pkey, p_physp)) {
+		char gid_str[INET6_ADDRSTRLEN];
+		if (is_new_group)
+			osm_mgrp_cleanup(sa->p_subn, p_mgrp);
+		CL_PLOCK_RELEASE(sa->p_lock);
+		memset(gid_str, 0, sizeof(gid_str));
+		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B14: "
+			"Cannot join port 0x%016" PRIx64 " to MGID %s - "
+			"Port is not in partition of this MC group\n",
+			cl_ntoh64(portguid),
+			inet_ntop(AF_INET6,
+				  p_mgrp->mcmember_rec.mgid.raw,
+				  gid_str, sizeof(gid_str)));
+		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_REQ_INVALID);
+		goto Exit;
+	}
+
 	/*
 	 * o15-0.2.1 requires validation of the requesting port
 	 * in the case of modification:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
