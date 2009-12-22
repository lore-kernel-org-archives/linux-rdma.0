From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] osm_sa_path_record.c: separate mutlicast processing code
Date: Tue, 22 Dec 2009 13:38:42 +0200
Message-ID: <20091222113842.GD26940@me>
References: <20091214164334.064102f0.weiny2@llnl.gov>
 <20091215170317.GV5262@me>
 <20091215171532.GA8288@obsidianresearch.com>
 <20091215091819.c217cf36.weiny2@llnl.gov>
 <f0e08f230912150959j536667bbg51b8381724681880@mail.gmail.com>
 <20091215185511.3ae458cc.weiny2@llnl.gov>
 <f0e08f230912160529h64424ba7id5c57dffb770380c@mail.gmail.com>
 <20091217181800.a1ee6b9b.weiny2@llnl.gov>
 <20091220195710.GA18524@me>
 <20091222113701.GC26940@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091222113701.GC26940@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Move multicast destination PR processing into separate function
pr_process_multicast(). As result also merge some duplicated code.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_path_record.c |  162 +++++++++++++++++------------------
 1 files changed, 79 insertions(+), 83 deletions(-)

diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index 082a41d..b78225e 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -1402,11 +1402,10 @@ static void pr_rcv_process_pair(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 }
 
 static ib_api_status_t pr_match_mgrp_attributes(IN osm_sa_t * sa,
-						IN const osm_madw_t * p_madw,
+						IN const ib_sa_mad_t * sa_mad,
 						IN const osm_mgrp_t * p_mgrp)
 {
 	const ib_path_rec_t *p_pr;
-	const ib_sa_mad_t *p_sa_mad;
 	ib_net64_t comp_mask;
 	const osm_port_t *port;
 	ib_api_status_t status = IB_ERROR;
@@ -1416,10 +1415,9 @@ static ib_api_status_t pr_match_mgrp_attributes(IN osm_sa_t * sa,
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
-	p_pr = ib_sa_mad_get_payload_ptr(p_sa_mad);
+	p_pr = ib_sa_mad_get_payload_ptr(sa_mad);
 
-	comp_mask = p_sa_mad->comp_mask;
+	comp_mask = sa_mad->comp_mask;
 
 	/* check that MLID of the MC group matches the PathRecord DLID */
 	if ((comp_mask & IB_PR_COMPMASK_DLID) && p_mgrp->mlid != p_pr->dlid)
@@ -1455,7 +1453,7 @@ static ib_api_status_t pr_match_mgrp_attributes(IN osm_sa_t * sa,
 
 	/* If SubnAdmGet, assume NumbPaths of 1 (1.2 erratum) */
 	if ((comp_mask & IB_PR_COMPMASK_NUMBPATH) &&
-	    (p_sa_mad->method != IB_MAD_METHOD_GET)) {
+	    (sa_mad->method != IB_MAD_METHOD_GET)) {
 		if (ib_path_rec_num_path(p_pr) == 0)
 			goto Exit;
 	}
@@ -1482,6 +1480,77 @@ Exit:
 	return status;
 }
 
+static void pr_process_multicast(osm_sa_t * sa, const ib_sa_mad_t *sa_mad,
+				 cl_qlist_t *list)
+{
+	ib_path_rec_t *pr = ib_sa_mad_get_payload_ptr(sa_mad);
+	osm_mgrp_t *mgrp;
+	ib_api_status_t status;
+	osm_pr_item_t *pr_item;
+	uint32_t flow_label;
+	uint8_t sl, hop_limit;
+
+	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Multicast destination requested\n");
+
+	mgrp = osm_get_mgrp_by_mgid(sa->p_subn, &pr->dgid);
+	if (!mgrp) {
+		char gid_str[INET6_ADDRSTRLEN];
+		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F09: "
+			"No MC group found for PathRecord destination GID %s\n",
+			inet_ntop(AF_INET6, pr->dgid.raw, gid_str,
+				  sizeof gid_str));
+		return;
+	}
+
+	/* Make sure the rest of the PathRecord matches the MC group attributes */
+	status = pr_match_mgrp_attributes(sa, sa_mad, mgrp);
+	if (status != IB_SUCCESS) {
+		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F19: "
+			"MC group attributes don't match PathRecord request\n");
+		return;
+	}
+
+	pr_item = malloc(sizeof(*pr_item));
+	if (pr_item == NULL) {
+		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F18: "
+			"Unable to allocate path record for MC group\n");
+		return;
+	}
+	memset(pr_item, 0, sizeof(*pr_item));
+
+	/* Copy PathRecord request into response */
+	pr_item->path_rec = *pr;
+
+	/* Now, use the MC info to cruft up the PathRecord response */
+	pr_item->path_rec.dgid = mgrp->mcmember_rec.mgid;
+	pr_item->path_rec.dlid = mgrp->mcmember_rec.mlid;
+	pr_item->path_rec.tclass = mgrp->mcmember_rec.tclass;
+	pr_item->path_rec.num_path = 1;
+	pr_item->path_rec.pkey = mgrp->mcmember_rec.pkey;
+
+	/* MTU, rate, and packet lifetime should be exactly */
+	pr_item->path_rec.mtu = (2 << 6) | mgrp->mcmember_rec.mtu;
+	pr_item->path_rec.rate = (2 << 6) | mgrp->mcmember_rec.rate;
+	pr_item->path_rec.pkt_life = (2 << 6) | mgrp->mcmember_rec.pkt_life;
+
+	/* SL, Hop Limit, and Flow Label */
+	ib_member_get_sl_flow_hop(mgrp->mcmember_rec.sl_flow_hop,
+				  &sl, &flow_label, &hop_limit);
+	ib_path_rec_set_sl(&pr_item->path_rec, sl);
+	ib_path_rec_set_qos_class(&pr_item->path_rec, 0);
+
+	/* HopLimit is not yet set in non link local MC groups */
+	/* If it were, this would not be needed */
+	if (ib_mgid_get_scope(&mgrp->mcmember_rec.mgid) !=
+	    IB_MC_SCOPE_LINK_LOCAL)
+		hop_limit = IB_HOPLIMIT_MAX;
+
+	pr_item->path_rec.hop_flow_raw =
+	    cl_hton32(hop_limit) | (flow_label << 8);
+
+	cl_qlist_insert_tail(list, &pr_item->list_item);
+}
+
 void osm_pr_rcv_process(IN void *context, IN void *data)
 {
 	osm_sa_t *sa = context;
@@ -1537,8 +1606,10 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 
 	/* Handle multicast destinations separately */
 	if ((p_sa_mad->comp_mask & IB_PR_COMPMASK_DGID) &&
-	    ib_gid_is_multicast(&p_pr->dgid));
-		goto McastDest;
+	    ib_gid_is_multicast(&p_pr->dgid)) {
+		pr_process_multicast(sa, p_sa_mad, &pr_list);
+		goto Unlock;
+	}
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Unicast destination requested\n");
 
