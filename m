From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] osmtest/SA client: Only set attribute offset for RMPP
	operations
Date: Fri, 27 Aug 2010 08:37:17 -0400
Message-ID: <20100827123717.GA15888@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/libvendor/osm_vendor_ibumad_sa.c b/opensm/libvendor/osm_vendor_ibumad_sa.c
index 3a7d54a..a81a6b7 100644
--- a/opensm/libvendor/osm_vendor_ibumad_sa.c
+++ b/opensm/libvendor/osm_vendor_ibumad_sa.c
@@ -2,7 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2007,2009 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
- * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2009,2010 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -342,6 +342,7 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bind,
 	static atomic32_t trans_id;
 	boolean_t sync;
 	osmv_query_req_t *p_query_req_copy;
+	uint32_t sa_size;
 
 	OSM_LOG_ENTER(p_log);
 
@@ -401,8 +402,8 @@ __osmv_send_sa_req(IN osmv_sa_bind_info_t * p_bind,
 		p_sa_mad->rmpp_flags = IB_RMPP_FLAG_ACTIVE;
 #endif
 	if (p_sa_mad->comp_mask) {
-		memcpy(p_sa_mad->data, p_sa_mad_data->p_attr,
-		       ib_get_attr_size(p_sa_mad_data->attr_offset));
+		p_sa_mad_data->attr_offset ? (sa_size = ib_get_attr_size(p_sa_mad_data->attr_offset)) : (sa_size = IB_SA_DATA_SIZE);
+		memcpy(p_sa_mad->data, p_sa_mad_data->p_attr, sa_size);
 	}
 
 	/*
@@ -488,6 +489,7 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 	/* Set the request information. */
 	sa_mad_data.method = IB_MAD_METHOD_GETTABLE;
 	sa_mad_data.attr_mod = 0;
+	sa_mad_data.attr_offset = 0;
 
 	/* Set the MAD attributes and component mask correctly. */
 	switch (p_query_req->query_type) {
@@ -497,7 +499,11 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
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
@@ -507,8 +513,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 	case OSMV_QUERY_ALL_SVC_RECS:
 		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 SVC_REC_BY_NAME\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_SERVICE_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_service_record_t));
 		sa_mad_data.comp_mask = 0;
 		sa_mad_data.p_attr = &u.svc_rec;
 		break;
@@ -518,8 +522,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		sa_mad_data.method = IB_MAD_METHOD_GET;
 		sa_mad_data.attr_id = IB_MAD_ATTR_SERVICE_RECORD;
 		sa_mad_data.comp_mask = IB_SR_COMPMASK_SNAME;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_service_record_t));
 		sa_mad_data.p_attr = &u.svc_rec;
 		memcpy(u.svc_rec.service_name, p_query_req->p_query_input,
 		       sizeof(ib_svc_name_t));
@@ -529,8 +531,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 SVC_REC_BY_ID\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_SERVICE_RECORD;
 		sa_mad_data.comp_mask = IB_SR_COMPMASK_SID;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_service_record_t));
 		sa_mad_data.p_attr = &u.svc_rec;
 		u.svc_rec.service_id =
 		    *(ib_net64_t *) (p_query_req->p_query_input);
@@ -540,8 +540,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 CLASS_PORT_INFO\n");
 		sa_mad_data.method = IB_MAD_METHOD_GET;
 		sa_mad_data.attr_id = IB_MAD_ATTR_CLASS_PORT_INFO;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_class_port_info_t));
 		sa_mad_data.comp_mask = 0;
 		sa_mad_data.p_attr = &u.class_port_info;
 		break;
@@ -549,8 +547,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 	case OSMV_QUERY_NODE_REC_BY_NODE_GUID:
 		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 NODE_REC_BY_NODE_GUID\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_NODE_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_node_record_t));
 		sa_mad_data.comp_mask = IB_NR_COMPMASK_NODEGUID;
 		sa_mad_data.p_attr = &u.node_rec;
 		u.node_rec.node_info.node_guid =
@@ -560,8 +556,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 	case OSMV_QUERY_PORT_REC_BY_LID:
 		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 PORT_REC_BY_LID\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_PORTINFO_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_portinfo_record_t));
 		sa_mad_data.comp_mask = IB_PIR_COMPMASK_LID;
 		sa_mad_data.p_attr = &u.port_info;
 		u.port_info.lid = *(ib_net16_t *) (p_query_req->p_query_input);
