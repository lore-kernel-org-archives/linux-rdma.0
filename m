From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 1/4 v3] IB/srp: preparation for send ring response allocation
Date: Tue, 3 Aug 2010 16:08:33 +0200
Message-ID: <201008031608.33373.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The information unit send ring (srp_target.tx_ring) in ib_srp is currently
used for allocating requests sent by the initiator to the target. This patch
prepares using that ring for allocation of both requests and responses. Also,
this patch differentiates the uses of SRP_SQ_SIZE and increases the size of
the IB send completion queue by one element.

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index bc2d512..1284bc3 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -320,7 +321,7 @@ static void srp_free_target_ib(struct srp_target_port *target)
 
 	for (i = 0; i < SRP_RQ_SIZE; ++i)
 		srp_free_iu(target->srp_host, target->rx_ring[i]);
-	for (i = 0; i < SRP_SQ_SIZE + 1; ++i)
+	for (i = 0; i < SRP_SQ_SIZE; ++i)
 		srp_free_iu(target->srp_host, target->tx_ring[i]);
 }
 
@@ -848,7 +849,7 @@ static int __srp_post_recv(struct srp_target_port *target)
 	unsigned int next;
 	int ret;
 
-	next	 = target->rx_head & (SRP_RQ_SIZE - 1);
+	next	 = target->rx_head & SRP_RQ_MASK;
 	wr.wr_id = next;
 	iu	 = target->rx_ring[next];
 
@@ -1051,7 +1052,7 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 
 	srp_send_completion(target->send_cq, target);
 
-	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
+	if (target->tx_head - target->tx_tail >= SRP_REQ_SQ_SIZE)
 		return NULL;
 
 	if (target->req_lim < min) {
@@ -1059,7 +1060,7 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 		return NULL;
 	}
 
-	return target->tx_ring[target->tx_head & SRP_SQ_SIZE];
+	return target->tx_ring[target->tx_head & SRP_SQ_MASK];
 }
 
 /*
@@ -1078,7 +1079,7 @@ static int __srp_post_send(struct srp_target_port *target,
 	list.lkey   = target->srp_host->srp_dev->mr->lkey;
 
 	wr.next       = NULL;
-	wr.wr_id      = target->tx_head & SRP_SQ_SIZE;
+	wr.wr_id      = target->tx_head & SRP_SQ_MASK;
 	wr.sg_list    = &list;
 	wr.num_sge    = 1;
 	wr.opcode     = IB_WR_SEND;
@@ -1179,7 +1180,7 @@ static int srp_alloc_iu_bufs(struct srp_target_port *target)
 			goto err;
 	}
 
-	for (i = 0; i < SRP_SQ_SIZE + 1; ++i) {
+	for (i = 0; i < SRP_SQ_SIZE; ++i) {
 		target->tx_ring[i] = srp_alloc_iu(target->srp_host,
 						  srp_max_iu_len,
 						  GFP_KERNEL, DMA_TO_DEVICE);
@@ -1195,7 +1196,7 @@ err:
 		target->rx_ring[i] = NULL;
 	}
 
-	for (i = 0; i < SRP_SQ_SIZE + 1; ++i) {
+	for (i = 0; i < SRP_SQ_SIZE; ++i) {
 		srp_free_iu(target->srp_host, target->tx_ring[i]);
 		target->tx_ring[i] = NULL;
 	}
@@ -1670,9 +1671,9 @@ static struct scsi_host_template srp_template = {
 	.eh_abort_handler		= srp_abort,
 	.eh_device_reset_handler	= srp_reset_device,
 	.eh_host_reset_handler		= srp_reset_host,
-	.can_queue			= SRP_SQ_SIZE,
+	.can_queue			= SRP_REQ_SQ_SIZE,
 	.this_id			= -1,
-	.cmd_per_lun			= SRP_SQ_SIZE,
+	.cmd_per_lun			= SRP_REQ_SQ_SIZE,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= srp_host_attrs
 };
@@ -1857,7 +1858,8 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 				printk(KERN_WARNING PFX "bad max cmd_per_lun parameter '%s'\n", p);
 				goto out;
 			}
-			target->scsi_host->cmd_per_lun = min(token, SRP_SQ_SIZE);
+			target->scsi_host->cmd_per_lun = min(token,
+							     SRP_REQ_SQ_SIZE);
 			break;
 
 		case SRP_OPT_IO_CLASS:
@@ -1935,7 +1937,7 @@ static ssize_t srp_create_target(struct device *dev,
 
 	INIT_LIST_HEAD(&target->free_reqs);
 	INIT_LIST_HEAD(&target->req_queue);
-	for (i = 0; i < SRP_SQ_SIZE; ++i) {
+	for (i = 0; i < SRP_REQ_SQ_SIZE; ++i) {
 		target->req_ring[i].index = i;
 		list_add_tail(&target->req_ring[i].list, &target->free_reqs);
 	}
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 5ceb4a4..9efff05 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -59,7 +59,12 @@ enum {
 
 	SRP_RQ_SHIFT    	= 6,
 	SRP_RQ_SIZE		= 1 << SRP_RQ_SHIFT,
-	SRP_SQ_SIZE		= SRP_RQ_SIZE - 1,
+	SRP_RQ_MASK		= SRP_RQ_SIZE - 1,
+
+	SRP_SQ_SIZE		= SRP_RQ_SIZE,
+	SRP_SQ_MASK		= SRP_SQ_SIZE - 1,
+	SRP_RSP_SQ_SIZE		= 1,
+	SRP_REQ_SQ_SIZE		= SRP_SQ_SIZE - SRP_RSP_SQ_SIZE,
 
 	SRP_TAG_TSK_MGMT	= 1 << (SRP_RQ_SHIFT + 1),
 
@@ -146,11 +151,11 @@ struct srp_target_port {
 
 	unsigned		tx_head;
 	unsigned		tx_tail;
-	struct srp_iu	       *tx_ring[SRP_SQ_SIZE + 1];
+	struct srp_iu	       *tx_ring[SRP_SQ_SIZE];
 
 	struct list_head	free_reqs;
 	struct list_head	req_queue;
-	struct srp_request	req_ring[SRP_SQ_SIZE];
+	struct srp_request	req_ring[SRP_REQ_SQ_SIZE];
 
 	struct work_struct	work;
 
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
