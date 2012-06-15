From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Eliminate unneeded field in DR path structure
Date: Fri, 15 Jun 2012 06:31:55 -0400
Message-ID: <4FDB0F1B.5010105@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


h_bind is not needed as part of DR path

Found by Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_path.h b/include/opensm/osm_path.h
index 0f6af03..b69e5f9 100644
--- a/include/opensm/osm_path.h
+++ b/include/opensm/osm_path.h
@@ -80,7 +80,6 @@ BEGIN_C_DECLS
 * SYNOPSIS
 */
 typedef struct osm_dr_path {
-	osm_bind_handle_t h_bind;
 	uint8_t hop_count;
 	uint8_t path[IB_SUBNET_PATH_HOPS_MAX];
 } osm_dr_path_t;
@@ -111,7 +110,6 @@ static inline void osm_dr_path_construct(IN osm_dr_path_t * p_path)
 {
 	/* The first location in the path array is reserved. */
 	memset(p_path, 0, sizeof(*p_path));
-	p_path->h_bind = OSM_BIND_INVALID_HANDLE;
 }
 
 /*
@@ -146,14 +144,12 @@ static inline void osm_dr_path_construct(IN osm_dr_path_t * p_path)
 * SYNOPSIS
 */
 static inline void
-osm_dr_path_init(IN osm_dr_path_t * p_path, IN osm_bind_handle_t h_bind,
-		 IN uint8_t hop_count,
+osm_dr_path_init(IN osm_dr_path_t * p_path, IN uint8_t hop_count,
 		 IN const uint8_t path[IB_SUBNET_PATH_HOPS_MAX])
 {
 	/* The first location in the path array is reserved. */
 	CL_ASSERT(path[0] == 0);
 	CL_ASSERT(hop_count < IB_SUBNET_PATH_HOPS_MAX);
-	p_path->h_bind = h_bind;
 	p_path->hop_count = hop_count;
 	memcpy(p_path->path, path, hop_count + 1);
 }
@@ -219,36 +215,5 @@ static inline int osm_dr_path_extend(IN osm_dr_path_t * p_path,
 * SEE ALSO
 *********/
 
-/****f* OpenSM: DR Path/osm_dr_path_get_bind_handle
-* NAME
-*	osm_dr_path_get_bind_handle
-*
-* DESCRIPTION
-*	Gets the bind handle from a path.
-*
-* SYNOPSIS
-*/
-static inline osm_bind_handle_t
-osm_dr_path_get_bind_handle(IN const osm_dr_path_t * p_path)
-{
-	return p_path->h_bind;
-}
-
-/*
-* PARAMETERS
-*	p_path
-*		[in] Pointer to a directed route path object to initialize.
-*
-*	port_num
-*		[in] Additional port to add to the DR path.
-*
-* RETURN VALUE
-*	None.
-*
-* NOTES
-*
-* SEE ALSO
-*********/
-
 END_C_DECLS
 #endif				/* _OSM_PATH_H_ */
diff --git a/opensm/osm_node_info_rcv.c b/opensm/osm_node_info_rcv.c
index dcf2456..4bb9b34 100644
--- a/opensm/osm_node_info_rcv.c
+++ b/opensm/osm_node_info_rcv.c
@@ -487,7 +487,7 @@ alias_done:
 		 */
 		p_dr_path = osm_physp_get_dr_path_ptr(p_physp);
 
-		osm_dr_path_init(p_dr_path, h_bind, p_smp->hop_count,
+		osm_dr_path_init(p_dr_path, p_smp->hop_count,
 				 p_smp->initial_path);
 	}
 
@@ -511,8 +511,7 @@ static void ni_rcv_process_switch(IN osm_sm_t * sm, IN osm_node_t * p_node,
 
 	/* update DR path of already initialized switch port 0 */
 	path = osm_physp_get_dr_path_ptr(osm_node_get_physp_ptr(p_node, 0));
-	osm_dr_path_init(path, osm_madw_get_bind_handle(p_madw),
-			 p_smp->hop_count, p_smp->initial_path);
+	osm_dr_path_init(path, p_smp->hop_count, p_smp->initial_path);
 
 	context.si_context.node_guid = osm_node_get_node_guid(p_node);
 	context.si_context.set_method = FALSE;
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 234ac64..de9cdb2 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -605,7 +605,7 @@ static int sweep_hop_1(osm_sm_t * sm)
 	CL_ASSERT(p_physp);
 
 	p_dr_path = osm_physp_get_dr_path_ptr(p_physp);
-	h_bind = osm_dr_path_get_bind_handle(p_dr_path);
+	h_bind = sm->mad_ctrl.h_bind;
 
 	CL_ASSERT(h_bind != OSM_BIND_INVALID_HANDLE);
 
@@ -621,7 +621,7 @@ static int sweep_hop_1(osm_sm_t * sm)
 
 		path_array[1] = port_num;
 
-		osm_dr_path_init(&hop_1_path, h_bind, 1, path_array);
+		osm_dr_path_init(&hop_1_path, 1, path_array);
 		status = osm_req_get(sm, &hop_1_path, IB_MAD_ATTR_NODE_INFO, 0,
 				     CL_DISP_MSGID_NONE, &context);
 
@@ -653,7 +653,7 @@ static int sweep_hop_1(osm_sm_t * sm)
 
 			path_array[1] = port_num;
 
-			osm_dr_path_init(&hop_1_path, h_bind, 1, path_array);
+			osm_dr_path_init(&hop_1_path, 1, path_array);
 			status = osm_req_get(sm, &hop_1_path,
 					     IB_MAD_ATTR_NODE_INFO, 0,
 					     CL_DISP_MSGID_NONE, &context);
@@ -715,7 +715,7 @@ static int sweep_hop_0(osm_sm_t * sm)
 		return -1;
 	}
 
-	osm_dr_path_init(&dr_path, h_bind, 0, path_array);
+	osm_dr_path_init(&dr_path, 0, path_array);
 	status = osm_req_get(sm, &dr_path, IB_MAD_ATTR_NODE_INFO, 0,
 			     CL_DISP_MSGID_NONE, NULL);
 
diff --git a/opensm/osm_port.c b/opensm/osm_port.c
index d7c0f75..88b9fd8 100644
--- a/opensm/osm_port.c
+++ b/opensm/osm_port.c
@@ -103,7 +103,7 @@ void osm_physp_init(IN osm_physp_t * p_physp, IN ib_net64_t port_guid,
 	p_physp->need_update = 2;
 	p_physp->p_node = (struct osm_node *)p_node;
 
-	osm_dr_path_init(&p_physp->dr_path, h_bind, hop_count, p_initial_path);
+	osm_dr_path_init(&p_physp->dr_path, hop_count, p_initial_path);
 
 	/* allocate enough SL2VL tables */
 	if (osm_node_get_type(p_node) == IB_NODE_TYPE_SWITCH)
@@ -418,7 +418,7 @@ static void physp_update_new_dr_path(IN osm_physp_t const *p_dest_physp,
 	}
 	if (p_src_physp) {
 		p_dr_path = osm_physp_get_dr_path_ptr(p_src_physp);
-		osm_dr_path_init(p_dr_path, h_bind, i, path_array);
+		osm_dr_path_init(p_dr_path, i, path_array);
 	}
 
 	cl_list_destroy(&tmpPortsList);
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index ca2808c..ec78428 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -588,8 +588,8 @@ void osm_pi_rcv_process(IN void *context, IN void *data)
 		/* Update the directed route path to this port
 		   in case the old path is no longer usable. */
 		p_dr_path = osm_physp_get_dr_path_ptr(p_physp);
-		osm_dr_path_init(p_dr_path, osm_madw_get_bind_handle(p_madw),
-				 p_smp->hop_count, p_smp->initial_path);
+		osm_dr_path_init(p_dr_path, p_smp->hop_count,
+				 p_smp->initial_path);
 
 		/* if port just inited or reached INIT state (external reset)
 		   request update for port related tables */
diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index 5ee904a..2532f9c 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -84,7 +84,7 @@ ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 
 	/* p_context may be NULL. */
 
-	p_madw = osm_mad_pool_get(sm->p_mad_pool, p_path->h_bind,
+	p_madw = osm_mad_pool_get(sm->p_mad_pool, sm->mad_ctrl.h_bind,
 				  MAD_BLOCK_SIZE, NULL);
 	if (p_madw == NULL) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
@@ -154,7 +154,7 @@ ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 
 	/* p_context may be NULL. */
 
-	p_madw = osm_mad_pool_get(sm->p_mad_pool, p_path->h_bind,
+	p_madw = osm_mad_pool_get(sm->p_mad_pool, sm->mad_ctrl.h_bind,
 				  MAD_BLOCK_SIZE, NULL);
 	if (p_madw == NULL) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index a2b2b96..0dbf4ad 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -237,7 +237,7 @@ static ib_api_status_t state_mgr_sweep_hop_0(IN osm_sm_t * sm)
 
 		CL_PLOCK_RELEASE(sm->p_lock);
 
-		osm_dr_path_init(&dr_path, h_bind, 0, path_array);
+		osm_dr_path_init(&dr_path, 0, path_array);
 		status = osm_req_get(sm, &dr_path, IB_MAD_ATTR_NODE_INFO, 0,
 				     CL_DISP_MSGID_NONE, NULL);
 		if (status != IB_SUCCESS)
@@ -426,7 +426,7 @@ static ib_api_status_t state_mgr_sweep_hop_1(IN osm_sm_t * sm)
 	CL_ASSERT(p_physp);
 
 	p_dr_path = osm_physp_get_dr_path_ptr(p_physp);
-	h_bind = osm_dr_path_get_bind_handle(p_dr_path);
+	h_bind = sm->mad_ctrl.h_bind;
 
 	CL_ASSERT(h_bind != OSM_BIND_INVALID_HANDLE);
 
@@ -442,7 +442,7 @@ static ib_api_status_t state_mgr_sweep_hop_1(IN osm_sm_t * sm)
 
 		path_array[1] = port_num;
 
-		osm_dr_path_init(&hop_1_path, h_bind, 1, path_array);
+		osm_dr_path_init(&hop_1_path, 1, path_array);
 		status = osm_req_get(sm, &hop_1_path, IB_MAD_ATTR_NODE_INFO, 0,
 				     CL_DISP_MSGID_NONE, &context);
 		if (status != IB_SUCCESS)
@@ -471,8 +471,7 @@ static ib_api_status_t state_mgr_sweep_hop_1(IN osm_sm_t * sm)
 				context.ni_context.port_num = port_num;
 
 				path_array[1] = port_num;
-				osm_dr_path_init(&hop_1_path, h_bind, 1,
-						 path_array);
+				osm_dr_path_init(&hop_1_path, 1, path_array);
 				status = osm_req_get(sm, &hop_1_path,
 						     IB_MAD_ATTR_NODE_INFO, 0,
 						     CL_DISP_MSGID_NONE,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
