From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 2/3] nvme-rdma: don't complete requests before a send
 work request has completed
Date: Mon, 20 Nov 2017 13:12:41 +0200
Message-ID: <df9c9545-7c00-328b-9f98-535d8e889715@grimberg.me>
References: <20171108100616.26605-1-sagi@grimberg.me>
 <20171108100616.26605-3-sagi@grimberg.me> <20171109092110.GB16966@lst.de>
 <0f368bc9-2e9f-4008-316c-46b85661a274@grimberg.me>
 <20171120083130.GC27552@lst.de>
 <384d8a51-aa2f-5954-c9fd-a0c88d7e5364@grimberg.me>
 <20171120084102.GA28456@lst.de>
 <58bdc9c0-f98e-9d9f-f81e-fbed572f922e@grimberg.me>
 <20171120104921.GA31309@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120104921.GA31309-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> -	if ((wc->wc_flags & IB_WC_WITH_INVALIDATE) &&
> -	    wc->ex.invalidate_rkey == req->mr->rkey) {
> -		atomic_dec(&req->ref);
> -	} else if (req->mr->need_inval) {
> +	if (req->mr->need_inval &&
> +	    (!(wc->wc_flags & IB_WC_WITH_INVALIDATE) ||
> +	     wc->ex.invalidate_rkey != req->mr->rkey)) {

I've been meaning to change this path because getting a remote
invalidation on a bogus MR is a protocol error and we want to
detect it regardless of req->mr->need_inval.

However, I do agree that we can save a atomic if we bail out
after we queue a local invalidate:

How about this (should be split into two patches):
--
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index a3802de0f248..d0a5a397ad66 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1148,8 +1148,6 @@ static int nvme_rdma_map_sg_fr(struct 
nvme_rdma_queue *queue,
         sg->type = (NVME_KEY_SGL_FMT_DATA_DESC << 4) |
                         NVME_SGL_FMT_INVALIDATE;

-       refcount_inc(&req->ref);
-
         return 0;
  }

@@ -1335,10 +1333,14 @@ static int nvme_rdma_process_nvme_rsp(struct 
nvme_rdma_queue *queue,
         req->cqe.status = cqe->status;
         req->cqe.result = cqe->result;

-       if ((wc->wc_flags & IB_WC_WITH_INVALIDATE) &&
-           wc->ex.invalidate_rkey == req->mr->rkey) {
+       if (wc->wc_flags & IB_WC_WITH_INVALIDATE) {
+               if (unlikely(wc->ex.invalidate_rkey == req->mr->rkey)) {
+                       dev_err(queue->ctrl->ctrl.device,
+                               "Bogus remote invalidation for rkey %#x\n",
+                               req->mr->rkey);
+                       nvme_rdma_error_recovery(queue->ctrl);
+               }
                 req->mr->need_inval = false;
-               refcount_dec(&req->ref);
         } else if (req->mr->need_inval) {
                 ret = nvme_rdma_inv_rkey(queue, req);
                 if (unlikely(ret < 0)) {
@@ -1347,6 +1349,8 @@ static int nvme_rdma_process_nvme_rsp(struct 
nvme_rdma_queue *queue,
                                 req->mr->rkey, ret);
                         nvme_rdma_error_recovery(queue->ctrl);
                 }
+               /* return here as we can't really end the request */
+               return 0;
         }

         if (refcount_dec_and_test(&req->ref)) {
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
