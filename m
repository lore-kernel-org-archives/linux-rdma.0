From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 3/4] nvme-rdma: wait for local invalidation before
 completing a request
Date: Wed, 22 Nov 2017 18:45:26 +0200
Message-ID: <35983721-ace6-7da2-eacf-951fbd556da4@mellanox.com>
References: <20171120113101.8292-1-sagi@grimberg.me>
 <20171120113101.8292-4-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120113101.8292-4-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: he
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> @@ -1337,8 +1335,19 @@ static int nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
>   	req->result = cqe->result;
>   
>   	if ((wc->wc_flags & IB_WC_WITH_INVALIDATE) &&
> -	    wc->ex.invalidate_rkey == req->mr->rkey)
> +	    wc->ex.invalidate_rkey == req->mr->rkey) {
>   		req->mr->need_inval = false;
> +	} else if (req->mr->need_inval) {
> +		ret = nvme_rdma_inv_rkey(queue, req);
> +		if (unlikely(ret < 0)) {
> +			dev_err(queue->ctrl->ctrl.device,
> +				"Queueing INV WR for rkey %#x failed (%d)\n",
> +				req->mr->rkey, ret);
> +			nvme_rdma_error_recovery(queue->ctrl);
> +		}
> +		/* the local invalidation completion will end the request */

inv completion or nvme_rdma_error_recovery will end the request...

> +		return 0;
> +	}
>   
>   	if (refcount_dec_and_test(&req->ref)) {
>   		if (rq->tag == tag)
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
