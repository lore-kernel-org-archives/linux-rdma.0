From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 05/27] Fixed crash in sm_state_mgr_send_master_sm_info_req() during fabric merge
Date: Tue, 31 Jul 2012 19:04:33 +0300
Message-ID: <1343750695-28063-5-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The scenario that led to a crash is as follows:
1. Our SM in MASTER state discovered another MASTER SM with lower priority.
2. Our SM waited for a HANDOVER and started to poll (SMInfoGet) the other SM.
3. Other SM's port/node disconnected from the fabric and didn't update the sm->p_remote_sm - pointer to the other SM.

Fix is to osm_remote_sm struct.
Remove p_port from remote osm_remote_sm struct.
Fix cleanup of sm->p_polling_sm in drop manager.
Add read lock during SM polling timer.

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_remote_sm.h |  4 +---
 opensm/osm_drop_mgr.c          |  4 +++-
 opensm/osm_remote_sm.c         |  4 +---
 opensm/osm_sa_sminfo_record.c  | 10 +++++++++-
 opensm/osm_sm_state_mgr.c      | 19 ++++++++++++++-----
 opensm/osm_sminfo_rcv.c        | 12 ++++++------
 opensm/osm_state_mgr.c         | 28 +++++++++++++++++++---------
 7 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/include/opensm/osm_remote_sm.h b/include/opensm/osm_remote_sm.h
index 886070e..e7d52fa 100644
--- a/include/opensm/osm_remote_sm.h
+++ b/include/opensm/osm_remote_sm.h
@@ -87,7 +87,6 @@ BEGIN_C_DECLS
 */
 typedef struct osm_remote_sm {
 	cl_map_item_t map_item;
-	const osm_port_t *p_port;
 	ib_sm_info_t smi;
 } osm_remote_sm_t;
 /*
@@ -169,8 +168,7 @@ void osm_remote_sm_destroy(IN osm_remote_sm_t * p_sm);
 *
 * SYNOPSIS
 */
-void osm_remote_sm_init(IN osm_remote_sm_t * p_sm, IN const osm_port_t * p_port,
-			IN const ib_sm_info_t * p_smi);
+void osm_remote_sm_init(IN osm_remote_sm_t * p_sm, IN const ib_sm_info_t * p_smi);
 /*
 * PARAMETERS
 *	p_sm
diff --git a/opensm/osm_drop_mgr.c b/opensm/osm_drop_mgr.c
index ab3b2b3..5e5f1b1 100644
--- a/opensm/osm_drop_mgr.c
+++ b/opensm/osm_drop_mgr.c
@@ -256,7 +256,9 @@ static void drop_mgr_remove_port(osm_sm_t * sm, IN osm_port_t * p_port)
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"Cleaned SM for port guid 0x%016" PRIx64 "\n",
 			cl_ntoh64(port_guid));
-
+		/* clean up the polling_sm pointer */
+		if (sm->p_polling_sm == p_sm)
+			sm->p_polling_sm = NULL;
 		free(p_sm);
 	}
 
diff --git a/opensm/osm_remote_sm.c b/opensm/osm_remote_sm.c
index a0562ac..4ebbd3f 100644
--- a/opensm/osm_remote_sm.c
+++ b/opensm/osm_remote_sm.c
@@ -59,15 +59,13 @@ void osm_remote_sm_destroy(IN osm_remote_sm_t * p_sm)
 	memset(p_sm, 0, sizeof(*p_sm));
 }
 
