From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 2/3] mlx5: Use common provider debug macros
Date: Wed, 18 Jan 2017 12:03:08 +0200
Message-ID: <20170118100308.GY32481@mtr-leonro.local>
References: <1484682449-95832-1-git-send-email-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+epxrXWOh++2HLjY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484682449-95832-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--+epxrXWOh++2HLjY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 17, 2017 at 01:47:29PM -0600, Tatyana Nikolova wrote:
> Replace mlx5 specific debug macros with
> common provider macros.
>
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  providers/mlx5/buf.c   | 18 +++++++++---------
>  providers/mlx5/cq.c    |  6 +++---
>  providers/mlx5/mlx5.c  | 51 +++++++++++++-------------------------------------
>  providers/mlx5/mlx5.h  | 27 ++------------------------
>  providers/mlx5/qp.c    | 24 +++++++++++++-----------
>  providers/mlx5/verbs.c | 48 +++++++++++++++++++++++------------------------
>  6 files changed, 64 insertions(+), 110 deletions(-)
>
> diff --git a/providers/mlx5/buf.c b/providers/mlx5/buf.c
> index 853450a..f70c474 100644
> --- a/providers/mlx5/buf.c
> +++ b/providers/mlx5/buf.c
> @@ -92,7 +92,7 @@ static void free_huge_mem(struct mlx5_hugetlb_mem *hmem)
>  {
>  	mlx5_bitmap_cleanup(&hmem->bitmap);
>  	if (shmdt(hmem->shmaddr) == -1)
> -		mlx5_dbg(stderr, MLX5_DBG_CONTIG, "%s\n", strerror(errno));
> +		PRINT_DBG(VERBS_DBG_MASK_CONTIG, mlx5_dbg_level, "%s\n", strerror(errno));
>  	shmctl(hmem->shmid, IPC_RMID, NULL);
>  	free(hmem);
>  }
> @@ -199,19 +199,19 @@ static struct mlx5_hugetlb_mem *alloc_huge_mem(size_t size)
>  	shm_len = align(size, MLX5_SHM_LENGTH);
>  	hmem->shmid = shmget(IPC_PRIVATE, shm_len, SHM_HUGETLB | SHM_R | SHM_W);
>  	if (hmem->shmid == -1) {
> -		mlx5_dbg(stderr, MLX5_DBG_CONTIG, "%s\n", strerror(errno));
> +		PRINT_DBG(VERBS_DBG_MASK_CONTIG, mlx5_dbg_level, "%s\n", strerror(errno));
>  		goto out_free;
>  	}
>
>  	hmem->shmaddr = shmat(hmem->shmid, MLX5_SHM_ADDR, MLX5_SHMAT_FLAGS);
>  	if (hmem->shmaddr == (void *)-1) {
> -		mlx5_dbg(stderr, MLX5_DBG_CONTIG, "%s\n", strerror(errno));
> +		PRINT_DBG(VERBS_DBG_MASK_CONTIG, mlx5_dbg_level, "%s\n", strerror(errno));
>  		goto out_rmid;
>  	}
>
>  	if (mlx5_bitmap_init(&hmem->bitmap, shm_len / MLX5_Q_CHUNK_SIZE,
>  			     shm_len / MLX5_Q_CHUNK_SIZE - 1)) {
> -		mlx5_dbg(stderr, MLX5_DBG_CONTIG, "%s\n", strerror(errno));
> +		PRINT_DBG(VERBS_DBG_MASK_CONTIG, mlx5_dbg_level, "%s\n", strerror(errno));
>  		goto out_shmdt;
>  	}
>
> @@ -224,7 +224,7 @@ static struct mlx5_hugetlb_mem *alloc_huge_mem(size_t size)
>
>  out_shmdt:
>  	if (shmdt(hmem->shmaddr) == -1)
> -		mlx5_dbg(stderr, MLX5_DBG_CONTIG, "%s\n", strerror(errno));
> +		PRINT_DBG(VERBS_DBG_MASK_CONTIG, mlx5_dbg_level, "%s\n", strerror(errno));
>
>  out_rmid:
>  	shmctl(hmem->shmid, IPC_RMID, NULL);
> @@ -285,7 +285,7 @@ static int alloc_huge_buf(struct mlx5_context *mctx, struct mlx5_buf *buf,
>
>  	ret = ibv_dontfork_range(buf->buf, buf->length);
>  	if (ret) {
> -		mlx5_dbg(stderr, MLX5_DBG_CONTIG, "\n");
> +		PRINT_DBG(VERBS_DBG_MASK_CONTIG, mlx5_dbg_level, "\n");
>  		goto out_fork;
>  	}
>  	buf->type = MLX5_ALLOC_TYPE_HUGE;
> @@ -344,7 +344,7 @@ int mlx5_alloc_prefered_buf(struct mlx5_context *mctx,
>  		if (type == MLX5_ALLOC_TYPE_HUGE)
>  			return -1;
>
> -		mlx5_dbg(stderr, MLX5_DBG_CONTIG,
> +		PRINT_DBG(VERBS_DBG_MASK_CONTIG, mlx5_dbg_level,
>  			 "Huge mode allocation failed, fallback to %s mode\n",
>  			 MLX5_ALLOC_TYPE_ALL ? "contig" : "default");
>  	}
> @@ -358,7 +358,7 @@ int mlx5_alloc_prefered_buf(struct mlx5_context *mctx,
>
>  		if (type == MLX5_ALLOC_TYPE_CONTIG)
>  			return -1;
> -		mlx5_dbg(stderr, MLX5_DBG_CONTIG,
> +		PRINT_DBG(VERBS_DBG_MASK_CONTIG, mlx5_dbg_level,
>  			 "Contig allocation failed, fallback to default mode\n");
>  	}
>
> @@ -518,7 +518,7 @@ int mlx5_alloc_buf_contig(struct mlx5_context *mctx,
>
>  		block_size_exp -= 1;
>  	} while (block_size_exp >= min_block_log);
> -	mlx5_dbg(mctx->dbg_fp, MLX5_DBG_CONTIG, "block order %d, addr %p\n",
> +	LOG_DBG(mctx->dbg_fp, VERBS_DBG_MASK_CONTIG, mlx5_dbg_level, "block order %d, addr %p\n",
>  		 block_size_exp, addr);
>
>  	if (addr == MAP_FAILED)
> diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
> index 7ad27a9..dd5045d 100644
> --- a/providers/mlx5/cq.c
> +++ b/providers/mlx5/cq.c
> @@ -572,10 +572,10 @@ static inline int mlx5_get_next_cqe(struct mlx5_cq *cq,
>  	{
>  		struct mlx5_context *mctx = to_mctx(cq->ibv_cq.context);
>
> -		if (mlx5_debug_mask & MLX5_DBG_CQ_CQE) {
> +		if (rdma_dbg_mask & VERBS_DBG_MASK_CQ) {
>  			FILE *fp = mctx->dbg_fp;
>
> -			mlx5_dbg(fp, MLX5_DBG_CQ_CQE, "dump cqe for cqn 0x%x:\n", cq->cqn);
> +			LOG_DBG(fp, VERBS_DBG_MASK_CQ, mlx5_dbg_level, "dump cqe for cqn 0x%x:\n", cq->cqn);
>  			dump_cqe(fp, cqe64);
>  		}
>  	}
> @@ -1166,7 +1166,7 @@ static inline enum ibv_wc_opcode mlx5_cq_read_wc_opcode(struct ibv_cq_ex *ibcq)
>  {
>  	struct mlx5_context *ctx = to_mctx(ibcq->context);
>
> -	mlx5_dbg(ctx->dbg_fp, MLX5_DBG_CQ_CQE, "un-expected opcode in cqe\n");
> +	LOG_DBG(ctx->dbg_fp, VERBS_DBG_MASK_CQ, mlx5_dbg_level, "un-expected opcode in cqe\n");
>  }
>  #endif
>  	return 0;
> diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
> index 747e242..25a4dab 100644
> --- a/providers/mlx5/mlx5.c
> +++ b/providers/mlx5/mlx5.c
> @@ -77,9 +77,14 @@ static struct {
>  	HCA(MELLANOX, 4121),    /* ConnectX-5, PCIe 4.0 */
>  };
>
> -uint32_t mlx5_debug_mask = 0;
>  int mlx5_freeze_on_error_cqe;
>
> +#ifdef MLX5_DEBUG
> +uint32_t mlx5_dbg_level = VERBS_DBG_LEVEL_VERBOSE;
> +#else
> +uint32_t mlx5_dbg_level;
> +#endif
> +
>  static struct ibv_context_ops mlx5_ctx_ops = {
>  	.query_device  = mlx5_query_device,
>  	.query_port    = mlx5_query_port,
> @@ -430,39 +435,6 @@ static int get_total_uuars(void)
>  	return size;
>  }
>
> -static void open_debug_file(struct mlx5_context *ctx)
> -{
> -	char *env;
> -
> -	env = getenv("MLX5_DEBUG_FILE");
> -	if (!env) {
> -		ctx->dbg_fp = stderr;
> -		return;
> -	}
> -
> -	ctx->dbg_fp = fopen(env, "aw+");
> -	if (!ctx->dbg_fp) {
> -		fprintf(stderr, "Failed opening debug file %s, using stderr\n", env);
> -		ctx->dbg_fp = stderr;
> -		return;
> -	}
> -}
> -
> -static void close_debug_file(struct mlx5_context *ctx)
> -{
> -	if (ctx->dbg_fp && ctx->dbg_fp != stderr)
> -		fclose(ctx->dbg_fp);
> -}
> -
> -static void set_debug_mask(void)
> -{
> -	char *env;
> -
> -	env = getenv("MLX5_DEBUG_MASK");
> -	if (env)
> -		mlx5_debug_mask = strtol(env, NULL, 0);
> -}
> -
>  static void set_freeze_on_error(void)
>  {
>  	char *env;
> @@ -604,8 +576,11 @@ static int mlx5_init_context(struct verbs_device *vdev,
>  	context = to_mctx(ctx);
>  	context->ibv_ctx.cmd_fd = cmd_fd;
>
> -	open_debug_file(context);
> -	set_debug_mask();
> +	setup_debug();
> +	context->dbg_fp = open_debug_file();
> +	if (!context->dbg_fp)
> +		context->dbg_fp = stderr;
> +
>  	set_freeze_on_error();
>  	if (gethostname(context->hostname, sizeof(context->hostname)))
>  		strcpy(context->hostname, "host_unknown");
> @@ -769,7 +744,7 @@ err_free:
>  		if (context->uar[i])
>  			munmap(context->uar[i], page_size);
>  	}
> -	close_debug_file(context);
> +	close_debug_file(context->dbg_fp);
>  	return errno;
>  }
>
> @@ -788,7 +763,7 @@ static void mlx5_cleanup_context(struct verbs_device *device,
>  	if (context->hca_core_clock)
>  		munmap(context->hca_core_clock - context->core_clock.offset,
>  		       page_size);
> -	close_debug_file(context);
> +	close_debug_file(context->dbg_fp);
>  }
>
>  static struct verbs_device *mlx5_driver_init(const char *uverbs_sys_path,
> diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
> index cb65429..b99451c 100644
> --- a/providers/mlx5/mlx5.h
> +++ b/providers/mlx5/mlx5.h
> @@ -42,6 +42,7 @@
>  #include <ccan/list.h>
>  #include "bitmap.h"
>  #include <ccan/minmax.h>
> +#include <util/dbg.h>
>
>  #ifdef __GNUC__
>  #define likely(x)	__builtin_expect((x), 1)
> @@ -82,32 +83,8 @@ enum {
>  #define MLX5_MAX_LOG2_CONTIG_BLOCK_SIZE 23
>  #define MLX5_MIN_LOG2_CONTIG_BLOCK_SIZE 12
>
> -enum {
> -	MLX5_DBG_QP		= 1 << 0,
> -	MLX5_DBG_CQ		= 1 << 1,
> -	MLX5_DBG_QP_SEND	= 1 << 2,
> -	MLX5_DBG_QP_SEND_ERR	= 1 << 3,
> -	MLX5_DBG_CQ_CQE		= 1 << 4,
> -	MLX5_DBG_CONTIG		= 1 << 5,
> -};
> -
> -extern uint32_t mlx5_debug_mask;
>  extern int mlx5_freeze_on_error_cqe;
> -
> -#ifdef MLX5_DEBUG
> -#define mlx5_dbg(fp, mask, format, arg...)				\
> -do {									\
> -	if (mask & mlx5_debug_mask)					\
> -		fprintf(fp, "%s:%d: " format, __func__, __LINE__, ##arg);	\
> -} while (0)
> -
> -#else
> -static inline void mlx5_dbg(FILE *fp, uint32_t mask, const char *fmt, ...)
> -	__attribute__((format(printf, 3, 4)));
> -static inline void mlx5_dbg(FILE *fp, uint32_t mask, const char *fmt, ...)
> -{
> -}
> -#endif
> +extern uint32_t mlx5_dbg_level;

If mlx5 is complied without MLX5_DEBUG all debug prints will be empty.
In your proposal, it is not the case, which is bad for data-path prints.

>
>  enum {
>  	MLX5_RCV_DBR	= 0,
> diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
> index e82b1a0..4c0c004 100644
> --- a/providers/mlx5/qp.c
> +++ b/providers/mlx5/qp.c
> @@ -368,8 +368,8 @@ static inline int copy_eth_inline_headers(struct ibv_qp *ibqp,
>  	FILE *fp = to_mctx(ibqp->context)->dbg_fp;
>
>  	if (unlikely(wr->num_sge < 1)) {
> -		mlx5_dbg(fp, MLX5_DBG_QP_SEND, "illegal num_sge: %d, minimum is 1\n",
> -			 wr->num_sge);
> +		LOG_DBG(fp, VERBS_DBG_MASK_QP_SEND, mlx5_dbg_level,
> +			"illegal num_sge: %d, minimum is 1\n", wr->num_sge);
>  		return EINVAL;
>  	}
>
> @@ -389,7 +389,8 @@ static inline int copy_eth_inline_headers(struct ibv_qp *ibqp,
>  			inl_hdr_size -= inl_hdr_copy_size;
>  		}
>  		if (unlikely(inl_hdr_size)) {
> -			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "Ethernet headers < 16 bytes\n");
> +			LOG_DBG(fp, VERBS_DBG_MASK_QP_SEND, mlx5_dbg_level,
> +				"Ethernet headers < 16 bytes\n");
>  			return EINVAL;
>  		}
>  		--j;
> @@ -571,7 +572,7 @@ static inline int set_tso_eth_seg(void **seg, struct ibv_send_wr *wr,
>
>  	if (unlikely(wr->tso.hdr_sz < MLX5_ETH_L2_MIN_HEADER_SIZE ||
>  		     wr->tso.hdr_sz > qp->max_tso_header)) {
> -		mlx5_dbg(fp, MLX5_DBG_QP_SEND,
> +		LOG_DBG(fp, VERBS_DBG_MASK_QP_SEND, mlx5_dbg_level,
>  			 "TSO header size should be at least %d and at most %d\n",
>  			 MLX5_ETH_L2_MIN_HEADER_SIZE,
>  			 qp->max_tso_header);
> @@ -643,7 +644,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
>  	for (nreq = 0; wr; ++nreq, wr = wr->next) {
>  		if (unlikely(wr->opcode < 0 ||
>  		    wr->opcode >= sizeof mlx5_ib_opcode / sizeof mlx5_ib_opcode[0])) {
> -			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "bad opcode %d\n", wr->opcode);
> +			LOG_DBG(fp, VERBS_DBG_MASK_QP_SEND, mlx5_dbg_level, "bad opcode %d\n", wr->opcode);
>  			err = EINVAL;
>  			*bad_wr = wr;
>  			goto out;
> @@ -651,14 +652,14 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
>
>  		if (unlikely(mlx5_wq_overflow(&qp->sq, nreq,
>  					      to_mcq(qp->ibv_qp->send_cq)))) {
> -			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "work queue overflow\n");
> +			LOG_DBG(fp, VERBS_DBG_MASK_QP_SEND, mlx5_dbg_level, "work queue overflow\n");
>  			err = ENOMEM;
>  			*bad_wr = wr;
>  			goto out;
>  		}
>
>  		if (unlikely(wr->num_sge > qp->sq.max_gs)) {
> -			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "max gs exceeded %d (max = %d)\n",
> +			LOG_DBG(fp, VERBS_DBG_MASK_QP_SEND, mlx5_dbg_level, "max gs exceeded %d (max = %d)\n",
>  				 wr->num_sge, qp->sq.max_gs);
>  			err = ENOMEM;
>  			*bad_wr = wr;
> @@ -707,7 +708,8 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
>  			case IBV_WR_ATOMIC_CMP_AND_SWP:
>  			case IBV_WR_ATOMIC_FETCH_AND_ADD:
>  				if (unlikely(!qp->atomics_enabled)) {
> -					mlx5_dbg(fp, MLX5_DBG_QP_SEND, "atomic operations are not supported\n");
> +					LOG_DBG(fp, VERBS_DBG_MASK_QP_SEND, mlx5_dbg_level,
> +						"atomic operations are not supported\n");
>  					err = ENOSYS;
>  					*bad_wr = wr;
>  					goto out;
> @@ -839,7 +841,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
>  				err = copy_eth_inline_headers(ibqp, wr, seg, &sg_copy_ptr);
>  				if (unlikely(err)) {
>  					*bad_wr = wr;
> -					mlx5_dbg(fp, MLX5_DBG_QP_SEND,
> +					LOG_DBG(fp, VERBS_DBG_MASK_QP_SEND, mlx5_dbg_level,
>  						 "copy_eth_inline_headers failed, err: %d\n",
>  						 err);
>  					goto out;
> @@ -860,7 +862,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
>  			err = set_data_inl_seg(qp, wr, seg, &sz, &sg_copy_ptr);
>  			if (unlikely(err)) {
>  				*bad_wr = wr;
> -				mlx5_dbg(fp, MLX5_DBG_QP_SEND,
> +				LOG_DBG(fp, VERBS_DBG_MASK_QP_SEND, mlx5_dbg_level,
>  					 "inline layout failed, err %d\n", err);
>  				goto out;
>  			}
> @@ -912,7 +914,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
>  		qp->sq.cur_post += DIV_ROUND_UP(size * 16, MLX5_SEND_WQE_BB);
>
>  #ifdef MLX5_DEBUG
> -		if (mlx5_debug_mask & MLX5_DBG_QP_SEND)
> +		if (rdma_dbg_mask & VERBS_DBG_MASK_QP_SEND)
>  			dump_wqe(to_mctx(ibqp->context)->dbg_fp, idx, size, qp);
>  #endif
>  	}
> diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
> index e288ebf..753b550 100644
> --- a/providers/mlx5/verbs.c
> +++ b/providers/mlx5/verbs.c
> @@ -351,13 +351,13 @@ static struct ibv_cq_ex *create_cq(struct ibv_context *context,
>  	FILE *fp = to_mctx(context)->dbg_fp;
>
>  	if (!cq_attr->cqe) {
> -		mlx5_dbg(fp, MLX5_DBG_CQ, "CQE invalid\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_CQ, mlx5_dbg_level, "CQE invalid\n");
>  		errno = EINVAL;
>  		return NULL;
>  	}
>
>  	if (cq_attr->comp_mask & ~CREATE_CQ_SUPPORTED_COMP_MASK) {
> -		mlx5_dbg(fp, MLX5_DBG_CQ,
> +		LOG_DBG(fp, VERBS_DBG_MASK_CQ, mlx5_dbg_level,
>  			 "Unsupported comp_mask for create_cq\n");
>  		errno = EINVAL;
>  		return NULL;
> @@ -365,21 +365,21 @@ static struct ibv_cq_ex *create_cq(struct ibv_context *context,
>
>  	if (cq_attr->comp_mask & IBV_CQ_INIT_ATTR_MASK_FLAGS &&
>  	    cq_attr->flags & ~CREATE_CQ_SUPPORTED_FLAGS) {
> -		mlx5_dbg(fp, MLX5_DBG_CQ,
> +		LOG_DBG(fp, VERBS_DBG_MASK_CQ, mlx5_dbg_level,
>  			 "Unsupported creation flags requested for create_cq\n");
>  		errno = EINVAL;
>  		return NULL;
>  	}
>
>  	if (cq_attr->wc_flags & ~CREATE_CQ_SUPPORTED_WC_FLAGS) {
> -		mlx5_dbg(fp, MLX5_DBG_CQ, "\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_CQ, mlx5_dbg_level, "\n");
>  		errno = ENOTSUP;
>  		return NULL;
>  	}
>
>  	cq =  calloc(1, sizeof *cq);
>  	if (!cq) {
> -		mlx5_dbg(fp, MLX5_DBG_CQ, "\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_CQ, mlx5_dbg_level, "\n");
>  		return NULL;
>  	}
>
> @@ -391,26 +391,26 @@ static struct ibv_cq_ex *create_cq(struct ibv_context *context,
>
>  	ncqe = align_queue_size(cq_attr->cqe + 1);
>  	if ((ncqe > (1 << 24)) || (ncqe < (cq_attr->cqe + 1))) {
> -		mlx5_dbg(fp, MLX5_DBG_CQ, "ncqe %d\n", ncqe);
> +		LOG_DBG(fp, VERBS_DBG_MASK_CQ, mlx5_dbg_level, "ncqe %d\n", ncqe);
>  		errno = EINVAL;
>  		goto err_spl;
>  	}
>
>  	cqe_sz = get_cqe_size();
>  	if (cqe_sz < 0) {
> -		mlx5_dbg(fp, MLX5_DBG_CQ, "\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_CQ, mlx5_dbg_level, "\n");
>  		errno = -cqe_sz;
>  		goto err_spl;
>  	}
>
>  	if (mlx5_alloc_cq_buf(to_mctx(context), cq, &cq->buf_a, ncqe, cqe_sz)) {
> -		mlx5_dbg(fp, MLX5_DBG_CQ, "\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_CQ, mlx5_dbg_level, "\n");
>  		goto err_spl;
>  	}
>
>  	cq->dbrec  = mlx5_alloc_dbrec(to_mctx(context));
>  	if (!cq->dbrec) {
> -		mlx5_dbg(fp, MLX5_DBG_CQ, "\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_CQ, mlx5_dbg_level, "\n");
>  		goto err_buf;
>  	}
>
> @@ -432,7 +432,7 @@ static struct ibv_cq_ex *create_cq(struct ibv_context *context,
>  				ibv_cq_ex_to_cq(&cq->ibv_cq), &cmd.ibv_cmd,
>  				sizeof(cmd), &resp.ibv_resp, sizeof(resp));
>  	if (ret) {
> -		mlx5_dbg(fp, MLX5_DBG_CQ, "ret %d\n", ret);
> +		LOG_DBG(fp, VERBS_DBG_MASK_CQ, mlx5_dbg_level, "ret %d\n", ret);
>  		goto err_db;
>  	}
>
> @@ -834,12 +834,12 @@ static int mlx5_calc_sq_size(struct mlx5_context *ctx,
>
>  	wqe_size = mlx5_calc_send_wqe(ctx, attr, qp);
>  	if (wqe_size < 0) {
> -		mlx5_dbg(fp, MLX5_DBG_QP, "\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_QP, mlx5_dbg_level, "\n");
>  		return wqe_size;
>  	}
>
>  	if (wqe_size > ctx->max_sq_desc_sz) {
> -		mlx5_dbg(fp, MLX5_DBG_QP, "\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_QP, mlx5_dbg_level, "\n");
>  		return -EINVAL;
>  	}
>
> @@ -852,14 +852,14 @@ static int mlx5_calc_sq_size(struct mlx5_context *ctx,
>  	 * that the multiplication will fit in int
>  	 */
>  	if (attr->cap.max_send_wr > 0x7fffffff / ctx->max_sq_desc_sz) {
> -		mlx5_dbg(fp, MLX5_DBG_QP, "\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_QP, mlx5_dbg_level, "\n");
>  		return -EINVAL;
>  	}
>
>  	wq_size = mlx5_round_up_power_of_two(attr->cap.max_send_wr * wqe_size);
>  	qp->sq.wqe_cnt = wq_size / MLX5_SEND_WQE_BB;
>  	if (qp->sq.wqe_cnt > ctx->max_send_wqebb) {
> -		mlx5_dbg(fp, MLX5_DBG_QP, "\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_QP, mlx5_dbg_level, "\n");
>  		return -EINVAL;
>  	}
>
> @@ -917,13 +917,13 @@ static int mlx5_calc_rq_size(struct mlx5_context *ctx,
>  		return 0;
>
>  	if (attr->cap.max_recv_wr > ctx->max_recv_wr) {
> -		mlx5_dbg(fp, MLX5_DBG_QP, "\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_QP, mlx5_dbg_level, "\n");
>  		return -EINVAL;
>  	}
>
>  	wqe_size = mlx5_calc_rcv_wqe(ctx, attr, qp);
>  	if (wqe_size < 0 || wqe_size > ctx->max_rq_desc_sz) {
> -		mlx5_dbg(fp, MLX5_DBG_QP, "\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_QP, mlx5_dbg_level, "\n");
>  		return -EINVAL;
>  	}
>
> @@ -1207,7 +1207,7 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
>
>  	qp = calloc(1, sizeof(*qp));
>  	if (!qp) {
> -		mlx5_dbg(fp, MLX5_DBG_QP, "\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_QP, mlx5_dbg_level, "\n");
>  		return NULL;
>  	}
>  	ibqp = (struct ibv_qp *)&qp->verbs_qp;
> @@ -1248,7 +1248,7 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
>  	}
>
>  	if (mlx5_alloc_qp_buf(context, attr, qp, ret)) {
> -		mlx5_dbg(fp, MLX5_DBG_QP, "\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_QP, mlx5_dbg_level, "\n");
>  		goto err;
>  	}
>
> @@ -1270,7 +1270,7 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
>
>  	qp->db = mlx5_alloc_dbrec(ctx);
>  	if (!qp->db) {
> -		mlx5_dbg(fp, MLX5_DBG_QP, "\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_QP, mlx5_dbg_level, "\n");
>  		goto err_free_qp_buf;
>  	}
>
> @@ -1294,7 +1294,7 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
>  	} else if (!is_xrc_tgt(attr->qp_type)) {
>  		usr_idx = mlx5_store_uidx(ctx, qp);
>  		if (usr_idx < 0) {
> -			mlx5_dbg(fp, MLX5_DBG_QP, "Couldn't find free user index\n");
> +			LOG_DBG(fp, VERBS_DBG_MASK_QP, mlx5_dbg_level, "Couldn't find free user index\n");
>  			goto err_rq_db;
>  		}
>
> @@ -1308,7 +1308,7 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
>  					   attr, &cmd.ibv_cmd, sizeof(cmd),
>  					   &resp.ibv_resp, sizeof(resp));
>  	if (ret) {
> -		mlx5_dbg(fp, MLX5_DBG_QP, "ret %d\n", ret);
> +		LOG_DBG(fp, VERBS_DBG_MASK_QP, mlx5_dbg_level, "ret %d\n", ret);
>  		goto err_free_uidx;
>  	}
>
> @@ -1318,7 +1318,7 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
>  		if (qp->sq.wqe_cnt || qp->rq.wqe_cnt) {
>  			ret = mlx5_store_qp(ctx, ibqp->qp_num, qp);
>  			if (ret) {
> -				mlx5_dbg(fp, MLX5_DBG_QP, "ret %d\n", ret);
> +				LOG_DBG(fp, VERBS_DBG_MASK_QP, mlx5_dbg_level, "ret %d\n", ret);
>  				goto err_destroy;
>  			}
>  		}
> @@ -1793,7 +1793,7 @@ mlx5_create_xrc_srq(struct ibv_context *context,
>  	if (ctx->cqe_version) {
>  		uidx = mlx5_store_uidx(ctx, msrq);
>  		if (uidx < 0) {
> -			mlx5_dbg(fp, MLX5_DBG_QP, "Couldn't find free user index\n");
> +			LOG_DBG(fp, VERBS_DBG_MASK_QP, mlx5_dbg_level, "Couldn't find free user index\n");
>  			goto err_free_db;
>  		}
>  		cmd.uidx = uidx;
> @@ -2000,7 +2000,7 @@ struct ibv_wq *mlx5_create_wq(struct ibv_context *context,
>  	cmd.drv.rq_wqe_shift = rwq->rq.wqe_shift;
>  	usr_idx = mlx5_store_uidx(ctx, rwq);
>  	if (usr_idx < 0) {
> -		mlx5_dbg(fp, MLX5_DBG_QP, "Couldn't find free user index\n");
> +		LOG_DBG(fp, VERBS_DBG_MASK_QP, mlx5_dbg_level, "Couldn't find free user index\n");
>  		goto err_free_db_rec;
>  	}
>
> --
> 1.8.5.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--+epxrXWOh++2HLjY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh/PVwACgkQ5GN7iDZy
WKdYqBAAiPi89XK/yyM8p0YWglzPKzvG6XEtQZUF+XevQlc/ceyrFWPpvyfAUTJr
TP5K6BiUchjENPJNcaumHvioNRuKvSlUnTpaFc8C75lGlc5DWPe5KkTdmHJzpPAz
65M/Ifi+VggFMmeuwTlwhAlA6ryZb5i/MdKCMRp4AXqX6VQJd+HM5dRdhHsO/ql4
p6XBrbed8WjDFxpibX67IleV25Ei987+9qigT/2iB67l++X27J/018f+D2OT/J+K
PwAPhCmJbI0Lt34cNN+KRReLKF/xktoIBVqWL7DLArZen2u6r7W92hu6/fWzM5BY
PbuqgzYk1JIvRYxj74nT614kekklI2Ocw8S1CwCPwAdxAeHKwr3lJHxAbCyxLf64
ke8Vo65p0A8CRH0EYGIzVsv0u6a7WlvgDOBi31OWRfPOrhIzmBmGhznXu8hKoqKk
RhQZ7jJlhy4FojK+OiFFqEBhk0ojh6tA8Q+ysazTNC4aVIYOaAxXHW9QNQBnLBnU
ltJ2ixR5okEKwVXF6zyfoXsxTtmVNmcp9Uwb/gMori1YHdl/M1tW9BdTqdgeMO+f
34gJPJjiogyO+kyukzEBOvDyQWTKR58uN4cn46+uH8H015bkZi07zyT/c4CBWzKj
IpQIY2ff+IGgH8h8hNUbu5N6HQ2BnLQhUx0ss4eES0qnAM3SDVY=
=cjNo
-----END PGP SIGNATURE-----

--+epxrXWOh++2HLjY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
