From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/partition: keep multicast group pointer
Date: Wed, 11 Nov 2009 14:38:37 +0200
Message-ID: <20091111123837.GV7192@me>
References: <4AC2114E.3010303@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AC2114E.3010303-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Slava Strebkov <slavas-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Instead of MLID value (which may refer to more than one MGIDs) keep
pointer to related multicast group object in partition structure.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_partition.h |   11 ++++++-----
 opensm/opensm/osm_prtn.c              |    6 +++---
 opensm/opensm/osm_qos_policy.c        |   21 +++++----------------
 3 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/opensm/include/opensm/osm_partition.h b/opensm/include/opensm/osm_partition.h
index 3c8a5aa..fdb34b9 100644
--- a/opensm/include/opensm/osm_partition.h
+++ b/opensm/include/opensm/osm_partition.h
@@ -48,6 +48,7 @@
 #include <complib/cl_map.h>
 #include <opensm/osm_log.h>
 #include <opensm/osm_subnet.h>
+#include <opensm/osm_multicast.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -92,8 +93,8 @@ BEGIN_C_DECLS
 typedef struct osm_prtn {
 	cl_map_item_t map_item;
 	ib_net16_t pkey;
-	ib_net16_t mlid;
 	uint8_t sl;
+	osm_mgrp_t *mgrp;
 	cl_map_t full_guid_tbl;
 	cl_map_t part_guid_tbl;
 	char name[32];
@@ -106,13 +107,13 @@ typedef struct osm_prtn {
 *	pkey
 *		The IBA defined P_KEY of this Partition.
 *
-*	mlid
-*		The network ordered LID of the well known Multicast Group
-*		that was created for this partition.
-*
 *	sl
 *		The Service Level (SL) associated with this Partiton.
 *
+*	mgrp
+*		The pointer to the well known Multicast Group
+*		that was created for this partition (when configured).
+*
 *	full_guid_tbl
 *		Container of pointers to all Port objects in the Partition
 *		with full membership, indexed by port GUID.
diff --git a/opensm/opensm/osm_prtn.c b/opensm/opensm/osm_prtn.c
index 4f84a80..f1094e3 100644
--- a/opensm/opensm/osm_prtn.c
+++ b/opensm/opensm/osm_prtn.c
@@ -225,7 +225,7 @@ ib_api_status_t osm_prtn_add_mcgroup(osm_log_t * p_log, osm_subn_t * p_subn,
 			cl_ntoh16(pkey));
 	if (p_mgrp) {
 		p_mgrp->well_known = TRUE;
-		p->mlid = p_mgrp->mlid;
+		p->mgrp = p_mgrp;
 	}
 
 	/* workaround for TS */
@@ -240,8 +240,8 @@ ib_api_status_t osm_prtn_add_mcgroup(osm_log_t * p_log, osm_subn_t * p_subn,
 						      &p_mgrp);
 	if (p_mgrp) {
 		p_mgrp->well_known = TRUE;
-		if (!p->mlid)
-			p->mlid = p_mgrp->mlid;
+		if (!p->mgrp)
+			p->mgrp = p_mgrp;
 	}
 
 	return status;
diff --git a/opensm/opensm/osm_qos_policy.c b/opensm/opensm/osm_qos_policy.c
index fcb9935..ed631c9 100644
--- a/opensm/opensm/osm_qos_policy.c
+++ b/opensm/opensm/osm_qos_policy.c
@@ -772,7 +772,6 @@ static void __qos_policy_validate_pkey(
 	uint8_t sl;
 	uint32_t flow;
 	uint8_t hop;
-	osm_mgrp_t * p_mgrp;
 
 	if (!p_qos_policy || !p_qos_match_rule || !p_prtn)
 		return;
@@ -792,31 +791,21 @@ static void __qos_policy_validate_pkey(
 
 	/* If this partition is an IPoIB partition, there should
 	   be a matching MCast group. Fix this group's SL too */
-
-	if (!p_prtn->mlid)
-		return;
-
-	p_mgrp = osm_get_mgrp_by_mlid(p_qos_policy->p_subn, p_prtn->mlid);
-	if (!p_mgrp) {
-		OSM_LOG(&p_qos_policy->p_subn->p_osm->log, OSM_LOG_ERROR,
-			"ERR AC16: MCast group for partition with "
-			"pkey 0x%04X not found\n",
-			cl_ntoh16(p_prtn->pkey));
+	if (!p_prtn->mgrp)
 		return;
-	}
 
-	CL_ASSERT((cl_ntoh16(p_mgrp->mcmember_rec.pkey) & 0x7fff) ==
+	CL_ASSERT((cl_ntoh16(p_prtn->mgrp->mcmember_rec.pkey) & 0x7fff) ==
 		  (cl_ntoh16(p_prtn->pkey) & 0x7fff));
 
-	ib_member_get_sl_flow_hop(p_mgrp->mcmember_rec.sl_flow_hop,
+	ib_member_get_sl_flow_hop(p_prtn->mgrp->mcmember_rec.sl_flow_hop,
 				  &sl, &flow, &hop);
 	if (sl != p_prtn->sl) {
 		OSM_LOG(&p_qos_policy->p_subn->p_osm->log, OSM_LOG_DEBUG,
 			"Updating MCGroup (MLID 0x%04x) SL to "
 			"match partition SL (%u)\n",
-			cl_hton16(p_mgrp->mcmember_rec.mlid),
+			cl_hton16(p_prtn->mgrp->mcmember_rec.mlid),
 			p_prtn->sl);
-		p_mgrp->mcmember_rec.sl_flow_hop =
+		p_prtn->mgrp->mcmember_rec.sl_flow_hop =
 			ib_member_set_sl_flow_hop(p_prtn->sl, flow, hop);
 	}
 }
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
