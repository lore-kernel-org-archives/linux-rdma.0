From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 15/27] opensm/osm_sa_path_record.c: Add debug logging to pr_match_mgrp_attributes
Date: Tue, 31 Jul 2012 19:04:43 +0300
Message-ID: <1343750695-28063-15-git-send-email-alexne@mellanox.com>
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
 opensm/osm_sa_path_record.c | 59 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 9 deletions(-)

diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index d37d35c..f06696d 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -1517,50 +1517,91 @@ static ib_api_status_t pr_match_mgrp_attributes(IN osm_sa_t * sa,
 	OSM_LOG_ENTER(sa->p_log);
 
 	/* check that MLID of the MC group matches the PathRecord DLID */
-	if ((comp_mask & IB_PR_COMPMASK_DLID) && p_mgrp->mlid != p_pr->dlid)
+	if ((comp_mask & IB_PR_COMPMASK_DLID) && p_mgrp->mlid != p_pr->dlid) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"DLID 0x%x is not MLID 0x%x for MC group\n",
+			 cl_ntoh16(p_pr->dlid), cl_ntoh16(p_mgrp->mlid));
 		goto Exit;
+	}
 
 	/* If SGID and/or SLID specified, should validate as member of MC group */
 	if (comp_mask & IB_PR_COMPMASK_SGID) {
 		if (!osm_mgrp_get_mcm_alias_guid(p_mgrp,
-						 p_pr->sgid.unicast.interface_id))
+						 p_pr->sgid.unicast.interface_id)) {
+			char gid_str[INET6_ADDRSTRLEN];
+			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+				"SGID %s is not a member of MC group\n",
+				inet_ntop(AF_INET6, p_pr->sgid.raw,
+					  gid_str, sizeof gid_str));
 			goto Exit;
+		}
 	}
 
 	if (comp_mask & IB_PR_COMPMASK_SLID) {
 		port = osm_get_port_by_lid(sa->p_subn, p_pr->slid);
-		if (!port || !osm_mgrp_get_mcm_port(p_mgrp, port->guid))
+		if (!port || !osm_mgrp_get_mcm_port(p_mgrp, port->guid)) {
+			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+				"Either no port with SLID %u found or "
+				"SLID not a member of MC group\n",
+				cl_ntoh16(p_pr->slid));
 			goto Exit;
+		}
 	}
 
 	/* Also, MTU, rate, packet lifetime, and raw traffic requested are not currently checked */
 	if ((comp_mask & IB_PR_COMPMASK_PKEY) &&
-	    p_pr->pkey != p_mgrp->mcmember_rec.pkey)
+	    p_pr->pkey != p_mgrp->mcmember_rec.pkey) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Pkey 0x%x doesn't match MC group Pkey 0x%x\n",
+			cl_ntoh16(p_pr->pkey),
+			cl_ntoh16(p_mgrp->mcmember_rec.pkey));
 		goto Exit;
+	}
 
 	ib_member_get_sl_flow_hop(p_mgrp->mcmember_rec.sl_flow_hop,
 				  &sl, &flow_label, &hop_limit);
 
-	if ((comp_mask & IB_PR_COMPMASK_SL) && ib_path_rec_sl(p_pr) != sl)
+	if ((comp_mask & IB_PR_COMPMASK_SL) && ib_path_rec_sl(p_pr) != sl) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"SL %d doesn't match MC group SL %d\n",
+			ib_path_rec_sl(p_pr), sl);
 		goto Exit;
+	}
 
 	/* If SubnAdmGet, assume NumbPaths of 1 (1.2 erratum) */
 	if ((comp_mask & IB_PR_COMPMASK_NUMBPATH) &&
 	    sa_mad->method != IB_MAD_METHOD_GET &&
-	    ib_path_rec_num_path(p_pr) == 0)
+	    ib_path_rec_num_path(p_pr) == 0) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Number of paths requested is 0\n");
 		goto Exit;
+	}
 
 	if ((comp_mask & IB_PR_COMPMASK_FLOWLABEL) &&
-	    ib_path_rec_flow_lbl(p_pr) != flow_label)
+	    ib_path_rec_flow_lbl(p_pr) != flow_label) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Flow label 0x%x doesn't match MC group "
+			" flow label 0x%x\n",
+			ib_path_rec_flow_lbl(p_pr), flow_label);
 		goto Exit;
+	}
 
 	if ((comp_mask & IB_PR_COMPMASK_HOPLIMIT) &&
-	    ib_path_rec_hop_limit(p_pr) != hop_limit)
+	    ib_path_rec_hop_limit(p_pr) != hop_limit) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Hop limit %u doesn't match MC group hop limit %u\n",
+			ib_path_rec_hop_limit(p_pr), hop_limit);
 		goto Exit;
+	}
+
 
 	if ((comp_mask & IB_PR_COMPMASK_TCLASS) &&
-	    p_pr->tclass != p_mgrp->mcmember_rec.tclass)
+	    p_pr->tclass != p_mgrp->mcmember_rec.tclass) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"TClass 0x%02x doesn't match MC group TClass 0x%02x\n",
+			p_pr->tclass, p_mgrp->mcmember_rec.tclass);
 		goto Exit;
+	}
 
 	status = IB_SUCCESS;
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
