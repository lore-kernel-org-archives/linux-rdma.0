From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_mcmember_record.c: Make
	mcmr_rcv_create_new_mgrp static function
Date: Fri, 16 Oct 2009 11:03:05 -0400
Message-ID: <20091016150305.GA20557@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index c80dae7..dd01eed 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -723,12 +723,12 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 /**********************************************************************
  Call this function to create a new mgrp.
 **********************************************************************/
-ib_api_status_t osm_mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
-					     IN ib_net64_t comp_mask,
-					     IN const ib_member_rec_t *
-					     const p_recvd_mcmember_rec,
-					     IN const osm_physp_t * p_physp,
-					     OUT osm_mgrp_t ** pp_mgrp)
+static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
+						IN ib_net64_t comp_mask,
+						IN const ib_member_rec_t *
+						const p_recvd_mcmember_rec,
+						IN const osm_physp_t * p_physp,
+						OUT osm_mgrp_t ** pp_mgrp)
 {
 	ib_net16_t mlid;
 	unsigned zero_mgid, i;
@@ -897,8 +897,8 @@ ib_api_status_t osm_mcmr_rcv_find_or_create_new_mgrp(IN osm_sa_t * sa,
 		*pp_mgrp = mgrp;
 		return IB_SUCCESS;
 	}
-	return osm_mcmr_rcv_create_new_mgrp(sa, comp_mask, p_recvd_mcmember_rec,
-					    NULL, pp_mgrp);
+	return mcmr_rcv_create_new_mgrp(sa, comp_mask, p_recvd_mcmember_rec,
+					NULL, pp_mgrp);
 }
 
 /*********************************************************************
@@ -1084,9 +1084,9 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 			goto Exit;
 		}
 
-		status = osm_mcmr_rcv_create_new_mgrp(sa, p_sa_mad->comp_mask,
-						      p_recvd_mcmember_rec,
-						      p_physp, &p_mgrp);
+		status = mcmr_rcv_create_new_mgrp(sa, p_sa_mad->comp_mask,
+						  p_recvd_mcmember_rec,
+						  p_physp, &p_mgrp);
 		if (status != IB_SUCCESS) {
 			CL_PLOCK_RELEASE(sa->p_lock);
 			osm_sa_send_error(sa, p_madw, status);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
