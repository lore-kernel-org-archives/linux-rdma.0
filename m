From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/srp: Fix initiator lockup
Date: Sat, 2 Jan 2010 13:19:13 +0100
Message-ID: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When the SRP initiator is communicating with an SRP target under load it can
happen that the SRP initiator locks up. The communication pattern that causes
the lockup is as follows:
* SRP initiator sends (req_lim - 2) SRP_CMD requests to the target.
* The REQUEST LIMIT DELTA field of each SRP_RSP response is zero.
* The target sends an SRP_CRED_REQ information unit with non-zero REQUEST
  LIMIT DELTA.

The above communication pattern brings the initiator in the following state:
* srp_queuecommand() always returns SCSI_MLQUEUE_HOST_BUSY.
* The per-session variable zero_req_lim keeps increasing.
The initiator never leaves this state because it ignores SRP_CRED_REQ
information units.

This patch fixes this issue by adding support for SRP_CRED_REQ information
units in the SRP initiator. Additionally, this patch makes the per-session
variable req_lim visible through sysfs, which makes observing the initiator
state easier.

See also http://bugzilla.kernel.org/show_bug.cgi?id=14235

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
b/drivers/infiniband/ulp/srp/ib_srp.c
index 54c8fe2..2006a0a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2005 Cisco Systems.  All rights reserved.
+ * Copyright (c) 2009 Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -53,6 +54,8 @@
 #define PFX		DRV_NAME ": "
 #define DRV_VERSION	"0.2"
 #define DRV_RELDATE	"November 1, 2005"
+/* Similar to is_power_of_2(), but can be evaluated at compile time. */
+#define IS_POWER_OF_2(n) ((n) != 0 && (((n) & ((n) - 1)) == 0))

 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand SCSI RDMA Protocol initiator "
@@ -82,6 +85,11 @@ static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device);
 static void srp_completion(struct ib_cq *cq, void *target_ptr);
 static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event);
+static void srp_process_cred_req(struct srp_target_port *target,
+				 struct srp_cred_req *req);
+static void srp_process_aer_req(struct srp_target_port *target,
+				struct srp_cred_req *req);
+static int srp_post_recv(struct srp_target_port *target);

 static struct scsi_transport_template *ib_srp_transport_template;

@@ -237,7 +245,7 @@ static int srp_create_target_ib(struct
srp_target_port *target)
 	ib_req_notify_cq(target->cq, IB_CQ_NEXT_COMP);

 	init_attr->event_handler       = srp_qp_event;
-	init_attr->cap.max_send_wr     = SRP_SQ_SIZE;
+	init_attr->cap.max_send_wr     = SRP_SQ_SIZE + SRP_TXP_SIZE;
 	init_attr->cap.max_recv_wr     = SRP_RQ_SIZE;
 	init_attr->cap.max_recv_sge    = 1;
 	init_attr->cap.max_send_sge    = 1;
@@ -272,10 +280,12 @@ static void srp_free_target_ib(struct
srp_target_port *target)
 	ib_destroy_qp(target->qp);
 	ib_destroy_cq(target->cq);

-	for (i = 0; i < SRP_RQ_SIZE; ++i)
+	for (i = 0; i < ARRAY_SIZE(target->rx_ring); ++i)
 		srp_free_iu(target->srp_host, target->rx_ring[i]);
-	for (i = 0; i < SRP_SQ_SIZE + 1; ++i)
+	for (i = 0; i < ARRAY_SIZE(target->tx_ring); ++i)
 		srp_free_iu(target->srp_host, target->tx_ring[i]);
+	for (i = 0; i < ARRAY_SIZE(target->txp_ring); ++i)
+		srp_free_iu(target->srp_host, target->txp_ring[i]);
 }

 static void srp_path_rec_completion(int status,
@@ -888,6 +898,14 @@ static void srp_handle_recv(struct
srp_target_port *target, struct ib_wc *wc)
 			     PFX "Got target logout request\n");
 		break;

+	case SRP_CRED_REQ:
+		srp_process_cred_req(target, iu->buf);
+		break;
+
+	case SRP_AER_REQ:
+		srp_process_aer_req(target, iu->buf);
+		break;
+
 	default:
 		shost_printk(KERN_WARNING, target->scsi_host,
 			     PFX "Unhandled SRP opcode 0x%02x\n", opcode);
