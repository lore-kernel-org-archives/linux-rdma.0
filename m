From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2] opensm/libvendor/osm_vendor_mlx_sa.c: Sync with osm_vendor_ibumad_sa.c
Date: Thu, 07 Apr 2011 10:49:52 -0400
Message-ID: <4D9DCF10.50005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Changes for not setting attribute offset unless RMPP
Added previous changes not merged:
Added OSMV_QUERY_MULTIPATH_REC support in osmv_query_sa
Changed bind info to indicate both is_responder and is_report_processor
are FALSE rather than TRUE 
Use OSM_LOG rather than osm_log
Cosmetic changes to log messages
Made some routines static

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v1:
Fixed formatting

diff --git a/opensm/libvendor/osm_vendor_mlx_sa.c b/opensm/libvendor/osm_vendor_mlx_sa.c
index 4be8e16..8442464 100644
--- a/opensm/libvendor/osm_vendor_mlx_sa.c
+++ b/opensm/libvendor/osm_vendor_mlx_sa.c
@@ -2,7 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005,2008 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
- * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2009,2010 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -68,7 +68,7 @@ typedef struct _osmv_sa_bind_info {
   A pointer to the actual context of the request (a copy of the oriignal
   request structure) is attached as the p_madw->context.ni_context.node_guid
 */
-void
+static void
 __osmv_sa_mad_rcv_cb(IN osm_madw_t * p_madw,
 		     IN void *bind_context, IN osm_madw_t * p_req_madw)
 {
@@ -81,8 +81,7 @@ __osmv_sa_mad_rcv_cb(IN osm_madw_t * p_madw,
 	OSM_LOG_ENTER(p_bind->p_log);
 
 	if (!p_req_madw) {
-		osm_log(p_bind->p_log, OSM_LOG_DEBUG,
-			"__osmv_sa_mad_rcv_cb: "
+		OSM_LOG(p_bind->p_log, OSM_LOG_DEBUG,
 			"Ignoring a non-response mad\n");
 		osm_mad_pool_put(p_bind->p_mad_pool, p_madw);
 		goto Exit;
@@ -104,19 +103,16 @@ __osmv_sa_mad_rcv_cb(IN osm_madw_t * p_madw,
 	/* if we got a remote error track it in the status */
 	mad_status = (ib_net16_t) (p_sa_mad->status & IB_SMP_STATUS_MASK);
 	if (mad_status != IB_SUCCESS) {
-		osm_log(p_bind->p_log, OSM_LOG_ERROR,
-			"__osmv_sa_mad_rcv_cb: ERR 0501: "
-			"Remote error:0x%04X .\n", mad_status);
+		OSM_LOG(p_bind->p_log, OSM_LOG_ERROR, "ERR 0501: "
+			"Remote error:0x%04X\n", cl_ntoh16(mad_status));
 		query_res.status = IB_REMOTE_ERROR;
-	} else {
+	} else
 		query_res.status = IB_SUCCESS;
-	}
 
 	/* what if we have got back an empty mad ? */
 	if (!p_madw->mad_size) {
-		osm_log(p_bind->p_log, OSM_LOG_ERROR,
-			"__osmv_sa_mad_rcv_cb: ERR 0502: "
-			"Got an empty mad.\n");
+		OSM_LOG(p_bind->p_log, OSM_LOG_ERROR, "ERR 0502: "
+			"Got an empty mad\n");
 		query_res.status = IB_ERROR;
 	}
 
@@ -137,15 +133,14 @@ __osmv_sa_mad_rcv_cb(IN osm_madw_t * p_madw,
 			   records in here */
 			if (ib_get_attr_size(p_sa_mad->attr_offset) == 0) {
 				query_res.result_cnt = 0;
-				osm_log(p_bind->p_log, OSM_LOG_DEBUG,
-					"__osmv_sa_mad_rcv_cb: Count = 0\n");
+				OSM_LOG(p_bind->p_log, OSM_LOG_DEBUG,
+					"Count = 0\n");
 			}
 			else {
 				query_res.result_cnt =
 					(p_madw->mad_size - IB_SA_MAD_HDR_SIZE) /
 					ib_get_attr_size(p_sa_mad->attr_offset);
-				osm_log(p_bind->p_log, OSM_LOG_DEBUG,
-					"__osmv_sa_mad_rcv_cb: "
+				OSM_LOG(p_bind->p_log, OSM_LOG_DEBUG,
 					"Count = %u = %zu / %u (%zu)\n",
 					query_res.result_cnt,
 					p_madw->mad_size - IB_SA_MAD_HDR_SIZE,
@@ -182,7 +177,7 @@ Exit:
 
   Only report the error and get rid of the mad wrapper
 */
-void __osmv_sa_mad_err_cb(IN void *bind_context, IN osm_madw_t * p_madw)
+static void __osmv_sa_mad_err_cb(IN void *bind_context, IN osm_madw_t * p_madw)
 {
 	osmv_sa_bind_info_t *p_bind = (osmv_sa_bind_info_t *) bind_context;
 	osmv_query_req_t *p_query_req_copy = NULL;
@@ -223,7 +218,7 @@ void __osmv_sa_mad_err_cb(IN void *bind_context, IN osm_madw_t * p_madw)
  to be stored in the context of the results. Also this coveres cases were
  we query for multiple guids.
  *****************************************************************************/
-ib_api_status_t
+static ib_api_status_t
 __osmv_get_lid_and_sm_lid_by_port_guid(IN osm_vendor_t * const p_vend,
 				       IN ib_net64_t port_guid,
 				       IN OUT uint64_t * p_lids_update_time_sec,
@@ -240,8 +235,7 @@ __osmv_get_lid_and_sm_lid_by_port_guid(IN osm_vendor_t * const p_vend,
 
 	/* use prevous values if current time is close enough to previous query */
 	if (cl_get_time_stamp_sec() <= *p_lids_update_time_sec + 30) {
-		osm_log(p_vend->p_log, OSM_LOG_DEBUG,
-			"__osmv_get_lid_and_sm_lid_by_port_guid: "
+		OSM_LOG(p_vend->p_log, OSM_LOG_DEBUG,
 			"Using previously stored lid:0x%04x sm_lid:0x%04x\n",
 			*lid, *sm_lid);
 		status = IB_SUCCESS;
@@ -252,20 +246,16 @@ __osmv_get_lid_and_sm_lid_by_port_guid(IN osm_vendor_t * const p_vend,
 	num_ports = 0;
 	status = osm_vendor_get_all_port_attr(p_vend, NULL, &num_ports);
 	if (status != IB_INSUFFICIENT_MEMORY) {
-		osm_log(p_vend->p_log, OSM_LOG_ERROR,
-			"__osmv_get_lid_and_sm_lid_by_port_guid: ERR 0503: "
-			"expected to get the IB_INSUFFICIENT_MEMORY but got: %s\n",
-			ib_get_err_str(status)
-		    );
+		OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 0503: "
+			"Expected to get the IB_INSUFFICIENT_MEMORY but got: %s\n",
+			ib_get_err_str(status));
 		status = IB_ERROR;
 		goto Exit;
 	}
 
-	osm_log(p_vend->p_log, OSM_LOG_DEBUG,
-		"__osmv_get_lid_and_sm_lid_by_port_guid: "
+	OSM_LOG(p_vend->p_log, OSM_LOG_DEBUG,
 		"Found total of %u ports. Looking for guid:0x%016" PRIx64 "\n",
-		num_ports, cl_ntoh64(port_guid)
-	    );
+		num_ports, cl_ntoh64(port_guid));
 
 	/* allocate the attributes */
 	p_attr_array =
@@ -274,11 +264,9 @@ __osmv_get_lid_and_sm_lid_by_port_guid(IN osm_vendor_t * const p_vend,
 	/* obtain the attributes */
 	status = osm_vendor_get_all_port_attr(p_vend, p_attr_array, &num_ports);
 	if (status != IB_SUCCESS) {
-		osm_log(p_vend->p_log, OSM_LOG_ERROR,
-			"__osmv_get_lid_and_sm_lid_by_port_guid: ERR 0504: "
-			"Fail to get port attributes (error: %s)\n",
-			ib_get_err_str(status)
-		    );
+		OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 0504: "
+			"Failed to get port attributes (error: %s)\n",
+			ib_get_err_str(status));
 		free(p_attr_array);
 		goto Exit;
 	}
@@ -292,8 +280,7 @@ __osmv_get_lid_and_sm_lid_by_port_guid(IN osm_vendor_t * const p_vend,
 			*sm_lid = p_attr_array[port_num].sm_lid;
 			*p_lids_update_time_sec = cl_get_time_stamp_sec();
 			status = IB_SUCCESS;
-			osm_log(p_vend->p_log, OSM_LOG_DEBUG,
-				"__osmv_get_lid_and_sm_lid_by_port_guid: "
+			OSM_LOG(p_vend->p_log, OSM_LOG_DEBUG,
 				"Found guid:0x%016" PRIx64 " with idx:%d\n",
 				cl_ntoh64(port_guid), port_num);
 		}
@@ -318,16 +305,15 @@ osmv_bind_sa(IN osm_vendor_t * const p_vend,
 
 	OSM_LOG_ENTER(p_log);
 
-	osm_log(p_log, OSM_LOG_DEBUG,
-		"osmv_bind_sa: "
-		"Binding to port 0x%" PRIx64 ".\n", cl_ntoh64(port_guid));
+	OSM_LOG(p_log, OSM_LOG_DEBUG,
+		"Binding to port 0x%" PRIx64 "\n", cl_ntoh64(port_guid));
 
 	bind_info.port_guid = port_guid;
 	bind_info.mad_class = IB_MCLASS_SUBN_ADM;
 	bind_info.class_version = 2;
-	bind_info.is_responder = TRUE;
+	bind_info.is_responder = FALSE;
 	bind_info.is_trap_processor = FALSE;
-	bind_info.is_report_processor = TRUE;
+	bind_info.is_report_processor = FALSE;
 	bind_info.send_q_size = 256;
 	bind_info.recv_q_size = 256;
 
@@ -335,9 +321,8 @@ osmv_bind_sa(IN osm_vendor_t * const p_vend,
 	p_sa_bind_info =
 	    (osmv_sa_bind_info_t *) malloc(sizeof(osmv_sa_bind_info_t));
 	if (!p_sa_bind_info) {
-		osm_log(p_log, OSM_LOG_ERROR,
-			"osmv_bind_sa: ERR 0505: "
-			"Fail to allocate new bidn structure\n");
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0505: "
+			"Failed to allocate new bind structure\n");
 		p_sa_bind_info = OSM_BIND_INVALID_HANDLE;
 		goto Exit;
 	}
@@ -355,9 +340,8 @@ osmv_bind_sa(IN osm_vendor_t * const p_vend,
 	if (p_sa_bind_info->h_bind == OSM_BIND_INVALID_HANDLE) {
 		free(p_sa_bind_info);
 		p_sa_bind_info = OSM_BIND_INVALID_HANDLE;
-		osm_log(p_log, OSM_LOG_ERROR,
-			"osmv_bind_sa: ERR 0506: "
-			"Fail to bind to vendor SMI.\n");
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0506: "
+			"Failed to bind to vendor GSI\n");
 		goto Exit;
 	}
 
@@ -371,9 +355,8 @@ osmv_bind_sa(IN osm_vendor_t * const p_vend,
 	if (status != IB_SUCCESS) {
 		free(p_sa_bind_info);
 		p_sa_bind_info = OSM_BIND_INVALID_HANDLE;
-		osm_log(p_log, OSM_LOG_ERROR,
-			"osmv_bind_sa: ERR 0507: "
-			"Fail to obtain the sm lid.\n");
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0507: "
+			"Failed to obtain the SM lid\n");
 		goto Exit;
 	}
 
@@ -381,10 +364,8 @@ osmv_bind_sa(IN osm_vendor_t * const p_vend,
 	cl_event_construct(&p_sa_bind_info->sync_event);
 	cl_status = cl_event_init(&p_sa_bind_info->sync_event, TRUE);
 	if (cl_status != CL_SUCCESS) {
-		osm_log(p_log, OSM_LOG_ERROR,
-			"osmv_bind_sa: ERR 0508: "
-			"cl_init_event failed: %s\n", ib_get_err_str(cl_status)
-		    );
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0508: "
+			"cl_init_event failed: %s\n", ib_get_err_str(cl_status));
 		free(p_sa_bind_info);
 		p_sa_bind_info = OSM_BIND_INVALID_HANDLE;
 	}
@@ -435,7 +416,7 @@ typedef struct _osmv_sa_mad_data {
  *****/
 
 /* Send a MAD out on the GSI interface */
-ib_api_status_t
+static ib_api_status_t
 __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bind,
 		   IN const osmv_sa_mad_data_t * const p_sa_mad_data,
 		   IN const osmv_query_req_t * const p_query_req)
@@ -448,13 +429,14 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bind,
 	static atomic32_t trans_id;
 	boolean_t sync;
 	osmv_query_req_t *p_query_req_copy;
+	uint32_t sa_size;
 
 	OSM_LOG_ENTER(p_log);
 
 	/*
 	   since the sm_lid might change we obtain it every send
 	   (actually it is cached in the bind object and refreshed
-	   every 30sec by this proc )
+	   every 30sec by this proc)
 	 */
 	status =
 	    __osmv_get_lid_and_sm_lid_by_port_guid(p_bind->p_vendor,
@@ -464,9 +446,8 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bind,
 						   &p_bind->lid,
 						   &p_bind->sm_lid);
 	if (status != IB_SUCCESS) {
-		osm_log(p_log, OSM_LOG_ERROR,
-			"__osmv_send_sa_req: ERR 0509: "
-			"Fail to obtain the sm lid.\n");
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0509: "
+			"Failed to obtain the SM lid\n");
 		goto Exit;
 	}
 
@@ -475,9 +456,8 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bind,
 				  p_bind->h_bind, MAD_BLOCK_SIZE, NULL);
 
 	if (p_madw == NULL) {
-		osm_log(p_log, OSM_LOG_ERROR,
-			"__osmv_send_sa_req: ERR 0510: "
-			"Unable to acquire MAD.\n");
+		OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0510: "
+			"Unable to acquire MAD\n");
 		status = IB_INSUFFICIENT_RESOURCES;
 		goto Exit;
 	}
@@ -501,16 +481,15 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bind,
 			p_sa_mad_data->method,	/* method */
 			cl_hton64((uint64_t) trans_id),	/* tid */
 			p_sa_mad_data->attr_id,	/* attr id */
-			p_sa_mad_data->attr_mod	/* attr mod */
-	    );
+			p_sa_mad_data->attr_mod	/* attr mod */);
 
 	/* Set the query information. */
 	p_sa_mad->sm_key = p_query_req->sm_key;
 	p_sa_mad->attr_offset = 0;
 	p_sa_mad->comp_mask = p_sa_mad_data->comp_mask;
 	if (p_sa_mad->comp_mask) {
-		memcpy(p_sa_mad->data, p_sa_mad_data->p_attr,
-		       ib_get_attr_size(p_sa_mad_data->attr_offset));
+		p_sa_mad_data->attr_offset ? (sa_size = ib_get_attr_size(p_sa_mad_data->attr_offset)) : (sa_size = IB_SA_DATA_SIZE);
+		memcpy(p_sa_mad->data, p_sa_mad_data->p_attr, sa_size);
 	}
 
 	/*
@@ -524,15 +503,13 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bind,
 #endif
 	p_madw->mad_addr.addr_type.smi.source_lid = cl_hton16(p_bind->lid);
 	p_madw->mad_addr.addr_type.gsi.remote_qp = CL_HTON32(1);
-	p_madw->mad_addr.addr_type.gsi.remote_qkey = IB_QP1_WELL_KNOWN_Q_KEY;
-	p_madw->mad_addr.addr_type.gsi.pkey_ix = 0;
 	p_madw->resp_expected = TRUE;
 	p_madw->fail_msg = CL_DISP_MSGID_NONE;
 
 	/*
 	   Provide MAD context such that the call back will know what to do.
 	   We have to keep the entire request structure so we know the CB.
-	   Since we can not rely on the client to keep it arroud until
+	   Since we can not rely on the client to keep it around until
 	   the response - we duplicate it and will later dispose it (in CB).
 	   To store on the MADW we cast it into what opensm has:
 	   p_madw->context.arb_context.context1
@@ -557,8 +534,7 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bind,
 
 	/* if synchronous - wait on the event */
 	if (sync) {
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"__osmv_send_sa_req: " "Waiting for async event.\n");
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "Waiting for async event\n");
 		cl_event_wait_on(&p_bind->sync_event, EVENT_NO_TIMEOUT, FALSE);
 		cl_event_reset(&p_bind->sync_event);
 		status = p_madw->status;
@@ -589,6 +565,10 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 	osmv_sa_mad_data_t sa_mad_data;
 	osmv_sa_bind_info_t *p_bind = (osmv_sa_bind_info_t *) h_bind;
 	osmv_user_query_t *p_user_query;
+#ifdef DUAL_SIDED_RMPP
+	osmv_multipath_req_t *p_mpr_req;
+	int i, j;
+#endif
 	osm_log_t *p_log = p_bind->p_log;
 	ib_api_status_t status;
 
@@ -597,17 +577,21 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 	/* Set the request information. */
 	sa_mad_data.method = IB_MAD_METHOD_GETTABLE;
 	sa_mad_data.attr_mod = 0;
+	sa_mad_data.attr_offset = 0;
 
 	/* Set the MAD attributes and component mask correctly. */
 	switch (p_query_req->query_type) {
 
 	case OSMV_QUERY_USER_DEFINED:
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s", "USER_DEFINED\n");
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 USER_DEFINED\n");
 		p_user_query = (osmv_user_query_t *) p_query_req->p_query_input;
 		if (p_user_query->method)
 			sa_mad_data.method = p_user_query->method;
-		sa_mad_data.attr_offset = p_user_query->attr_offset;
+#ifdef DUAL_SIDED_RMPP
+		if (sa_mad_data.method == IB_MAD_METHOD_GETMULTI ||
+		    sa_mad_data.method == IB_MAD_METHOD_GETTRACETABLE)
+			sa_mad_data.attr_offset = p_user_query->attr_offset;
+#endif
 		sa_mad_data.attr_id = p_user_query->attr_id;
 		sa_mad_data.attr_mod = p_user_query->attr_mod;
 		sa_mad_data.comp_mask = p_user_query->comp_mask;
@@ -615,73 +599,51 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		break;
 
 	case OSMV_QUERY_ALL_SVC_RECS:
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s", "SVC_REC_BY_NAME\n");
-		sa_mad_data.method = IB_MAD_METHOD_GETTABLE;
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 SVC_REC_BY_NAME\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_SERVICE_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_service_record_t));
 		sa_mad_data.comp_mask = 0;
 		sa_mad_data.p_attr = &u.svc_rec;
 		break;
 
 	case OSMV_QUERY_SVC_REC_BY_NAME:
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s", "SVC_REC_BY_NAME\n");
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 SVC_REC_BY_NAME\n");
 		sa_mad_data.method = IB_MAD_METHOD_GET;
 		sa_mad_data.attr_id = IB_MAD_ATTR_SERVICE_RECORD;
 		sa_mad_data.comp_mask = IB_SR_COMPMASK_SNAME;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_service_record_t));
 		sa_mad_data.p_attr = &u.svc_rec;
 		memcpy(u.svc_rec.service_name, p_query_req->p_query_input,
 		       sizeof(ib_svc_name_t));
 		break;
 
 	case OSMV_QUERY_SVC_REC_BY_ID:
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s", "SVC_REC_BY_ID\n");
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 SVC_REC_BY_ID\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_SERVICE_RECORD;
 		sa_mad_data.comp_mask = IB_SR_COMPMASK_SID;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_service_record_t));
 		sa_mad_data.p_attr = &u.svc_rec;
 		u.svc_rec.service_id =
 		    *(ib_net64_t *) (p_query_req->p_query_input);
 		break;
 
 	case OSMV_QUERY_CLASS_PORT_INFO:
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s", "CLASS_PORT_INFO\n");
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 CLASS_PORT_INFO\n");
 		sa_mad_data.method = IB_MAD_METHOD_GET;
 		sa_mad_data.attr_id = IB_MAD_ATTR_CLASS_PORT_INFO;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_class_port_info_t));
 		sa_mad_data.comp_mask = 0;
 		sa_mad_data.p_attr = &u.class_port_info;
-
 		break;
 
 	case OSMV_QUERY_NODE_REC_BY_NODE_GUID:
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s", "NODE_REC_BY_NODE_GUID\n");
-		sa_mad_data.method = IB_MAD_METHOD_GETTABLE;
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 NODE_REC_BY_NODE_GUID\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_NODE_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_node_record_t));
 		sa_mad_data.comp_mask = IB_NR_COMPMASK_NODEGUID;
 		sa_mad_data.p_attr = &u.node_rec;
 		u.node_rec.node_info.node_guid =
 		    *(ib_net64_t *) (p_query_req->p_query_input);
-
 		break;
 
 	case OSMV_QUERY_PORT_REC_BY_LID:
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s", "PORT_REC_BY_LID\n");
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 PORT_REC_BY_LID\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_PORTINFO_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_portinfo_record_t));
 		sa_mad_data.comp_mask = IB_PIR_COMPMASK_LID;
 		sa_mad_data.p_attr = &u.port_info;
 		u.port_info.lid = *(ib_net16_t *) (p_query_req->p_query_input);
