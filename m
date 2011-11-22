From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 5/5] opensm: Enhance osm_physp_share_this_pkey for allow_both_pkeys
 policy
Date: Tue, 22 Nov 2011 15:23:59 -0500
Message-ID: <4ECC04DF.90409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When allow_both_pkeys, osm_physp_share_this_pkey should find full pkey
(16 bits) rather than pkey base (15 bits).

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_pkey.h        |    6 +++++-
 include/opensm/osm_qos_policy.h  |    5 +++--
 opensm/osm_pkey.c                |   18 +++++++++++++-----
 opensm/osm_qos_policy.c          |    8 +++++---
 opensm/osm_sa_multipath_record.c |    6 ++++--
 opensm/osm_sa_path_record.c      |    6 ++++--
 6 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/include/opensm/osm_pkey.h b/include/opensm/osm_pkey.h
index d70f5d9..ef09431 100644
--- a/include/opensm/osm_pkey.h
+++ b/include/opensm/osm_pkey.h
@@ -506,7 +506,8 @@ osm_pkey_tbl_set(IN osm_pkey_tbl_t * p_pkey_tbl,
 */
 boolean_t osm_physp_share_this_pkey(IN const struct osm_physp * p_physp1,
 				    IN const struct osm_physp * p_physp2,
-				    IN ib_net16_t pkey);
+				    IN ib_net16_t pkey,
+				    IN boolean_t allow_both_pkeys);
 /*
 * PARAMETERS
 *
@@ -519,6 +520,9 @@ boolean_t osm_physp_share_this_pkey(IN const struct osm_physp * p_physp1,
 *  pkey
 *     [in] value of P_Key to check.
 *
+*  allow_both_pkeys
+*     [in] whether both pkeys allowed policy is being used.
+*
 * RETURN VALUES
 *  Returns TRUE if the two ports are matching.
 *  FALSE otherwise.
diff --git a/include/opensm/osm_qos_policy.h b/include/opensm/osm_qos_policy.h
index 03ee891..73a1e98 100644
--- a/include/opensm/osm_qos_policy.h
+++ b/include/opensm/osm_qos_policy.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2008 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -172,7 +172,8 @@ boolean_t osm_qos_level_has_pkey(IN const osm_qos_level_t * p_qos_level,
 
 ib_net16_t osm_qos_level_get_shared_pkey(IN const osm_qos_level_t * p_qos_level,
 					 IN const osm_physp_t * p_src_physp,
-					 IN const osm_physp_t * p_dest_physp);
+					 IN const osm_physp_t * p_dest_physp,
+					 IN const boolean_t allow_both_pkeys);
 
 osm_qos_match_rule_t * osm_qos_policy_match_rule_create();
 void osm_qos_policy_match_rule_destroy(osm_qos_match_rule_t * p_match_rule);
diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index c7c89fd..93e393c 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -330,14 +330,22 @@ static boolean_t match_pkey(IN const ib_net16_t * pkey1,
 
 boolean_t osm_physp_share_this_pkey(IN const osm_physp_t * p_physp1,
 				    IN const osm_physp_t * p_physp2,
-				    IN ib_net16_t pkey)
+				    IN ib_net16_t pkey,
+				    IN boolean_t allow_both_pkeys)
 {
 	ib_net16_t *pkey1, *pkey2;
 
-	pkey1 = cl_map_get(&(osm_physp_get_pkey_tbl(p_physp1))->keys,
-			   ib_pkey_get_base(pkey));
-	pkey2 = cl_map_get(&(osm_physp_get_pkey_tbl(p_physp2))->keys,
-			   ib_pkey_get_base(pkey));
+	if (allow_both_pkeys) {
+		pkey1 = cl_map_get(&(osm_physp_get_pkey_tbl(p_physp1))->keys,
+				   pkey);
+		pkey2 = cl_map_get(&(osm_physp_get_pkey_tbl(p_physp2))->keys,
+				   pkey);
+	} else {
+		pkey1 = cl_map_get(&(osm_physp_get_pkey_tbl(p_physp1))->keys,
+				   ib_pkey_get_base(pkey));
+		pkey2 = cl_map_get(&(osm_physp_get_pkey_tbl(p_physp2))->keys,
+				   ib_pkey_get_base(pkey));
+	}
 	return (pkey1 && pkey2 && match_pkey(pkey1, pkey2));
 }
 
diff --git a/opensm/osm_qos_policy.c b/opensm/osm_qos_policy.c
index 3780968..b6b1f80 100644
--- a/opensm/osm_qos_policy.c
+++ b/opensm/osm_qos_policy.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2009 HNR Consulting.  All rights reserved.
@@ -312,7 +312,8 @@ boolean_t osm_qos_level_has_pkey(IN const osm_qos_level_t * p_qos_level,
 
 ib_net16_t osm_qos_level_get_shared_pkey(IN const osm_qos_level_t * p_qos_level,
 					 IN const osm_physp_t * p_src_physp,
-					 IN const osm_physp_t * p_dest_physp)
+					 IN const osm_physp_t * p_dest_physp,
+					 IN const boolean_t allow_both_pkeys)
 {
 	unsigned i;
 	uint16_t pkey_ho = 0;
@@ -330,7 +331,8 @@ ib_net16_t osm_qos_level_get_shared_pkey(IN const osm_qos_level_t * p_qos_level,
 		for (pkey_ho = p_qos_level->pkey_range_arr[i][0];
 		     pkey_ho <= p_qos_level->pkey_range_arr[i][1]; pkey_ho++) {
 			if (osm_physp_share_this_pkey
-			    (p_src_physp, p_dest_physp, cl_hton16(pkey_ho)))
+			    (p_src_physp, p_dest_physp, cl_hton16(pkey_ho),
+			     allow_both_pkeys))
 				return cl_hton16(pkey_ho);
 		}
 	}
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index 208dc31..e0cfaa1 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -615,7 +615,8 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		 */
 		required_pkey = p_mpr->pkey;
 		if (!osm_physp_share_this_pkey
-		    (p_src_physp, p_dest_physp, required_pkey)) {
+		    (p_src_physp, p_dest_physp, required_pkey,
+		     sa->p_subn->opt.allow_both_pkeys)) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4518: "
 				"Ports src 0x%016"PRIx64" (%s port %d) "
 				"and dst 0x%016"PRIx64" (%s port %d) "
