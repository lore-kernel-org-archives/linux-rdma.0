From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 05/10] IB/srp: Start timers if a transport layer error occurs
Date: Thu, 10 Oct 2013 14:14:12 +0200
Message-ID: <52569A14.8020204@acm.org>
References: <52569806.9080201@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52569806.9080201-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Start the reconnect timer, fast_io_fail timer and dev_loss timers
if a transport layer error occurs.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 19 +++++++++++++++++++
 drivers/infiniband/ulp/srp/ib_srp.h |  1 +
 2 files changed, 20 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 5551f3b..ceb84b6 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -593,6 +593,7 @@ static void srp_remove_target(struct srp_target_port *target)
 	srp_disconnect_target(target);
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
+	cancel_work_sync(&target->tl_err_work);
 	srp_rport_put(target->rport);
 	srp_free_req_data(target);
 
@@ -1363,6 +1364,21 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 			     PFX "Recv failed with error code %d\n", res);
 }
 
+/**
+ * srp_tl_err_work() - handle a transport layer error
+ *
+ * Note: This function may get invoked before the rport has been created,
+ * hence the target->rport test.
+ */
+static void srp_tl_err_work(struct work_struct *work)
+{
+	struct srp_target_port *target;
+
+	target = container_of(work, struct srp_target_port, tl_err_work);
+	if (target->rport)
+		srp_start_tl_fail_timers(target->rport);
+}
+
 static void srp_handle_qp_err(enum ib_wc_status wc_status, bool send_err,
 			      struct srp_target_port *target)
 {
@@ -1371,6 +1387,7 @@ static void srp_handle_qp_err(enum ib_wc_status wc_status, bool send_err,
 			     PFX "failed %s status %d\n",
 			     send_err ? "send" : "receive",
 			     wc_status);
+		queue_work(system_long_wq, &target->tl_err_work);
 	}
 	target->qp_in_error = true;
 }
@@ -1733,6 +1750,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		if (ib_send_cm_drep(cm_id, NULL, 0))
 			shost_printk(KERN_ERR, target->scsi_host,
 				     PFX "Sending CM DREP failed\n");
+		queue_work(system_long_wq, &target->tl_err_work);
 		break;
 
 	case IB_CM_TIMEWAIT_EXIT:
@@ -2419,6 +2437,7 @@ static ssize_t srp_create_target(struct device *dev,
 			     sizeof (struct srp_indirect_buf) +
 			     target->cmd_sg_cnt * sizeof (struct srp_direct_buf);
 
+	INIT_WORK(&target->tl_err_work, srp_tl_err_work);
 	INIT_WORK(&target->remove_work, srp_remove_work);
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index fd1817e..446b045 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -177,6 +177,7 @@ struct srp_target_port {
 	struct srp_iu	       *rx_ring[SRP_RQ_SIZE];
 	struct srp_request	req_ring[SRP_CMD_SQ_SIZE];
 
+	struct work_struct	tl_err_work;
 	struct work_struct	remove_work;
 
 	struct list_head	list;
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
