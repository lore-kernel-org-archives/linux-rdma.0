From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 8/13] opensm/osm_sa_multipath_record.c: Add support for alias
 GUIDs
Date: Fri, 29 Apr 2011 09:27:44 -0400
Message-ID: <4DBABCD0.1010309@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From edf1f90e782cfa52617d7a3a4e0428bdcfcd0268 Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Fri, 29 Apr 2011 00:00:56 +0300
Subject: [PATCH] opensm/osm_sa_multipath_record.c: Add support for alias GUIDs

Similar to osm_sa_path_record.c change for alias GUID support

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_multipath_record.c |  264 ++++++++++++++++++++------------------
 1 files changed, 142 insertions(+), 122 deletions(-)

diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index 208dc31..10d65c8 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -150,8 +150,8 @@ sa_multipath_rec_apply_tavor_mtu_limit(IN const ib_multipath_rec_t * p_mpr,
 static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 					      IN const ib_multipath_rec_t *
 					      p_mpr,
-					      IN const osm_port_t * p_src_port,
-					      IN const osm_port_t * p_dest_port,
+					      IN const osm_alias_guid_t * p_src_alias_guid,
+					      IN const osm_alias_guid_t * p_dest_alias_guid,
 					      IN const uint16_t dest_lid_ho,
 					      IN const ib_net64_t comp_mask,
 					      OUT osm_path_parms_t * p_parms)
@@ -183,8 +183,8 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 
 	dest_lid = cl_hton16(dest_lid_ho);
 
-	p_dest_physp = p_dest_port->p_physp;
-	p_physp = p_src_port->p_physp;
+	p_dest_physp = p_dest_alias_guid->p_base_port->p_physp;
+	p_physp = p_src_alias_guid->p_base_port->p_physp;
 	p_src_physp = p_physp;
 	p_pi = &p_physp->port_info;
 
@@ -198,8 +198,10 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 	   port MTU with 1K.
 	 */
 	if (sa->p_subn->opt.enable_quirks &&
-	    sa_multipath_rec_apply_tavor_mtu_limit(p_mpr, p_src_port,
-						   p_dest_port, comp_mask))
+	    sa_multipath_rec_apply_tavor_mtu_limit(p_mpr,
+						   p_src_alias_guid->p_base_port,
+						   p_dest_alias_guid->p_base_port,
+						   comp_mask))
 		if (mtu > IB_MTU_LEN_1024) {
 			mtu = IB_MTU_LEN_1024;
 			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
@@ -341,12 +343,12 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 				"from %s (GUID: 0x%016"PRIx64") port %d "
 				"to %s (GUID: 0x%016"PRIx64") port %d; "
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
@@ -546,7 +548,7 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 	/* Verify the pkt_life_time */
 	/* According to spec definition IBA 1.2 Table 205 PacketLifeTime description,
 	   for loopback paths, packetLifeTime shall be zero. */
-	if (p_src_port == p_dest_port)
+	if (p_src_alias_guid->p_base_port == p_dest_alias_guid->p_base_port)
 		pkt_life = 0;	/* loopback */
 	else if (p_qos_level && p_qos_level->pkt_life_set)
 		pkt_life = p_qos_level->pkt_life;
@@ -729,10 +731,10 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 				"[%s port %d <-> %s port %d]\n", required_sl,
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
@@ -766,10 +768,10 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 				"using default SL %d "
 				"[%s port %d <-> %s port %d]\n",
 				cl_ntoh16(required_pkey), required_sl,
-				p_src_port->p_node->print_desc,
-				p_src_port->p_physp->port_num,
-				p_dest_port->p_node->print_desc,
-				p_dest_port->p_physp->port_num);
+				p_src_alias_guid->p_base_port->p_node->print_desc,
+				p_src_alias_guid->p_base_port->p_physp->port_num,
+				p_dest_alias_guid->p_base_port->p_node->print_desc,
+				p_dest_alias_guid->p_base_port->p_physp->port_num);
 		} else
 			required_sl = p_prtn->sl;
 
@@ -790,10 +792,10 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 			"Selected SL (%u) leads to VL15 "
 			"[%s port %d <-> %s port %d]\n",
 			required_sl,
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
@@ -820,20 +822,20 @@ Exit:
 	return status;
 }
 
