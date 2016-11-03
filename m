From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/8] libpvrdma: Add ABI and main header files
Date: Thu, 3 Nov 2016 16:44:30 -0700
Message-ID: <1478216677-6150-2-git-send-email-aditr@vmware.com>
References: <1478216677-6150-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478216677-6150-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add all the structures and types to interact with kernel driver.

Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 providers/pvrdma/pvrdma-abi.h | 297 ++++++++++++++++++++++++++++++++++++
 providers/pvrdma/pvrdma.h     | 347 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 644 insertions(+)
 create mode 100644 providers/pvrdma/pvrdma-abi.h
 create mode 100644 providers/pvrdma/pvrdma.h

diff --git a/providers/pvrdma/pvrdma-abi.h b/providers/pvrdma/pvrdma-abi.h
new file mode 100644
index 0000000..c7a38c5
--- /dev/null
+++ b/providers/pvrdma/pvrdma-abi.h
@@ -0,0 +1,297 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
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
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __PVRDMA_ABI_H__
+#define __PVRDMA_ABI_H__
+
+#include <infiniband/kern-abi.h>
+
+#define PVRDMA_UVERBS_ABI_VERSION	3
+#define PVRDMA_UAR_HANDLE_MASK		0x00FFFFFF	/* Bottom 24 bits. */
+#define PVRDMA_UAR_QP_OFFSET		0		/* QP doorbell offset. */
+#define PVRDMA_UAR_QP_SEND		BIT(30)		/* Send bit. */
+#define PVRDMA_UAR_QP_RECV		BIT(31)		/* Recv bit. */
+#define PVRDMA_UAR_CQ_OFFSET		4		/* CQ doorbell offset. */
+#define PVRDMA_UAR_CQ_ARM_SOL		BIT(29)		/* Arm solicited bit. */
+#define PVRDMA_UAR_CQ_ARM		BIT(30)		/* Arm bit. */
+#define PVRDMA_UAR_CQ_POLL		BIT(31)		/* Poll bit. */
+
+enum pvrdma_wr_opcode {
+	PVRDMA_WR_RDMA_WRITE,
+	PVRDMA_WR_RDMA_WRITE_WITH_IMM,
+	PVRDMA_WR_SEND,
+	PVRDMA_WR_SEND_WITH_IMM,
+	PVRDMA_WR_RDMA_READ,
+	PVRDMA_WR_ATOMIC_CMP_AND_SWP,
+	PVRDMA_WR_ATOMIC_FETCH_AND_ADD,
+	PVRDMA_WR_LSO,
+	PVRDMA_WR_SEND_WITH_INV,
+	PVRDMA_WR_RDMA_READ_WITH_INV,
+	PVRDMA_WR_LOCAL_INV,
+	PVRDMA_WR_FAST_REG_MR,
+	PVRDMA_WR_MASKED_ATOMIC_CMP_AND_SWP,
+	PVRDMA_WR_MASKED_ATOMIC_FETCH_AND_ADD,
+	PVRDMA_WR_BIND_MW,
+	PVRDMA_WR_REG_SIG_MR,
+};
+
+enum pvrdma_wc_status {
+	PVRDMA_WC_SUCCESS,
+	PVRDMA_WC_LOC_LEN_ERR,
+	PVRDMA_WC_LOC_QP_OP_ERR,
+	PVRDMA_WC_LOC_EEC_OP_ERR,
+	PVRDMA_WC_LOC_PROT_ERR,
+	PVRDMA_WC_WR_FLUSH_ERR,
+	PVRDMA_WC_MW_BIND_ERR,
+	PVRDMA_WC_BAD_RESP_ERR,
+	PVRDMA_WC_LOC_ACCESS_ERR,
+	PVRDMA_WC_REM_INV_REQ_ERR,
+	PVRDMA_WC_REM_ACCESS_ERR,
+	PVRDMA_WC_REM_OP_ERR,
+	PVRDMA_WC_RETRY_EXC_ERR,
+	PVRDMA_WC_RNR_RETRY_EXC_ERR,
+	PVRDMA_WC_LOC_RDD_VIOL_ERR,
+	PVRDMA_WC_REM_INV_RD_REQ_ERR,
+	PVRDMA_WC_REM_ABORT_ERR,
+	PVRDMA_WC_INV_EECN_ERR,
+	PVRDMA_WC_INV_EEC_STATE_ERR,
+	PVRDMA_WC_FATAL_ERR,
+	PVRDMA_WC_RESP_TIMEOUT_ERR,
+	PVRDMA_WC_GENERAL_ERR,
+};
+
+enum pvrdma_wc_opcode {
+	PVRDMA_WC_SEND,
+	PVRDMA_WC_RDMA_WRITE,
+	PVRDMA_WC_RDMA_READ,
+	PVRDMA_WC_COMP_SWAP,
+	PVRDMA_WC_FETCH_ADD,
+	PVRDMA_WC_BIND_MW,
+	PVRDMA_WC_LSO,
+	PVRDMA_WC_LOCAL_INV,
+	PVRDMA_WC_FAST_REG_MR,
+	PVRDMA_WC_MASKED_COMP_SWAP,
+	PVRDMA_WC_MASKED_FETCH_ADD,
+	PVRDMA_WC_RECV = 1 << 7,
+	PVRDMA_WC_RECV_RDMA_WITH_IMM,
+};
+
+enum pvrdma_wc_flags {
+	PVRDMA_WC_GRH			= 1 << 0,
+	PVRDMA_WC_WITH_IMM		= 1 << 1,
+	PVRDMA_WC_WITH_INVALIDATE	= 1 << 2,
+	PVRDMA_WC_IP_CSUM_OK		= 1 << 3,
+	PVRDMA_WC_WITH_SMAC		= 1 << 4,
+	PVRDMA_WC_WITH_VLAN		= 1 << 5,
+	PVRDMA_WC_FLAGS_MAX		= PVRDMA_WC_WITH_VLAN,
+};
+
+struct pvrdma_alloc_ucontext_resp {
+	struct ibv_get_context_resp	ibv_resp;
+	__u32				qp_tab_size;
+	__u32				reserved;
+};
+
+struct pvrdma_alloc_pd_resp {
+	struct ibv_alloc_pd_resp	ibv_resp;
+	__u32				pdn;
+	__u32				reserved;
+};
+
+struct pvrdma_create_cq {
+	struct ibv_create_cq		ibv_cmd;
+	__u64				buf_addr;
+	__u32				buf_size;
+	__u32				reserved;
+};
+
+struct pvrdma_create_cq_resp {
+	struct ibv_create_cq_resp	ibv_resp;
+	__u32				cqn;
+	__u32				reserved;
+};
+
+struct pvrdma_resize_cq {
+	struct ibv_resize_cq		ibv_cmd;
+	__u64				buf_addr;
+	__u32				buf_size;
+	__u32				reserved;
+};
+
+struct pvrdma_create_srq {
+	struct ibv_create_srq		ibv_cmd;
+	__u64				buf_addr;
+};
+
+struct pvrdma_create_srq_resp {
+	struct ibv_create_srq_resp	ibv_resp;
+	__u32				srqn;
+	__u32				reserved;
+};
+
+struct pvrdma_create_qp {
+	struct ibv_create_qp		ibv_cmd;
+	__u64				rbuf_addr;
+	__u64				sbuf_addr;
+	__u32				rbuf_size;
+	__u32				sbuf_size;
+	__u64				qp_addr;
+};
+
+/* PVRDMA masked atomic compare and swap */
+struct pvrdma_ex_cmp_swap {
+	__u64 swap_val;
+	__u64 compare_val;
+	__u64 swap_mask;
+	__u64 compare_mask;
+};
+
+/* PVRDMA masked atomic fetch and add */
+struct pvrdma_ex_fetch_add {
+	__u64 add_val;
+	__u64 field_boundary;
+};
+
+/* PVRDMA address vector. */
+struct pvrdma_av {
+	__u32 port_pd;
+	__u32 sl_tclass_flowlabel;
+	__u8 dgid[16];
+	__u8 src_path_bits;
+	__u8 gid_index;
+	__u8 stat_rate;
+	__u8 hop_limit;
+	__u8 dmac[6];
+	__u8 reserved[6];
+};
+
+/* PVRDMA scatter/gather entry */
+struct pvrdma_sge {
+	__u64   addr;
+	__u32   length;
+	__u32   lkey;
+};
+
+/* PVRDMA receive queue work request */
+struct pvrdma_rq_wqe_hdr {
+	__u64 wr_id;		/* wr id */
+	__u32 num_sge;		/* size of s/g array */
+	__u32 total_len;	/* reserved */
+};
+/* Use pvrdma_sge (ib_sge) for receive queue s/g array elements. */
+
+/* PVRDMA send queue work request */
+struct pvrdma_sq_wqe_hdr {
+	__u64 wr_id;		/* wr id */
+	__u32 num_sge;		/* size of s/g array */
+	__u32 total_len;	/* reserved */
+	__u32 opcode;		/* operation type */
+	__u32 send_flags;	/* wr flags */
+	union {
+		__u32 imm_data;
+		__u32 invalidate_rkey;
+	} ex;
+	__u32 reserved;
+	union {
+		struct {
+			__u64 remote_addr;
+			__u32 rkey;
+			__u8 reserved[4];
+		} rdma;
+		struct {
+			__u64 remote_addr;
+			__u64 compare_add;
+			__u64 swap;
+			__u32 rkey;
+			__u32 reserved;
+		} atomic;
+		struct {
+			__u64 remote_addr;
+			__u32 log_arg_sz;
+			__u32 rkey;
+			union {
+				struct pvrdma_ex_cmp_swap  cmp_swap;
+				struct pvrdma_ex_fetch_add fetch_add;
+			} wr_data;
+		} masked_atomics;
+		struct {
+			__u64 iova_start;
+			__u64 pl_pdir_dma;
+			__u32 page_shift;
+			__u32 page_list_len;
+			__u32 length;
+			__u32 access_flags;
+			__u32 rkey;
+		} fast_reg;
+		struct {
+			__u32 remote_qpn;
+			__u32 remote_qkey;
+			struct pvrdma_av av;
+		} ud;
+	} wr;
+};
+/* Use pvrdma_sge (ib_sge) for send queue s/g array elements. */
+
+/* Completion queue element. */
+struct pvrdma_cqe {
+	__u64 wr_id;
+	__u64 qp;
+	__u32 opcode;
+	__u32 status;
+	__u32 byte_len;
+	__u32 imm_data;
+	__u32 src_qp;
+	__u32 wc_flags;
+	__u32 vendor_err;
+	__u16 pkey_index;
+	__u16 slid;
+	__u8 sl;
+	__u8 dlid_path_bits;
+	__u8 port_num;
+	__u8 smac[6];
+	__u8 reserved2[7]; /* Pad to next power of 2 (64). */
+};
+
+#endif /* __PVRDMA_ABI_H__ */
diff --git a/providers/pvrdma/pvrdma.h b/providers/pvrdma/pvrdma.h
new file mode 100644
index 0000000..d3df07d
--- /dev/null
+++ b/providers/pvrdma/pvrdma.h
@@ -0,0 +1,347 @@
+/*
+ * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of EITHER the GNU General Public License
+ * version 2 as published by the Free Software Foundation or the BSD
+ * 2-Clause License. This program is distributed in the hope that it
+ * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
+ * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License version 2 for more details at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program available in the file COPYING in the main
+ * directory of this source tree.
+ *
+ * The BSD 2-Clause License
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
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __PVRDMA_H__
+#define __PVRDMA_H__
+
+#include <config.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <pthread.h>
+#include <unistd.h>
+#include <netinet/in.h>
+#include <sys/mman.h>
+#include <infiniband/driver.h>
+
+#define BIT(nr) (1UL << (nr))
+
+#include "pvrdma-abi.h"
+#include "pvrdma_ring.h"
+
+#ifndef rmb
+#  define rmb() mb()
+#endif
+
+#ifndef wmb
+#  define wmb() mb()
+#endif
+
+#ifndef likely
+#define likely(x)	__builtin_expect(!!(x), 1)
+#else
+#define likely(x)	(x)
+#endif
+
+#ifndef unlikely
+#define unlikely(x)	__builtin_expect(!!(x), 0)
+#else
+#define unlikely(x)	(x)
+#endif
+
+#ifndef max
+#define max(a, b) \
+	({ typeof (a) _a = (a); \
+	   typeof (b) _b = (b); \
+	   _a > _b ? _a : _b; })
+#endif
+
+#ifndef min
+#define min(a,b) \
+	({ typeof (a) _a = (a); \
+	   typeof (b) _b = (b); \
+	   _a < _b ? _a : _b; })
+#endif
+
+#define PFX "pvrdma: "
+
+enum {
+	PVRDMA_OPCODE_NOP			= 0x00,
+	PVRDMA_OPCODE_SEND_INVAL		= 0x01,
+	PVRDMA_OPCODE_RDMA_WRITE		= 0x08,
+	PVRDMA_OPCODE_RDMA_WRITE_IMM		= 0x09,
+	PVRDMA_OPCODE_SEND			= 0x0a,
+	PVRDMA_OPCODE_SEND_IMM			= 0x0b,
+	PVRDMA_OPCODE_LSO			= 0x0e,
+	PVRDMA_OPCODE_RDMA_READ			= 0x10,
+	PVRDMA_OPCODE_ATOMIC_CS			= 0x11,
+	PVRDMA_OPCODE_ATOMIC_FA			= 0x12,
+	PVRDMA_OPCODE_ATOMIC_MASK_CS		= 0x14,
+	PVRDMA_OPCODE_ATOMIC_MASK_FA		= 0x15,
+	PVRDMA_OPCODE_BIND_MW			= 0x18,
+	PVRDMA_OPCODE_FMR			= 0x19,
+	PVRDMA_OPCODE_LOCAL_INVAL		= 0x1b,
+	PVRDMA_OPCODE_CONFIG_CMD		= 0x1f,
+
+	PVRDMA_RECV_OPCODE_RDMA_WRITE_IMM	= 0x00,
+	PVRDMA_RECV_OPCODE_SEND			= 0x01,
+	PVRDMA_RECV_OPCODE_SEND_IMM		= 0x02,
+	PVRDMA_RECV_OPCODE_SEND_INVAL		= 0x03,
+
+	PVRDMA_CQE_OPCODE_ERROR			= 0x1e,
+	PVRDMA_CQE_OPCODE_RESIZE		= 0x16,
+};
+
+enum {
+	PVRDMA_WQE_CTRL_FENCE			= 1 << 6,
+	PVRDMA_WQE_CTRL_CQ_UPDATE		= 3 << 2,
+	PVRDMA_WQE_CTRL_SOLICIT			= 1 << 1,
+};
+
+struct pvrdma_device {
+	struct ibv_device		ibv_dev;
+	int				page_size;
+	int				abi_version;
+};
+
+struct pvrdma_context {
+	struct ibv_context		ibv_ctx;
+	void				*uar;
+	pthread_spinlock_t		uar_lock;
+	int				max_qp_wr;
+	int				max_sge;
+	int				max_cqe;
+	struct pvrdma_qp		**qp_tbl;
+};
+
+struct pvrdma_buf {
+	void				*buf;
+	size_t				length;
+};
+
+struct pvrdma_pd {
+	struct ibv_pd			ibv_pd;
+	uint32_t			pdn;
+};
+
+struct pvrdma_cq {
+	struct ibv_cq			ibv_cq;
+	struct pvrdma_buf		buf;
+	struct pvrdma_buf		resize_buf;
+	pthread_spinlock_t		lock;
+	struct pvrdma_ring_state	*ring_state;
+	uint32_t			cqe_cnt;
+	uint32_t			offset;
+	uint32_t			cqn;
+};
+
+struct pvrdma_wq {
+	uint64_t			*wrid;
+	pthread_spinlock_t		lock;
+	int				wqe_cnt;
+	int				wqe_size;
+	struct pvrdma_ring		*ring_state;
+	int				max_gs;
+	int				wqe_shift;
+	int				offset;
+};
+
+struct pvrdma_qp {
+	struct ibv_qp			ibv_qp;
+	struct pvrdma_buf		rbuf;
+	struct pvrdma_buf		sbuf;
+	int				max_inline_data;
+	int				buf_size;
+	uint32_t			sq_signal_bits;
+	int				sq_spare_wqes;
+	struct pvrdma_wq		sq;
+	struct pvrdma_wq		rq;
+};
+
+struct pvrdma_ah {
+	struct ibv_ah			ibv_ah;
+	struct pvrdma_av		av;
+};
+
+static inline unsigned long align(unsigned long val, unsigned long align)
+{
+	return (val + align - 1) & ~(align - 1);
+}
+
+static inline int align_next_power2(int size)
+{
+	int  val = 1;
+
+	while (val < size)
+		val <<= 1;
+
+	return val;
+}
+
+#define to_vxxx(xxx, type)						\
+	((struct pvrdma_##type *)					\
+	 ((void *) ib##xxx - offsetof(struct pvrdma_##type, ibv_##xxx)))
+
+static inline struct pvrdma_device *to_vdev(struct ibv_device *ibdev)
+{
+	return to_vxxx(dev, device);
+}
+
+static inline struct pvrdma_context *to_vctx(struct ibv_context *ibctx)
+{
+	return to_vxxx(ctx, context);
+}
+
+static inline struct pvrdma_pd *to_vpd(struct ibv_pd *ibpd)
+{
+	return to_vxxx(pd, pd);
+}
+
+static inline struct pvrdma_cq *to_vcq(struct ibv_cq *ibcq)
+{
+	return to_vxxx(cq, cq);
+}
+
+static inline struct pvrdma_qp *to_vqp(struct ibv_qp *ibqp)
+{
+	return to_vxxx(qp, qp);
+}
+
+static inline struct pvrdma_ah *to_vah(struct ibv_ah *ibah)
+{
+	return to_vxxx(ah, ah);
+}
+
+static inline void pvrdma_write_uar_qp(void *uar, unsigned value)
+{
+	*(uint32_t *)(uar + PVRDMA_UAR_QP_OFFSET) = htole32(value);
+}
+
+static inline void pvrdma_write_uar_cq(void *uar, unsigned value)
+{
+	*(uint32_t *)(uar + PVRDMA_UAR_CQ_OFFSET) = htole32(value);
+}
+
+static inline int ibv_send_flags_to_pvrdma(int flags)
+{
+	return flags;
+}
+
+static inline enum pvrdma_wr_opcode ibv_wr_opcode_to_pvrdma(
+						enum ibv_wr_opcode op)
+{
+	return (enum pvrdma_wr_opcode)op;
+}
+
+static inline enum ibv_wc_status pvrdma_wc_status_to_ibv(
+					enum pvrdma_wc_status status)
+{
+	return (enum ibv_wc_status)status;
+}
+
+static inline enum ibv_wc_opcode pvrdma_wc_opcode_to_ibv(
+					enum pvrdma_wc_opcode op)
+{
+	return (enum ibv_wc_opcode)op;
+}
+
+static inline int pvrdma_wc_flags_to_ibv(int flags)
+{
+	return flags;
+}
+
+int pvrdma_alloc_buf(struct pvrdma_buf *buf, size_t size, int page_size);
+void pvrdma_free_buf(struct pvrdma_buf *buf);
+
+int pvrdma_query_device(struct ibv_context *context,
+			struct ibv_device_attr *attr);
+int pvrdma_query_port(struct ibv_context *context, uint8_t port,
+		      struct ibv_port_attr *attr);
+
+struct ibv_pd *pvrdma_alloc_pd(struct ibv_context *context);
+int pvrdma_free_pd(struct ibv_pd *pd);
+
+struct ibv_mr *pvrdma_reg_mr(struct ibv_pd *pd, void *addr,
+			     size_t length, int access);
+int pvrdma_dereg_mr(struct ibv_mr *mr);
+
+struct ibv_cq *pvrdma_create_cq(struct ibv_context *context, int cqe,
+				struct ibv_comp_channel *channel,
+				int comp_vector);
+int pvrdma_alloc_cq_buf(struct pvrdma_device *dev, struct pvrdma_cq *cq,
+			struct pvrdma_buf *buf, int nent);
+int pvrdma_destroy_cq(struct ibv_cq *cq);
+int pvrdma_req_notify_cq(struct ibv_cq *cq, int solicited);
+int pvrdma_poll_cq(struct ibv_cq *cq, int ne, struct ibv_wc *wc);
+void pvrdma_cq_event(struct ibv_cq *cq);
+void __pvrdma_cq_clean(struct pvrdma_cq *cq, uint32_t qpn);
+void pvrdma_cq_clean(struct pvrdma_cq *cq, uint32_t qpn);
+int pvrdma_get_outstanding_cqes(struct pvrdma_cq *cq);
+void pvrdma_cq_resize_copy_cqes(struct pvrdma_cq *cq, void *buf,
+				int new_cqe);
+
+struct ibv_qp *pvrdma_create_qp(struct ibv_pd *pd,
+				struct ibv_qp_init_attr *attr);
+int pvrdma_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+		    int attr_mask, struct ibv_qp_init_attr *init_attr);
+int pvrdma_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+		     int attr_mask);
+int pvrdma_destroy_qp(struct ibv_qp *qp);
+void pvrdma_init_qp_indices(struct pvrdma_qp *qp);
+void pvrdma_qp_init_sq_ownership(struct pvrdma_qp *qp);
+int pvrdma_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
+		     struct ibv_send_wr **bad_wr);
+int pvrdma_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
+		     struct ibv_recv_wr **bad_wr);
+void pvrdma_calc_sq_wqe_size(struct ibv_qp_cap *cap, enum ibv_qp_type type,
+			     struct pvrdma_qp *qp);
+int pvrdma_alloc_qp_buf(struct pvrdma_device *dev, struct ibv_qp_cap *cap,
+			enum ibv_qp_type type, struct pvrdma_qp *qp);
+void pvrdma_set_sq_sizes(struct pvrdma_qp *qp, struct ibv_qp_cap *cap,
+			 enum ibv_qp_type type);
+struct pvrdma_qp *pvrdma_find_qp(struct pvrdma_context *ctx,
+				 uint32_t qpn);
+int pvrdma_store_qp(struct pvrdma_context *ctx, uint32_t qpn,
+		    struct pvrdma_qp *qp);
+void pvrdma_clear_qp(struct pvrdma_context *ctx, uint32_t qpn);
+
+struct ibv_ah *pvrdma_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr);
+int pvrdma_destroy_ah(struct ibv_ah *ah);
+
+int pvrdma_alloc_av(struct pvrdma_pd *pd, struct ibv_ah_attr *attr,
+		    struct pvrdma_ah *ah);
+void pvrdma_free_av(struct pvrdma_ah *ah);
+
+#endif /* __PVRDMA_H__ */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
