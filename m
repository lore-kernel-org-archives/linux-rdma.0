From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [v1] libmlx5: Add support for RAW_ETH TX/RX checksum offload
Date: Wed,  3 Feb 2016 19:05:32 +0200
Message-ID: <1454519132-46636-1-git-send-email-bodong@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RX checksum verification status is reported through wc_flag when polling
CQ. When IBV_WC_IP_CSUM_OK is set, that means both IPv4 header checksum and
TCP/UDP checksum are OK.

TX checksum offload will be enabled for TCP/UDP over IPv4 if user sets
send_flag IBV_SEND_IP_CSUM.

A new field, qp_cap_cache, is added to mlx5_qp in order to 'cache'
the csum capabilities to minimize perfromance hit on poll_one
function. The device and port capabilities are cached inside
mlx5_init_context.

Change-Id: I4d26f43027c08e7142e77a977744e2abe08a6e58
Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c    | 31 ++++++++++++++++++++++++++++---
 src/mlx5.c  | 12 ++++++++++++
 src/mlx5.h  | 16 ++++++++++++++++
 src/qp.c    | 10 ++++++++++
 src/verbs.c | 16 ++++++++++++++++
 src/wqe.h   |  5 +++++
 6 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 79a200f..ce18ac9 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -97,6 +97,18 @@ enum {
 	MLX5_CQ_MODIFY_MAPPING = 2,
 };
 
