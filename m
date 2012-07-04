From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V1.1 3/8] Add locking where necessary around osm_req_*
Date: Tue,  3 Jul 2012 17:25:48 -0700
Message-ID: <1341361548-30229-2-git-send-email-foraker1@llnl.gov>
References: <1341361508.5218.148.camel@auk75.llnl.gov>
 <1341361548-30229-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341361548-30229-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Grabs plock for reading in the places where one did not
already exist when osm_req_get/osm_req_set are called.

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_perfmgr.c      |    6 ++++++
 opensm/osm_sm_state_mgr.c |    2 ++
 opensm/osm_state_mgr.c    |    8 ++++++++
 opensm/osm_trap_rcv.c     |    6 +++++-
 4 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index a7ff017..f8e56d2 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -610,8 +610,10 @@ static int sweep_hop_1(osm_sm_t * sm)
 		path_array[1] = port_num;
 
 		osm_dr_path_init(&hop_1_path, 1, path_array);
+		CL_PLOCK_ACQUIRE(sm->p_lock);
 		status = osm_req_get(sm, &hop_1_path, IB_MAD_ATTR_NODE_INFO, 0,
 				     CL_DISP_MSGID_NONE, &context);
+		CL_PLOCK_RELEASE(sm->p_lock);
 
 		if (status != IB_SUCCESS)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 4C82: "
@@ -642,9 +644,11 @@ static int sweep_hop_1(osm_sm_t * sm)
 			path_array[1] = port_num;
 
 			osm_dr_path_init(&hop_1_path, 1, path_array);
+			CL_PLOCK_ACQUIRE(sm->p_lock);
 			status = osm_req_get(sm, &hop_1_path,
 					     IB_MAD_ATTR_NODE_INFO, 0,
 					     CL_DISP_MSGID_NONE, &context);
+			CL_PLOCK_RELEASE(sm->p_lock);
 
 			if (status != IB_SUCCESS)
 				OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 4C84: "
@@ -704,8 +708,10 @@ static int sweep_hop_0(osm_sm_t * sm)
 	}
 
 	osm_dr_path_init(&dr_path, 0, path_array);
+	CL_PLOCK_ACQUIRE(sm->p_lock);
 	status = osm_req_get(sm, &dr_path, IB_MAD_ATTR_NODE_INFO, 0,
 			     CL_DISP_MSGID_NONE, NULL);
+	CL_PLOCK_RELEASE(sm->p_lock);
 
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR,
diff --git a/opensm/osm_sm_state_mgr.c b/opensm/osm_sm_state_mgr.c
index e826f1f..061a0f2 100644
--- a/opensm/osm_sm_state_mgr.c
+++ b/opensm/osm_sm_state_mgr.c
@@ -109,9 +109,11 @@ static void sm_state_mgr_send_master_sm_info_req(osm_sm_t * sm)
 	context.smi_context.port_guid = p_port->guid;
 	context.smi_context.set_method = FALSE;
 
+	CL_PLOCK_ACQUIRE(sm->p_lock);
 	status = osm_req_get(sm, osm_physp_get_dr_path_ptr(p_port->p_physp),
 			     IB_MAD_ATTR_SM_INFO, 0, CL_DISP_MSGID_NONE,
 			     &context);
+	CL_PLOCK_RELEASE(sm->p_lock);
 
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3204: "
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index 74114af..e276a64 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -239,8 +239,10 @@ static ib_api_status_t state_mgr_sweep_hop_0(IN osm_sm_t * sm)
 		CL_PLOCK_RELEASE(sm->p_lock);
 
 		osm_dr_path_init(&dr_path, 0, path_array);
+		CL_PLOCK_ACQUIRE(sm->p_lock);
 		status = osm_req_get(sm, &dr_path, IB_MAD_ATTR_NODE_INFO, 0,
 				     CL_DISP_MSGID_NONE, NULL);
+		CL_PLOCK_RELEASE(sm->p_lock);
 		if (status != IB_SUCCESS)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3305: "
 				"Request for NodeInfo failed (%s)\n",
@@ -432,8 +434,10 @@ static ib_api_status_t state_mgr_sweep_hop_1(IN osm_sm_t * sm)
 		path_array[1] = port_num;
 
 		osm_dr_path_init(&hop_1_path, 1, path_array);
+		CL_PLOCK_ACQUIRE(sm->p_lock);
 		status = osm_req_get(sm, &hop_1_path, IB_MAD_ATTR_NODE_INFO, 0,
 				     CL_DISP_MSGID_NONE, &context);
+		CL_PLOCK_RELEASE(sm->p_lock);
 		if (status != IB_SUCCESS)
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3311: "
 				"Request for NodeInfo failed (%s)\n",
@@ -461,10 +465,12 @@ static ib_api_status_t state_mgr_sweep_hop_1(IN osm_sm_t * sm)
 
 				path_array[1] = port_num;
 				osm_dr_path_init(&hop_1_path, 1, path_array);
+				CL_PLOCK_ACQUIRE(sm->p_lock);
 				status = osm_req_get(sm, &hop_1_path,
 						     IB_MAD_ATTR_NODE_INFO, 0,
 						     CL_DISP_MSGID_NONE,
 						     &context);
+				CL_PLOCK_RELEASE(sm->p_lock);
 				if (status != IB_SUCCESS)
 					OSM_LOG(sm->p_log, OSM_LOG_ERROR,
 						"ERR 3312: "
@@ -811,10 +817,12 @@ static void state_mgr_send_handover(IN osm_sm_t * sm, IN osm_remote_sm_t * p_sm)
 		p_smi->sm_key = 0;
 	}
 
+	CL_PLOCK_ACQUIRE(sm->p_lock);
 	status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p_port->p_physp),
 			     payload, sizeof(payload), IB_MAD_ATTR_SM_INFO,
 			     IB_SMINFO_ATTR_MOD_HANDOVER, CL_DISP_MSGID_NONE,
 			     &context);
+	CL_PLOCK_RELEASE(sm->p_lock);
 
 	if (status != IB_SUCCESS)
 		OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 3317: "
diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index e90ad5e..90cb673 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -213,6 +213,7 @@ static int disable_port(osm_sm_t *sm, osm_physp_t *p)
 	uint8_t payload[IB_SMP_DATA_SIZE];
 	osm_madw_context_t context;
 	ib_port_info_t *pi = (ib_port_info_t *)payload;
+	ib_api_status_t status;
 
 	/* select the nearest port to master opensm */
 	if (p->p_remote_physp &&
@@ -235,10 +236,13 @@ static int disable_port(osm_sm_t *sm, osm_physp_t *p)
 	context.pi_context.light_sweep = FALSE;
 	context.pi_context.active_transition = FALSE;
 
-	return osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
+	CL_PLOCK_ACQUIRE(sm->p_lock);
+	status = osm_req_set(sm, osm_physp_get_dr_path_ptr(p),
 			   payload, sizeof(payload), IB_MAD_ATTR_PORT_INFO,
 			   cl_hton32(osm_physp_get_port_num(p)),
 			   CL_DISP_MSGID_NONE, &context);
+	CL_PLOCK_RELEASE(sm->p_lock);
+	return status;
 }
 
 static void log_trap_info(osm_log_t *p_log, ib_mad_notice_attr_t *p_ntci,
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
