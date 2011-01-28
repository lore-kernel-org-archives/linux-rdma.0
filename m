From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V2] Add node/port/qos information to some error messages
Date: Thu, 27 Jan 2011 19:21:39 -0800
Message-ID: <20110127192139.feb18627.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashakvolt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 25 Jan 2011 17:09:04 -0800
Subject: [PATCH] Add node/port/qos information to some error messages

V2: further cleanup of text
    include MultiPathRecord messages
    add qos information where appropriate

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 opensm/opensm/osm_sa_multipath_record.c |  129 +++++++++++++++++++++------
 opensm/opensm/osm_sa_path_record.c      |  148 ++++++++++++++++++++++++-------
 opensm/opensm/osm_ucast_mgr.c           |    8 +-
 3 files changed, 220 insertions(+), 65 deletions(-)

diff --git a/opensm/opensm/osm_sa_multipath_record.c b/opensm/opensm/osm_sa_multipath_record.c
index 18a0122..208dc31 100644
--- a/opensm/opensm/osm_sa_multipath_record.c
+++ b/opensm/opensm/osm_sa_multipath_record.c
@@ -225,8 +225,9 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		p_physp = osm_switch_get_route_by_lid(p_node->sw, dest_lid);
 		if (p_physp == 0) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4514: "
-				"Can't find routing to LID %u from switch for GUID 0x%016"
-				PRIx64 "\n", dest_lid_ho,
+				"Can't find routing to LID %u on switch %s "
+				"(GUID 0x%016"PRIx64")\n", dest_lid_ho,
+				p_node->print_desc,
 				cl_ntoh64(osm_node_get_node_guid(p_node)));
 			status = IB_NOT_FOUND;
 			goto Exit;
@@ -269,8 +270,9 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 
 		if (p_dest_physp == 0) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4515: "
-				"Can't find routing to LID %u from switch for GUID 0x%016"
-				PRIx64 "\n", dest_lid_ho,
+				"Can't find routing to LID %u on switch %s "
+				"(GUID 0x%016"PRIx64")\n", dest_lid_ho,
+				p_node->print_desc,
 				cl_ntoh64(osm_node_get_node_guid(p_node)));
 			status = IB_NOT_FOUND;
 			goto Exit;
@@ -284,14 +286,19 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 
 	while (p_physp != p_dest_physp) {
 
+		int tmp_pnum = p_physp->port_num;
 		p_node = osm_physp_get_node_ptr(p_physp);
 		p_physp = osm_physp_get_remote(p_physp);
 
 		if (p_physp == 0) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4505: "
-				"Can't find remote phys port when routing to LID %u from node GUID 0x%016"
-				PRIx64 "\n", dest_lid_ho,
-				cl_ntoh64(osm_node_get_node_guid(p_node)));
+				"Can't find remote phys port of %s (GUID "
+				"0x%016"PRIx64") port %d "
+				"while routing to LID %u",
+				p_node->print_desc,
+				cl_ntoh64(osm_node_get_node_guid(p_node)),
+				tmp_pnum,
+				dest_lid_ho);
 			status = IB_ERROR;
 			goto Exit;
 		}
@@ -330,7 +337,18 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 			   the destination by now!
 			 */
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4503: "
-				"Internal error, bad path\n");
+				"Internal error, bad path while routing "
+				"from %s (GUID: 0x%016"PRIx64") port %d "
+				"to %s (GUID: 0x%016"PRIx64") port %d; "
+				"ended at %s port %d\n",
+				p_src_port->p_node->print_desc,
+				cl_ntoh64(p_src_port->p_node->node_info.node_guid),
+				p_src_port->p_physp->port_num,
+				p_dest_port->p_node->print_desc,
+				cl_ntoh64(p_dest_port->p_node->node_info.node_guid),
+				p_dest_port->p_physp->port_num,
+				p_node->print_desc,
+				p_physp->port_num);
 			status = IB_ERROR;
 			goto Exit;
 		}
