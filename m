From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 02/16] IB/pvrdma: Add user-level shared functions
Date: Sun, 2 Oct 2016 19:10:22 -0700
Message-ID: <515c704574423b16feb4c3d97847156623a8d042.1475458407.git.aditr@vmware.com>
References: <cover.1475458407.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1475458407.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We share some common structures with the user-level driver. This patch adds
those structures and shared functions to traverse the QP/CQ rings.

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
Changes v5->v6:
 - Removed the pvrdma-uapi.h file and moved common structures into
 pvrdma-abi.h.
 - Moved enums and structs common to user-level and kernel driver into
 pvrdma-abi.h.
 - Changed _exp_ to _ex_ for extended structures.

Changes v4->v5:
 - Moved pvrdma_uapi.h and pvrdma_user.h into common UAPI folder.
 - Renamed to pvrdma-uapi.h and pvrdma-abi.h respectively.
 - Prefixed unsigned vars with __.

Changes v3->v4:
 - Moved pvrdma_sge into pvrdma_uapi.h
---
 include/uapi/rdma/Kbuild       |   2 +
 include/uapi/rdma/pvrdma-abi.h | 289 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 291 insertions(+)
 create mode 100644 include/uapi/rdma/pvrdma-abi.h

diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
index ac62908..04357ba 100644
--- a/include/uapi/rdma/Kbuild
+++ b/include/uapi/rdma/Kbuild
@@ -8,3 +8,5 @@ header-y += rdma_netlink.h
 header-y += rdma_user_cm.h
 header-y += hfi/
 header-y += rdma_user_rxe.h
+header-y += pvrdma-abi.h
+header-y += pvrdma-uapi.h
diff --git a/include/uapi/rdma/pvrdma-abi.h b/include/uapi/rdma/pvrdma-abi.h
new file mode 100644
index 0000000..5ca0e91
--- /dev/null
+++ b/include/uapi/rdma/pvrdma-abi.h
@@ -0,0 +1,289 @@
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
+#include <linux/types.h>
+
+#define PVRDMA_UVERBS_ABI_VERSION	3		/* ABI Version. */
+#define PVRDMA_UAR_HANDLE_MASK		0x00FFFFFF	/* Bottom 24 bits. */
+#define PVRDMA_UAR_QP_OFFSET		0		/* QP doorbell. */
+#define PVRDMA_UAR_QP_SEND		BIT(30)		/* Send bit. */
+#define PVRDMA_UAR_QP_RECV		BIT(31)		/* Recv bit. */
+#define PVRDMA_UAR_CQ_OFFSET		4		/* CQ doorbell. */
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
+	__u32 qp_tab_size;
+	__u32 reserved;
+};
+
+struct pvrdma_alloc_pd_resp {
+	__u32 pdn;
+	__u32 reserved;
+};
+
+struct pvrdma_create_cq {
+	__u64 buf_addr;
+	__u32 buf_size;
+	__u32 reserved;
+};
+
+struct pvrdma_create_cq_resp {
+	__u32 cqn;
+	__u32 reserved;
+};
+
+struct pvrdma_resize_cq {
+	__u64 buf_addr;
+	__u32 buf_size;
+	__u32 reserved;
+};
+
+struct pvrdma_create_srq {
+	__u64 buf_addr;
+};
+
+struct pvrdma_create_srq_resp {
+	__u32 srqn;
+	__u32 reserved;
+};
+
+struct pvrdma_create_qp {
+	__u64 rbuf_addr;
+	__u64 sbuf_addr;
+	__u32 rbuf_size;
+	__u32 sbuf_size;
+	__u64 qp_addr;
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
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
