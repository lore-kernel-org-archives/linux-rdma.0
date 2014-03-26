From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm 1/2] All SA queries should validate the requester port
 under lock
Date: Wed, 26 Mar 2014 14:49:57 -0400
Message-ID: <53332155.7080304@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


It might collide with the sweep operations.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_guidinfo_record.c  |   69 +++++++++++++++++++++++++++----------
 opensm/osm_sa_informinfo.c       |    9 +++--
 opensm/osm_sa_lft_record.c       |    5 ++-
 opensm/osm_sa_link_record.c      |    5 ++-
 opensm/osm_sa_mcmember_record.c  |   12 ++++---
 opensm/osm_sa_mft_record.c       |    5 ++-
 opensm/osm_sa_multipath_record.c |   33 +++++++++---------
 opensm/osm_sa_node_record.c      |    5 ++-
 opensm/osm_sa_path_record.c      |    3 +-
 opensm/osm_sa_pkey_record.c      |    5 ++-
 opensm/osm_sa_portinfo_record.c  |    5 ++-
 opensm/osm_sa_service_record.c   |   20 +++++-----
 opensm/osm_sa_slvl_record.c      |    5 ++-
 opensm/osm_sa_sminfo_record.c    |    5 ++-
 opensm/osm_sa_sw_info_record.c   |    5 ++-
 opensm/osm_sa_vlarb_record.c     |    5 ++-
 16 files changed, 120 insertions(+), 76 deletions(-)

diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index 28f6c0f..1ad8cad 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -401,6 +401,7 @@ static void del_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 			"block_num %d is higher than Max GUID Cap block %d "
 			"for port GUID 0x%" PRIx64 "\n",
 			block_num, max_block, cl_ntoh64(p_port->p_physp->port_guid));
+		CL_PLOCK_RELEASE(sa->p_lock);
 		osm_sa_send_error(sa, p_madw,
 				  IB_SA_MAD_STATUS_NO_RECORDS);
 		return;
@@ -417,6 +418,7 @@ static void del_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 	     i++) {
 		/* can't delete block 0 index 0 (base guid is RO) for alias guid table */
 		if (i == 0 && p_sa_mad->comp_mask & IB_GIR_COMPMASK_GID0) {
+			CL_PLOCK_RELEASE(sa->p_lock);
 			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 				"Not allowed to delete RO GID 0\n");
 			osm_sa_send_error(sa, p_madw,
@@ -436,6 +438,7 @@ static void del_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 				p_list_item = cl_qlist_next(p_list_item);
 				p_mcm_alias_guid = osm_mgrp_get_mcm_alias_guid(p_mcm_port->mgrp, del_alias_guid);
 				if (p_mcm_alias_guid) {
+					CL_PLOCK_RELEASE(sa->p_lock);
 					osm_sa_send_error(sa, p_madw,
 							  IB_SA_MAD_STATUS_DENIED);
 					return;
@@ -481,6 +484,7 @@ static void del_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 	       sizeof(ib_guid_info_t));
 
 Exit:
+	CL_PLOCK_RELEASE(sa->p_lock);
 	gir_respond(sa, p_madw);
 }
 
@@ -504,6 +508,7 @@ static void set_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 			"block_num %d is higher than Max GUID Cap block %d "
 			"for port GUID 0x%" PRIx64 "\n",
 			block_num, max_block, cl_ntoh64(p_port->p_physp->port_guid));
+		CL_PLOCK_RELEASE(sa->p_lock);
 		osm_sa_send_error(sa, p_madw,
 				  IB_SA_MAD_STATUS_NO_RECORDS);
 		return;
@@ -516,6 +521,7 @@ static void set_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 				"GUID table memory allocation failed for port "
 				"GUID 0x%" PRIx64 "\n",
 				cl_ntoh64(p_port->p_physp->port_guid));