@@ -352,9 +370,11 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		p_physp = osm_switch_get_route_by_lid(p_node->sw, dest_lid);
 		if (p_physp == 0) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4516: "
-				"Dead end on path to LID %u from switch for GUID 0x%016"
-				PRIx64 "\n", dest_lid_ho,
-				cl_ntoh64(osm_node_get_node_guid(p_node)));
+				"Dead end path on switch "
+				"%s (GUID: 0x%016"PRIx64") to LID %u\n",
+				p_node->print_desc,
+				cl_ntoh64(osm_node_get_node_guid(p_node)),
+				dest_lid_ho);
 			status = IB_ERROR;
 			goto Exit;
 		}
@@ -597,19 +617,36 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		if (!osm_physp_share_this_pkey
 		    (p_src_physp, p_dest_physp, required_pkey)) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4518: "
-				"Ports do not share specified PKey 0x%04x\n"
-				"\t\tsrc %" PRIx64 " dst %" PRIx64 "\n",
-				cl_ntoh16(required_pkey),
+				"Ports src 0x%016"PRIx64" (%s port %d) "
+				"and dst 0x%016"PRIx64" (%s port %d) "
+				"do not share the specified PKey 0x%04x\n",
 				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
+				p_src_physp->p_node->print_desc,
+				p_src_physp->port_num,
 				cl_ntoh64(osm_physp_get_port_guid
-					  (p_dest_physp)));
+					  (p_dest_physp)),
+				p_dest_physp->p_node->print_desc,
+				p_dest_physp->port_num,
+				cl_ntoh16(required_pkey));
 			status = IB_NOT_FOUND;
 			goto Exit;
 		}
 		if (p_qos_level && p_qos_level->pkey_range_len &&
 		    !osm_qos_level_has_pkey(p_qos_level, required_pkey)) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 451C: "
-				"Ports do not share PKeys defined by QoS level\n");
+				"Ports src 0x%016"PRIx64" (%s port %d) "
+				"and dst 0x%016"PRIx64" (%s port %d) "
+				"do not share specified PKey (0x%04x) as "
+				"defined by QoS level \"%s\"\n",
+				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
+				p_src_physp->p_node->print_desc,
+				p_src_physp->port_num,
+				cl_ntoh64(osm_physp_get_port_guid
+					  (p_dest_physp)),
+				p_dest_physp->p_node->print_desc,
+				p_dest_physp->port_num,
+				cl_ntoh16(required_pkey),
+				p_qos_level->name);
 			status = IB_NOT_FOUND;
 			goto Exit;
 		}
@@ -624,7 +661,18 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 							      p_dest_physp);
 		if (!required_pkey) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 451D: "
-				"Ports do not share PKeys defined by QoS level\n");
+				"Ports src 0x%016"PRIx64" (%s port %d) "
+				"and dst 0x%016"PRIx64" (%s port %d) "
+				"do not share a PKey as defined by QoS "
+				"level \"%s\"\n",
+				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
+				p_src_physp->p_node->print_desc,
+				p_src_physp->port_num,
+				cl_ntoh64(osm_physp_get_port_guid
+					  (p_dest_physp)),
+				p_dest_physp->p_node->print_desc,
+				p_dest_physp->port_num,
+				p_qos_level->name);
 			status = IB_NOT_FOUND;
 			goto Exit;
 		}
@@ -638,11 +686,16 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		    osm_physp_find_common_pkey(p_src_physp, p_dest_physp);
 		if (!required_pkey) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4519: "
-				"Ports do not have any shared PKeys\n"
-				"\t\tsrc %" PRIx64 " dst %" PRIx64 "\n",
-				cl_ntoh64(osm_physp_get_port_guid(p_physp)),
+				"Ports src 0x%016"PRIx64" (%s port %d) "
+				"and dst 0x%016"PRIx64" (%s port %d) "
+				"do not have any shared PKeys\n",
+				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
+				p_src_physp->p_node->print_desc,
+				p_src_physp->port_num,
 				cl_ntoh64(osm_physp_get_port_guid
-					  (p_dest_physp)));
+					  (p_dest_physp)),
+				p_dest_physp->p_node->print_desc,
+				p_dest_physp->port_num);
 			status = IB_NOT_FOUND;
 			goto Exit;
 		}