@@ -572,8 +566,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		p_user_query = (osmv_user_query_t *) p_query_req->p_query_input;
 		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 PORT_REC_BY_LID_AND_NUM\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_PORTINFO_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_portinfo_record_t));
 		sa_mad_data.comp_mask =
 		    IB_PIR_COMPMASK_LID | IB_PIR_COMPMASK_PORTNUM;
 		sa_mad_data.p_attr = p_user_query->p_attr;
@@ -584,8 +576,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		p_user_query = (osmv_user_query_t *) p_query_req->p_query_input;
 		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 OSMV_QUERY_VLARB_BY_LID_PORT_BLOCK\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_VLARB_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_vl_arb_table_record_t));
 		sa_mad_data.comp_mask =
 		    IB_VLA_COMPMASK_LID | IB_VLA_COMPMASK_OUT_PORT |
 		    IB_VLA_COMPMASK_BLOCK;
@@ -597,8 +587,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		p_user_query = (osmv_user_query_t *) p_query_req->p_query_input;
 		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 OSMV_QUERY_VLARB_BY_LID_PORT_BLOCK\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_SLVL_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_slvl_table_record_t));
 		sa_mad_data.comp_mask =
 		    IB_SLVL_COMPMASK_LID | IB_SLVL_COMPMASK_OUT_PORT |
 		    IB_SLVL_COMPMASK_IN_PORT;
@@ -609,8 +597,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 PATH_REC_BY_PORT_GUIDS\n");
 		memset(&u.path_rec, 0, sizeof(ib_path_rec_t));
 		sa_mad_data.attr_id = IB_MAD_ATTR_PATH_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_path_rec_t));
 		sa_mad_data.comp_mask =
 		    (IB_PR_COMPMASK_DGID | IB_PR_COMPMASK_SGID | IB_PR_COMPMASK_NUMBPATH);
 		u.path_rec.num_path = 0x7f;
@@ -629,8 +615,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 PATH_REC_BY_GIDS\n");
 		memset(&u.path_rec, 0, sizeof(ib_path_rec_t));
 		sa_mad_data.attr_id = IB_MAD_ATTR_PATH_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_path_rec_t));
 		sa_mad_data.comp_mask =
 		    (IB_PR_COMPMASK_DGID | IB_PR_COMPMASK_SGID | IB_PR_COMPMASK_NUMBPATH);
 		u.path_rec.num_path = 0x7f;
@@ -648,8 +632,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		memset(&u.path_rec, 0, sizeof(ib_path_rec_t));
 		sa_mad_data.method = IB_MAD_METHOD_GET;
 		sa_mad_data.attr_id = IB_MAD_ATTR_PATH_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_path_rec_t));
 		sa_mad_data.comp_mask =
 		    (IB_PR_COMPMASK_DLID | IB_PR_COMPMASK_SLID);
 		sa_mad_data.p_attr = &u.path_rec;
@@ -665,8 +647,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		p_user_query = (osmv_user_query_t *) p_query_req->p_query_input;
 		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 OSMV_QUERY_UD_MULTICAST_SET\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_MCMEMBER_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_member_rec_t));
 		sa_mad_data.comp_mask = p_user_query->comp_mask;
 		sa_mad_data.p_attr = p_user_query->p_attr;
 		break;
