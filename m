From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fix search common pkeys
Date: Sat, 19 May 2012 22:51:03 +0300
Message-ID: <20120519195103.GE2110@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixing search common pkey algorithm, due to changes in pkeys table when
using allow_both_pkeys = TRUE

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_pkey.h        |   17 +++++++++++--
 opensm/osm_inform.c              |    3 +-
 opensm/osm_pkey.c                |   49 ++++++++++++++++++++++++++++++++++----
 opensm/osm_sa_guidinfo_record.c  |    7 +++--
 opensm/osm_sa_informinfo.c       |    9 ++++--
 opensm/osm_sa_lft_record.c       |    3 +-
 opensm/osm_sa_link_record.c      |    9 ++++--
 opensm/osm_sa_mcmember_record.c  |    3 +-
 opensm/osm_sa_mft_record.c       |    3 +-
 opensm/osm_sa_multipath_record.c |   15 +++++++----
 opensm/osm_sa_node_record.c      |    3 +-
 opensm/osm_sa_path_record.c      |   15 +++++++----
 opensm/osm_sa_pkey_record.c      |    4 +-
 opensm/osm_sa_portinfo_record.c  |    8 +++---
 opensm/osm_sa_slvl_record.c      |    7 +++--
 opensm/osm_sa_sminfo_record.c    |    3 +-
 opensm/osm_sa_sw_info_record.c   |    3 +-
 opensm/osm_sa_vlarb_record.c     |    8 +++---
 18 files changed, 122 insertions(+), 47 deletions(-)

