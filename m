From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [patch 5/8] ehca - ib_post_recv fixes Always set
 ib_post_recv()s bad_wr.
Date: Tue, 24 Nov 2009 18:06:21 -0500
Message-ID: <20091124180621.0df9150b@alex-laptop>
References: <20091124043323.927819053@systemfabricworks.com>
	<4B0C19AE.6030006@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B0C19AE.6030006-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Hoang-Nam Nguyen <HNGUYEN-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 24 Nov 2009 11:36:46 -0600
frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:

Hi Frank,

> Signed-off-by: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
> Index: linux-2.6.31/drivers/infiniband/hw/ehca/ehca_reqs.c
> ===================================================================
> --- linux-2.6.31.orig/drivers/infiniband/hw/ehca/ehca_reqs.c	2009-11-23 
> 21:23:08.000000000 -0600
> +++ linux-2.6.31/drivers/infiniband/hw/ehca/ehca_reqs.c	2009-11-23 
> 21:25:48.000000000 -0600
> @@ -519,7 +519,7 @@
>   	if (unlikely(!HAS_RQ(my_qp))) {
>   		ehca_err(dev, "QP has no RQ  ehca_qp=%p qp_num=%x ext_type=%d",
>   			 my_qp, my_qp->real_qp_num, my_qp->ext_type);
> -		return -ENODEV;
> +		ret = -ENODEV;

aren't you missing a goto statement here?

>   	}
> 
>   	/* LOCK the QUEUE */
> @@ -533,13 +533,9 @@
>   		wqe_p = ipz_qeit_get_inc(&my_qp->ipz_rqueue);
>   		if (unlikely(!wqe_p)) {
>   			/* too many posted work requests: queue overflow */
> -			if (bad_recv_wr)
> -				*bad_recv_wr = cur_recv_wr;
> -			if (wqe_cnt == 0) {
> -				ret = -ENOMEM;
> -				ehca_err(dev, "Too many posted WQEs "
> -					 "qp_num=%x", my_qp->real_qp_num);
> -			}
> +			ret = -ENOMEM;
> +			ehca_err(dev, "Too many posted WQEs "
> +				"qp_num=%x", my_qp->real_qp_num);
>   			goto post_recv_exit0;
>   		}
>   		/*
> @@ -558,11 +554,9 @@
>   		if (unlikely(ret)) {
>   			my_qp->ipz_rqueue.current_q_offset = start_offset;
>   			*bad_recv_wr = cur_recv_wr;
> -			if (wqe_cnt == 0) {
> -				ret = -EINVAL;
> -				ehca_err(dev, "Could not write WQE "
> -					 "qp_num=%x", my_qp->real_qp_num);
> -			}
> +			ret = -EINVAL;
> +			ehca_err(dev, "Could not write WQE "
> +				"qp_num=%x", my_qp->real_qp_num);
>   			goto post_recv_exit0;
>   		}
> 
> @@ -581,6 +575,11 @@
>   	    ehca_dbg(dev, "ehca_qp=%p qp_num=%x wqe_cnt=%d ret=%i",
>   		     my_qp, my_qp->real_qp_num, wqe_cnt, ret);
>   	spin_unlock_irqrestore(&my_qp->spinlock_r, flags);
> +
> +out:
> +	if (ret)
> +		*bad_recv_wr = cur_recv_wr;
> +
>   	return ret;
>   }
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
