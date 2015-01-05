From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Add separate dispatcher for SA set and delete requests
Date: Mon, 05 Jan 2015 17:28:07 -0500
Message-ID: <54AB0FF7.4090005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add a separate dispatcher for SA set/delete requests in order to avoid
dependent request race conditions. This is caused by SA client
misbehavior (in not following IBA spec) in terms of dependent management
requests.

Without this change, when an agent sends a set of requests, OpenSM might
handle them in different order from that they were received, and if the
requests are dependent on each other, the outcome may vary.
With this change, requests will be handled in the order they were
received.

Stress test result:
Test is to send 200K set/delete guid info requests in parallel
(20 requests on the wire)
Without the patches: ~5.37 seconds
With the patches: 5.1 seconds

Background:
In terms of the general requirement/problem, the confusion stems from
the IBA management "non standard" meaning of a transaction. A
transaction ID is required to be unique if new operation (not rerequest
of existing operation) where transaction is determined from the
combination of TID, SGID (or SLID), and  MgmtClass. There is no
requirement about handling the ordering of transactions. This was
explicitly omitted by design.
This lack of requirement actually goes further than just sets and could
serialize all incoming SA transactions if done across clients.

This is a bug but it is not OpenSM misbehavior. The requirement on any
ordering is on the client and not on the manager. The problem is to
"deal with non compliant SA clients" without negatively impacting
SA performance.

The specific issue is the ordering of set processing from a specific
application in a node which is a subset of the above. If a client is
to pipeline SA sets, it needs to know what it's doing and serialize
subsequent sets which depend on previous ones. If that is not done
(which is the case), per IBA standard, the bug is in the SA client.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_opensm.h      |    8 +++++
 include/opensm/osm_sa.h          |   12 +++++++
 include/opensm/osm_sa_mad_ctrl.h |   14 ++++++++-
 opensm/osm_opensm.c              |   17 ++++++++++-
 opensm/osm_sa.c                  |   45 ++++++++++++++++++++++++++-
 opensm/osm_sa_mad_ctrl.c         |   61 +++++++++++++++++++++++++++++++------
 6 files changed, 143 insertions(+), 14 deletions(-)

