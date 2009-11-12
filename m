From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_mgrp_new(): add subnet db insertion
Date: Thu, 12 Nov 2009 02:02:24 +0200
Message-ID: <20091112000224.GZ7192@me>
References: <4AC2114E.3010303@Voltaire.COM>
 <20091111235959.GY7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091111235959.GY7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Slava Strebkov <slavas-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add insertion of mgrp into subnet DB in osm_mgrp_new() function code.
This consolidation makes a code cleaner and will help us to add MGID to
MLID compression model where mgrp will not be mapped directly to mlids
but using additional structure.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_multicast.h  |    5 ++++-
 opensm/opensm/osm_multicast.c          |    7 ++++++-
 opensm/opensm/osm_sa_mcmember_record.c |    7 +------
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/opensm/include/opensm/osm_multicast.h b/opensm/include/opensm/osm_multicast.h
index f0897f4..59e4d0d 100644
--- a/opensm/include/opensm/osm_multicast.h
+++ b/opensm/include/opensm/osm_multicast.h
@@ -142,9 +142,12 @@ typedef struct osm_mgrp {
 *
 * SYNOPSIS
 */
-osm_mgrp_t *osm_mgrp_new(IN ib_net16_t mlid, IN ib_member_rec_t * mcmr);
+osm_mgrp_t *osm_mgrp_new(IN osm_subn_t * subn, IN ib_net16_t mlid,
+			 IN ib_member_rec_t * mcmr);
 /*
 * PARAMETERS
+*	subn
+*		[in] Pointer to osm_subn_t object.
 *	mlid
 *		[in] Multicast LID for this multicast group.
 *
diff --git a/opensm/opensm/osm_multicast.c b/opensm/opensm/osm_multicast.c
index 8ccab8e..ff607e1 100644
--- a/opensm/opensm/osm_multicast.c
+++ b/opensm/opensm/osm_multicast.c
@@ -73,7 +73,8 @@ void osm_mgrp_delete(IN osm_mgrp_t * p_mgrp)
 	free(p_mgrp);
 }
 
-osm_mgrp_t *osm_mgrp_new(IN ib_net16_t mlid, IN ib_member_rec_t * mcmr)
+osm_mgrp_t *osm_mgrp_new(IN osm_subn_t * subn, IN ib_net16_t mlid,
+			 IN ib_member_rec_t * mcmr)
 {
 	osm_mgrp_t *p_mgrp;
 
@@ -86,6 +87,10 @@ osm_mgrp_t *osm_mgrp_new(IN ib_net16_t mlid, IN ib_member_rec_t * mcmr)
 	p_mgrp->mlid = mlid;
 	p_mgrp->mcmember_rec = *mcmr;
 
+	cl_fmap_insert(&subn->mgrp_mgid_tbl, &p_mgrp->mcmember_rec.mgid,
+		       &p_mgrp->map_item);
+	subn->mgroups[cl_ntoh16(p_mgrp->mlid) - IB_LID_MCAST_START_HO] = p_mgrp;
+
 	return p_mgrp;
 }
 
diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index 95c41e4..357e6ab 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -796,7 +796,7 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 
 	/* create a new MC Group */
 	mcm_rec.mlid = mlid;
-	*pp_mgrp = osm_mgrp_new(mlid, &mcm_rec);
+	*pp_mgrp = osm_mgrp_new(sa->p_subn, mlid, &mcm_rec);
 	if (*pp_mgrp == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B08: "
 			"osm_mgrp_new failed\n");
@@ -813,11 +813,6 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 	(*pp_mgrp)->mcmember_rec.pkt_life &= 0x3f;
 	(*pp_mgrp)->mcmember_rec.pkt_life |= 2 << 6;	/* exactly */
 
-	/* Insert the new group in the data base */
-	cl_fmap_insert(&sa->p_subn->mgrp_mgid_tbl,
-		       &(*pp_mgrp)->mcmember_rec.mgid, &(*pp_mgrp)->map_item);
-	sa->p_subn->mgroups[cl_ntoh16(mlid) - IB_LID_MCAST_START_HO] = *pp_mgrp;
-
 Exit:
 	OSM_LOG_EXIT(sa->p_log);
 	return status;
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