@@ -908,7 +926,11 @@ static void srp_completion(struct ib_cq *cq, void
*target_ptr)
 		if (wc.status) {
 			shost_printk(KERN_ERR, target->scsi_host,
 				     PFX "failed %s status %d\n",
-				     wc.wr_id & SRP_OP_RECV ? "receive" : "send",
+				     wc.wr_id & SRP_OP_RECV
+				     ? "receiving"
+				     : wc.wr_id & SRP_OP_TXP
+				     ? "sending response"
+				     : "sending request",
 				     wc.status);
 			target->qp_in_error = 1;
 			break;
@@ -916,6 +938,8 @@ static void srp_completion(struct ib_cq *cq, void
*target_ptr)

 		if (wc.wr_id & SRP_OP_RECV)
 			srp_handle_recv(target, &wc);
+		else if (wc.wr_id & SRP_OP_TXP)
+			++target->txp_tail;
 		else
 			++target->tx_tail;
 	}
@@ -961,15 +985,19 @@ static int srp_post_recv(struct srp_target_port *target)
 }

 /*
+ * Obtain an information unit for sending a request to the target.
+ *
  * Must be called with target->scsi_host->host_lock held to protect
  * req_lim and tx_head.  Lock cannot be dropped between call here and
- * call to __srp_post_send().
+ * call to __srp_post_send_req().
  */
 static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 					enum srp_request_type req_type)
 {
 	s32 min = (req_type == SRP_REQ_TASK_MGMT) ? 1 : 2;

+	BUILD_BUG_ON(!IS_POWER_OF_2(ARRAY_SIZE(target->tx_ring)));
+
 	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
 		return NULL;

@@ -978,26 +1006,31 @@ static struct srp_iu *__srp_get_tx_iu(struct
srp_target_port *target,
 		return NULL;
 	}

-	return target->tx_ring[target->tx_head & SRP_SQ_SIZE];
+	return target->tx_ring[target->tx_head
+			       & (ARRAY_SIZE(target->tx_ring) - 1)];
 }

 /*
+ * Send a request to the target.
+ *
  * Must be called with target->scsi_host->host_lock held to protect
  * req_lim and tx_head.
  */
