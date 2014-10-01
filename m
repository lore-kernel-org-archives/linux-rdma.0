From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 05/21] IB/iser: Fix DEVICE REMOVAL handling in the absence of iscsi daemon
Date: Wed,  1 Oct 2014 14:02:01 +0300
Message-ID: <1412161337-25285-6-git-send-email-ogerlitz@mellanox.com>
References: <1412161337-25285-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412161337-25285-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

iscsi daemon is in user-space, thus we can't rely on it to
be invoke connection teardown (if not running or does not receive
CPU time).

This patch addresses the issue by re-structuring iSER connection
teardown logic and CM events handling.

The CM events will dictate the RDMA resources destruction (ib_conn)
and iser_conn is kept around as long as iscsi_conn is left around
allowing iscsi/iser callbacks to continue after RDMA transport was
destroyed.

This patch introduces a separation in logic when handling CM events:
- DISCONNECTED_HANDLER, ADDR_CHANGED
  This events indicate the start of teardown process.
  Actions:
  1. Terminate the connection: rdma_disconnect (send DREQ/DREP)
  2. Notify iSCSI of connection failure
  3. Change state to TERMINATING
  4. Poll for all flush errors to be consumed

- TIMEWAIT_EXIT, DEVICE_REMOVAL
  These events indicate the final stage of termination process and
  we can free RDMA related resources.
  Actions:
  1. Call disconnected handler (we are not guaranteed that DISCONNECTED
     event was invoked in the past)
  2. Cleanup RDMA related resources
  3. For DEVICE_REMOVAL return non-zero rc from cma_handler to
     implicitly destroy the cm_id (Can't rely on user-space, make sure
     we have forward progress)

We replace flush_completion (indicate all flushes were consumed) with
ib_completion (rdma resources were cleaned up).

