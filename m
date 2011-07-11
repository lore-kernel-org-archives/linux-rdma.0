From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/3] Remove unused variables from code
Date: Mon, 11 Jul 2011 20:46:52 +0300
Message-ID: <20110711174651.GE2084@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Unused variables may cause unused-but-set warning

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_inform.c             |    2 --
 opensm/osm_lid_mgr.c            |    5 +++--
 opensm/osm_mesh.c               |    2 --
 opensm/osm_sa.c                 |    3 +--
 opensm/osm_sa_informinfo.c      |    2 --
 opensm/osm_sa_link_record.c     |    4 ++--
 opensm/osm_sa_mcmember_record.c |    3 ---
 opensm/osm_sa_pkey_record.c     |    2 --
 opensm/osm_sa_portinfo_record.c |    3 ---
 opensm/osm_sa_service_record.c  |    3 ---
 opensm/osm_sa_slvl_record.c     |    2 --
 opensm/osm_sa_vlarb_record.c    |    2 --
 opensm/osm_torus.c              |    4 +---
 opensm/osm_ucast_file.c         |    2 --
 osmtest/osmt_slvl_vl_arb.c      |   32 ++++++++++++++++----------------
 15 files changed, 23 insertions(+), 48 deletions(-)

diff --git a/opensm/osm_inform.c b/opensm/osm_inform.c
index 8af8616..fd7caa2 100644
--- a/opensm/osm_inform.c
+++ b/opensm/osm_inform.c
@@ -451,7 +451,6 @@ static void match_notice_to_inf_rec(IN cl_list_item_t * p_list_item,
 	ib_mad_notice_attr_t *p_ntc = p_infr_match->p_ntc;
 	osm_infr_t *p_infr_rec = (osm_infr_t *) p_list_item;
 	ib_inform_info_t *p_ii = &(p_infr_rec->inform_record.inform_info);
-	cl_status_t status = CL_NOT_FOUND;
 	osm_log_t *p_log = p_infr_rec->sa->p_log;
 
 	OSM_LOG_ENTER(p_log);
@@ -559,7 +558,6 @@ static void match_notice_to_inf_rec(IN cl_list_item_t * p_list_item,
 	/* send the report to the address provided in the inform record */
 	OSM_LOG(p_log, OSM_LOG_DEBUG, "MATCH! Sending Report...\n");
 	send_report(p_infr_rec, p_ntc);
-	status = CL_SUCCESS;
 
 Exit:
 	OSM_LOG_EXIT(p_log);
diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index 5d0247a..015e65a 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -1183,8 +1183,9 @@ int osm_lid_mgr_process_subnet(IN osm_lid_mgr_t * p_mgr)
 		   to look for any field change and will only send an updated
 		   if required */
 		OSM_LOG(p_mgr->p_log, OSM_LOG_VERBOSE,
-			"Assigned port 0x%016" PRIx64 ", LID [%u,%u]\n",
-			cl_ntoh64(port_guid), min_lid_ho, max_lid_ho);
+			"Assigned port 0x%016" PRIx64 ", %s LID [%u,%u]\n",
+			cl_ntoh64(port_guid), lid_changed ? "new" : "",
+			min_lid_ho, max_lid_ho);
 
 		/* the proc returns the fact it sent a set port info */
 		if (lid_mgr_set_physp_pi(p_mgr, p_port, p_port->p_physp,
diff --git a/opensm/osm_mesh.c b/opensm/osm_mesh.c
index d156b7a..aa9b682 100644
--- a/opensm/osm_mesh.c
+++ b/opensm/osm_mesh.c
@@ -1634,7 +1634,6 @@ int osm_do_mesh_analysis(lash_t *p_lash)
 {
 	osm_log_t *p_log = &p_lash->p_osm->log;
 	mesh_t *mesh;
-	int max_class = -1;
 	int max_class_num = 0;
 	int max_class_type = -1;
 	int i;
@@ -1667,7 +1666,6 @@ int osm_do_mesh_analysis(lash_t *p_lash)
 			i, mesh->class_count[i],
 			p_lash->switches[mesh->class_type[i]]->node->type);
 		if (mesh->class_count[i] > max_class_num) {
-			max_class = i;
 			max_class_num = mesh->class_count[i];
 			max_class_type = mesh->class_type[i];
 		}
diff --git a/opensm/osm_sa.c b/opensm/osm_sa.c
index bbd1a56..cdb8999 100644
--- a/opensm/osm_sa.c
+++ b/opensm/osm_sa.c
@@ -101,13 +101,12 @@ void osm_sa_construct(IN osm_sa_t * p_sa)
 
 void osm_sa_shutdown(IN osm_sa_t * p_sa)
 {
-	ib_api_status_t status;
 	OSM_LOG_ENTER(p_sa->p_log);
 
 	cl_timer_stop(&p_sa->sr_timer);
 
 	/* unbind from the mad service */
-	status = osm_sa_mad_ctrl_unbind(&p_sa->mad_ctrl);
+	osm_sa_mad_ctrl_unbind(&p_sa->mad_ctrl);
 
 	/* remove any registered dispatcher message */
 	cl_disp_unregister(p_sa->nr_disp_h);
diff --git a/opensm/osm_sa_informinfo.c b/opensm/osm_sa_informinfo.c
index be7aba7..f775d36 100644
--- a/opensm/osm_sa_informinfo.c
+++ b/opensm/osm_sa_informinfo.c
@@ -235,7 +235,6 @@ static void sa_inform_info_rec_by_comp_mask(IN osm_sa_t * sa,
 					    IN const osm_infr_t * p_infr,
 					    osm_iir_search_ctxt_t * p_ctxt)
 {
-	const ib_inform_info_record_t *p_rcvd_rec = NULL;
 	ib_net64_t comp_mask;
 	ib_net64_t portguid;
 	osm_port_t *p_subscriber_port;
@@ -245,7 +244,6 @@ static void sa_inform_info_rec_by_comp_mask(IN osm_sa_t * sa,
 
 	OSM_LOG_ENTER(sa->p_log);
 
-	p_rcvd_rec = p_ctxt->p_rcvd_rec;
 	comp_mask = p_ctxt->comp_mask;
 	p_req_physp = p_ctxt->p_req_physp;
 
diff --git a/opensm/osm_sa_link_record.c b/opensm/osm_sa_link_record.c
index 5b97b90..8ac4962 100644
--- a/opensm/osm_sa_link_record.c
+++ b/opensm/osm_sa_link_record.c
@@ -370,7 +370,7 @@ static ib_net16_t lr_rcv_get_end_points(IN osm_sa_t * sa,
 	*pp_src_port = NULL;
 	*pp_dest_port = NULL;
 
-	if (p_sa_mad->comp_mask & IB_LR_COMPMASK_FROM_LID) {
+	if (comp_mask & IB_LR_COMPMASK_FROM_LID) {
 		*pp_src_port = osm_get_port_by_lid(sa->p_subn, p_lr->from_lid);
 		if (!*pp_src_port) {
 			/*
@@ -387,7 +387,7 @@ static ib_net16_t lr_rcv_get_end_points(IN osm_sa_t * sa,
 		}
 	}
 
-	if (p_sa_mad->comp_mask & IB_LR_COMPMASK_TO_LID) {
+	if (comp_mask & IB_LR_COMPMASK_TO_LID) {
 		*pp_dest_port = osm_get_port_by_lid(sa->p_subn, p_lr->to_lid);
 		if (!*pp_dest_port) {
 			/*
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 0f79e69..6556070 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -893,7 +893,6 @@ static void mcmr_rcv_leave_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	ib_sa_mad_t *p_sa_mad;
 	ib_member_rec_t *p_recvd_mcmember_rec;
 	ib_member_rec_t mcmember_rec;
-	ib_net64_t portguid;
 	osm_mcm_port_t *p_mcm_port;
 
 	OSM_LOG_ENTER(sa->p_log);
@@ -922,8 +921,6 @@ static void mcmr_rcv_leave_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 		goto Exit;
 	}
 
-	portguid = p_recvd_mcmember_rec->port_gid.unicast.interface_id;
-
 	/* check validity of the delete request o15-0.1.14 */
 	if (!validate_delete(sa, p_mgrp, osm_madw_get_mad_addr_ptr(p_madw),
 			     p_recvd_mcmember_rec, &p_mcm_port)) {
diff --git a/opensm/osm_sa_pkey_record.c b/opensm/osm_sa_pkey_record.c
index cf50430..6bd2056 100644
--- a/opensm/osm_sa_pkey_record.c
+++ b/opensm/osm_sa_pkey_record.c
@@ -70,7 +70,6 @@ static void sa_pkey_create(IN osm_sa_t * sa, IN osm_physp_t * p_physp,
 {
 	osm_pkey_item_t *p_rec_item;
 	uint16_t lid;
-	ib_api_status_t status = IB_SUCCESS;
 	ib_pkey_table_t *tbl;
 
 	OSM_LOG_ENTER(sa->p_log);
@@ -79,7 +78,6 @@ static void sa_pkey_create(IN osm_sa_t * sa, IN osm_physp_t * p_physp,
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4602: "
 			"rec_item alloc failed\n");
-		status = IB_INSUFFICIENT_RESOURCES;
 		goto Exit;
 	}
 
diff --git a/opensm/osm_sa_portinfo_record.c b/opensm/osm_sa_portinfo_record.c
index c5b88b8..0836c3c 100644
--- a/opensm/osm_sa_portinfo_record.c
+++ b/opensm/osm_sa_portinfo_record.c
@@ -443,7 +443,6 @@ void osm_pir_rcv_process(IN void *ctx, IN void *data)
 	const ib_sa_mad_t *p_rcvd_mad;
 	const ib_portinfo_record_t *p_rcvd_rec;
 	const osm_port_t *p_port = NULL;
-	const ib_port_info_t *p_pi;
 	cl_qlist_t rec_list;
 	osm_pir_search_ctxt_t context;
 	ib_net64_t comp_mask;
@@ -485,8 +484,6 @@ void osm_pir_rcv_process(IN void *ctx, IN void *data)
 	if (osm_log_is_active(sa->p_log, OSM_LOG_DEBUG))
 		osm_dump_portinfo_record(sa->p_log, p_rcvd_rec, OSM_LOG_DEBUG);
 
-	p_pi = &p_rcvd_rec->port_info;
-
 	cl_qlist_init(&rec_list);
 
 	context.p_rcvd_rec = p_rcvd_rec;
diff --git a/opensm/osm_sa_service_record.c b/opensm/osm_sa_service_record.c
index ae002ad..4658014 100644
--- a/opensm/osm_sa_service_record.c
+++ b/opensm/osm_sa_service_record.c
@@ -602,7 +602,6 @@ static void sr_rcv_process_delete_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 {
 	ib_sa_mad_t *p_sa_mad;
 	ib_service_record_t *p_recvd_service_rec;
-	ib_net64_t comp_mask;
 	osm_svcr_t *p_svcr;
 	osm_sr_item_t *p_sr_item;
 	cl_qlist_t sr_list;
@@ -615,8 +614,6 @@ static void sr_rcv_process_delete_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	p_recvd_service_rec =
 	    (ib_service_record_t *) ib_sa_mad_get_payload_ptr(p_sa_mad);
 
-	comp_mask = p_sa_mad->comp_mask;
-
 	if (osm_log_is_active(sa->p_log, OSM_LOG_DEBUG))
 		osm_dump_service_record(sa->p_log, p_recvd_service_rec,
 					OSM_LOG_DEBUG);
diff --git a/opensm/osm_sa_slvl_record.c b/opensm/osm_sa_slvl_record.c
index 8a980ee..6d9f00a 100644
--- a/opensm/osm_sa_slvl_record.c
+++ b/opensm/osm_sa_slvl_record.c
@@ -77,7 +77,6 @@ static void sa_slvl_create(IN osm_sa_t * sa, IN const osm_physp_t * p_physp,
 {
 	osm_slvl_item_t *p_rec_item;
 	uint16_t lid;
-	ib_api_status_t status = IB_SUCCESS;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -85,7 +84,6 @@ static void sa_slvl_create(IN osm_sa_t * sa, IN const osm_physp_t * p_physp,
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2602: "
 			"rec_item alloc failed\n");
-		status = IB_INSUFFICIENT_RESOURCES;
 		goto Exit;
 	}
 
diff --git a/opensm/osm_sa_vlarb_record.c b/opensm/osm_sa_vlarb_record.c
index d32fdb1..f56bfe6 100644
--- a/opensm/osm_sa_vlarb_record.c
+++ b/opensm/osm_sa_vlarb_record.c
@@ -77,7 +77,6 @@ static void sa_vl_arb_create(IN osm_sa_t * sa, IN osm_physp_t * p_physp,
 {
 	osm_vl_arb_item_t *p_rec_item;
 	uint16_t lid;
-	ib_api_status_t status = IB_SUCCESS;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -85,7 +84,6 @@ static void sa_vl_arb_create(IN osm_sa_t * sa, IN osm_physp_t * p_physp,
 	if (p_rec_item == NULL) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2A02: "
 			"rec_item alloc failed\n");
-		status = IB_INSUFFICIENT_RESOURCES;
 		goto Exit;
 	}
 
diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index d06cea9..a2d7b15 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -9057,7 +9057,7 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 	struct t_switch *ssw, *dsw;
 	struct torus *t;
 	guid_t guid;
-	unsigned sl = 0, sp;
+	unsigned sl = 0;
 
 	sport = osm_sport->priv;
 	if (!(sport && sport->osm_port == osm_sport)) {
@@ -9107,10 +9107,8 @@ uint8_t torus_path_sl(void *context, uint8_t path_sl_hint,
 	 */
 	if (sport->link) {
 		ssw = sport->link->end[0].sw;
-		sp = sport->link->end[0].port;
 	} else {
 		ssw = sport->sw;
-		sp = sport->port;
 	}
 	if (dport->link)
 		dsw = dport->link->end[0].sw;
diff --git a/opensm/osm_ucast_file.c b/opensm/osm_ucast_file.c
index fef77a2..41751bc 100644
--- a/opensm/osm_ucast_file.c
+++ b/opensm/osm_ucast_file.c
@@ -108,10 +108,8 @@ static void add_lid_hops(osm_opensm_t * p_osm, osm_switch_t * p_sw,
 			 uint16_t lid, ib_net64_t guid,
 			 uint8_t hops[], unsigned len)
 {
-	uint16_t new_lid;
 	uint8_t i;
 
-	new_lid = guid ? remap_lid(p_osm, lid, guid) : lid;
 	if (len > p_sw->num_ports)
 		len = p_sw->num_ports;
 
diff --git a/osmtest/osmt_slvl_vl_arb.c b/osmtest/osmt_slvl_vl_arb.c
index d4a08ff..49123ad 100644
--- a/osmtest/osmt_slvl_vl_arb.c
+++ b/osmtest/osmt_slvl_vl_arb.c
@@ -56,18 +56,18 @@ osmtest_write_vl_arb_table(IN osmtest_t * const p_osmt,
 			   IN FILE * fh,
 			   IN const ib_vl_arb_table_record_t * const p_rec)
 {
-	int result, i;
+	int i;
 	cl_status_t status = IB_SUCCESS;
 
 	OSM_LOG_ENTER(&p_osmt->log);
 
-	result = fprintf(fh,
-			 "VL_ARBITRATION_TABLE\n"
-			 "lid                     0x%X\n"
-			 "port_num                0x%X\n"
-			 "block                   0x%X\n",
-			 cl_ntoh16(p_rec->lid),
-			 p_rec->port_num, p_rec->block_num);
+	fprintf(fh,
+		"VL_ARBITRATION_TABLE\n"
+		"lid                     0x%X\n"
+		"port_num                0x%X\n"
+		"block                   0x%X\n",
+		cl_ntoh16(p_rec->lid),
+		p_rec->port_num, p_rec->block_num);
 
 	fprintf(fh, "       ");
 	for (i = 0; i < 32; i++)
@@ -260,18 +260,18 @@ osmtest_write_slvl_map_table(IN osmtest_t * const p_osmt,
 			     IN FILE * fh,
 			     IN const ib_slvl_table_record_t * const p_rec)
 {
-	int result, i;
+	int i;
 	cl_status_t status = IB_SUCCESS;
 
 	OSM_LOG_ENTER(&p_osmt->log);
 
-	result = fprintf(fh,
-			 "SLtoVL_MAP_TABLE\n"
-			 "lid                     0x%X\n"
-			 "in_port_num             0x%X\n"
-			 "out_port_num            0x%X\n",
-			 cl_ntoh16(p_rec->lid),
-			 p_rec->in_port_num, p_rec->out_port_num);
+	fprintf(fh,
+		"SLtoVL_MAP_TABLE\n"
+		"lid                     0x%X\n"
+		"in_port_num             0x%X\n"
+		"out_port_num            0x%X\n",
+		cl_ntoh16(p_rec->lid),
+		p_rec->in_port_num, p_rec->out_port_num);
 
 	fprintf(fh, "SL:");
 	for (i = 0; i < 16; i++)
-- 
1.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