+			CL_PLOCK_RELEASE(sa->p_lock);
 			osm_sa_send_error(sa, p_madw,
 					  IB_SA_MAD_STATUS_NO_RESOURCES);
 			return;
@@ -539,6 +545,7 @@ static void set_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 	     i++) {
 		/* can't set block 0 index 0 (base guid is RO) for alias guid table */
 		if (i == 0 && p_sa_mad->comp_mask & IB_GIR_COMPMASK_GID0) {
+			CL_PLOCK_RELEASE(sa->p_lock);
 			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 				"Not allowed to set RO GID 0\n");
 			osm_sa_send_error(sa, p_madw,
@@ -595,6 +602,7 @@ static void set_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 			for (j = 0; j < 1000; j++) {
 				assigned_guid = sm_assigned_guid(sa->p_subn->opt.sm_assigned_guid);
 				if (!assigned_guid) {
+					CL_PLOCK_RELEASE(sa->p_lock);
 					OSM_LOG(sa->p_log, OSM_LOG_ERROR,
 						"ERR 510E: No more assigned guids available\n");
 					osm_sa_send_error(sa, p_madw,
@@ -618,6 +626,7 @@ static void set_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 								OSM_LOG_ERROR,
 								"ERR 510D: osm_assigned_guids_new failed port GUID 0x%" PRIx64 " index %d\n",
 								cl_ntoh64(p_port->p_physp->port_guid), i);
+							CL_PLOCK_RELEASE(sa->p_lock);
 							osm_sa_send_error(sa, p_madw,
 									  IB_SA_MAD_STATUS_NO_RESOURCES);
 							return;
@@ -645,6 +654,7 @@ add_alias_guid:
 				"Alias guid %d memory allocation failed"
 				" for port GUID 0x%" PRIx64 "\n",
 				i, cl_ntoh64(p_port->p_physp->port_guid));
+			CL_PLOCK_RELEASE(sa->p_lock);
 			return;
 		}
 
@@ -702,6 +712,7 @@ add_alias_guid:
 	       &((*p_port->p_physp->p_guids)[block_num * GUID_TABLE_MAX_ENTRIES]),
 	       sizeof(ib_guid_info_t));
 
+	CL_PLOCK_RELEASE(sa->p_lock);
 	gir_respond(sa, p_madw);
 }
 
@@ -725,12 +736,11 @@ static void get_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 	context.sa = sa;
 	context.p_req_physp = p_req_physp;
 
-	cl_plock_acquire(sa->p_lock);
 
 	cl_qmap_apply_func(&sa->p_subn->node_guid_tbl, sa_gir_by_comp_mask_cb,
 			   &context);
 
-	cl_plock_release(sa->p_lock);
+	CL_PLOCK_RELEASE(sa->p_lock);
 
 	osm_sa_respond(sa, p_madw, sizeof(ib_guidinfo_record_t), &rec_list);
 }
@@ -754,23 +764,25 @@ void osm_gir_rcv_process(IN void *ctx, IN void *data)
 
 	CL_ASSERT(p_rcvd_mad->attr_id == IB_MAD_ATTR_GUIDINFO_RECORD);
 
-	/* update the requester physical port */
-	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
-						osm_madw_get_mad_addr_ptr(p_madw));
-	if (p_req_physp == NULL) {
-		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5104: "
-			"Cannot find requester physical port\n");
-		goto Exit;
-	}
-	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
-		"Requester port GUID 0x%" PRIx64 "\n",
-		cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
-
 	switch(p_rcvd_mad->method) {
 	case IB_MAD_METHOD_GET:
 	case IB_MAD_METHOD_GETTABLE:
+		/* update the requester physical port */
+		CL_PLOCK_ACQUIRE(sa->p_lock);
+		p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
+							osm_madw_get_mad_addr_ptr(p_madw));
+		if (p_req_physp == NULL) {
+			CL_PLOCK_RELEASE(sa->p_lock);
+			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5104: "
+				"Cannot find requester physical port\n");
+			goto Exit;
+		}
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Requester port GUID 0x%" PRIx64 "\n",
+			cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
+
 		get_guidinfo(sa, p_madw, p_req_physp);
