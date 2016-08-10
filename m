From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 libmlx5] fix err return values to match ibv_post_send
 expectations
Date: Wed, 10 Aug 2016 14:53:45 +0300
Message-ID: <b3afb94e-529f-38c4-6cdc-071f8ca3301b@dev.mellanox.co.il>
References: <20160808173333.GA26622@obsidianresearch.com>
 <1470679455-28911-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470679455-28911-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/8/2016 9:04 PM, Jarod Wilson wrote:
> The man page for ibv_post_send says:
>
>    RETURN VALUE
>
>        ibv_post_send() returns 0 on success, or the value of errno on failure
>        (which indicates the failure reason).
>
> QEMU looks for the return value, and in the ENOMEM case, waits and
> retries, but with mlx5, it ends up dropping requests and hanging, because
> of the unexpected -1 return instead of ENOMEM.
>
> The fix is simple: set err = E<whatever> instead of -1, and eliminate use
> of errno = in _mlx5_post_send, just have mlx5_post_send return the err from
> _mlx5_post_send instead. This fix has been confirmed to resolves the issues
> seen with QEMU.
>
> While we're at it, fix the MW_DEBUG code paths to no muck with errno either.
>
> v2: per discussion with Jason Gunthorpe, don't set errno in mlx5_post_send

Your patch missed few other flows that should be fixed as part of 
mlx5_post_send. (e.g. set_data_inl_seg which returns -1, set_bind_wr 
which touches errno, etc).

Just fixed that with some other minor typos/changes to the commit log, 
will send it shortly as V3, left you as the Author to give you the 
credit for.

In addition,
Both mlx5_post_recv and mlx5_post_srq_recv should be fixed in the same 
manner, prepared another patch as some candidate fix will send it 
shortly as well.

Once the new candidate patches will pass our regression testing will 
take them officially into libmlx5.

>
> Reported-by: Dr. David Alan Gilbert <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Tested-by: Dr. David Alan Gilbert <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  src/qp.c | 27 +++++++++------------------
>  1 file changed, 9 insertions(+), 18 deletions(-)
>
> diff --git a/src/qp.c b/src/qp.c
> index 51e1176..38352e9 100644
> --- a/src/qp.c
> +++ b/src/qp.c
> @@ -590,8 +590,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
>  		if (unlikely(wr->opcode < 0 ||
>  		    wr->opcode >= sizeof mlx5_ib_opcode / sizeof mlx5_ib_opcode[0])) {
>  			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "bad opcode %d\n", wr->opcode);
> -			errno = EINVAL;
> -			err = -1;
> +			err = EINVAL;
>  			*bad_wr = wr;
>  			goto out;
>  		}
> @@ -599,8 +598,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
>  		if (unlikely(mlx5_wq_overflow(&qp->sq, nreq,
>  					      to_mcq(qp->ibv_qp->send_cq)))) {
>  			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "work queue overflow\n");
> -			errno = ENOMEM;
> -			err = -1;
> +			err = ENOMEM;
>  			*bad_wr = wr;
>  			goto out;
>  		}
> @@ -608,8 +606,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
>  		if (unlikely(wr->num_sge > qp->sq.max_gs)) {
>  			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "max gs exceeded %d (max = %d)\n",
>  				 wr->num_sge, qp->sq.max_gs);
> -			errno = ENOMEM;
> -			err = -1;
> +			err = ENOMEM;
>  			*bad_wr = wr;
>  			goto out;
>  		}
> @@ -899,22 +896,16 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
>  {
>  #ifdef MW_DEBUG
>  	if (wr->opcode == IBV_WR_BIND_MW) {
> -		if (wr->bind_mw.mw->type == IBV_MW_TYPE_1) {
> -			errno = EINVAL;
> -			return errno;
> -		}
> +		if (wr->bind_mw.mw->type == IBV_MW_TYPE_1)
> +			return EINVAL;
>
>  		if (!wr->bind_mw.bind_info.mr ||
>  		    !wr->bind_mw.bind_info.addr ||
> -		    !wr->bind_mw.bind_info.length) {
> -			errno = EINVAL;
> -			return errno;
> -		}
> +		    !wr->bind_mw.bind_info.length)
> +			return EINVAL;
>
> -		if (wr->bind_mw.bind_info.mr->pd != wr->bind_mw.mw->pd) {
> -			errno = EINVAL;
> -			return errno;
> -		}
> +		if (wr->bind_mw.bind_info.mr->pd != wr->bind_mw.mw->pd)
> +			return EINVAL;
>  	}
>  #endif
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
