From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/vmw_pvrdma: Expose vendor error to ULPs
Date: Fri, 17 Feb 2017 10:37:33 -0800
Message-ID: <724b4c8f-6188-6988-daa2-39d1a9b28cbd@vmware.com>
References: <1487246705-11297-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487246705-11297-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 16, 2017 at 2:05:05PM +0200, Yuval Shaia wrote:
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> index e429ca5..69bda61 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> @@ -373,7 +373,7 @@ static int pvrdma_poll_one(struct pvrdma_cq *cq, struct pvrdma_qp **cur_qp,
>  	wc->sl = cqe->sl;
>  	wc->dlid_path_bits = cqe->dlid_path_bits;
>  	wc->port_num = cqe->port_num;
> -	wc->vendor_err = 0;
> +	wc->vendor_err = cqe->vendor_err;
>  
>  	/* Update shared ring state */
>  	pvrdma_idx_ring_inc(&cq->ring_state->rx.cons_head, cq->ibcq.cqe);

Thanks.

Acked-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
