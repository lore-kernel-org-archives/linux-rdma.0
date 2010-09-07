From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/sa: simplify osm_mcmr_rcv_find_or_create_new_mgrp()
 function call
Date: Tue, 7 Sep 2010 23:55:27 +0300
Message-ID: <20100907205527.GR11502@me>
References: <4C865139.7010705@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C865139.7010705-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Simplify osm_mcmr_rcv_find_or_create_new_mgrp() function call so that it
will return the pointer to created of found MC group.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_sa.h         |   15 +++++++--------
 opensm/opensm/osm_prtn.c               |   20 ++++++++++----------
 opensm/opensm/osm_sa.c                 |    8 ++++----
 opensm/opensm/osm_sa_mcmember_record.c |   21 ++++++++++-----------
 4 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/opensm/include/opensm/osm_sa.h b/opensm/include/opensm/osm_sa.h
index d516310..7c1061d 100644
--- a/opensm/include/opensm/osm_sa.h
+++ b/opensm/include/opensm/osm_sa.h
@@ -472,22 +472,21 @@ int osm_sa_db_file_load(struct osm_opensm *p_osm);
 * SYNOPSIS
 */
 
-ib_api_status_t
-osm_mcmr_rcv_find_or_create_new_mgrp(IN osm_sa_t * sa, IN ib_net64_t comp_mask,
-				     IN ib_member_rec_t * p_recvd_mcmember_rec,
-				     OUT osm_mgrp_t ** pp_mgrp);
+osm_mgrp_t *osm_mcmr_rcv_find_or_create_new_mgrp(IN osm_sa_t * sa,
+						 IN ib_net64_t comp_mask,
+						 IN ib_member_rec_t *
+						 p_recvd_mcmember_rec);
 /*
 * PARAMETERS
 *	p_sa
 *		[in] Pointer to an osm_sa_t object.
+*	comp_mask
+*		[in] SA query component mask
 *	p_recvd_mcmember_rec
 *		[in] Received Multicast member record
 *
-*	pp_mgrp
-*		[out] pointer the osm_mgrp_t object
-*
 * RETURN VALUES
-*	IB_SUCCESS, IB_ERROR
+*	The pointer to MC group object found or created, NULL in case of errors
 *
 *********/
 
