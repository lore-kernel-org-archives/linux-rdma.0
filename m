From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 1/7] mlx5: Add mlx5 direct verbs
Date: Sun, 12 Feb 2017 16:16:46 +0200
Message-ID: <1486909012-15064-2-git-send-email-yishaih@mellanox.com>
References: <1486909012-15064-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486909012-15064-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Direct verbs feature provides fast data path execution by
implementing verbs directly over hardware specification.

It consists from the two parts:
 * Exported functions to translate internal mlx5 structures to be
   accessible by user applications.
 * Inline functions, enums and defines to simplify programmer's life.

This patch adds one header file (mlx5dv.h) with general, CQE and WQE data.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/cq.c     |  84 +----------
 providers/mlx5/mlx5.c   | 109 ++++++++++++++
 providers/mlx5/mlx5.h   |  62 +-------
 providers/mlx5/mlx5dv.h | 371 ++++++++++++++++++++++++++++++++++++++++++++++++
 providers/mlx5/qp.c     |   2 +-
 providers/mlx5/wqe.h    |  97 +------------
 6 files changed, 490 insertions(+), 235 deletions(-)
 create mode 100644 providers/mlx5/mlx5dv.h

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index b53fa66..88bca75 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -48,97 +48,17 @@
 #include "doorbell.h"
 
 enum {
-	MLX5_CQ_DOORBELL			= 0x20
-};
-
-enum {
 	CQ_OK					=  0,
 	CQ_EMPTY				= -1,
 	CQ_POLL_ERR				= -2
 };
 
-#define MLX5_CQ_DB_REQ_NOT_SOL			(1 << 24)
-#define MLX5_CQ_DB_REQ_NOT			(0 << 24)
-
-enum {
-	MLX5_CQE_SYNDROME_LOCAL_LENGTH_ERR		= 0x01,
-	MLX5_CQE_SYNDROME_LOCAL_QP_OP_ERR		= 0x02,
-	MLX5_CQE_SYNDROME_LOCAL_PROT_ERR		= 0x04,
-	MLX5_CQE_SYNDROME_WR_FLUSH_ERR			= 0x05,
-	MLX5_CQE_SYNDROME_MW_BIND_ERR			= 0x06,
-	MLX5_CQE_SYNDROME_BAD_RESP_ERR			= 0x10,
-	MLX5_CQE_SYNDROME_LOCAL_ACCESS_ERR		= 0x11,
-	MLX5_CQE_SYNDROME_REMOTE_INVAL_REQ_ERR		= 0x12,
-	MLX5_CQE_SYNDROME_REMOTE_ACCESS_ERR		= 0x13,
-	MLX5_CQE_SYNDROME_REMOTE_OP_ERR			= 0x14,
-	MLX5_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR	= 0x15,
-	MLX5_CQE_SYNDROME_RNR_RETRY_EXC_ERR		= 0x16,
-	MLX5_CQE_SYNDROME_REMOTE_ABORTED_ERR		= 0x22,
-};
-
-enum {
-	MLX5_CQE_OWNER_MASK	= 1,
-	MLX5_CQE_REQ		= 0,
-	MLX5_CQE_RESP_WR_IMM	= 1,
-	MLX5_CQE_RESP_SEND	= 2,
-	MLX5_CQE_RESP_SEND_IMM	= 3,
-	MLX5_CQE_RESP_SEND_INV	= 4,
-	MLX5_CQE_RESIZE_CQ	= 5,
-	MLX5_CQE_REQ_ERR	= 13,
-	MLX5_CQE_RESP_ERR	= 14,
-	MLX5_CQE_INVALID	= 15,
-};
-
 enum {
 	MLX5_CQ_MODIFY_RESEIZE = 0,
 	MLX5_CQ_MODIFY_MODER = 1,
 	MLX5_CQ_MODIFY_MAPPING = 2,
 };
 
