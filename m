From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 2/3] nvme-rdma: don't complete requests before a
        send work request has completed
Date: Mon, 20 Nov 2017 11:49:21 +0100
Message-ID: <20171120104921.GA31309@lst.de>
References: <20171108100616.26605-1-sagi@grimberg.me> <20171108100616.26605-3-sagi@grimberg.me> <20171109092110.GB16966@lst.de> <0f368bc9-2e9f-4008-316c-46b85661a274@grimberg.me> <20171120083130.GC27552@lst.de> <384d8a51-aa2f-5954-c9fd-a0c88d7e5364@grimberg.me> <20171120084102.GA28456@lst.de> <58bdc9c0-f98e-9d9f-f81e-fbed572f922e@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58bdc9c0-f98e-9d9f-f81e-fbed572f922e-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Btw, I think we can avoid 2 atomic ops for the remote invalidation
path with a simple update like the one below:


diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 5627d81735d2..2032cd8ad431 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1141,7 +1141,6 @@ static int nvme_rdma_map_sg_fr(struct nvme_rdma_queue *queue,
 			     IB_ACCESS_REMOTE_WRITE;
 
 	req->mr->need_inval = true;
-	atomic_inc(&req->ref);
 
 	sg->addr = cpu_to_le64(req->mr->iova);
 	put_unaligned_le24(req->mr->length, sg->length);
@@ -1328,10 +1327,9 @@ static int nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 	req->cqe.status = cqe->status;
 	req->cqe.result = cqe->result;
 
-	if ((wc->wc_flags & IB_WC_WITH_INVALIDATE) &&
-	    wc->ex.invalidate_rkey == req->mr->rkey) {
-		atomic_dec(&req->ref);
-	} else if (req->mr->need_inval) {
+	if (req->mr->need_inval &&
+	    (!(wc->wc_flags & IB_WC_WITH_INVALIDATE) ||
+	     wc->ex.invalidate_rkey != req->mr->rkey)) {
 		ret = nvme_rdma_inv_rkey(queue, req);
 		if (unlikely(ret < 0)) {
 			dev_err(queue->ctrl->ctrl.device,
@@ -1339,12 +1337,12 @@ static int nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 				req->mr->rkey, ret);
 			nvme_rdma_error_recovery(queue->ctrl);
 		}
-	}
-
-	if (atomic_dec_and_test(&req->ref)) {
-		if (rq->tag == tag)
-			ret = 1;
-		nvme_end_request(rq, req->cqe.status, req->cqe.result);
+	} else {
+		if (atomic_dec_and_test(&req->ref)) {
+			if (rq->tag == tag)
+				ret = 1;
+			nvme_end_request(rq, req->cqe.status, req->cqe.result);
+		}
 	}
 
 	return ret;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