@@ -671,9 +724,15 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		if (p_qos_level && p_qos_level->sl_set &&
 		    p_qos_level->sl != required_sl) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 451E: "
-				"QoS constraints: required MultiPathRecord SL (%u) "
-				"doesn't match QoS policy SL (%u)\n",
-				required_sl, p_qos_level->sl);
+				"QoS constraints: required MultiPathRecord SL "
+				"(%u) doesn't match QoS policy \"%s\" SL (%u) "
+				"[%s port %d <-> %s port %d]\n", required_sl,
+				p_qos_level->name,
+				p_qos_level->sl,
+				p_src_port->p_node->print_desc,
+				p_src_port->p_physp->port_num,
+				p_dest_port->p_node->print_desc,
+				p_dest_port->p_physp->port_num);
 			status = IB_NOT_FOUND;
 			goto Exit;
 		}
@@ -703,8 +762,14 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 			/* this may be possible when pkey tables are created somehow in
 			   previous runs or things are going wrong here */
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 451A: "
-				"No partition found for PKey 0x%04x - using default SL %d\n",
-				cl_ntoh16(required_pkey), required_sl);
+				"No partition found for PKey 0x%04x - "
+				"using default SL %d "
+				"[%s port %d <-> %s port %d]\n",
+				cl_ntoh16(required_pkey), required_sl,
+				p_src_port->p_node->print_desc,
+				p_src_port->p_physp->port_num,
+				p_dest_port->p_node->print_desc,
+				p_dest_port->p_physp->port_num);
 		} else
 			required_sl = p_prtn->sl;
 
@@ -722,7 +787,13 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 
 	if (sa->p_subn->opt.qos && !(valid_sl_mask & (1 << required_sl))) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 451F: "
-			"Selected SL (%u) leads to VL15\n", required_sl);
+			"Selected SL (%u) leads to VL15 "
+			"[%s port %d <-> %s port %d]\n",
+			required_sl,
+			p_src_port->p_node->print_desc,
+			p_src_port->p_physp->port_num,
+			p_dest_port->p_node->print_desc,
+			p_dest_port->p_physp->port_num);
 		status = IB_NOT_FOUND;
 		goto Exit;
 	}
@@ -1462,8 +1533,8 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 	if (sa_status != IB_SA_MAD_STATUS_SUCCESS || !nsrc || !ndest) {
 		if (sa_status == IB_SA_MAD_STATUS_SUCCESS && (!nsrc || !ndest))
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4512: "
-				"mpr_rcv_get_end_points failed, not enough GIDs "
-				"(nsrc %d ndest %d)\n", nsrc, ndest);
+				"mpr_rcv_get_end_points failed, # GIDs found; "
+				"src %d; dest %d)\n", nsrc, ndest);
 		cl_plock_release(sa->p_lock);
 		if (sa_status == IB_SA_MAD_STATUS_SUCCESS)
 			osm_sa_send_error(sa, p_madw,
diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index 2897c7b..0a58b22 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -230,8 +230,9 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		p_physp = osm_switch_get_route_by_lid(p_node->sw, dest_lid);
 		if (p_physp == 0) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F02: "
-				"Cannot find routing to LID %u from switch for GUID 0x%016"
-				PRIx64 "\n", dest_lid_ho,
+				"Cannot find routing to LID %u on switch "
+				"%s (GUID: 0x%016" PRIx64 ")\n", dest_lid_ho,
+				p_node->print_desc,
 				cl_ntoh64(osm_node_get_node_guid(p_node)));
 			status = IB_NOT_FOUND;
 			goto Exit;