@@ -1575,81 +1646,6 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 						     &pr_list);
 		}
 	}
-	goto Unlock;
-
-McastDest:
-	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Multicast destination requested\n");
-	{
-		osm_mgrp_t *p_mgrp = NULL;
-		ib_api_status_t status;
-		osm_pr_item_t *p_pr_item;
-		uint32_t flow_label;
-		uint8_t sl;
-		uint8_t hop_limit;
-
-		/* First, get the MC info */
-		p_mgrp = osm_get_mgrp_by_mgid(sa->p_subn, &p_pr->dgid);
-		if (!p_mgrp) {
-			char gid_str[INET6_ADDRSTRLEN];
-			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F09: "
-				"No MC group found for PathRecord destination GID %s\n",
-				inet_ntop(AF_INET6, p_pr->dgid.raw, gid_str,
-					  sizeof gid_str));
-			goto Unlock;
-		}
-
-		/* Make sure the rest of the PathRecord matches the MC group attributes */
-		status = pr_match_mgrp_attributes(sa, p_madw, p_mgrp);
-		if (status != IB_SUCCESS) {
-			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F19: "
-				"MC group attributes don't match PathRecord request\n");
-			goto Unlock;
-		}
-
-		p_pr_item = malloc(sizeof(*p_pr_item));
-		if (p_pr_item == NULL) {
-			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F18: "
-				"Unable to allocate path record for MC group\n");
-			goto Unlock;
-		}
-		memset(p_pr_item, 0, sizeof(*p_pr_item));
-
-		/* Copy PathRecord request into response */
-		p_sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
-		p_pr = (ib_path_rec_t *)
-		    ib_sa_mad_get_payload_ptr(p_sa_mad);
-		p_pr_item->path_rec = *p_pr;
-
-		/* Now, use the MC info to cruft up the PathRecord response */
-		p_pr_item->path_rec.dgid = p_mgrp->mcmember_rec.mgid;
-		p_pr_item->path_rec.dlid = p_mgrp->mcmember_rec.mlid;
-		p_pr_item->path_rec.tclass = p_mgrp->mcmember_rec.tclass;
-		p_pr_item->path_rec.num_path = 1;
-		p_pr_item->path_rec.pkey = p_mgrp->mcmember_rec.pkey;
-
-		/* MTU, rate, and packet lifetime should be exactly */
-		p_pr_item->path_rec.mtu = (2 << 6) | p_mgrp->mcmember_rec.mtu;
-		p_pr_item->path_rec.rate = (2 << 6) | p_mgrp->mcmember_rec.rate;
-		p_pr_item->path_rec.pkt_life =
-		    (2 << 6) | p_mgrp->mcmember_rec.pkt_life;
-
-		/* SL, Hop Limit, and Flow Label */
-		ib_member_get_sl_flow_hop(p_mgrp->mcmember_rec.sl_flow_hop,
-					  &sl, &flow_label, &hop_limit);
-		ib_path_rec_set_sl(&p_pr_item->path_rec, sl);
-		ib_path_rec_set_qos_class(&p_pr_item->path_rec, 0);
-
-		/* HopLimit is not yet set in non link local MC groups */
-		/* If it were, this would not be needed */
-		if (ib_mgid_get_scope(&p_mgrp->mcmember_rec.mgid) !=
-		    IB_MC_SCOPE_LINK_LOCAL)
-			hop_limit = IB_HOPLIMIT_MAX;
-
-		p_pr_item->path_rec.hop_flow_raw =
-		    cl_hton32(hop_limit) | (flow_label << 8);
-
-		cl_qlist_insert_tail(&pr_list, &p_pr_item->list_item);
-	}
 
 Unlock:
 	cl_plock_release(sa->p_lock);
-- 
1.6.6.rc4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
