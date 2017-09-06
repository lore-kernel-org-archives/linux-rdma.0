From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/3] mlx5: Add support for managing QP with a
 given source QP number
Date: Wed, 6 Sep 2017 18:12:22 +0300
Message-ID: <20170906151222.GA23532@yuvallap>
References: <1504708729-15249-1-git-send-email-yishaih@mellanox.com>
 <1504708729-15249-3-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1504708729-15249-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 06, 2017 at 05:38:48PM +0300, Yishai Hadas wrote:
> Add support to create a QP with source QPN (e.g. IPoIB QPN) over UD QP.

Sorry, i missed the kernel patches.
Is this UD limitation is for mlx5 only? Asking as i see no limitation in
the verb layer (patch 1/3).
If no, any plans for CM?
If yes, why?

> 
> It includes:
> - Input checking that basic QP type is UD.
> - Create and manage driver resources as done for RAW QP.
> 
> Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  providers/mlx5/mlx5.h  |  8 +++++++-
>  providers/mlx5/qp.c    |  3 ++-
>  providers/mlx5/verbs.c | 36 +++++++++++++++++++++++++++++++-----
>  3 files changed, 40 insertions(+), 7 deletions(-)
> 
> diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
> index ad36cbf..ae39d17 100644
> --- a/providers/mlx5/mlx5.h
> +++ b/providers/mlx5/mlx5.h
> @@ -150,7 +150,8 @@ enum {
>  };
>  
>  enum {
> -	MLX5_CSUM_SUPPORT_RAW_OVER_ETH  = (1 <<  0),
> +	MLX5_CSUM_SUPPORT_RAW_OVER_ETH  = (1 << 0),
> +	MLX5_CSUM_SUPPORT_UNDERLAY_UD   = (1 << 1),
>  	/*
>  	 * Only report rx checksum when the validation
>  	 * is valid.
> @@ -396,6 +397,10 @@ struct mlx5_mr {
>  	uint32_t			alloc_flags;
>  };
>  
> +enum mlx5_qp_flags {
> +	MLX5_QP_FLAGS_USE_UNDERLAY = 0x01,
> +};
> +
>  struct mlx5_qp {
>  	struct mlx5_resource            rsc; /* This struct must be first */
>  	struct verbs_qp			verbs_qp;
> @@ -421,6 +426,7 @@ struct mlx5_qp {
>  	uint32_t			max_tso;
>  	uint16_t			max_tso_header;
>  	int                             rss_qp;
> +	uint32_t			flags; /* Use enum mlx5_qp_flags */
>  };
>  
>  struct mlx5_ah {
> diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
> index 52da8c1..2960ba0 100644
> --- a/providers/mlx5/qp.c
> +++ b/providers/mlx5/qp.c
> @@ -1199,7 +1199,8 @@ out:
>  		 * This is only for Raw Packet QPs since they are represented
>  		 * differently in the hardware.
>  		 */
> -		if (likely(!(ibqp->qp_type == IBV_QPT_RAW_PACKET &&
> +		if (likely(!((ibqp->qp_type == IBV_QPT_RAW_PACKET ||
> +			      qp->flags & MLX5_QP_FLAGS_USE_UNDERLAY) &&
>  			     ibqp->state < IBV_QPS_RTR)))
>  			qp->db[MLX5_RCV_DBR] = htobe32(qp->rq.head & 0xffff);
>  	}
> diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
> index fc63ae9..a469c93 100644
> --- a/providers/mlx5/verbs.c
> +++ b/providers/mlx5/verbs.c
> @@ -1096,7 +1096,8 @@ static int mlx5_alloc_qp_buf(struct ibv_context *context,
>  
>  	memset(qp->buf.buf, 0, qp->buf_size);
>  
> -	if (attr->qp_type == IBV_QPT_RAW_PACKET) {
> +	if (attr->qp_type == IBV_QPT_RAW_PACKET ||
> +	    qp->flags & MLX5_QP_FLAGS_USE_UNDERLAY) {
>  		size_t aligned_sq_buf_size = align(qp->sq_buf_size,
>  						   to_mdev(context->device)->page_size);
>  		/* For Raw Packet QP, allocate a separate buffer for the SQ */
> @@ -1257,6 +1258,17 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
>  	ibqp = (struct ibv_qp *)&qp->verbs_qp;
>  	qp->ibv_qp = ibqp;
>  
> +	if ((attr->comp_mask & IBV_QP_INIT_ATTR_CREATE_FLAGS) &&
> +		(attr->create_flags & IBV_QP_CREATE_SOURCE_QPN)) {
> +
> +		if (attr->qp_type != IBV_QPT_UD) {
> +			errno = EINVAL;
> +			goto err;
> +		}
> +
> +		qp->flags |= MLX5_QP_FLAGS_USE_UNDERLAY;
> +	}
> +
>  	memset(&cmd, 0, sizeof(cmd));
>  	memset(&resp, 0, sizeof(resp));
>  	memset(&resp_ex, 0, sizeof(resp_ex));
> @@ -1282,7 +1294,8 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
>  		goto err;
>  	}
>  
> -	if (attr->qp_type == IBV_QPT_RAW_PACKET) {
> +	if (attr->qp_type == IBV_QPT_RAW_PACKET ||
> +	    qp->flags & MLX5_QP_FLAGS_USE_UNDERLAY) {
>  		qp->buf_size = qp->sq.offset;
>  		qp->sq_buf_size = ret - qp->buf_size;
>  		qp->sq.offset = 0;
> @@ -1296,7 +1309,8 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
>  		goto err;
>  	}
>  
> -	if (attr->qp_type == IBV_QPT_RAW_PACKET) {
> +	if (attr->qp_type == IBV_QPT_RAW_PACKET ||
> +	    qp->flags & MLX5_QP_FLAGS_USE_UNDERLAY) {
>  		qp->sq_start = qp->sq_buf.buf;
>  		qp->sq.qend = qp->sq_buf.buf +
>  				(qp->sq.wqe_cnt << qp->sq.wqe_shift);
> @@ -1322,7 +1336,8 @@ static struct ibv_qp *create_qp(struct ibv_context *context,
>  	qp->db[MLX5_SND_DBR] = 0;
>  
>  	cmd.buf_addr = (uintptr_t) qp->buf.buf;
> -	cmd.sq_buf_addr = (attr->qp_type == IBV_QPT_RAW_PACKET) ?
> +	cmd.sq_buf_addr = (attr->qp_type == IBV_QPT_RAW_PACKET ||
> +			   qp->flags & MLX5_QP_FLAGS_USE_UNDERLAY) ?
>  			  (uintptr_t) qp->sq_buf.buf : 0;
>  	cmd.db_addr  = (uintptr_t) qp->db;
>  	cmd.sq_wqe_count = qp->sq.wqe_cnt;
> @@ -1560,6 +1575,16 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
>  	if (mqp->rss_qp)
>  		return ENOSYS;
>  
> +	if (mqp->flags & MLX5_QP_FLAGS_USE_UNDERLAY) {
> +		if (attr_mask & ~(IBV_QP_STATE | IBV_QP_CUR_STATE))
> +			return EINVAL;
> +
> +		/* Underlay QP is UD over infiniband */
> +		if (context->cached_device_cap_flags & IBV_DEVICE_UD_IP_CSUM)
> +			mqp->qp_cap_cache |= MLX5_CSUM_SUPPORT_UNDERLAY_UD |
> +					     MLX5_RX_CSUM_VALID;
> +	}
> +
>  	if (attr_mask & IBV_QP_PORT) {
>  		switch (qp->qp_type) {
>  		case IBV_QPT_RAW_PACKET:
> @@ -1621,7 +1646,8 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
>  	if (!ret &&
>  	    (attr_mask & IBV_QP_STATE) &&
>  	    attr->qp_state == IBV_QPS_RTR &&
> -	    qp->qp_type == IBV_QPT_RAW_PACKET) {
> +	    (qp->qp_type == IBV_QPT_RAW_PACKET ||
> +	     mqp->flags & MLX5_QP_FLAGS_USE_UNDERLAY)) {
>  		mlx5_spin_lock(&mqp->rq.lock);
>  		mqp->db[MLX5_RCV_DBR] = htobe32(mqp->rq.head & 0xffff);
>  		mlx5_spin_unlock(&mqp->rq.lock);
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