@@ -690,12 +652,8 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 	case OSMV_QUERY_PORT_REC_BY_LID_AND_NUM:
 		sa_mad_data.method = IB_MAD_METHOD_GET;
 		p_user_query = (osmv_user_query_t *) p_query_req->p_query_input;
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s",
-			"PORT_REC_BY_LID_AND_NUM\n");
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 PORT_REC_BY_LID_AND_NUM\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_PORTINFO_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_portinfo_record_t));
 		sa_mad_data.comp_mask =
 		    IB_PIR_COMPMASK_LID | IB_PIR_COMPMASK_PORTNUM;
 		sa_mad_data.p_attr = p_user_query->p_attr;
@@ -704,12 +662,8 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 	case OSMV_QUERY_VLARB_BY_LID_PORT_BLOCK:
 		sa_mad_data.method = IB_MAD_METHOD_GET;
 		p_user_query = (osmv_user_query_t *) p_query_req->p_query_input;
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s",
-			"OSMV_QUERY_VLARB_BY_LID_PORT_BLOCK\n");
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 OSMV_QUERY_VLARB_BY_LID_PORT_BLOCK\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_VLARB_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_vl_arb_table_record_t));
 		sa_mad_data.comp_mask =
 		    IB_VLA_COMPMASK_LID | IB_VLA_COMPMASK_OUT_PORT |
 		    IB_VLA_COMPMASK_BLOCK;
