From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: [RFC PATCH 1/3] IB/srp: differentiate the uses of SRP_SQ_SIZE
Date: Sun,  3 Jan 2010 20:43:35 -0500
Message-ID: <1262569417-20341-1-git-send-email-dave@thedillows.org>
References: <1262568846.13289.4.camel@obelisk.thedillows.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1262568846.13289.4.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
In-Reply-To: <1262568846.13289.4.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
References: <1262568846.13289.4.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SRP_SQ_SIZE was used in many places that needed to know about the
real size of the data structures, and needed to use a magic offset.
Additionally, the meaning of the value was different depending on
where it was used. Prepare for future work by naming the use
appropriately for the site.

Also, document the assumptions about the ring sizes being a power of 2.
---
The BUILD_BUG_ON() needs to be reworked, once a version of is_power_of_2
that works at compile time is committed upstream. This version is a little
obfuscated for my taste, but I don't want to define a local macro for it
either.

 drivers/infiniband/ulp/srp/ib_srp.c |   24 ++++++++++++++----------
 drivers/infiniband/ulp/srp/ib_srp.h |   10 +++++++---
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 54c8fe2..82e7f9d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -274,7 +274,7 @@ static void srp_free_target_ib(struct srp_target_port *target)
 
 	for (i = 0; i < SRP_RQ_SIZE; ++i)
 		srp_free_iu(target->srp_host, target->rx_ring[i]);
-	for (i = 0; i < SRP_SQ_SIZE + 1; ++i)
+	for (i = 0; i < SRP_SQ_SIZE; ++i)
 		srp_free_iu(target->srp_host, target->tx_ring[i]);
 }
 
@@ -970,7 +970,7 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 {
 	s32 min = (req_type == SRP_REQ_TASK_MGMT) ? 1 : 2;
 
-	if (target->tx_head - target->tx_tail >= SRP_SQ_SIZE)
+	if (target->tx_head - target->tx_tail >= SRP_SQ_FULL)
 		return NULL;
 
 	if (target->req_lim < min) {
@@ -978,7 +978,7 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 		return NULL;
 	}
 
-	return target->tx_ring[target->tx_head & SRP_SQ_SIZE];
+	return target->tx_ring[target->tx_head & SRP_SQ_MASK];
 }
 
 /*
@@ -997,7 +997,7 @@ static int __srp_post_send(struct srp_target_port *target,
 	list.lkey   = target->srp_host->srp_dev->mr->lkey;
 
 	wr.next       = NULL;
-	wr.wr_id      = target->tx_head & SRP_SQ_SIZE;
+	wr.wr_id      = target->tx_head & SRP_SQ_MASK;
 	wr.sg_list    = &list;
 	wr.num_sge    = 1;
 	wr.opcode     = IB_WR_SEND;
@@ -1103,7 +1103,7 @@ static int srp_alloc_iu_bufs(struct srp_target_port *target)
 			goto err;
 	}
 
-	for (i = 0; i < SRP_SQ_SIZE + 1; ++i) {
+	for (i = 0; i < SRP_SQ_SIZE; ++i) {
 		target->tx_ring[i] = srp_alloc_iu(target->srp_host,
 						  srp_max_iu_len,
 						  GFP_KERNEL, DMA_TO_DEVICE);
@@ -1119,7 +1119,7 @@ err:
 		target->rx_ring[i] = NULL;
 	}
 
-	for (i = 0; i < SRP_SQ_SIZE + 1; ++i) {
+	for (i = 0; i < SRP_SQ_SIZE; ++i) {
 		srp_free_iu(target->srp_host, target->tx_ring[i]);
 		target->tx_ring[i] = NULL;
 	}
@@ -1589,9 +1589,9 @@ static struct scsi_host_template srp_template = {
 	.eh_abort_handler		= srp_abort,
 	.eh_device_reset_handler	= srp_reset_device,
 	.eh_host_reset_handler		= srp_reset_host,
-	.can_queue			= SRP_SQ_SIZE,
+	.can_queue			= SRP_MAX_CREDIT,
 	.this_id			= -1,
-	.cmd_per_lun			= SRP_SQ_SIZE,
+	.cmd_per_lun			= SRP_MAX_CREDIT,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= srp_host_attrs
 };
@@ -1776,7 +1776,7 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 				printk(KERN_WARNING PFX "bad max cmd_per_lun parameter '%s'\n", p);
 				goto out;
 			}
-			target->scsi_host->cmd_per_lun = min(token, SRP_SQ_SIZE);
+			target->scsi_host->cmd_per_lun = min(token, SRP_MAX_CREDIT);
 			break;
 
 		case SRP_OPT_IO_CLASS:
@@ -1854,7 +1854,7 @@ static ssize_t srp_create_target(struct device *dev,
 
 	INIT_LIST_HEAD(&target->free_reqs);
 	INIT_LIST_HEAD(&target->req_queue);
-	for (i = 0; i < SRP_SQ_SIZE; ++i) {
+	for (i = 0; i < SRP_MAX_CREDIT; ++i) {
 		target->req_ring[i].index = i;
 		list_add_tail(&target->req_ring[i].list, &target->free_reqs);
 	}
@@ -2122,6 +2122,10 @@ static int __init srp_init_module(void)
 {
 	int ret;
 
+	/* This code assumes that the ring sizes are powers of two */
+	BUILD_BUG_ON(SRP_RQ_SIZE != (1UL << ilog2(SRP_RQ_SIZE)));
+	BUILD_BUG_ON(SRP_SQ_SIZE != (1UL << ilog2(SRP_SQ_SIZE)));
+
 	if (srp_sg_tablesize > 255) {
 		printk(KERN_WARNING PFX "Clamping srp_sg_tablesize to 255\n");
 		srp_sg_tablesize = 255;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index e185b90..2742969 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -59,9 +59,13 @@ enum {
 
 	SRP_RQ_SHIFT    	= 6,
 	SRP_RQ_SIZE		= 1 << SRP_RQ_SHIFT,
-	SRP_SQ_SIZE		= SRP_RQ_SIZE - 1,
+	SRP_SQ_SIZE		= SRP_RQ_SIZE,
 	SRP_CQ_SIZE		= SRP_SQ_SIZE + SRP_RQ_SIZE,
 
+	SRP_SQ_FULL		= SRP_SQ_SIZE - 1,
+	SRP_SQ_MASK		= SRP_SQ_SIZE - 1,
+	SRP_MAX_CREDIT		= SRP_SQ_SIZE - 1,
+
 	SRP_TAG_TSK_MGMT	= 1 << (SRP_RQ_SHIFT + 1),
 
 	SRP_FMR_SIZE		= 256,
@@ -146,11 +150,11 @@ struct srp_target_port {
 
 	unsigned		tx_head;
 	unsigned		tx_tail;
-	struct srp_iu	       *tx_ring[SRP_SQ_SIZE + 1];
+	struct srp_iu	       *tx_ring[SRP_SQ_SIZE];
 
 	struct list_head	free_reqs;
 	struct list_head	req_queue;
-	struct srp_request	req_ring[SRP_SQ_SIZE];
+	struct srp_request	req_ring[SRP_MAX_CREDIT];
 
 	struct work_struct	work;
 
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