-static void mpr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
-			     IN const osm_port_t * p_dest_port,
+static void mpr_rcv_build_pr(IN osm_sa_t * sa,
+			     IN const osm_alias_guid_t * p_src_alias_guid,
+			     IN const osm_alias_guid_t * p_dest_alias_guid,
 			     IN uint16_t src_lid_ho, IN uint16_t dest_lid_ho,
 			     IN uint8_t preference,
 			     IN const osm_path_parms_t * p_parms,
 			     OUT ib_path_rec_t * p_pr)
 {
-	const osm_physp_t *p_src_physp;
-	const osm_physp_t *p_dest_physp;
+	const osm_physp_t *p_src_physp, *p_dest_physp;
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_src_physp = p_src_port->p_physp;
-	p_dest_physp = p_dest_port->p_physp;
+	p_src_physp = p_src_alias_guid->p_base_port->p_physp;
+	p_dest_physp = p_dest_alias_guid->p_base_port->p_physp;
 
 	p_pr->dgid.unicast.prefix = osm_physp_get_subnet_prefix(p_dest_physp);
 	p_pr->dgid.unicast.interface_id = osm_physp_get_port_guid(p_dest_physp);
@@ -854,7 +856,7 @@ static void mpr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
 
 	/* According to 1.2 spec definition Table 205 PacketLifeTime description,
 	   for loopback paths, packetLifeTime shall be zero. */
-	if (p_src_port == p_dest_port)
+	if (p_src_alias_guid->p_base_port == p_dest_alias_guid->p_base_port)
 		p_pr->pkt_life = 0x80;	/* loopback */
 	else
 		p_pr->pkt_life = (uint8_t) (p_parms->pkt_life | 0x80);
@@ -871,10 +873,10 @@ static void mpr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
 static osm_mpr_item_t *mpr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
 						 IN const ib_multipath_rec_t *
 						 p_mpr,
-						 IN const osm_port_t *
-						 p_src_port,
-						 IN const osm_port_t *
-						 p_dest_port,
+						 IN const osm_alias_guid_t *
+						 p_src_alias_guid,
+						 IN const osm_alias_guid_t *
+						 p_dest_alias_guid,
 						 IN const uint16_t src_lid_ho,
 						 IN const uint16_t dest_lid_ho,
 						 IN const ib_net64_t comp_mask,
@@ -898,8 +900,9 @@ static osm_mpr_item_t *mpr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
 	}
 	memset(p_pr_item, 0, sizeof(*p_pr_item));
 
-	status = mpr_rcv_get_path_parms(sa, p_mpr, p_src_port, p_dest_port,
-					dest_lid_ho, comp_mask, &path_parms);
+	status = mpr_rcv_get_path_parms(sa, p_mpr, p_src_alias_guid,
+					p_dest_alias_guid, dest_lid_ho,
+					comp_mask, &path_parms);
 
 	if (status != IB_SUCCESS) {
 		free(p_pr_item);
@@ -908,8 +911,8 @@ static osm_mpr_item_t *mpr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
 	}
 
 	/* now try the reversible path */
-	rev_path_status = mpr_rcv_get_path_parms(sa, p_mpr, p_dest_port,
-						 p_src_port, src_lid_ho,
+	rev_path_status = mpr_rcv_get_path_parms(sa, p_mpr, p_dest_alias_guid,
+						 p_src_alias_guid, src_lid_ho,
 						 comp_mask, &rev_path_parms);
 	path_parms.reversible = (rev_path_status == IB_SUCCESS);
 
@@ -930,12 +933,13 @@ static osm_mpr_item_t *mpr_rcv_get_lid_pair_path(IN osm_sa_t * sa,
 		}
 	}
 
-	p_pr_item->p_src_port = p_src_port;
-	p_pr_item->p_dest_port = p_dest_port;
+	p_pr_item->p_src_port = p_src_alias_guid->p_base_port;
+	p_pr_item->p_dest_port = p_dest_alias_guid->p_base_port;
 	p_pr_item->hops = path_parms.hops;
 
-	mpr_rcv_build_pr(sa, p_src_port, p_dest_port, src_lid_ho, dest_lid_ho,
-			 preference, &path_parms, &p_pr_item->path_rec);
+	mpr_rcv_build_pr(sa, p_src_alias_guid, p_dest_alias_guid, src_lid_ho,
+			 dest_lid_ho, preference, &path_parms,
+			 &p_pr_item->path_rec);
 
 Exit:
 	OSM_LOG_EXIT(sa->p_log);
@@ -945,8 +949,8 @@ Exit:
 static uint32_t mpr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 					    IN const ib_multipath_rec_t * p_mpr,
 					    IN const osm_port_t * p_req_port,