diff --git a/include/opensm/osm_pkey.h b/include/opensm/osm_pkey.h
index 57c23cd..54888e6 100644
--- a/include/opensm/osm_pkey.h
+++ b/include/opensm/osm_pkey.h
@@ -541,7 +541,8 @@ boolean_t osm_physp_share_this_pkey(IN const struct osm_physp * p_physp1,
 * SYNOPSIS
 */
 ib_net16_t osm_physp_find_common_pkey(IN const struct osm_physp *p_physp1,
-				      IN const struct osm_physp *p_physp2);
+				      IN const struct osm_physp *p_physp2,
+				      IN boolean_t allow_both_pkeys);
 /*
 * PARAMETERS
 *
@@ -551,6 +552,10 @@ ib_net16_t osm_physp_find_common_pkey(IN const struct osm_physp *p_physp1,
 *  p_physp2
 *     [in] Pointer to an osm_physp_t object.
 *
+*  allow_both_pkeys
+*     [in] Whether both full and limited membership on same partition
+*          are allowed
+*
 * RETURN VALUES
 *  Returns value of first shared P_Key or INVALID P_Key (0x0) if not
 *  found.
@@ -585,7 +590,8 @@ ib_net16_t osm_physp_find_common_pkey(IN const struct osm_physp *p_physp1,
 */
 boolean_t osm_physp_share_pkey(IN osm_log_t * p_log,
 			       IN const struct osm_physp * p_physp_1,
-			       IN const struct osm_physp * p_physp_2);
+			       IN const struct osm_physp * p_physp_2,
+			       IN boolean_t allow_both_pkeys);
 
 /*
 * PARAMETERS
@@ -598,6 +604,10 @@ boolean_t osm_physp_share_pkey(IN osm_log_t * p_log,
 *  p_physp_2
 *     [in] Pointer to an osm_physp_t object.
 *
+*  allow_both_pkeys
+*     [in] Whether both full and limited membership on same partition
+*          are allowed
+*
 * RETURN VALUES
 *  Returns TRUE if the 2 physical ports are matching.
 *  FALSE otherwise.
@@ -632,7 +642,8 @@ boolean_t osm_physp_share_pkey(IN osm_log_t * p_log,
 */
 boolean_t osm_port_share_pkey(IN osm_log_t * p_log,
 			      IN const struct osm_port * p_port_1,
-			      IN const struct osm_port * p_port_2);
+			      IN const struct osm_port * p_port_2,
+			      IN boolean_t allow_both_pkeys);
 
 /*
 * PARAMETERS
diff --git a/opensm/osm_inform.c b/opensm/osm_inform.c
index fd7caa2..6a2cb7e 100644
--- a/opensm/osm_inform.c
+++ b/opensm/osm_inform.c
@@ -415,7 +415,8 @@ static int is_access_permitted(osm_infr_t *p_infr_rec,
 			}
 
 
-			if (osm_port_share_pkey(p_log, p_src_port, p_dest_port) == FALSE) {
+			if (osm_port_share_pkey(p_log, p_src_port, p_dest_port,
+						p_subn->opt.allow_both_pkeys) == FALSE) {
 				OSM_LOG(p_log, OSM_LOG_DEBUG, "Mismatch by Pkey\n");
 				/* According to o13-17.1.2 - If this informInfo
 				   does not have lid_range_begin of 0xFFFF,
diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index e95adb2..69657dc 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -360,16 +360,23 @@ boolean_t osm_physp_share_this_pkey(IN const osm_physp_t * p_physp1,
 }
 
 ib_net16_t osm_physp_find_common_pkey(IN const osm_physp_t * p_physp1,
-				      IN const osm_physp_t * p_physp2)
+				      IN const osm_physp_t * p_physp2,
+				      IN boolean_t allow_both_pkeys)
 {
 	ib_net16_t *pkey1, *pkey2;
 	uint64_t pkey1_base, pkey2_base;
 	const osm_pkey_tbl_t *pkey_tbl1, *pkey_tbl2;
 	cl_map_iterator_t map_iter1, map_iter2;
+	ib_net16_t key;
+	const osm_pkey_tbl_t *pkey_tbl;
+	cl_map_iterator_t map_iter, map_end;
 
 	pkey_tbl1 = osm_physp_get_pkey_tbl(p_physp1);
 	pkey_tbl2 = osm_physp_get_pkey_tbl(p_physp2);
 
+	if (allow_both_pkeys)
+		goto SearchByKeys;
+
 	map_iter1 = cl_map_head(&pkey_tbl1->keys);
 	map_iter2 = cl_map_head(&pkey_tbl2->keys);
 
@@ -395,11 +402,42 @@ ib_net16_t osm_physp_find_common_pkey(IN const osm_physp_t * p_physp1,
 	}
 
 	return 0;
+
+SearchByKeys:
+
+	/* Select to iterate over the table with the least elements */
+	if (cl_map_count(&pkey_tbl1->keys) < cl_map_count(&pkey_tbl2->keys)) {
+		map_iter = cl_map_head(&pkey_tbl1->keys);
+		map_end = cl_map_end(&pkey_tbl1->keys);
+		pkey_tbl = pkey_tbl2;
+	} else {
+		map_iter = cl_map_head(&pkey_tbl2->keys);
+		map_end = cl_map_end(&pkey_tbl2->keys);
+		pkey_tbl =  pkey_tbl1;
+	}
+
+	while (map_iter != map_end) {
+		pkey1 = (ib_net16_t *) cl_map_obj(map_iter);
+		key = cl_map_key(map_iter);
+
+		pkey2 = cl_map_get(&pkey_tbl->keys, key | IB_PKEY_TYPE_MASK);
+		if (!pkey2)
+			pkey2 = cl_map_get(&pkey_tbl->keys,
+					key & ~IB_PKEY_TYPE_MASK);
+
+		if (pkey2 && match_pkey(pkey1, pkey2))
+			return (pkey_tbl == pkey_tbl2 ? *pkey1 : *pkey2);
+
+		map_iter = cl_map_next(map_iter);
+	}
+
+	return 0;
 }
 
 boolean_t osm_physp_share_pkey(IN osm_log_t * p_log,
 			       IN const osm_physp_t * p_physp_1,
-			       IN const osm_physp_t * p_physp_2)
+			       IN const osm_physp_t * p_physp_2,
+			       IN boolean_t allow_both_pkeys)
 {
 	const osm_pkey_tbl_t *pkey_tbl1, *pkey_tbl2;
 
@@ -421,12 +459,13 @@ boolean_t osm_physp_share_pkey(IN osm_log_t * p_log,
 
 	return
 	    !ib_pkey_is_invalid(osm_physp_find_common_pkey
-				(p_physp_1, p_physp_2));
+				(p_physp_1, p_physp_2, allow_both_pkeys));
 }
 
 boolean_t osm_port_share_pkey(IN osm_log_t * p_log,
 			      IN const osm_port_t * p_port_1,
-			      IN const osm_port_t * p_port_2)
+			      IN const osm_port_t * p_port_2,
+			      IN boolean_t allow_both_pkeys)
 {
 
 	osm_physp_t *p_physp1, *p_physp2;
@@ -447,7 +486,7 @@ boolean_t osm_port_share_pkey(IN osm_log_t * p_log,
 		goto Exit;
 	}
 
-	ret = osm_physp_share_pkey(p_log, p_physp1, p_physp2);
+	ret = osm_physp_share_pkey(p_log, p_physp1, p_physp2, allow_both_pkeys);
 
 Exit:
 	OSM_LOG_EXIT(p_log);
diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index 37451b3..0140a70 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -155,7 +155,8 @@ static void sa_gir_create_gir(IN osm_sa_t * sa, IN osm_node_t * p_node,
 
 		/* Check to see if the found p_physp and the requester physp
 		   share a pkey. If not, continue */
-		if (!osm_physp_share_pkey(sa->p_log, p_physp, p_req_physp))
+		if (!osm_physp_share_pkey(sa->p_log, p_physp, p_req_physp,
+					  sa->p_subn->opt.allow_both_pkeys))
 			continue;
 
 		port_guid = osm_physp_get_port_guid(p_physp);
@@ -777,8 +778,8 @@ void osm_gir_rcv_process(IN void *ctx, IN void *data)
 			osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_NO_RECORDS);
 			goto Exit;
 		}