@@ -719,12 +673,8 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 	case OSMV_QUERY_SLVL_BY_LID_AND_PORTS:
 		sa_mad_data.method = IB_MAD_METHOD_GET;
 		p_user_query = (osmv_user_query_t *) p_query_req->p_query_input;
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s",
-			"OSMV_QUERY_VLARB_BY_LID_PORT_BLOCK\n");
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 OSMV_QUERY_VLARB_BY_LID_PORT_BLOCK\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_SLVL_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_slvl_table_record_t));
 		sa_mad_data.comp_mask =
 		    IB_SLVL_COMPMASK_LID | IB_SLVL_COMPMASK_OUT_PORT |
 		    IB_SLVL_COMPMASK_IN_PORT;
@@ -732,12 +682,9 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		break;
 
 	case OSMV_QUERY_PATH_REC_BY_PORT_GUIDS:
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s", "PATH_REC_BY_PORT_GUIDS\n");
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 PATH_REC_BY_PORT_GUIDS\n");
 		memset(&u.path_rec, 0, sizeof(ib_path_rec_t));
 		sa_mad_data.attr_id = IB_MAD_ATTR_PATH_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_path_rec_t));
 		sa_mad_data.comp_mask =
 		    (IB_PR_COMPMASK_DGID | IB_PR_COMPMASK_SGID | IB_PR_COMPMASK_NUMBPATH);
 		u.path_rec.num_path = 0x7f;
