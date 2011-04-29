From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 5/13] opensm/osm_sa_path_record.c: Add support for alias GUIDs
Date: Fri, 29 Apr 2011 09:27:25 -0400
Message-ID: <4DBABCBD.1020704@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 9b4c9c5e455a453986413758785563be97136bf4 Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 28 Apr 2011 23:36:38 +0300
Subject: [PATCH] opensm/osm_sa_path_record.c: Add support for alias GUIDs

Use alias_port_guid_tbl to resolve SA path queries.
Any alias GUIDs in addition to the base port GUID
are present in the table based on SA sets and
deletes of GUIDInfoRecord.

Use this table for any DGID/SGID queries so if alias GUID is
used the alias GUID paths are also determined.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_subnet.h |   30 ++++
 opensm/osm_sa_path_record.c |  371 ++++++++++++++++++++++++++++---------------
 opensm/osm_subnet.c         |   15 ++-
 3 files changed, 285 insertions(+), 131 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 5c19b19..1205846 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -1039,6 +1039,36 @@ struct osm_port *osm_get_port_by_lid_ho(const osm_subn_t * subn, uint16_t lid);
 *       Subnet object, osm_port_t
 *********/
 
+/****f* OpenSM: Subnet/osm_get_alias_guid_by_guid
+* NAME
+*	osm_get_alias_guid_by_guid
+*
+* DESCRIPTION
+*	This looks for the given port guid in the subnet table of ports by
+*	alias guid.
+*  NOTE: this code is not thread safe. Need to grab the lock before
+*  calling it.
+*
+* SYNOPSIS
+*/
+struct osm_alias_guid *osm_get_alias_guid_by_guid(IN osm_subn_t const *p_subn,
+						  IN ib_net64_t guid);
+/*
+* PARAMETERS
+*	p_subn
+*		[in] Pointer to an osm_subn_t object
+*
+*	guid
+*		[in] The alias port guid in network order
+*
+* RETURN VALUES
+*	The alias guid structure pointer if found. NULL otherwise.
+*
+* SEE ALSO
+*	Subnet object, osm_subn_construct, osm_subn_destroy,
+*	osm_alias_guid_t
+*********/
+
 /****f* OpenSM: Subnet/osm_get_port_by_alias_guid
 * NAME
 *	osm_get_port_by_alias_guid
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 04ddf96..3ebaa4f 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2008 Xsigo Systems Inc. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
@@ -152,8 +152,8 @@ sa_path_rec_apply_tavor_mtu_limit(IN const ib_path_rec_t * p_pr,
 
 static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 					     IN const ib_path_rec_t * p_pr,
-					     IN const osm_port_t * p_src_port,
-					     IN const osm_port_t * p_dest_port,
+					     IN const osm_alias_guid_t * p_src_alias_guid,
+					     IN const osm_alias_guid_t * p_dest_alias_guid,
 					     IN const uint16_t dest_lid_ho,
 					     IN const ib_net64_t comp_mask,
 					     OUT osm_path_parms_t * p_parms)
@@ -187,8 +187,8 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 
 	dest_lid = cl_hton16(dest_lid_ho);
 
-	p_dest_physp = p_dest_port->p_physp;
-	p_physp = p_src_port->p_physp;
+	p_dest_physp = p_dest_alias_guid->p_base_port->p_physp;
+	p_physp = p_src_alias_guid->p_base_port->p_physp;
 	p_src_physp = p_physp;
 	p_pi = &p_physp->port_info;
 	p_osm = sa->p_subn->p_osm;
@@ -204,7 +204,9 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	   port MTU with 1K.
 	 */
 	if (sa->p_subn->opt.enable_quirks &&
-	    sa_path_rec_apply_tavor_mtu_limit(p_pr, p_src_port, p_dest_port,
+	    sa_path_rec_apply_tavor_mtu_limit(p_pr,
+					      p_src_alias_guid->p_base_port,
+					      p_dest_alias_guid->p_base_port,
 					      comp_mask))
 		if (mtu > IB_MTU_LEN_1024) {
 			mtu = IB_MTU_LEN_1024;
@@ -329,12 +331,12 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 				"%s (GUID: 0x%016"PRIx64") port %d to "
 				"%s (GUID: 0x%016"PRIx64") port %d; "
 				"ended at %s port %d\n",
-				p_src_port->p_node->print_desc,
-				cl_ntoh64(p_src_port->p_node->node_info.node_guid),
-				p_src_port->p_physp->port_num,
-				p_dest_port->p_node->print_desc,
-				cl_ntoh64(p_dest_port->p_node->node_info.node_guid),
-				p_dest_port->p_physp->port_num,
+				p_src_alias_guid->p_base_port->p_node->print_desc,
+				cl_ntoh64(p_src_alias_guid->p_base_port->p_node->node_info.node_guid),
+				p_src_alias_guid->p_base_port->p_physp->port_num,
+				p_dest_alias_guid->p_base_port->p_node->print_desc,
+				cl_ntoh64(p_dest_alias_guid->p_base_port->p_node->node_info.node_guid),
+				p_dest_alias_guid->p_base_port->p_physp->port_num,
 				p_node->print_desc,
 				p_physp->port_num);
 			status = IB_ERROR;
@@ -469,7 +471,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	 * PacketLifeTime description, for loopback paths,
 	 * packetLifeTime shall be zero.
 	 */
-	if (p_src_port == p_dest_port)
+	if (p_src_alias_guid->p_base_port == p_dest_alias_guid->p_base_port)
 		pkt_life = 0;
 	else if (p_qos_level && p_qos_level->pkt_life_set)
 		pkt_life = p_qos_level->pkt_life;
@@ -650,11 +652,11 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 				"\"%s\"\n",
 				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
 				p_src_physp->p_node->print_desc,
-				p_src_port->p_physp->port_num,
+				p_src_alias_guid->p_base_port->p_physp->port_num,
 				cl_ntoh64(osm_physp_get_port_guid
 					  (p_dest_physp)),
 				p_dest_physp->p_node->print_desc,
-				p_dest_port->p_physp->port_num,
+				p_dest_alias_guid->p_base_port->p_physp->port_num,
 				p_qos_level->name);
 			status = IB_NOT_FOUND;
 			goto Exit;