@@ -273,8 +274,9 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 
 		if (p_dest_physp == 0) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F03: "
-				"Cannot find routing to LID %u from switch for GUID 0x%016"
-				PRIx64 "\n", dest_lid_ho,
+				"Cannot find routing to LID %u on switch "
+				"%s (GUID: 0x%016" PRIx64 ")\n", dest_lid_ho,
+				p_node->print_desc,
 				cl_ntoh64(osm_node_get_node_guid(p_node)));
 			status = IB_NOT_FOUND;
 			goto Exit;
@@ -288,14 +290,19 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 
 	while (p_physp != p_dest_physp) {
 
+		int tmp_pnum = p_physp->port_num;
 		p_node = osm_physp_get_node_ptr(p_physp);
 		p_physp = osm_physp_get_remote(p_physp);
 
 		if (p_physp == 0) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F05: "
-				"Cannot find remote phys port when routing to LID %u from node GUID 0x%016"
-				PRIx64 "\n", dest_lid_ho,
-				cl_ntoh64(osm_node_get_node_guid(p_node)));
+				"Can't find remote phys port of %s (GUID: "
+				"0x%016"PRIx64") port %d "
+				"while routing to LID %u",
+				p_node->print_desc,
+				cl_ntoh64(osm_node_get_node_guid(p_node)),
+				tmp_pnum,
+				dest_lid_ho);
 			status = IB_ERROR;
 			goto Exit;
 		}
@@ -317,7 +324,18 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 			   the destination by now!
 			 */
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F06: "
-				"Internal error, bad path\n");
+				"Internal error, bad path while routing "
+				"%s (GUID: 0x%016"PRIx64") port %d to "
+				"%s (GUID: 0x%016"PRIx64") port %d; "
+				"ended at %s port %d\n",
+				p_src_port->p_node->print_desc,
+				cl_ntoh64(p_src_port->p_node->node_info.node_guid),
+				p_src_port->p_physp->port_num,
+				p_dest_port->p_node->print_desc,
+				cl_ntoh64(p_dest_port->p_node->node_info.node_guid),
+				p_dest_port->p_physp->port_num,
+				p_node->print_desc,
+				p_physp->port_num);
 			status = IB_ERROR;
 			goto Exit;
 		}
@@ -339,9 +357,11 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		p_physp = osm_switch_get_route_by_lid(p_node->sw, dest_lid);
 		if (p_physp == 0) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F07: "
-				"Dead end on path to LID %u from switch for GUID 0x%016"
-				PRIx64 "\n", dest_lid_ho,
-				cl_ntoh64(osm_node_get_node_guid(p_node)));
+				"Dead end path on switch "
+				"%s (GUID: 0x%016"PRIx64") to LID %u\n",
+				p_node->print_desc,
+				cl_ntoh64(osm_node_get_node_guid(p_node)),
+				dest_lid_ho);
 			status = IB_ERROR;
 			goto Exit;
 		}
@@ -378,14 +398,18 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		hops++;
 		if (hops > MAX_HOPS) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F25: "
-				"Path from GUID 0x%016" PRIx64 " (%s) to"
-				" lid %u GUID 0x%016" PRIx64 " (%s) needs"
-				" more than %d hops, max %d hops allowed\n",
+				"Path from GUID 0x%016" PRIx64 " (%s port %d) "
+				"to lid %u GUID 0x%016" PRIx64 " (%s port %d) "
+				"needs more than %d hops, max %d hops allowed\n",
 				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
-				p_src_physp->p_node->print_desc, dest_lid_ho,
+				p_src_physp->p_node->print_desc,
+				p_src_physp->port_num,
+				dest_lid_ho,
 				cl_ntoh64(osm_physp_get_port_guid
 					  (p_dest_physp)),
-				p_dest_physp->p_node->print_desc, hops,
+				p_dest_physp->p_node->print_desc,
+				p_dest_physp->port_num,
+				hops,
 				MAX_HOPS);
 			status = IB_NOT_FOUND;
 			goto Exit;
