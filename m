From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/2] IB/rxe: Avoid accessing timers for non RC
 QPs
Date: Tue, 21 Mar 2017 10:31:56 +0200
Message-ID: <20170321083155.GC5970@yuval-lap>
References: <20170319092057.9103-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170319092057.9103-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 19, 2017 at 11:20:56AM +0200, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This patch avoids RNR NAK timer and retransmit timer initialization and
> cleanup for non RC QPs (such as UD QP, GSI QP).
> 
> Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_qp.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
> index f98a19e61a3d..3ad9b48212de 100644
> --- a/drivers/infiniband/sw/rxe/rxe_qp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_qp.c
> @@ -273,10 +273,11 @@ static int rxe_qp_init_req(struct rxe_dev *rxe, struct rxe_qp *qp,
>  	rxe_init_task(rxe, &qp->comp.task, qp,
>  		      rxe_completer, "comp");
>  
> -	setup_timer(&qp->rnr_nak_timer, rnr_nak_timer, (unsigned long)qp);
> -	setup_timer(&qp->retrans_timer, retransmit_timer, (unsigned long)qp);
>  	qp->qp_timeout_jiffies = 0; /* Can't be set for UD/UC in modify_qp */
> -
> +	if (init->qp_type == IB_QPT_RC) {
> +		setup_timer(&qp->rnr_nak_timer, rnr_nak_timer, (unsigned long)qp);
> +		setup_timer(&qp->retrans_timer, retransmit_timer, (unsigned long)qp);
> +	}
>  	return 0;
>  }
>  
> @@ -804,8 +805,10 @@ void rxe_qp_destroy(struct rxe_qp *qp)
>  	qp->qp_timeout_jiffies = 0;
>  	rxe_cleanup_task(&qp->resp.task);
>  
> -	del_timer_sync(&qp->retrans_timer);
> -	del_timer_sync(&qp->rnr_nak_timer);
> +	if (qp_type(qp) == IB_QPT_RC) {
> +		del_timer_sync(&qp->retrans_timer);
> +		del_timer_sync(&qp->rnr_nak_timer);
> +	}

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

>  
>  	rxe_cleanup_task(&qp->req.task);
>  	rxe_cleanup_task(&qp->comp.task);
> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
