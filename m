From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 09/28] mlx5: Fix gcc 6.4 uninitialized variable warning
Date: Thu, 15 Sep 2016 17:26:33 +0300
Message-ID: <f54fd76a-975f-900a-d996-2ae208402ae8@dev.mellanox.co.il>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1473109698-31408-10-git-send-email-jgunthorpe@obsidianresearch.com>
 <0ba444b7-6af4-72f3-d3d6-c27b73421679@dev.mellanox.co.il>
 <20160914163716.GB16014@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160914163716.GB16014-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/14/2016 7:37 PM, Jason Gunthorpe wrote:

>
> Okay, great, in that case you can gain more speed by writing code the
> compiler can understand. In this instance we don't need to test for
> (cqe64->op_own & MLX5_INLINE_SCATTER_XX) after we have disproven it by
> checking for !(MLX5_OPCODE_RDMA_READ,MLX5_OPCODE_ATOMIC_CS,MLX5_OPCODE_ATOMIC_FA)

I'm fine with that approach, still can improve your patch see below.

>  1 file changed, 32 insertions(+), 27 deletions(-)
>
> diff --git a/libmlx5/src/cq.c b/libmlx5/src/cq.c
> index 88097037eea0..91c568e2f4b6 100644
> --- a/libmlx5/src/cq.c
> +++ b/libmlx5/src/cq.c
> @@ -222,23 +222,6 @@ static inline void handle_good_req(struct ibv_wc *wc, struct mlx5_cqe64 *cqe, st
>  	}
>  }
>
> -static inline void handle_good_req_lazy(struct mlx5_cqe64 *cqe, uint32_t *pwc_byte_len,
> -					int *umr_opcode, struct mlx5_wq *wq, int idx)
> -{
> -	switch (ntohl(cqe->sop_drop_qpn) >> 24) {
> -	case MLX5_OPCODE_RDMA_READ:
> -		*pwc_byte_len  = ntohl(cqe->byte_cnt);
> -		break;
> -	case MLX5_OPCODE_ATOMIC_CS:
> -	case MLX5_OPCODE_ATOMIC_FA:
> -		*pwc_byte_len  = 8;
> -		break;
> -	case MLX5_OPCODE_UMR:
> -		*umr_opcode = wq->wr_data[idx];
> -		break;
> -	}
> -}
> -
>  static inline int handle_responder_lazy(struct mlx5_cq *cq, struct mlx5_cqe64 *cqe,
>  					struct mlx5_qp *qp, struct mlx5_srq *srq)
>  {
> @@ -634,7 +617,6 @@ static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
>  	switch (opcode) {
>  	case MLX5_CQE_REQ:
>  	{
> -		uint32_t uninitialized_var(wc_byte_len);
>  		mqp = get_req_context(mctx, cur_rsc,
>  				      (cqe_ver ? (ntohl(cqe64->srqn_uidx) & 0xffffff) : qpn),
>  				      cqe_ver);
> @@ -643,17 +625,40 @@ static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
>  		wq = &mqp->sq;
>  		wqe_ctr = ntohs(cqe64->wqe_counter);
>  		idx = wqe_ctr & (wq->wqe_cnt - 1);
> -		if (lazy)
> -			handle_good_req_lazy(cqe64, &wc_byte_len, &cq->umr_opcode, wq, idx);
> -		else
> +		if (lazy) {
> +			uint32_t wc_byte_len;
> +
> +			switch (ntohl(cqe64->sop_drop_qpn) >> 24) {
> +			case MLX5_OPCODE_UMR:
> +				cq->umr_opcode = wq->wr_data[idx];
> +				break;
> +
> +			case MLX5_OPCODE_RDMA_READ:
> +				wc_byte_len = ntohl(cqe64->byte_cnt);
> +				goto scatter_out;
> +			case MLX5_OPCODE_ATOMIC_CS:
> +			case MLX5_OPCODE_ATOMIC_FA:
> +				wc_byte_len = 8;
> +
> +			scatter_out:
> +				if (cqe64->op_own & MLX5_INLINE_SCATTER_32)
> +					err = mlx5_copy_to_send_wqe(
> +					    mqp, wqe_ctr, cqe, wc_byte_len);
> +				else if (cqe64->op_own & MLX5_INLINE_SCATTER_64)
> +					err = mlx5_copy_to_send_wqe(
> +					    mqp, wqe_ctr, cqe - 1, wc_byte_len);
> +				break;
> +			}
> +		} else {
>  			handle_good_req(wc, cqe64, wq, idx);
>
> -		if (cqe64->op_own & MLX5_INLINE_SCATTER_32)
> -			err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe,
> -						    lazy ? wc_byte_len : wc->byte_len);
> -		else if (cqe64->op_own & MLX5_INLINE_SCATTER_64)
> -			err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe - 1,
> -						     lazy ? wc_byte_len : wc->byte_len);
> +			if (cqe64->op_own & MLX5_INLINE_SCATTER_32)
> +				err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe,
> +							    wc->byte_len);
> +			else if (cqe64->op_own & MLX5_INLINE_SCATTER_64)
> +				err = mlx5_copy_to_send_wqe(
> +				    mqp, wqe_ctr, cqe - 1, wc->byte_len);
> +		}
>
>  		if (lazy) {
>  			cq->ibv_cq.wr_id = wq->wrid[idx];
>

This 'if' can be omitted and its body can be embedded above for both 
lazy/non-lazy modes.

Will handle that in our side and put into our regression system, once 
the patch will be approved will take it into my formal GIT so that you 
can take it from there.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