-void osm_remote_sm_init(IN osm_remote_sm_t * p_sm, IN const osm_port_t * p_port,
+void osm_remote_sm_init(IN osm_remote_sm_t * p_sm,
 			IN const ib_sm_info_t * p_smi)
 {
 	CL_ASSERT(p_sm);
-	CL_ASSERT(p_port);
 
 	osm_remote_sm_construct(p_sm);
 
-	p_sm->p_port = p_port;
 	p_sm->smi = *p_smi;
 	return;
 }
diff --git a/opensm/osm_sa_sminfo_record.c b/opensm/osm_sa_sminfo_record.c
index e549046..23eda1d 100644
--- a/opensm/osm_sa_sminfo_record.c
+++ b/opensm/osm_sa_sminfo_record.c
@@ -123,6 +123,7 @@ static void sa_smir_by_comp_mask(IN osm_sa_t * sa,
 	const ib_sminfo_record_t *const p_rcvd_rec = p_ctxt->p_rcvd_rec;
 	const osm_physp_t *const p_req_physp = p_ctxt->p_req_physp;
 	ib_net64_t const comp_mask = p_ctxt->comp_mask;
+	osm_port_t *p_port;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -144,8 +145,15 @@ static void sa_smir_by_comp_mask(IN osm_sa_t * sa,
 	}
 
 	/* Implement any other needed search cases */
+	p_port = osm_get_port_by_guid(sa->p_subn, p_rem_sm->smi.guid);
 
-	smir_rcv_new_smir(sa, p_rem_sm->p_port, p_ctxt->p_list,
+        if (p_port == NULL) {
+                OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2810: "
+                        "No port for remote sm\n");
+                goto Exit;
+        }
+
+	smir_rcv_new_smir(sa, p_port, p_ctxt->p_list,
 			  p_rem_sm->smi.guid, p_rem_sm->smi.act_count,
 			  p_rem_sm->smi.pri_state, p_req_physp);
 
diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index e826f1f..80de22d 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -78,10 +78,13 @@ static void sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm)
 	osm_madw_context_t context;
 	const osm_port_t *p_port;
 	ib_api_status_t status;
+	osm_dr_path_t dr_path;
+	ib_net64_t guid;
 
 	OSM_LOG_ENTER(sm->p_log);
 
 	memset(&context, 0, sizeof(context));
+	CL_PLOCK_ACQUIRE(sm->p_lock);
 	if (sm->p_subn->sm_state == IB_SMINFO_STATE_STANDBY) {
 		/*
 		 * We are in STANDBY state - this means we need to poll the
@@ -89,7 +92,7 @@ static void sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm)
 		 * Send a query of SubnGet(SMInfo) to the subn
 		 * master_sm_base_lid object.
 		 */
-		p_port = osm_get_port_by_guid(sm->p_subn, sm->master_sm_guid);
+		guid = sm->master_sm_guid;
 	} else {
 		/*
 		 * We are not in STANDBY - this means we are in MASTER state -
@@ -97,19 +100,25 @@ static void sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm)
 		 * under sm.
 		 * Send a query of SubnGet(SMInfo) to that SM.
 		 */
-		p_port = sm->p_polling_sm->p_port;
+		guid = sm->p_polling_sm->smi.guid;
 	}
+
+	p_port = osm_get_port_by_guid(sm->p_subn, guid);
+
 	if (p_port == NULL) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3203: "
 			"No port object for GUID 0x%016" PRIx64 "\n",
-			cl_ntoh64(sm->master_sm_guid));
+			cl_ntoh64(guid));
+		CL_PLOCK_RELEASE(sm->p_lock);
 		goto Exit;
 	}
 
-	context.smi_context.port_guid = p_port->guid;
+	context.smi_context.port_guid = guid;
 	context.smi_context.set_method = FALSE;
+	memcpy(&dr_path, osm_physp_get_dr_path_ptr(p_port->p_physp), sizeof(osm_dr_path_t));
+	CL_PLOCK_RELEASE(sm->p_lock);
 
-	status = osm_req_get(sm, osm_physp_get_dr_path_ptr(p_port->p_physp),
+	status = osm_req_get(sm, &dr_path,
 			     IB_MAD_ATTR_SM_INFO, 0, CL_DISP_MSGID_NONE,
 			     &context);
 
diff --git a/opensm/osm_sminfo_rcv.c b/opensm/osm_sminfo_rcv.c
index 4ee4f17..eb7c17f 100644
--- a/opensm/osm_sminfo_rcv.c
+++ b/opensm/osm_sminfo_rcv.c
@@ -323,8 +323,8 @@ static void smi_rcv_process_get_sm(IN osm_sm_t * sm,
 			/* save on the sm the guid of the current master. */
 			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 				"Found master SM. Updating sm_state_mgr master_guid: 0x%016"
-				PRIx64 "\n", cl_ntoh64(p_sm->p_port->guid));
-			sm->master_sm_guid = p_sm->p_port->guid;
+				PRIx64 "\n", cl_ntoh64(p_smi->guid));
+			sm->master_sm_guid = p_smi->guid;
 			break;
 		case IB_SMINFO_STATE_DISCOVERING:
 		case IB_SMINFO_STATE_STANDBY:
@@ -336,8 +336,8 @@ static void smi_rcv_process_get_sm(IN osm_sm_t * sm,
 				OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 					"Found higher SM. Updating sm_state_mgr master_guid:"
 					" 0x%016" PRIx64 "\n",
-					cl_ntoh64(p_sm->p_port->guid));
-				sm->master_sm_guid = p_sm->p_port->guid;
+					cl_ntoh64(p_smi->guid));
+				sm->master_sm_guid = p_smi->guid;
 			}
 			break;
 		default:
