From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 06/18] ib_srp: Wait for last completion when disconnecting
Date: Sat, 14 Jan 2012 12:44:18 +0000
Message-ID: <1559902.bolRMFhoqP@asus>
References: <3109536.qySrY1Ts3e@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3109536.qySrY1Ts3e@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dillowda-1Heg1YXhbW8@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When disconnecting the IB connection via the IB CM, wait until
any invoked completion handlers have finished processing SRP
protocol data and prevent that new work completions are queued.
Change the IB completion handlers such that all error completions
are processed instead of a subset and also such that receiving a
completion with zero wr_id is recognized as an end-of-work marker.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   81 ++++++++++++++++++++++++++++++----
 drivers/infiniband/ulp/srp/ib_srp.h |    3 +
 2 files changed, 74 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ad8f168..0265a10 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -40,7 +40,7 @@
 #include <linux/parser.h>
 #include <linux/random.h>
 #include <linux/jiffies.h>
-
+#include <linux/delay.h>
 #include <linux/atomic.h>
 
 #include <scsi/scsi.h>
@@ -443,8 +443,58 @@ static bool srp_change_conn_state(struct srp_target_port *target,
 	return changed;
 }
 
+static void srp_wait_last_recv_wqe(struct srp_target_port *target)
+{
+	struct ib_recv_wr wr, *bad_wr;
+	int ret;
+
+	if (target->last_recv_wqe)
+		return;
+
+	memset(&wr, 0, sizeof(wr));
+	ret = ib_post_recv(target->qp, &wr, &bad_wr);
+	if (ret < 0) {
+		shost_printk(KERN_ERR, target->scsi_host,
+			     "ib_post_recv() failed (%d)\n", ret);
+		return;
+	}
+
+	ret = wait_event_timeout(target->qp_wq, target->last_recv_wqe,
+				 target->rq_tmo_jiffies);
+	WARN(ret <= 0, "Timeout while waiting for last recv WQE (ret = %d)\n",
+	     ret);
+}
+
+static void srp_wait_last_send_wqe(struct srp_target_port *target)
+{
+	unsigned long deadline = jiffies + target->rq_tmo_jiffies;
+	struct ib_send_wr wr, *bad_wr;
+	int ret;
+
+	if (target->last_send_wqe)
+		return;
+
+	memset(&wr, 0, sizeof(wr));
+	ret = ib_post_send(target->qp, &wr, &bad_wr);
+	if (ret < 0) {
+		shost_printk(KERN_ERR, target->scsi_host,
+			     "ib_post_send() failed (%d)\n", ret);
+		return;
+	}
+
+	while (!target->last_send_wqe && time_before(jiffies, deadline)) {
+		srp_send_completion(target->send_cq, target);
+		msleep(20);
+	}
+
+	WARN_ON(!target->last_send_wqe);
+}
+
 static void srp_disconnect_target(struct srp_target_port *target)
 {
+	struct ib_qp_attr qp_attr;
+	int ret;
+
 	if (srp_change_conn_state(target, false)) {
 		/* XXX should send SRP_I_LOGOUT request */
 
@@ -456,6 +506,16 @@ static void srp_disconnect_target(struct srp_target_port *target)
 			wait_for_completion(&target->done);
 		}
 	}
+
+	if (target->qp) {
+		qp_attr.qp_state = IB_QPS_ERR;
+		ret = ib_modify_qp(target->qp, &qp_attr, IB_QP_STATE);
+		WARN(ret != 0, "ib_modify_qp() failed: %d\n", ret);
+
+		srp_wait_last_recv_wqe(target);
+
+		srp_wait_last_send_wqe(target);
+	}
 }
 
 static bool srp_change_state(struct srp_target_port *target,
@@ -535,6 +595,8 @@ static int srp_connect_target(struct srp_target_port *target)
 	WARN_ON(target->connected);
 
 	target->qp_in_error = false;
+	target->last_recv_wqe = false;
+	target->last_send_wqe = false;
 
 	ret = srp_lookup_path(target);
 	if (ret)
@@ -631,7 +693,6 @@ static void srp_reset_req(struct srp_target_port *target, struct srp_request *re
 static int srp_reconnect_target(struct srp_target_port *target)
 {
 	struct ib_qp_attr qp_attr;
-	struct ib_wc wc;
 	int i, ret;
 
 	if (target->state != SRP_TARGET_LIVE)
@@ -655,11 +716,6 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	if (ret)
 		goto err;
 
-	while (ib_poll_cq(target->recv_cq, 1, &wc) > 0)
-		; /* nothing */
-	while (ib_poll_cq(target->send_cq, 1, &wc) > 0)
-		; /* nothing */
-
 	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
 		struct srp_request *req = &target->req_ring[i];
 		if (req->scmnd)
@@ -1237,7 +1293,7 @@ static void srp_handle_qp_err(enum ib_wc_status wc_status,
 			      enum ib_wc_opcode wc_opcode,
 			      struct srp_target_port *target)
 {
-	if (target->connected)
+	if (target->connected && !target->qp_in_error)
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "failed %s status %d\n",
 			     wc_opcode & IB_WC_RECV ? "receive" : "send",
@@ -1257,9 +1313,12 @@ static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 			if (likely(wc[i].status == IB_WC_SUCCESS)) {
 				srp_handle_recv(target, &wc[i]);
 			} else {
+				if (wc[i].wr_id == 0) {
+					target->last_recv_wqe = true;
+					wake_up(&target->qp_wq);
+				}
 				srp_handle_qp_err(wc[i].status, wc[i].opcode,
 						  target);
-				return;
 			}
 		}
 	}
@@ -1278,9 +1337,10 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 				iu = (struct srp_iu *) (uintptr_t) wc[i].wr_id;
 				list_add(&iu->list, &target->free_tx);
 			} else {
+				if (wc[i].wr_id == 0)
+					target->last_send_wqe = true;
 				srp_handle_qp_err(wc[i].status, wc[i].opcode,
 						  target);
-				return;
 			}
 		}
 	}
@@ -2231,6 +2291,7 @@ static ssize_t srp_create_target(struct device *dev,
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
 	INIT_LIST_HEAD(&target->free_reqs);
+	init_waitqueue_head(&target->qp_wq);
 	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
 		struct srp_request *req = &target->req_ring[i];
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 5f288fe..fc411ae 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -183,6 +183,9 @@ struct srp_target_port {
 	struct completion	done;
 	int			status;
 	bool			qp_in_error;
+	bool			last_recv_wqe;
+	bool			last_send_wqe;
+	wait_queue_head_t	qp_wq;
 
 	struct completion	tsk_mgmt_done;
 	u8			tsk_mgmt_status;
-- 
1.7.7


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
