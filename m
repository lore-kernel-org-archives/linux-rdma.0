From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5] Add TSO support for RAW Ethernet QP
Date: Thu, 28 Jul 2016 15:48:59 +0300
Message-ID: <1469710139-17063-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When sending TCP packets over RAW Ethernet QP with ibv_post_send, user
has the option to set IBV_WR_TSO flag to enable large segment offload.
The TSO header, header size and maximum segment size must be specified by
the user through ibv_send_wr.

Eligible hardware will break down large chunk of data into smaller
segments per user setup. Error will be returned if TSO is not supported,
or the size of chunk is too large for hardware to handle.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---
 src/cq.c       |   5 +++
 src/mlx5-abi.h |   7 ++--
 src/mlx5.c     |  13 +++++---
 src/mlx5.h     |  10 +++++-
 src/qp.c       | 103 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 src/verbs.c    |  49 ++++++++++++++++++++-------
 src/wqe.h      |   1 +
 7 files changed, 156 insertions(+), 32 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index ddea073..8809703 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -216,6 +216,9 @@ static inline void handle_good_req(struct ibv_wc *wc, struct mlx5_cqe64 *cqe, st
 	case MLX5_OPCODE_UMR:
 		wc->opcode = wq->wr_data[idx];
 		break;
+	case MLX5_OPCODE_TSO:
+		wc->opcode    = IBV_WC_TSO;
+		break;
 	}
 }
 
@@ -1133,6 +1136,8 @@ static inline enum ibv_wc_opcode mlx5_cq_read_wc_opcode(struct ibv_cq_ex *ibcq)
 			return IBV_WC_FETCH_ADD;
 		case MLX5_OPCODE_UMR:
 			return cq->umr_opcode;
+		case MLX5_OPCODE_TSO:
+			return IBV_WC_TSO;
 		}
 	}
 
diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index b57fd55..3d71eb0 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -82,8 +82,8 @@ struct mlx5_alloc_ucontext_resp {
 	__u32				comp_mask;
 	__u32				response_length;
 	__u8				cqe_version;
-	__u8				reserved2;
-	__u16				reserved3;
+	__u8				cmds_supp_uhw;
+	__u16				reserved2;
 	__u64				hca_core_clock_offset;
 };
 
@@ -188,6 +188,9 @@ struct mlx5_query_device_ex {
 
 struct mlx5_query_device_ex_resp {
 	struct ibv_query_device_resp_ex ibv_resp;
+	__u32				comp_mask;
+	__u32				response_length;
+	struct ibv_tso_caps		tso_caps;
 };
 
 #endif /* MLX5_ABI_H */
diff --git a/src/mlx5.c b/src/mlx5.c
index a5f8daf..2d4bf24 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -601,7 +601,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	struct mlx5_device	       *mdev;
 	struct verbs_context	       *v_ctx;
 	struct ibv_port_attr		port_attr;
-	struct ibv_device_attr		device_attr;
+	struct ibv_device_attr_ex	device_attr;
 
 	mdev = to_mdev(&vdev->device);
 	v_ctx = verbs_get_ctx(ctx);
@@ -675,6 +675,8 @@ static int mlx5_init_context(struct verbs_device *vdev,
 			 goto err_free_bf;
 	}
 
+	context->cmds_supp_uhw = resp.cmds_supp_uhw;
+
 	pthread_mutex_init(&context->qp_table_mutex, NULL);
 	pthread_mutex_init(&context->srq_table_mutex, NULL);
 	pthread_mutex_init(&context->uidx_table_mutex, NULL);
@@ -745,9 +747,12 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, create_cq_ex, mlx5_create_cq_ex);
 
 	memset(&device_attr, 0, sizeof(device_attr));
