From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 7/8] IB/iser: Replace connection waitqueue with completion object
Date: Thu, 31 Jul 2014 13:27:50 +0300
Message-ID: <1406802471-23359-8-git-send-email-ogerlitz@mellanox.com>
References: <1406802471-23359-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406802471-23359-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Instead of waiting for events and condition changes of the iser connection
state, we wait for explicit completion of connection establishment and teardown.

Separate connection establishment wait object from the teardown object to avoid
a situation where racing connection establishment and teardown may concurrently
wakeup each other.

ep_poll will wait for up_completion invoked by iser_connected_handler() and iser
release worker will wait for flush_completion before releasing the connection.

Bound the completion wait with a 30 seconds timeout for cases where iscsid
(the user space iscsi daemon) is too slow or gone.

Signed-off-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   13 ++++++-------
 drivers/infiniband/ulp/iser/iscsi_iser.h |    3 ++-
 drivers/infiniband/ulp/iser/iser_verbs.c |   29 ++++++++++++++---------------
 3 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 3dc853c..61ee91d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -627,10 +627,8 @@ iscsi_iser_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 	int rc;
 
 	ib_conn = ep->dd_data;
-	rc = wait_event_interruptible_timeout(ib_conn->wait,
-			     ib_conn->state == ISER_CONN_UP,
-			     msecs_to_jiffies(timeout_ms));
-
+	rc = wait_for_completion_interruptible_timeout(&ib_conn->up_completion,
+						       msecs_to_jiffies(timeout_ms));
 	/* if conn establishment failed, return error code to iscsi */
 	if (rc == 0) {
 		mutex_lock(&ib_conn->state_mutex);
@@ -661,9 +659,10 @@ iscsi_iser_ep_disconnect(struct iscsi_endpoint *ep)
 	iser_conn_terminate(ib_conn);
 
 	/*
-	 * if iser_conn and iscsi_conn are bound, we must wait iscsi_conn_stop
-	 * call and ISER_CONN_DOWN state before freeing the iser resources.
-	 * otherwise we are safe to free resources immediately.
+	 * if iser_conn and iscsi_conn are bound, we must wait for
+	 * iscsi_conn_stop and flush errors completion before freeing
+	 * the iser resources. Otherwise we are safe to free resources
+	 * immediately.
 	 */
 	if (ib_conn->iscsi_conn) {
 		INIT_WORK(&ib_conn->release_work, iser_release_work);
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index c7efc5a..c877dad 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -326,7 +326,6 @@ struct iser_conn {
 	struct iser_device           *device;       /* device context          */
 	struct rdma_cm_id            *cma_id;       /* CMA ID		       */
 	struct ib_qp	             *qp;           /* QP 		       */
-	wait_queue_head_t	     wait;          /* waitq for conn/disconn  */
 	unsigned		     qp_max_recv_dtos; /* num of rx buffers */
 	unsigned		     qp_max_recv_dtos_mask; /* above minus 1 */
 	unsigned		     min_posted_rx; /* qp_max_recv_dtos >> 2 */
@@ -336,6 +335,8 @@ struct iser_conn {
 	struct work_struct	     release_work;
 	struct completion	     stop_completion;
 	struct mutex		     state_mutex;
+	struct completion	     flush_completion;
+	struct completion	     up_completion;
 	struct list_head	     conn_list;       /* entry in ig conn list */
 
 	char  			     *login_buf;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 6e7e54d..06a49b3 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -582,15 +582,19 @@ static int iser_conn_state_comp_exch(struct iser_conn *ib_conn,
 void iser_release_work(struct work_struct *work)
 {
 	struct iser_conn *ib_conn;
+	int rc;
 
 	ib_conn = container_of(work, struct iser_conn, release_work);
 
 	/* wait for .conn_stop callback */
-	wait_for_completion(&ib_conn->stop_completion);
+	rc = wait_for_completion_timeout(&ib_conn->stop_completion, 30 * HZ);
+	WARN_ON(rc == 0);
 
 	/* wait for the qp`s post send and post receive buffers to empty */
-	wait_event_interruptible(ib_conn->wait,
-				 ib_conn->state == ISER_CONN_DOWN);
+	rc = wait_for_completion_timeout(&ib_conn->flush_completion, 30 * HZ);
+	WARN_ON(rc == 0);
+
+	ib_conn->state = ISER_CONN_DOWN;
 
 	mutex_lock(&ib_conn->state_mutex);
 	ib_conn->state = ISER_CONN_DOWN;
@@ -656,9 +660,7 @@ static void iser_connect_error(struct rdma_cm_id *cma_id)
 	struct iser_conn *ib_conn;
 
 	ib_conn = (struct iser_conn *)cma_id->context;
-
 	ib_conn->state = ISER_CONN_DOWN;
-	wake_up_interruptible(&ib_conn->wait);
 }
 
 /**
@@ -761,9 +763,8 @@ static void iser_connected_handler(struct rdma_cm_id *cma_id)
 	(void)ib_query_qp(cma_id->qp, &attr, ~0, &init_attr);
 	iser_info("remote qpn:%x my qpn:%x\n", attr.dest_qp_num, cma_id->qp->qp_num);
 
-	ib_conn = (struct iser_conn *)cma_id->context;
-	if (iser_conn_state_comp_exch(ib_conn, ISER_CONN_PENDING, ISER_CONN_UP))
-		wake_up_interruptible(&ib_conn->wait);
+	ib_conn->state = ISER_CONN_UP;
+	complete(&ib_conn->up_completion);
 }
 
 static void iser_disconnected_handler(struct rdma_cm_id *cma_id)
@@ -785,8 +786,7 @@ static void iser_disconnected_handler(struct rdma_cm_id *cma_id)
 	/* Complete the termination process if no posts are pending */
 	if (ib_conn->post_recv_buf_count == 0 &&
 	    (atomic_read(&ib_conn->post_send_buf_count) == 0)) {
-		ib_conn->state = ISER_CONN_DOWN;
-		wake_up_interruptible(&ib_conn->wait);
+		complete(&ib_conn->flush_completion);
 	}
 }
 
@@ -833,10 +833,11 @@ static int iser_cma_handler(struct rdma_cm_id *cma_id, struct rdma_cm_event *eve
 void iser_conn_init(struct iser_conn *ib_conn)
 {
 	ib_conn->state = ISER_CONN_INIT;
-	init_waitqueue_head(&ib_conn->wait);
 	ib_conn->post_recv_buf_count = 0;
 	atomic_set(&ib_conn->post_send_buf_count, 0);
 	init_completion(&ib_conn->stop_completion);
+	init_completion(&ib_conn->flush_completion);
+	init_completion(&ib_conn->up_completion);
 	INIT_LIST_HEAD(&ib_conn->conn_list);
 	spin_lock_init(&ib_conn->lock);
 	mutex_init(&ib_conn->state_mutex);
@@ -880,8 +881,7 @@ int iser_connect(struct iser_conn   *ib_conn,
 	}
 
 	if (!non_blocking) {
-		wait_event_interruptible(ib_conn->wait,
-					 (ib_conn->state != ISER_CONN_PENDING));
+		wait_for_completion_interruptible(&ib_conn->up_completion);
 
 		if (ib_conn->state != ISER_CONN_UP) {
 			err =  -EIO;
@@ -1097,8 +1097,7 @@ static void iser_handle_comp_error(struct iser_tx_desc *desc,
 
 		/* no more non completed posts to the QP, complete the
 		 * termination process w.o worrying on disconnect event */
-		ib_conn->state = ISER_CONN_DOWN;
-		wake_up_interruptible(&ib_conn->wait);
+		complete(&ib_conn->flush_completion);
 	}
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