@@ -732,10 +734,10 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 				"[%s port %d <-> %s port %d]\n", sl,
 				p_qos_level->name,
 				p_qos_level->sl,
-				p_src_port->p_node->print_desc,
-				p_src_port->p_physp->port_num,
-				p_dest_port->p_node->print_desc,
-				p_dest_port->p_physp->port_num);
+				p_src_alias_guid->p_base_port->p_node->print_desc,
+				p_src_alias_guid->p_base_port->p_physp->port_num,
+				p_dest_alias_guid->p_base_port->p_node->print_desc,
+				p_dest_alias_guid->p_base_port->p_physp->port_num);
 			status = IB_NOT_FOUND;
 			goto Exit;
 		}
@@ -765,10 +767,10 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 				"using default SL %d "
 				"[%s port %d <-> %s port %d]\n",
 				cl_ntoh16(pkey), sl,
-				p_src_port->p_node->print_desc,
-				p_src_port->p_physp->port_num,
-				p_dest_port->p_node->print_desc,
-				p_dest_port->p_physp->port_num);
+				p_src_alias_guid->p_base_port->p_node->print_desc,
+				p_src_alias_guid->p_base_port->p_physp->port_num,
+				p_dest_alias_guid->p_base_port->p_node->print_desc,
+				p_dest_alias_guid->p_base_port->p_physp->port_num);
 		} else
 			sl = p_prtn->sl;
 	} else if (sa->p_subn->opt.qos) {
@@ -788,10 +790,10 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 			"Selected SL (%u) leads to VL15 "
 			"[%s port %d <-> %s port %d]\n",
 			sl,
-			p_src_port->p_node->print_desc,
-			p_src_port->p_physp->port_num,
-			p_dest_port->p_node->print_desc,
-			p_dest_port->p_physp->port_num);
+			p_src_alias_guid->p_base_port->p_node->print_desc,
+			p_src_alias_guid->p_base_port->p_physp->port_num,
+			p_dest_alias_guid->p_base_port->p_node->print_desc,
+			p_dest_alias_guid->p_base_port->p_physp->port_num);
 		status = IB_NOT_FOUND;
 		goto Exit;
 	}
@@ -802,7 +804,9 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	 * engine override it.
 	 */
 	if (p_re && p_re->path_sl)
