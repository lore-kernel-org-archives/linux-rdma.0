From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Some log changes
Date: Mon, 3 Jun 2013 04:40:47 -0700 (PDT)
Message-ID: <8f6acddb-ab5a-419e-a965-3c69301ecb56@default>
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

diff --git a/opensm/osm_lin_fwd_rcv.c b/opensm/osm_lin_fwd_rcv.c
index dd18c09..13d9b72 100644
--- a/opensm/osm_lin_fwd_rcv.c
+++ b/opensm/osm_lin_fwd_rcv.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2002-2005,2008 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -104,8 +105,8 @@ void osm_lft_rcv_process(IN void *context, IN void *data)
 			}
 		} else {
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0402: "
-				"Setting forwarding table block failed (%s)"
-				", Switch 0x%" PRIx64 " %s\n",
+				"Setting forwarding table block %d failed (%s)"
+				", Switch 0x%" PRIx64 " %s\n", block_num,
 				ib_get_err_str(status), cl_ntoh64(node_guid),
 				p_sw->p_node->print_desc);
 		}
diff --git a/opensm/osm_node_desc_rcv.c b/opensm/osm_node_desc_rcv.c
index 065909b..546ffed 100644
--- a/opensm/osm_node_desc_rcv.c
+++ b/opensm/osm_node_desc_rcv.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2007 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -87,7 +88,7 @@ static void nd_rcv_process_nd(IN osm_sm_t * sm, IN osm_node_t * p_node,
 #endif				/* ENABLE_OSM_PERF_MGR */
 
 	OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
-		"Node 0x%" PRIx64 "\n\t\t\t\tDescription = %s\n",
+		"Node 0x%" PRIx64 ", Description = %s\n",
 		cl_ntoh64(osm_node_get_node_guid(p_node)), p_node->print_desc);
 
 	OSM_LOG_EXIT(sm->p_log);
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index 2ea35b8..7dcd15e 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2002-2012 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -146,8 +147,8 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
 					cl_ntoh64(port_guid));
 			else {
 				OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
-					"Detected another SM. Requesting SMInfo"
-					"\n\t\t\t\tPort 0x%" PRIx64 "\n",
+					"Detected another SM. Requesting SMInfo "
+					"from port 0x%" PRIx64 "\n",
 					cl_ntoh64(port_guid));
 
 				/*
@@ -168,8 +169,10 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
 				if (status != IB_SUCCESS)
 					OSM_LOG(sm->p_log, OSM_LOG_ERROR,
 						"ERR 0F05: "
-						"Failure requesting SMInfo (%s)\n",
-						ib_get_err_str(status));
+						"Failure requesting SMInfo (%s) "
+						"from port 0x%" PRIx64 "\n",
+						ib_get_err_str(status),
+						cl_ntoh64(port_guid));
 			}
 		} else {
 			p_sm =
diff --git a/opensm/osm_sminfo_rcv.c b/opensm/osm_sminfo_rcv.c
index a0092a5..6520e65 100644
--- a/opensm/osm_sminfo_rcv.c
+++ b/opensm/osm_sminfo_rcv.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -116,7 +117,7 @@ static void smi_rcv_process_get_request(IN osm_sm_t * sm,
 	status = osm_resp_send(sm, p_madw, 0, payload);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F02: "
-			"Error sending response (%s)\n",
+			"Error sending SMInfo response (%s)\n",
 			ib_get_err_str(status));
 		goto Exit;
 	}
@@ -177,7 +178,7 @@ static void smi_rcv_process_set_request(IN osm_sm_t * sm,
 
 	if (p_smp->method != IB_MAD_METHOD_SET) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F03: "
-			"Unsupported method 0x%X\n", p_smp->method);
+			"Unsupported set method 0x%X\n", p_smp->method);
 		goto Exit;
 	}
 
@@ -213,7 +214,7 @@ static void smi_rcv_process_set_request(IN osm_sm_t * sm,
 		status = osm_resp_send(sm, p_madw, 7, payload);
 		if (status != IB_SUCCESS)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F05: "
-				"Error sending response (%s)\n",
+				"Error sending SMInfo response (%s)\n",
 				ib_get_err_str(status));
 		CL_PLOCK_RELEASE(sm->p_lock);
 		goto Exit;
@@ -260,7 +261,7 @@ static void smi_rcv_process_set_request(IN osm_sm_t * sm,
 		status = osm_resp_send(sm, p_madw, 7, payload);
 		if (status != IB_SUCCESS)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F08: "
-				"Error sending response (%s)\n",
+				"Error sending SMInfo response (%s)\n",
 				ib_get_err_str(status));
 		goto Exit;
 	}
@@ -269,7 +270,7 @@ static void smi_rcv_process_set_request(IN osm_sm_t * sm,
 	status = osm_resp_send(sm, p_madw, 0, payload);
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F09: "
-			"Error sending response (%s)\n",
+			"Error sending SMInfo response (%s)\n",
 			ib_get_err_str(status));
 
 	/* it is a legal packet - act according to it */