@@ -676,8 +656,6 @@ osmv_query_sa(IN osm_bind_handle_t h_bind,
 		p_user_query = (osmv_user_query_t *) p_query_req->p_query_input;
 		OSM_LOG(p_log, OSM_LOG_DEBUG, "DBG:001 OSMV_QUERY_UD_MULTICAST_DELETE\n");
 		sa_mad_data.attr_id = IB_MAD_ATTR_MCMEMBER_RECORD;
-		sa_mad_data.attr_offset =
-		    ib_get_attr_offset(sizeof(ib_member_rec_t));
 		sa_mad_data.comp_mask = p_user_query->comp_mask;
 		sa_mad_data.p_attr = p_user_query->p_attr;
 		break;
diff --git a/opensm/osmtest/osmt_multicast.c b/opensm/osmtest/osmt_multicast.c
index 34422b7..5c938b5 100644
--- a/opensm/osmtest/osmt_multicast.c
+++ b/opensm/osmtest/osmt_multicast.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005,2008 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2010 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -65,7 +66,6 @@ static void __osmt_print_all_multicast_records(IN osmtest_t * const p_osmt)
 	memset(&user, 0, sizeof(user));
 
 	user.attr_id = IB_MAD_ATTR_MCMEMBER_RECORD;
-	user.attr_offset = ib_get_attr_offset(sizeof(*mcast_record));
 
 	req.query_type = OSMV_QUERY_USER_DEFINED;
 	req.timeout_ms = p_osmt->opt.transaction_timeout;
@@ -167,7 +167,6 @@ ib_api_status_t osmt_query_mcast(IN osmtest_t * const p_osmt)
 
 	context.p_osmt = p_osmt;
 	user.attr_id = IB_MAD_ATTR_MCMEMBER_RECORD;
-	user.attr_offset = ib_get_attr_offset(sizeof(ib_member_rec_t));
 
 	req.query_type = OSMV_QUERY_USER_DEFINED;
 	req.timeout_ms = p_osmt->opt.transaction_timeout;
@@ -303,14 +302,12 @@ osmt_send_mcast_request(IN osmtest_t * const p_osmt,
 		req.query_type = OSMV_QUERY_USER_DEFINED;
 		user.method = IB_MAD_METHOD_GET;
 		user.attr_id = IB_MAD_ATTR_MCMEMBER_RECORD;
-		user.attr_offset = ib_get_attr_offset(sizeof(ib_member_rec_t));
 	} else if (is_set == 0xff) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_VERBOSE,
 			"Set USER DEFINED QUERY\n");
 		req.query_type = OSMV_QUERY_USER_DEFINED;
 		user.method = IB_MAD_METHOD_SET;
 		user.attr_id = IB_MAD_ATTR_MCMEMBER_RECORD;
-		user.attr_offset = ib_get_attr_offset(sizeof(ib_member_rec_t));
 	}
 
 	/* TODO : Check the validity of all user fields in order to use
diff --git a/opensm/osmtest/osmt_service.c b/opensm/osmtest/osmt_service.c
index a203b0c..6f27109 100644
--- a/opensm/osmtest/osmt_service.c
+++ b/opensm/osmtest/osmt_service.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2006-2008 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2010 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -121,7 +122,6 @@ osmt_register_service(IN osmtest_t * const p_osmt,
 		    IB_SR_COMPMASK_SLEASE |
 		    IB_SR_COMPMASK_SKEY | IB_SR_COMPMASK_SNAME;
 	}
-	user.attr_offset = ib_get_attr_offset(sizeof(ib_service_record_t));
 	user.p_attr = &svc_rec;
 
 	status = osmv_query_sa(p_osmt->h_bind, &req);
@@ -226,7 +226,6 @@ osmt_register_service_with_full_key(IN osmtest_t * const p_osmt,
 		    IB_SR_COMPMASK_SLEASE |
 		    IB_SR_COMPMASK_SKEY | IB_SR_COMPMASK_SNAME;
 	}
-	user.attr_offset = ib_get_attr_offset(sizeof(ib_service_record_t));
 	user.p_attr = &svc_rec;
 
 	status = osmv_query_sa(p_osmt->h_bind, &req);
@@ -373,7 +372,6 @@ osmt_register_service_with_data(IN osmtest_t * const p_osmt,
 		    IB_SR_COMPMASK_SDATA32_1 |
 		    IB_SR_COMPMASK_SDATA64_0 | IB_SR_COMPMASK_SDATA64_1;
 	}
-	user.attr_offset = ib_get_attr_offset(sizeof(ib_service_record_t));
 	user.p_attr = &svc_rec;
 
 	/*  Dump to Service Data b4 send */
