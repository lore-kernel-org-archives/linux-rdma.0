From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: discard multicast SA PR with wildcard DGID
Date: Sat, 19 Sep 2009 20:00:00 +0300
Message-ID: <20090919170000.GE13667@me>
References: <20090919165817.GC13667@me>
 <20090919165924.GD13667@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090919165924.GD13667@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


IBA 1.2.1 states (Vol.1, 15.2.5.16, p.918) that DGID shell be explicitly
specified when path destination of SA PathRecord query is multicast
group.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_path_record.c |   45 ++++++++++++------------------------
 1 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index f68be20..37f32ac 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -1437,45 +1437,27 @@ static osm_mgrp_t *pr_get_mgrp(IN osm_sa_t * sa, IN const osm_madw_t * p_madw)
 {
 	ib_path_rec_t *p_pr;
 	const ib_sa_mad_t *p_sa_mad;
-	ib_net64_t comp_mask;
-	osm_mgrp_t *mgrp = NULL;
+	osm_mgrp_t *mgrp;
 
 	p_sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
-	p_pr = (ib_path_rec_t *) ib_sa_mad_get_payload_ptr(p_sa_mad);
+	p_pr = ib_sa_mad_get_payload_ptr(p_sa_mad);
 
-	comp_mask = p_sa_mad->comp_mask;
+	if (!(p_sa_mad->comp_mask & IB_PR_COMPMASK_DGID)) {
+		OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
+			"discard multicast target SA PR with wildcarded MGID");
+		return NULL;
+	}
 
-	if ((comp_mask & IB_PR_COMPMASK_DGID) &&
-	    !(mgrp = osm_get_mgrp_by_mgid(sa, &p_pr->dgid))) {
+	mgrp = osm_get_mgrp_by_mgid(sa, &p_pr->dgid);
+	if (!mgrp) {
 		char gid_str[INET6_ADDRSTRLEN];
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F09: "
 			"No MC group found for PathRecord destination GID %s\n",
 			inet_ntop(AF_INET6, p_pr->dgid.raw, gid_str,
 				  sizeof gid_str));
-		goto Exit;
-	}
-
-	if (comp_mask & IB_PR_COMPMASK_DLID) {
-		if (mgrp) {
-			/* check that the MLID in the MC group is */
-			/* the same as the DLID in the PathRecord */
-			if (mgrp->mlid != p_pr->dlid) {
-				/* Note: perhaps this might be better indicated as an invalid request */
-				OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F10: "
-					"MC group MLID 0x%x does not match "
-					"PathRecord destination LID 0x%x\n",
-					mgrp->mlid, p_pr->dlid);
-				mgrp = NULL;
-				goto Exit;
-			}
-		} else
-		    if (!(mgrp = osm_get_mgrp_by_mlid(sa->p_subn, p_pr->dlid)))
-			OSM_LOG(sa->p_log, OSM_LOG_ERROR,
-				"ERR 1F11: " "No MC group found for PathRecord "
-				"destination LID 0x%x\n", p_pr->dlid);
+		return NULL;
 	}
 
-Exit:
 	return mgrp;
 }
 
@@ -1497,10 +1479,14 @@ static ib_api_status_t pr_match_mgrp_attributes(IN osm_sa_t * sa,
 	OSM_LOG_ENTER(sa->p_log);
 
 	p_sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
-	p_pr = (ib_path_rec_t *) ib_sa_mad_get_payload_ptr(p_sa_mad);
+	p_pr = ib_sa_mad_get_payload_ptr(p_sa_mad);
 
 	comp_mask = p_sa_mad->comp_mask;
 
+	/* check that MLID of the MC group matchs the PathRecord DLID */
+	if ((comp_mask & IB_PR_COMPMASK_DLID) && p_mgrp->mlid != p_pr->dlid)
+		goto Exit;
+
 	/* If SGID and/or SLID specified, should validate as member of MC group */
 	if (comp_mask & IB_PR_COMPMASK_SGID) {
 		port = osm_get_port_by_guid(sa->p_subn,
@@ -1713,7 +1699,6 @@ McastDest:
 
 		/* First, get the MC info */
 		p_mgrp = pr_get_mgrp(sa, p_madw);
-
 		if (!p_mgrp)
 			goto Unlock;
 
-- 
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