-	if (!mlx5_query_device(ctx, &device_attr)) {
-		context->cached_device_cap_flags = device_attr.device_cap_flags;
-		context->atomic_cap = device_attr.atomic_cap;
+	if (!mlx5_query_device_ex(ctx, NULL, &device_attr,
+				  sizeof(struct ibv_device_attr_ex))) {
+		context->cached_device_cap_flags =
+			device_attr.orig_attr.device_cap_flags;
+		context->atomic_cap = device_attr.orig_attr.atomic_cap;
+		context->cached_tso_caps = device_attr.tso_caps;
 	}
 
 	for (j = 0; j < min(MLX5_MAX_PORTS_NUM, context->num_ports); ++j) {
diff --git a/src/mlx5.h b/src/mlx5.h
index feb095c..5833339 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -209,7 +209,7 @@ enum {
 	MLX5_OPCODE_RDMA_WRITE_IMM	= 0x09,
 	MLX5_OPCODE_SEND		= 0x0a,
 	MLX5_OPCODE_SEND_IMM		= 0x0b,
-	MLX5_OPCODE_LSO			= 0x0e,
+	MLX5_OPCODE_TSO			= 0x0e,
 	MLX5_OPCODE_RDMA_READ		= 0x10,
 	MLX5_OPCODE_ATOMIC_CS		= 0x11,
 	MLX5_OPCODE_ATOMIC_FA		= 0x12,
@@ -266,6 +266,10 @@ enum mlx5_rsc_type {
 	MLX5_RSC_TYPE_INVAL,
 };
 
+enum {
+	MLX5_USER_CMDS_SUPP_UHW_QUERY_DEVICE = 1 << 0,
+};
+
 struct mlx5_resource {
 	enum mlx5_rsc_type	type;
 	uint32_t		rsn;
@@ -340,6 +344,8 @@ struct mlx5_context {
 		uint64_t                mask;
 	} core_clock;
 	void			       *hca_core_clock;
+	struct ibv_tso_caps		cached_tso_caps;
+	int				cmds_supp_uhw;
 };
 
 struct mlx5_bitmap {
@@ -487,6 +493,8 @@ struct mlx5_qp {
 	int                             wq_sig;
 	uint32_t			qp_cap_cache;
 	int				atomics_enabled;
+	uint32_t			max_tso;
+	uint16_t			max_tso_header;
 };
 
 struct mlx5_av {
diff --git a/src/qp.c b/src/qp.c
index 51e1176..ab84319 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -58,7 +58,8 @@ static const uint32_t mlx5_ib_opcode[] = {
 	[IBV_WR_ATOMIC_CMP_AND_SWP]	= MLX5_OPCODE_ATOMIC_CS,
 	[IBV_WR_ATOMIC_FETCH_AND_ADD]	= MLX5_OPCODE_ATOMIC_FA,
 	[IBV_WR_BIND_MW]		= MLX5_OPCODE_UMR,
-	[IBV_WR_LOCAL_INV]		= MLX5_OPCODE_UMR
+	[IBV_WR_LOCAL_INV]		= MLX5_OPCODE_UMR,
+	[IBV_WR_TSO]			= MLX5_OPCODE_TSO,
 };
 
 static void *get_recv_wqe(struct mlx5_qp *qp, int n)
@@ -556,12 +557,68 @@ static inline int set_bind_wr(struct mlx5_qp *qp, enum ibv_mw_type type,
 	return 0;
 }
 
+/* Copy tso header to eth segment with considering padding and WQE
+ * wrap around in WQ buffer.
+ */
+static inline int set_tso_eth_seg(void **seg, struct ibv_send_wr *wr,
+				   void *qend, struct mlx5_qp *qp, int *size)
+{
+	struct mlx5_wqe_eth_seg *eseg = *seg;
+	int size_of_inl_hdr_start = sizeof(eseg->inline_hdr_start);
+	uint64_t left, left_len, copy_sz;
+	void *pdata = wr->tso.hdr;
+#ifdef MLX5_DEBUG
+	FILE *fp = to_mctx(qp->ibv_qp->context)->dbg_fp;
+#endif
+
+	if (unlikely(wr->tso.hdr_sz < MLX5_ETH_L2_MIN_HEADER_SIZE ||
+		     wr->tso.hdr_sz > qp->max_tso_header)) {
+		mlx5_dbg(fp, MLX5_DBG_QP_SEND,
+			 "TSO header size should be at least %d and at most %d\n",
+			 MLX5_ETH_L2_MIN_HEADER_SIZE,
+			 qp->max_tso_header);
+		return EINVAL;
+	}
+
+	left = wr->tso.hdr_sz;
+	eseg->mss = htons(wr->tso.mss);
+	eseg->inline_hdr_sz = htons(wr->tso.hdr_sz);
+
+	/* Check if there is space till the end of queue, if yes,
+	 * copy all in one shot, otherwise copy till the end of queue,
+	 * rollback and then copy the left
+	 */
+	left_len = qend - (void *)eseg->inline_hdr_start;
+	copy_sz = min(left_len, left);
+
+	memcpy(eseg->inline_hdr_start, pdata, copy_sz);
+
+	/* The -1 is because there are already 16 bytes included in
+	 * eseg->inline_hdr[16]
+	 */
+	*seg += align(copy_sz - size_of_inl_hdr_start, 16) - 16;
+	*size += align(copy_sz - size_of_inl_hdr_start, 16) / 16 - 1;
+
+	/* The last wqe in the queue */
+	if (unlikely(copy_sz < left)) {
+		*seg = mlx5_get_send_wqe(qp, 0);
+		left -= copy_sz;
+		pdata += copy_sz;
+		memcpy(*seg, pdata, left);
+		*seg += align(left, 16);
+		*size += align(left, 16) / 16;
+	}
+
+	return 0;
+}
+
 static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 				  struct ibv_send_wr **bad_wr)
 {
 	struct mlx5_context *ctx;
 	struct mlx5_qp *qp = to_mqp(ibqp);
 	void *seg;
+	struct mlx5_wqe_eth_seg *eseg;
 	struct mlx5_wqe_ctrl_seg *ctrl = NULL;
 	struct mlx5_wqe_data_seg *dpseg;
 	struct mlx5_sg_copy_ptr sg_copy_ptr = {.index = 0, .offset = 0};
@@ -578,6 +635,8 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	struct mlx5_wqe_xrc_seg *xrc;
 	uint8_t fence;
 	uint8_t next_fence;
+	uint32_t max_tso = 0;
+
 #ifdef MLX5_DEBUG
 	FILE *fp = to_mctx(ibqp->context)->dbg_fp;
 #endif
@@ -765,15 +824,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 
 		case IBV_QPT_RAW_PACKET:
 			memset(seg, 0, sizeof(struct mlx5_wqe_eth_seg));
-
-			err = copy_eth_inline_headers(ibqp, wr, seg, &sg_copy_ptr);
-			if (unlikely(err)) {
-				*bad_wr = wr;
-				mlx5_dbg(fp, MLX5_DBG_QP_SEND,
-					 "copy_eth_inline_headers failed, err: %d\n",
-					 err);
-				goto out;
-			}
+			eseg = seg;
 
 			if (wr->send_flags & IBV_SEND_IP_CSUM) {
 				if (!(qp->qp_cap_cache & MLX5_CSUM_SUPPORT_RAW_OVER_ETH)) {
@@ -782,8 +833,25 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 					goto out;
 				}
 
-				((struct mlx5_wqe_eth_seg *)seg)->cs_flags |=
-					MLX5_ETH_WQE_L3_CSUM | MLX5_ETH_WQE_L4_CSUM;
+				eseg->cs_flags |= MLX5_ETH_WQE_L3_CSUM | MLX5_ETH_WQE_L4_CSUM;
+			}
+
+			if (wr->opcode == IBV_WR_TSO) {
+				max_tso = qp->max_tso;
+				err = set_tso_eth_seg(&seg, wr, qend, qp, &size);
+				if (unlikely(err)) {
+					*bad_wr = wr;
+					goto out;
+				}
+			} else {
+				err = copy_eth_inline_headers(ibqp, wr, seg, &sg_copy_ptr);
+				if (unlikely(err)) {
+					*bad_wr = wr;
+					mlx5_dbg(fp, MLX5_DBG_QP_SEND,
+						 "copy_eth_inline_headers failed, err: %d\n",
+						 err);
+					goto out;
+				}
 			}
 
 			seg += sizeof(struct mlx5_wqe_eth_seg);
@@ -819,9 +887,18 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 						   wr->opcode ==
 						   IBV_WR_ATOMIC_FETCH_AND_ADD))
 						set_data_ptr_seg_atomic(dpseg, wr->sg_list + i);
-					else
+					else {
+						if (unlikely(wr->opcode == IBV_WR_TSO)) {
+							if (max_tso < wr->sg_list[i].length) {
+								err = EINVAL;
+								*bad_wr = wr;
+								goto out;
+							}
+							max_tso -= wr->sg_list[i].length;
+						}
 						set_data_ptr_seg(dpseg, wr->sg_list + i,
 								 sg_copy_ptr.offset);
+					}
 					sg_copy_ptr.offset = 0;
 					++dpseg;
 					size += sizeof(struct mlx5_wqe_data_seg) / 16;
diff --git a/src/verbs.c b/src/verbs.c
index 40f66c6..621b402 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -792,7 +792,12 @@ static int mlx5_calc_send_wqe(struct mlx5_context *ctx,
 			attr->cap.max_inline_data, 16);
 	}
 
-	max_gather = (ctx->max_sq_desc_sz -  sq_overhead(attr->qp_type)) /
+	if (attr->comp_mask & IBV_QP_INIT_ATTR_MAX_TSO_HEADER) {
+		size += align(attr->max_tso_header, 16);
+		qp->max_tso_header = attr->max_tso_header;
+	}
+
+	max_gather = (ctx->max_sq_desc_sz - size) /
 		sizeof(struct mlx5_wqe_data_seg);
 	if (attr->cap.max_send_sge > max_gather)
 		return -EINVAL;
@@ -1121,11 +1126,13 @@ static int mlx5_cmd_create_qp_ex(struct ibv_context *context,
 enum {
 	MLX5_CREATE_QP_SUP_COMP_MASK = (IBV_QP_INIT_ATTR_PD |
 					IBV_QP_INIT_ATTR_XRCD |
-					IBV_QP_INIT_ATTR_CREATE_FLAGS),
+					IBV_QP_INIT_ATTR_CREATE_FLAGS |
+					IBV_QP_INIT_ATTR_MAX_TSO_HEADER),
 };
 
 enum {
-	MLX5_CREATE_QP_EX2_COMP_MASK = (IBV_QP_INIT_ATTR_CREATE_FLAGS),
+	MLX5_CREATE_QP_EX2_COMP_MASK = (IBV_QP_INIT_ATTR_CREATE_FLAGS |
+					IBV_QP_INIT_ATTR_MAX_TSO_HEADER),
 };
 
 struct ibv_qp *create_qp(struct ibv_context *context,
@@ -1147,6 +1154,10 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 	if (attr->comp_mask & ~MLX5_CREATE_QP_SUP_COMP_MASK)
 		return NULL;
 
+	if ((attr->comp_mask & IBV_QP_INIT_ATTR_MAX_TSO_HEADER) &&
+	    (attr->qp_type != IBV_QPT_RAW_PACKET))
+		return NULL;
+
 	qp = calloc(1, sizeof(*qp));
 	if (!qp) {
 		mlx5_dbg(fp, MLX5_DBG_QP, "\n");
@@ -1431,12 +1442,20 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	if (attr_mask & IBV_QP_PORT) {
 		switch (qp->qp_type) {
 		case IBV_QPT_RAW_PACKET:
-			if ((context->cached_link_layer[attr->port_num - 1] ==
-			     IBV_LINK_LAYER_ETHERNET) &&
-			    (context->cached_device_cap_flags &
-			     IBV_DEVICE_RAW_IP_CSUM))
-				mqp->qp_cap_cache |= MLX5_CSUM_SUPPORT_RAW_OVER_ETH |
-						     MLX5_RX_CSUM_VALID;
+			if (context->cached_link_layer[attr->port_num - 1] ==
+			     IBV_LINK_LAYER_ETHERNET) {
+				if (context->cached_device_cap_flags &
+				    IBV_DEVICE_RAW_IP_CSUM)
+					mqp->qp_cap_cache |=
+						MLX5_CSUM_SUPPORT_RAW_OVER_ETH |
+						MLX5_RX_CSUM_VALID;
+
+				if (ibv_is_qpt_supported(
+				 context->cached_tso_caps.supported_qpts,
+				 IBV_QPT_RAW_PACKET))
+					mqp->max_tso =
+					     context->cached_tso_caps.max_tso;
+			}
 			break;
 		default:
 			break;
@@ -1726,6 +1745,7 @@ int mlx5_query_device_ex(struct ibv_context *context,
 			 struct ibv_device_attr_ex *attr,
 			 size_t attr_size)
 {
+	struct mlx5_context *mctx = to_mctx(context);
 	struct mlx5_query_device_ex_resp resp;
 	struct mlx5_query_device_ex cmd;
 	struct ibv_device_attr *a;
@@ -1734,16 +1754,21 @@ int mlx5_query_device_ex(struct ibv_context *context,
 	unsigned major;
 	unsigned minor;
 	int err;
+	int cmd_supp_uhw = mctx->cmds_supp_uhw &
+		MLX5_USER_CMDS_SUPP_UHW_QUERY_DEVICE;
 
 	memset(&cmd, 0, sizeof(cmd));
 	memset(&resp, 0, sizeof(resp));
 	err = ibv_cmd_query_device_ex(context, input, attr, attr_size,
-				      &raw_fw_ver, &cmd.ibv_cmd, sizeof(cmd.ibv_cmd),
-				      sizeof(cmd), &resp.ibv_resp, sizeof(resp),
-				      sizeof(resp.ibv_resp));
+				      &raw_fw_ver,
+				      &cmd.ibv_cmd, sizeof(cmd.ibv_cmd), sizeof(cmd),
+				      &resp.ibv_resp, sizeof(resp.ibv_resp),
+				      cmd_supp_uhw ? sizeof(resp) : sizeof(resp.ibv_resp));
 	if (err)
 		return err;
 
+	attr->tso_caps = resp.tso_caps;
+
 	major     = (raw_fw_ver >> 32) & 0xffff;
 	minor     = (raw_fw_ver >> 16) & 0xffff;
 	sub_minor = raw_fw_ver & 0xffff;
diff --git a/src/wqe.h b/src/wqe.h
index c2622d5..f097b77 100644
--- a/src/wqe.h
+++ b/src/wqe.h
@@ -78,6 +78,7 @@ struct mlx5_eqe_qp_srq {
 
 enum {
 	MLX5_ETH_L2_INLINE_HEADER_SIZE	= 18,
+	MLX5_ETH_L2_MIN_HEADER_SIZE	= 14,
 };
 
 enum {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