@@ -753,14 +700,11 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		break;
 
 	case OSMV_QUERY_PATH_REC_BY_GIDS:
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s", "PATH_REC_BY_GIDS\n");
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 PATH_REC_BY_GIDS\n");
 		memset(&u.path_rec, 0, sizeof(ib_path_rec_t));
 		sa_mad_data.attr_id = IB_MAD_ATTR_PATH_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_path_rec_t));
 		sa_mad_data.comp_mask =
-		  (IB_PR_COMPMASK_DGID | IB_PR_COMPMASK_SGID | IB_PR_COMPMASK_NUMBPATH);
+		    (IB_PR_COMPMASK_DGID | IB_PR_COMPMASK_SGID | IB_PR_COMPMASK_NUMBPATH);
 		u.path_rec.num_path = 0x7f;
 		sa_mad_data.p_attr = &u.path_rec;
 		memcpy(&u.path_rec.dgid,
@@ -772,13 +716,10 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		break;
 
 	case OSMV_QUERY_PATH_REC_BY_LIDS:
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s", "PATH_REC_BY_LIDS\n");
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 PATH_REC_BY_LIDS\n");
 		memset(&u.path_rec, 0, sizeof(ib_path_rec_t));
 		sa_mad_data.method = IB_MAD_METHOD_GET;
 		sa_mad_data.attr_id = IB_MAD_ATTR_PATH_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_path_rec_t));
 		sa_mad_data.comp_mask =
 		    (IB_PR_COMPMASK_DLID | IB_PR_COMPMASK_SLID);
 		sa_mad_data.p_attr = &u.path_rec;