@@ -308,8 +309,9 @@ static void smi_rcv_process_get_sm(IN osm_sm_t * sm,
 	p_smi = &p_sm->smi;
 
 	OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
-		"Detected SM 0x%016" PRIx64 " in state %u\n",
-		cl_ntoh64(p_smi->guid), ib_sminfo_get_state(p_smi));
+		"Detected SM 0x%016" PRIx64 " in state %u (%s)\n",
+		cl_ntoh64(p_smi->guid), ib_sminfo_get_state(p_smi),
+		osm_get_sm_mgr_state_str(ib_sminfo_get_state(p_smi)));
 
 	/* Check the state of this SM vs. our own. */
 	switch (sm->p_subn->sm_state) {
@@ -443,7 +445,7 @@ static void smi_rcv_process_get_response(IN osm_sm_t * sm,
 
 	if (p_smp->method != IB_MAD_METHOD_GET_RESP) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F11: "
-			"Unsupported method 0x%X\n", p_smp->method);
+			"Unsupported response method 0x%X\n", p_smp->method);
 		goto Exit;
 	}
 
@@ -477,7 +479,7 @@ static void smi_rcv_process_get_response(IN osm_sm_t * sm,
 
 	if (osm_port_get_guid(p_port) != p_smi->guid) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F13: "
-			"Bogus SM port GUID\n\t\t\t\tExpected 0x%016" PRIx64
+			"Bogus SM port GUID, Expected 0x%016" PRIx64
 			", Received 0x%016" PRIx64 "\n",
 			cl_ntoh64(osm_port_get_guid(p_port)),
 			cl_ntoh64(p_smi->guid));
@@ -532,7 +534,7 @@ static void smi_rcv_process_set_response(IN osm_sm_t * sm,
 
 	if (p_smp->method != IB_MAD_METHOD_GET_RESP) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F16: "
-			"Unsupported method 0x%X\n", p_smp->method);
+			"Unsupported response method 0x%X\n", p_smp->method);
 		goto Exit;
 	}
 
@@ -542,7 +544,8 @@ static void smi_rcv_process_set_response(IN osm_sm_t * sm,
 	/* Check the AttributeModifier */
 	if (p_smp->attr_mod != IB_SMINFO_ATTR_MOD_HANDOVER) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F17: "
-			"Unsupported attribute modifier 0x%X\n",
+			"Unsupported attribute modifier 0x%X, "
+			"expected ATTR_MOD_HANDOVER\n",
 			p_smp->attr_mod);
 		goto Exit;
 	}
@@ -585,7 +588,7 @@ void osm_sminfo_rcv_process(IN void *context, IN void *data)
 		if (p_smi_context->port_guid != p_smi->guid) {
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F19: "
 				"Unexpected SM port GUID in response"
-				"\n\t\t\t\tExpected 0x%016" PRIx64
+				", Expected 0x%016" PRIx64
 				", Received 0x%016" PRIx64 "\n",
 				cl_ntoh64(p_smi_context->port_guid),
 				cl_ntoh64(p_smi->guid));
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