-		if (!osm_physp_share_pkey(sa->p_log, p_req_physp,
-					  p_port->p_physp))
+		if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_port->p_physp,
+					  sa->p_subn->opt.allow_both_pkeys))
 			goto Exit;
 		CL_PLOCK_EXCL_ACQUIRE(sa->p_lock);
 		if (p_rcvd_mad->method == IB_MAD_METHOD_SET)
diff --git a/opensm/osm_sa_informinfo.c b/opensm/osm_sa_informinfo.c
index f775d36..e3f6ffa 100644
--- a/opensm/osm_sa_informinfo.c
+++ b/opensm/osm_sa_informinfo.c
@@ -116,7 +116,8 @@ static boolean_t validate_ports_access_rights(IN osm_sa_t * sa,
 		/* make sure that the requester and destination port can access
 		   each other according to the current partitioning. */
 		if (!osm_physp_share_pkey
-		    (sa->p_log, p_port->p_physp, p_requester_physp)) {
+		    (sa->p_log, p_port->p_physp, p_requester_physp,
+		     sa->p_subn->opt.allow_both_pkeys)) {
 			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 				"port and requester don't share pkey\n");
 			valid = FALSE;
@@ -165,7 +166,8 @@ static boolean_t validate_ports_access_rights(IN osm_sa_t * sa,
 			/* make sure that the requester and destination port can access
 			   each other according to the current partitioning. */
 			if (!osm_physp_share_pkey
-			    (sa->p_log, p_port->p_physp, p_requester_physp)) {
+			    (sa->p_log, p_port->p_physp, p_requester_physp,
+			     sa->p_subn->opt.allow_both_pkeys)) {
 				OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 					"port and requester don't share pkey\n");
 				valid = FALSE;
@@ -273,7 +275,8 @@ static void sa_inform_info_rec_by_comp_mask(IN osm_sa_t * sa,
 	p_subscriber_physp = p_subscriber_port->p_physp;
 	/* make sure that the requester and subscriber port can access each
 	   other according to the current partitioning. */
-	if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_subscriber_physp)) {
+	if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_subscriber_physp,
+				  sa->p_subn->opt.allow_both_pkeys)) {
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"requester and subscriber ports don't share pkey\n");
 		goto Exit;