-		sl = p_re->path_sl(p_re->context, sl, p_src_port, p_dest_port);
+		sl = p_re->path_sl(p_re->context, sl,
+				   p_src_alias_guid->p_base_port,
+				   p_dest_alias_guid->p_base_port);
 
 	/* reset pkey when raw traffic */
 	if (comp_mask & IB_PR_COMPMASK_RAWTRAFFIC &&
@@ -829,14 +833,13 @@ ib_api_status_t osm_get_path_params(IN osm_sa_t * sa,
 				    IN const uint16_t dlid_ho,
 				    OUT osm_path_parms_t * p_parms)
 {
-	ib_path_rec_t pr;
-	memset(&pr, 0, sizeof(ib_path_rec_t));
-	return pr_rcv_get_path_parms(sa, &pr,
-		p_src_port, p_dest_port, dlid_ho, 0, p_parms);
+	return 1;
 }
 
-static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
-			    IN const osm_port_t * p_dest_port,
+static void pr_rcv_build_pr(IN osm_sa_t * sa,
+			    IN const osm_alias_guid_t * p_src_alias_guid,
+			    IN const osm_alias_guid_t * p_dest_alias_guid,
+			    IN const ib_gid_t * p_sgid,
 			    IN const ib_gid_t * p_dgid,
 			    IN const uint16_t src_lid_ho,
 			    IN const uint16_t dest_lid_ho,
@@ -844,26 +847,27 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
 			    IN const osm_path_parms_t * p_parms,
 			    OUT ib_path_rec_t * p_pr)
 {
-	const osm_physp_t *p_src_physp;
-	const osm_physp_t *p_dest_physp;
+	const osm_physp_t *p_src_physp, *p_dest_physp;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_src_physp = p_src_port->p_physp;
-
 	if (p_dgid)
 		p_pr->dgid = *p_dgid;
 	else {
-		p_dest_physp = p_dest_port->p_physp;
+		p_dest_physp = p_dest_alias_guid->p_base_port->p_physp;
 
 		p_pr->dgid.unicast.prefix =
 		    osm_physp_get_subnet_prefix(p_dest_physp);
-		p_pr->dgid.unicast.interface_id =
-		    osm_physp_get_port_guid(p_dest_physp);
+		p_pr->dgid.unicast.interface_id = p_dest_alias_guid->alias_guid;
 	}
+	if (p_sgid)
+		p_pr->sgid = *p_sgid;
+	else {
+		p_src_physp = p_src_alias_guid->p_base_port->p_physp;
 
-	p_pr->sgid.unicast.prefix = osm_physp_get_subnet_prefix(p_src_physp);
-	p_pr->sgid.unicast.interface_id = osm_physp_get_port_guid(p_src_physp);
+		p_pr->sgid.unicast.prefix = osm_physp_get_subnet_prefix(p_src_physp);
+		p_pr->sgid.unicast.interface_id = p_src_alias_guid->alias_guid;
+	}
 
 	p_pr->dlid = cl_hton16(dest_lid_ho);
 	p_pr->slid = cl_hton16(src_lid_ho);
@@ -882,7 +886,7 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
 
 	/* According to 1.2 spec definition Table 205 PacketLifeTime description,
 	   for loopback paths, packetLifeTime shall be zero. */
-	if (p_src_port == p_dest_port)
+	if (p_src_alias_guid->p_base_port == p_dest_alias_guid->p_base_port)
 		p_pr->pkt_life = 0x80;	/* loopback */
 	else
 		p_pr->pkt_life = (uint8_t) (p_parms->pkt_life | 0x80);
@@ -898,9 +902,9 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
 
 static osm_pr_item_t *pr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
 					       IN const ib_path_rec_t * p_pr,
-					       IN const osm_port_t * p_src_port,
-					       IN const osm_port_t *
-					       p_dest_port,
+					       IN const osm_alias_guid_t * p_src_alias_guid,
+					       IN const osm_alias_guid_t * p_dest_alias_guid,
+					       IN const ib_gid_t * p_sgid,
 					       IN const ib_gid_t * p_dgid,
 					       IN const uint16_t src_lid_ho,
 					       IN const uint16_t dest_lid_ho,
@@ -925,8 +929,9 @@ static osm_pr_item_t *pr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
 	}
 	memset(p_pr_item, 0, sizeof(*p_pr_item));
 
-	status = pr_rcv_get_path_parms(sa, p_pr, p_src_port, p_dest_port,
-				       dest_lid_ho, comp_mask, &path_parms);
+	status = pr_rcv_get_path_parms(sa, p_pr, p_src_alias_guid,
+				       p_dest_alias_guid, dest_lid_ho,
+				       comp_mask, &path_parms);
 
 	if (status != IB_SUCCESS) {
 		free(p_pr_item);
@@ -935,8 +940,8 @@ static osm_pr_item_t *pr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
 	}
 
 	/* now try the reversible path */
-	rev_path_status = pr_rcv_get_path_parms(sa, p_pr, p_dest_port,
-						p_src_port, src_lid_ho,
+	rev_path_status = pr_rcv_get_path_parms(sa, p_pr, p_dest_alias_guid,
+						p_src_alias_guid, src_lid_ho,
 						comp_mask, &rev_path_parms);
 	path_parms.reversible = (rev_path_status == IB_SUCCESS);
 
@@ -955,8 +960,8 @@ static osm_pr_item_t *pr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
 		goto Exit;
 	}
 
-	pr_rcv_build_pr(sa, p_src_port, p_dest_port, p_dgid, src_lid_ho,
-			dest_lid_ho, preference, &path_parms,
+	pr_rcv_build_pr(sa, p_src_alias_guid, p_dest_alias_guid, p_sgid, p_dgid,
+			src_lid_ho, dest_lid_ho, preference, &path_parms,
 			&p_pr_item->path_rec);
 
 Exit:
@@ -967,8 +972,9 @@ Exit:
 static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 				       IN const ib_sa_mad_t *sa_mad,
 				       IN const osm_port_t * p_req_port,
-				       IN const osm_port_t * p_src_port,
-				       IN const osm_port_t * p_dest_port,
+				       IN const osm_alias_guid_t * p_src_alias_guid,
+				       IN const osm_alias_guid_t * p_dest_alias_guid,
+				       IN const ib_gid_t * p_sgid,
 				       IN const ib_gid_t * p_dgid,
 				       IN cl_qlist_t * p_list)
 {
@@ -989,15 +995,17 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"Src port 0x%016" PRIx64 ", Dst port 0x%016" PRIx64 "\n",
-		cl_ntoh64(osm_port_get_guid(p_src_port)),
-		cl_ntoh64(osm_port_get_guid(p_dest_port)));
+		cl_ntoh64(p_src_alias_guid->alias_guid),
+		cl_ntoh64(p_dest_alias_guid->alias_guid));
 
 	/* Check that the req_port, src_port and dest_port all share a
 	   pkey. The check is done on the default physical port of the ports. */