-		break;
+		goto Exit;
 	case IB_MAD_METHOD_SET:
 	case IB_MAD_METHOD_DELETE:
 		if (!check_mod_comp_mask(p_rcvd_mad->comp_mask)) {
@@ -784,23 +796,40 @@ void osm_gir_rcv_process(IN void *ctx, IN void *data)
 			goto Exit;
 		}
 		p_rcvd_rec = (ib_guidinfo_record_t *) ib_sa_mad_get_payload_ptr(p_rcvd_mad);
+
+		/* update the requester physical port */
+		CL_PLOCK_EXCL_ACQUIRE(sa->p_lock);
+		p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
+							osm_madw_get_mad_addr_ptr(p_madw));
+		if (p_req_physp == NULL) {
+			CL_PLOCK_RELEASE(sa->p_lock);
+			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5104: "
+				"Cannot find requester physical port\n");
+			goto Exit;
+		}
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"Requester port GUID 0x%" PRIx64 "\n",
+			cl_ntoh64(osm_physp_get_port_guid(p_req_physp)));
+
 		p_port = osm_get_port_by_lid(sa->p_subn, p_rcvd_rec->lid);
 		if (!p_port) {
+			CL_PLOCK_RELEASE(sa->p_lock);
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5117: "
 				"Port with LID %u not found\n",
 				cl_ntoh16(p_rcvd_rec->lid));
-			osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_NO_RECORDS);
+				osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_NO_RECORDS);
 			goto Exit;
 		}
 		if (!osm_physp_share_pkey(sa->p_log, p_req_physp, p_port->p_physp,
-					  sa->p_subn->opt.allow_both_pkeys))
+					  sa->p_subn->opt.allow_both_pkeys)) {
+			CL_PLOCK_RELEASE(sa->p_lock);
 			goto Exit;
-		CL_PLOCK_EXCL_ACQUIRE(sa->p_lock);
+		}
+
 		if (p_rcvd_mad->method == IB_MAD_METHOD_SET)
 			set_guidinfo(sa, p_madw, p_port, p_rcvd_rec->block_num);
 		else
 			del_guidinfo(sa, p_madw, p_port, p_rcvd_rec->block_num);
-		CL_PLOCK_RELEASE(sa->p_lock);
 		break;
 	default:
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5105: "
diff --git a/opensm/osm_sa_informinfo.c b/opensm/osm_sa_informinfo.c
index 5543c9a..92855bf 100644
--- a/opensm/osm_sa_informinfo.c
+++ b/opensm/osm_sa_informinfo.c
@@ -338,11 +338,14 @@ static void infr_rcv_process_get_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	p_rcvd_rec =
 	    (ib_inform_info_record_t *) ib_sa_mad_get_payload_ptr(p_rcvd_mad);
 
+	cl_plock_acquire(sa->p_lock);
+
 	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
 	if (p_req_physp == NULL) {
+		cl_plock_release(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4309: "
 			"Cannot find requester physical port\n");
 		goto Exit;
@@ -375,13 +378,9 @@ static void infr_rcv_process_get_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 		cl_ntoh16(p_rcvd_rec->subscriber_enum),
 		(p_rcvd_mad->comp_mask & IB_IIR_COMPMASK_ENUM) != 0);
 
-	cl_plock_acquire(sa->p_lock);
-
 	cl_qlist_apply_func(&sa->p_subn->sa_infr_list,
 			    sa_inform_info_rec_by_comp_mask_cb, &context);
 
