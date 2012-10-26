From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 17/19] ib_srp: Add dev_loss_tmo support
Date: Fri, 26 Oct 2012 14:57:20 +0200
Message-ID: <508A88B0.70104@acm.org>
References: <508A85BB.1000505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <508A85BB.1000505-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove an SRP host if dev_loss_tmo expired.

Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   30 +++++++++++++++++++++++++++++-
 drivers/infiniband/ulp/srp/ib_srp.h |    2 ++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b3a09e9..7ed0c26 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -617,6 +617,7 @@ static void srp_remove_target(struct srp_target_port *target)
 		scsi_remove_host(shost);
 	}
 	srp_disconnect_target(target);
+	cancel_work_sync(&target->tl_err_work);
 	srp_free_target_ib(target);
 	srp_free_req_data(target);
 	scsi_host_put(shost);
@@ -834,6 +835,13 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	mutex_unlock(&target->mutex);
 
 	srp_disconnect_target(target);
+	cancel_work_sync(&target->tl_err_work);
+
+	mutex_lock(&target->mutex);
+	if (target->scsi_host_added)
+		srp_stop_tl_fail_timers(target->rport);
+	mutex_unlock(&target->mutex);
+
 	/*
 	 * Now get a new local CM ID so that we avoid confusing the
 	 * target in case things are really fouled up.
@@ -1439,15 +1447,32 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 			     PFX "Recv failed with error code %d\n", res);
 }
 
+/**
+ * srp_tl_err_work - Start the transport layer failure timers.
+ */
+static void srp_tl_err_work(struct work_struct *work)
+{
+	struct srp_target_port *target;
+
+	target = container_of(work, struct srp_target_port, tl_err_work);
+
+	mutex_lock(&target->mutex);
+	if (target->scsi_host_added)
+		srp_start_tl_fail_timers(target->rport, target->rq_tmo_jiffies);
+	mutex_unlock(&target->mutex);
+}
+
 static void srp_handle_qp_err(enum ib_wc_status wc_status,
 			      enum ib_wc_opcode wc_opcode,
 			      struct srp_target_port *target)
 {
-	if (target->connected && !target->qp_in_error)
+	if (target->connected && !target->qp_in_error) {
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "failed %s status %d\n",
 			     wc_opcode & IB_WC_RECV ? "receive" : "send",
 			     wc_status);
+		queue_work(system_long_wq, &target->tl_err_work);
+	}
 	target->qp_in_error = true;
 }
 
@@ -1808,6 +1833,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		if (ib_send_cm_drep(cm_id, NULL, 0))
 			shost_printk(KERN_ERR, target->scsi_host,
 				     PFX "Sending CM DREP failed\n");
+		queue_work(system_long_wq, &target->tl_err_work);
 		break;
 
 	case IB_CM_TIMEWAIT_EXIT:
@@ -2119,6 +2145,7 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 	}
 
 	rport->lld_data = target;
+	target->rport = rport;
 
 	return 0;
 }
@@ -2406,6 +2433,7 @@ static ssize_t srp_create_target(struct device *dev,
 			     target->cmd_sg_cnt * sizeof (struct srp_direct_buf);
 
 	mutex_init(&target->mutex);
+	INIT_WORK(&target->tl_err_work, srp_tl_err_work);
 	INIT_WORK(&target->remove_work, srp_remove_work);
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 4e0b413..99485a3 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -164,6 +164,7 @@ struct srp_target_port {
 	u16			io_class;
 	struct srp_host	       *srp_host;
 	struct Scsi_Host       *scsi_host;
+	struct srp_rport       *rport;
 	char			target_name[32];
 	unsigned int		scsi_id;
 	unsigned int		sg_tablesize;
@@ -188,6 +189,7 @@ struct srp_target_port {
 	struct srp_iu	       *rx_ring[SRP_RQ_SIZE];
 	struct srp_request	req_ring[SRP_CMD_SQ_SIZE];
 
+	struct work_struct	tl_err_work;
 	struct work_struct	remove_work;
 
 	struct list_head	list;
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
