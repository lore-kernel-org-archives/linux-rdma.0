From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH][TRIVIAL] Add attribute information to SA request error
 messages
Date: Thu, 6 Jun 2013 07:35:45 -0700 (PDT)
Message-ID: <5c35d4ce-f8db-44f0-ac6f-b61144006d43@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/opensm/osm_sa_class_port_info.c b/opensm/osm_sa_class_port_info.c
index 2682505..69abad5 100644
--- a/opensm/osm_sa_class_port_info.c
+++ b/opensm/osm_sa_class_port_info.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2008 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -201,7 +202,7 @@ void osm_cpi_rcv_process(IN void *context, IN void *data)
 	/* we only support GET */
 	if (p_sa_mad->method != IB_MAD_METHOD_GET) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1403: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for ClassPortInfo request\n",
 			ib_get_sa_method_str(p_sa_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_REQ_INVALID);
 		goto Exit;
diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index a00b257..8323b38 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2006-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2012 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -797,7 +798,7 @@ void osm_gir_rcv_process(IN void *ctx, IN void *data)
 		break;
 	default:
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5105: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for GUIDInfoRecord request\n",
 			ib_get_sa_method_str(p_rcvd_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		break;
diff --git a/opensm/osm_sa_lft_record.c b/opensm/osm_sa_lft_record.c
index 3be20f3..cf651ef 100644
--- a/opensm/osm_sa_lft_record.c
+++ b/opensm/osm_sa_lft_record.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005,2008 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -197,7 +198,7 @@ void osm_lftr_rcv_process(IN void *ctx, IN void *data)
 	if (p_rcvd_mad->method != IB_MAD_METHOD_GET &&
 	    p_rcvd_mad->method != IB_MAD_METHOD_GETTABLE) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4408: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for LFTRecord request\n",
 			ib_get_sa_method_str(p_rcvd_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		goto Exit;
diff --git a/opensm/osm_sa_link_record.c b/opensm/osm_sa_link_record.c
index eec952d..5073f96 100644
--- a/opensm/osm_sa_link_record.c
+++ b/opensm/osm_sa_link_record.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -436,7 +437,7 @@ void osm_lr_rcv_process(IN void *context, IN void *data)
 	if (p_sa_mad->method != IB_MAD_METHOD_GET &&
 	    p_sa_mad->method != IB_MAD_METHOD_GETTABLE) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1804: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for LinkRecord request\n",
 			ib_get_sa_method_str(p_sa_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		goto Exit;
diff --git a/opensm/osm_sa_mft_record.c b/opensm/osm_sa_mft_record.c
index 2eca1f0..6f9763f 100644
--- a/opensm/osm_sa_mft_record.c
+++ b/opensm/osm_sa_mft_record.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -230,7 +231,7 @@ void osm_mftr_rcv_process(IN void *ctx, IN void *data)
 	if (p_rcvd_mad->method != IB_MAD_METHOD_GET &&
 	    p_rcvd_mad->method != IB_MAD_METHOD_GETTABLE) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4A08: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for MFTRecord request\n",
 			ib_get_sa_method_str(p_rcvd_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		goto Exit;
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index bde993c..9030278 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -1562,7 +1562,7 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 	/* we only support SubnAdmGetMulti method */
 	if (p_sa_mad->method != IB_MAD_METHOD_GETMULTI) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4513: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for MultiPathRecord request\n",
 			ib_get_sa_method_str(p_sa_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		goto Exit;
diff --git a/opensm/osm_sa_node_record.c b/opensm/osm_sa_node_record.c
index 709d8ad..19c7cc3 100644
--- a/opensm/osm_sa_node_record.c
+++ b/opensm/osm_sa_node_record.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -87,7 +88,7 @@ static ib_api_status_t nr_rcv_new_nr(osm_sa_t * sa,
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"New NodeRecord: node 0x%016" PRIx64
-		"\n\t\t\t\tport 0x%016" PRIx64 ", lid %u\n",
+		", port 0x%016" PRIx64 ", lid %u\n",
 		cl_ntoh64(osm_node_get_node_guid(p_node)),
 		cl_ntoh64(port_guid), cl_ntoh16(lid));
 
@@ -305,7 +306,7 @@ void osm_nr_rcv_process(IN void *ctx, IN void *data)
 	if (p_rcvd_mad->method != IB_MAD_METHOD_GET &&
 	    p_rcvd_mad->method != IB_MAD_METHOD_GETTABLE) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1D05: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for NodeRecord request\n",
 			ib_get_sa_method_str(p_rcvd_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		goto Exit;
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 1bec16d..c14bf15 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -6,6 +6,7 @@
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  * Copyright (c) 2010 Sun Microsystems, Inc. All rights reserved.
  * Copyright (c) 2009-2011 ZIH, TU Dresden, Federal Republic of Germany. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -1702,7 +1703,7 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 	if (p_sa_mad->method != IB_MAD_METHOD_GET &&
 	    p_sa_mad->method != IB_MAD_METHOD_GETTABLE) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F17: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for PathRecord request\n",
 			ib_get_sa_method_str(p_sa_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		goto Exit;
diff --git a/opensm/osm_sa_pkey_record.c b/opensm/osm_sa_pkey_record.c
index 4c4dd13..586c3eb 100644
--- a/opensm/osm_sa_pkey_record.c
+++ b/opensm/osm_sa_pkey_record.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -237,7 +238,7 @@ void osm_pkey_rec_rcv_process(IN void *ctx, IN void *data)
 	if (p_rcvd_mad->method != IB_MAD_METHOD_GET &&
 	    p_rcvd_mad->method != IB_MAD_METHOD_GETTABLE) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4605: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for PKeyRecord request\n",
 			ib_get_sa_method_str(p_rcvd_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		goto Exit;
@@ -251,8 +252,8 @@ void osm_pkey_rec_rcv_process(IN void *ctx, IN void *data)
 	if (p_rcvd_mad->sm_key != sa->p_subn->opt.sa_key) {
 		/* This is not a trusted requester! */
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4608: "
-			"Request from non-trusted requester: "
-			"Given SM_Key:0x%016" PRIx64 "\n",
+			"Ignoring PKeyRecord request from non-trusted requester"
+			" with SM_Key 0x%016" PRIx64 "\n",
 			cl_ntoh64(p_rcvd_mad->sm_key));
 		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_REQ_INVALID);
 		goto Exit;
diff --git a/opensm/osm_sa_portinfo_record.c b/opensm/osm_sa_portinfo_record.c
index 39ea51d..78d8d16 100644
--- a/opensm/osm_sa_portinfo_record.c
+++ b/opensm/osm_sa_portinfo_record.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -531,7 +532,7 @@ void osm_pir_rcv_process(IN void *ctx, IN void *data)
 	if (p_rcvd_mad->method != IB_MAD_METHOD_GET &&
 	    p_rcvd_mad->method != IB_MAD_METHOD_GETTABLE) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2105: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for PortInfoRecord request\n",
 			ib_get_sa_method_str(p_rcvd_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		goto Exit;
@@ -576,7 +577,7 @@ void osm_pir_rcv_process(IN void *ctx, IN void *data)
 			sa_pir_by_comp_mask(sa, p_port->p_node, &context);
 		else
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2109: "
-				"No port found with LID %u\n",
+				"No port found with requested LID %u\n",
 				cl_ntoh16(p_rcvd_rec->lid));
 	} else
 		cl_qmap_apply_func(&sa->p_subn->node_guid_tbl,
diff --git a/opensm/osm_sa_service_record.c b/opensm/osm_sa_service_record.c
index 6121518..c2c6ea9 100644
--- a/opensm/osm_sa_service_record.c
+++ b/opensm/osm_sa_service_record.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -556,7 +557,7 @@ static void sr_rcv_process_set_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 			cl_plock_release(sa->p_lock);
 
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2411: "
-				"osm_svcr_get_by_rid failed\n");
+				"Failed to create new service record\n");
 
 			osm_sa_send_error(sa, p_madw,
 					  IB_SA_MAD_STATUS_NO_RESOURCES);
@@ -711,7 +712,7 @@ void osm_sr_rcv_process(IN void *context, IN void *data)
 		break;
 	default:
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for ServiceRecord request\n",
 			ib_get_sa_method_str(p_sa_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		break;
diff --git a/opensm/osm_sa_slvl_record.c b/opensm/osm_sa_slvl_record.c
index d3b48af..467ac0b 100644
--- a/opensm/osm_sa_slvl_record.c
+++ b/opensm/osm_sa_slvl_record.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -225,7 +226,7 @@ void osm_slvl_rec_rcv_process(IN void *ctx, IN void *data)
 	if (p_rcvd_mad->method != IB_MAD_METHOD_GET &&
 	    p_rcvd_mad->method != IB_MAD_METHOD_GETTABLE) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2604: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for SL2VLRecord request\n",
 			ib_get_sa_method_str(p_rcvd_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		goto Exit;
diff --git a/opensm/osm_sa_sminfo_record.c b/opensm/osm_sa_sminfo_record.c
index 99bb5ab..995dc9d 100644
--- a/opensm/osm_sa_sminfo_record.c
+++ b/opensm/osm_sa_sminfo_record.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -201,7 +202,7 @@ void osm_smir_rcv_process(IN void *ctx, IN void *data)
 	if (sad_mad->method != IB_MAD_METHOD_GET &&
 	    sad_mad->method != IB_MAD_METHOD_GETTABLE) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2804: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for SMInfoRecord request\n",
 			ib_get_sa_method_str(sad_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		goto Exit;
diff --git a/opensm/osm_sa_sw_info_record.c b/opensm/osm_sa_sw_info_record.c
index 1ce1230..7d518fe 100644
--- a/opensm/osm_sa_sw_info_record.c
+++ b/opensm/osm_sa_sw_info_record.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -215,7 +216,7 @@ void osm_sir_rcv_process(IN void *ctx, IN void *data)
 	if (sad_mad->method != IB_MAD_METHOD_GET &&
 	    sad_mad->method != IB_MAD_METHOD_GETTABLE) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5305: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for SwithInfoRecord request\n",
 			ib_get_sa_method_str(sad_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		goto Exit;
diff --git a/opensm/osm_sa_vlarb_record.c b/opensm/osm_sa_vlarb_record.c
index 24652a0..17b21a5 100644
--- a/opensm/osm_sa_vlarb_record.c
+++ b/opensm/osm_sa_vlarb_record.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -232,7 +233,7 @@ void osm_vlarb_rec_rcv_process(IN void *ctx, IN void *data)
 	if (sad_mad->method != IB_MAD_METHOD_GET &&
 	    sad_mad->method != IB_MAD_METHOD_GETTABLE) {
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2A05: "
-			"Unsupported Method (%s)\n",
+			"Unsupported Method (%s) for a VLArbRecord request\n",
 			ib_get_sa_method_str(sad_mad->method));
 		osm_sa_send_error(sa, p_madw, IB_MAD_STATUS_UNSUP_METHOD_ATTR);
 		goto Exit;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
