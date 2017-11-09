From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 2/3] nvme-rdma: don't complete requests before a
        send work request has completed
Date: Thu, 9 Nov 2017 10:21:10 +0100
Message-ID: <20171109092110.GB16966@lst.de>
References: <20171108100616.26605-1-sagi@grimberg.me> <20171108100616.26605-3-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171108100616.26605-3-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +	}
> +
> +	spin_lock_irqsave(&req->lock, flags);
> +	req->send_completed = true;
> +	end = req->resp_completed;
> +	spin_unlock_irqrestore(&req->lock, flags);

Wouldn't it be better to use atomic bitops (test_and_set_bit and co)
for these flags instead of needing a irqsave lock?

>  	err = nvme_rdma_post_send(queue, sqe, req->sge, req->num_sge,
> -			req->mr->need_inval ? &req->reg_wr.wr : NULL);
> +			req->mr->need_inval ? &req->reg_wr.wr : NULL, true);

Looks like the unsignalled completions just removed in the last patch
are coming back here.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