-					    IN const osm_port_t * p_src_port,
-					    IN const osm_port_t * p_dest_port,
+					    IN const osm_alias_guid_t * p_src_alias_guid,
+					    IN const osm_alias_guid_t * p_dest_alias_guid,
 					    IN const uint32_t rem_paths,
 					    IN const ib_net64_t comp_mask,
 					    IN cl_qlist_t * p_list)
@@ -966,15 +970,17 @@ static uint32_t mpr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 
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
 
@@ -1023,9 +1029,10 @@ static uint32_t mpr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 	   redundancy, but I'm not going to bother with that now.
 	 */
 
-	osm_port_get_lid_range_ho(p_src_port, &src_lid_min_ho, &src_lid_max_ho);
-	osm_port_get_lid_range_ho(p_dest_port, &dest_lid_min_ho,
-				  &dest_lid_max_ho);
+	osm_port_get_lid_range_ho(p_src_alias_guid->p_base_port,
+				  &src_lid_min_ho, &src_lid_max_ho);
+	osm_port_get_lid_range_ho(p_dest_alias_guid->p_base_port,
+				  &dest_lid_min_ho, &dest_lid_max_ho);
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Src LID [%u-%u], Dest LID [%u-%u]\n",
 		src_lid_min_ho, src_lid_max_ho,
@@ -1043,10 +1050,11 @@ static uint32_t mpr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 		/*
 		   These paths are "fully redundant"
 		 */