@@ -602,18 +626,35 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		pkey = p_pr->pkey;
 		if (!osm_physp_share_this_pkey(p_src_physp, p_dest_physp, pkey)) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1A: "
-				"Ports 0x%016" PRIx64 " 0x%016" PRIx64
+				"Ports 0x%016" PRIx64 " (%s port %d) and "
+				"0x%016" PRIx64 " (%s port %d) "
 				" do not share specified PKey 0x%04x\n",
 				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
+				p_src_physp->p_node->print_desc,
+				p_src_physp->port_num,
 				cl_ntoh64(osm_physp_get_port_guid
-					  (p_dest_physp)), cl_ntoh16(pkey));
+					  (p_dest_physp)),
+				p_dest_physp->p_node->print_desc,
+				p_dest_physp->port_num,
+				cl_ntoh16(pkey));
 			status = IB_NOT_FOUND;
 			goto Exit;
 		}
 		if (p_qos_level && p_qos_level->pkey_range_len &&
 		    !osm_qos_level_has_pkey(p_qos_level, pkey)) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1D: "
-				"Ports do not share PKeys defined by QoS level\n");
+				"Ports 0x%016" PRIx64 " (%s port %d) and "
+				"0x%016"PRIx64" (%s port %d) "
+				"do not share PKeys defined by QoS level "
+				"\"%s\"\n",
+				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
+				p_src_physp->p_node->print_desc,
+				p_src_port->p_physp->port_num,
+				cl_ntoh64(osm_physp_get_port_guid
+					  (p_dest_physp)),
+				p_dest_physp->p_node->print_desc,
+				p_dest_port->p_physp->port_num,
+				p_qos_level->name);
 			status = IB_NOT_FOUND;
 			goto Exit;
 		}
@@ -627,11 +668,15 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 						     p_src_physp, p_dest_physp);
 		if (!pkey) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1E: "
-				"Ports 0x%016" PRIx64 " 0x%016" PRIx64
-				" do not share PKeys defined by QoS level\n",
+				"Ports 0x%016" PRIx64 " (%s) and "
+				"0x%016" PRIx64 " (%s) do not share "
+				"PKeys defined by QoS level \"%s\"\n",
 				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
+				p_src_physp->p_node->print_desc,
 				cl_ntoh64(osm_physp_get_port_guid
-					  (p_dest_physp)));
+					  (p_dest_physp)),
+				p_dest_physp->p_node->print_desc,
+				p_qos_level->name);
 			status = IB_NOT_FOUND;
 			goto Exit;
 		}
@@ -643,11 +688,16 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		pkey = osm_physp_find_common_pkey(p_src_physp, p_dest_physp);
 		if (!pkey) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1B: "
-				"Ports 0x%016" PRIx64 " 0x%016" PRIx64
-				" do not have any shared PKeys\n",
+				"Ports src 0x%016"PRIx64" (%s port %d) and "
+				"dst 0x%016"PRIx64" (%s port %d) do not have "
+				"any shared PKeys\n",
 				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
+				p_src_physp->p_node->print_desc,
+				p_src_physp->port_num,
 				cl_ntoh64(osm_physp_get_port_guid
-					  (p_dest_physp)));
+					  (p_dest_physp)),
+				p_dest_physp->p_node->print_desc,
+				p_dest_physp->port_num);
 			status = IB_NOT_FOUND;
 			goto Exit;
 		}
@@ -679,8 +729,14 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		    && (p_qos_level->sl != sl)) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1F: "
 				"QoS constraints: required PathRecord SL (%u) "
-				"doesn't match QoS policy SL (%u)\n", sl,
-				p_qos_level->sl);
+				"doesn't match QoS policy \"%s\" SL (%u) "
+				"[%s port %d <-> %s port %d]\n", sl,
+				p_qos_level->name,
+				p_qos_level->sl,
+				p_src_port->p_node->print_desc,
+				p_src_port->p_physp->port_num,
+				p_dest_port->p_node->print_desc,
+				p_dest_port->p_physp->port_num);
 			status = IB_NOT_FOUND;
 			goto Exit;
 		}