-	cl_plock_release(sa->p_lock);
-
 	/* clear reserved and pad fields in InformInfoRecord */
 	for (item = (osm_sa_item_t *) cl_qlist_head(&rec_list);
 	     item != (osm_sa_item_t *) cl_qlist_end(&rec_list);
@@ -390,6 +389,8 @@ static void infr_rcv_process_get_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 		memset(item->resp.inform_rec.pad, 0, sizeof(item->resp.inform_rec.pad));
 	}
 
+	cl_plock_release(sa->p_lock);
+
 	osm_sa_respond(sa, p_madw, sizeof(ib_inform_info_record_t), &rec_list);
 
 Exit:
diff --git a/opensm/osm_sa_lft_record.c b/opensm/osm_sa_lft_record.c
index cf651ef..8f4749e 100644
--- a/opensm/osm_sa_lft_record.c
+++ b/opensm/osm_sa_lft_record.c
@@ -204,11 +204,14 @@ void osm_lftr_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
+	cl_plock_acquire(sa->p_lock);
+
 	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
 	if (p_req_physp == NULL) {
+		cl_plock_release(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4407: "
 			"Cannot find requester physical port\n");
 		goto Exit;
@@ -226,8 +229,6 @@ void osm_lftr_rcv_process(IN void *ctx, IN void *data)
 	context.sa = sa;
 	context.p_req_physp = p_req_physp;
 
-	cl_plock_acquire(sa->p_lock);
-
 	/* Go over all switches */
 	cl_qmap_apply_func(&sa->p_subn->sw_guid_tbl, lftr_rcv_by_comp_mask,
 			   &context);
diff --git a/opensm/osm_sa_link_record.c b/opensm/osm_sa_link_record.c
index 5073f96..5ab3d74 100644
--- a/opensm/osm_sa_link_record.c
+++ b/opensm/osm_sa_link_record.c
@@ -443,11 +443,14 @@ void osm_lr_rcv_process(IN void *context, IN void *data)
 		goto Exit;
 	}
 
+	cl_plock_acquire(sa->p_lock);
+
 	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
 	if (p_req_physp == NULL) {
+		cl_plock_release(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1805: "
 			"Cannot find requester physical port\n");
 		goto Exit;
@@ -466,8 +469,6 @@ void osm_lr_rcv_process(IN void *context, IN void *data)
 	   Most SA functions (including this one) are read-only on the
 	   subnet object, so we grab the lock non-exclusively.
 	 */
-	cl_plock_acquire(sa->p_lock);
-
 	status = lr_rcv_get_end_points(sa, p_madw, &p_src_port, &p_dest_port);
 
 	if (status == IB_SA_MAD_STATUS_SUCCESS)
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 84b6936..4f43c62 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -931,6 +931,8 @@ static void mcmr_rcv_leave_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 		goto Exit;
 	}
 
+	CL_PLOCK_EXCL_ACQUIRE(sa->p_lock);
+
 	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
 		osm_physp_t *p_req_physp;
 
@@ -948,7 +950,6 @@ static void mcmr_rcv_leave_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 		osm_dump_mc_record_v2(sa->p_log, &mcmember_rec, FILE_ID, OSM_LOG_DEBUG);
 	}
 
-	CL_PLOCK_EXCL_ACQUIRE(sa->p_lock);
 	p_mgrp = osm_get_mgrp_by_mgid(sa->p_subn, &p_recvd_mcmember_rec->mgid);
 	if (!p_mgrp) {
 		char gid_str[INET6_ADDRSTRLEN];
@@ -1030,6 +1031,10 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 		goto Exit;
 	}
 
+	CL_PLOCK_EXCL_ACQUIRE(sa->p_lock);
+
+	CL_PLOCK_EXCL_ACQUIRE(sa->p_lock);
+
 	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
 		osm_physp_t *p_req_physp;
 
@@ -1047,8 +1052,6 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 		osm_dump_mc_record_v2(sa->p_log, &mcmember_rec, FILE_ID, OSM_LOG_DEBUG);
 	}
 