diff --git a/include/opensm/osm_opensm.h b/include/opensm/osm_opensm.h
index 4750505..7768881 100644
--- a/include/opensm/osm_opensm.h
+++ b/include/opensm/osm_opensm.h
@@ -226,6 +226,8 @@ typedef struct osm_opensm {
 	osm_vl15_t vl15;
 	osm_log_t log;
 	cl_dispatcher_t disp;
+	cl_dispatcher_t sa_set_disp;
+	boolean_t sa_set_disp_initialized;
 	cl_plock_t lock;
 	struct osm_routing_engine *routing_engine_list;
 	struct osm_routing_engine *routing_engine_used;
@@ -269,6 +271,12 @@ typedef struct osm_opensm {
 *	disp
 *		Central dispatcher containing the OpenSM worker threads.
 *
+*	sa_set_disp
+*		Dispatcher for SA Set and Delete requests.
+*
+*	sa_set_disp_initialized.
+*		Indicator that sa_set_disp dispatcher was initialized.
+*
 *	lock
 *		Shared lock guarding most OpenSM structures.
 *
diff --git a/include/opensm/osm_sa.h b/include/opensm/osm_sa.h
index f9f334e..aeeaa02 100644
--- a/include/opensm/osm_sa.h
+++ b/include/opensm/osm_sa.h
@@ -186,6 +186,7 @@ typedef struct osm_sa {
 	osm_log_t *p_log;
 	osm_mad_pool_t *p_mad_pool;
 	cl_dispatcher_t *p_disp;
+	cl_dispatcher_t *p_set_disp;
 	cl_plock_t *p_lock;
 	atomic32_t sa_trans_id;
 	osm_sa_mad_ctrl_t mad_ctrl;
@@ -211,6 +212,10 @@ typedef struct osm_sa {
 	cl_disp_reg_handle_t lft_disp_h;
 	cl_disp_reg_handle_t sir_disp_h;
 	cl_disp_reg_handle_t mft_disp_h;
+	cl_disp_reg_handle_t infr_set_disp_h;
+	cl_disp_reg_handle_t gir_set_disp_h;
+	cl_disp_reg_handle_t mcmr_set_disp_h;
+	cl_disp_reg_handle_t sr_set_disp_h;
 } osm_sa_t;
 /*
 * FIELDS
@@ -235,6 +240,9 @@ typedef struct osm_sa {
 *	p_disp
 *		Pointer to dispatcher
 *
+*	p_set_disp
+*		Pointer to dispatcher for Set requests.
+*
 *	p_lock
 *		Pointer to Lock for serialization
 *
@@ -346,6 +354,7 @@ ib_api_status_t osm_sa_init(IN osm_sm_t * p_sm, IN osm_sa_t * p_sa,
 			    IN osm_mad_pool_t * p_mad_pool,
 			    IN osm_log_t * p_log, IN osm_stats_t * p_stats,
 			    IN cl_dispatcher_t * p_disp,
+			    IN cl_dispatcher_t * p_set_disp,
 			    IN cl_plock_t * p_lock);
 /*
 * PARAMETERS
@@ -370,6 +379,9 @@ ib_api_status_t osm_sa_init(IN osm_sm_t * p_sm, IN osm_sa_t * p_sa,
 *	p_disp
 *		[in] Pointer to the OpenSM central Dispatcher.
 *
+*	p_set_disp
+*		[in] Pointer to the OpenSM Dispatcher for Set requests.
+*
 *	p_lock
 *		[in] Pointer to the OpenSM serializing lock.
 *
diff --git a/include/opensm/osm_sa_mad_ctrl.h b/include/opensm/osm_sa_mad_ctrl.h
index 00ccbf6..2c2513b 100644
--- a/include/opensm/osm_sa_mad_ctrl.h
+++ b/include/opensm/osm_sa_mad_ctrl.h
@@ -98,7 +98,9 @@ typedef struct osm_sa_mad_ctrl {
 	osm_vendor_t *p_vendor;
 	osm_bind_handle_t h_bind;
 	cl_dispatcher_t *p_disp;
+	cl_dispatcher_t *p_set_disp;
 	cl_disp_reg_handle_t h_disp;
+	cl_disp_reg_handle_t h_set_disp;
 	osm_stats_t *p_stats;
 	osm_subn_t *p_subn;
 } osm_sa_mad_ctrl_t;
@@ -122,9 +124,15 @@ typedef struct osm_sa_mad_ctrl {
 *	p_disp
 *		Pointer to the Dispatcher.
 *
+*	p_set_disp
+*		Pointer to the Dispatcher for Set requests.
+*
 *	h_disp
 *		Handle returned from dispatcher registration.
 *
+*	h_set_disp
+*		Handle returned from Set requests dispatcher registration.
+*
 *	p_stats
 *		Pointer to the OpenSM statistics block.
 *
@@ -211,7 +219,8 @@ ib_api_status_t osm_sa_mad_ctrl_init(IN osm_sa_mad_ctrl_t * p_ctrl,
 				     IN osm_subn_t * p_subn,
 				     IN osm_log_t * p_log,
 				     IN osm_stats_t * p_stats,
-				     IN cl_dispatcher_t * p_disp);
+				     IN cl_dispatcher_t * p_disp,
+				     IN cl_dispatcher_t * p_set_disp);
 /*
 * PARAMETERS
 *	p_ctrl
@@ -235,6 +244,9 @@ ib_api_status_t osm_sa_mad_ctrl_init(IN osm_sa_mad_ctrl_t * p_ctrl,
 *	p_disp
 *		[in] Pointer to the OpenSM central Dispatcher.
 *
+*	p_set_disp
+*		[in] Pointer to the OpenSM Dispatcher for Set requests.
+*
 * RETURN VALUES
 *	IB_SUCCESS if the SA MAD Controller object was initialized
 *	successfully.
diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
index 69d2ba6..afa2544 100644
--- a/opensm/osm_opensm.c
+++ b/opensm/osm_opensm.c
@@ -345,6 +345,8 @@ void osm_opensm_destroy_finish(IN osm_opensm_t * p_osm)
 	osm_vendor_delete(&p_osm->p_vendor);
 	osm_subn_destroy(&p_osm->subn);
 	cl_disp_destroy(&p_osm->disp);
+	if (p_osm->sa_set_disp_initialized)
+		cl_disp_destroy(&p_osm->sa_set_disp);
 #ifdef HAVE_LIBPTHREAD
 	pthread_cond_destroy(&p_osm->stats.cond);
 	pthread_mutex_destroy(&p_osm->stats.mutex);
@@ -432,6 +434,17 @@ ib_api_status_t osm_opensm_init(IN osm_opensm_t * p_osm,
 	if (status != IB_SUCCESS)
 		goto Exit;
 
+	/* Unless OpenSM runs in single threaded mode, we create new single
+	 * threaded dispatcher for SA Set and Delete requets.
+	 */
+	p_osm->sa_set_disp_initialized = FALSE;
+	if (!p_opt->single_thread) {
+		status = cl_disp_init(&p_osm->sa_set_disp, 1, "subnadmin_set");
+		if (status != IB_SUCCESS)
+			goto Exit;
+		p_osm->sa_set_disp_initialized = TRUE;
+	}
+
 	/* the DB is in use by subn so init before */
 	status = osm_db_init(&p_osm->db, &p_osm->log);
 	if (status != IB_SUCCESS)
@@ -480,7 +493,9 @@ ib_api_status_t osm_opensm_init_finish(IN osm_opensm_t * p_osm,
 
 	status = osm_sa_init(&p_osm->sm, &p_osm->sa, &p_osm->subn,
 			     p_osm->p_vendor, &p_osm->mad_pool, &p_osm->log,
-			     &p_osm->stats, &p_osm->disp, &p_osm->lock);
+			     &p_osm->stats, &p_osm->disp,
+			     p_opt->single_thread ? NULL : &p_osm->sa_set_disp,
+			     &p_osm->lock);
 	if (status != IB_SUCCESS)
 		goto Exit;
 
diff --git a/opensm/osm_sa.c b/opensm/osm_sa.c
index 06a09a9..e9ba68b 100644
--- a/opensm/osm_sa.c
+++ b/opensm/osm_sa.c
@@ -132,6 +132,14 @@ void osm_sa_shutdown(IN osm_sa_t * p_sa)
 	cl_disp_unregister(p_sa->lft_disp_h);
 	cl_disp_unregister(p_sa->sir_disp_h);
 	cl_disp_unregister(p_sa->mft_disp_h);
+
+	if (p_sa->p_set_disp) {
+		cl_disp_unregister(p_sa->mcmr_set_disp_h);
+		cl_disp_unregister(p_sa->infr_set_disp_h);
+		cl_disp_unregister(p_sa->sr_set_disp_h);
+		cl_disp_unregister(p_sa->gir_set_disp_h);
+	}
+
 	osm_sa_mad_ctrl_destroy(&p_sa->mad_ctrl);
 
 	OSM_LOG_EXIT(p_sa->p_log);
@@ -152,7 +160,9 @@ ib_api_status_t osm_sa_init(IN osm_sm_t * p_sm, IN osm_sa_t * p_sa,
 			    IN osm_subn_t * p_subn, IN osm_vendor_t * p_vendor,
 			    IN osm_mad_pool_t * p_mad_pool,
 			    IN osm_log_t * p_log, IN osm_stats_t * p_stats,
-			    IN cl_dispatcher_t * p_disp, IN cl_plock_t * p_lock)
+			    IN cl_dispatcher_t * p_disp,
+			    IN cl_dispatcher_t * p_set_disp,
+			    IN cl_plock_t * p_lock)
 {
 	ib_api_status_t status;
 
@@ -164,13 +174,14 @@ ib_api_status_t osm_sa_init(IN osm_sm_t * p_sm, IN osm_sa_t * p_sa,
 	p_sa->p_mad_pool = p_mad_pool;
 	p_sa->p_log = p_log;
 	p_sa->p_disp = p_disp;
+	p_sa->p_set_disp = p_set_disp;
 	p_sa->p_lock = p_lock;
 
 	p_sa->state = OSM_SA_STATE_READY;
 
 	status = osm_sa_mad_ctrl_init(&p_sa->mad_ctrl, p_sa, p_sa->p_mad_pool,
 				      p_sa->p_vendor, p_subn, p_log, p_stats,
-				      p_disp);
+				      p_disp, p_set_disp);
 	if (status != IB_SUCCESS)
 		goto Exit;
 
@@ -277,6 +288,36 @@ ib_api_status_t osm_sa_init(IN osm_sm_t * p_sm, IN osm_sa_t * p_sa,
 	if (p_sa->mft_disp_h == CL_DISP_INVALID_HANDLE)
 		goto Exit;
 
+	/*
+	 * When p_set_disp is defined, it means that we use different dispatcher
+	 * for SA Set requests, and we need to register handlers for it.
+	 */
+	if (p_set_disp) {
+		p_sa->gir_set_disp_h =
+		    cl_disp_register(p_set_disp, OSM_MSG_MAD_GUIDINFO_RECORD,
+				     osm_gir_rcv_process, p_sa);
+		if (p_sa->gir_set_disp_h == CL_DISP_INVALID_HANDLE)
+			goto Exit;
+
+		p_sa->mcmr_set_disp_h =
+		    cl_disp_register(p_set_disp, OSM_MSG_MAD_MCMEMBER_RECORD,
+				     osm_mcmr_rcv_process, p_sa);
+		if (p_sa->mcmr_set_disp_h == CL_DISP_INVALID_HANDLE)
+			goto Exit;
+
+		p_sa->sr_set_disp_h =
+		    cl_disp_register(p_set_disp, OSM_MSG_MAD_SERVICE_RECORD,
+				     osm_sr_rcv_process, p_sa);
+		if (p_sa->sr_set_disp_h == CL_DISP_INVALID_HANDLE)
+			goto Exit;
+
+		p_sa->infr_set_disp_h =
+		    cl_disp_register(p_set_disp, OSM_MSG_MAD_INFORM_INFO,
+				     osm_infr_rcv_process, p_sa);
+		if (p_sa->infr_set_disp_h == CL_DISP_INVALID_HANDLE)
+			goto Exit;
+	}
+
 	status = IB_SUCCESS;
 Exit:
 	OSM_LOG_EXIT(p_log);
diff --git a/opensm/osm_sa_mad_ctrl.c b/opensm/osm_sa_mad_ctrl.c
index c21f7d1..30f3c9d 100644
--- a/opensm/osm_sa_mad_ctrl.c
+++ b/opensm/osm_sa_mad_ctrl.c
@@ -93,9 +93,11 @@ static void sa_mad_ctrl_disp_done_callback(IN void *context, IN void *p_data)
  * SYNOPSIS
  */
 static void sa_mad_ctrl_process(IN osm_sa_mad_ctrl_t * p_ctrl,
-				IN osm_madw_t * p_madw)
+				IN osm_madw_t * p_madw,
+				IN boolean_t is_get_request)
 {
 	ib_sa_mad_t *p_sa_mad;
+	cl_disp_reg_handle_t h_disp;
 	cl_status_t status;
 	cl_disp_msgid_t msg_id = CL_DISP_MSGID_NONE;
 	uint64_t last_dispatched_msg_queue_time_msec;
@@ -103,6 +105,8 @@ static void sa_mad_ctrl_process(IN osm_sa_mad_ctrl_t * p_ctrl,
 
 	OSM_LOG_ENTER(p_ctrl->p_log);
 
+	p_sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
+
 	/*
 	   If the dispatcher is showing us that it is overloaded
 	   there is no point in placing the request in. We should instead
@@ -113,8 +117,16 @@ static void sa_mad_ctrl_process(IN osm_sa_mad_ctrl_t * p_ctrl,
 	   HACK: Actually, we cannot send a mad from within the receive callback;
 	   thus - we will just drop it.
 	 */
-	cl_disp_get_queue_status(p_ctrl->h_disp, &num_messages,
+
+	if (!is_get_request && p_ctrl->p_set_disp) {
+		h_disp = p_ctrl->h_set_disp;
+		goto SKIP_QUEUE_CHECK;
+	}
+
+	h_disp = p_ctrl->h_disp;
+	cl_disp_get_queue_status(h_disp, &num_messages,
 				 &last_dispatched_msg_queue_time_msec);
+
 	if (num_messages > 1 && p_ctrl->p_subn->opt.max_msg_fifo_timeout &&
 	    last_dispatched_msg_queue_time_msec >
 	    p_ctrl->p_subn->opt.max_msg_fifo_timeout) {
@@ -134,8 +146,7 @@ static void sa_mad_ctrl_process(IN osm_sa_mad_ctrl_t * p_ctrl,
 		goto Exit;
 	}
 
-	p_sa_mad = osm_madw_get_sa_mad_ptr(p_madw);
-
+SKIP_QUEUE_CHECK:
 	/*
 	   Note that attr_id (like the rest of the MAD) is in
 	   network byte order.
@@ -233,7 +244,7 @@ static void sa_mad_ctrl_process(IN osm_sa_mad_ctrl_t * p_ctrl,
 			"Posting Dispatcher message %s\n",
 			osm_get_disp_msg_str(msg_id));
 
-		status = cl_disp_post(p_ctrl->h_disp, msg_id, p_madw,
+		status = cl_disp_post(h_disp, msg_id, p_madw,
 				      sa_mad_ctrl_disp_done_callback, p_ctrl);
 
 		if (status != CL_SUCCESS) {
@@ -283,6 +294,7 @@ static void sa_mad_ctrl_rcv_callback(IN osm_madw_t * p_madw, IN void *context,
 {
 	osm_sa_mad_ctrl_t *p_ctrl = context;
 	ib_sa_mad_t *p_sa_mad;
+	boolean_t is_get_request = FALSE;
 
 	OSM_LOG_ENTER(p_ctrl->p_log);
 
@@ -360,13 +372,14 @@ static void sa_mad_ctrl_rcv_callback(IN osm_madw_t * p_madw, IN void *context,
 #if defined (VENDOR_RMPP_SUPPORT) && defined (DUAL_SIDED_RMPP)
 	case IB_MAD_METHOD_GETMULTI:
 #endif
+		is_get_request = TRUE;
 	case IB_MAD_METHOD_SET:
 	case IB_MAD_METHOD_DELETE:
 		/* if we are closing down simply do nothing */
 		if (osm_exit_flag)
 			osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
 		else
-			sa_mad_ctrl_process(p_ctrl, p_madw);
+			sa_mad_ctrl_process(p_ctrl, p_madw, is_get_request);
 		break;
 
 	default:
@@ -439,9 +452,20 @@ static void sa_mad_ctrl_send_err_callback(IN void *context,
 			"Posting Dispatcher message %s\n",
 			osm_get_disp_msg_str(osm_madw_get_err_msg(p_madw)));
 
-		status = cl_disp_post(p_ctrl->h_disp,
-				      osm_madw_get_err_msg(p_madw), p_madw,
-				      sa_mad_ctrl_disp_done_callback, p_ctrl);
+		if (p_ctrl->p_set_disp &&
+		    (p_madw->p_mad->method == IB_MAD_METHOD_SET ||
+		     p_madw->p_mad->method == IB_MAD_METHOD_DELETE))
+			status = cl_disp_post(p_ctrl->h_set_disp,
+					      osm_madw_get_err_msg(p_madw),
+					      p_madw,
+					      sa_mad_ctrl_disp_done_callback,
+					      p_ctrl);
+		else
+			status = cl_disp_post(p_ctrl->h_disp,
+					      osm_madw_get_err_msg(p_madw),
+					      p_madw,
+					      sa_mad_ctrl_disp_done_callback,
+					      p_ctrl);
 		if (status != CL_SUCCESS) {
 			OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 1A07: "
 				"Dispatcher post message failed (%s)\n",
@@ -468,12 +492,14 @@ void osm_sa_mad_ctrl_construct(IN osm_sa_mad_ctrl_t * p_ctrl)
 	CL_ASSERT(p_ctrl);
 	memset(p_ctrl, 0, sizeof(*p_ctrl));
 	p_ctrl->h_disp = CL_DISP_INVALID_HANDLE;
+	p_ctrl->h_set_disp = CL_DISP_INVALID_HANDLE;
 }
 
 void osm_sa_mad_ctrl_destroy(IN osm_sa_mad_ctrl_t * p_ctrl)
 {
 	CL_ASSERT(p_ctrl);
 	cl_disp_unregister(p_ctrl->h_disp);
+	cl_disp_unregister(p_ctrl->h_set_disp);
 }
 
 ib_api_status_t osm_sa_mad_ctrl_init(IN osm_sa_mad_ctrl_t * p_ctrl,
@@ -483,7 +509,8 @@ ib_api_status_t osm_sa_mad_ctrl_init(IN osm_sa_mad_ctrl_t * p_ctrl,
 				     IN osm_subn_t * p_subn,
 				     IN osm_log_t * p_log,
 				     IN osm_stats_t * p_stats,
-				     IN cl_dispatcher_t * p_disp)
+				     IN cl_dispatcher_t * p_disp,
+				     IN cl_dispatcher_t * p_set_disp)
 {
 	ib_api_status_t status = IB_SUCCESS;
 
@@ -494,6 +521,7 @@ ib_api_status_t osm_sa_mad_ctrl_init(IN osm_sa_mad_ctrl_t * p_ctrl,
 	p_ctrl->sa = sa;
 	p_ctrl->p_log = p_log;
 	p_ctrl->p_disp = p_disp;
+	p_ctrl->p_set_disp = p_set_disp;
 	p_ctrl->p_mad_pool = p_mad_pool;
 	p_ctrl->p_vendor = p_vendor;
 	p_ctrl->p_stats = p_stats;
@@ -509,6 +537,19 @@ ib_api_status_t osm_sa_mad_ctrl_init(IN osm_sa_mad_ctrl_t * p_ctrl,
 		goto Exit;
 	}
 
+	if (p_set_disp) {
+		p_ctrl->h_set_disp =
+		    cl_disp_register(p_set_disp, CL_DISP_MSGID_NONE, NULL,
+				     p_ctrl);
+
+		if (p_ctrl->h_set_disp == CL_DISP_INVALID_HANDLE) {
+			OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 1A0A: "
+				"SA set dispatcher registration failed\n");
+			status = IB_INSUFFICIENT_RESOURCES;
+			goto Exit;
+		}
+	}
+
 Exit:
 	OSM_LOG_EXIT(p_log);
 	return status;
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