-		p_pr_item = mpr_rcv_get_lid_pair_path(sa, p_mpr, p_src_port,
-						      p_dest_port, src_lid_ho,
-						      dest_lid_ho, comp_mask,
-						      preference);
+		p_pr_item = mpr_rcv_get_lid_pair_path(sa, p_mpr,
+						      p_src_alias_guid,
+						      p_dest_alias_guid,
+						      src_lid_ho, dest_lid_ho,
+						      comp_mask, preference);
 
 		if (p_pr_item) {
 			cl_qlist_insert_tail(p_list, &p_pr_item->list_item);
@@ -1106,10 +1114,11 @@ static uint32_t mpr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 		if (src_offset == dest_offset)
 			continue;	/* already reported */
 
-		p_pr_item = mpr_rcv_get_lid_pair_path(sa, p_mpr, p_src_port,
-						      p_dest_port, src_lid_ho,
-						      dest_lid_ho, comp_mask,
-						      preference);
+		p_pr_item = mpr_rcv_get_lid_pair_path(sa, p_mpr,
+						      p_src_alias_guid,
+						      p_dest_alias_guid,
+						      src_lid_ho, dest_lid_ho,
+						      comp_mask, preference);
 
 		if (p_pr_item) {
 			cl_qlist_insert_tail(p_list, &p_pr_item->list_item);
@@ -1129,10 +1138,10 @@ static osm_mpr_item_t *mpr_rcv_get_apm_port_pair_paths(IN osm_sa_t * sa,
 						       IN const
 						       ib_multipath_rec_t *
 						       p_mpr,
-						       IN const osm_port_t *
-						       p_src_port,
-						       IN const osm_port_t *
-						       p_dest_port,
+						       IN const osm_alias_guid_t *
+						       p_src_alias_guid,
+						       IN const osm_alias_guid_t *
+						       p_dest_alias_guid,
 						       IN int base_offs,
 						       IN const ib_net64_t
 						       comp_mask,
@@ -1152,12 +1161,14 @@ static osm_mpr_item_t *mpr_rcv_get_apm_port_pair_paths(IN osm_sa_t * sa,
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "Src port 0x%016" PRIx64 ", "
 		"Dst port 0x%016" PRIx64 ", base offs %d\n",
-		cl_ntoh64(osm_port_get_guid(p_src_port)),
-		cl_ntoh64(osm_port_get_guid(p_dest_port)), base_offs);
+		cl_ntoh64(p_src_alias_guid->alias_guid),
+		cl_ntoh64(p_dest_alias_guid->alias_guid),
+		base_offs);
 
-	osm_port_get_lid_range_ho(p_src_port, &src_lid_min_ho, &src_lid_max_ho);
-	osm_port_get_lid_range_ho(p_dest_port, &dest_lid_min_ho,
-				  &dest_lid_max_ho);
+	osm_port_get_lid_range_ho(p_src_alias_guid->p_base_port,
+				  &src_lid_min_ho, &src_lid_max_ho);
+	osm_port_get_lid_range_ho(p_dest_alias_guid->p_base_port,
+				  &dest_lid_min_ho, &dest_lid_max_ho);
 
 	src_lid_ho = src_lid_min_ho;
 	dest_lid_ho = dest_lid_min_ho;
@@ -1180,10 +1191,11 @@ static osm_mpr_item_t *mpr_rcv_get_apm_port_pair_paths(IN osm_sa_t * sa,
 		/*
 		   These paths are "fully redundant"
 		 */
-		p_pr_item = mpr_rcv_get_lid_pair_path(sa, p_mpr, p_src_port,
-						      p_dest_port, src_lid_ho,
-						      dest_lid_ho, comp_mask,
-						      0);
+		p_pr_item = mpr_rcv_get_lid_pair_path(sa, p_mpr,
+						      p_src_alias_guid,
+						      p_dest_alias_guid,
+						      src_lid_ho, dest_lid_ho,
+						      comp_mask, 0);
 
 		if (p_pr_item) {
 			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
@@ -1205,9 +1217,9 @@ static osm_mpr_item_t *mpr_rcv_get_apm_port_pair_paths(IN osm_sa_t * sa,
 
 static ib_net16_t mpr_rcv_get_gids(IN osm_sa_t * sa, IN const ib_gid_t * gids,
 				   IN int ngids, IN int is_sgid,
-				   OUT osm_port_t ** pp_port)
+				   OUT osm_alias_guid_t ** pp_alias_guid)
 {
-	osm_port_t *p_port;
+	osm_alias_guid_t *p_alias_guid;
 	ib_net16_t ib_status = IB_SUCCESS;
 	int i;
 
@@ -1234,10 +1246,10 @@ static ib_net16_t mpr_rcv_get_gids(IN osm_sa_t * sa, IN const ib_gid_t * gids,
 			}
 		}
 
-		p_port =
-		    osm_get_port_by_guid(sa->p_subn,
-					 gids->unicast.interface_id);
-		if (!p_port) {
+		p_alias_guid =
+		    osm_get_alias_guid_by_guid(sa->p_subn,
+					       gids->unicast.interface_id);
+		if (!p_alias_guid) {
 			/*
 			   This 'error' is the client's fault (bad gid) so
 			   don't enter it as an error in our own log.
@@ -1251,7 +1263,7 @@ static ib_net16_t mpr_rcv_get_gids(IN osm_sa_t * sa, IN const ib_gid_t * gids,
 			goto Exit;
 		}
 
-		pp_port[i] = p_port;
+		pp_alias_guid[i] = p_alias_guid;
 	}
 
 Exit:
@@ -1262,7 +1274,7 @@ Exit:
 
 static ib_net16_t mpr_rcv_get_end_points(IN osm_sa_t * sa,
 					 IN const osm_madw_t * p_madw,
-					 OUT osm_port_t ** pp_ports,
+					 OUT osm_alias_guid_t ** pp_alias_guids,
 					 OUT int *nsrc, OUT int *ndest)
 {
 	const ib_multipath_rec_t *p_mpr;
@@ -1293,7 +1305,7 @@ static ib_net16_t mpr_rcv_get_end_points(IN osm_sa_t * sa,
 		*nsrc = p_mpr->sgid_count;
 		if (*nsrc > IB_MULTIPATH_MAX_GIDS)
 			*nsrc = IB_MULTIPATH_MAX_GIDS;
-		sa_status = mpr_rcv_get_gids(sa, gids, *nsrc, 1, pp_ports);
+		sa_status = mpr_rcv_get_gids(sa, gids, *nsrc, 1, pp_alias_guids);
 		if (sa_status != IB_SUCCESS)
 			goto Exit;
 	}
@@ -1304,7 +1316,7 @@ static ib_net16_t mpr_rcv_get_end_points(IN osm_sa_t * sa,
 			*ndest = IB_MULTIPATH_MAX_GIDS - *nsrc;
 		sa_status =
 		    mpr_rcv_get_gids(sa, gids + *nsrc, *ndest, 0,
-				     pp_ports + *nsrc);
+				     pp_alias_guids + *nsrc);
 	}
 
 Exit:
@@ -1318,11 +1330,11 @@ Exit:
 static void mpr_rcv_get_apm_paths(IN osm_sa_t * sa,
 				  IN const ib_multipath_rec_t * p_mpr,
 				  IN const osm_port_t * p_req_port,
-				  IN osm_port_t ** _pp_ports,
+				  IN osm_alias_guid_t ** _pp_alias_guids,
 				  IN const ib_net64_t comp_mask,
 				  IN cl_qlist_t * p_list)
 {
-	osm_port_t *pp_ports[4];
+	osm_alias_guid_t *pp_alias_guids[4];
 	osm_mpr_item_t *matrix[2][2];
 	int base_offs, src_lid_ho, dest_lid_ho;
 	int sumA, sumB, minA, minB;
@@ -1343,40 +1355,46 @@ static void mpr_rcv_get_apm_paths(IN osm_sa_t * sa,
 	 * Note that the diagonals on a Clos have the same number of hops, so it doesn't
 	 * really matter which diagonal we use.
 	 */
-	if (_pp_ports[0]->guid < _pp_ports[1]->guid) {
-		pp_ports[0] = _pp_ports[0];
-		pp_ports[1] = _pp_ports[1];
+	if (_pp_alias_guids[0]->p_base_port->guid <
+	    _pp_alias_guids[1]->p_base_port->guid) {
+		pp_alias_guids[0] = _pp_alias_guids[0];
+		pp_alias_guids[1] = _pp_alias_guids[1];
 	} else {
-		pp_ports[0] = _pp_ports[1];
-		pp_ports[1] = _pp_ports[0];
+		pp_alias_guids[0] = _pp_alias_guids[1];
+		pp_alias_guids[1] = _pp_alias_guids[0];
 	}
-	if (_pp_ports[2]->guid < _pp_ports[3]->guid) {
-		pp_ports[2] = _pp_ports[2];
-		pp_ports[3] = _pp_ports[3];
+	if (_pp_alias_guids[2]->p_base_port->guid <
+	    _pp_alias_guids[3]->p_base_port->guid) {
+		pp_alias_guids[2] = _pp_alias_guids[2];
+		pp_alias_guids[3] = _pp_alias_guids[3];
 	} else {
-		pp_ports[2] = _pp_ports[3];
-		pp_ports[3] = _pp_ports[2];
+		pp_alias_guids[2] = _pp_alias_guids[3];
+		pp_alias_guids[3] = _pp_alias_guids[2];
 	}
 
-	src_lid_ho = osm_port_get_base_lid(pp_ports[0]);
-	dest_lid_ho = osm_port_get_base_lid(pp_ports[2]);
+	src_lid_ho = osm_port_get_base_lid(pp_alias_guids[0]->p_base_port);
+	dest_lid_ho = osm_port_get_base_lid(pp_alias_guids[2]->p_base_port);
 
 	base_offs = src_lid_ho < dest_lid_ho ?
 	    hash_lids(src_lid_ho, dest_lid_ho, sa->p_subn->opt.lmc) :
 	    hash_lids(dest_lid_ho, src_lid_ho, sa->p_subn->opt.lmc);
 
 	matrix[0][0] =
-	    mpr_rcv_get_apm_port_pair_paths(sa, p_mpr, pp_ports[0], pp_ports[2],
-					    base_offs, comp_mask, p_list);
+	    mpr_rcv_get_apm_port_pair_paths(sa, p_mpr, pp_alias_guids[0],
+					    pp_alias_guids[2], base_offs,
+					    comp_mask, p_list);
 	matrix[0][1] =
-	    mpr_rcv_get_apm_port_pair_paths(sa, p_mpr, pp_ports[0], pp_ports[3],
-					    base_offs, comp_mask, p_list);
+	    mpr_rcv_get_apm_port_pair_paths(sa, p_mpr, pp_alias_guids[0],
+					    pp_alias_guids[3], base_offs,
+					    comp_mask, p_list);
 	matrix[1][0] =
-	    mpr_rcv_get_apm_port_pair_paths(sa, p_mpr, pp_ports[1], pp_ports[2],
-					    base_offs + 1, comp_mask, p_list);
+	    mpr_rcv_get_apm_port_pair_paths(sa, p_mpr, pp_alias_guids[1],
+					    pp_alias_guids[2], base_offs + 1,
+					    comp_mask, p_list);
 	matrix[1][1] =
-	    mpr_rcv_get_apm_port_pair_paths(sa, p_mpr, pp_ports[1], pp_ports[3],
-					    base_offs + 1, comp_mask, p_list);
+	    mpr_rcv_get_apm_port_pair_paths(sa, p_mpr, pp_alias_guids[1],
+					    pp_alias_guids[3], base_offs + 1,
+					    comp_mask, p_list);
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "APM matrix:\n"
 		"\t{0,0} 0x%X->0x%X (%d)\t| {0,1} 0x%X->0x%X (%d)\n"
@@ -1431,12 +1449,13 @@ static void mpr_rcv_get_apm_paths(IN osm_sa_t * sa,
 static void mpr_rcv_process_pairs(IN osm_sa_t * sa,
 				  IN const ib_multipath_rec_t * p_mpr,
 				  IN osm_port_t * p_req_port,
-				  IN osm_port_t ** pp_ports, IN const int nsrc,
-				  IN int ndest, IN ib_net64_t comp_mask,
+				  IN osm_alias_guid_t ** pp_alias_guids,
+				  IN const int nsrc, IN int ndest,
+				  IN ib_net64_t comp_mask,
 				  IN cl_qlist_t * p_list)
 {
-	osm_port_t **pp_src_port, **pp_es;
-	osm_port_t **pp_dest_port, **pp_ed;
+	osm_alias_guid_t **pp_src_alias_guid, **pp_es;
+	osm_alias_guid_t **pp_dest_alias_guid, **pp_ed;
 	uint32_t max_paths, num_paths, total_paths = 0;
 
 	OSM_LOG_ENTER(sa->p_log);
@@ -1446,14 +1465,14 @@ static void mpr_rcv_process_pairs(IN osm_sa_t * sa,
 	else
 		max_paths = OSM_SA_MPR_MAX_NUM_PATH;
 
-	for (pp_src_port = pp_ports, pp_es = pp_ports + nsrc;
-	     pp_src_port < pp_es; pp_src_port++) {
-		for (pp_dest_port = pp_es, pp_ed = pp_es + ndest;
-		     pp_dest_port < pp_ed; pp_dest_port++) {
+	for (pp_src_alias_guid = pp_alias_guids, pp_es = pp_alias_guids + nsrc;
+	     pp_src_alias_guid < pp_es; pp_src_alias_guid++) {
+		for (pp_dest_alias_guid = pp_es, pp_ed = pp_es + ndest;
+		     pp_dest_alias_guid < pp_ed; pp_dest_alias_guid++) {
 			num_paths =
 			    mpr_rcv_get_port_pair_paths(sa, p_mpr, p_req_port,
-							*pp_src_port,
-							*pp_dest_port,
+							*pp_src_alias_guid,
+							*pp_dest_alias_guid,
 							max_paths - total_paths,
 							comp_mask, p_list);
 			total_paths += num_paths;
@@ -1477,7 +1496,7 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 	const ib_multipath_rec_t *p_mpr;
 	ib_sa_mad_t *p_sa_mad;
 	osm_port_t *requester_port;
-	osm_port_t *pp_ports[IB_MULTIPATH_MAX_GIDS];
+	osm_alias_guid_t *pp_alias_guids[IB_MULTIPATH_MAX_GIDS];
 	cl_qlist_t pr_list;
 	ib_net16_t sa_status;
 	int nsrc, ndest;
@@ -1528,7 +1547,8 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 	 */
 	cl_plock_acquire(sa->p_lock);
 
-	sa_status = mpr_rcv_get_end_points(sa, p_madw, pp_ports, &nsrc, &ndest);
+	sa_status = mpr_rcv_get_end_points(sa, p_madw, pp_alias_guids,
+					   &nsrc, &ndest);
 
 	if (sa_status != IB_SA_MAD_STATUS_SUCCESS || !nsrc || !ndest) {
 		if (sa_status == IB_SA_MAD_STATUS_SUCCESS && (!nsrc || !ndest))
@@ -1546,10 +1566,10 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 
 	/* APM request */
 	if (nsrc == 2 && ndest == 2 && (p_mpr->num_path & 0x7F) == 2)
-		mpr_rcv_get_apm_paths(sa, p_mpr, requester_port, pp_ports,
+		mpr_rcv_get_apm_paths(sa, p_mpr, requester_port, pp_alias_guids,
 				      p_sa_mad->comp_mask, &pr_list);
 	else
-		mpr_rcv_process_pairs(sa, p_mpr, requester_port, pp_ports,
+		mpr_rcv_process_pairs(sa, p_mpr, requester_port, pp_alias_guids,
 				      nsrc, ndest, p_sa_mad->comp_mask,
 				      &pr_list);
 
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