@@ -658,7 +659,8 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		 */
 		required_pkey = osm_qos_level_get_shared_pkey(p_qos_level,
 							      p_src_physp,
-							      p_dest_physp);
+							      p_dest_physp,
+							      sa->p_subn->opt.allow_both_pkeys);
 		if (!required_pkey) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 451D: "
 				"Ports src 0x%016"PRIx64" (%s port %d) "
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 04ddf96..b820267 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -625,7 +625,8 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		 * PR returned pkey is the requested pkey.
 		 */
 		pkey = p_pr->pkey;
-		if (!osm_physp_share_this_pkey(p_src_physp, p_dest_physp, pkey)) {
+		if (!osm_physp_share_this_pkey(p_src_physp, p_dest_physp, pkey,
+					       sa->p_subn->opt.allow_both_pkeys)) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1A: "
 				"Ports 0x%016" PRIx64 " (%s port %d) and "
 				"0x%016" PRIx64 " (%s port %d) "
@@ -666,7 +667,8 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		 * has pkeys - get shared pkey from QoS level pkeys
 		 */
 		pkey = osm_qos_level_get_shared_pkey(p_qos_level,
-						     p_src_physp, p_dest_physp);
+						     p_src_physp, p_dest_physp,
+						     sa->p_subn->opt.allow_both_pkeys);
 		if (!pkey) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1E: "
 				"Ports 0x%016" PRIx64 " (%s) and "
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