-	CL_PLOCK_EXCL_ACQUIRE(sa->p_lock);
-
 	/* make sure the requested port guid is known to the SM */
 	p_port = osm_get_port_by_alias_guid(sa->p_subn, portguid);
 	if (!p_port) {
@@ -1451,11 +1454,14 @@ static void mcmr_query_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	 */
 	trusted_req = (p_rcvd_mad->sm_key != 0);
 
+	CL_PLOCK_ACQUIRE(sa->p_lock);
+
 	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
 	if (p_req_physp == NULL) {
+		CL_PLOCK_RELEASE(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B04: "
 			"Cannot find requester physical port\n");
 		goto Exit;
@@ -1471,8 +1477,6 @@ static void mcmr_query_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 
 	cl_qlist_init(&rec_list);
 
-	CL_PLOCK_ACQUIRE(sa->p_lock);
-
 	/* simply go over all MCGs and match */
 	for (p_mgrp = (osm_mgrp_t *) cl_fmap_head(&sa->p_subn->mgrp_mgid_tbl);
 	     p_mgrp != (osm_mgrp_t *) cl_fmap_end(&sa->p_subn->mgrp_mgid_tbl);
diff --git a/opensm/osm_sa_mft_record.c b/opensm/osm_sa_mft_record.c
index 6f9763f..3f9b14a 100644
--- a/opensm/osm_sa_mft_record.c
+++ b/opensm/osm_sa_mft_record.c
@@ -237,11 +237,14 @@ void osm_mftr_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
+	cl_plock_acquire(sa->p_lock);
+
 	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
 	if (p_req_physp == NULL) {
+		cl_plock_release(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4A07: "
 			"Cannot find requester physical port\n");
 		goto Exit;
@@ -258,8 +261,6 @@ void osm_mftr_rcv_process(IN void *ctx, IN void *data)
 	context.sa = sa;
 	context.p_req_physp = p_req_physp;
 
-	cl_plock_acquire(sa->p_lock);
-
 	/* Go over all switches */
 	cl_qmap_apply_func(&sa->p_subn->sw_guid_tbl, mftr_rcv_by_comp_mask,
 			   &context);
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index 9030278..1f7ee86 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -1568,22 +1568,8 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 		goto Exit;
 	}
 
-	/* update the requester physical port */
-	requester_port = osm_get_port_by_mad_addr(sa->p_log, sa->p_subn,
-						  osm_madw_get_mad_addr_ptr
-						  (p_madw));
-	if (requester_port == NULL) {
-		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4517: "
-			"Cannot find requester physical port\n");
-		goto Exit;
-	}
-
-	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
-		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
-			"Requester port GUID 0x%" PRIx64 "\n",
-			cl_ntoh64(osm_port_get_guid(requester_port)));
+	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG))
 		osm_dump_multipath_record_v2(sa->p_log, p_mpr, FILE_ID, OSM_LOG_DEBUG);
-	}
 
 	/* Make sure required components (S/DGIDCount) are supplied */
 	if (!(p_sa_mad->comp_mask & IB_MPR_COMPMASK_SGIDCOUNT) ||
@@ -1629,15 +1615,30 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 	 */
 	cl_plock_acquire(sa->p_lock);
 
+	/* update the requester physical port */
+	requester_port = osm_get_port_by_mad_addr(sa->p_log, sa->p_subn,
+						  osm_madw_get_mad_addr_ptr
+						  (p_madw));
+	if (requester_port == NULL) {
+		cl_plock_release(sa->p_lock);
+		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4517: "
+			"Cannot find requester physical port\n");
+		goto Exit;
+	}
+
+	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+		"Requester port GUID 0x%" PRIx64 "\n",
+		cl_ntoh64(osm_port_get_guid(requester_port)));
+
 	sa_status = mpr_rcv_get_end_points(sa, p_madw, pp_alias_guids,
 					   &nsrc, &ndest);
 
 	if (sa_status != IB_SA_MAD_STATUS_SUCCESS || !nsrc || !ndest) {
+		cl_plock_release(sa->p_lock);
 		if (sa_status == IB_SA_MAD_STATUS_SUCCESS && (!nsrc || !ndest))
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4512: "
 				"mpr_rcv_get_end_points failed, # GIDs found; "
 				"src %d; dest %d)\n", nsrc, ndest);
