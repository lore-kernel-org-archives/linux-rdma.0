From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 2/8] IB/srp: move IB CM setup completion into its own function
Date: Tue, 18 Jan 2011 23:27:16 -0500
Message-ID: <1295411242-26148-3-git-send-email-dillowda@ornl.gov>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1295411242-26148-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is to clean up prior to further changes.
---
 drivers/infiniband/ulp/srp/ib_srp.c |  144 ++++++++++++++++++-----------------
 1 files changed, 73 insertions(+), 71 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 197e26c..060e6a8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1213,6 +1213,78 @@ err:
 	return -ENOMEM;
 }
 
+static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
+			       struct srp_login_rsp *lrsp,
+			       struct srp_target_port *target)
+{
+	struct ib_qp_attr *qp_attr = NULL;
+	int attr_mask = 0;
+	int ret;
+	int i;
+
+	if (lrsp->opcode == SRP_LOGIN_RSP) {
+		target->max_ti_iu_len = be32_to_cpu(lrsp->max_ti_iu_len);
+		target->req_lim       = be32_to_cpu(lrsp->req_lim_delta);
+
+		/*
+		 * Reserve credits for task management so we don't
+		 * bounce requests back to the SCSI mid-layer.
+		 */
+		target->scsi_host->can_queue
+			= min(target->req_lim - SRP_TSK_MGMT_SQ_SIZE,
+			      target->scsi_host->can_queue);
+	} else {
+		shost_printk(KERN_WARNING, target->scsi_host,
+			     PFX "Unhandled RSP opcode %#x\n", lrsp->opcode);
+		ret = -ECONNRESET;
+		goto error;
+	}
+
+	if (!target->rx_ring[0]) {
+		ret = srp_alloc_iu_bufs(target);
+		if (ret)
+			goto error;
+	}
+
+	ret = -ENOMEM;
+	qp_attr = kmalloc(sizeof *qp_attr, GFP_KERNEL);
+	if (!qp_attr)
+		goto error;
+
+	qp_attr->qp_state = IB_QPS_RTR;
+	ret = ib_cm_init_qp_attr(cm_id, qp_attr, &attr_mask);
+	if (ret)
+		goto error_free;
+
+	ret = ib_modify_qp(target->qp, qp_attr, attr_mask);
+	if (ret)
+		goto error_free;
+
+	for (i = 0; i < SRP_RQ_SIZE; i++) {
+		struct srp_iu *iu = target->rx_ring[i];
+		ret = srp_post_recv(target, iu);
+		if (ret)
+			goto error_free;
+	}
+
+	qp_attr->qp_state = IB_QPS_RTS;
+	ret = ib_cm_init_qp_attr(cm_id, qp_attr, &attr_mask);
+	if (ret)
+		goto error_free;
+
+	ret = ib_modify_qp(target->qp, qp_attr, attr_mask);
+	if (ret)
+		goto error_free;
+
+	ret = ib_send_cm_rtu(cm_id, NULL, 0);
+
+error_free:
+	kfree(qp_attr);
+
+error:
+	target->status = ret;
+}
+
 static void srp_cm_rej_handler(struct ib_cm_id *cm_id,
 			       struct ib_cm_event *event,
 			       struct srp_target_port *target)
@@ -1296,11 +1368,7 @@ static void srp_cm_rej_handler(struct ib_cm_id *cm_id,
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 {
 	struct srp_target_port *target = cm_id->context;
-	struct ib_qp_attr *qp_attr = NULL;
-	int attr_mask = 0;
 	int comp = 0;
-	int opcode = 0;
-	int i;
 
 	switch (event->event) {
 	case IB_CM_REQ_ERROR:
@@ -1312,71 +1380,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 
 	case IB_CM_REP_RECEIVED:
 		comp = 1;
-		opcode = *(u8 *) event->private_data;
-
-		if (opcode == SRP_LOGIN_RSP) {
-			struct srp_login_rsp *rsp = event->private_data;
-
-			target->max_ti_iu_len = be32_to_cpu(rsp->max_ti_iu_len);
-			target->req_lim       = be32_to_cpu(rsp->req_lim_delta);
-
-			/*
-			 * Reserve credits for task management so we don't
-			 * bounce requests back to the SCSI mid-layer.
-			 */
-			target->scsi_host->can_queue
-				= min(target->req_lim - SRP_TSK_MGMT_SQ_SIZE,
-				      target->scsi_host->can_queue);
-		} else {
-			shost_printk(KERN_WARNING, target->scsi_host,
-				    PFX "Unhandled RSP opcode %#x\n", opcode);
-			target->status = -ECONNRESET;
-			break;
-		}
-
-		if (!target->rx_ring[0]) {
-			target->status = srp_alloc_iu_bufs(target);
-			if (target->status)
-				break;
-		}
-
-		qp_attr = kmalloc(sizeof *qp_attr, GFP_KERNEL);
-		if (!qp_attr) {
-			target->status = -ENOMEM;
-			break;
-		}
-
-		qp_attr->qp_state = IB_QPS_RTR;
-		target->status = ib_cm_init_qp_attr(cm_id, qp_attr, &attr_mask);
-		if (target->status)
-			break;
-
-		target->status = ib_modify_qp(target->qp, qp_attr, attr_mask);
-		if (target->status)
-			break;
-
-		for (i = 0; i < SRP_RQ_SIZE; i++) {
-			struct srp_iu *iu = target->rx_ring[i];
-			target->status = srp_post_recv(target, iu);
-			if (target->status)
-				break;
-		}
-		if (target->status)
-			break;
-
-		qp_attr->qp_state = IB_QPS_RTS;
-		target->status = ib_cm_init_qp_attr(cm_id, qp_attr, &attr_mask);
-		if (target->status)
-			break;
-
-		target->status = ib_modify_qp(target->qp, qp_attr, attr_mask);
-		if (target->status)
-			break;
-
-		target->status = ib_send_cm_rtu(cm_id, NULL, 0);
-		if (target->status)
-			break;
-
+		srp_cm_rep_handler(cm_id, event->private_data, target);
 		break;
 
 	case IB_CM_REJ_RECEIVED:
@@ -1416,8 +1420,6 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	if (comp)
 		complete(&target->done);
 
-	kfree(qp_attr);
-
 	return 0;
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