diff --git a/opensm/osm_sa_lft_record.c b/opensm/osm_sa_lft_record.c
index 2069235..7da3a55 100644
--- a/opensm/osm_sa_lft_record.c
+++ b/opensm/osm_sa_lft_record.c
@@ -139,7 +139,8 @@ static void lftr_rcv_by_comp_mask(IN cl_map_item_t * p_map_item, IN void *cxt)
 			cl_ntoh64(p_sw->p_node->node_info.node_guid));
 		return;
 	}
-	if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_physp))
+	if (!osm_physp_share_pkey(sa->p_log, p_req_physp,
+				  p_physp, sa->p_subn->opt.allow_both_pkeys))
 		return;
 
 	/* get the port 0 of the switch */
diff --git a/opensm/osm_sa_link_record.c b/opensm/osm_sa_link_record.c
index 8ac4962..85f4074 100644
--- a/opensm/osm_sa_link_record.c
+++ b/opensm/osm_sa_link_record.c
@@ -137,17 +137,20 @@ static void lr_rcv_get_physp_link(IN osm_sa_t * sa,
 
 	/* Check that the p_src_physp, p_dest_physp and p_req_physp
 	   all share a pkey (doesn't have to be the same p_key). */
-	if (!osm_physp_share_pkey(sa->p_log, p_src_physp, p_dest_physp)) {
+	if (!osm_physp_share_pkey(sa->p_log, p_src_physp, p_dest_physp,
+				  sa->p_subn->opt.allow_both_pkeys)) {
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"Source and Dest PhysPorts do not share PKey\n");
 		goto Exit;
 	}
-	if (!osm_physp_share_pkey(sa->p_log, p_src_physp, p_req_physp)) {
+	if (!osm_physp_share_pkey(sa->p_log, p_src_physp, p_req_physp,
+				  sa->p_subn->opt.allow_both_pkeys)) {
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"Source and Requester PhysPorts do not share PKey\n");
 		goto Exit;
 	}
-	if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_dest_physp)) {
+	if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_dest_physp,
+				  sa->p_subn->opt.allow_both_pkeys)) {
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"Requester and Dest PhysPorts do not share PKey\n");
 		goto Exit;
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index b97f77f..2757258 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -1016,7 +1016,8 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 
 	proxy = (p_physp != p_request_physp);
 
-	if (proxy && !osm_physp_share_pkey(sa->p_log, p_physp, p_request_physp)) {
+	if (proxy && !osm_physp_share_pkey(sa->p_log, p_physp, p_request_physp,
+					   sa->p_subn->opt.allow_both_pkeys)) {
 		CL_PLOCK_RELEASE(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
 			"Port and requester don't share pkey\n");
diff --git a/opensm/osm_sa_mft_record.c b/opensm/osm_sa_mft_record.c
index 7450faa..80f403f 100644
--- a/opensm/osm_sa_mft_record.c
+++ b/opensm/osm_sa_mft_record.c
@@ -146,7 +146,8 @@ static void mftr_rcv_by_comp_mask(IN cl_map_item_t * p_map_item, IN void *cxt)
 			cl_ntoh64(p_sw->p_node->node_info.node_guid));
 		return;
 	}
-	if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_physp))
+	if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_physp,
+				  sa->p_subn->opt.allow_both_pkeys))
 		return;
 
 	/* get the port 0 of the switch */
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index 12f8eb2..3c74b15 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -618,7 +618,8 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 	if (comp_mask & IB_MPR_COMPMASK_RAWTRAFFIC &&
 	    cl_ntoh32(p_mpr->hop_flow_raw) & (1 << 31))
 		required_pkey =