The iser_conn_release_work will wait for teardown completions:
- conn_stop was completed (tasks were cleaned-up) - stop_completion
- RDMA resources were destroyed - ib_completion
And then will continue to free iser connection representation (iser_conn).

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h |    6 +-
 drivers/infiniband/ulp/iser/iser_verbs.c |  163 +++++++++++++++++++-----------
 2 files changed, 108 insertions(+), 61 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index ec238b3..95c484d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -370,9 +370,9 @@ struct iser_conn {
 	unsigned		     min_posted_rx; /* qp_max_recv_dtos >> 2 */
 	char 			     name[ISER_OBJECT_NAME_SIZE];
 	struct work_struct	     release_work;
-	struct completion	     stop_completion;
 	struct mutex		     state_mutex;
-	struct completion	     flush_completion;
+	struct completion	     stop_completion;
+	struct completion	     ib_completion;
 	struct completion	     up_completion;
 	struct list_head	     conn_list;       /* entry in ig conn list */
 
@@ -442,7 +442,7 @@ void iser_conn_init(struct iser_conn *iser_conn);
 
 void iser_conn_release(struct iser_conn *iser_conn);
 
-void iser_conn_terminate(struct iser_conn *iser_conn);
+int iser_conn_terminate(struct iser_conn *iser_conn);
 
 void iser_release_work(struct work_struct *work);
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index e429974..6170d06 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -44,6 +44,7 @@
 
 static void iser_cq_tasklet_fn(unsigned long data);
 static void iser_cq_callback(struct ib_cq *cq, void *cq_context);
+static int iser_drain_tx_cq(struct iser_device  *device, int cq_index);
 
 static void iser_cq_event_callback(struct ib_event *cause, void *context)
 {
@@ -573,11 +574,10 @@ void iser_release_work(struct work_struct *work)
 	rc = wait_for_completion_timeout(&iser_conn->stop_completion, 30 * HZ);
 	WARN_ON(rc == 0);
 
-	/* wait for the qp`s post send and post receive buffers to empty */
-	rc = wait_for_completion_timeout(&iser_conn->flush_completion, 30 * HZ);
-	WARN_ON(rc == 0);
-
-	iser_conn->state = ISER_CONN_DOWN;
+	rc = wait_for_completion_timeout(&iser_conn->ib_completion, 30 * HZ);
+	if (rc == 0)
+		iser_warn("conn %p, IB cleanup didn't complete in 30 "
+			  "seconds, continue with release\n", iser_conn);
 
 	mutex_lock(&iser_conn->state_mutex);
 	iser_conn->state = ISER_CONN_DOWN;
@@ -589,12 +589,16 @@ void iser_release_work(struct work_struct *work)
 /**
  * iser_free_ib_conn_res - release IB related resources
  * @iser_conn: iser connection struct
+ * @destroy_device: indicator if we need to try to release
+ *     the iser device (only iscsi shutdown and DEVICE_REMOVAL
+ *     will use this.
  *
  * This routine is called with the iser state mutex held
  * so the cm_id removal is out of here. It is Safe to
  * be invoked multiple times.
  */
-static void iser_free_ib_conn_res(struct iser_conn *iser_conn)
+static void iser_free_ib_conn_res(struct iser_conn *iser_conn,
+				  bool destroy_device)
 {
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	struct iser_device *device = ib_conn->device;
@@ -610,7 +614,7 @@ static void iser_free_ib_conn_res(struct iser_conn *iser_conn)
 		ib_conn->qp = NULL;
 	}
 
-	if (device != NULL) {
+	if (destroy_device && device != NULL) {
 		iser_device_try_release(device);
 		ib_conn->device = NULL;
 	}
@@ -629,7 +633,11 @@ void iser_conn_release(struct iser_conn *iser_conn)
 
 	mutex_lock(&iser_conn->state_mutex);
 	BUG_ON(iser_conn->state != ISER_CONN_DOWN);
-	iser_free_ib_conn_res(iser_conn);
+	/*
+	 * In case we never got to bind stage, we still need to
+	 * release IB resources (which is safe to call more than once).
+	 */
+	iser_free_ib_conn_res(iser_conn, true);
 	mutex_unlock(&iser_conn->state_mutex);
 
 	if (ib_conn->cma_id != NULL) {
@@ -641,23 +649,68 @@ void iser_conn_release(struct iser_conn *iser_conn)
 }
 
 /**
+ * iser_poll_for_flush_errors - Don't settle for less than all.
+ * @struct ib_conn: IB context of the connection
+ *
+ * This routine is called when the QP is in error state
+ * It polls the send CQ until all flush errors are consumed and
+ * returns when all flush errors were processed.
+ */
+static void iser_poll_for_flush_errors(struct ib_conn *ib_conn)
+{
+	struct iser_device *device = ib_conn->device;
+	int count = 0;
+
+	while (ib_conn->post_recv_buf_count > 0 ||
+	       atomic_read(&ib_conn->post_send_buf_count) > 0) {
+		msleep(100);
+		if (atomic_read(&ib_conn->post_send_buf_count) > 0)
+			iser_drain_tx_cq(device, ib_conn->cq_index);
+
+		count++;
+		/* Don't flood with prints */
+		if (count % 30 == 0)
+			iser_dbg("post_recv %d post_send %d",
+				 ib_conn->post_recv_buf_count,
+				 atomic_read(&ib_conn->post_send_buf_count));
+	}
+}
+
+/**
  * triggers start of the disconnect procedures and wait for them to be done
+ * Called with state mutex held
  */
-void iser_conn_terminate(struct iser_conn *iser_conn)
+int iser_conn_terminate(struct iser_conn *iser_conn)
 {
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
 	int err = 0;
 
-	/* change the ib conn state only if the conn is UP, however always call
-	 * rdma_disconnect since this is the only way to cause the CMA to change
-	 * the QP state to ERROR
+	/* terminate the iser conn only if the conn state is UP */
+	if (!iser_conn_state_comp_exch(iser_conn, ISER_CONN_UP,
+				       ISER_CONN_TERMINATING))
+		return 0;
+
+	iser_info("iser_conn %p state %d\n", iser_conn, iser_conn->state);
+
+	/* suspend queuing of new iscsi commands */
+	if (iser_conn->iscsi_conn)
+		iscsi_suspend_queue(iser_conn->iscsi_conn);
+
+	/*
+	 * In case we didn't already clean up the cma_id (peer initiated
+	 * a disconnection), we need to Cause the CMA to change the QP
+	 * state to ERROR.
 	 */
+	if (ib_conn->cma_id) {
+		err = rdma_disconnect(ib_conn->cma_id);
+		if (err)
+			iser_err("Failed to disconnect, conn: 0x%p err %d\n",
+				 iser_conn, err);
+
+		iser_poll_for_flush_errors(ib_conn);
+	}
 
-	iser_conn_state_comp_exch(iser_conn, ISER_CONN_UP, ISER_CONN_TERMINATING);
-	err = rdma_disconnect(ib_conn->cma_id);
-	if (err)
-		iser_err("Failed to disconnect, conn: 0x%p err %d\n",
-			 iser_conn, err);
+	return 1;
 }
 
 /**
@@ -780,34 +833,36 @@ static void iser_connected_handler(struct rdma_cm_id *cma_id)
 
 static void iser_disconnected_handler(struct rdma_cm_id *cma_id)
 {
-	struct iser_conn *iser_conn;
-	struct ib_conn *ib_conn = &iser_conn->ib_conn;
-
-	iser_conn = (struct iser_conn *)cma_id->context;
+	struct iser_conn *iser_conn = (struct iser_conn *)cma_id->context;
 
-	/* getting here when the state is UP means that the conn is being *
-	 * terminated asynchronously from the iSCSI layer's perspective.  */
-	if (iser_conn_state_comp_exch(iser_conn, ISER_CONN_UP,
-				      ISER_CONN_TERMINATING)){
+	if (iser_conn_terminate(iser_conn)) {
 		if (iser_conn->iscsi_conn)
-			iscsi_conn_failure(iser_conn->iscsi_conn, ISCSI_ERR_CONN_FAILED);
+			iscsi_conn_failure(iser_conn->iscsi_conn,
+					   ISCSI_ERR_CONN_FAILED);
 		else
 			iser_err("iscsi_iser connection isn't bound\n");
 	}
+}
+
+static void iser_cleanup_handler(struct rdma_cm_id *cma_id,
+				 bool destroy_device)
+{
+	struct iser_conn *iser_conn = (struct iser_conn *)cma_id->context;
 
-	/* Complete the termination process if no posts are pending. This code
-	 * block also exists in iser_handle_comp_error(), but it is needed here
-	 * for cases of no flushes at all, e.g. discovery over rdma.
+	/*
+	 * We are not guaranteed that we visited disconnected_handler
+	 * by now, call it here to be safe that we handle CM drep
+	 * and flush errors.
 	 */
-	if (ib_conn->post_recv_buf_count == 0 &&
-	    (atomic_read(&ib_conn->post_send_buf_count) == 0)) {
-		complete(&iser_conn->flush_completion);
-	}
-}
+	iser_disconnected_handler(cma_id);
+	iser_free_ib_conn_res(iser_conn, destroy_device);
+	complete(&iser_conn->ib_completion);
+};
 
 static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 {
 	struct iser_conn *iser_conn;
+	int ret = 0;
 
 	iser_conn = (struct iser_conn *)cma_id->context;
 	iser_info("event %d status %d conn %p id %p\n",
@@ -832,17 +887,29 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
 		iser_connect_error(cma_id);
 		break;
 	case RDMA_CM_EVENT_DISCONNECTED:
-	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 	case RDMA_CM_EVENT_ADDR_CHANGE:
-	case RDMA_CM_EVENT_TIMEWAIT_EXIT:
 		iser_disconnected_handler(cma_id);
 		break;
+	case RDMA_CM_EVENT_DEVICE_REMOVAL:
+		/*
+		 * we *must* destroy the device as we cannot rely
+		 * on iscsid to be around to initiate error handling.
+		 * also implicitly destroy the cma_id.
+		 */
+		iser_cleanup_handler(cma_id, true);
+		iser_conn->ib_conn.cma_id = NULL;
+		ret = 1;
+		break;
+	case RDMA_CM_EVENT_TIMEWAIT_EXIT:
+		iser_cleanup_handler(cma_id, false);
+		break;
 	default:
 		iser_err("Unexpected RDMA CM event (%d)\n", event->event);
 		break;
 	}
 	mutex_unlock(&iser_conn->state_mutex);
-	return 0;
+
+	return ret;
 }
 
 void iser_conn_init(struct iser_conn *iser_conn)
@@ -851,7 +918,7 @@ void iser_conn_init(struct iser_conn *iser_conn)
 	iser_conn->ib_conn.post_recv_buf_count = 0;
 	atomic_set(&iser_conn->ib_conn.post_send_buf_count, 0);
 	init_completion(&iser_conn->stop_completion);
-	init_completion(&iser_conn->flush_completion);
+	init_completion(&iser_conn->ib_completion);
 	init_completion(&iser_conn->up_completion);
 	INIT_LIST_HEAD(&iser_conn->conn_list);
 	spin_lock_init(&iser_conn->ib_conn.lock);
@@ -1100,28 +1167,8 @@ int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc)
 static void iser_handle_comp_error(struct iser_tx_desc *desc,
 				   struct ib_conn *ib_conn)
 {
-	struct iser_conn *iser_conn = container_of(ib_conn, struct iser_conn,
-						   ib_conn);
-
 	if (desc && desc->type == ISCSI_TX_DATAOUT)
 		kmem_cache_free(ig.desc_cache, desc);
-
-	if (ib_conn->post_recv_buf_count == 0 &&
-	    atomic_read(&ib_conn->post_send_buf_count) == 0) {
-		/**
-		 * getting here when the state is UP means that the conn is
-		 * being terminated asynchronously from the iSCSI layer's
-		 * perspective. It is safe to peek at the connection state
-		 * since iscsi_conn_failure is allowed to be called twice.
-		 **/
-		if (iser_conn->state == ISER_CONN_UP)
-			iscsi_conn_failure(iser_conn->iscsi_conn,
-					   ISCSI_ERR_CONN_FAILED);
-
-		/* no more non completed posts to the QP, complete the
-		 * termination process w.o worrying on disconnect event */
-		complete(&iser_conn->flush_completion);
-	}
 }
 
 static int iser_drain_tx_cq(struct iser_device  *device, int cq_index)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
