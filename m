From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] osm_sa_mcmember_record.c: pass MCM Record data to mlid
 allocator
Date: Fri, 13 Nov 2009 22:11:44 +0200
Message-ID: <20091113201144.GS7192@me>
References: <20091113061948.GJ7192@me>
 <20091113062104.GK7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091113062104.GK7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Pass whole MCMember Record request data to get_new_mlid() function.
We need this for MGID compression implementation, so that for mlid
value selection all MCMember join request parameters (including MGID
value) could be used as mgid to mlid mapping trigger (signature checks
or so).

Respectively move mlid allocation call to be after a point where all
MCMember Record fields are already generated (MGID in particular) and
after request validation.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_mcmember_record.c |   36 +++++++++++++------------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index 85f0ca2..27675b6 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -114,9 +114,10 @@ static void free_mlid(IN osm_sa_t * sa, IN uint16_t mlid)
 /*********************************************************************
  Get a new unused mlid by scanning all the used ones in the subnet.
 **********************************************************************/
-static ib_net16_t get_new_mlid(osm_sa_t * sa, ib_net16_t requested_mlid)
+static ib_net16_t get_new_mlid(osm_sa_t * sa, ib_member_rec_t * mcmr)
 {
 	osm_subn_t *p_subn = sa->p_subn;
+	ib_net16_t requested_mlid = mcmr->mlid;
 	unsigned i, max;
 
 	if (requested_mlid && cl_ntoh16(requested_mlid) >= IB_LID_MCAST_START_HO
@@ -761,23 +762,6 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	/*
-	   we allocate a new mlid number before we might use it
-	   for MGID ...
-	 */
-	mlid = get_new_mlid(sa, mcm_rec.mlid);
-	if (mlid == 0) {
-		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B19: "
-			"get_new_mlid failed request mlid 0x%04x\n",
-			cl_ntoh16(mcm_rec.mlid));
-		status = IB_SA_MAD_STATUS_NO_RESOURCES;
-		goto Exit;
-	}
-
-	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Obtained new mlid 0x%X\n",
-		cl_ntoh16(mlid));
-
-	mcm_rec.mlid = mlid;
 	/* we need to create the new MGID if it was not defined */
 	if (!ib_gid_is_notzero(&p_recvd_mcmember_rec->mgid)) {
 		/* create a new MGID */
@@ -786,7 +770,6 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 		if (!build_new_mgid(sa, comp_mask, &mcm_rec)) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B23: "
 				"cannot allocate unique MGID value\n");
-			free_mlid(sa, mlid);
 			status = IB_SA_MAD_STATUS_NO_RESOURCES;
 			goto Exit;
 		}
@@ -797,7 +780,6 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 		/* a specific MGID was requested so validate the resulting MGID */
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B22: "
 			"Invalid requested MGID\n");
-		free_mlid(sa, mlid);
 		status = IB_SA_MAD_STATUS_REQ_INVALID;
 		goto Exit;
 	}
@@ -807,11 +789,23 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 	    FALSE) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B26: "
 			"Requested MGRP parameters are not realizable\n");
-		free_mlid(sa, mlid);
 		status = IB_SA_MAD_STATUS_REQ_INVALID;
 		goto Exit;
 	}
 
+	mlid = get_new_mlid(sa, &mcm_rec);
+	if (mlid == 0) {
+		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B19: "
+			"get_new_mlid failed request mlid 0x%04x\n",
+			cl_ntoh16(mcm_rec.mlid));
+		status = IB_SA_MAD_STATUS_NO_RESOURCES;
+		goto Exit;
+	}
+
+	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Obtained new mlid 0x%X\n",
+		cl_ntoh16(mlid));
+
+	mcm_rec.mlid = mlid;
 	/* create a new MC Group */
 	*pp_mgrp = osm_mgrp_new(sa->p_subn, mlid, &mcm_rec);
 	if (*pp_mgrp == NULL) {
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