+enum {
+	MLX5_CQE_L2_OK = 1 << 0,
+	MLX5_CQE_L3_OK = 1 << 1,
+	MLX5_CQE_L4_OK = 1 << 2,
+};
+
+enum {
+	MLX5_CQE_L3_HDR_TYPE_NONE = 0x0,
+	MLX5_CQE_L3_HDR_TYPE_IPV6 = 0x1,
+	MLX5_CQE_L3_HDR_TYPE_IPV4 = 0x2,
+};
+
 struct mlx5_err_cqe {
 	uint8_t		rsvd0[32];
 	uint32_t	srqn;
@@ -115,7 +127,9 @@ struct mlx5_cqe64 {
 	uint8_t		rsvd20[4];
 	uint16_t	slid;
 	uint32_t	flags_rqpn;
-	uint8_t		rsvd28[4];
+	uint8_t		hds_ip_ext;
+	uint8_t		l4_hdr_type_etc;
+	uint16_t	vlan_info;
 	uint32_t	srqn_uidx;
 	uint32_t	imm_inval_pkey;
 	uint8_t		rsvd40[4];
@@ -133,6 +147,11 @@ int mlx5_stall_cq_poll_max = 100000;
 int mlx5_stall_cq_inc_step = 100;
 int mlx5_stall_cq_dec_step = 10;
 
+static inline uint8_t get_cqe_l3_hdr_type(struct mlx5_cqe64 *cqe)
+{
+	return (cqe->l4_hdr_type_etc >> 2) & 0x3;
+}
+
 static void *get_buf_cqe(struct mlx5_buf *buf, int n, int cqe_sz)
 {
 	return buf->buf + n * cqe_sz;
@@ -230,6 +249,12 @@ static int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 		else if (cqe->op_own & MLX5_INLINE_SCATTER_64)
 			err = mlx5_copy_to_recv_wqe(qp, wqe_ctr, cqe - 1,
 						    wc->byte_len);
+		if (qp->qp_cap_cache & MLX5_RX_CSUM_VALID)
+			wc->wc_flags |= (!!(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
+					 !!(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
+					(get_cqe_l3_hdr_type(cqe) ==
+					MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
+					IBV_WC_IP_CSUM_OK_SHIFT;
 	}
 	if (err)
 		return err;
@@ -239,7 +264,7 @@ static int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 	switch (cqe->op_own >> 4) {
 	case MLX5_CQE_RESP_WR_IMM:
 		wc->opcode	= IBV_WC_RECV_RDMA_WITH_IMM;
-		wc->wc_flags	= IBV_WC_WITH_IMM;
+		wc->wc_flags	|= IBV_WC_WITH_IMM;
 		wc->imm_data = cqe->imm_inval_pkey;
 		break;
 	case MLX5_CQE_RESP_SEND:
@@ -247,7 +272,7 @@ static int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 		break;
 	case MLX5_CQE_RESP_SEND_IMM:
 		wc->opcode	= IBV_WC_RECV;
-		wc->wc_flags	= IBV_WC_WITH_IMM;
+		wc->wc_flags	|= IBV_WC_WITH_IMM;
 		wc->imm_data = cqe->imm_inval_pkey;
 		break;
 	}
diff --git a/src/mlx5.c b/src/mlx5.c
index 0469a78..b9e91ca 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -547,6 +547,8 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	off_t				offset;
 	struct mlx5_device	       *mdev;
 	struct verbs_context	       *v_ctx;
+	struct ibv_port_attr		port_attr;
+	struct ibv_device_attr		device_attr;
 
 	mdev = to_mdev(&vdev->device);
 	v_ctx = verbs_get_ctx(ctx);
@@ -675,6 +677,16 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, get_srq_num, mlx5_get_srq_num);
 	verbs_set_ctx_op(v_ctx, query_device_ex, mlx5_query_device_ex);
 
+	memset(&device_attr, 0, sizeof(device_attr));
+	if (!ibv_query_device(ctx, &device_attr))
+		context->cached_device_cap_flags = device_attr.device_cap_flags;
+
+	for (j = 0; j < min(MLX5_MAX_PORTS_NUM, context->num_ports); ++j) {
+		memset(&port_attr, 0, sizeof(port_attr));
+		if (!ibv_query_port(ctx, j+1, &port_attr))
+			context->cached_link_layer[j] = port_attr.link_layer;
+	}
+
 	return 0;
 
 err_free_bf:
diff --git a/src/mlx5.h b/src/mlx5.h
index 4fa0f46..0a30702 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -230,6 +230,19 @@ enum {
 	MLX5_INLINE_SEG	= 0x80000000,
 };
 
+enum {
+	MLX5_MAX_PORTS_NUM = 2,
+};
+
+enum {
+	MLX5_CSUM_SUPPORT_RAW_OVER_ETH  = (1 <<  0),
+	/*
+	 * Only report rx checksum when the validation
+	 * is valid.
+	 */
+	MLX5_RX_CSUM_VALID              = (1 << 16),
+};
+
 enum mlx5_alloc_type {
 	MLX5_ALLOC_TYPE_ANON,
 	MLX5_ALLOC_TYPE_HUGE,
@@ -312,6 +325,8 @@ struct mlx5_context {
 	struct mlx5_spinlock            hugetlb_lock;
 	struct list_head                hugetlb_list;
 	int				cqe_version;
+	uint8_t				cached_link_layer[MLX5_MAX_PORTS_NUM];
+	int				cached_device_cap_flags;
 };
 
 struct mlx5_bitmap {
@@ -441,6 +456,7 @@ struct mlx5_qp {
 	uint32_t                       *db;
 	struct mlx5_wq                  rq;
 	int                             wq_sig;
+	uint32_t			qp_cap_cache;
 };
 
 struct mlx5_av {
diff --git a/src/qp.c b/src/qp.c
index 0deaf1d..c4c90dc 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -508,6 +508,16 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 				goto out;
 			}
 
+			if (wr->send_flags & IBV_SEND_IP_CSUM) {
+				if (!(qp->qp_cap_cache & MLX5_CSUM_SUPPORT_RAW_OVER_ETH)) {
+					err = EINVAL;
+					*bad_wr = wr;
+					goto out;
+				}
+				((struct mlx5_wqe_eth_seg *)seg)->cs_flags |=
+					MLX5_ETH_WQE_L3_CSUM | MLX5_ETH_WQE_L4_CSUM;
+			}
+
 			seg += sizeof(struct mlx5_wqe_eth_seg);
 			size += sizeof(struct mlx5_wqe_eth_seg) / 16;
 			break;
diff --git a/src/verbs.c b/src/verbs.c
index da62775..14bdb08 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -1192,9 +1192,25 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 {
 	struct ibv_modify_qp cmd;
 	struct mlx5_qp *mqp = to_mqp(qp);
+	struct mlx5_context *context = to_mctx(qp->context);
 	int ret;
 	uint32_t *db;
 
+	if (attr_mask & IBV_QP_PORT) {
+		switch(qp->qp_type) {
+		case IBV_QPT_RAW_PACKET:
+			if ((context->cached_link_layer[attr->port_num - 1] ==
+			     IBV_LINK_LAYER_ETHERNET) &&
+			    (context->cached_device_cap_flags &
+			     IBV_DEVICE_RAW_IP_CSUM))
+				mqp->qp_cap_cache |= MLX5_CSUM_SUPPORT_RAW_OVER_ETH |
+						     MLX5_RX_CSUM_VALID;
+			break;
+		default:
+			break;
+		}
+	}
+
 	ret = ibv_cmd_modify_qp(qp, attr, attr_mask, &cmd, sizeof(cmd));
 
 	if (!ret		       &&
diff --git a/src/wqe.h b/src/wqe.h
index eaaf7a6..c3a024a 100644
--- a/src/wqe.h
+++ b/src/wqe.h
@@ -76,6 +76,11 @@ struct mlx5_eqe_qp_srq {
 };
 
 enum {
+	MLX5_ETH_WQE_L3_CSUM = (1 << 6),
+	MLX5_ETH_WQE_L4_CSUM = (1 << 7),
+};
+
+enum {
 	MLX5_ETH_L2_INLINE_HEADER_SIZE	= 18,
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
