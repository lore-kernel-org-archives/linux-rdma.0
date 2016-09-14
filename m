From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 21/28] mlx5: Avoid gcc 5.4 warning -Wempty-body
Date: Wed, 14 Sep 2016 19:25:25 +0300
Message-ID: <6214bd07-f40c-8458-73a2-c07383c5d85a@dev.mellanox.co.il>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1473109698-31408-22-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-22-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/6/2016 12:08 AM, Jason Gunthorpe wrote:
> gcc 5.4 remarks:
>
> ../providers/mlx5/buf.c:95:61: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
>
> Around code like this:
>
> 	if (shmdt(hmem->shmaddr) == -1)
> 		mlx5_dbg(stderr, MLX5_DBG_CONTIG, "%s\n", strerror(errno));
>
> When mlx5_dgb is defined as an empty macro the code expands to
> 	if (..)
> 		;
>
> Which is functionally okay, but strange.

As you pointed, there is no functional issue with that.

> It is much better to make mlx5_dbg an empty static inline, this way it
> continues to do parameter type validation even when disabled, and we
> can drop the sprinkling of #ifdef MLX5_DEBUG everywhere.

The idea was to have an 'empty' code when this macro is used as some 
code is done in the data path, see below notes.


> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  libmlx5/src/mlx5.h  |  6 +++++-
>  libmlx5/src/qp.c    |  7 -------
>  libmlx5/src/verbs.c | 10 ----------
>  3 files changed, 5 insertions(+), 18 deletions(-)
>
> diff --git a/libmlx5/src/mlx5.h b/libmlx5/src/mlx5.h
> index 5833339a543f..b4787dade7cb 100644
> --- a/libmlx5/src/mlx5.h
> +++ b/libmlx5/src/mlx5.h
> @@ -158,7 +158,11 @@ do {									\
>  } while (0)
>
>  #else
> -	#define mlx5_dbg(fp, mask, format, arg...)
> +static inline void mlx5_dbg(FILE *fp, uint32_t mask, const char *fmt, ...)
> +	__attribute__((format(printf, 3, 4)));
> +static inline void mlx5_dbg(FILE *fp, uint32_t mask, const char *fmt, ...)
> +{
> +}
>  #endif

Inline is not guaranteed by the compiler, calling empty function in some 
data data path flows should be prevented.

>  enum {
> diff --git a/libmlx5/src/qp.c b/libmlx5/src/qp.c
> index c805fcae4123..23270e50af7a 100644
> --- a/libmlx5/src/qp.c
> +++ b/libmlx5/src/qp.c
> @@ -356,9 +356,7 @@ static inline int copy_eth_inline_headers(struct ibv_qp *ibqp,
>  	int inl_hdr_size = MLX5_ETH_L2_INLINE_HEADER_SIZE;
>  	int inl_hdr_copy_size = 0;
>  	int j = 0;
> -#ifdef MLX5_DEBUG
>  	FILE *fp = to_mctx(ibqp->context)->dbg_fp;
> -#endif

This is data path flow, dropping the #ifdef may cause a redundant 
assignment for 'fp' here.

>  	if (unlikely(wr->num_sge < 1)) {
>  		mlx5_dbg(fp, MLX5_DBG_QP_SEND, "illegal num_sge: %d, minimum is 1\n",
> @@ -560,9 +558,7 @@ static inline int set_tso_eth_seg(void **seg, struct ibv_send_wr *wr,
>  	int size_of_inl_hdr_start = sizeof(eseg->inline_hdr_start);
>  	uint64_t left, left_len, copy_sz;
>  	void *pdata = wr->tso.hdr;
> -#ifdef MLX5_DEBUG
>  	FILE *fp = to_mctx(qp->ibv_qp->context)->dbg_fp;
> -#endif

Again, same issue as of above, here and below in the post_send flow.

>  	if (unlikely(wr->tso.hdr_sz < MLX5_ETH_L2_MIN_HEADER_SIZE ||
>  		     wr->tso.hdr_sz > qp->max_tso_header)) {
> @@ -629,10 +625,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
>  	uint8_t fence;
>  	uint8_t next_fence;
>  	uint32_t max_tso = 0;
> -
> -#ifdef MLX5_DEBUG
>  	FILE *fp = to_mctx(ibqp->context)->dbg_fp;
> -#endif
>
>  	mlx5_spin_lock(&qp->sq.lock);
>
> diff --git a/libmlx5/src/verbs.c b/libmlx5/src/verbs.c
> index 07e2545e2791..a76821e6f695 100644
> --- a/libmlx5/src/verbs.c
> +++ b/libmlx5/src/verbs.c
> @@ -360,9 +360,7 @@ static struct ibv_cq_ex *create_cq(struct ibv_context *context,
>  	int				cqe_sz;
>  	int				ret;
>  	int				ncqe;
> -#ifdef MLX5_DEBUG
>  	FILE *fp = to_mctx(context)->dbg_fp;
> -#endif
>
>  	if (!cq_attr->cqe) {
>  		mlx5_dbg(fp, MLX5_DBG_CQ, "CQE invalid\n");
> @@ -840,9 +838,7 @@ static int mlx5_calc_sq_size(struct mlx5_context *ctx,
>  {
>  	int wqe_size;
>  	int wq_size;
> -#ifdef MLX5_DEBUG
>  	FILE *fp = ctx->dbg_fp;
> -#endif
>
>  	if (!attr->cap.max_send_wr)
>  		return 0;
> @@ -892,9 +888,7 @@ static int mlx5_calc_rq_size(struct mlx5_context *ctx,
>  	int wqe_size;
>  	int wq_size;
>  	int scat_spc;
> -#ifdef MLX5_DEBUG
>  	FILE *fp = ctx->dbg_fp;
> -#endif
>
>  	if (!attr->cap.max_recv_wr)
>  		return 0;
> @@ -1146,9 +1140,7 @@ struct ibv_qp *create_qp(struct ibv_context *context,
>  	struct ibv_qp		       *ibqp;
>  	int32_t				usr_idx = 0;
>  	uint32_t			uuar_index;
> -#ifdef MLX5_DEBUG
>  	FILE *fp = ctx->dbg_fp;
> -#endif
>
>  	if (attr->comp_mask & ~MLX5_CREATE_QP_SUP_COMP_MASK)
>  		return NULL;
> @@ -1610,9 +1602,7 @@ mlx5_create_xrc_srq(struct ibv_context *context,
>  	int max_sge;
>  	struct ibv_srq *ibsrq;
>  	int uidx;
> -#ifdef MLX5_DEBUG
>  	FILE *fp = ctx->dbg_fp;
> -#endif
>
>  	msrq = calloc(1, sizeof(*msrq));
>  	if (!msrq)
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
