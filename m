From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v5 2/4] nvme-rdma: don't complete requests before a
        send work request has completed
Date: Thu, 23 Nov 2017 09:08:58 +0100
Message-ID: <20171123080858.GA20524@lst.de>
References: <20171122185838.28855-1-sagi@grimberg.me> <20171122185838.28855-3-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171122185838.28855-3-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  static void nvme_rdma_send_done(struct ib_cq *cq, struct ib_wc *wc)
>  {
> -	if (unlikely(wc->status != IB_WC_SUCCESS))
> +	struct nvme_rdma_qe *qe;
> +	struct nvme_rdma_request *req;
> +	struct request *rq;
> +
> +	if (unlikely(wc->status != IB_WC_SUCCESS)) {
>  		nvme_rdma_wr_error(cq, wc, "SEND");
> +		return;
> +	}
> +
> +	qe = container_of(wc->wr_cqe, struct nvme_rdma_qe, cqe);
> +	req = container_of(qe, struct nvme_rdma_request, sqe);
> +	rq = blk_mq_rq_from_pdu(req);

This add least needs a comment that this is for the AEN request.

Or we'll just use a separate completion handler for the AEN.  In fact
it seems to me that we might want to just stop using nvme_rdma_post_send
for the AEN request and just open code the sending in both callers.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