@@ -361,7 +361,7 @@ static void smi_rcv_process_get_sm(IN osm_sm_t * sm,
 		case IB_SMINFO_STATE_STANDBY:
 			/* This should be the response from the sm we are polling. */
 			/* If it is - then signal master is alive */
-			if (sm->master_sm_guid == p_sm->p_port->guid) {
+			if (sm->master_sm_guid == p_sm->smi.guid) {
 				/* Make sure that it is an SM with higher priority than us.
 				   If we started polling it when it was master, and it moved
 				   to standby - then it might be with a lower priority than
@@ -498,7 +498,7 @@ static void smi_rcv_process_get_response(IN osm_sm_t * sm,
 			goto _unlock_and_exit;
 		}
 
-		osm_remote_sm_init(p_sm, p_port, p_smi);
+		osm_remote_sm_init(p_sm, p_smi);
 
 		cl_qmap_insert(p_sm_tbl, port_guid, &p_sm->map_item);
 	} else
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index e8c76c0..00e9c72 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -491,12 +491,20 @@ static void query_sm_info(cl_map_item_t * item, void *cxt)
 	osm_remote_sm_t *r_sm = cl_item_obj(item, r_sm, map_item);
 	osm_sm_t *sm = cxt;
 	ib_api_status_t ret;
+	osm_port_t *p_port;
+
+	p_port= osm_get_port_by_guid(sm->p_subn, r_sm->smi.guid);
+	if (p_port == NULL) {
+		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3340: "
+			"No port object on given sm object\n");
+		return;
+        }
 
-	context.smi_context.port_guid = r_sm->p_port->guid;
+	context.smi_context.port_guid = r_sm->smi.guid;
 	context.smi_context.set_method = FALSE;
 	context.smi_context.light_sweep = TRUE;
 
-	ret = osm_req_get(sm, osm_physp_get_dr_path_ptr(r_sm->p_port->p_physp),
+	ret = osm_req_get(sm, osm_physp_get_dr_path_ptr(p_port->p_physp),
 			  IB_MAD_ATTR_SM_INFO, 0, CL_DISP_MSGID_NONE, &context);
 	if (ret != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3314: "
@@ -673,6 +681,7 @@ static osm_remote_sm_t *state_mgr_exists_other_master_sm(IN osm_sm_t * sm)
 	cl_qmap_t *p_sm_tbl;
 	osm_remote_sm_t *p_sm;
 	osm_remote_sm_t *p_sm_res = NULL;
+	osm_node_t *p_node;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -683,12 +692,12 @@ static osm_remote_sm_t *state_mgr_exists_other_master_sm(IN osm_sm_t * sm)
 	     p_sm != (osm_remote_sm_t *) cl_qmap_end(p_sm_tbl);
 	     p_sm = (osm_remote_sm_t *) cl_qmap_next(&p_sm->map_item)) {
 		/* If the sm is in MASTER state - return a pointer to it */
+		p_node = osm_get_node_by_guid(sm->p_subn, p_sm->smi.guid);
 		if (ib_sminfo_get_state(&p_sm->smi) == IB_SMINFO_STATE_MASTER) {
 			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 				"Found remote master SM with guid:0x%016" PRIx64
 				" (node %s)\n", cl_ntoh64(p_sm->smi.guid),
-				p_sm->p_port->p_node ? p_sm->p_port->p_node->
-				print_desc : "UNKNOWN");
+				p_node ? p_node->print_desc : "UNKNOWN");
 			p_sm_res = p_sm;
 			goto Exit;
 		}
@@ -712,6 +721,7 @@ static osm_remote_sm_t *state_mgr_get_highest_sm(IN osm_sm_t * sm)
 	osm_remote_sm_t *p_highest_sm;
 	uint8_t highest_sm_priority;
 	ib_net64_t highest_sm_guid;
+	osm_node_t *p_node;
 
 	OSM_LOG_ENTER(sm->p_log);
 
@@ -744,13 +754,13 @@ static osm_remote_sm_t *state_mgr_get_highest_sm(IN osm_sm_t * sm)
 		}
 	}
 
-	if (p_highest_sm != NULL)
+	if (p_highest_sm != NULL) {
+		p_node = osm_get_node_by_guid(sm->p_subn, p_highest_sm->smi.guid);
 		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 			"Found higher SM with guid: %016" PRIx64 " (node %s)\n",
 			cl_ntoh64(p_highest_sm->smi.guid),
-			p_highest_sm->p_port->p_node ?
-			p_highest_sm->p_port->p_node->print_desc : "UNKNOWN");
-
+			p_node ? p_node->print_desc : "UNKNOWN");
+	}
 	OSM_LOG_EXIT(sm->p_log);
 	return p_highest_sm;
 }
@@ -774,7 +784,7 @@ static void state_mgr_send_handover(IN osm_sm_t * sm, IN osm_remote_sm_t * p_sm)
 	 */
 
 	memset(&context, 0, sizeof(context));
-	p_port = p_sm->p_port;
+	p_port = osm_get_port_by_guid(sm->p_subn, p_sm->smi.guid);
 	if (p_port == NULL) {
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3316: "
 			"No port object on given remote_sm object\n");
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