-	if (osm_port_share_pkey(sa->p_log, p_req_port, p_src_port) == FALSE
+	if (osm_port_share_pkey(sa->p_log, p_req_port,
+				p_src_alias_guid->p_base_port) == FALSE
 	    || osm_port_share_pkey(sa->p_log, p_req_port,
-				   p_dest_port) == FALSE
-	    || osm_port_share_pkey(sa->p_log, p_src_port, p_dest_port) == FALSE)
+				   p_dest_alias_guid->p_base_port) == FALSE
+	    || osm_port_share_pkey(sa->p_log, p_src_alias_guid->p_base_port,
+				   p_dest_alias_guid->p_base_port) == FALSE)
 		/* One of the pairs doesn't share a pkey so the path is disqualified. */
 		goto Exit;
 
@@ -1052,21 +1060,21 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 	if (comp_mask & IB_PR_COMPMASK_DLID)
 		dest_lid_max_ho = dest_lid_min_ho = cl_ntoh16(p_pr->dlid);
 	else
-		osm_port_get_lid_range_ho(p_dest_port, &dest_lid_min_ho,
-					  &dest_lid_max_ho);
+		osm_port_get_lid_range_ho(p_dest_alias_guid->p_base_port,
+					  &dest_lid_min_ho, &dest_lid_max_ho);
 
 	if (comp_mask & IB_PR_COMPMASK_SLID)
 		src_lid_max_ho = src_lid_min_ho = cl_ntoh16(p_pr->slid);
 	else
-		osm_port_get_lid_range_ho(p_src_port, &src_lid_min_ho,
-					  &src_lid_max_ho);
+		osm_port_get_lid_range_ho(p_src_alias_guid->p_base_port,
+					  &src_lid_min_ho, &src_lid_max_ho);
 
 	if (src_lid_min_ho == 0) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F20:"
 			"Obtained source LID of 0. No such LID possible "
 			"(%s port %d)\n",
-			p_src_port->p_node->print_desc,
-			p_src_port->p_physp->port_num);
+			p_src_alias_guid->p_base_port->p_node->print_desc,
+			p_src_alias_guid->p_base_port->p_physp->port_num);
 		goto Exit;
 	}
 
@@ -1074,8 +1082,8 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F21:"
 			"Obtained destination LID of 0. No such LID possible "
 			"(%s port %d)\n",
-			p_dest_port->p_node->print_desc,
-			p_dest_port->p_physp->port_num);
+			p_dest_alias_guid->p_base_port->p_node->print_desc,
+			p_dest_alias_guid->p_base_port->p_physp->port_num);
 		goto Exit;
 	}
 
@@ -1106,8 +1114,9 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 		   These paths are "fully redundant"
 		 */
 
