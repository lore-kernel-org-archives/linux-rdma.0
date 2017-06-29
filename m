From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/7] mlx4: Add mlx4 direct verbs
Date: Thu, 29 Jun 2017 14:47:02 +0300
Message-ID: <1498736828-17875-2-git-send-email-yishaih@mellanox.com>
References: <1498736828-17875-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498736828-17875-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Direct verbs feature provides fast data path execution
by implementing verbs directly over hardware specification.

It consists from the two parts:
 * Exported functions to translate internal mlx4 structures to be
   accessible by user applications.
 * Inline functions, enums and defines to simplify programmer's life.

This patch adds one header file (mlx4dv.h) with general, CQE and WQE data.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/cq.c     |  47 +------
 providers/mlx4/mlx4.c   |  76 +++++++++++
 providers/mlx4/mlx4.h   |  60 +--------
 providers/mlx4/mlx4dv.h | 338 ++++++++++++++++++++++++++++++++++++++++++++++++
 providers/mlx4/qp.c     |   1 -
 providers/mlx4/srq.c    |   1 -
 providers/mlx4/verbs.c  |   1 -
 providers/mlx4/wqe.h    | 149 ---------------------
 8 files changed, 420 insertions(+), 253 deletions(-)
 create mode 100644 providers/mlx4/mlx4dv.h
 delete mode 100644 providers/mlx4/wqe.h

diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index 8ebc2ae..068e0d2 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -46,55 +46,11 @@
 #include "mlx4.h"
 
 enum {
-	MLX4_CQ_DOORBELL			= 0x20
-};
-
-enum {
 	CQ_OK					=  0,
 	CQ_EMPTY				= -1,
 	CQ_POLL_ERR				= -2
 };
 
