From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: Fix modify CQ
Date: Mon, 8 Nov 2010 18:17:10 +0200
Message-ID: <20101108161710.GH5921@mtldesk30>
References: <20101025143859.GA8420@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101025143859.GA8420@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,
this patch has bad affect on mlx4_en. I sent another patch which does
the same at the IPoIB layer. Please consider removing it.

- thanks.

On Mon, Oct 25, 2010 at 04:38:59PM +0200, Eli Cohen wrote:
> The modify CQ command disables the effect of both the count and period
> paramters if any of them is zero. This is undesirable since we may still want
> to have one of them in effect while the other is neutralized. To do so we put
> the max value to a parameter if its value is zero while the other's is not
> zero. This is also consistent with the interfaces of ethtool but is still
> generally good.
> 
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
> ---
>  drivers/net/mlx4/cq.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/mlx4/cq.c b/drivers/net/mlx4/cq.c
> index 7cd34e9..24bf440 100644
> --- a/drivers/net/mlx4/cq.c
> +++ b/drivers/net/mlx4/cq.c
> @@ -149,6 +149,13 @@ int mlx4_cq_modify(struct mlx4_dev *dev, struct mlx4_cq *cq,
>  	cq_context = mailbox->buf;
>  	memset(cq_context, 0, sizeof *cq_context);
>  
> +
> +	if (count | period) {
> +		if (!count)
> +			count = 0xffff;
> +		else if (!period)
> +			period = 0xffff;
> +	}
>  	cq_context->cq_max_count = cpu_to_be16(count);
>  	cq_context->cq_period    = cpu_to_be16(period);
>  
> -- 
> 1.7.3.1
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