-enum {
-	MLX5_CQE_L2_OK = 1 << 0,
-	MLX5_CQE_L3_OK = 1 << 1,
-	MLX5_CQE_L4_OK = 1 << 2,
-};
-
-enum {
-	MLX5_CQE_L3_HDR_TYPE_NONE = 0x0,
-	MLX5_CQE_L3_HDR_TYPE_IPV6 = 0x1,
-	MLX5_CQE_L3_HDR_TYPE_IPV4 = 0x2,
-};
-
-struct mlx5_err_cqe {
-	uint8_t		rsvd0[32];
-	uint32_t	srqn;
-	uint8_t		rsvd1[18];
-	uint8_t		vendor_err_synd;
-	uint8_t		syndrome;
-	uint32_t	s_wqe_opcode_qpn;
-	uint16_t	wqe_counter;
-	uint8_t		signature;
-	uint8_t		op_own;
-};
-
-struct mlx5_cqe64 {
-	uint8_t		rsvd0[17];
-	uint8_t		ml_path;
-	uint8_t		rsvd20[4];
-	uint16_t	slid;
-	uint32_t	flags_rqpn;
-	uint8_t		hds_ip_ext;
-	uint8_t		l4_hdr_type_etc;
-	uint16_t	vlan_info;
-	uint32_t	srqn_uidx;
-	uint32_t	imm_inval_pkey;
-	uint8_t		rsvd40[4];
-	uint32_t	byte_cnt;
-	__be64		timestamp;
-	uint32_t	sop_drop_qpn;
-	uint16_t	wqe_counter;
-	uint8_t		signature;
-	uint8_t		op_own;
-};
-
 int mlx5_stall_num_loop = 60;
 int mlx5_stall_cq_poll_min = 60;
 int mlx5_stall_cq_poll_max = 100000;
@@ -258,7 +178,7 @@ static inline int handle_responder_lazy(struct mlx5_cq *cq, struct mlx5_cqe64 *c
 		else if (cqe->op_own & MLX5_INLINE_SCATTER_64)
 			err = mlx5_copy_to_recv_wqe(qp, wqe_ctr, cqe - 1,
 						    ntohl(cqe->byte_cnt));
-	}
+}
 
 	return err;
 }
@@ -1435,7 +1355,7 @@ void __mlx5_cq_clean(struct mlx5_cq *cq, uint32_t rsn, struct mlx5_srq *srq)
 	uint8_t owner_bit;
 	int cqe_version;
 
