From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 1/3 v5] IB/srp: Preparation for transmit ring response allocation
Date: Mon, 16 Aug 2010 20:54:06 +0200
Message-ID: <201008162054.06416.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The information unit transmit ring (srp_target.tx_ring) in ib_srp is currently
only used for allocating requests sent by the initiator to the target. This
patch prepares using that ring buffer for allocation of both requests and
responses. Also, this patch differentiates the uses of SRP_SQ_SIZE,
increases the size of the IB send completion queue by one element and
reserves one transmit ring slot for SRP_TSK_MGMT requests.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |   30 ++++++++++++++++++------------
 drivers/infiniband/ulp/srp/ib_srp.h |   13 ++++++++++---
 2 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 7f8f16b..548ba5d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -291,7 +291,7 @@ static void srp_free_target_ib(struct srp_target_port *target)
 
 	for (i = 0; i < SRP_RQ_SIZE; ++i)
 		srp_free_iu(target->srp_host, target->rx_ring[i]);
-	for (i = 0; i < SRP_SQ_SIZE + 1; ++i)
+	for (i = 0; i < SRP_SQ_SIZE; ++i)
 		srp_free_iu(target->srp_host, target->tx_ring[i]);
 }
 
@@ -822,7 +822,7 @@ static int srp_post_recv(struct srp_target_port *target)
 
 	spin_lock_irqsave(target->scsi_host->host_lock, flags);
 
-	next	 = target->rx_head & (SRP_RQ_SIZE - 1);
+	next	 = target->rx_head & SRP_RQ_MASK;
 	wr.wr_id = next;
 	iu	 = target->rx_ring[next];
 
@@ -989,19 +989,21 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 					enum srp_request_type req_type)
 {
-	s32 min = (req_type == SRP_REQ_TASK_MGMT) ? 1 : 2;
+	s32 rsv;
+
+	rsv = (req_type == SRP_REQ_TASK_MGMT) ? 0 : SRP_TASK_MGMT_SQ_SIZE;
 
 	srp_send_completion(target->send_cq, target);
 
 	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
 		return NULL;
 
-	if (target->req_lim < min) {
+	if (target->req_lim <= rsv) {
 		++target->zero_req_lim;
 		return NULL;
 	}
 
-	return target->tx_ring[target->tx_head & SRP_SQ_SIZE];
+	return target->tx_ring[target->tx_head & SRP_SQ_MASK];
 }
 
 /*
@@ -1020,7 +1022,7 @@ static int __srp_post_send(struct srp_target_port *target,
 	list.lkey   = target->srp_host->srp_dev->mr->lkey;
 
 	wr.next       = NULL;
-	wr.wr_id      = target->tx_head & SRP_SQ_SIZE;
+	wr.wr_id      = target->tx_head & SRP_SQ_MASK;
 	wr.sg_list    = &list;
 	wr.num_sge    = 1;
 	wr.opcode     = IB_WR_SEND;
@@ -1121,7 +1123,7 @@ static int srp_alloc_iu_bufs(struct srp_target_port *target)
 			goto err;
 	}
 
-	for (i = 0; i < SRP_SQ_SIZE + 1; ++i) {
+	for (i = 0; i < SRP_SQ_SIZE; ++i) {
 		target->tx_ring[i] = srp_alloc_iu(target->srp_host,
 						  srp_max_iu_len,
 						  GFP_KERNEL, DMA_TO_DEVICE);
@@ -1137,7 +1139,7 @@ err:
 		target->rx_ring[i] = NULL;
 	}
 
-	for (i = 0; i < SRP_SQ_SIZE + 1; ++i) {
+	for (i = 0; i < SRP_SQ_SIZE; ++i) {
 		srp_free_iu(target->srp_host, target->tx_ring[i]);
 		target->tx_ring[i] = NULL;
 	}
@@ -1626,9 +1628,9 @@ static struct scsi_host_template srp_template = {
 	.eh_abort_handler		= srp_abort,
 	.eh_device_reset_handler	= srp_reset_device,
 	.eh_host_reset_handler		= srp_reset_host,
-	.can_queue			= SRP_SQ_SIZE,
+	.can_queue			= SRP_NORMAL_REQ_SQ_SIZE,
 	.this_id			= -1,
-	.cmd_per_lun			= SRP_SQ_SIZE,
+	.cmd_per_lun			= SRP_NORMAL_REQ_SQ_SIZE,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= srp_host_attrs
 };
@@ -1813,7 +1815,8 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 				printk(KERN_WARNING PFX "bad max cmd_per_lun parameter '%s'\n", p);
 				goto out;
 			}
-			target->scsi_host->cmd_per_lun = min(token, SRP_SQ_SIZE);
+			target->scsi_host->cmd_per_lun
+				= min(token, SRP_NORMAL_REQ_SQ_SIZE);
 			break;
 
 		case SRP_OPT_IO_CLASS:
@@ -1891,7 +1894,7 @@ static ssize_t srp_create_target(struct device *dev,
 
 	INIT_LIST_HEAD(&target->free_reqs);
 	INIT_LIST_HEAD(&target->req_queue);
-	for (i = 0; i < SRP_SQ_SIZE; ++i) {
+	for (i = 0; i < SRP_NORMAL_REQ_SQ_SIZE; ++i) {
 		target->req_ring[i].index = i;
 		list_add_tail(&target->req_ring[i].list, &target->free_reqs);
 	}
@@ -2159,6 +2162,9 @@ static int __init srp_init_module(void)
 {
 	int ret;
 
+	BUILD_BUG_ON_NOT_POWER_OF_2(SRP_SQ_SIZE);
+	BUILD_BUG_ON_NOT_POWER_OF_2(SRP_RQ_SIZE);
+
 	if (srp_sg_tablesize > 255) {
 		printk(KERN_WARNING PFX "Clamping srp_sg_tablesize to 255\n");
 		srp_sg_tablesize = 255;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 5a80eac..3a566a7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -59,7 +59,14 @@ enum {
 
 	SRP_RQ_SHIFT    	= 6,
 	SRP_RQ_SIZE		= 1 << SRP_RQ_SHIFT,
-	SRP_SQ_SIZE		= SRP_RQ_SIZE - 1,
+	SRP_RQ_MASK		= SRP_RQ_SIZE - 1,
+
+	SRP_SQ_SIZE		= SRP_RQ_SIZE,
+	SRP_SQ_MASK		= SRP_SQ_SIZE - 1,
+	SRP_RSP_SQ_SIZE		= 1,
+	SRP_REQ_SQ_SIZE		= SRP_SQ_SIZE - SRP_RSP_SQ_SIZE,
+	SRP_TASK_MGMT_SQ_SIZE	= 1,
+	SRP_NORMAL_REQ_SQ_SIZE	= SRP_REQ_SQ_SIZE - SRP_TASK_MGMT_SQ_SIZE,
 
 	SRP_TAG_TSK_MGMT	= 1 << (SRP_RQ_SHIFT + 1),
 
@@ -144,11 +151,11 @@ struct srp_target_port {
 
 	unsigned		tx_head;
 	unsigned		tx_tail;
-	struct srp_iu	       *tx_ring[SRP_SQ_SIZE + 1];
+	struct srp_iu	       *tx_ring[SRP_SQ_SIZE];
 
 	struct list_head	free_reqs;
 	struct list_head	req_queue;
-	struct srp_request	req_ring[SRP_SQ_SIZE];
+	struct srp_request	req_ring[SRP_NORMAL_REQ_SQ_SIZE];
 
 	struct work_struct	work;
 
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