@@ -689,7 +745,15 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		    && osm_get_lash_sl(p_osm, p_src_port, p_dest_port) != sl) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F23: "
 				"Required PathRecord SL (%u) doesn't "
-				"match LASH SL\n", sl);
+				"match LASH SL (%u) "
+				"[%s port %d <-> %s port %d]\n",
+				sl,
+				osm_get_lash_sl(p_osm, p_src_port,
+						p_dest_port),
+				p_src_port->p_node->print_desc,
+				p_src_port->p_physp->port_num,
+				p_dest_port->p_node->print_desc,
+				p_dest_port->p_physp->port_num);
 			status = IB_NOT_FOUND;
 			goto Exit;
 		}
@@ -722,8 +786,14 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 			/* this may be possible when pkey tables are created somehow in
 			   previous runs or things are going wrong here */
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1C: "
-				"No partition found for PKey 0x%04x - using default SL %d\n",
-				cl_ntoh16(pkey), sl);
+				"No partition found for PKey 0x%04x - "
+				"using default SL %d "
+				"[%s port %d <-> %s port %d]\n",
+				cl_ntoh16(pkey), sl,
+				p_src_port->p_node->print_desc,
+				p_src_port->p_physp->port_num,
+				p_dest_port->p_node->print_desc,
+				p_dest_port->p_physp->port_num);
 		} else
 			sl = p_prtn->sl;
 	} else if (sa->p_subn->opt.qos) {
@@ -740,7 +810,13 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 
 	if (sa->p_subn->opt.qos && !(valid_sl_mask & (1 << sl))) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F24: "
-			"Selected SL (%u) leads to VL15\n", sl);
+			"Selected SL (%u) leads to VL15 "
+			"[%s port %d <-> %s port %d]\n",
+			sl,
+			p_src_port->p_node->print_desc,
+			p_src_port->p_physp->port_num,
+			p_dest_port->p_node->print_desc,
+			p_dest_port->p_physp->port_num);
 		status = IB_NOT_FOUND;
 		goto Exit;
 	}
@@ -1004,13 +1080,19 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
 
 	if (src_lid_min_ho == 0) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F20:"
-			"Obtained source LID of 0. No such LID possible\n");
+			"Obtained source LID of 0. No such LID possible "
+			"(%s port %d)\n",
+			p_src_port->p_node->print_desc,
+			p_src_port->p_physp->port_num);
 		goto Exit;
 	}
 
 	if (dest_lid_min_ho == 0) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F21:"
-			"Obtained destination LID of 0. No such LID possible\n");
+			"Obtained destination LID of 0. No such LID possible "
+			"(%s port %d)\n",
+			p_dest_port->p_node->print_desc,
+			p_dest_port->p_physp->port_num);
 		goto Exit;
 	}
 
diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
index 37b8741..f295531 100644
--- a/opensm/opensm/osm_ucast_mgr.c
+++ b/opensm/opensm/osm_ucast_mgr.c
@@ -217,9 +217,11 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
 	 * the initialization. Don't handle this port. */
 	if (min_lid_ho == 0 || max_lid_ho == 0) {
 		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR, "ERR 3A04: "
-			"Port 0x%" PRIx64 " has LID 0. An initialization "
-			"error occurred. Ignoring port\n",
-			cl_ntoh64(osm_port_get_guid(p_port)));
+			"Port 0x%"PRIx64" (%s port %d) has LID 0. An "
+			"initialization error occurred. Ignoring port\n",
+			cl_ntoh64(osm_port_get_guid(p_port)),
+			p_port->p_node->print_desc,
+			p_port->p_physp->port_num);
 		goto Exit;
 	}
 
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
