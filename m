From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 7/9] IB/core: generic RDMA READ/WRITE API
Date: Thu, 10 Mar 2016 17:26:19 -0800
Message-ID: <56E21EBB.6060205@sandisk.com>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-8-git-send-email-hch@lst.de> <56DF44FC.8070103@sandisk.com>
 <20160309130723.GD31210@lst.de> <20160309155457.GA1898@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160309155457.GA1898-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/09/2016 07:54 AM, Christoph Hellwig wrote:
> +		if (i + 1 != ctx->nr_ops)
> +			rdma_wr->wr.next = &ctx->map.wrs[i + 1].wr;

Not that this really matters, but my own preference is to write such a 
comparison as i + 1 < ctx->nr_ops.

> @@ -787,6 +799,16 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
>
>   	atomic_inc(&pd->usecnt);
>   	atomic_inc(&qp_init_attr->send_cq->usecnt);
> +
> +	if (qp_init_attr->cap.max_rdma_ctxs) {
> +		ret = rdma_rw_init_mrs(qp, qp_init_attr);
> +		if (ret) {
> +			pr_err("failed to init MR pool ret= %d\n", ret);
> +			ib_destroy_qp(qp);
> +			qp = ERR_PTR(ret);
> +		}
> +	}

ib_destroy_qp() can fail and if it fails it does not decrement 
pd->usecnt. Does this have to be handled or reported in some way?

Otherwise this patch looks fine to me.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
