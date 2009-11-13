From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_mcmember_record.c: move mgid allocation code
Date: Fri, 13 Nov 2009 08:19:48 +0200
Message-ID: <20091113061948.GJ7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Move new MGID allocation code into separate function build_new_mgid().

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_sa_mcmember_record.c |   68 +++++++++++++++++++-------------
 1 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index 357e6ab..f6a9ead 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -712,19 +712,45 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 	return TRUE;
 }
 
+static unsigned build_new_mgid(osm_sa_t * sa, ib_net64_t comp_mask,
+			       ib_member_rec_t * mcmr)
+{
+	ib_gid_t *mgid = &mcmr->mgid;
+	uint8_t scope;
+
+	/* use the given scope state only if requested! */
+	if (comp_mask & IB_MCR_COMPMASK_SCOPE)
+		ib_member_get_scope_state(mcmr->scope_state, &scope, NULL);
+	else
+	/* to guarantee no collision with other subnets use local scope! */
+		scope = IB_MC_SCOPE_LINK_LOCAL;
+
+	mgid->raw[0] = 0xff;
+	mgid->raw[1] = 0x10 | scope;
+	mgid->raw[2] = 0xa0;
+	mgid->raw[3] = 0x1b;
+
+	/* HACK: use the SA port gid to make it globally unique */
+	memcpy(&mgid->raw[4], &sa->p_subn->opt.subnet_prefix, sizeof(uint64_t));
+
+	/* HACK: how do we get a unique number - use the mlid twice */
+	memcpy(&mgid->raw[10], &mcmr->mlid, sizeof(uint16_t));
+	memcpy(&mgid->raw[12], &mcmr->mlid, sizeof(uint16_t));
+
+	return 1;
+}
+
 /**********************************************************************
  Call this function to create a new mgrp.
 **********************************************************************/
 static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 						IN ib_net64_t comp_mask,
 						IN const ib_member_rec_t *
-						const p_recvd_mcmember_rec,
+						p_recvd_mcmember_rec,
 						IN const osm_physp_t * p_physp,
 						OUT osm_mgrp_t ** pp_mgrp)
 {
 	ib_net16_t mlid;
-	uint8_t scope;
-	ib_gid_t *p_mgid;
 	ib_api_status_t status = IB_SUCCESS;
 	ib_member_rec_t mcm_rec = *p_recvd_mcmember_rec;	/* copy for modifications */
 
@@ -743,37 +769,24 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 		goto Exit;
 	}
 
-	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
-		"Obtained new mlid 0x%X\n", cl_ntoh16(mlid));
+	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Obtained new mlid 0x%X\n",
+		cl_ntoh16(mlid));
 
+	mcm_rec.mlid = mlid;
 	/* we need to create the new MGID if it was not defined */
 	if (!ib_gid_is_notzero(&p_recvd_mcmember_rec->mgid)) {
 		/* create a new MGID */
 		char gid_str[INET6_ADDRSTRLEN];
 
-		/* use the given scope state only if requested! */
-		if (comp_mask & IB_MCR_COMPMASK_SCOPE)
-			ib_member_get_scope_state(p_recvd_mcmember_rec->
-						  scope_state, &scope, NULL);
-		else
-			/* to guarantee no collision with other subnets use local scope! */
-			scope = IB_MC_SCOPE_LINK_LOCAL;
-
-		p_mgid = &(mcm_rec.mgid);
-		p_mgid->raw[0] = 0xFF;
-		p_mgid->raw[1] = 0x10 | scope;
-		p_mgid->raw[2] = 0xA0;
-		p_mgid->raw[3] = 0x1B;
-
-		/* HACK: use the SA port gid to make it globally unique */
-		memcpy((&p_mgid->raw[4]),
-		       &sa->p_subn->opt.subnet_prefix, sizeof(uint64_t));
-
-		/* HACK: how do we get a unique number - use the mlid twice */
-		memcpy(&p_mgid->raw[10], &mlid, sizeof(uint16_t));
-		memcpy(&p_mgid->raw[12], &mlid, sizeof(uint16_t));
+		if (!build_new_mgid(sa, comp_mask, &mcm_rec)) {
+			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B23: "
+				"cannot allocate unique MGID value\n");
+			free_mlid(sa, mlid);
+			status = IB_SA_MAD_STATUS_NO_RESOURCES;
+			goto Exit;
+		}
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Allocated new MGID:%s\n",
-			inet_ntop(AF_INET6, p_mgid->raw, gid_str,
+			inet_ntop(AF_INET6, mcm_rec.mgid.raw, gid_str,
 				  sizeof gid_str));
 	} else if (!validate_requested_mgid(sa, &mcm_rec)) {
 		/* a specific MGID was requested so validate the resulting MGID */
@@ -795,7 +808,6 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 	}
 
 	/* create a new MC Group */
-	mcm_rec.mlid = mlid;
 	*pp_mgrp = osm_mgrp_new(sa->p_subn, mlid, &mcm_rec);
 	if (*pp_mgrp == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B08: "
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