@@ -792,12 +733,8 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 	case OSMV_QUERY_UD_MULTICAST_SET:
 		sa_mad_data.method = IB_MAD_METHOD_SET;
 		p_user_query = (osmv_user_query_t *) p_query_req->p_query_input;
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s",
-			"OSMV_QUERY_UD_MULTICAST_SET\n");
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 OSMV_QUERY_UD_MULTICAST_SET\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_MCMEMBER_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_member_rec_t));
 		sa_mad_data.comp_mask = p_user_query->comp_mask;
 		sa_mad_data.p_attr = p_user_query->p_attr;
 		break;
@@ -805,19 +742,54 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 	case OSMV_QUERY_UD_MULTICAST_DELETE:
 		sa_mad_data.method = IB_MAD_METHOD_DELETE;
 		p_user_query = (osmv_user_query_t *) p_query_req->p_query_input;
-		osm_log(p_log, OSM_LOG_DEBUG,
-			"osmv_query_sa DBG:001 %s",
-			"OSMV_QUERY_UD_MULTICAST_DELETE\n");
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 OSMV_QUERY_UD_MULTICAST_DELETE\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_MCMEMBER_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_member_rec_t));
 		sa_mad_data.comp_mask = p_user_query->comp_mask;
 		sa_mad_data.p_attr = p_user_query->p_attr;
 		break;
 
