From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 3/8] opensm/osm_node_info_rcv.c: using if_PF for all the fatal
 conditions
Date: Wed, 15 Aug 2012 00:35:00 +0300
Message-ID: <502AC484.60303@mellanox.co.il>
Reply-To: <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is just the first file - similar optimization will be done
on other MADs receivers.

Note that this patch doesn't mess with all the non-fatal cases.
The goal was not to help SM to perform better with all the
validations that it does, but to make sure that the fatal
cases will never be predicted wrong, so	any fatal check (existing
or a newely added one) won't affect the SM performance.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---
 opensm/osm_node_info_rcv.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index 36d8046..2f2aa6d 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2012 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
@@ -153,7 +153,7 @@ static void ni_rcv_set_links(IN osm_sm_t * sm, osm_node_t * p_node,

 	p_neighbor_node = osm_get_node_by_guid(sm->p_subn,
 					       p_ni_context->node_guid);
-	if (!p_neighbor_node) {
+	if_PF (!p_neighbor_node) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D10: "
 			"Unexpected removal of neighbor node 0x%" PRIx64 "\n",
 			cl_ntoh64(p_ni_context->node_guid));
@@ -430,7 +430,7 @@ static void ni_rcv_process_existing_ca_or_router(IN osm_sm_t * sm,
 		osm_node_init_physp(p_node, port_num, p_madw);

 		p_port = osm_port_new(p_ni, p_node);
-		if (p_port == NULL) {
+		if_PF (p_port == NULL) {
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D04: "
 				"Unable to create new port object\n");
 			goto Exit;
@@ -443,7 +443,7 @@ static void ni_rcv_process_existing_ca_or_router(IN osm_sm_t * sm,
 		    (osm_port_t *) cl_qmap_insert(&sm->p_subn->port_guid_tbl,
 						  p_ni->port_guid,
 						  &p_port->map_item);
-		if (p_port_check != p_port) {
+		if_PF (p_port_check != p_port) {
 			/*
 			   We should never be here!
 			   Somehow, this port GUID already exists in the table.
@@ -458,7 +458,7 @@ static void ni_rcv_process_existing_ca_or_router(IN osm_sm_t * sm,

 		p_alias_guid = osm_alias_guid_new(p_ni->port_guid,
 						  p_port);
-		if (!p_alias_guid) {
+		if_PF (!p_alias_guid) {
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D11: "
 				"alias guid memory allocation failed"
 				" for port GUID 0x%" PRIx64 "\n",
@@ -495,7 +495,7 @@ alias_done:
 	} else {
 		osm_physp_t *p_physp = osm_node_get_physp_ptr(p_node, port_num);

-		if (p_physp == NULL) {
+		if_PF (p_physp == NULL) {
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D1C: "
 				"No physical port found for node GUID 0x%"
 				PRIx64 " port %u. Might be duplicate port GUID\n",
@@ -639,7 +639,7 @@ static void ni_rcv_process_new(IN osm_sm_t * sm, IN const osm_madw_t * p_madw)
 		ib_get_node_type_str(p_ni->node_type),
 		cl_ntoh64(p_ni->node_guid), cl_ntoh64(p_smp->trans_id));

-	if (port_num > p_ni->num_ports) {
+	if_PF (port_num > p_ni->num_ports) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D0A: "
 			"New %s node GUID 0x%" PRIx64 "is non-compliant and "
 			"is being ignored since the "
@@ -651,7 +651,7 @@ static void ni_rcv_process_new(IN osm_sm_t * sm, IN const osm_madw_t * p_madw)
 	}

 	p_node = osm_node_new(p_madw);
-	if (p_node == NULL) {
+	if_PF (p_node == NULL) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D07: "
 			"Unable to create new node object\n");
 		goto Exit;
@@ -662,7 +662,7 @@ static void ni_rcv_process_new(IN osm_sm_t * sm, IN const osm_madw_t * p_madw)
 	   ports in the port table.
 	 */
 	p_port = osm_port_new(p_ni, p_node);
-	if (p_port == NULL) {
+	if_PF (p_port == NULL) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D14: "
 			"Unable to create new port object\n");
 		osm_node_delete(&p_node);
@@ -675,7 +675,7 @@ static void ni_rcv_process_new(IN osm_sm_t * sm, IN const osm_madw_t * p_madw)
 	p_port_check =
 	    (osm_port_t *) cl_qmap_insert(&sm->p_subn->port_guid_tbl,
 					  p_ni->port_guid, &p_port->map_item);
-	if (p_port_check != p_port) {
+	if_PF (p_port_check != p_port) {
 		/*
 		   We should never be here!
 		   Somehow, this port GUID already exists in the table.
@@ -698,7 +698,7 @@ static void ni_rcv_process_new(IN osm_sm_t * sm, IN const osm_madw_t * p_madw)

 	p_alias_guid = osm_alias_guid_new(p_ni->port_guid,
 					  p_port);
-	if (!p_alias_guid) {
+	if_PF (!p_alias_guid) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D18: "
 			"alias guid memory allocation failed"
 			" for port GUID 0x%" PRIx64 "\n",
@@ -733,7 +733,7 @@ alias_done2:
 	/* If there were RouterInfo or other router attribute,
 	   this would be elsewhere */
 	if (p_ni->node_type == IB_NODE_TYPE_ROUTER) {
-		if ((p_rtr = osm_router_new(p_port)) == NULL)
+		if_PF ((p_rtr = osm_router_new(p_port)) == NULL)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D1A: "
 				"Unable to create new router object\n");
 		else {
@@ -742,7 +742,7 @@ alias_done2:
 			    (osm_router_t *) cl_qmap_insert(p_rtr_guid_tbl,
 							    p_ni->port_guid,
 							    &p_rtr->map_item);
-			if (p_rtr_check != p_rtr)
+			if_PF (p_rtr_check != p_rtr)
 				OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D1B: "
 					"Unable to add port GUID:0x%016" PRIx64
 					" to router table\n",
@@ -753,7 +753,7 @@ alias_done2:
 	p_node_check =
 	    (osm_node_t *) cl_qmap_insert(&sm->p_subn->node_guid_tbl,
 					  p_ni->node_guid, &p_node->map_item);
-	if (p_node_check != p_node) {
+	if_PF (p_node_check != p_node) {
 		/*
 		   This node must have been inserted by another thread.
 		   This is unexpected, but is not an error.
@@ -817,7 +817,7 @@ static void ni_rcv_process_existing(IN osm_sm_t * sm, IN osm_node_t * p_node,
 		cl_ntoh64(p_ni->node_guid),
 		cl_ntoh64(p_smp->trans_id), p_node->discovery_count);

-	if (port_num > p_ni->num_ports) {
+	if_PF (port_num > p_ni->num_ports) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D0C: "
 			"Existing %s node GUID 0x%" PRIx64 "is non-compliant "
 			"and is being ignored since the "
@@ -876,14 +876,14 @@ void osm_ni_rcv_process(IN void *context, IN void *data)

 	CL_ASSERT(p_smp->attr_id == IB_MAD_ATTR_NODE_INFO);

-	if (p_ni->node_guid == 0) {
+	if_PF (p_ni->node_guid == 0) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D16: "
 			"Got Zero Node GUID! Found on the directed route:\n");
 		osm_dump_smp_dr_path_v2(sm->p_log, p_smp, FILE_ID, OSM_LOG_ERROR);
 		goto Exit;
 	}

-	if (p_ni->port_guid == 0) {
+	if_PF (p_ni->port_guid == 0) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0D17: "
 			"Got Zero Port GUID! Found on the directed route:\n");
 		osm_dump_smp_dr_path_v2(sm->p_log, p_smp, FILE_ID, OSM_LOG_ERROR);
-- 
1.7.11.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
