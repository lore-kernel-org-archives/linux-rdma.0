From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 2/3] nvme-rdma: don't complete requests before a
        send work request has completed
Date: Mon, 20 Nov 2017 09:31:31 +0100
Message-ID: <20171120083130.GC27552@lst.de>
References: <20171108100616.26605-1-sagi@grimberg.me> <20171108100616.26605-3-sagi@grimberg.me> <20171109092110.GB16966@lst.de> <0f368bc9-2e9f-4008-316c-46b85661a274@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0f368bc9-2e9f-4008-316c-46b85661a274-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 09, 2017 at 01:14:23PM +0200, Sagi Grimberg wrote:
>> Wouldn't it be better to use atomic bitops (test_and_set_bit and co)
>> for these flags instead of needing a irqsave lock?
>
> Here it will be better, but in the next patch, where we need to check
> also for MR invalidation atomically I don't know.
>
> The logic is:
> 1. on RECV: complete if (send completed and MR invalidated)
> 2. on SEND: complete if (recv completed and MR invalidated)
> 3. on INV: complete if (recv completed and send completed)
>
> We need the conditions to be atomic because the CQ can be processed
> from two contexts (and trust me, it falls apart fast if we don't protect
> it). Not sure I understand how I can achieve this with atomic bitops.
>
> We could relax the spinlock to _bh I think as we are only racing with
> irq-poll.

Both send and recv completed only ever go from not set to set on a live
requests, so that's easy.  need_inval only goes from set to cleared
so I'm not too worried about it either, but due to the lack of atomic
bitops there it will need better memory barries, or just a switch
to bitops..

But looking at this in a little more detail I wonder if we just want
a recount on the nvme_rdma_request, untested patch below.  With a little
more work we can probably also remove the need_inval flag, but I think
I want to wait for the mr pool patch from Israel for that.

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index ef3373e56602..5627d81735d2 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -60,9 +60,7 @@ struct nvme_rdma_request {
 	struct ib_mr		*mr;
 	struct nvme_rdma_qe	sqe;
 	struct nvme_completion	cqe;
-	spinlock_t		lock;
-	bool			send_completed;
-	bool			resp_completed;
+	atomic_t		ref;
 	struct ib_sge		sge[1 + NVME_RDMA_MAX_INLINE_SEGMENTS];
 	u32			num_sge;
 	int			nents;
@@ -315,8 +313,6 @@ static int nvme_rdma_init_request(struct blk_mq_tag_set *set,
 	struct ib_device *ibdev = dev->dev;
 	int ret;
 
-	spin_lock_init(&req->lock);
-
 	ret = nvme_rdma_alloc_qe(ibdev, &req->sqe, sizeof(struct nvme_command),
 			DMA_TO_DEVICE);
 	if (ret)
@@ -1025,19 +1021,13 @@ static void nvme_rdma_inv_rkey_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct nvme_rdma_request *req =
 		container_of(wc->wr_cqe, struct nvme_rdma_request, reg_cqe);
 	struct request *rq = blk_mq_rq_from_pdu(req);
-	unsigned long flags;
-	bool end;
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		nvme_rdma_wr_error(cq, wc, "LOCAL_INV");
 		return;
 	}
 
-	spin_lock_irqsave(&req->lock, flags);
-	req->mr->need_inval = false;
-	end = (req->resp_completed && req->send_completed);
-	spin_unlock_irqrestore(&req->lock, flags);
-	if (end)
+	if (atomic_dec_and_test(&req->ref))
 		nvme_end_request(rq, req->cqe.status, req->cqe.result);
 
 }
@@ -1151,6 +1141,7 @@ static int nvme_rdma_map_sg_fr(struct nvme_rdma_queue *queue,
 			     IB_ACCESS_REMOTE_WRITE;
 
 	req->mr->need_inval = true;
+	atomic_inc(&req->ref);
 
 	sg->addr = cpu_to_le64(req->mr->iova);
 	put_unaligned_le24(req->mr->length, sg->length);
@@ -1172,8 +1163,7 @@ static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
 	req->num_sge = 1;
 	req->inline_data = false;
 	req->mr->need_inval = false;
-	req->send_completed = false;
-	req->resp_completed = false;
+	atomic_set(&req->ref, 2);
 
 	c->common.flags |= NVME_CMD_SGL_METABUF;
 
@@ -1215,19 +1205,13 @@ static void nvme_rdma_send_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct nvme_rdma_request *req =
 		container_of(qe, struct nvme_rdma_request, sqe);
 	struct request *rq = blk_mq_rq_from_pdu(req);
-	unsigned long flags;
-	bool end;
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		nvme_rdma_wr_error(cq, wc, "SEND");
 		return;
 	}
 
-	spin_lock_irqsave(&req->lock, flags);
-	req->send_completed = true;
-	end = req->resp_completed && !req->mr->need_inval;
-	spin_unlock_irqrestore(&req->lock, flags);
-	if (end)
+	if (atomic_dec_and_test(&req->ref))
 		nvme_end_request(rq, req->cqe.status, req->cqe.result);
 }
 
@@ -1330,8 +1314,6 @@ static int nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 	struct request *rq;
 	struct nvme_rdma_request *req;
 	int ret = 0;
-	unsigned long flags;
-	bool end;
 
 	rq = blk_mq_tag_to_rq(nvme_rdma_tagset(queue), cqe->command_id);
 	if (!rq) {
@@ -1348,7 +1330,7 @@ static int nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 
 	if ((wc->wc_flags & IB_WC_WITH_INVALIDATE) &&
 	    wc->ex.invalidate_rkey == req->mr->rkey) {
-		req->mr->need_inval = false;
+		atomic_dec(&req->ref);
 	} else if (req->mr->need_inval) {
 		ret = nvme_rdma_inv_rkey(queue, req);
 		if (unlikely(ret < 0)) {
@@ -1359,11 +1341,7 @@ static int nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 		}
 	}
 
-	spin_lock_irqsave(&req->lock, flags);
-	req->resp_completed = true;
-	end = req->send_completed && !req->mr->need_inval;
-	spin_unlock_irqrestore(&req->lock, flags);
-	if (end) {
+	if (atomic_dec_and_test(&req->ref)) {
 		if (rq->tag == tag)
 			ret = 1;
 		nvme_end_request(rq, req->cqe.status, req->cqe.result);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