+#ifdef DUAL_SIDED_RMPP
+	case OSMV_QUERY_MULTIPATH_REC:
+		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 MULTIPATH_REC\n");
+		/* Validate sgid/dgid counts against SA client limit */
+		p_mpr_req = (osmv_multipath_req_t *) p_query_req->p_query_input;
+		if (p_mpr_req->sgid_count + p_mpr_req->dgid_count >
+		    IB_MULTIPATH_MAX_GIDS) {
+			OSM_LOG(p_log, OSM_LOG_ERROR, "DBG:001 MULTIPATH_REC "
+				"SGID count %d DGID count %d max count %d\n",
+				p_mpr_req->sgid_count, p_mpr_req->dgid_count,
+				IB_MULTIPATH_MAX_GIDS);
+			CL_ASSERT(0);
+			return IB_ERROR;
+		}
+		memset(&u.multipath_rec, 0, sizeof(ib_multipath_rec_t));
+		sa_mad_data.method = IB_MAD_METHOD_GETMULTI;
+		sa_mad_data.attr_id = IB_MAD_ATTR_MULTIPATH_RECORD;
+		sa_mad_data.attr_offset =
+		    ib_get_attr_offset(sizeof(ib_multipath_rec_t));
+		sa_mad_data.p_attr = &u.multipath_rec;
+		sa_mad_data.comp_mask = p_mpr_req->comp_mask;
+		u.multipath_rec.num_path = p_mpr_req->num_path;
+		if (p_mpr_req->reversible)
+			u.multipath_rec.num_path |= 0x80;
+		else
+			u.multipath_rec.num_path &= ~0x80;
+		u.multipath_rec.pkey = p_mpr_req->pkey;
+		ib_multipath_rec_set_sl(&u.multipath_rec, p_mpr_req->sl);
+		ib_multipath_rec_set_qos_class(&u.multipath_rec, 0);
+		u.multipath_rec.independence = p_mpr_req->independence;
+		u.multipath_rec.sgid_count = p_mpr_req->sgid_count;
+		u.multipath_rec.dgid_count = p_mpr_req->dgid_count;
+		j = 0;
+		for (i = 0; i < p_mpr_req->sgid_count; i++, j++)
+			u.multipath_rec.gids[j] = p_mpr_req->gids[j];
+		for (i = 0; i < p_mpr_req->dgid_count; i++, j++)
+			u.multipath_rec.gids[j] = p_mpr_req->gids[j];
+		break;
+#endif
+
 	default:
-		osm_log(p_log, OSM_LOG_ERROR,
-			"osmv_query_sa DBG:001 %s", "UNKNOWN\n");
+		OSM_LOG(p_log, OSM_LOG_ERROR, "DBG:001 UNKNOWN\n");
 		CL_ASSERT(0);
 		return IB_ERROR;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