-		    osm_physp_find_common_pkey(p_src_physp, p_dest_physp);
+		    osm_physp_find_common_pkey(p_src_physp, p_dest_physp,
+					       sa->p_subn->opt.allow_both_pkeys);
 
 	else if (comp_mask & IB_MPR_COMPMASK_PKEY) {
 		/*
@@ -700,7 +701,8 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		 * Just get any shared pkey.
 		 */
 		required_pkey =
-		    osm_physp_find_common_pkey(p_src_physp, p_dest_physp);
+		    osm_physp_find_common_pkey(p_src_physp, p_dest_physp,
+					       sa->p_subn->opt.allow_both_pkeys);
 		if (!required_pkey) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4519: "
 				"Ports src 0x%016"PRIx64" (%s port %d) "
@@ -991,11 +993,14 @@ static uint32_t mpr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 	/* Check that the req_port, src_port and dest_port all share a
 	   pkey. The check is done on the default physical port of the ports. */
 	if (osm_port_share_pkey(sa->p_log, p_req_port,
-				p_src_alias_guid->p_base_port) == FALSE
+				p_src_alias_guid->p_base_port,
+				sa->p_subn->opt.allow_both_pkeys) == FALSE
 	    || osm_port_share_pkey(sa->p_log, p_req_port,
-				   p_dest_alias_guid->p_base_port) == FALSE
+				   p_dest_alias_guid->p_base_port,
+				   sa->p_subn->opt.allow_both_pkeys) == FALSE
 	    || osm_port_share_pkey(sa->p_log, p_src_alias_guid->p_base_port,
-				   p_dest_alias_guid->p_base_port) == FALSE)
+				   p_dest_alias_guid->p_base_port,
+				   sa->p_subn->opt.allow_both_pkeys) == FALSE)
 		/* One of the pairs doesn't share a pkey so the path is disqualified. */
 		goto Exit;
 
diff --git a/opensm/osm_sa_node_record.c b/opensm/osm_sa_node_record.c
index f135607..5255ae9 100644
--- a/opensm/osm_sa_node_record.c
+++ b/opensm/osm_sa_node_record.c
@@ -150,7 +150,8 @@ static void nr_rcv_create_nr(IN osm_sa_t * sa, IN osm_node_t * p_node,
 
 		/* Check to see if the found p_physp and the requester physp
 		   share a pkey. If not - continue */
-		if (!osm_physp_share_pkey(sa->p_log, p_physp, p_req_physp))
+		if (!osm_physp_share_pkey(sa->p_log, p_physp, p_req_physp,
+					  sa->p_subn->opt.allow_both_pkeys))
 			continue;
 
 		port_guid = osm_physp_get_port_guid(p_physp);
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 0e2dae2..e61aaa0 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -631,7 +631,8 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 
 	if ((comp_mask & IB_PR_COMPMASK_RAWTRAFFIC) &&
 	    (cl_ntoh32(p_pr->hop_flow_raw) & (1 << 31)))
-		pkey = osm_physp_find_common_pkey(p_src_physp, p_dest_physp);
+		pkey = osm_physp_find_common_pkey(p_src_physp, p_dest_physp,
+						  sa->p_subn->opt.allow_both_pkeys);
 
 	else if (comp_mask & IB_PR_COMPMASK_PKEY) {
 		/*
@@ -705,7 +706,8 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		 * Neither PR request nor QoS level have pkey.
 		 * Just get any shared pkey.
 		 */
-		pkey = osm_physp_find_common_pkey(p_src_physp, p_dest_physp);
+		pkey = osm_physp_find_common_pkey(p_src_physp, p_dest_physp,
+						  sa->p_subn->opt.allow_both_pkeys);
 		if (!pkey) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1B: "
 				"Ports src 0x%016"PRIx64" (%s port %d) and "
@@ -1020,11 +1022,14 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 	/* Check that the req_port, src_port and dest_port all share a
 	   pkey. The check is done on the default physical port of the ports. */
 	if (osm_port_share_pkey(sa->p_log, p_req_port,
-				p_src_alias_guid->p_base_port) == FALSE
+				p_src_alias_guid->p_base_port,
+				sa->p_subn->opt.allow_both_pkeys) == FALSE
 	    || osm_port_share_pkey(sa->p_log, p_req_port,
-				   p_dest_alias_guid->p_base_port) == FALSE
+				   p_dest_alias_guid->p_base_port,
+				   sa->p_subn->opt.allow_both_pkeys) == FALSE
 	    || osm_port_share_pkey(sa->p_log, p_src_alias_guid->p_base_port,
-				   p_dest_alias_guid->p_base_port) == FALSE)
+				   p_dest_alias_guid->p_base_port,
+				   sa->p_subn->opt.allow_both_pkeys) == FALSE)
 		/* One of the pairs doesn't share a pkey so the path is disqualified. */
 		goto Exit;
 