-static int __srp_post_send(struct srp_target_port *target,
-			   struct srp_iu *iu, int len)
+static int __srp_post_send_req(struct srp_target_port *target,
+			       struct srp_iu *iu, int len)
 {
 	struct ib_sge list;
 	struct ib_send_wr wr, *bad_wr;
 	int ret = 0;

+	BUILD_BUG_ON(!IS_POWER_OF_2(ARRAY_SIZE(target->tx_ring)));
+
 	list.addr   = iu->dma;
 	list.length = len;
 	list.lkey   = target->srp_host->srp_dev->mr->lkey;

 	wr.next       = NULL;
-	wr.wr_id      = target->tx_head & SRP_SQ_SIZE;
+	wr.wr_id      = target->tx_head & (ARRAY_SIZE(target->tx_ring) - 1);
 	wr.sg_list    = &list;
 	wr.num_sge    = 1;
 	wr.opcode     = IB_WR_SEND;
@@ -1013,6 +1046,117 @@ static int __srp_post_send(struct
srp_target_port *target,
 	return ret;
 }

+/*
+ * Obtain an information unit for sending a response to the target.
+ *
+ * Must be called with target->scsi_host->host_lock held to protect
+ * req_lim and tx_head.  Lock cannot be dropped between call here and
+ * call to __srp_post_send_rsp().
+ */
+static struct srp_iu *__srp_get_txp_iu(struct srp_target_port *target)
+{
+	BUILD_BUG_ON(!IS_POWER_OF_2(SRP_TXP_SIZE));
+
+	if (WARN_ON(target->txp_head - target->txp_tail >= SRP_TXP_SIZE))
+		return NULL;
+
+	return target->txp_ring[target->txp_head & (SRP_TXP_SIZE - 1)];
+}
+
+/*
+ * Send a response to a request received from the target.
+ *
+ * Must be called with target->scsi_host->host_lock held to protect txp_head.
+ */
+static int __srp_post_send_rsp(struct srp_target_port *target,
+			       struct srp_iu *iu, int len)
+{
+	struct ib_sge list;
+	struct ib_send_wr wr, *bad_wr;
+	int ret = 0;
+
+	BUILD_BUG_ON(!IS_POWER_OF_2(SRP_TXP_SIZE));
+
+	list.addr   = iu->dma;
+	list.length = len;
+	list.lkey   = target->srp_host->srp_dev->mr->lkey;
+
+	wr.next       = NULL;
+	wr.wr_id      = (target->txp_head & (SRP_TXP_SIZE - 1)) | SRP_OP_TXP;
+	wr.sg_list    = &list;
+	wr.num_sge    = 1;
+	wr.opcode     = IB_WR_SEND;
+	wr.send_flags = IB_SEND_SIGNALED;
+
+	ret = ib_post_send(target->qp, &wr, &bad_wr);
+
+	if (!ret)
+		++target->txp_head;
+
+	return ret;
+}
+
+static void srp_process_cred_req(struct srp_target_port *target,
+				 struct srp_cred_req *req)
+{
+	struct ib_device *dev;
+	struct srp_iu *iu;
+	struct srp_cred_rsp *rsp;
+	unsigned long flags;
+	int res;
+	s32 delta;
+	u64 tag;
+
+	dev = target->srp_host->srp_dev->dev;
+	delta = (s32) be32_to_cpu(req->req_lim_delta);
+	tag = req->tag;
+
+	spin_lock_irqsave(target->scsi_host->host_lock, flags);
+
+	target->req_lim += delta;
+
+	iu = __srp_get_txp_iu(target);
+	if (!iu)
+		goto out;
+
+	rsp = iu->buf;
+
+	ib_dma_sync_single_for_cpu(dev, iu->dma, sizeof(*rsp),
+				   DMA_TO_DEVICE);
+
+	memset(rsp, 0, sizeof *rsp);
+	rsp->opcode = SRP_CRED_RSP;
+	rsp->tag    = tag;
+
+	ib_dma_sync_single_for_device(dev, iu->dma, srp_max_iu_len,
+				      DMA_TO_DEVICE);
+
+	if (__srp_post_send_rsp(target, iu, sizeof(*rsp)))
+		shost_printk(KERN_ERR, target->scsi_host,
+			     PFX "Sending response failed\n");
+
+	res = __srp_post_recv(target);
+	if (res)
+		shost_printk(KERN_ERR, target->scsi_host,
+			     PFX "ib_post_recv() failed -- res = %d\n", res);
+
+out:
+	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
+}
+
+static void srp_process_aer_req(struct srp_target_port *target,
+				 struct srp_cred_req *req)
+{
+	int res;
+
+	shost_printk(KERN_ERR, target->scsi_host,
+		     PFX "received and ignored SRP_AER_REQ\n");
+	res = srp_post_recv(target);
+	if (res)
+		shost_printk(KERN_ERR, target->scsi_host,
+			     PFX "ib_post_recv() failed -- res = %d\n", res);
+}
+
 static int srp_queuecommand(struct scsi_cmnd *scmnd,
 			    void (*done)(struct scsi_cmnd *))
 {
@@ -1075,8 +1219,9 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 	ib_dma_sync_single_for_device(dev, iu->dma, srp_max_iu_len,
 				      DMA_TO_DEVICE);

-	if (__srp_post_send(target, iu, len)) {
-		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
+	if (__srp_post_send_req(target, iu, len)) {
+		shost_printk(KERN_ERR, target->scsi_host,
+			     PFX "Sending request failed\n");
 		goto err_unmap;
 	}

@@ -1095,7 +1240,7 @@ static int srp_alloc_iu_bufs(struct
srp_target_port *target)
 {
 	int i;

-	for (i = 0; i < SRP_RQ_SIZE; ++i) {
+	for (i = 0; i < ARRAY_SIZE(target->rx_ring); ++i) {
 		target->rx_ring[i] = srp_alloc_iu(target->srp_host,
 						  target->max_ti_iu_len,
 						  GFP_KERNEL, DMA_FROM_DEVICE);
@@ -1103,7 +1248,7 @@ static int srp_alloc_iu_bufs(struct
srp_target_port *target)
 			goto err;
 	}

-	for (i = 0; i < SRP_SQ_SIZE + 1; ++i) {
+	for (i = 0; i < ARRAY_SIZE(target->tx_ring); ++i) {
 		target->tx_ring[i] = srp_alloc_iu(target->srp_host,
 						  srp_max_iu_len,
 						  GFP_KERNEL, DMA_TO_DEVICE);
@@ -1111,19 +1256,32 @@ static int srp_alloc_iu_bufs(struct
srp_target_port *target)
 			goto err;
 	}

+	for (i = 0; i < ARRAY_SIZE(target->txp_ring); ++i) {
+		target->txp_ring[i] = srp_alloc_iu(target->srp_host,
+						  srp_max_iu_len,
+						  GFP_KERNEL, DMA_TO_DEVICE);
+		if (!target->txp_ring[i])
+			goto err;
+	}
+
 	return 0;

 err:
-	for (i = 0; i < SRP_RQ_SIZE; ++i) {
+	for (i = 0; i < ARRAY_SIZE(target->rx_ring); ++i) {
 		srp_free_iu(target->srp_host, target->rx_ring[i]);
 		target->rx_ring[i] = NULL;
 	}

-	for (i = 0; i < SRP_SQ_SIZE + 1; ++i) {
+	for (i = 0; i < ARRAY_SIZE(target->tx_ring); ++i) {
 		srp_free_iu(target->srp_host, target->tx_ring[i]);
 		target->tx_ring[i] = NULL;
 	}

+	for (i = 0; i < ARRAY_SIZE(target->txp_ring); ++i) {
+		srp_free_iu(target->srp_host, target->txp_ring[i]);
+		target->tx_ring[i] = NULL;
+	}
+
 	return -ENOMEM;
 }

@@ -1211,6 +1369,7 @@ static int srp_cm_handler(struct ib_cm_id
*cm_id, struct ib_cm_event *event)
 {
 	struct srp_target_port *target = cm_id->context;
 	struct ib_qp_attr *qp_attr = NULL;
+	int i;
 	int attr_mask = 0;
 	int comp = 0;
 	int opcode = 0;
@@ -1263,7 +1422,11 @@ static int srp_cm_handler(struct ib_cm_id
*cm_id, struct ib_cm_event *event)
 		if (target->status)
 			break;

-		target->status = srp_post_recv(target);
+		for (i = 0; i < SRP_RXR_SIZE; ++i) {
+			target->status = srp_post_recv(target);
+			if (target->status)
+				break;
+		}
 		if (target->status)
 			break;

@@ -1353,7 +1516,7 @@ static int srp_send_tsk_mgmt(struct
srp_target_port *target,
 	tsk_mgmt->tsk_mgmt_func = func;
 	tsk_mgmt->task_tag 	= req->index;

-	if (__srp_post_send(target, iu, sizeof *tsk_mgmt))
+	if (__srp_post_send_req(target, iu, sizeof *tsk_mgmt))
 		goto out;

 	req->tsk_mgmt = iu;
@@ -1529,6 +1692,18 @@ static ssize_t show_orig_dgid(struct device *dev,
 	return sprintf(buf, "%pI6\n", target->orig_dgid);
 }

+static ssize_t show_req_lim(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+
+	if (target->state == SRP_TARGET_DEAD ||
+	    target->state == SRP_TARGET_REMOVED)
+		return -ENODEV;
+
+	return sprintf(buf, "%d\n", target->req_lim);
+}
+
 static ssize_t show_zero_req_lim(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
@@ -1563,6 +1738,7 @@ static DEVICE_ATTR(service_id,	    S_IRUGO,
show_service_id,	   NULL);
 static DEVICE_ATTR(pkey,	    S_IRUGO, show_pkey,		   NULL);
 static DEVICE_ATTR(dgid,	    S_IRUGO, show_dgid,		   NULL);
 static DEVICE_ATTR(orig_dgid,	    S_IRUGO, show_orig_dgid,	   NULL);
+static DEVICE_ATTR(req_lim,	    S_IRUGO, show_req_lim,	   NULL);
 static DEVICE_ATTR(zero_req_lim,    S_IRUGO, show_zero_req_lim,	   NULL);
 static DEVICE_ATTR(local_ib_port,   S_IRUGO, show_local_ib_port,   NULL);
 static DEVICE_ATTR(local_ib_device, S_IRUGO, show_local_ib_device, NULL);
@@ -1574,6 +1750,7 @@ static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_pkey,
 	&dev_attr_dgid,
 	&dev_attr_orig_dgid,
+	&dev_attr_req_lim,
 	&dev_attr_zero_req_lim,
 	&dev_attr_local_ib_port,
 	&dev_attr_local_ib_device,
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h
b/drivers/infiniband/ulp/srp/ib_srp.h
index e185b90..c553a03 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -57,10 +57,20 @@ enum {
 	SRP_MAX_LUN		= 512,
 	SRP_DEF_SG_TABLESIZE	= 12,

+	/*
+	 * Receive queue: queue for receiving responses and requests from the
+	 * target.
+	 */
 	SRP_RQ_SHIFT    	= 6,
 	SRP_RQ_SIZE		= 1 << SRP_RQ_SHIFT,
-	SRP_SQ_SIZE		= SRP_RQ_SIZE - 1,
-	SRP_CQ_SIZE		= SRP_SQ_SIZE + SRP_RQ_SIZE,
+	/* Number of receive slots reserved for receiving requests. */
+	SRP_RXR_SIZE		= 2,
+	/* Send queue: queue for sending requests to the target. */
+	SRP_SQ_SIZE		= SRP_RQ_SIZE - SRP_RXR_SIZE - 1,
+	/* Size of the queue for sending responses to the target. */
+	SRP_TXP_SIZE            = 2,
+	/* Completion queue. */
+	SRP_CQ_SIZE		= SRP_SQ_SIZE + SRP_TXP_SIZE + SRP_RQ_SIZE,

 	SRP_TAG_TSK_MGMT	= 1 << (SRP_RQ_SHIFT + 1),

@@ -69,6 +79,9 @@ enum {
 	SRP_FMR_DIRTY_SIZE	= SRP_FMR_POOL_SIZE / 4
 };

+/* wr_id / wc_id flag for marking responses sent to the target. */
+#define SRP_OP_TXP		(1 << 30)
+/* wr_id / wc_id flag for marking receive operations. */
 #define SRP_OP_RECV		(1 << 31)

 enum srp_target_state {
@@ -141,12 +154,20 @@ struct srp_target_port {

 	int			zero_req_lim;

+
+	/* Receive ring for responses and requests received by the initiator. */
 	unsigned		rx_head;
 	struct srp_iu	       *rx_ring[SRP_RQ_SIZE];

+	/* Transmit ring for requests sent to the target. */
 	unsigned		tx_head;
 	unsigned		tx_tail;
-	struct srp_iu	       *tx_ring[SRP_SQ_SIZE + 1];
+	struct srp_iu	       *tx_ring[SRP_SQ_SIZE + SRP_RXR_SIZE + 1];
+
+	/* Transmit ring for responses sent to the target. */
+	unsigned		txp_head;
+	unsigned		txp_tail;
+	struct srp_iu	       *txp_ring[SRP_TXP_SIZE];

 	struct list_head	free_reqs;
 	struct list_head	req_queue;
diff --git a/include/scsi/srp.h b/include/scsi/srp.h
index ad178fa..55c16c7 100644
--- a/include/scsi/srp.h
+++ b/include/scsi/srp.h
@@ -239,4 +239,26 @@ struct srp_rsp {
 	u8	data[0];
 } __attribute__((packed));

+/*
+ * SRP_CRED_REQ information unit, as defined in section 6.10 of the
+ * T10 SRP r16a document.
+ */
+struct srp_cred_req {
+	u8	opcode;
+	u8	sol_not;
+	u8	reserved[2];
+	__be32	req_lim_delta;
+	u64	tag;
+} __attribute__((packed));
+
+/*
+ * SRP_CRED_RSP information unit, as defined in section 6.11 of the
+ * T10 SRP r16a document.
+ */
+struct srp_cred_rsp {
+	u8	opcode;
+	u8	reserved[7];
+	u64	tag;
+} __attribute__((packed));
+
 #endif /* SCSI_SRP_H */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
