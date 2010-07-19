From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [patch v2] infiniband: cxgb3: clean up signed check
Date: Mon, 19 Jul 2010 17:17:59 -0500
Message-ID: <4C44CF17.3030408@opengridcomputing.com>
References: <20100717102900.GG17585@bicker> <4C446509.3010400@opengridcomputing.com> <20100719203014.GN17585@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100719203014.GN17585@bicker>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Dan Carpenter wrote:
> Q_FREECNT() returns the number of spaces free.  This should never
> be a negative amount.  Also the num_wrs is an unsigned int so it can
> never be less than zero.
>
> Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> In v1: I changed num_wrs to a signed int.
>
> diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
> index ae47bfd..6adc13f 100644
> --- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
> +++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
> @@ -371,7 +371,7 @@ int iwch_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>  	}
>  	num_wrs = Q_FREECNT(qhp->wq.sq_rptr, qhp->wq.sq_wptr,
>  		  qhp->wq.sq_size_log2);
> -	if (num_wrs <= 0) {
> +	if (num_wrs == 0) {
>  		spin_unlock_irqrestore(&qhp->lock, flag);
>  		err = -ENOMEM;
>  		goto out;
> @@ -554,7 +554,7 @@ int iwch_bind_mw(struct ib_qp *qp,
>  	}
>  	num_wrs = Q_FREECNT(qhp->wq.sq_rptr, qhp->wq.sq_wptr,
>  			    qhp->wq.sq_size_log2);
> -	if ((num_wrs) <= 0) {
> +	if (num_wrs == 0) {
>  		spin_unlock_irqrestore(&qhp->lock, flag);
>  		return -ENOMEM;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