-	if (!cq)
+	if (!cq || cq->flags & MLX5_CQ_FLAGS_DV_OWNED)
 		return;
 
 	/*
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 747e242..1cf5a5f 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -578,6 +578,115 @@ static int mlx5_map_internal_clock(struct mlx5_device *mdev,
 	return 0;
 }
 
+int mlx5dv_query_device(struct ibv_context *ctx_in,
+			 struct mlx5dv_context *attrs_out)
+{
+	attrs_out->comp_mask = 0;
+	attrs_out->version   = 0;
+	attrs_out->flags     = 0;
+
+	if (to_mctx(ctx_in)->cqe_version == MLX5_CQE_VERSION_V1)
+		attrs_out->flags |= MLX5DV_CONTEXT_FLAGS_CQE_V1;
+
+	return 0;
+}
+
+static int mlx5dv_get_qp(struct ibv_qp *qp_in,
+			 struct mlx5dv_qp *qp_out)
+{
+	struct mlx5_qp *mqp = to_mqp(qp_in);
+
+	qp_out->comp_mask = 0;
+	qp_out->dbrec     = mqp->db;
+
+	if (mqp->sq_buf_size)
+		/* IBV_QPT_RAW_PACKET */
+		qp_out->sq.buf = (void *)((uintptr_t)mqp->sq_buf.buf);
+	else
+		qp_out->sq.buf = (void *)((uintptr_t)mqp->buf.buf + mqp->sq.offset);
+	qp_out->sq.wqe_cnt = mqp->sq.wqe_cnt;
+	qp_out->sq.stride  = 1 << mqp->sq.wqe_shift;
+
+	qp_out->rq.buf     = (void *)((uintptr_t)mqp->buf.buf + mqp->rq.offset);
+	qp_out->rq.wqe_cnt = mqp->rq.wqe_cnt;
+	qp_out->rq.stride  = 1 << mqp->rq.wqe_shift;
+
+	qp_out->bf.reg    = mqp->bf->reg;
+
+	if (mqp->bf->uuarn > 0)
+		qp_out->bf.size = mqp->bf->buf_size;
+	else
+		qp_out->bf.size = 0;
+
+	return 0;
+}
+
+static int mlx5dv_get_cq(struct ibv_cq *cq_in,
+			 struct mlx5dv_cq *cq_out)
+{
+	struct mlx5_cq *mcq = to_mcq(cq_in);
+	struct mlx5_context *mctx = to_mctx(cq_in->context);
+
+	cq_out->comp_mask = 0;
+	cq_out->cqn       = mcq->cqn;
+	cq_out->cqe_cnt   = mcq->ibv_cq.cqe + 1;
+	cq_out->cqe_size  = mcq->cqe_sz;
+	cq_out->buf       = mcq->active_buf->buf;
+	cq_out->dbrec     = mcq->dbrec;
+	cq_out->uar	  = mctx->uar;
+
+	mcq->flags	 |= MLX5_CQ_FLAGS_DV_OWNED;
+
+	return 0;
+}
+
+static int mlx5dv_get_rwq(struct ibv_wq *wq_in,
+			  struct mlx5dv_rwq *rwq_out)
+{
+	struct mlx5_rwq *mrwq = to_mrwq(wq_in);
+
+	rwq_out->comp_mask = 0;
+	rwq_out->buf       = mrwq->pbuff;
+	rwq_out->dbrec     = mrwq->recv_db;
+	rwq_out->wqe_cnt   = mrwq->rq.wqe_cnt;
+	rwq_out->stride    = 1 << mrwq->rq.wqe_shift;
+
+	return 0;
+}
+
+static int mlx5dv_get_srq(struct ibv_srq *srq_in,
+			  struct mlx5dv_srq *srq_out)
+{
+	struct mlx5_srq *msrq;
+
+	msrq = container_of(srq_in, struct mlx5_srq, vsrq.srq);
+
+	srq_out->comp_mask = 0;
+	srq_out->buf       = msrq->buf.buf;
+	srq_out->dbrec     = msrq->db;
+	srq_out->stride    = 1 << msrq->wqe_shift;
+	srq_out->head      = msrq->head;
+	srq_out->tail      = msrq->tail;
+
+	return 0;
+}
+
+int mlx5dv_init_obj(struct mlx5dv_obj *obj, uint64_t obj_type)
+{
+	int ret = 0;
+
+	if (obj_type & MLX5DV_OBJ_QP)
+		ret = mlx5dv_get_qp(obj->qp.in, obj->qp.out);
+	if (!ret && (obj_type & MLX5DV_OBJ_CQ))
+		ret = mlx5dv_get_cq(obj->cq.in, obj->cq.out);
+	if (!ret && (obj_type & MLX5DV_OBJ_SRQ))
+		ret = mlx5dv_get_srq(obj->srq.in, obj->srq.out);
+	if (!ret && (obj_type & MLX5DV_OBJ_RWQ))
+		ret = mlx5dv_get_rwq(obj->rwq.in, obj->rwq.out);
+
+	return ret;
+}
+
 static int mlx5_init_context(struct verbs_device *vdev,
 			     struct ibv_context *ctx, int cmd_fd)
 {
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 3f89f4b..f75bbf1 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -43,6 +43,7 @@
 #include <ccan/list.h>
 #include "bitmap.h"
 #include <ccan/minmax.h>
+#include "mlx5dv.h"
 
 #include <valgrind/memcheck.h>
 
@@ -100,11 +101,6 @@ static inline void mlx5_dbg(FILE *fp, uint32_t mask, const char *fmt, ...)
 #endif
 
 enum {
-	MLX5_RCV_DBR	= 0,
-	MLX5_SND_DBR	= 1,
-};
-
-enum {
 	MLX5_STAT_RATE_OFFSET		= 5
 };
 
@@ -127,36 +123,10 @@ enum {
 };
 
 enum {
-	MLX5_SEND_WQE_BB	= 64,
-	MLX5_SEND_WQE_SHIFT	= 6,
-};
-
-enum {
 	MLX5_BF_OFFSET	= 0x800
 };
 
 enum {
-	MLX5_INLINE_SCATTER_32	= 0x4,
-	MLX5_INLINE_SCATTER_64	= 0x8,
-};
-
-enum {
-	MLX5_OPCODE_NOP			= 0x00,
-	MLX5_OPCODE_SEND_INVAL		= 0x01,
-	MLX5_OPCODE_RDMA_WRITE		= 0x08,
-	MLX5_OPCODE_RDMA_WRITE_IMM	= 0x09,
-	MLX5_OPCODE_SEND		= 0x0a,
-	MLX5_OPCODE_SEND_IMM		= 0x0b,
-	MLX5_OPCODE_TSO			= 0x0e,
-	MLX5_OPCODE_RDMA_READ		= 0x10,
-	MLX5_OPCODE_ATOMIC_CS		= 0x11,
-	MLX5_OPCODE_ATOMIC_FA		= 0x12,
-	MLX5_OPCODE_ATOMIC_MASKED_CS	= 0x14,
-	MLX5_OPCODE_ATOMIC_MASKED_FA	= 0x15,
-	MLX5_OPCODE_FMR			= 0x19,
-	MLX5_OPCODE_LOCAL_INVAL		= 0x1b,
-	MLX5_OPCODE_CONFIG_CMD		= 0x1f,
-
 	MLX5_RECV_OPCODE_RDMA_WRITE_IMM	= 0x00,
 	MLX5_RECV_OPCODE_SEND		= 0x01,
 	MLX5_RECV_OPCODE_SEND_IMM	= 0x02,
@@ -164,7 +134,6 @@ enum {
 
 	MLX5_CQE_OPCODE_ERROR		= 0x1e,
 	MLX5_CQE_OPCODE_RESIZE		= 0x16,
-	MLX5_OPCODE_UMR			= 0x25,
 };
 
 enum {
@@ -172,10 +141,6 @@ enum {
 };
 
 enum {
-	MLX5_INLINE_SEG	= 0x80000000,
-};
-
-enum {
 	MLX5_MAX_PORTS_NUM = 2,
 };
 
@@ -239,7 +204,7 @@ struct mlx5_context {
 	int				prefer_bf;
 	int				shut_up_bf;
 	struct {
-		struct mlx5_qp	      **table;
+		struct mlx5_qp        **table;
 		int			refcnt;
 	}				qp_table[MLX5_QP_TABLE_SIZE];
 	pthread_mutex_t			qp_table_mutex;
@@ -328,6 +293,7 @@ enum {
 	MLX5_CQ_FLAGS_FOUND_CQES = 1 << 2,
 	MLX5_CQ_FLAGS_EXTENDED = 1 << 3,
 	MLX5_CQ_FLAGS_SINGLE_THREADED = 1 << 4,
+	MLX5_CQ_FLAGS_DV_OWNED = 1 << 5,
 };
 
 struct mlx5_cq {
@@ -438,29 +404,9 @@ struct mlx5_qp {
 	int                             rss_qp;
 };
 
-struct mlx5_av {
-	union {
-		struct {
-			uint32_t	qkey;
-			uint32_t	reserved;
-		} qkey;
-		uint64_t	dc_key;
-	} key;
-	uint32_t	dqp_dct;
-	uint8_t		stat_rate_sl;
-	uint8_t		fl_mlid;
-	uint16_t	rlid;
-	uint8_t		reserved0[4];
-	uint8_t		rmac[6];
-	uint8_t		tclass;
-	uint8_t		hop_limit;
-	uint32_t	grh_gid_fl;
-	uint8_t		rgid[16];
-};
-
 struct mlx5_ah {
 	struct ibv_ah			ibv_ah;
-	struct mlx5_av			av;
+	struct mlx5_wqe_av		av;
 	bool				kern_ah;
 };
 
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
new file mode 100644
index 0000000..34502a8
--- /dev/null
+++ b/providers/mlx5/mlx5dv.h
@@ -0,0 +1,371 @@
+/*
+ * Copyright (c) 2017 Mellanox Technologies, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _MLX5DV_H_
+#define _MLX5DV_H_
+
+/* For __be64 type */
+#include <linux/types.h>
+#include <arpa/inet.h>
+
+enum {
+	MLX5_RCV_DBR	= 0,
+	MLX5_SND_DBR	= 1,
+};
+
+/*
+ * Direct verbs device-specific attributes
+ */
+struct mlx5dv_context {
+	uint8_t		version;
+	uint64_t	flags;
+	uint64_t	comp_mask;
+};
+
+enum mlx5dv_context_flags {
+	/*
+	 * This flag indicates if CQE version 0 or 1 is needed.
+	 */
+	MLX5DV_CONTEXT_FLAGS_CQE_V1 = (1 << 0),
+};
+
+/*
+ * Most device capabilities are exported by ibv_query_device(...),
+ * but there is HW device-specific information which is important
+ * for data-path, but isn't provided.
+ *
+ * Return 0 on success.
+ */
+int mlx5dv_query_device(struct ibv_context *ctx_in,
+			struct mlx5dv_context *attrs_out);
+
+struct mlx5dv_qp {
+	uint32_t		*dbrec;
+	struct {
+		void		*buf;
+		uint32_t	wqe_cnt;
+		uint32_t	stride;
+	} sq;
+	struct {
+		void		*buf;
+		uint32_t	wqe_cnt;
+		uint32_t	stride;
+	} rq;
+	struct {
+		void		*reg;
+		uint32_t	size;
+	} bf;
+	uint64_t		comp_mask;
+};
+
+struct mlx5dv_cq {
+	void			*buf;
+	uint32_t		*dbrec;
+	uint32_t		cqe_cnt;
+	uint32_t		cqe_size;
+	void			*uar;
+	uint32_t		cqn;
+	uint64_t		comp_mask;
+};
+
+struct mlx5dv_srq {
+	void			*buf;
+	uint32_t		*dbrec;
+	uint32_t		stride;
+	uint32_t		head;
+	uint32_t		tail;
+	uint64_t		comp_mask;
+};
+
+struct mlx5dv_rwq {
+	void		*buf;
+	uint32_t	*dbrec;
+	uint32_t	wqe_cnt;
+	uint32_t	stride;
+	uint64_t	comp_mask;
+};
+
+struct mlx5dv_obj {
+	struct {
+		struct ibv_qp		*in;
+		struct mlx5dv_qp	*out;
+	} qp;
+	struct {
+		struct ibv_cq		*in;
+		struct mlx5dv_cq	*out;
+	} cq;
+	struct {
+		struct ibv_srq		*in;
+		struct mlx5dv_srq	*out;
+	} srq;
+	struct {
+		struct ibv_wq		*in;
+		struct mlx5dv_rwq	*out;
+	} rwq;
+};
+
+enum mlx5dv_obj_type {
+	MLX5DV_OBJ_QP	= 1 << 0,
+	MLX5DV_OBJ_CQ	= 1 << 1,
+	MLX5DV_OBJ_SRQ	= 1 << 2,
+	MLX5DV_OBJ_RWQ	= 1 << 3,
+};
+
+/*
+ * This function will initialize mlx5dv_xxx structs based on supplied type.
+ * The information for initialization is taken from ibv_xx structs supplied
+ * as part of input.
+ *
+ * Request information of CQ marks its owned by DV for all consumer index
+ * related actions.
+ *
+ * The initialization type can be combination of several types together.
+ *
+ * Return: 0 in case of success.
+ */
+int mlx5dv_init_obj(struct mlx5dv_obj *obj, uint64_t obj_type);
+
+enum {
+	MLX5_OPCODE_NOP			= 0x00,
+	MLX5_OPCODE_SEND_INVAL		= 0x01,
+	MLX5_OPCODE_RDMA_WRITE		= 0x08,
+	MLX5_OPCODE_RDMA_WRITE_IMM	= 0x09,
+	MLX5_OPCODE_SEND		= 0x0a,
+	MLX5_OPCODE_SEND_IMM		= 0x0b,
+	MLX5_OPCODE_TSO			= 0x0e,
+	MLX5_OPCODE_RDMA_READ		= 0x10,
+	MLX5_OPCODE_ATOMIC_CS		= 0x11,
+	MLX5_OPCODE_ATOMIC_FA		= 0x12,
+	MLX5_OPCODE_ATOMIC_MASKED_CS	= 0x14,
+	MLX5_OPCODE_ATOMIC_MASKED_FA	= 0x15,
+	MLX5_OPCODE_FMR			= 0x19,
+	MLX5_OPCODE_LOCAL_INVAL		= 0x1b,
+	MLX5_OPCODE_CONFIG_CMD		= 0x1f,
+	MLX5_OPCODE_UMR			= 0x25,
+};
+
+/*
+ * CQE related part
+ */
+
+enum {
+	MLX5_INLINE_SCATTER_32	= 0x4,
+	MLX5_INLINE_SCATTER_64	= 0x8,
+};
+
+enum {
+	MLX5_CQE_SYNDROME_LOCAL_LENGTH_ERR		= 0x01,
+	MLX5_CQE_SYNDROME_LOCAL_QP_OP_ERR		= 0x02,
+	MLX5_CQE_SYNDROME_LOCAL_PROT_ERR		= 0x04,
+	MLX5_CQE_SYNDROME_WR_FLUSH_ERR			= 0x05,
+	MLX5_CQE_SYNDROME_MW_BIND_ERR			= 0x06,
+	MLX5_CQE_SYNDROME_BAD_RESP_ERR			= 0x10,
+	MLX5_CQE_SYNDROME_LOCAL_ACCESS_ERR		= 0x11,
+	MLX5_CQE_SYNDROME_REMOTE_INVAL_REQ_ERR		= 0x12,
+	MLX5_CQE_SYNDROME_REMOTE_ACCESS_ERR		= 0x13,
+	MLX5_CQE_SYNDROME_REMOTE_OP_ERR			= 0x14,
+	MLX5_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR	= 0x15,
+	MLX5_CQE_SYNDROME_RNR_RETRY_EXC_ERR		= 0x16,
+	MLX5_CQE_SYNDROME_REMOTE_ABORTED_ERR		= 0x22,
+};
+
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
+enum {
+	MLX5_CQE_OWNER_MASK	= 1,
+	MLX5_CQE_REQ		= 0,
+	MLX5_CQE_RESP_WR_IMM	= 1,
+	MLX5_CQE_RESP_SEND	= 2,
+	MLX5_CQE_RESP_SEND_IMM	= 3,
+	MLX5_CQE_RESP_SEND_INV	= 4,
+	MLX5_CQE_RESIZE_CQ	= 5,
+	MLX5_CQE_REQ_ERR	= 13,
+	MLX5_CQE_RESP_ERR	= 14,
+	MLX5_CQE_INVALID	= 15,
+};
+
+enum {
+	MLX5_CQ_DOORBELL			= 0x20
+};
+
+enum {
+	MLX5_CQ_DB_REQ_NOT_SOL	= 1 << 24,
+	MLX5_CQ_DB_REQ_NOT	= 0 << 24,
+};
+
+struct mlx5_err_cqe {
+	uint8_t		rsvd0[32];
+	uint32_t	srqn;
+	uint8_t		rsvd1[18];
+	uint8_t		vendor_err_synd;
+	uint8_t		syndrome;
+	uint32_t	s_wqe_opcode_qpn;
+	uint16_t	wqe_counter;
+	uint8_t		signature;
+	uint8_t		op_own;
+};
+
+struct mlx5_cqe64 {
+	uint8_t		rsvd0[17];
+	uint8_t		ml_path;
+	uint8_t		rsvd20[4];
+	uint16_t	slid;
+	uint32_t	flags_rqpn;
+	uint8_t		hds_ip_ext;
+	uint8_t		l4_hdr_type_etc;
+	uint16_t	vlan_info;
+	uint32_t	srqn_uidx;
+	uint32_t	imm_inval_pkey;
+	uint8_t		rsvd40[4];
+	uint32_t	byte_cnt;
+	__be64		timestamp;
+	uint32_t	sop_drop_qpn;
+	uint16_t	wqe_counter;
+	uint8_t		signature;
+	uint8_t		op_own;
+};
+
+/*
+ * WQE related part
+ */
+enum {
+	MLX5_INVALID_LKEY	= 0x100,
+};
+
+enum {
+	MLX5_EXTENDED_UD_AV	= 0x80000000,
+};
+
+enum {
+	MLX5_WQE_CTRL_CQ_UPDATE	= 2 << 2,
+	MLX5_WQE_CTRL_SOLICITED	= 1 << 1,
+	MLX5_WQE_CTRL_FENCE	= 4 << 5,
+	MLX5_WQE_CTRL_INITIATOR_SMALL_FENCE = 1 << 5,
+};
+
+enum {
+	MLX5_SEND_WQE_BB	= 64,
+	MLX5_SEND_WQE_SHIFT	= 6,
+};
+
+enum {
+	MLX5_INLINE_SEG	= 0x80000000,
+};
+
+enum {
+	MLX5_ETH_WQE_L3_CSUM = (1 << 6),
+	MLX5_ETH_WQE_L4_CSUM = (1 << 7),
+};
+
+struct mlx5_wqe_srq_next_seg {
+	uint8_t			rsvd0[2];
+	uint16_t		next_wqe_index;
+	uint8_t			signature;
+	uint8_t			rsvd1[11];
+};
+
+struct mlx5_wqe_data_seg {
+	uint32_t		byte_count;
+	uint32_t		lkey;
+	uint64_t		addr;
+};
+
+struct mlx5_wqe_ctrl_seg {
+	uint32_t	opmod_idx_opcode;
+	uint32_t	qpn_ds;
+	uint8_t		signature;
+	uint8_t		rsvd[2];
+	uint8_t		fm_ce_se;
+	uint32_t	imm;
+};
+
+struct mlx5_wqe_av {
+	union {
+		struct {
+			uint32_t	qkey;
+			uint32_t	reserved;
+		} qkey;
+		uint64_t	dc_key;
+	} key;
+	uint32_t	dqp_dct;
+	uint8_t		stat_rate_sl;
+	uint8_t		fl_mlid;
+	uint16_t	rlid;
+	uint8_t		reserved0[4];
+	uint8_t		rmac[6];
+	uint8_t		tclass;
+	uint8_t		hop_limit;
+	uint32_t	grh_gid_fl;
+	uint8_t		rgid[16];
+};
+
+struct mlx5_wqe_datagram_seg {
+	struct mlx5_wqe_av	av;
+};
+
+struct mlx5_wqe_raddr_seg {
+	uint64_t	raddr;
+	uint32_t	rkey;
+	uint32_t	reserved;
+};
+
+struct mlx5_wqe_atomic_seg {
+	uint64_t	swap_add;
+	uint64_t	compare;
+};
+
+struct mlx5_wqe_inl_data_seg {
+	uint32_t	byte_count;
+};
+
+struct mlx5_wqe_eth_seg {
+	uint32_t	rsvd0;
+	uint8_t		cs_flags;
+	uint8_t		rsvd1;
+	uint16_t	mss;
+	uint32_t	rsvd2;
+	uint16_t	inline_hdr_sz;
+	uint8_t		inline_hdr_start[2];
+	uint8_t		inline_hdr[16];
+};
+
+#endif /* _MLX5DV_H_ */
diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
index e82b1a0..177b9ae 100644
--- a/providers/mlx5/qp.c
+++ b/providers/mlx5/qp.c
@@ -212,7 +212,7 @@ static void set_datagram_seg(struct mlx5_wqe_datagram_seg *dseg,
 			     struct ibv_send_wr *wr)
 {
 	memcpy(&dseg->av, &to_mah(wr->wr.ud.ah)->av, sizeof dseg->av);
-	dseg->av.dqp_dct = htonl(wr->wr.ud.remote_qpn | MLX5_EXTENED_UD_AV);
+	dseg->av.dqp_dct = htonl(wr->wr.ud.remote_qpn | MLX5_EXTENDED_UD_AV);
 	dseg->av.key.qkey.qkey = htonl(wr->wr.ud.remote_qkey);
 }
 
diff --git a/providers/mlx5/wqe.h b/providers/mlx5/wqe.h
index f097b77..13597bc 100644
--- a/providers/mlx5/wqe.h
+++ b/providers/mlx5/wqe.h
@@ -33,34 +33,6 @@
 #ifndef WQE_H
 #define WQE_H
 
-enum {
-	MLX5_WQE_CTRL_CQ_UPDATE	= 2 << 2,
-	MLX5_WQE_CTRL_SOLICITED	= 1 << 1,
-	MLX5_WQE_CTRL_FENCE	= 4 << 5,
-	MLX5_WQE_CTRL_INITIATOR_SMALL_FENCE = 1 << 5,
-};
-
-enum {
-	MLX5_INVALID_LKEY	= 0x100,
-};
-
-enum {
-	MLX5_EXTENED_UD_AV	= 0x80000000,
-};
-
-struct mlx5_wqe_srq_next_seg {
-	uint8_t			rsvd0[2];
-	uint16_t		next_wqe_index;
-	uint8_t			signature;
-	uint8_t			rsvd1[11];
-};
-
-struct mlx5_wqe_data_seg {
-	uint32_t		byte_count;
-	uint32_t		lkey;
-	uint64_t		addr;
-};
-
 struct mlx5_sg_copy_ptr {
 	int	index;
 	int	offset;
@@ -76,36 +48,6 @@ struct mlx5_eqe_qp_srq {
 	uint32_t	qp_srq_n;
 };
 
-enum {
-	MLX5_ETH_L2_INLINE_HEADER_SIZE	= 18,
-	MLX5_ETH_L2_MIN_HEADER_SIZE	= 14,
-};
-
-enum {
-	MLX5_ETH_WQE_L3_CSUM = (1 << 6),
-	MLX5_ETH_WQE_L4_CSUM = (1 << 7),
-};
-
-struct mlx5_wqe_eth_seg {
-	uint32_t	rsvd0;
-	uint8_t		cs_flags;
-	uint8_t		rsvd1;
-	uint16_t	mss;
-	uint32_t	rsvd2;
-	uint16_t	inline_hdr_sz;
-	uint8_t		inline_hdr_start[2];
-	uint8_t		inline_hdr[16];
-};
-
-struct mlx5_wqe_ctrl_seg {
-	uint32_t	opmod_idx_opcode;
-	uint32_t	qpn_ds;
-	uint8_t		signature;
-	uint8_t		rsvd[2];
-	uint8_t		fm_ce_se;
-	uint32_t	imm;
-};
-
 struct mlx5_wqe_xrc_seg {
 	uint32_t	xrc_srqn;
 	uint8_t		rsvd[12];
@@ -118,42 +60,9 @@ struct mlx5_wqe_masked_atomic_seg {
 	uint64_t	compare_mask;
 };
 
-struct mlx5_wqe_av {
-	union {
-		struct {
-			uint32_t	qkey;
-			uint32_t	reserved;
-		} qkey;
-		uint64_t	dc_key;
-	} key;
-	uint32_t	dqp_dct;
-	uint8_t		stat_rate_sl;
-	uint8_t		fl_mlid;
-	uint16_t	rlid;
-	uint8_t		reserved0[10];
-	uint8_t		tclass;
-	uint8_t		hop_limit;
-	uint32_t	grh_gid_fl;
-	uint8_t		rgid[16];
-};
-
-struct mlx5_wqe_datagram_seg {
-	struct mlx5_wqe_av	av;
-};
-
-struct mlx5_wqe_raddr_seg {
-	uint64_t	raddr;
-	uint32_t	rkey;
-	uint32_t	reserved;
-};
-
-struct mlx5_wqe_atomic_seg {
-	uint64_t	swap_add;
-	uint64_t	compare;
-};
-
-struct mlx5_wqe_inl_data_seg {
-	uint32_t	byte_count;
+enum {
+	MLX5_ETH_L2_INLINE_HEADER_SIZE	= 18,
+	MLX5_ETH_L2_MIN_HEADER_SIZE	= 14,
 };
 
 enum {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
