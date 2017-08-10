From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 for-rc] RDMA/vmw_pvrdma: Report CQ missed events
Date: Thu, 10 Aug 2017 23:02:56 +0300
Message-ID: <20170810200256.GA4913@yuvallap>
References: <1502391902-5674-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502391902-5674-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 10, 2017 at 12:05:02PM -0700, Adit Ranadive wrote:
> From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> 
> There is a chance of a race between arming the CQ and receiving
> completions. By reporting CQ missed events any ULPs should poll
> again to get the completions.
> 
> Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
> Acked-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
> v0 -> v1:
>  - Check for invalid ring index.
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> index 69bda61..90aa326 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> @@ -65,13 +65,28 @@ int pvrdma_req_notify_cq(struct ib_cq *ibcq,
>  	struct pvrdma_dev *dev = to_vdev(ibcq->device);
>  	struct pvrdma_cq *cq = to_vcq(ibcq);
>  	u32 val = cq->cq_handle;
> +	unsigned long flags;
> +	int has_data = 0;
>  
>  	val |= (notify_flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
>  		PVRDMA_UAR_CQ_ARM_SOL : PVRDMA_UAR_CQ_ARM;
>  
> +	spin_lock_irqsave(&cq->cq_lock, flags);
> +
>  	pvrdma_write_uar_cq(dev, val);
>  
> -	return 0;
> +	if (notify_flags & IB_CQ_REPORT_MISSED_EVENTS) {
> +		unsigned int head;
> +
> +		has_data = pvrdma_idx_ring_has_data(&cq->ring_state->rx,
> +						    cq->ibcq.cqe, &head);
> +		if (unlikely(has_data == PVRDMA_INVALID_IDX))
> +			dev_err(&dev->pdev->dev, "CQ ring state invalid\n");

I see the point of checking the return value but per my understanding, and
correct me if i'm wrong, this rare case points to a corrupted ring which
can happen *only* in case of a bug so it is not "error" by nature.
If this is correct then i don't see the point of having this "question" on
every call to ib_notify_cq.

Do you agree to move this check to pvrdma_idx_ring_has_data and even make
the function use BUG_ON?

> +	}
> +
> +	spin_unlock_irqrestore(&cq->cq_lock, flags);
> +
> +	return has_data;
>  }
>  
>  /**
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