-		cl_plock_release(sa->p_lock);
 		if (sa_status == IB_SA_MAD_STATUS_SUCCESS)
 			osm_sa_send_error(sa, p_madw,
 					  IB_SA_MAD_STATUS_REQ_INVALID);
diff --git a/opensm/osm_sa_node_record.c b/opensm/osm_sa_node_record.c
index 19c7cc3..0cb0ffb 100644
--- a/opensm/osm_sa_node_record.c
+++ b/opensm/osm_sa_node_record.c
@@ -312,11 +312,14 @@ void osm_nr_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
+	cl_plock_acquire(sa->p_lock);
+
 	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
 	if (p_req_physp == NULL) {
+		cl_plock_release(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1D04: "
 			"Cannot find requester physical port\n");
 		goto Exit;
@@ -337,8 +340,6 @@ void osm_nr_rcv_process(IN void *ctx, IN void *data)
 	context.sa = sa;
 	context.p_req_physp = p_req_physp;
 
-	cl_plock_acquire(sa->p_lock);
-
 	cl_qmap_apply_func(&sa->p_subn->node_guid_tbl, nr_rcv_by_comp_mask,
 			   &context);
 
diff --git a/opensm/osm_sa_pkey_record.c b/opensm/osm_sa_pkey_record.c
index 586c3eb..296d0a5 100644
--- a/opensm/osm_sa_pkey_record.c
+++ b/opensm/osm_sa_pkey_record.c
@@ -259,11 +259,14 @@ void osm_pkey_rec_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
+	cl_plock_acquire(sa->p_lock);
+
 	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
 	if (p_req_physp == NULL) {
+		cl_plock_release(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4604: "
 			"Cannot find requester physical port\n");
 		goto Exit;
@@ -288,8 +291,6 @@ void osm_pkey_rec_rcv_process(IN void *ctx, IN void *data)
 		(comp_mask & IB_PKEY_COMPMASK_PORT) != 0, context.block_num,
 		(comp_mask & IB_PKEY_COMPMASK_BLOCK) != 0);
 
-	cl_plock_acquire(sa->p_lock);
-
 	/*
 	   If the user specified a LID, it obviously narrows our
 	   work load, since we don't have to search every port
diff --git a/opensm/osm_sa_portinfo_record.c b/opensm/osm_sa_portinfo_record.c
index 78d8d16..c362c62 100644
--- a/opensm/osm_sa_portinfo_record.c
+++ b/opensm/osm_sa_portinfo_record.c
@@ -538,11 +538,14 @@ void osm_pir_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
+	cl_plock_acquire(sa->p_lock);
+
 	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
 	if (p_req_physp == NULL) {
+		cl_plock_release(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2104: "
 			"Cannot find requester physical port\n");
 		goto Exit;
@@ -565,8 +568,6 @@ void osm_pir_rcv_process(IN void *ctx, IN void *data)
 	context.is_enhanced_comp_mask =
 	    cl_ntoh32(p_rcvd_mad->attr_mod) & (1 << 31);
 
-	cl_plock_acquire(sa->p_lock);
-
 	/*
 	   If the user specified a LID, it obviously narrows our
 	   work load, since we don't have to search every port
diff --git a/opensm/osm_sa_service_record.c b/opensm/osm_sa_service_record.c
index c2c6ea9..61c5892 100644
--- a/opensm/osm_sa_service_record.c
+++ b/opensm/osm_sa_service_record.c
@@ -453,11 +453,15 @@ static void sr_rcv_process_get_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 
 	CL_ASSERT(p_madw);
 
+	/* Grab the lock */
+	cl_plock_excl_acquire(sa->p_lock);
+
 	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
 	if (p_req_physp == NULL) {
+		cl_plock_release(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2409: "
 			"Cannot find requester physical port\n");
 		goto Exit;
@@ -483,9 +487,6 @@ static void sr_rcv_process_get_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	context.p_sr_item = &sr_match_item;
 	context.p_req_physp = p_req_physp;
 
-	/* Grab the lock */
-	cl_plock_excl_acquire(sa->p_lock);
-
 	cl_qlist_apply_func(&sa->p_subn->sa_sr_list, get_matching_sr, &context);
 
 	cl_plock_release(sa->p_lock);
@@ -530,6 +531,7 @@ static void sr_rcv_process_set_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 
 	if ((comp_mask & (IB_SR_COMPMASK_SID | IB_SR_COMPMASK_SGID)) !=
 	    (IB_SR_COMPMASK_SID | IB_SR_COMPMASK_SGID)) {
+		cl_plock_release(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
 			"Component Mask RID check failed for METHOD_SET\n");
 		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_REQ_INVALID);
@@ -543,9 +545,6 @@ static void sr_rcv_process_set_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 		p_recvd_service_rec->service_lease = 0xFFFFFFFF;
 	}
 
-	/* Grab the lock */
-	cl_plock_excl_acquire(sa->p_lock);
-
 	/* If Record exists with matching RID */
 	p_svcr = osm_svcr_get_by_rid(sa->p_subn, sa->p_log,
 				     p_recvd_service_rec);
@@ -555,7 +554,6 @@ static void sr_rcv_process_set_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 		p_svcr = osm_svcr_new(p_recvd_service_rec);
 		if (p_svcr == NULL) {
 			cl_plock_release(sa->p_lock);
-
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2411: "
 				"Failed to create new service record\n");
 
@@ -626,9 +624,6 @@ static void sr_rcv_process_delete_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 		osm_dump_service_record_v2(sa->p_log, p_recvd_service_rec,
 					   FILE_ID, OSM_LOG_DEBUG);
 
-	/* Grab the lock */
-	cl_plock_excl_acquire(sa->p_lock);
-
 	/* If Record exists with matching RID */
 	p_svcr = osm_svcr_get_by_rid(sa->p_subn, sa->p_log,
 				     p_recvd_service_rec);
@@ -685,19 +680,24 @@ void osm_sr_rcv_process(IN void *context, IN void *data)
 
 	switch (p_sa_mad->method) {
 	case IB_MAD_METHOD_SET:
+		cl_plock_excl_acquire(sa->p_lock);
 		valid = validate_sr(sa, p_madw);
 		if (!valid) {
+			cl_plock_release(sa->p_lock);
 			OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
 				"Component Mask check failed for set request\n");
 			osm_sa_send_error(sa, p_madw,
 					  IB_SA_MAD_STATUS_REQ_INVALID);
 			goto Exit;
 		}
+		cl_plock_release(sa->p_lock);
 		sr_rcv_process_set_method(sa, p_madw);
 		break;
 	case IB_MAD_METHOD_DELETE:
+		cl_plock_excl_acquire(sa->p_lock);
 		valid = validate_sr(sa, p_madw);
 		if (!valid) {
+			cl_plock_release(sa->p_lock);
 			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 				"Component Mask check failed for delete request\n");
 			osm_sa_send_error(sa, p_madw,
diff --git a/opensm/osm_sa_slvl_record.c b/opensm/osm_sa_slvl_record.c
index 467ac0b..83f0cb1 100644
--- a/opensm/osm_sa_slvl_record.c
+++ b/opensm/osm_sa_slvl_record.c
@@ -232,11 +232,14 @@ void osm_slvl_rec_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
+	cl_plock_acquire(sa->p_lock);
+
 	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
 	if (p_req_physp == NULL) {
+		cl_plock_release(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2603: "
 			"Cannot find requester physical port\n");
 		goto Exit;
@@ -254,8 +257,6 @@ void osm_slvl_rec_rcv_process(IN void *ctx, IN void *data)
 	context.in_port_num = p_rcvd_rec->in_port_num;
 	context.p_req_physp = p_req_physp;
 
-	cl_plock_acquire(sa->p_lock);
-
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"Got Query Lid:%u(%02X), In-Port:0x%02X(%02X), Out-Port:0x%02X(%02X)\n",
 		cl_ntoh16(p_rcvd_rec->lid),
diff --git a/opensm/osm_sa_sminfo_record.c b/opensm/osm_sa_sminfo_record.c
index 83991f4..243b6a4 100644
--- a/opensm/osm_sa_sminfo_record.c
+++ b/opensm/osm_sa_sminfo_record.c
@@ -208,11 +208,14 @@ void osm_smir_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
+	cl_plock_acquire(sa->p_lock);
+
 	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
 	if (p_req_physp == NULL) {
+		cl_plock_release(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2803: "
 			"Cannot find requester physical port\n");
 		goto Exit;
@@ -235,8 +238,6 @@ void osm_smir_rcv_process(IN void *ctx, IN void *data)
 	context.sa = sa;
 	context.p_req_physp = p_req_physp;
 
-	cl_plock_acquire(sa->p_lock);
-
 	/*
 	   If the user specified a LID, it obviously narrows our
 	   work load, since we don't have to search every port
diff --git a/opensm/osm_sa_sw_info_record.c b/opensm/osm_sa_sw_info_record.c
index 0776c8b..acbe3a6 100644
--- a/opensm/osm_sa_sw_info_record.c
+++ b/opensm/osm_sa_sw_info_record.c
@@ -222,11 +222,14 @@ void osm_sir_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
+	cl_plock_acquire(sa->p_lock);
+
 	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
 	if (p_req_physp == NULL) {
+		cl_plock_release(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5304: "
 			"Cannot find requester physical port\n");
 		goto Exit;
@@ -248,8 +251,6 @@ void osm_sir_rcv_process(IN void *ctx, IN void *data)
 	context.sa = sa;
 	context.p_req_physp = p_req_physp;
 
-	cl_plock_acquire(sa->p_lock);
-
 	/* Go over all switches */
 	cl_qmap_apply_func(&sa->p_subn->sw_guid_tbl, sir_rcv_by_comp_mask,
 			   &context);
diff --git a/opensm/osm_sa_vlarb_record.c b/opensm/osm_sa_vlarb_record.c
index 17b21a5..8cb25fc 100644
--- a/opensm/osm_sa_vlarb_record.c
+++ b/opensm/osm_sa_vlarb_record.c
@@ -239,11 +239,14 @@ void osm_vlarb_rec_rcv_process(IN void *ctx, IN void *data)
 		goto Exit;
 	}
 
+	cl_plock_acquire(sa->p_lock);
+
 	/* update the requester physical port */
 	p_req_physp = osm_get_physp_by_mad_addr(sa->p_log, sa->p_subn,
 						osm_madw_get_mad_addr_ptr
 						(p_madw));
 	if (p_req_physp == NULL) {
+		cl_plock_release(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2A04: "
 			"Cannot find requester physical port\n");
 		goto Exit;
@@ -269,8 +272,6 @@ void osm_vlarb_rec_rcv_process(IN void *ctx, IN void *data)
 		p_rcvd_rec->block_num,
 		(comp_mask & IB_VLA_COMPMASK_BLOCK) != 0);
 
-	cl_plock_acquire(sa->p_lock);
-
 	/*
 	   If the user specified a LID, it obviously narrows our
 	   work load, since we don't have to search every port
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
