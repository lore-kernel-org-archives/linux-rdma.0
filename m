From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_path_record.c: MGID must be specified
 explicitly
Date: Tue, 22 Dec 2009 13:37:01 +0200
Message-ID: <20091222113701.GC26940@me>
References: <20091214164334.064102f0.weiny2@llnl.gov>
 <20091215170317.GV5262@me>
 <20091215171532.GA8288@obsidianresearch.com>
 <20091215091819.c217cf36.weiny2@llnl.gov>
 <f0e08f230912150959j536667bbg51b8381724681880@mail.gmail.com>
 <20091215185511.3ae458cc.weiny2@llnl.gov>
 <f0e08f230912160529h64424ba7id5c57dffb770380c@mail.gmail.com>
 <20091217181800.a1ee6b9b.weiny2@llnl.gov>
 <20091220195710.GA18524@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091220195710.GA18524@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


IBA 1.2.1 states (Vol.1, 15.2.5.16, p.918) that DGID shell be explicitly
specified when path destination of SA PathRecord query is multicast
group. So ignore all other cases when choosing multicast PR destination.
Other related parameters (mlid) is checked in pr_match_mgrp_attributes()
anyway. As result consolidate many of effectively duplicate code.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_path_record.c |   88 +++++-------------------------------
 1 files changed, 11 insertions(+), 77 deletions(-)

diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index fbeef03..082a41d 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -1401,34 +1401,6 @@ static void pr_rcv_process_pair(IN osm_sa_t * sa, IN const osm_madw_t * p_madw,
 	OSM_LOG_EXIT(sa->p_log);
 }
 
-static osm_mgrp_t *pr_get_mgrp(IN osm_sa_t * sa, IN const osm_madw_t * p_madw)
-{
-	ib_path_rec_t *p_pr;
-	const ib_sa_mad_t *p_sa_mad;
-	osm_mgrp_t *mgrp;
-
-	p_sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
-	p_pr = ib_sa_mad_get_payload_ptr(p_sa_mad);
-
-	if (!(p_sa_mad->comp_mask & IB_PR_COMPMASK_DGID)) {
-		OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
-			"discard multicast target SA PR with wildcarded MGID");
-		return NULL;
-	}
-
-	mgrp = osm_get_mgrp_by_mgid(sa->p_subn, &p_pr->dgid);
-	if (!mgrp) {
-		char gid_str[INET6_ADDRSTRLEN];
-		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F09: "
-			"No MC group found for PathRecord destination GID %s\n",
-			inet_ntop(AF_INET6, p_pr->dgid.raw, gid_str,
-				  sizeof gid_str));
-		return NULL;
-	}
-
-	return mgrp;
-}
-
 static ib_api_status_t pr_match_mgrp_attributes(IN osm_sa_t * sa,
 						IN const osm_madw_t * p_madw,
 						IN const osm_mgrp_t * p_mgrp)
@@ -1510,47 +1482,11 @@ Exit:
 	return status;
 }
 
-static int pr_rcv_check_mcast_dest(osm_sa_t * sa, IN const osm_madw_t * p_madw)
-{
-	const ib_path_rec_t *p_pr;
-	const ib_sa_mad_t *p_sa_mad;
-	ib_net64_t comp_mask;
-	int is_multicast = 0;
-
-	OSM_LOG_ENTER(sa->p_log);
-
-	p_sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
-	p_pr = (ib_path_rec_t *) ib_sa_mad_get_payload_ptr(p_sa_mad);
-
-	comp_mask = p_sa_mad->comp_mask;
-
-	if (comp_mask & IB_PR_COMPMASK_DGID) {
-		is_multicast = ib_gid_is_multicast(&p_pr->dgid);
-		if (!is_multicast)
-			goto Exit;
-	}
-
-	if (comp_mask & IB_PR_COMPMASK_DLID) {
-		if (cl_ntoh16(p_pr->dlid) >= IB_LID_MCAST_START_HO &&
-		    cl_ntoh16(p_pr->dlid) <= IB_LID_MCAST_END_HO)
-			is_multicast = 1;
-		else if (is_multicast) {
-			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F12: "
-				"PathRecord request indicates MGID but not MLID\n");
-			is_multicast = -1;
-		}
-	}
-
-Exit:
-	OSM_LOG_EXIT(sa->p_log);
-	return is_multicast;
-}
-
 void osm_pr_rcv_process(IN void *context, IN void *data)
 {
 	osm_sa_t *sa = context;
 	osm_madw_t *p_madw = data;
-	const ib_path_rec_t *p_pr;
+	ib_path_rec_t *p_pr;
 	const ib_sa_mad_t *p_sa_mad;
 	const osm_port_t *p_src_port;
 	const osm_port_t *p_dest_port;
@@ -1558,7 +1494,6 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 	ib_gid_t dgid;
 	ib_net16_t sa_status;
 	osm_port_t *requester_port;
-	int ret;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -1601,21 +1536,14 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 	cl_plock_acquire(sa->p_lock);
 
 	/* Handle multicast destinations separately */
-	if ((ret = pr_rcv_check_mcast_dest(sa, p_madw)) < 0) {
-		/* Multicast DGID with unicast DLID */
-		cl_plock_release(sa->p_lock);
-		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_INVALID_FIELD);
-		goto Exit;
-	}
-
-	if (ret > 0)
+	if ((p_sa_mad->comp_mask & IB_PR_COMPMASK_DGID) &&
+	    ib_gid_is_multicast(&p_pr->dgid));
 		goto McastDest;
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Unicast destination requested\n");
 
 	sa_status = pr_rcv_get_end_points(sa, p_madw, &p_src_port, &p_dest_port,
 					  &dgid);
-
 	if (sa_status == IB_SA_MAD_STATUS_SUCCESS) {
 		/*
 		   What happens next depends on the type of endpoint information
@@ -1660,9 +1588,15 @@ McastDest:
 		uint8_t hop_limit;
 
 		/* First, get the MC info */
-		p_mgrp = pr_get_mgrp(sa, p_madw);
-		if (!p_mgrp)
+		p_mgrp = osm_get_mgrp_by_mgid(sa->p_subn, &p_pr->dgid);
+		if (!p_mgrp) {
+			char gid_str[INET6_ADDRSTRLEN];
+			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F09: "
+				"No MC group found for PathRecord destination GID %s\n",
+				inet_ntop(AF_INET6, p_pr->dgid.raw, gid_str,
+					  sizeof gid_str));
 			goto Unlock;
+		}
 
 		/* Make sure the rest of the PathRecord matches the MC group attributes */
 		status = pr_match_mgrp_attributes(sa, p_madw, p_mgrp);
-- 
1.6.6.rc4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