@@ -486,7 +484,6 @@ osmt_get_service_by_id_and_name(IN osmtest_t * const p_osmt,
 	user.method = IB_MAD_METHOD_GET;
 	user.attr_id = IB_MAD_ATTR_SERVICE_RECORD;
 	user.comp_mask = IB_SR_COMPMASK_SID | IB_SR_COMPMASK_SNAME;
-	user.attr_offset = ib_get_attr_offset(sizeof(ib_service_record_t));
 	user.p_attr = &svc_rec;
 
 	status = osmv_query_sa(p_osmt->h_bind, &req);
@@ -607,7 +604,6 @@ osmt_get_service_by_id(IN osmtest_t * const p_osmt,
 	user.method = IB_MAD_METHOD_GET;
 	user.attr_id = IB_MAD_ATTR_SERVICE_RECORD;
 	user.comp_mask = IB_SR_COMPMASK_SID;
-	user.attr_offset = ib_get_attr_offset(sizeof(ib_service_record_t));
 	user.p_attr = &svc_rec;
 
 	status = osmv_query_sa(p_osmt->h_bind, &req);
@@ -739,7 +735,6 @@ osmt_get_service_by_name_and_key(IN osmtest_t * const p_osmt,
 	user.method = IB_MAD_METHOD_GET;
 	user.attr_id = IB_MAD_ATTR_SERVICE_RECORD;
 	user.comp_mask = IB_SR_COMPMASK_SNAME | IB_SR_COMPMASK_SKEY;
-	user.attr_offset = ib_get_attr_offset(sizeof(ib_service_record_t));
 	user.p_attr = &svc_rec;
 	status = osmv_query_sa(p_osmt->h_bind, &req);
 	if (status != IB_SUCCESS) {
@@ -1092,7 +1087,6 @@ osmt_delete_service_by_name(IN osmtest_t * const p_osmt,
 	user.method = IB_MAD_METHOD_DELETE;
 	user.attr_id = IB_MAD_ATTR_SERVICE_RECORD;
 	user.comp_mask = IB_SR_COMPMASK_SNAME;
-	user.attr_offset = ib_get_attr_offset(sizeof(ib_service_record_t));
 	user.p_attr = &svc_rec;
 
 	status = osmv_query_sa(p_osmt->h_bind, &req);
diff --git a/opensm/osmtest/osmtest.c b/opensm/osmtest/osmtest.c
index d96fb28..af17d15 100644
--- a/opensm/osmtest/osmtest.c
+++ b/opensm/osmtest/osmtest.c
@@ -2,7 +2,7 @@
  * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
- * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2009,2010 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -563,7 +563,6 @@ osmtest_get_all_recs(IN osmtest_t * const p_osmt,
 
 	p_context->p_osmt = p_osmt;
 	user.attr_id = attr_id;
-	user.attr_offset = ib_get_attr_offset((uint16_t) attr_size);
 
 	req.query_type = OSMV_QUERY_USER_DEFINED;
 	req.timeout_ms = p_osmt->opt.transaction_timeout;
@@ -719,7 +718,6 @@ osmtest_get_node_rec(IN osmtest_t * const p_osmt,
 	p_context->p_osmt = p_osmt;
 	user.comp_mask = IB_NR_COMPMASK_NODEGUID;
 	user.attr_id = IB_MAD_ATTR_NODE_RECORD;
-	user.attr_offset = ib_get_attr_offset((uint16_t) sizeof(record));
 	user.p_attr = &record;
 
 	req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -793,7 +791,6 @@ osmtest_get_node_rec_by_lid(IN osmtest_t * const p_osmt,
 	p_context->p_osmt = p_osmt;
 	user.comp_mask = IB_NR_COMPMASK_LID;
 	user.attr_id = IB_MAD_ATTR_NODE_RECORD;
-	user.attr_offset = ib_get_attr_offset((uint16_t) sizeof(record));
 	user.p_attr = &record;
 
 	req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -1057,7 +1054,6 @@ osmtest_get_port_rec(IN osmtest_t * const p_osmt,
 	p_context->p_osmt = p_osmt;
 	user.comp_mask = IB_PIR_COMPMASK_LID;
 	user.attr_id = IB_MAD_ATTR_PORTINFO_RECORD;
-	user.attr_offset = ib_get_attr_offset((uint16_t) sizeof(record));
 	user.p_attr = &record;
 
 	req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -4171,7 +4167,6 @@ osmtest_get_link_rec_by_lid(IN osmtest_t * const p_osmt,
 	if (to_lid)
 		user.comp_mask |= IB_LR_COMPMASK_TO_LID;
 	user.attr_id = IB_MAD_ATTR_LINK_RECORD;
-	user.attr_offset = ib_get_attr_offset((uint16_t) sizeof(record));
 	user.p_attr = &record;
 
 	req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -4249,7 +4244,6 @@ osmtest_get_guidinfo_rec_by_lid(IN osmtest_t * const p_osmt,
 	p_context->p_osmt = p_osmt;
 	user.comp_mask = IB_GIR_COMPMASK_LID;
 	user.attr_id = IB_MAD_ATTR_GUIDINFO_RECORD;
-	user.attr_offset = ib_get_attr_offset((uint16_t) sizeof(record));
 	user.p_attr = &record;
 
 	req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -4328,7 +4322,6 @@ osmtest_get_pkeytbl_rec_by_lid(IN osmtest_t * const p_osmt,
 	p_context->p_osmt = p_osmt;
 	user.comp_mask = IB_PKEY_COMPMASK_LID;
 	user.attr_id = IB_MAD_ATTR_PKEY_TBL_RECORD;
-	user.attr_offset = ib_get_attr_offset((uint16_t) sizeof(record));
 	user.p_attr = &record;
 
 	req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -4407,7 +4400,6 @@ osmtest_get_sw_info_rec_by_lid(IN osmtest_t * const p_osmt,
 	if (lid)
 		user.comp_mask = IB_SWIR_COMPMASK_LID;
 	user.attr_id = IB_MAD_ATTR_SWITCH_INFO_RECORD;
-	user.attr_offset = ib_get_attr_offset((uint16_t) sizeof(record));
 	user.p_attr = &record;
 
 	req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -4486,7 +4478,6 @@ osmtest_get_lft_rec_by_lid(IN osmtest_t * const p_osmt,
 	if (lid)
 		user.comp_mask = IB_LFTR_COMPMASK_LID;
 	user.attr_id = IB_MAD_ATTR_LFT_RECORD;
-	user.attr_offset = ib_get_attr_offset((uint16_t) sizeof(record));
 	user.p_attr = &record;
 
 	req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -4565,7 +4556,6 @@ osmtest_get_mft_rec_by_lid(IN osmtest_t * const p_osmt,
 	if (lid)
 		user.comp_mask = IB_MFTR_COMPMASK_LID;
 	user.attr_id = IB_MAD_ATTR_MFT_RECORD;
-	user.attr_offset = ib_get_attr_offset((uint16_t) sizeof(record));
 	user.p_attr = &record;
 
 	req.query_type = OSMV_QUERY_USER_DEFINED;
@@ -4637,7 +4627,6 @@ osmtest_sminfo_record_request(IN osmtest_t * const p_osmt,
 
 	p_context->p_osmt = p_osmt;
 	user.attr_id = IB_MAD_ATTR_SMINFO_RECORD;
-	user.attr_offset = ib_get_attr_offset((uint16_t) sizeof(record));
 	p_sm_info_opt = p_options;
 	if (p_sm_info_opt->sm_guid != 0) {
 		record.sm_info.guid = p_sm_info_opt->sm_guid;
@@ -4737,7 +4726,6 @@ osmtest_informinfo_request(IN osmtest_t * const p_osmt,
 	p_context->p_osmt = p_osmt;
 	user.attr_id = attr_id;
 	if (attr_id == IB_MAD_ATTR_INFORM_INFO_RECORD) {
-		user.attr_offset = ib_get_attr_offset((uint16_t) sizeof(record));
 		p_inform_info_rec_opt = p_options;
 		if (p_inform_info_rec_opt->subscriber_gid.unicast.prefix != 0 &&
 		    p_inform_info_rec_opt->subscriber_gid.unicast.
@@ -4751,7 +4739,6 @@ osmtest_informinfo_request(IN osmtest_t * const p_osmt,
 		user.comp_mask |= IB_IIR_COMPMASK_ENUM;
 		user.p_attr = &record;
 	} else {
-		user.attr_offset = ib_get_attr_offset((uint16_t) sizeof(rec));
 		/* comp mask bits below are for InformInfoRecord rather than InformInfo */
 		/* as currently no comp mask bits defined for InformInfo!!! */
 		user.comp_mask = IB_IIR_COMPMASK_SUBSCRIBE;
@@ -4900,7 +4887,6 @@ osmtest_validate_single_node_rec_lid(IN osmtest_t * const p_osmt,
 	context.p_osmt = p_osmt;
 	user.comp_mask = IB_NR_COMPMASK_LID;
 	user.attr_id = IB_MAD_ATTR_NODE_RECORD;
-	user.attr_offset = ib_get_attr_offset((uint16_t) sizeof(record));
 	user.p_attr = &record;
 
 	req.query_type = OSMV_QUERY_USER_DEFINED;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
