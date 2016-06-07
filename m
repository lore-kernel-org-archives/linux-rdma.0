From: Sagi Grimberg <sagi-ImC7XgPzLAfvYQKSrp0J2Q@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: remove dead code
Date: Tue, 7 Jun 2016 15:41:04 +0300
Message-ID: <5756C0E0.7090303@lightbits.io>
References: <1465247706-4418-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465247706-4418-1-git-send-email-sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 07/06/16 00:15, Sudip Mukherjee wrote:
> prot_sg_cnt has been assigned with the value of ret which we have
> already checked to be non-zero so prot_sg_cnt can never be zero at this
> point of the code and hence the else part can never execute.
> And since we know prot_sg_cnt is non zero there is no use for the
> if condition also.
>
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
> ---
>   drivers/infiniband/core/rw.c | 24 ++++++++++--------------
>   1 file changed, 10 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
> index 1eb9b12..a829a14 100644
> --- a/drivers/infiniband/core/rw.c
> +++ b/drivers/infiniband/core/rw.c
> @@ -386,21 +386,17 @@ int rdma_rw_ctx_signature_init(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
>   	count += ret;
>   	prev_wr = &ctx->sig->data.reg_wr.wr;
>
> -	if (prot_sg_cnt) {
> -		ret = rdma_rw_init_one_mr(qp, port_num, &ctx->sig->prot,
> -				prot_sg, prot_sg_cnt, 0);
> -		if (ret < 0)
> -			goto out_destroy_data_mr;
> -		count += ret;
> +	ret = rdma_rw_init_one_mr(qp, port_num, &ctx->sig->prot,
> +				  prot_sg, prot_sg_cnt, 0);
> +	if (ret < 0)
> +		goto out_destroy_data_mr;
> +	count += ret;
>
> -		if (ctx->sig->prot.inv_wr.next)
> -			prev_wr->next = &ctx->sig->prot.inv_wr;
> -		else
> -			prev_wr->next = &ctx->sig->prot.reg_wr.wr;
> -		prev_wr = &ctx->sig->prot.reg_wr.wr;
> -	} else {
> -		ctx->sig->prot.mr = NULL;
> -	}
> +	if (ctx->sig->prot.inv_wr.next)
> +		prev_wr->next = &ctx->sig->prot.inv_wr;
> +	else
> +		prev_wr->next = &ctx->sig->prot.reg_wr.wr;
> +	prev_wr = &ctx->sig->prot.reg_wr.wr;
>
>   	ctx->sig->sig_mr = ib_mr_pool_get(qp, &qp->sig_mrs);
>   	if (!ctx->sig->sig_mr) {
>

Actually it looks like the data-integrity insert/strip operation
(where protection sg list does not exist) is broken.

It looks that the protection scatterlist should be done only if
prot_sg_count was provided...

I don't have access to mlx5 devices at the moment (still waiting
to get some...)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
