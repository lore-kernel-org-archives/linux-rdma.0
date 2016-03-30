From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: Adding queue drain functions
Date: Wed, 30 Mar 2016 10:11:39 +0300
Message-ID: <20160330071139.GA8511@leon.nu>
References: <20160329175837.GA9868@TENIKOLO-MOBL2>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160329175837.GA9868@TENIKOLO-MOBL2>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 29, 2016 at 12:58:37PM -0500, Tatyana Nikolova wrote:
> Adding sq and rq drain functions, which block until all
> previously posted wr-s in the specified queue have completed.
> A completion object is signaled to unblock the thread,
> when the last cqe for the corresponding queue is processed.
> 
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/nes/nes_verbs.c | 34 ++++++++++++++++++++++++++++++++++
>  drivers/infiniband/hw/nes/nes_verbs.h |  2 ++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
> index fba69a3..170d43a 100644
> --- a/drivers/infiniband/hw/nes/nes_verbs.c
> +++ b/drivers/infiniband/hw/nes/nes_verbs.c
> @@ -1315,6 +1315,8 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
>  			nes_debug(NES_DBG_QP, "Invalid QP type: %d\n", init_attr->qp_type);
>  			return ERR_PTR(-EINVAL);
>  	}
> +	init_completion(&nesqp->sq_drained);
> +	init_completion(&nesqp->rq_drained);
>  
>  	nesqp->sig_all = (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR);
>  	init_timer(&nesqp->terminate_timer);
> @@ -3452,6 +3454,29 @@ out:
>  	return err;
>  }
>  
> +/**
> + * nes_drain_sq - drain sq
> + * @ibqp: pointer to ibqp
> + */
> +static void nes_drain_sq(struct ib_qp *ibqp)
> +{
> +	struct nes_qp *nesqp = to_nesqp(ibqp);
> +
> +	if (nesqp->hwqp.sq_tail != nesqp->hwqp.sq_head)

I'm not sure that you need these checks in all places.
It won't protect from anything.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
