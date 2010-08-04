From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/srp receive buffer handling robustness improvement
Date: Wed, 04 Aug 2010 11:45:59 -0700
Message-ID: <adaaap28bdk.fsf@roland-alpha.cisco.com>
References: <201007301259.05796.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201007301259.05796.bvanassche-HInyCGIudOg@public.gmane.org> (Bart Van Assche's
	message of "Fri, 30 Jul 2010 12:59:05 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks, I combined these patches and also got rid of __srp_post_recv()
since we don't need the split anymore... so I queued the patch below.
(Bart, by the way, this patch didn't have a "---" after the changelog
part, and also didn't have a diffstat for the patch.  If you use git,
then "git format-patch" will generate a patch without you having to
worry about these trivial details)


IB/srp: Make receive buffer handling more robust

The current strategy in ib_srp for posting receive buffers is:

 * Post one buffer after channel establishment.
 * Post one buffer before sending an SRP_CMD or SRP_TSK_MGMT to the target.

As a result, only the first non-SRP_RSP information unit from the
target will be processed.  If that first information unit is an
SRP_T_LOGOUT, it will be processed.  On the other hand, if the
initiator receives an SRP_CRED_REQ or SRP_AER_REQ before it receives a
SRP_T_LOGOUT, the SRP_T_LOGOUT won't be processed.

We can fix this inconsistency by changing the strategy for posting
receive buffers to:

 * Post all receive buffers after channel establishment.
 * After a receive buffer has been consumed and processed, post it again.

A side effect is that the ib_post_recv() call is moved out of the SCSI
command processing path.  Since __srp_post_recv() is not called
directly any more, get rid of it and move the code directly into
srp_post_recv().  Also, move srp_post_recv() up in the file to avoid a
forward declaration.

Signed-off-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   89 +++++++++++++++++------------------
 1 files changed, 44 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 4675def..ffdd2d1 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -811,6 +811,38 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 	return len;
 }
 
+static int srp_post_recv(struct srp_target_port *target)
+{
+	unsigned long flags;
+	struct srp_iu *iu;
+	struct ib_sge list;
+	struct ib_recv_wr wr, *bad_wr;
+	unsigned int next;
+	int ret;
+
+	spin_lock_irqsave(target->scsi_host->host_lock, flags);
+
+	next	 = target->rx_head & (SRP_RQ_SIZE - 1);
+	wr.wr_id = next;
+	iu	 = target->rx_ring[next];
+
+	list.addr   = iu->dma;
+	list.length = iu->size;
+	list.lkey   = target->srp_host->srp_dev->mr->lkey;
+
+	wr.next     = NULL;
+	wr.sg_list  = &list;
+	wr.num_sge  = 1;
+
+	ret = ib_post_recv(target->qp, &wr, &bad_wr);
+	if (!ret)
+		++target->rx_head;
+
+	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
+
+	return ret;
+}
+
 static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 {
 	struct srp_request *req;
@@ -868,6 +900,7 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 {
 	struct ib_device *dev;
 	struct srp_iu *iu;
+	int res;
 	u8 opcode;
 
 	iu = target->rx_ring[wc->wr_id];
@@ -904,6 +937,11 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 
 	ib_dma_sync_single_for_device(dev, iu->dma, target->max_ti_iu_len,
 				      DMA_FROM_DEVICE);
+
+	res = srp_post_recv(target);
+	if (res != 0)
+		shost_printk(KERN_ERR, target->scsi_host,
+			     PFX "Recv failed with error code %d\n", res);
 }
 
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
@@ -943,45 +981,6 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 	}
 }
 
-static int __srp_post_recv(struct srp_target_port *target)
-{
-	struct srp_iu *iu;
-	struct ib_sge list;
-	struct ib_recv_wr wr, *bad_wr;
-	unsigned int next;
-	int ret;
-
-	next 	 = target->rx_head & (SRP_RQ_SIZE - 1);
-	wr.wr_id = next;
-	iu 	 = target->rx_ring[next];
-
-	list.addr   = iu->dma;
-	list.length = iu->size;
-	list.lkey   = target->srp_host->srp_dev->mr->lkey;
-
-	wr.next     = NULL;
-	wr.sg_list  = &list;
-	wr.num_sge  = 1;
-
-	ret = ib_post_recv(target->qp, &wr, &bad_wr);
-	if (!ret)
-		++target->rx_head;
-
-	return ret;
-}
-
-static int srp_post_recv(struct srp_target_port *target)
-{
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(target->scsi_host->host_lock, flags);
-	ret = __srp_post_recv(target);
-	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
-
-	return ret;
-}
-
 /*
  * Must be called with target->scsi_host->host_lock held to protect
  * req_lim and tx_head.  Lock cannot be dropped between call here and
@@ -1091,11 +1090,6 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 		goto err;
 	}
 
-	if (__srp_post_recv(target)) {
-		shost_printk(KERN_ERR, target->scsi_host, PFX "Recv failed\n");
-		goto err_unmap;
-	}
-
 	ib_dma_sync_single_for_device(dev, iu->dma, srp_max_iu_len,
 				      DMA_TO_DEVICE);
 
@@ -1238,6 +1232,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	int attr_mask = 0;
 	int comp = 0;
 	int opcode = 0;
+	int i;
 
 	switch (event->event) {
 	case IB_CM_REQ_ERROR:
@@ -1287,7 +1282,11 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		if (target->status)
 			break;
 
-		target->status = srp_post_recv(target);
+		for (i = 0; i < SRP_RQ_SIZE; i++) {
+			target->status = srp_post_recv(target);
+			if (target->status)
+				break;
+		}
 		if (target->status)
 			break;
 
-- 
1.7.2


-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