diff --git a/opensm/osm_sa_pkey_record.c b/opensm/osm_sa_pkey_record.c
index 6bd2056..122c44f 100644
--- a/opensm/osm_sa_pkey_record.c
+++ b/opensm/osm_sa_pkey_record.c
@@ -171,7 +171,7 @@ static void sa_pkey_by_comp_mask(IN osm_sa_t * sa, IN const osm_port_t * p_port,
 			   with the p_req_physp. */
 			if (p_physp &&
 			    osm_physp_share_pkey(sa->p_log, p_req_physp,
-						 p_physp))
+						 p_physp, sa->p_subn->opt.allow_both_pkeys))
 				sa_pkey_check_physp(sa, p_physp, p_ctxt);
 		} else {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4603: "
@@ -191,7 +191,7 @@ static void sa_pkey_by_comp_mask(IN osm_sa_t * sa, IN const osm_port_t * p_port,
 			/* if the requester and the p_physp don't share a pkey -
 			   continue */
 			if (!osm_physp_share_pkey
-			    (sa->p_log, p_req_physp, p_physp))
+			    (sa->p_log, p_req_physp, p_physp, sa->p_subn->opt.allow_both_pkeys))
 				continue;
 
 			sa_pkey_check_physp(sa, p_physp, p_ctxt);
diff --git a/opensm/osm_sa_portinfo_record.c b/opensm/osm_sa_portinfo_record.c
index 5aa599a..4e662d1 100644
--- a/opensm/osm_sa_portinfo_record.c
+++ b/opensm/osm_sa_portinfo_record.c
@@ -472,8 +472,8 @@ static void sa_pir_by_comp_mask(IN osm_sa_t * sa, IN osm_node_t * p_node,
 			/* Check that the p_physp is valid, and that the
 			   p_physp and the p_req_physp share a pkey. */
 			if (p_physp &&
-			    osm_physp_share_pkey(sa->p_log, p_req_physp,
-						 p_physp))
+			    osm_physp_share_pkey(sa->p_log, p_req_physp, p_physp,
+						 sa->p_subn->opt.allow_both_pkeys))
 				sa_pir_check_physp(sa, p_physp, p_ctxt);
 		}
 	} else {
@@ -484,8 +484,8 @@ static void sa_pir_by_comp_mask(IN osm_sa_t * sa, IN osm_node_t * p_node,
 
 			/* if the requester and the p_physp don't share a pkey -
 			   continue */
-			if (!osm_physp_share_pkey
-			    (sa->p_log, p_req_physp, p_physp))
+			if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_physp,
+						  sa->p_subn->opt.allow_both_pkeys))
 				continue;
 
 			sa_pir_check_physp(sa, p_physp, p_ctxt);
diff --git a/opensm/osm_sa_slvl_record.c b/opensm/osm_sa_slvl_record.c
index 6d9f00a..3ef7dd2 100644
--- a/opensm/osm_sa_slvl_record.c
+++ b/opensm/osm_sa_slvl_record.c
@@ -141,7 +141,8 @@ static void sa_slvl_by_comp_mask(IN osm_sa_t * sa, IN const osm_port_t * p_port,
 			p_port->p_physp->port_num);
 		p_out_physp = p_port->p_physp;
 		/* check that the p_out_physp and the p_req_physp share a pkey */
