From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Add the use of IBV_SEND_INLINE to example
 pingpong programs
Date: Mon, 15 Jul 2013 14:21:03 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F71CB38@xmb-rcd-x01.cisco.com>
References: <1373488359-11413-1-git-send-email-jsquyres@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373488359-11413-1-git-send-email-jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <E128BBAE98E1874986E5F476A5183FBB-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bump.

On Jul 10, 2013, at 4:32 PM, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:

> If the send size is less than the cap.max_inline_data reported by the
> qp, use the IBV_SEND_INLINE flag.  This now only shows the example of
> using ibv_query_qp(), it also reduces the latency time shown by the
> pingpong programs when the sends can be inlined.
> 
> Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
> examples/rc_pingpong.c  | 18 +++++++++++++-----
> examples/srq_pingpong.c | 19 +++++++++++++------
> examples/uc_pingpong.c  | 17 ++++++++++++-----
> examples/ud_pingpong.c  | 18 +++++++++++++-----
> 4 files changed, 51 insertions(+), 21 deletions(-)
> 
> diff --git a/examples/rc_pingpong.c b/examples/rc_pingpong.c
> index 15494a1..a8637a5 100644
> --- a/examples/rc_pingpong.c
> +++ b/examples/rc_pingpong.c
> @@ -65,6 +65,7 @@ struct pingpong_context {
> 	struct ibv_qp		*qp;
> 	void			*buf;
> 	int			 size;
> +	int			 send_flags;
> 	int			 rx_depth;
> 	int			 pending;
> 	struct ibv_port_attr     portinfo;
> @@ -319,8 +320,9 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
> 	if (!ctx)
> 		return NULL;
> 
> -	ctx->size     = size;
> -	ctx->rx_depth = rx_depth;
> +	ctx->size       = size;
> +	ctx->send_flags = IBV_SEND_SIGNALED;
> +	ctx->rx_depth   = rx_depth;
> 
> 	ctx->buf = memalign(page_size, size);
> 	if (!ctx->buf) {
> @@ -367,7 +369,8 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
> 	}
> 
> 	{
> -		struct ibv_qp_init_attr attr = {
> +		struct ibv_qp_attr attr;
> +		struct ibv_qp_init_attr init_attr = {
> 			.send_cq = ctx->cq,
> 			.recv_cq = ctx->cq,
> 			.cap     = {
> @@ -379,11 +382,16 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
> 			.qp_type = IBV_QPT_RC
> 		};
> 
> -		ctx->qp = ibv_create_qp(ctx->pd, &attr);
> +		ctx->qp = ibv_create_qp(ctx->pd, &init_attr);
> 		if (!ctx->qp)  {
> 			fprintf(stderr, "Couldn't create QP\n");
> 			goto clean_cq;
> 		}
> +
> +		ibv_query_qp(ctx->qp, &attr, IBV_QP_CAP, &init_attr);
> +		if (init_attr.cap.max_inline_data >= size) {
> +			ctx->send_flags |= IBV_SEND_INLINE;
> +		}
> 	}
> 
> 	{
> @@ -508,7 +516,7 @@ static int pp_post_send(struct pingpong_context *ctx)
> 		.sg_list    = &list,
> 		.num_sge    = 1,
> 		.opcode     = IBV_WR_SEND,
> -		.send_flags = IBV_SEND_SIGNALED,
> +		.send_flags = ctx->send_flags,
> 	};
> 	struct ibv_send_wr *bad_wr;
> 
> diff --git a/examples/srq_pingpong.c b/examples/srq_pingpong.c
> index 6e00f8c..552a144 100644
> --- a/examples/srq_pingpong.c
> +++ b/examples/srq_pingpong.c
> @@ -68,6 +68,7 @@ struct pingpong_context {
> 	struct ibv_qp		*qp[MAX_QP];
> 	void			*buf;
> 	int			 size;
> +	int			 send_flags;
> 	int			 num_qp;
> 	int			 rx_depth;
> 	int			 pending[MAX_QP];
> @@ -350,9 +351,10 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
> 	if (!ctx)
> 		return NULL;
> 
> -	ctx->size     = size;
> -	ctx->num_qp   = num_qp;
> -	ctx->rx_depth = rx_depth;
> +	ctx->size       = size;
> +	ctx->send_flags = IBV_SEND_SIGNALED;
> +	ctx->num_qp     = num_qp;
> +	ctx->rx_depth   = rx_depth;
> 
> 	ctx->buf = memalign(page_size, size);
> 	if (!ctx->buf) {
> @@ -413,7 +415,8 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
> 	}
> 
> 	for (i = 0; i < num_qp; ++i) {
> -		struct ibv_qp_init_attr attr = {
> +		struct ibv_qp_attr attr;
> +		struct ibv_qp_init_attr init_attr = {
> 			.send_cq = ctx->cq,
> 			.recv_cq = ctx->cq,
> 			.srq     = ctx->srq,
> @@ -424,11 +427,15 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
> 			.qp_type = IBV_QPT_RC
> 		};
> 
> -		ctx->qp[i] = ibv_create_qp(ctx->pd, &attr);
> +		ctx->qp[i] = ibv_create_qp(ctx->pd, &init_attr);
> 		if (!ctx->qp[i])  {
> 			fprintf(stderr, "Couldn't create QP[%d]\n", i);
> 			goto clean_qps;
> 		}
> +		ibv_query_qp(ctx->qp[i], &attr, IBV_QP_CAP, &init_attr);
> +		if (init_attr.cap.max_inline_data >= size) {
> +			ctx->send_flags |= IBV_SEND_INLINE;
> +		}
> 	}
> 
> 	for (i = 0; i < num_qp; ++i) {
> @@ -568,7 +575,7 @@ static int pp_post_send(struct pingpong_context *ctx, int qp_index)
> 		.sg_list    = &list,
> 		.num_sge    = 1,
> 		.opcode     = IBV_WR_SEND,
> -		.send_flags = IBV_SEND_SIGNALED,
> +		.send_flags = ctx->send_flags,
> 	};
> 	struct ibv_send_wr *bad_wr;
> 
> diff --git a/examples/uc_pingpong.c b/examples/uc_pingpong.c
> index 52c6c28..58cc3cc 100644
> --- a/examples/uc_pingpong.c
> +++ b/examples/uc_pingpong.c
> @@ -65,6 +65,7 @@ struct pingpong_context {
> 	struct ibv_qp		*qp;
> 	void			*buf;
> 	int			 size;
> +	int			 send_flags;
> 	int			 rx_depth;
> 	int			 pending;
> 	struct ibv_port_attr     portinfo;
> @@ -307,8 +308,9 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
> 	if (!ctx)
> 		return NULL;
> 
> -	ctx->size     = size;
> -	ctx->rx_depth = rx_depth;
> +	ctx->size       = size;
> +	ctx->send_flags = IBV_SEND_SIGNALED;
> +	ctx->rx_depth   = rx_depth;
> 
> 	ctx->buf = memalign(page_size, size);
> 	if (!ctx->buf) {
> @@ -355,7 +357,8 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
> 	}
> 
> 	{
> -		struct ibv_qp_init_attr attr = {
> +		struct ibv_qp_attr attr;
> +		struct ibv_qp_init_attr init_attr = {
> 			.send_cq = ctx->cq,
> 			.recv_cq = ctx->cq,
> 			.cap     = {
> @@ -367,11 +370,15 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
> 			.qp_type = IBV_QPT_UC
> 		};
> 
> -		ctx->qp = ibv_create_qp(ctx->pd, &attr);
> +		ctx->qp = ibv_create_qp(ctx->pd, &init_attr);
> 		if (!ctx->qp)  {
> 			fprintf(stderr, "Couldn't create QP\n");
> 			goto clean_cq;
> 		}
> +		ibv_query_qp(ctx->qp, &attr, IBV_QP_CAP, &init_attr);
> +		if (init_attr.cap.max_inline_data >= size) {
> +			ctx->send_flags |= IBV_SEND_INLINE;
> +		}
> 	}
> 
> 	{
> @@ -496,7 +503,7 @@ static int pp_post_send(struct pingpong_context *ctx)
> 		.sg_list    = &list,
> 		.num_sge    = 1,
> 		.opcode     = IBV_WR_SEND,
> -		.send_flags = IBV_SEND_SIGNALED,
> +		.send_flags = ctx->send_flags,
> 	};
> 	struct ibv_send_wr *bad_wr;
> 
> diff --git a/examples/ud_pingpong.c b/examples/ud_pingpong.c
> index 21c551d..9102241 100644
> --- a/examples/ud_pingpong.c
> +++ b/examples/ud_pingpong.c
> @@ -66,6 +66,7 @@ struct pingpong_context {
> 	struct ibv_ah		*ah;
> 	void			*buf;
> 	int			 size;
> +	int			 send_flags;
> 	int			 rx_depth;
> 	int			 pending;
> 	struct ibv_port_attr     portinfo;
> @@ -305,8 +306,9 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
> 	if (!ctx)
> 		return NULL;
> 
> -	ctx->size     = size;
> -	ctx->rx_depth = rx_depth;
> +	ctx->size       = size;
> +	ctx->send_flags = IBV_SEND_SIGNALED;
> +	ctx->rx_depth   = rx_depth;
> 
> 	ctx->buf = memalign(page_size, size + 40);
> 	if (!ctx->buf) {
> @@ -368,7 +370,8 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
> 	}
> 
> 	{
> -		struct ibv_qp_init_attr attr = {
> +		struct ibv_qp_attr attr;
> +		struct ibv_qp_init_attr init_attr = {
> 			.send_cq = ctx->cq,
> 			.recv_cq = ctx->cq,
> 			.cap     = {
> @@ -380,11 +383,16 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
> 			.qp_type = IBV_QPT_UD,
> 		};
> 
> -		ctx->qp = ibv_create_qp(ctx->pd, &attr);
> +		ctx->qp = ibv_create_qp(ctx->pd, &init_attr);
> 		if (!ctx->qp)  {
> 			fprintf(stderr, "Couldn't create QP\n");
> 			goto clean_cq;
> 		}
> +
> +		ibv_query_qp(ctx->qp, &attr, IBV_QP_CAP, &init_attr);
> +		if (init_attr.cap.max_inline_data >= size) {
> +			ctx->send_flags |= IBV_SEND_INLINE;
> +		}
> 	}
> 
> 	{
> @@ -514,7 +522,7 @@ static int pp_post_send(struct pingpong_context *ctx, uint32_t qpn)
> 		.sg_list    = &list,
> 		.num_sge    = 1,
> 		.opcode     = IBV_WR_SEND,
> -		.send_flags = IBV_SEND_SIGNALED,
> +		.send_flags = ctx->send_flags,
> 		.wr         = {
> 			.ud = {
> 				 .ah          = ctx->ah,
> -- 
> 1.8.2.1
> 


-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