diff --git a/opensm/opensm/osm_prtn.c b/opensm/opensm/osm_prtn.c
index 4b087a4..6a23c76 100644
--- a/opensm/opensm/osm_prtn.c
+++ b/opensm/opensm/osm_prtn.c
@@ -174,9 +174,8 @@ ib_api_status_t osm_prtn_add_mcgroup(osm_log_t * p_log, osm_subn_t * p_subn,
 	ib_member_rec_t mc_rec;
 	ib_net64_t comp_mask;
 	ib_net16_t pkey;
-	osm_mgrp_t *p_mgrp = NULL;
+	osm_mgrp_t *mgrp;
 	osm_sa_t *p_sa = &p_subn->p_osm->sa;
-	ib_api_status_t status = IB_SUCCESS;
 	uint8_t hop_limit;
 
 	pkey = p->pkey | cl_hton16(0x8000);
@@ -197,24 +196,25 @@ ib_api_status_t osm_prtn_add_mcgroup(osm_log_t * p_log, osm_subn_t * p_subn,
 	mc_rec.pkt_life = p_subn->opt.subnet_timeout;
 	mc_rec.sl_flow_hop = ib_member_set_sl_flow_hop(p->sl, 0, hop_limit);
 	/* Scope in MCMemberRecord (if present) needs to be consistent with MGID */
-	mc_rec.scope_state = ib_member_set_scope_state(scope, IB_MC_REC_STATE_FULL_MEMBER);
+	mc_rec.scope_state =
+	    ib_member_set_scope_state(scope, IB_MC_REC_STATE_FULL_MEMBER);
 	ib_mgid_set_scope(&mc_rec.mgid, scope);
 
 	/* don't update rate, mtu */
 	comp_mask = IB_MCR_COMPMASK_MTU | IB_MCR_COMPMASK_MTU_SEL |
 	    IB_MCR_COMPMASK_RATE | IB_MCR_COMPMASK_RATE_SEL;
-	status = osm_mcmr_rcv_find_or_create_new_mgrp(p_sa, comp_mask, &mc_rec,
-						      &p_mgrp);
-	if (!p_mgrp || status != IB_SUCCESS)
+	mgrp = osm_mcmr_rcv_find_or_create_new_mgrp(p_sa, comp_mask, &mc_rec);
+	if (!mgrp) {
 		OSM_LOG(p_log, OSM_LOG_ERROR,
 			"Failed to create MC group with pkey 0x%04x\n",
 			cl_ntoh16(pkey));
-	if (p_mgrp) {
-		p_mgrp->well_known = TRUE;
-		p->mgrp = p_mgrp;
+		return IB_ERROR;
 	}
 
-	return status;
+	mgrp->well_known = TRUE;
+	p->mgrp = mgrp;
+
+	return IB_SUCCESS;
 }
 
 static uint16_t generate_pkey(osm_subn_t * p_subn)
diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index ef9872d..812e435 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -741,10 +741,10 @@ static osm_mgrp_t *load_mcgroup(osm_opensm_t * p_osm, ib_net16_t mlid,
 
 	comp_mask = IB_MCR_COMPMASK_MTU | IB_MCR_COMPMASK_MTU_SEL
 	    | IB_MCR_COMPMASK_RATE | IB_MCR_COMPMASK_RATE_SEL;
-	if (osm_mcmr_rcv_find_or_create_new_mgrp(&p_osm->sa,
-						 comp_mask, p_mcm_rec,
-						 &p_mgrp) != IB_SUCCESS ||
-	    !p_mgrp || p_mgrp->mlid != mlid) {
+	if (!(p_mgrp = osm_mcmr_rcv_find_or_create_new_mgrp(&p_osm->sa,
+							    comp_mask,
+							    p_mcm_rec)) ||
+	    p_mgrp->mlid != mlid) {
 		OSM_LOG(&p_osm->log, OSM_LOG_ERROR,
 			"cannot create MC group with mlid 0x%04x and mgid "
 			"0x%016" PRIx64 ":0x%016" PRIx64 "\n", cl_ntoh16(mlid),
diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index 93c2767..b2318ec 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -868,21 +868,20 @@ Exit:
 /**********************************************************************
  Call this function to find or create a new mgrp.
 **********************************************************************/
-ib_api_status_t osm_mcmr_rcv_find_or_create_new_mgrp(IN osm_sa_t * sa,
-						     IN ib_net64_t comp_mask,
-						     IN ib_member_rec_t *
-						     p_recvd_mcmember_rec,
-						     OUT osm_mgrp_t ** pp_mgrp)
+osm_mgrp_t *osm_mcmr_rcv_find_or_create_new_mgrp(IN osm_sa_t * sa,
+						 IN ib_net64_t comp_mask,
+						 IN ib_member_rec_t *
+						 p_recvd_mcmember_rec)
 {
 	osm_mgrp_t *mgrp;
 
 	if ((mgrp = osm_get_mgrp_by_mgid(sa->p_subn,
-					 &p_recvd_mcmember_rec->mgid))) {
-		*pp_mgrp = mgrp;
-		return IB_SUCCESS;
-	}
-	return mcmr_rcv_create_new_mgrp(sa, comp_mask, p_recvd_mcmember_rec,
-					NULL, pp_mgrp);
+					 &p_recvd_mcmember_rec->mgid)))
+		return mgrp;
+	if (mcmr_rcv_create_new_mgrp(sa, comp_mask, p_recvd_mcmember_rec, NULL,
+				     &mgrp) == IB_SUCCESS)
+		return mgrp;
+	return NULL;
 }
 
 /*********************************************************************
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