-		if (osm_physp_share_pkey(sa->p_log, p_req_physp, p_out_physp))
+		if (osm_physp_share_pkey(sa->p_log, p_req_physp, p_out_physp,
+					 sa->p_subn->opt.allow_both_pkeys))
 			sa_slvl_create(sa, p_out_physp, p_ctxt, 0);
 	} else {
 		if (comp_mask & IB_SLVL_COMPMASK_OUT_PORT)
@@ -173,8 +174,8 @@ static void sa_slvl_by_comp_mask(IN osm_sa_t * sa, IN const osm_port_t * p_port,
 
 				/* if the requester and the p_out_physp don't share a pkey -
 				   continue */
-				if (!osm_physp_share_pkey
-				    (sa->p_log, p_req_physp, p_out_physp))
+				if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_out_physp,
+							  sa->p_subn->opt.allow_both_pkeys))
 					continue;
 
 				sa_slvl_create(sa, p_out_physp, p_ctxt,
diff --git a/opensm/osm_sa_sminfo_record.c b/opensm/osm_sa_sminfo_record.c
index 97bc01e..02fb3c7 100644
--- a/opensm/osm_sa_sminfo_record.c
+++ b/opensm/osm_sa_sminfo_record.c
@@ -254,7 +254,8 @@ void osm_smir_rcv_process(IN void *ctx, IN void *data)
 		if (!p_port || local_port == p_port) {
 			if (FALSE ==
 			    osm_physp_share_pkey(sa->p_log, p_req_physp,
-						 local_port->p_physp)) {
+						 local_port->p_physp,
+						 sa->p_subn->opt.allow_both_pkeys)) {
 				cl_plock_release(sa->p_lock);
 				OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2805: "
 					"Cannot get SMInfo record due to pkey violation\n");
diff --git a/opensm/osm_sa_sw_info_record.c b/opensm/osm_sa_sw_info_record.c
index 63e51d9..4cb5fa8 100644
--- a/opensm/osm_sa_sw_info_record.c
+++ b/opensm/osm_sa_sw_info_record.c
@@ -136,7 +136,8 @@ static void sir_rcv_create_sir(IN osm_sa_t * sa, IN const osm_switch_t * p_sw,
 			cl_ntoh64(p_sw->p_node->node_info.node_guid));
 		goto Exit;
 	}
-	if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_physp))
+	if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_physp,
+				  sa->p_subn->opt.allow_both_pkeys))
 		goto Exit;
 
 	/* get the port 0 of the switch */
diff --git a/opensm/osm_sa_vlarb_record.c b/opensm/osm_sa_vlarb_record.c
index f56bfe6..18297a4 100644
--- a/opensm/osm_sa_vlarb_record.c
+++ b/opensm/osm_sa_vlarb_record.c
@@ -164,8 +164,8 @@ static void sa_vl_arb_by_comp_mask(osm_sa_t * sa, IN const osm_port_t * p_port,
 			/* check that the p_physp is valid, and that the requester
 			   and the p_physp share a pkey. */
 			if (p_physp &&
-			    osm_physp_share_pkey(sa->p_log, p_req_physp,
-						 p_physp))
+			    osm_physp_share_pkey(sa->p_log, p_req_physp, p_physp,
+						 sa->p_subn->opt.allow_both_pkeys))
 				sa_vl_arb_check_physp(sa, p_physp, p_ctxt);
 		} else {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2A03: "
@@ -184,8 +184,8 @@ static void sa_vl_arb_by_comp_mask(osm_sa_t * sa, IN const osm_port_t * p_port,
 
 			/* if the requester and the p_physp don't share a pkey -
 			   continue */
-			if (!osm_physp_share_pkey
-			    (sa->p_log, p_req_physp, p_physp))
+			if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_physp,
+						  sa->p_subn->opt.allow_both_pkeys))
 				continue;
 
 			sa_vl_arb_check_physp(sa, p_physp, p_ctxt);
-- 
1.7.7.6

-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