-#define MLX4_CQ_DB_REQ_NOT_SOL			(1 << 24)
-#define MLX4_CQ_DB_REQ_NOT			(2 << 24)
-
-enum {
-	MLX4_CQE_VLAN_PRESENT_MASK		= 1 << 29,
-	MLX4_CQE_QPN_MASK			= 0xffffff,
-};
-
-enum {
-	MLX4_CQE_OWNER_MASK			= 0x80,
-	MLX4_CQE_IS_SEND_MASK			= 0x40,
-	MLX4_CQE_OPCODE_MASK			= 0x1f
-};
-
-enum {
-	MLX4_CQE_SYNDROME_LOCAL_LENGTH_ERR		= 0x01,
-	MLX4_CQE_SYNDROME_LOCAL_QP_OP_ERR		= 0x02,
-	MLX4_CQE_SYNDROME_LOCAL_PROT_ERR		= 0x04,
-	MLX4_CQE_SYNDROME_WR_FLUSH_ERR			= 0x05,
-	MLX4_CQE_SYNDROME_MW_BIND_ERR			= 0x06,
-	MLX4_CQE_SYNDROME_BAD_RESP_ERR			= 0x10,
-	MLX4_CQE_SYNDROME_LOCAL_ACCESS_ERR		= 0x11,
-	MLX4_CQE_SYNDROME_REMOTE_INVAL_REQ_ERR		= 0x12,
-	MLX4_CQE_SYNDROME_REMOTE_ACCESS_ERR		= 0x13,
-	MLX4_CQE_SYNDROME_REMOTE_OP_ERR			= 0x14,
-	MLX4_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR	= 0x15,
-	MLX4_CQE_SYNDROME_RNR_RETRY_EXC_ERR		= 0x16,
-	MLX4_CQE_SYNDROME_REMOTE_ABORTED_ERR		= 0x22,
-};
-
-struct mlx4_err_cqe {
-	uint32_t	vlan_my_qpn;
-	uint32_t	reserved1[5];
-	uint16_t	wqe_index;
-	uint8_t		vendor_err;
-	uint8_t		syndrome;
-	uint8_t		reserved2[3];
-	uint8_t		owner_sr_opcode;
-};
-
 static struct mlx4_cqe *get_cqe(struct mlx4_cq *cq, int entry)
 {
 	return cq->buf.buf + entry * cq->cqe_size;
@@ -722,6 +678,9 @@ void __mlx4_cq_clean(struct mlx4_cq *cq, uint32_t qpn, struct mlx4_srq *srq)
 	int nfreed = 0;
 	int cqe_inc = cq->cqe_size == 64 ? 1 : 0;
 
+	if (!cq || cq->flags & MLX4_CQ_FLAGS_DV_OWNED)
+		return;
+
 	/*
 	 * First we need to find the current producer index, so we
 	 * know where to start cleaning from.  It doesn't matter if HW
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index b798b37..db3f903 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -324,3 +324,79 @@ static __attribute__((constructor)) void mlx4_register_driver(void)
 {
 	verbs_register_driver("mlx4", mlx4_driver_init);
 }
+
+static int mlx4dv_get_qp(struct ibv_qp *qp_in,
+			 struct mlx4dv_qp *qp_out)
+{
+	struct mlx4_qp *mqp = to_mqp(qp_in);
+	struct mlx4_context *ctx = to_mctx(qp_in->context);
+
+	qp_out->comp_mask = 0;
+
+	qp_out->buf.buf = mqp->buf.buf;
+	qp_out->buf.length = mqp->buf.length;
+
+	qp_out->rdb = mqp->db;
+	qp_out->sdb = (uint32_t *) (ctx->uar + MLX4_SEND_DOORBELL);
+	qp_out->doorbell_qpn = mqp->doorbell_qpn;
+
+	qp_out->sq.wqe_cnt = mqp->sq.wqe_cnt;
+	qp_out->sq.wqe_shift = mqp->sq.wqe_shift;
+	qp_out->sq.offset = mqp->sq.offset;
+
+	qp_out->rq.wqe_cnt = mqp->rq.wqe_cnt;
+	qp_out->rq.wqe_shift = mqp->rq.wqe_shift;
+	qp_out->rq.offset = mqp->rq.offset;
+
+	return 0;
+}
+
+static int mlx4dv_get_cq(struct ibv_cq *cq_in,
+			 struct mlx4dv_cq *cq_out)
+{
+	struct mlx4_cq *mcq = to_mcq(cq_in);
+
+	cq_out->comp_mask = 0;
+	cq_out->buf.buf = mcq->buf.buf;
+	cq_out->buf.length = mcq->buf.length;
+	cq_out->cqn = mcq->cqn;
+	cq_out->set_ci_db = mcq->set_ci_db;
+	cq_out->arm_db = mcq->arm_db;
+	cq_out->arm_sn = mcq->arm_sn;
+	cq_out->cqe_size = mcq->cqe_size;
+	cq_out->cqe_cnt = mcq->ibv_cq.cqe + 1;
+
+	mcq->flags |= MLX4_CQ_FLAGS_DV_OWNED;
+
+	return 0;
+}
+
+static int mlx4dv_get_srq(struct ibv_srq *srq_in,
+			  struct mlx4dv_srq *srq_out)
+{
+	struct mlx4_srq *msrq = to_msrq(srq_in);
+
+	srq_out->comp_mask = 0;
+	srq_out->buf.buf = msrq->buf.buf;
+	srq_out->buf.length = msrq->buf.length;
+	srq_out->wqe_shift = msrq->wqe_shift;
+	srq_out->head = msrq->head;
+	srq_out->tail = msrq->tail;
+	srq_out->db = msrq->db;
+
+	return 0;
+}
+
+int mlx4dv_init_obj(struct mlx4dv_obj *obj, uint64_t obj_type)
+{
+	int ret = 0;
+
+	if (obj_type & MLX4DV_OBJ_QP)
+		ret = mlx4dv_get_qp(obj->qp.in, obj->qp.out);
+	if (!ret && (obj_type & MLX4DV_OBJ_CQ))
+		ret = mlx4dv_get_cq(obj->cq.in, obj->cq.out);
+	if (!ret && (obj_type & MLX4DV_OBJ_SRQ))
+		ret = mlx4dv_get_srq(obj->srq.in, obj->srq.out);
+
+	return ret;
+}
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index b4f6e86..8f0d6f2 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -42,6 +42,8 @@
 #include <util/udma_barrier.h>
 #include <infiniband/verbs.h>
 
+#include "mlx4dv.h"
+
 #define MLX4_PORTS_NUM 2
 
 #include <valgrind/memcheck.h>
@@ -88,33 +90,6 @@ enum mlx4_db_type {
 	MLX4_NUM_DB_TYPE
 };
 
-enum {
-	MLX4_OPCODE_NOP			= 0x00,
-	MLX4_OPCODE_SEND_INVAL		= 0x01,
-	MLX4_OPCODE_RDMA_WRITE		= 0x08,
-	MLX4_OPCODE_RDMA_WRITE_IMM	= 0x09,
-	MLX4_OPCODE_SEND		= 0x0a,
-	MLX4_OPCODE_SEND_IMM		= 0x0b,
-	MLX4_OPCODE_LSO			= 0x0e,
-	MLX4_OPCODE_RDMA_READ		= 0x10,
-	MLX4_OPCODE_ATOMIC_CS		= 0x11,
-	MLX4_OPCODE_ATOMIC_FA		= 0x12,
-	MLX4_OPCODE_MASKED_ATOMIC_CS	= 0x14,
-	MLX4_OPCODE_MASKED_ATOMIC_FA	= 0x15,
-	MLX4_OPCODE_BIND_MW		= 0x18,
-	MLX4_OPCODE_FMR			= 0x19,
-	MLX4_OPCODE_LOCAL_INVAL		= 0x1b,
-	MLX4_OPCODE_CONFIG_CMD		= 0x1f,
-
-	MLX4_RECV_OPCODE_RDMA_WRITE_IMM	= 0x00,
-	MLX4_RECV_OPCODE_SEND		= 0x01,
-	MLX4_RECV_OPCODE_SEND_IMM	= 0x02,
-	MLX4_RECV_OPCODE_SEND_INVAL	= 0x03,
-
-	MLX4_CQE_OPCODE_ERROR		= 0x1e,
-	MLX4_CQE_OPCODE_RESIZE		= 0x16,
-};
-
 struct mlx4_device {
 	struct verbs_device		verbs_dev;
 	int				page_size;
@@ -174,6 +149,7 @@ enum {
 	MLX4_CQ_FLAGS_RX_CSUM_VALID = 1 << 0,
 	MLX4_CQ_FLAGS_EXTENDED = 1 << 1,
 	MLX4_CQ_FLAGS_SINGLE_THREADED = 1 << 2,
+	MLX4_CQ_FLAGS_DV_OWNED = 1 << 3,
 };
 
 struct mlx4_cq {
@@ -265,36 +241,6 @@ enum {
 	MLX4_RX_CSUM_VALID		= (1 <<  16),
 };
 
-enum mlx4_cqe_status {
-	MLX4_CQE_STATUS_TCP_UDP_CSUM_OK	= (1 <<  2),
-	MLX4_CQE_STATUS_IPV4_PKT	= (1 << 22),
-	MLX4_CQE_STATUS_IP_HDR_CSUM_OK	= (1 << 28),
-	MLX4_CQE_STATUS_IPV4_CSUM_OK	= MLX4_CQE_STATUS_IPV4_PKT |
-					MLX4_CQE_STATUS_IP_HDR_CSUM_OK |
-					MLX4_CQE_STATUS_TCP_UDP_CSUM_OK
-};
-
-struct mlx4_cqe {
-	uint32_t	vlan_my_qpn;
-	uint32_t	immed_rss_invalid;
-	uint32_t	g_mlpath_rqpn;
-	union {
-		struct {
-			uint16_t	sl_vid;
-			uint16_t	rlid;
-		};
-		uint32_t ts_47_16;
-	};
-	uint32_t	status;
-	uint32_t	byte_cnt;
-	uint16_t	wqe_index;
-	uint16_t	checksum;
-	uint8_t		reserved3;
-	uint8_t		ts_15_8;
-	uint8_t		ts_7_0;
-	uint8_t		owner_sr_opcode;
-};
-
 static inline unsigned long align(unsigned long val, unsigned long align)
 {
 	return (val + align - 1) & ~(align - 1);
diff --git a/providers/mlx4/mlx4dv.h b/providers/mlx4/mlx4dv.h
new file mode 100644
index 0000000..86b4e13
--- /dev/null
+++ b/providers/mlx4/mlx4dv.h
@@ -0,0 +1,338 @@
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
+#ifndef _MLX4DV_H_
+#define _MLX4DV_H_
+
+#include <linux/types.h>
+#include <endian.h>
+#include <infiniband/verbs.h>
+
+enum {
+	MLX4_OPCODE_NOP			= 0x00,
+	MLX4_OPCODE_SEND_INVAL		= 0x01,
+	MLX4_OPCODE_RDMA_WRITE		= 0x08,
+	MLX4_OPCODE_RDMA_WRITE_IMM	= 0x09,
+	MLX4_OPCODE_SEND		= 0x0a,
+	MLX4_OPCODE_SEND_IMM		= 0x0b,
+	MLX4_OPCODE_LSO			= 0x0e,
+	MLX4_OPCODE_RDMA_READ		= 0x10,
+	MLX4_OPCODE_ATOMIC_CS		= 0x11,
+	MLX4_OPCODE_ATOMIC_FA		= 0x12,
+	MLX4_OPCODE_MASKED_ATOMIC_CS	= 0x14,
+	MLX4_OPCODE_MASKED_ATOMIC_FA	= 0x15,
+	MLX4_OPCODE_BIND_MW		= 0x18,
+	MLX4_OPCODE_FMR			= 0x19,
+	MLX4_OPCODE_LOCAL_INVAL		= 0x1b,
+	MLX4_OPCODE_CONFIG_CMD		= 0x1f,
+
+	MLX4_RECV_OPCODE_RDMA_WRITE_IMM	= 0x00,
+	MLX4_RECV_OPCODE_SEND		= 0x01,
+	MLX4_RECV_OPCODE_SEND_IMM	= 0x02,
+	MLX4_RECV_OPCODE_SEND_INVAL	= 0x03,
+
+	MLX4_CQE_OPCODE_ERROR		= 0x1e,
+	MLX4_CQE_OPCODE_RESIZE		= 0x16,
+};
+
+enum {
+	MLX4_CQ_DOORBELL			= 0x20
+};
+
+#define MLX4_CQ_DB_REQ_NOT_SOL			(1 << 24)
+#define MLX4_CQ_DB_REQ_NOT			(2 << 24)
+
+enum {
+	MLX4_CQE_VLAN_PRESENT_MASK		= 1 << 29,
+	MLX4_CQE_QPN_MASK			= 0xffffff,
+};
+
+enum {
+	MLX4_CQE_OWNER_MASK			= 0x80,
+	MLX4_CQE_IS_SEND_MASK			= 0x40,
+	MLX4_CQE_OPCODE_MASK			= 0x1f
+};
+
+enum {
+	MLX4_CQE_SYNDROME_LOCAL_LENGTH_ERR		= 0x01,
+	MLX4_CQE_SYNDROME_LOCAL_QP_OP_ERR		= 0x02,
+	MLX4_CQE_SYNDROME_LOCAL_PROT_ERR		= 0x04,
+	MLX4_CQE_SYNDROME_WR_FLUSH_ERR			= 0x05,
+	MLX4_CQE_SYNDROME_MW_BIND_ERR			= 0x06,
+	MLX4_CQE_SYNDROME_BAD_RESP_ERR			= 0x10,
+	MLX4_CQE_SYNDROME_LOCAL_ACCESS_ERR		= 0x11,
+	MLX4_CQE_SYNDROME_REMOTE_INVAL_REQ_ERR		= 0x12,
+	MLX4_CQE_SYNDROME_REMOTE_ACCESS_ERR		= 0x13,
+	MLX4_CQE_SYNDROME_REMOTE_OP_ERR			= 0x14,
+	MLX4_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR	= 0x15,
+	MLX4_CQE_SYNDROME_RNR_RETRY_EXC_ERR		= 0x16,
+	MLX4_CQE_SYNDROME_REMOTE_ABORTED_ERR		= 0x22,
+};
+
+struct mlx4_err_cqe {
+	uint32_t	vlan_my_qpn;
+	uint32_t	reserved1[5];
+	uint16_t	wqe_index;
+	uint8_t		vendor_err;
+	uint8_t		syndrome;
+	uint8_t		reserved2[3];
+	uint8_t		owner_sr_opcode;
+};
+
+enum mlx4_cqe_status {
+	MLX4_CQE_STATUS_TCP_UDP_CSUM_OK	= (1 <<  2),
+	MLX4_CQE_STATUS_IPV4_PKT	= (1 << 22),
+	MLX4_CQE_STATUS_IP_HDR_CSUM_OK	= (1 << 28),
+	MLX4_CQE_STATUS_IPV4_CSUM_OK	= MLX4_CQE_STATUS_IPV4_PKT |
+					MLX4_CQE_STATUS_IP_HDR_CSUM_OK |
+					MLX4_CQE_STATUS_TCP_UDP_CSUM_OK
+};
+
+struct mlx4_cqe {
+	uint32_t	vlan_my_qpn;
+	uint32_t	immed_rss_invalid;
+	uint32_t	g_mlpath_rqpn;
+	union {
+		struct {
+			uint16_t	sl_vid;
+			uint16_t	rlid;
+		};
+		uint32_t ts_47_16;
+	};
+	uint32_t	status;
+	uint32_t	byte_cnt;
+	uint16_t	wqe_index;
+	uint16_t	checksum;
+	uint8_t		reserved3;
+	uint8_t		ts_15_8;
+	uint8_t		ts_7_0;
+	uint8_t		owner_sr_opcode;
+};
+
+struct mlx4dv_qp {
+	uint32_t		*rdb;
+	uint32_t		*sdb;
+	uint32_t		doorbell_qpn;
+	struct {
+		uint32_t	wqe_cnt;
+		int		wqe_shift;
+		int		offset;
+	} sq;
+	struct {
+		uint32_t	wqe_cnt;
+		int		wqe_shift;
+		int		offset;
+	} rq;
+	struct {
+		void			*buf;
+		size_t			length;
+	} buf;
+	uint64_t		comp_mask;
+};
+
+struct mlx4dv_cq {
+	struct {
+		void			*buf;
+		size_t			length;
+	} buf;
+	uint32_t			cqe_cnt;
+	uint32_t			cqn;
+	uint32_t		       *set_ci_db;
+	uint32_t		       *arm_db;
+	int				arm_sn;
+	int				cqe_size;
+	uint64_t			comp_mask;
+};
+struct mlx4dv_srq {
+	struct {
+		void			*buf;
+		size_t			length;
+	} buf;
+	int				wqe_shift;
+	int				head;
+	int				tail;
+	uint32_t		       *db;
+	uint64_t			comp_mask;
+};
+
+struct mlx4dv_obj {
+	struct {
+		struct ibv_qp		*in;
+		struct mlx4dv_qp	*out;
+	} qp;
+	struct {
+		struct ibv_cq		*in;
+		struct mlx4dv_cq	*out;
+	} cq;
+	struct {
+		struct ibv_srq		*in;
+		struct mlx4dv_srq	*out;
+	} srq;
+};
+
+enum mlx4dv_obj_type {
+	MLX4DV_OBJ_QP	= 1 << 0,
+	MLX4DV_OBJ_CQ	= 1 << 1,
+	MLX4DV_OBJ_SRQ	= 1 << 2,
+};
+
+/*
+ * This function will initialize mlx4dv_xxx structs based on supplied type.
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
+int mlx4dv_init_obj(struct mlx4dv_obj *obj, uint64_t obj_type);
+
+/*
+ * WQE related part
+ */
+
+enum {
+	MLX4_SEND_DOORBELL	= 0x14,
+};
+
+enum {
+	MLX4_WQE_CTRL_SOLICIT		= 1 << 1,
+	MLX4_WQE_CTRL_CQ_UPDATE		= 3 << 2,
+	MLX4_WQE_CTRL_IP_HDR_CSUM	= 1 << 4,
+	MLX4_WQE_CTRL_TCP_UDP_CSUM	= 1 << 5,
+	MLX4_WQE_CTRL_FENCE		= 1 << 6,
+	MLX4_WQE_CTRL_STRONG_ORDER	= 1 << 7
+};
+
+enum {
+	MLX4_WQE_BIND_TYPE_2		= (1<<31),
+	MLX4_WQE_BIND_ZERO_BASED	= (1<<30),
+};
+
+enum {
+	MLX4_INLINE_SEG		= 1 << 31,
+	MLX4_INLINE_ALIGN	= 64,
+};
+
+enum {
+	MLX4_INVALID_LKEY	= 0x100,
+};
+
+enum {
+	MLX4_WQE_MW_REMOTE_READ   = 1 << 29,
+	MLX4_WQE_MW_REMOTE_WRITE  = 1 << 30,
+	MLX4_WQE_MW_ATOMIC        = 1 << 31
+};
+
+struct mlx4_wqe_local_inval_seg {
+	uint64_t		reserved1;
+	uint32_t		mem_key;
+	uint32_t		reserved2;
+	uint64_t		reserved3[2];
+};
+
+struct mlx4_wqe_bind_seg {
+	uint32_t		flags1;
+	uint32_t		flags2;
+	uint32_t		new_rkey;
+	uint32_t		lkey;
+	uint64_t		addr;
+	uint64_t		length;
+};
+
+struct mlx4_wqe_ctrl_seg {
+	uint32_t		owner_opcode;
+	union {
+		struct {
+			uint8_t			reserved[3];
+			uint8_t			fence_size;
+		};
+		uint32_t	bf_qpn;
+	};
+	/*
+	 * High 24 bits are SRC remote buffer; low 8 bits are flags:
+	 * [7]   SO (strong ordering)
+	 * [5]   TCP/UDP checksum
+	 * [4]   IP checksum
+	 * [3:2] C (generate completion queue entry)
+	 * [1]   SE (solicited event)
+	 * [0]   FL (force loopback)
+	 */
+	uint32_t		srcrb_flags;
+	/*
+	 * imm is immediate data for send/RDMA write w/ immediate;
+	 * also invalidation key for send with invalidate; input
+	 * modifier for WQEs on CCQs.
+	 */
+	uint32_t		imm;
+};
+
+struct mlx4_wqe_datagram_seg {
+	uint32_t		av[8];
+	uint32_t		dqpn;
+	uint32_t		qkey;
+	uint16_t		vlan;
+	uint8_t			mac[6];
+};
+
+struct mlx4_wqe_data_seg {
+	uint32_t		byte_count;
+	uint32_t		lkey;
+	uint64_t		addr;
+};
+
+struct mlx4_wqe_inline_seg {
+	uint32_t		byte_count;
+};
+
+struct mlx4_wqe_srq_next_seg {
+	uint16_t		reserved1;
+	uint16_t		next_wqe_index;
+	uint32_t		reserved2[3];
+};
+
+struct mlx4_wqe_raddr_seg {
+	uint64_t		raddr;
+	uint32_t		rkey;
+	uint32_t		reserved;
+};
+
+struct mlx4_wqe_atomic_seg {
+	uint64_t		swap_add;
+	uint64_t		compare;
+};
+
+#endif /* _MLX4DV_H_ */
+
diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
index e7f10b9..b7e3669 100644
--- a/providers/mlx4/qp.c
+++ b/providers/mlx4/qp.c
@@ -42,7 +42,6 @@
 #include <util/compiler.h>
 
 #include "mlx4.h"
-#include "wqe.h"
 
 static const uint32_t mlx4_ib_opcode[] = {
 	[IBV_WR_SEND]			= MLX4_OPCODE_SEND,
diff --git a/providers/mlx4/srq.c b/providers/mlx4/srq.c
index f30cc2e..9c566cd 100644
--- a/providers/mlx4/srq.c
+++ b/providers/mlx4/srq.c
@@ -37,7 +37,6 @@
 #include <string.h>
 
 #include "mlx4.h"
-#include "wqe.h"
 #include "mlx4-abi.h"
 
 static void *get_wqe(struct mlx4_srq *srq, int n)
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 80efd9a..fce6f22 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -43,7 +43,6 @@
 
 #include "mlx4.h"
 #include "mlx4-abi.h"
-#include "wqe.h"
 
 int mlx4_query_device(struct ibv_context *context, struct ibv_device_attr *attr)
 {
diff --git a/providers/mlx4/wqe.h b/providers/mlx4/wqe.h
deleted file mode 100644
index 6f833d9..0000000
--- a/providers/mlx4/wqe.h
+++ /dev/null
@@ -1,149 +0,0 @@
-/*
- * Copyright (c) 2007 Cisco, Inc.  All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#ifndef WQE_H
-#define WQE_H
-
-#include <stdint.h>
-
-enum {
-	MLX4_SEND_DOORBELL	= 0x14,
-};
-
-enum {
-	MLX4_WQE_CTRL_SOLICIT		= 1 << 1,
-	MLX4_WQE_CTRL_CQ_UPDATE		= 3 << 2,
-	MLX4_WQE_CTRL_IP_HDR_CSUM	= 1 << 4,
-	MLX4_WQE_CTRL_TCP_UDP_CSUM	= 1 << 5,
-	MLX4_WQE_CTRL_FENCE		= 1 << 6,
-	MLX4_WQE_CTRL_STRONG_ORDER	= 1 << 7
-};
-
-enum {
-	MLX4_WQE_BIND_TYPE_2		= (1<<31),
-	MLX4_WQE_BIND_ZERO_BASED	= (1<<30),
-};
-
-enum {
-	MLX4_INLINE_SEG		= 1 << 31,
-	MLX4_INLINE_ALIGN	= 64,
-};
-
-enum {
-	MLX4_INVALID_LKEY	= 0x100,
-};
-
-struct mlx4_wqe_ctrl_seg {
-	uint32_t		owner_opcode;
-	union {
-		struct {
-			uint8_t			reserved[3];
-			uint8_t			fence_size;
-		};
-		uint32_t	bf_qpn;
-	};
-	/*
-	 * High 24 bits are SRC remote buffer; low 8 bits are flags:
-	 * [7]   SO (strong ordering)
-	 * [5]   TCP/UDP checksum
-	 * [4]   IP checksum
-	 * [3:2] C (generate completion queue entry)
-	 * [1]   SE (solicited event)
-	 * [0]   FL (force loopback)
-	 */
-	uint32_t		srcrb_flags;
-	/*
-	 * imm is immediate data for send/RDMA write w/ immediate;
-	 * also invalidation key for send with invalidate; input
-	 * modifier for WQEs on CCQs.
-	 */
-	uint32_t		imm;
-};
-
-struct mlx4_wqe_datagram_seg {
-	uint32_t		av[8];
-	uint32_t		dqpn;
-	uint32_t		qkey;
-	uint16_t		vlan;
-	uint8_t			mac[6];
-};
-
-struct mlx4_wqe_data_seg {
-	uint32_t		byte_count;
-	uint32_t		lkey;
-	uint64_t		addr;
-};
-
-struct mlx4_wqe_inline_seg {
-	uint32_t		byte_count;
-};
-
-struct mlx4_wqe_srq_next_seg {
-	uint16_t		reserved1;
-	uint16_t		next_wqe_index;
-	uint32_t		reserved2[3];
-};
-
-struct mlx4_wqe_local_inval_seg {
-	uint64_t		reserved1;
-	uint32_t		mem_key;
-	uint32_t		reserved2;
-	uint64_t		reserved3[2];
-};
-
-enum {
-	MLX4_WQE_MW_REMOTE_READ   = 1 << 29,
-	MLX4_WQE_MW_REMOTE_WRITE  = 1 << 30,
-	MLX4_WQE_MW_ATOMIC        = 1 << 31
-};
-
-struct mlx4_wqe_raddr_seg {
-	uint64_t		raddr;
-	uint32_t		rkey;
-	uint32_t		reserved;
-};
-
-struct mlx4_wqe_atomic_seg {
-	uint64_t		swap_add;
-	uint64_t		compare;
-};
-
-struct mlx4_wqe_bind_seg {
-	uint32_t		flags1;
-	uint32_t		flags2;
-	uint32_t		new_rkey;
-	uint32_t		lkey;
-	uint64_t		addr;
-	uint64_t		length;
-};
-
-#endif /* WQE_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