-		p_pr_item = pr_rcv_get_lid_pair_path(sa, p_pr, p_src_port,
-						     p_dest_port, p_dgid,
+		p_pr_item = pr_rcv_get_lid_pair_path(sa, p_pr, p_src_alias_guid,
+						     p_dest_alias_guid,
+						     p_sgid, p_dgid,
 						     src_lid_ho, dest_lid_ho,
 						     comp_mask, preference);
 
@@ -1169,10 +1178,11 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 		if (src_offset == dest_offset)
 			continue;	/* already reported */
 
-		p_pr_item = pr_rcv_get_lid_pair_path(sa, p_pr, p_src_port,
-						     p_dest_port, p_dgid,
-						     src_lid_ho, dest_lid_ho,
-						     comp_mask, preference);
+		p_pr_item = pr_rcv_get_lid_pair_path(sa, p_pr, p_src_alias_guid,
+						     p_dest_alias_guid, p_sgid,
+						     p_dgid, src_lid_ho,
+						     dest_lid_ho, comp_mask,
+						     preference);
 
 		if (p_pr_item) {
 			cl_qlist_insert_tail(p_list, &p_pr_item->list_item);
@@ -1219,8 +1229,11 @@ static ib_net64_t find_router(const osm_sa_t *sa, ib_net64_t prefix)
 
 static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 					IN const ib_sa_mad_t *sa_mad,
+					OUT const osm_alias_guid_t ** pp_src_alias_guid,
+					OUT const osm_alias_guid_t ** pp_dest_alias_guid,
 					OUT const osm_port_t ** pp_src_port,
 					OUT const osm_port_t ** pp_dest_port,
+					OUT const ib_gid_t ** pp_sgid,
 					OUT const ib_gid_t ** pp_dgid)
 {
 	const ib_path_rec_t *p_pr = ib_sa_mad_get_payload_ptr(sa_mad);
@@ -1240,6 +1253,8 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 	   into the endpoints.
 	 */
 
+	*pp_src_alias_guid = NULL;
+	*pp_src_port = NULL;
 	if (comp_mask & IB_PR_COMPMASK_SGID) {
 		if (!ib_gid_is_link_local(&p_pr->sgid)) {
 			if (ib_gid_get_subnet_prefix(&p_pr->sgid) !=
@@ -1258,10 +1273,9 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 			}
 		}
 
-		*pp_src_port = osm_get_port_by_guid(sa->p_subn,
-						    p_pr->sgid.unicast.
-						    interface_id);
-		if (!*pp_src_port) {
+		*pp_src_alias_guid = osm_get_alias_guid_by_guid(sa->p_subn,
+								p_pr->sgid.unicast.interface_id);
+		if (!*pp_src_alias_guid) {
 			/*
 			   This 'error' is the client's fault (bad gid) so
 			   don't enter it as an error in our own log.
@@ -1273,6 +1287,8 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 			sa_status = IB_SA_MAD_STATUS_INVALID_GID;
 			goto Exit;
 		}
+		if (pp_sgid)
+			*pp_sgid = &p_pr->sgid;
 	} else if (comp_mask & IB_PR_COMPMASK_SLID) {
 		*pp_src_port = osm_get_port_by_lid(sa->p_subn, p_pr->slid);
 		if (!*pp_src_port) {
@@ -1286,9 +1302,10 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 			sa_status = IB_SA_MAD_STATUS_NO_RECORDS;
 			goto Exit;
 		}
-	} else
-		*pp_src_port = NULL;
+	}
 
+	*pp_dest_alias_guid = NULL;
+	*pp_dest_port = NULL;
 	if (comp_mask & IB_PR_COMPMASK_DGID) {
 		if (!ib_gid_is_link_local(&p_pr->dgid) &&
 		    !ib_gid_is_multicast(&p_pr->dgid) &&
@@ -1310,8 +1327,9 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 		} else
 			dest_guid = p_pr->dgid.unicast.interface_id;
 
-		*pp_dest_port = osm_get_port_by_guid(sa->p_subn, dest_guid);
-		if (!*pp_dest_port) {
+		*pp_dest_alias_guid = osm_get_alias_guid_by_guid(sa->p_subn,
+								 dest_guid);
+		if (!*pp_dest_alias_guid) {
 			/*
 			   This 'error' is the client's fault (bad gid) so
 			   don't enter it as an error in our own log.
@@ -1336,8 +1354,7 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
 			sa_status = IB_SA_MAD_STATUS_NO_RECORDS;
 			goto Exit;
 		}
-	} else
-		*pp_dest_port = NULL;
+	}
 
 Exit:
 	OSM_LOG_EXIT(sa->p_log);
@@ -1346,12 +1363,12 @@ Exit:
 
 static void pr_rcv_process_world(IN osm_sa_t * sa, IN const ib_sa_mad_t * sa_mad,
 				 IN const osm_port_t * requester_port,
+				 IN const ib_gid_t * p_sgid,
 				 IN const ib_gid_t * p_dgid,
 				 IN cl_qlist_t * p_list)
 {
 	const cl_qmap_t *p_tbl;
-	const osm_port_t *p_dest_port;
-	const osm_port_t *p_src_port;
+	const osm_alias_guid_t *p_dest_alias_guid, *p_src_alias_guid;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -1363,25 +1380,26 @@ static void pr_rcv_process_world(IN osm_sa_t * sa, IN const ib_sa_mad_t * sa_mad
 	   We compute both A -> B and B -> A, since we don't have
 	   any check to determine the reversability of the paths.
 	 */
-	p_tbl = &sa->p_subn->port_guid_tbl;
+	p_tbl = &sa->p_subn->alias_port_guid_tbl;
 
-	p_dest_port = (osm_port_t *) cl_qmap_head(p_tbl);
-	while (p_dest_port != (osm_port_t *) cl_qmap_end(p_tbl)) {
-		p_src_port = (osm_port_t *) cl_qmap_head(p_tbl);
-		while (p_src_port != (osm_port_t *) cl_qmap_end(p_tbl)) {
+	p_dest_alias_guid = (osm_alias_guid_t *) cl_qmap_head(p_tbl);
+	while (p_dest_alias_guid != (osm_alias_guid_t *) cl_qmap_end(p_tbl)) {
+		p_src_alias_guid = (osm_alias_guid_t *) cl_qmap_head(p_tbl);
+		while (p_src_alias_guid != (osm_alias_guid_t *) cl_qmap_end(p_tbl)) {
 			pr_rcv_get_port_pair_paths(sa, sa_mad, requester_port,
-						   p_src_port, p_dest_port,
-						   p_dgid, p_list);
+						   p_src_alias_guid,
+						   p_dest_alias_guid,
+						   p_sgid, p_dgid, p_list);
 			if (sa_mad->method == IB_MAD_METHOD_GET &&
 			    cl_qlist_count(p_list) > 0)
 				goto Exit;
 
-			p_src_port =
-			    (osm_port_t *) cl_qmap_next(&p_src_port->map_item);
+			p_src_alias_guid =
+			    (osm_alias_guid_t *) cl_qmap_next(&p_src_alias_guid->map_item);
 		}
 
-		p_dest_port =
-		    (osm_port_t *) cl_qmap_next(&p_dest_port->map_item);
+		p_dest_alias_guid =
+		    (osm_alias_guid_t *) cl_qmap_next(&p_dest_alias_guid->map_item);
 	}
 
 Exit:
@@ -1390,13 +1408,14 @@ Exit:
 
 static void pr_rcv_process_half(IN osm_sa_t * sa, IN const ib_sa_mad_t * sa_mad,
 				IN const osm_port_t * requester_port,
-				IN const osm_port_t * p_src_port,
-				IN const osm_port_t * p_dest_port,
+				IN const osm_alias_guid_t * p_src_alias_guid,
+				IN const osm_alias_guid_t * p_dest_alias_guid,
+				IN const ib_gid_t * p_sgid,
 				IN const ib_gid_t * p_dgid,
 				IN cl_qlist_t * p_list)
 {
 	const cl_qmap_t *p_tbl;
-	const osm_port_t *p_port;
+	const osm_alias_guid_t *p_alias_guid;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -1405,35 +1424,37 @@ static void pr_rcv_process_half(IN osm_sa_t * sa, IN const ib_sa_mad_t * sa_mad,
 	   A path record from a port to itself is legit, so no
 	   need to special case that one.
 	 */
-	p_tbl = &sa->p_subn->port_guid_tbl;
+	p_tbl = &sa->p_subn->alias_port_guid_tbl;
 
-	if (p_src_port) {
+	if (p_src_alias_guid) {
 		/*
 		   The src port if fixed, so iterate over destination ports.
 		 */
-		p_port = (osm_port_t *) cl_qmap_head(p_tbl);
-		while (p_port != (osm_port_t *) cl_qmap_end(p_tbl)) {
+		p_alias_guid = (osm_alias_guid_t *) cl_qmap_head(p_tbl);
+		while (p_alias_guid != (osm_alias_guid_t *) cl_qmap_end(p_tbl)) {
 			pr_rcv_get_port_pair_paths(sa, sa_mad, requester_port,
-						   p_src_port, p_port, p_dgid,
-						   p_list);
+						   p_src_alias_guid,
+						   p_alias_guid,
+						   p_sgid, p_dgid, p_list);
 			if (sa_mad->method == IB_MAD_METHOD_GET &&
 			    cl_qlist_count(p_list) > 0)
 				break;
-			p_port = (osm_port_t *) cl_qmap_next(&p_port->map_item);
+			p_alias_guid = (osm_alias_guid_t *) cl_qmap_next(&p_alias_guid->map_item);
 		}
 	} else {
 		/*
 		   The dest port if fixed, so iterate over source ports.
 		 */
-		p_port = (osm_port_t *) cl_qmap_head(p_tbl);
-		while (p_port != (osm_port_t *) cl_qmap_end(p_tbl)) {
+		p_alias_guid = (osm_alias_guid_t *) cl_qmap_head(p_tbl);
+		while (p_alias_guid != (osm_alias_guid_t *) cl_qmap_end(p_tbl)) {
 			pr_rcv_get_port_pair_paths(sa, sa_mad, requester_port,
-						   p_port, p_dest_port, p_dgid,
-						   p_list);
+						   p_alias_guid,
+						   p_dest_alias_guid, p_sgid,
+						   p_dgid, p_list);
 			if (sa_mad->method == IB_MAD_METHOD_GET &&
 			    cl_qlist_count(p_list) > 0)
 				break;
-			p_port = (osm_port_t *) cl_qmap_next(&p_port->map_item);
+			p_alias_guid = (osm_alias_guid_t *) cl_qmap_next(&p_alias_guid->map_item);
 		}
 	}
 
@@ -1442,15 +1463,16 @@ static void pr_rcv_process_half(IN osm_sa_t * sa, IN const ib_sa_mad_t * sa_mad,
 
 static void pr_rcv_process_pair(IN osm_sa_t * sa, IN const ib_sa_mad_t * sa_mad,
 				IN const osm_port_t * requester_port,
-				IN const osm_port_t * p_src_port,
-				IN const osm_port_t * p_dest_port,
+				IN const osm_alias_guid_t * p_src_alias_guid,
+				IN const osm_alias_guid_t * p_dest_alias_guid,
+				IN const ib_gid_t * p_sgid,
 				IN const ib_gid_t * p_dgid,
 				IN cl_qlist_t * p_list)
 {
 	OSM_LOG_ENTER(sa->p_log);
 
-	pr_rcv_get_port_pair_paths(sa, sa_mad, requester_port, p_src_port,
-				   p_dest_port, p_dgid, p_list);
+	pr_rcv_get_port_pair_paths(sa, sa_mad, requester_port, p_src_alias_guid,
+				   p_dest_alias_guid, p_sgid, p_dgid, p_list);
 
 	OSM_LOG_EXIT(sa->p_log);
 }
@@ -1600,7 +1622,8 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 	const ib_sa_mad_t *p_sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
 	ib_path_rec_t *p_pr = ib_sa_mad_get_payload_ptr(p_sa_mad);
 	cl_qlist_t pr_list;
-	const ib_gid_t *p_dgid = NULL;
+	const ib_gid_t *p_sgid = NULL, *p_dgid = NULL;
+	const osm_alias_guid_t *p_src_alias_guid, *p_dest_alias_guid;
 	const osm_port_t *p_src_port, *p_dest_port;
 	osm_port_t *requester_port;
 
@@ -1650,31 +1673,121 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Unicast destination requested\n");
 
-	if (pr_rcv_get_end_points(sa, p_sa_mad, &p_src_port, &p_dest_port,
-				  &p_dgid) != IB_SA_MAD_STATUS_SUCCESS)
+	if (pr_rcv_get_end_points(sa, p_sa_mad,
+				  &p_src_alias_guid, &p_dest_alias_guid,
+				  &p_src_port, &p_dest_port,
+				  &p_sgid, &p_dgid) != IB_SA_MAD_STATUS_SUCCESS)
 		goto Unlock;
 	/*
 	   What happens next depends on the type of endpoint information
 	   that was specified....
 	 */
-	if (p_src_port) {
-		if (p_dest_port)
+	if (p_src_alias_guid) {
+		if (p_dest_alias_guid)
 			pr_rcv_process_pair(sa, p_sa_mad, requester_port,
-					    p_src_port, p_dest_port, p_dgid,
-					    &pr_list);
-		else
+					    p_src_alias_guid, p_dest_alias_guid,
+					    p_sgid, p_dgid, &pr_list);
+		else if (!p_dest_port)
 			pr_rcv_process_half(sa, p_sa_mad, requester_port,
-					    p_src_port, NULL, p_dgid, &pr_list);
+					    p_src_alias_guid, NULL, p_sgid,
+					    p_dgid, &pr_list);
+		else {
+			/* Get all alias GUIDs for the dest port */
+			p_dest_alias_guid = (osm_alias_guid_t *) cl_qmap_head(&sa->p_subn->alias_port_guid_tbl);
+			while (p_dest_alias_guid !=
+			       (osm_alias_guid_t *) cl_qmap_end(&sa->p_subn->alias_port_guid_tbl)) {
+				if (osm_get_port_by_alias_guid(sa->p_subn, p_dest_alias_guid->alias_guid) ==
+				    p_dest_port)
+					pr_rcv_process_pair(sa, p_sa_mad,
+							    requester_port,
+							    p_src_alias_guid,
+							    p_dest_alias_guid,
+							    p_sgid, p_dgid,
+							    &pr_list);
+				if (p_sa_mad->method == IB_MAD_METHOD_GET &&
+				    cl_qlist_count(&pr_list) > 0)
+					break;
+
+				p_dest_alias_guid = (osm_alias_guid_t *) cl_qmap_next(&p_dest_alias_guid->map_item);
+			}
+		}
 	} else {
-		if (p_dest_port)
+		if (p_dest_alias_guid)
 			pr_rcv_process_half(sa, p_sa_mad, requester_port,
-					    NULL, p_dest_port, p_dgid, &pr_list);
-		else
+					    NULL, p_dest_alias_guid, p_sgid,
+					    p_dgid, &pr_list);
+		else if (!p_src_port && !p_dest_port)
 			/*
 			   Katie, bar the door!
 			 */
 			pr_rcv_process_world(sa, p_sa_mad, requester_port,
-					     p_dgid, &pr_list);
+					     p_sgid, p_dgid, &pr_list);
+		else if (p_src_port && !p_dest_port) {
+			/* Get all alias GUIDs for the src port */
+			p_src_alias_guid = (osm_alias_guid_t *) cl_qmap_head(&sa->p_subn->alias_port_guid_tbl);
+			while (p_src_alias_guid !=
+			       (osm_alias_guid_t *) cl_qmap_end(&sa->p_subn->alias_port_guid_tbl)) {
+				if (osm_get_port_by_alias_guid(sa->p_subn,
+							       p_src_alias_guid->alias_guid) ==
+				    p_src_port)
+					pr_rcv_process_half(sa, p_sa_mad,
+							    requester_port,
+							    p_src_alias_guid,
+							    NULL, p_sgid,
+							    p_dgid, &pr_list);
+				p_src_alias_guid = (osm_alias_guid_t *) cl_qmap_next(&p_src_alias_guid->map_item);
+			}
+		} else if (p_dest_port && !p_src_port) {
+			/* Get all alias GUIDs for the dest port */
+			p_dest_alias_guid = (osm_alias_guid_t *) cl_qmap_head(&sa->p_subn->alias_port_guid_tbl);
+			while (p_dest_alias_guid !=
+			       (osm_alias_guid_t *) cl_qmap_end(&sa->p_subn->alias_port_guid_tbl)) {
+				if (osm_get_port_by_alias_guid(sa->p_subn,
+							       p_dest_alias_guid->alias_guid) ==
+				    p_dest_port)
+					pr_rcv_process_half(sa, p_sa_mad,
+							    requester_port,
+							    NULL,
+							    p_dest_alias_guid,
+							    p_sgid, p_dgid,
+							    &pr_list);
+				p_dest_alias_guid = (osm_alias_guid_t *) cl_qmap_next(&p_dest_alias_guid->map_item);
+			}
+		} else {
+			/* Get all alias GUIDs for the src port */
+			p_src_alias_guid = (osm_alias_guid_t *) cl_qmap_head(&sa->p_subn->alias_port_guid_tbl);
+			while (p_src_alias_guid !=
+			       (osm_alias_guid_t *) cl_qmap_end(&sa->p_subn->alias_port_guid_tbl)) {
+				if (osm_get_port_by_alias_guid(sa->p_subn,
+							       p_src_alias_guid->alias_guid) ==
+				    p_src_port) {
+					/* Get all alias GUIDs for the dest port */
+					p_dest_alias_guid = (osm_alias_guid_t *) cl_qmap_head(&sa->p_subn->alias_port_guid_tbl);
+					while (p_dest_alias_guid !=
+					       (osm_alias_guid_t *) cl_qmap_end(&sa->p_subn->alias_port_guid_tbl)) {
+						if (osm_get_port_by_alias_guid(sa->p_subn,
+									       p_dest_alias_guid->alias_guid) ==
+						    p_dest_port)
+						pr_rcv_process_pair(sa,
+								    p_sa_mad,
+								    requester_port,
+								    p_src_alias_guid,
+								    p_dest_alias_guid,
+								    p_sgid,
+								    p_dgid,
+								    &pr_list);
+						if (p_sa_mad->method == IB_MAD_METHOD_GET &&
+						    cl_qlist_count(&pr_list) > 0)
+							break;
+						p_dest_alias_guid = (osm_alias_guid_t *) cl_qmap_next(&p_dest_alias_guid->map_item);
+					}
+ 				}
+				if (p_sa_mad->method == IB_MAD_METHOD_GET &&
+				    cl_qlist_count(&pr_list) > 0)
+					break;
+				p_src_alias_guid = (osm_alias_guid_t *) cl_qmap_next(&p_src_alias_guid->map_item);
+			}
+		}
 	}
 
 Unlock:
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 32b5e1e..e8d5646 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -651,14 +651,25 @@ osm_port_t *osm_get_port_by_guid(IN osm_subn_t const *p_subn, IN ib_net64_t guid
 	return p_port;
 }
 
-osm_port_t *osm_get_port_by_alias_guid(IN osm_subn_t const *p_subn,
-				       IN ib_net64_t guid)
+osm_alias_guid_t *osm_get_alias_guid_by_guid(IN osm_subn_t const *p_subn,
+					     IN ib_net64_t guid)
 {
 	osm_alias_guid_t *p_alias_guid;
 
 	p_alias_guid = (osm_alias_guid_t *) cl_qmap_get(&(p_subn->alias_port_guid_tbl), guid);
 	if (p_alias_guid == (osm_alias_guid_t *) cl_qmap_end(&(p_subn->alias_port_guid_tbl)))
 		return NULL;
+	return p_alias_guid;
+}
+
+osm_port_t *osm_get_port_by_alias_guid(IN osm_subn_t const *p_subn,
+				       IN ib_net64_t guid)
+{
+	osm_alias_guid_t *p_alias_guid;
+
+	p_alias_guid = osm_get_alias_guid_by_guid(p_subn, guid);
+	if (!p_alias_guid)
+		return NULL;
 	return p_alias_guid->p_base_port;
 }
 
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
