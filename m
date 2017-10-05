From: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: [PATCH 1/1] Adding SoftiWarp to the RDMA subsystem
Date: Thu,  5 Oct 2017 09:26:59 -0400
Message-ID: <20171005132659.25930-2-bmt@zurich.ibm.com>
References: <20171005132659.25930-1-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171005132659.25930-1-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

SoftiWARP (siw) is a software iWARP kernel driver for Linux.
It implements the iWARP protocol suite (MPA/DDP/RDMAP,
IETF-RFC 5044/5041/5040/6581) completely in software, without requiring
any dedicated RDMA hardware.

Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
---
 drivers/infiniband/Kconfig            |    1 +
 drivers/infiniband/sw/Makefile        |    1 +
 drivers/infiniband/sw/siw/Kconfig     |   18 +
 drivers/infiniband/sw/siw/Makefile    |   15 +
 drivers/infiniband/sw/siw/iwarp.h     |  381 ++++++
 drivers/infiniband/sw/siw/siw.h       |  785 ++++++++++++
 drivers/infiniband/sw/siw/siw_ae.c    |  113 ++
 drivers/infiniband/sw/siw/siw_cm.c    | 2270 +++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/siw/siw_cm.h    |  154 +++
 drivers/infiniband/sw/siw/siw_cq.c    |  164 +++
 drivers/infiniband/sw/siw/siw_debug.c |  442 +++++++
 drivers/infiniband/sw/siw/siw_debug.h |  178 +++
 drivers/infiniband/sw/siw/siw_main.c  |  754 +++++++++++
 drivers/infiniband/sw/siw/siw_mem.c   |  403 ++++++
 drivers/infiniband/sw/siw/siw_obj.c   |  428 +++++++
 drivers/infiniband/sw/siw/siw_obj.h   |  113 ++
 drivers/infiniband/sw/siw/siw_qp.c    | 1172 +++++++++++++++++
 drivers/infiniband/sw/siw/siw_qp_rx.c | 1381 ++++++++++++++++++++
 drivers/infiniband/sw/siw/siw_qp_tx.c | 1342 +++++++++++++++++++
 drivers/infiniband/sw/siw/siw_verbs.c | 1933 ++++++++++++++++++++++++++++
 drivers/infiniband/sw/siw/siw_verbs.h |  119 ++
 include/uapi/rdma/siw_user.h          |  220 ++++
 22 files changed, 12387 insertions(+)
 create mode 100644 drivers/infiniband/sw/siw/Kconfig
 create mode 100644 drivers/infiniband/sw/siw/Makefile
 create mode 100644 drivers/infiniband/sw/siw/iwarp.h
 create mode 100644 drivers/infiniband/sw/siw/siw.h
 create mode 100644 drivers/infiniband/sw/siw/siw_ae.c
 create mode 100644 drivers/infiniband/sw/siw/siw_cm.c
 create mode 100644 drivers/infiniband/sw/siw/siw_cm.h
 create mode 100644 drivers/infiniband/sw/siw/siw_cq.c
 create mode 100644 drivers/infiniband/sw/siw/siw_debug.c
 create mode 100644 drivers/infiniband/sw/siw/siw_debug.h
 create mode 100644 drivers/infiniband/sw/siw/siw_main.c
 create mode 100644 drivers/infiniband/sw/siw/siw_mem.c
 create mode 100644 drivers/infiniband/sw/siw/siw_obj.c
 create mode 100644 drivers/infiniband/sw/siw/siw_obj.h
 create mode 100644 drivers/infiniband/sw/siw/siw_qp.c
 create mode 100644 drivers/infiniband/sw/siw/siw_qp_rx.c
 create mode 100644 drivers/infiniband/sw/siw/siw_qp_tx.c
 create mode 100644 drivers/infiniband/sw/siw/siw_verbs.c
 create mode 100644 drivers/infiniband/sw/siw/siw_verbs.h
 create mode 100644 include/uapi/rdma/siw_user.h

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 234fe01904e7..6c963e814208 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -88,6 +88,7 @@ source "drivers/infiniband/ulp/isert/Kconfig"
 source "drivers/infiniband/ulp/opa_vnic/Kconfig"
 source "drivers/infiniband/sw/rdmavt/Kconfig"
 source "drivers/infiniband/sw/rxe/Kconfig"
+source "drivers/infiniband/sw/siw/Kconfig"
 
 source "drivers/infiniband/hw/hfi1/Kconfig"
 
diff --git a/drivers/infiniband/sw/Makefile b/drivers/infiniband/sw/Makefile
index 8b095b27db87..d37610fcbbc7 100644
--- a/drivers/infiniband/sw/Makefile
+++ b/drivers/infiniband/sw/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_INFINIBAND_RDMAVT)		+= rdmavt/
 obj-$(CONFIG_RDMA_RXE)			+= rxe/
+obj-$(CONFIG_RDMA_SIW)			+= siw/
diff --git a/drivers/infiniband/sw/siw/Kconfig b/drivers/infiniband/sw/siw/Kconfig
new file mode 100644
index 000000000000..482a0e992bc8
--- /dev/null
+++ b/drivers/infiniband/sw/siw/Kconfig
@@ -0,0 +1,18 @@
+config RDMA_SIW
+	tristate "Software RDMA over TCP/IP (iWARP) driver"
+	depends on INET && INFINIBAND
+	depends on CRYPTO_CRC32
+	---help---
+	This driver implements the iWARP RDMA transport over
+	the Linux TCP/IP network stack. It enables a system with a
+	standard Ethernet adapter to interoperate with a iWARP
+	adapter or with another system running the SIW driver.
+	(See also RXE which is a similar software driver for RoCE.)
+
+	The driver interfaces with the Linux RDMA stack and
+	implements both a kernel and user space RDMA verbs API.
+	The user space verbs API requires a support
+	library named libsiw which is loaded by the generic user
+	space verbs API, libibverbs. To implement RDMA over
+	TCP/IP, the driver further interfaces with the Linux
+	in-kernel TCP socket layer.
diff --git a/drivers/infiniband/sw/siw/Makefile b/drivers/infiniband/sw/siw/Makefile
new file mode 100644
index 000000000000..20f31c9e827b
--- /dev/null
+++ b/drivers/infiniband/sw/siw/Makefile
@@ -0,0 +1,15 @@
+obj-$(CONFIG_RDMA_SIW) += siw.o
+
+siw-y := \
+	siw_main.o \
+	siw_cm.o \
+	siw_verbs.o \
+	siw_obj.o \
+	siw_qp.o \
+	siw_qp_tx.o \
+	siw_qp_rx.o \
+	siw_cq.o \
+	siw_cm.o \
+	siw_debug.o \
+	siw_ae.o \
+	siw_mem.o
diff --git a/drivers/infiniband/sw/siw/iwarp.h b/drivers/infiniband/sw/siw/iwarp.h
new file mode 100644
index 000000000000..7db5ed442d3b
--- /dev/null
+++ b/drivers/infiniband/sw/siw/iwarp.h
@@ -0,0 +1,381 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *          Fredy Neeser <nfd-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#ifndef _IWARP_H
+#define _IWARP_H
+
+#include <rdma/rdma_user_cm.h>	/* RDMA_MAX_PRIVATE_DATA */
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+
+#define RDMAP_VERSION		1
+#define DDP_VERSION		1
+#define MPA_REVISION_1		1
+#define MPA_REVISION_2		2
+#define MPA_MAX_PRIVDATA	RDMA_MAX_PRIVATE_DATA
+#define MPA_KEY_REQ		"MPA ID Req Frame"
+#define MPA_KEY_REP		"MPA ID Rep Frame"
+#define	MPA_IRD_ORD_MASK	0x3fff
+
+struct mpa_rr_params {
+	__be16	bits;
+	__be16	pd_len;
+};
+
+/*
+ * MPA request/response Hdr bits & fields
+ */
+enum {
+	MPA_RR_FLAG_MARKERS	= __cpu_to_be16(0x8000),
+	MPA_RR_FLAG_CRC		= __cpu_to_be16(0x4000),
+	MPA_RR_FLAG_REJECT	= __cpu_to_be16(0x2000),
+	MPA_RR_FLAG_ENHANCED	= __cpu_to_be16(0x1000),
+	MPA_RR_RESERVED		= __cpu_to_be16(0x0f00),
+	MPA_RR_MASK_REVISION	= __cpu_to_be16(0x00ff)
+};
+
+/*
+ * MPA request/reply header
+ */
+struct mpa_rr {
+	__u8	key[16];
+	struct mpa_rr_params params;
+};
+
+
+static inline void __mpa_rr_set_revision(u16 *bits, u8 rev)
+{
+	*bits = (*bits & ~MPA_RR_MASK_REVISION)
+		| (cpu_to_be16(rev) & MPA_RR_MASK_REVISION);
+}
+
+static inline u8 __mpa_rr_revision(u16 mpa_rr_bits)
+{
+	u16 rev = mpa_rr_bits & MPA_RR_MASK_REVISION;
+
+	return (u8)be16_to_cpu(rev);
+}
+
+enum mpa_v2_ctrl {
+	MPA_V2_PEER_TO_PEER	= __cpu_to_be16(0x8000),
+	MPA_V2_ZERO_LENGTH_RTR	= __cpu_to_be16(0x4000),
+	MPA_V2_RDMA_WRITE_RTR	= __cpu_to_be16(0x8000),
+	MPA_V2_RDMA_READ_RTR	= __cpu_to_be16(0x4000),
+	MPA_V2_RDMA_NO_RTR	= __cpu_to_be16(0x0000),
+	MPA_V2_MASK_IRD_ORD	= __cpu_to_be16(0x3fff)
+};
+
+struct mpa_v2_data {
+	__be16		ird;
+	__be16		ord;
+};
+
+struct mpa_marker {
+	__be16	rsvd;
+	__be16	fpdu_hmd; /* FPDU header-marker distance (= MPA's FPDUPTR) */
+};
+
+/*
+ * maximum MPA trailer
+ */
+struct mpa_trailer {
+	char	pad[4];
+	__be32	crc;
+};
+
+#define MPA_HDR_SIZE	2
+#define MPA_CRC_SIZE	4
+
+
+/*
+ * Common portion of iWARP headers (MPA, DDP, RDMAP)
+ * for any FPDU
+ */
+struct iwarp_ctrl {
+	__be16	mpa_len;
+	__be16	ddp_rdmap_ctrl;
+};
+
+/*
+ * DDP/RDMAP Hdr bits & fields
+ */
+enum {
+	DDP_FLAG_TAGGED		= __cpu_to_be16(0x8000),
+	DDP_FLAG_LAST		= __cpu_to_be16(0x4000),
+	DDP_MASK_RESERVED	= __cpu_to_be16(0x3C00),
+	DDP_MASK_VERSION	= __cpu_to_be16(0x0300),
+	RDMAP_MASK_VERSION	= __cpu_to_be16(0x00C0),
+	RDMAP_MASK_RESERVED	= __cpu_to_be16(0x0030),
+	RDMAP_MASK_OPCODE	= __cpu_to_be16(0x000f)
+};
+
+static inline u8 __ddp_version(struct iwarp_ctrl *ctrl)
+{
+	return (u8)(be16_to_cpu(ctrl->ddp_rdmap_ctrl & DDP_MASK_VERSION) >> 8);
+};
+
+static inline void __ddp_set_version(struct iwarp_ctrl *ctrl, u8 version)
+{
+	ctrl->ddp_rdmap_ctrl = (ctrl->ddp_rdmap_ctrl & ~DDP_MASK_VERSION)
+		| (__cpu_to_be16((u16)version << 8) & DDP_MASK_VERSION);
+};
+
+static inline u8 __rdmap_version(struct iwarp_ctrl *ctrl)
+{
+	u16 ver = ctrl->ddp_rdmap_ctrl & RDMAP_MASK_VERSION;
+
+	return (u8)(be16_to_cpu(ver) >> 6);
+};
+
+static inline void __rdmap_set_version(struct iwarp_ctrl *ctrl, u8 version)
+{
+	ctrl->ddp_rdmap_ctrl = (ctrl->ddp_rdmap_ctrl & ~RDMAP_MASK_VERSION)
+			| (__cpu_to_be16(version << 6) & RDMAP_MASK_VERSION);
+}
+
+static inline u8 __rdmap_opcode(struct iwarp_ctrl *ctrl)
+{
+	return (u8)be16_to_cpu(ctrl->ddp_rdmap_ctrl & RDMAP_MASK_OPCODE);
+}
+
+static inline void __rdmap_set_opcode(struct iwarp_ctrl *ctrl, u8 opcode)
+{
+	ctrl->ddp_rdmap_ctrl = (ctrl->ddp_rdmap_ctrl & ~RDMAP_MASK_OPCODE)
+				| (__cpu_to_be16(opcode) & RDMAP_MASK_OPCODE);
+}
+
+
+struct iwarp_rdma_write {
+	struct iwarp_ctrl	ctrl;
+	__be32			sink_stag;
+	__be64			sink_to;
+};
+
+struct iwarp_rdma_rreq {
+	struct iwarp_ctrl	ctrl;
+	__be32			rsvd;
+	__be32			ddp_qn;
+	__be32			ddp_msn;
+	__be32			ddp_mo;
+	__be32			sink_stag;
+	__be64			sink_to;
+	__be32			read_size;
+	__be32			source_stag;
+	__be64			source_to;
+};
+
+struct iwarp_rdma_rresp {
+	struct iwarp_ctrl	ctrl;
+	__be32			sink_stag;
+	__be64			sink_to;
+};
+
+struct iwarp_send {
+	struct iwarp_ctrl	ctrl;
+	__be32			rsvd;
+	__be32			ddp_qn;
+	__be32			ddp_msn;
+	__be32			ddp_mo;
+};
+
+struct iwarp_send_inv {
+	struct iwarp_ctrl	ctrl;
+	__be32			inval_stag;
+	__be32			ddp_qn;
+	__be32			ddp_msn;
+	__be32			ddp_mo;
+};
+
+struct iwarp_terminate {
+	struct iwarp_ctrl	ctrl;
+	__be32			rsvd;
+	__be32			ddp_qn;
+	__be32			ddp_msn;
+	__be32			ddp_mo;
+	__be32			term_ctrl;
+};
+
+/*
+ * Terminate Hdr bits & fields
+ */
+enum {
+	RDMAP_TERM_MASK_LAYER	= __cpu_to_be32(0xf0000000),
+	RDMAP_TERM_MASK_ETYPE	= __cpu_to_be32(0x0f000000),
+	RDMAP_TERM_MASK_ECODE	= __cpu_to_be32(0x00ff0000),
+	RDMAP_TERM_FLAG_M	= __cpu_to_be32(0x00008000),
+	RDMAP_TERM_FLAG_D	= __cpu_to_be32(0x00004000),
+	RDMAP_TERM_FLAG_R	= __cpu_to_be32(0x00002000),
+	RDMAP_TERM_MASK_RESVD	= __cpu_to_be32(0x00001fff)
+};
+
+static inline u8 __rdmap_term_layer(struct iwarp_terminate *ctrl)
+{
+	return (u8)(be32_to_cpu(ctrl->term_ctrl & RDMAP_TERM_MASK_LAYER)
+		    >> 28);
+};
+
+static inline u8 __rdmap_term_etype(struct iwarp_terminate *ctrl)
+{
+	return (u8)(be32_to_cpu(ctrl->term_ctrl & RDMAP_TERM_MASK_ETYPE)
+		    >> 24);
+};
+
+static inline u8 __rdmap_term_ecode(struct iwarp_terminate *ctrl)
+{
+	return (u8)(be32_to_cpu(ctrl->term_ctrl & RDMAP_TERM_MASK_ECODE)
+		    >> 20);
+};
+
+
+/*
+ * Common portion of iWARP headers (MPA, DDP, RDMAP)
+ * for an FPDU carrying an untagged DDP segment
+ */
+struct iwarp_ctrl_untagged {
+	struct iwarp_ctrl	ctrl;
+	__be32			rsvd;
+	__be32			ddp_qn;
+	__be32			ddp_msn;
+	__be32			ddp_mo;
+};
+
+/*
+ * Common portion of iWARP headers (MPA, DDP, RDMAP)
+ * for an FPDU carrying a tagged DDP segment
+ */
+struct iwarp_ctrl_tagged {
+	struct iwarp_ctrl	ctrl;
+	__be32			ddp_stag;
+	__be64			ddp_to;
+};
+
+union iwarp_hdrs {
+	struct iwarp_ctrl		ctrl;
+	struct iwarp_ctrl_untagged	c_untagged;
+	struct iwarp_ctrl_tagged	c_tagged;
+	struct iwarp_rdma_write		rwrite;
+	struct iwarp_rdma_rreq		rreq;
+	struct iwarp_rdma_rresp		rresp;
+	struct iwarp_terminate		terminate;
+	struct iwarp_send		send;
+	struct iwarp_send_inv		send_inv;
+};
+
+enum ddp_etype {
+	DDP_ETYPE_CATASTROPHIC	= 0x0,
+	DDP_ETYPE_TAGGED_BUF	= 0x1,
+	DDP_ETYPE_UNTAGGED_BUF	= 0x2,
+	DDP_ETYPE_RSVD		= 0x3
+};
+
+enum ddp_ecode {
+	DDP_ECODE_CATASTROPHIC		= 0x00,
+	/* Tagged Buffer Errors */
+	DDP_ECODE_T_INVALID_STAG	= 0x00,
+	DDP_ECODE_T_BASE_BOUNDS		= 0x01,
+	DDP_ECODE_T_STAG_NOT_ASSOC	= 0x02,
+	DDP_ECODE_T_TO_WRAP		= 0x03,
+	DDP_ECODE_T_DDP_VERSION		= 0x04,
+	/* Untagged Buffer Errors */
+	DDP_ECODE_UT_INVALID_QN		= 0x01,
+	DDP_ECODE_UT_INVALID_MSN_NOBUF	= 0x02,
+	DDP_ECODE_UT_INVALID_MSN_RANGE	= 0x03,
+	DDP_ECODE_UT_INVALID_MO		= 0x04,
+	DDP_ECODE_UT_MSG_TOOLONG	= 0x05,
+	DDP_ECODE_UT_DDP_VERSION	= 0x06
+};
+
+
+enum rdmap_untagged_qn {
+	RDMAP_UNTAGGED_QN_SEND		= 0,
+	RDMAP_UNTAGGED_QN_RDMA_READ	= 1,
+	RDMAP_UNTAGGED_QN_TERMINATE	= 2,
+	RDMAP_UNTAGGED_QN_COUNT		= 3
+};
+
+enum rdmap_etype {
+	RDMAP_ETYPE_CATASTROPHIC	= 0x0,
+	RDMAP_ETYPE_REMOTE_PROTECTION	= 0x1,
+	RDMAP_ETYPE_REMOTE_OPERATION	= 0x2
+};
+
+enum rdmap_ecode {
+	RDMAP_ECODE_INVALID_STAG	= 0x00,
+	RDMAP_ECODE_BASE_BOUNDS		= 0x01,
+	RDMAP_ECODE_ACCESS_RIGHTS	= 0x02,
+	RDMAP_ECODE_STAG_NOT_ASSOC	= 0x03,
+	RDMAP_ECODE_TO_WRAP		= 0x04,
+	RDMAP_ECODE_RDMAP_VERSION	= 0x05,
+	RDMAP_ECODE_UNEXPECTED_OPCODE	= 0x06,
+	RDMAP_ECODE_CATASTROPHIC_STREAM	= 0x07,
+	RDMAP_ECODE_CATASTROPHIC_GLOBAL	= 0x08,
+	RDMAP_ECODE_STAG_NOT_INVALIDATE	= 0x09,
+	RDMAP_ECODE_UNSPECIFIED		= 0xff
+};
+
+enum rdmap_elayer {
+	RDMAP_ERROR_LAYER_RDMA	= 0x00,
+	RDMAP_ERROR_LAYER_DDP	= 0x01,
+	RDMAP_ERROR_LAYER_LLP	= 0x02	/* eg., MPA */
+};
+
+enum llp_ecode {
+	LLP_ECODE_LOCAL_CATASTROPHIC	= 0x05,
+	LLP_ECODE_INSUFFICIENT_IRD	= 0x06,
+	LLP_ECODE_NO_MATCHING_RTR	= 0x07
+};
+
+enum llp_etype {
+	LLP_ETYPE_MPA	= 0x00
+};
+
+enum rdma_opcode {
+	RDMAP_RDMA_WRITE	= 0x0,
+	RDMAP_RDMA_READ_REQ	= 0x1,
+	RDMAP_RDMA_READ_RESP	= 0x2,
+	RDMAP_SEND		= 0x3,
+	RDMAP_SEND_INVAL	= 0x4,
+	RDMAP_SEND_SE		= 0x5,
+	RDMAP_SEND_SE_INVAL	= 0x6,
+	RDMAP_TERMINATE		= 0x7,
+	RDMAP_NOT_SUPPORTED	= RDMAP_TERMINATE + 1
+};
+
+#endif
diff --git a/drivers/infiniband/sw/siw/siw.h b/drivers/infiniband/sw/siw/siw.h
new file mode 100644
index 000000000000..f7323f67118f
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw.h
@@ -0,0 +1,785 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#ifndef _SIW_H
+#define _SIW_H
+
+#include <linux/idr.h>
+#include <rdma/ib_verbs.h>
+#include <linux/socket.h>
+#include <linux/skbuff.h>
+#include <linux/in.h>
+#include <linux/fs.h>
+#include <linux/netdevice.h>
+#include <crypto/hash.h>
+#include <linux/resource.h>	/* MLOCK_LIMIT */
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/llist.h>
+#include <linux/mm.h>
+#include <linux/sched/signal.h>
+
+#include <rdma/siw_user.h>
+#include "iwarp.h"
+
+#define _load_shared(a)		(*(volatile typeof(a) *)&(a))
+
+#define DEVICE_ID_SOFTIWARP	0x0815
+#define SIW_VENDOR_ID		0x626d74	/* ascii 'bmt' for now */
+#define SIW_VENDORT_PART_ID	0
+#define SIW_MAX_QP		(1024 * 100)
+#define SIW_MAX_QP_WR		(1024 * 32)
+#define SIW_MAX_ORD_QP		128
+#define SIW_MAX_IRD_QP		128
+#define SIW_MAX_SGE_PBL		256	/* max num sge's for PBL */
+#define SIW_MAX_SGE_RD		1	/* iwarp limitation. we could relax */
+#define SIW_MAX_CQ		(1024 * 100)
+#define SIW_MAX_CQE		(SIW_MAX_QP_WR * 100)
+#define SIW_MAX_MR		(SIW_MAX_QP * 10)
+#define SIW_MAX_PD		SIW_MAX_QP
+#define SIW_MAX_MW		0	/* to be set if MW's are supported */
+#define SIW_MAX_FMR		SIW_MAX_MR
+#define SIW_MAX_SRQ		SIW_MAX_QP
+#define SIW_MAX_SRQ_WR		(SIW_MAX_QP_WR * 10)
+#define SIW_MAX_CONTEXT		SIW_MAX_PD
+
+#define SENDPAGE_THRESH		PAGE_SIZE /* min bytes for using sendpage() */
+#define SQ_USER_MAXBURST	100
+
+#define MAX_CPU			NR_CPUS
+
+struct siw_devinfo {
+	unsigned int	device;
+	unsigned int	version;
+
+	u32	vendor_id;
+	u32	vendor_part_id;
+	u32	sw_version;
+	int	max_qp;
+	int	max_qp_wr;
+	int	max_ord; /* max. outbound read queue depth */
+	int	max_ird; /* max. inbound read queue depth */
+
+	enum ib_device_cap_flags cap_flags;
+	int	max_sge;
+	int	max_sge_rd;
+	int	max_cq;
+	int	max_cqe;
+	u64	max_mr_size;
+	int	max_mr;
+	int	max_pd;
+	int	max_mw;
+	int	max_fmr;
+	int	max_srq;
+	int	max_srq_wr;
+	int	max_srq_sge;
+};
+
+
+struct siw_dev {
+	struct ib_device	ofa_dev;
+	struct list_head	list;
+	struct net_device	*netdev;
+	struct siw_devinfo	attrs;
+	int			is_registered; /* Registered with OFA core */
+
+	/* physical port state (only one port per device) */
+	enum ib_port_state	state;
+
+	/* object management */
+	struct list_head	cep_list;
+	struct list_head	qp_list;
+	spinlock_t		idr_lock;
+	struct idr		qp_idr;
+	struct idr		cq_idr;
+	struct idr		pd_idr;
+	struct idr		mem_idr;
+
+	/* active objects statistics */
+	atomic_t		num_qp;
+	atomic_t		num_cq;
+	atomic_t		num_pd;
+	atomic_t		num_mem;
+	atomic_t		num_srq;
+	atomic_t		num_cep;
+	atomic_t		num_ctx;
+
+	struct dentry		*debugfs;
+};
+
+struct siw_objhdr {
+	u32			id;	/* for idr based object lookup */
+	struct kref		ref;
+	struct siw_dev		*sdev;
+};
+
+struct siw_uobj {
+	struct list_head	list;
+	void	*addr;
+	u32	size;
+	u32	key;
+};
+
+struct siw_ucontext {
+	struct ib_ucontext	ib_ucontext;
+	struct siw_dev		*sdev;
+
+	/* List of user mappable queue objects */
+	struct list_head	uobj_list;
+	spinlock_t		uobj_lock;
+	u32			uobj_key;
+};
+
+struct siw_pd {
+	struct siw_objhdr	hdr;
+	struct ib_pd		ofa_pd;
+};
+
+enum siw_access_flags {
+	SIW_MEM_LREAD	= (1<<0),
+	SIW_MEM_LWRITE	= (1<<1),
+	SIW_MEM_RREAD	= (1<<2),
+	SIW_MEM_RWRITE	= (1<<3),
+
+	SIW_MEM_FLAGS_LOCAL =
+		(SIW_MEM_LREAD | SIW_MEM_LWRITE),
+	SIW_MEM_FLAGS_REMOTE =
+		(SIW_MEM_RWRITE | SIW_MEM_RREAD)
+};
+
+#define SIW_STAG_MAX	0xffffffff
+
+struct siw_mr;
+
+/*
+ * siw presentation of user memory registered as source
+ * or target of RDMA operations.
+ */
+
+struct siw_page_chunk {
+	struct page **p;
+};
+
+struct siw_umem {
+	struct siw_page_chunk	*page_chunk;
+	int			num_pages;
+	u64			fp_addr;	/* First page base address */
+	struct pid		*pid;
+	struct mm_struct	*mm_s;
+	struct work_struct	work;
+};
+
+struct siw_pble {
+	u64	addr;		/* Address of assigned user buffer */
+	u64	size;		/* Size of this entry */
+	u64	pbl_off;	/* Total offset form start of PBL */
+};
+
+struct siw_pbl {
+	unsigned int	num_buf;
+	unsigned int	max_buf;
+	struct siw_pble	pbe[1];
+};
+
+/*
+ * generic memory representation for registered siw memory.
+ * memory lookup always via higher 24 bit of stag (stag index).
+ * the stag is stored as part of the siw object header (id).
+ * object relates to memory window if embedded mr pointer is valid
+ */
+struct siw_mem {
+	struct siw_objhdr	hdr;
+
+	struct siw_mr	*mr;	/* assoc. MR if MW, NULL if MR */
+	u64	va;		/* VA of memory */
+	u64	len;		/* amount of memory bytes */
+
+	u32	stag_valid:1,		/* VALID or INVALID */
+		is_pbl:1,		/* PBL or user space mem */
+		is_zbva:1,		/* zero based virt. addr. */
+		mw_bind_enabled:1,	/* check only if MR */
+		remote_inval_enabled:1,	/* VALID or INVALID */
+		consumer_owns_key:1,	/* key/index split ? */
+		rsvd:26;
+
+	enum siw_access_flags	perms;	/* local/remote READ & WRITE */
+};
+
+#define SIW_MEM_IS_MW(m)	((m)->mr != NULL)
+
+/*
+ * MR and MW definition.
+ * Used OFA structs ib_mr/ib_mw holding:
+ * lkey, rkey, MW reference count on MR
+ */
+struct siw_mr {
+	struct ib_mr	ofa_mr;
+	struct siw_mem	mem;
+	struct rcu_head rcu;
+	union {
+		struct siw_umem	*umem;
+		struct siw_pbl	*pbl;
+		void *mem_obj;
+	};
+	struct siw_pd	*pd;
+};
+
+struct siw_mw {
+	struct ib_mw	ofa_mw;
+	struct siw_mem	mem;
+	struct rcu_head rcu;
+};
+
+enum siw_wr_state {
+	SIW_WR_IDLE		= 0,
+	SIW_WR_QUEUED		= 1,	/* processing has not started yet */
+	SIW_WR_INPROGRESS	= 2	/* initiated processing of the WR */
+};
+
+union siw_mem_resolved {
+	struct siw_mem	*obj;	/* reference to registered memory */
+	char		*buf;	/* linear kernel buffer */
+};
+
+/* The WQE currently being processed (RT or TX) */
+struct siw_wqe {
+	/* Copy of applications SQE or RQE */
+	union {
+		struct siw_sqe	sqe;
+		struct siw_rqe	rqe;
+	};
+	union siw_mem_resolved	mem[SIW_MAX_SGE]; /* per sge's resolved mem */
+	enum siw_wr_state	wr_status;
+	enum siw_wc_status	wc_status;
+	u32			bytes;		/* total bytes to process */
+	u32			processed;	/* bytes processed */
+	int			error;
+};
+
+struct siw_cq {
+	struct ib_cq		ofa_cq;
+	struct siw_objhdr	hdr;
+	enum siw_notify_flags	*notify;
+	spinlock_t		lock;
+	struct siw_cqe		*queue;
+	u32			cq_put;
+	u32			cq_get;
+	u32			num_cqe;
+	int			kernel_verbs;
+};
+
+enum siw_qp_state {
+	SIW_QP_STATE_IDLE	= 0,
+	SIW_QP_STATE_RTR	= 1,
+	SIW_QP_STATE_RTS	= 2,
+	SIW_QP_STATE_CLOSING	= 3,
+	SIW_QP_STATE_TERMINATE	= 4,
+	SIW_QP_STATE_ERROR	= 5,
+	SIW_QP_STATE_COUNT	= 6
+};
+
+enum siw_qp_flags {
+	SIW_RDMA_BIND_ENABLED	= (1 << 0),
+	SIW_RDMA_WRITE_ENABLED	= (1 << 1),
+	SIW_RDMA_READ_ENABLED	= (1 << 2),
+	SIW_SIGNAL_ALL_WR	= (1 << 3),
+	SIW_MPA_CRC		= (1 << 4),
+	SIW_QP_IN_DESTROY	= (1 << 5)
+};
+
+enum siw_qp_attr_mask {
+	SIW_QP_ATTR_STATE		= (1 << 0),
+	SIW_QP_ATTR_ACCESS_FLAGS	= (1 << 1),
+	SIW_QP_ATTR_LLP_HANDLE		= (1 << 2),
+	SIW_QP_ATTR_ORD			= (1 << 3),
+	SIW_QP_ATTR_IRD			= (1 << 4),
+	SIW_QP_ATTR_SQ_SIZE		= (1 << 5),
+	SIW_QP_ATTR_RQ_SIZE		= (1 << 6),
+	SIW_QP_ATTR_MPA			= (1 << 7)
+};
+
+struct siw_sk_upcalls {
+	void	(*sk_state_change)(struct sock *sk);
+	void	(*sk_data_ready)(struct sock *sk, int bytes);
+	void	(*sk_write_space)(struct sock *sk);
+	void	(*sk_error_report)(struct sock *sk);
+};
+
+struct siw_srq {
+	struct ib_srq		ofa_srq;
+	struct siw_pd		*pd;
+	atomic_t		rq_index;
+	spinlock_t		lock;
+	u32			max_sge;
+	atomic_t		space;	/* current space for posting wqe's */
+	u32			limit;	/* low watermark for async event */
+	struct siw_rqe		*recvq;
+	u32			rq_put;
+	u32			rq_get;
+	u32			num_rqe;/* max # of wqe's allowed */
+	char			armed;	/* inform user if limit hit */
+	char			kernel_verbs; /* '1' if kernel client */
+};
+
+struct siw_qp_attrs {
+	enum siw_qp_state	state;
+	char			terminate_buffer[52];
+	u32			terminate_msg_length;
+	u32			ddp_rdmap_version; /* 0 or 1 */
+	char			*stream_msg_buf;
+	u32			stream_msg_buf_length;
+	u32			rq_hiwat;
+	u32			sq_size;
+	u32			rq_size;
+	u32			orq_size;
+	u32			irq_size;
+	u32			sq_max_sges;
+	u32			sq_max_sges_rdmaw;
+	u32			rq_max_sges;
+	enum siw_qp_flags	flags;
+
+	struct socket		*llp_stream_handle;
+};
+
+enum siw_tx_ctx {
+	SIW_SEND_HDR = 0,	/* start or continue sending HDR */
+	SIW_SEND_DATA = 1,	/* start or continue sending DDP payload */
+	SIW_SEND_TRAILER = 2,	/* start or continue sending TRAILER */
+	SIW_SEND_SHORT_FPDU = 3 /* send whole FPDU hdr|data|trailer at once */
+};
+
+enum siw_rx_state {
+	SIW_GET_HDR = 0,	/* await new hdr or within hdr */
+	SIW_GET_DATA_START = 1,	/* start of inbound DDP payload */
+	SIW_GET_DATA_MORE = 2,	/* continuation of (misaligned) DDP payload */
+	SIW_GET_TRAILER	= 3	/* await new trailer or within trailer */
+};
+
+
+struct siw_iwarp_rx {
+	struct sk_buff		*skb;
+	union iwarp_hdrs	hdr;
+	struct mpa_trailer	trailer;
+	/*
+	 * local destination memory of inbound iwarp operation.
+	 * valid, according to wqe->wr_status
+	 */
+	struct siw_wqe		wqe_active;
+
+	struct shash_desc	*mpa_crc_hd;
+	/*
+	 * Next expected DDP MSN for each QN +
+	 * expected steering tag +
+	 * expected DDP tagget offset (all HBO)
+	 */
+	u32			ddp_msn[RDMAP_UNTAGGED_QN_COUNT];
+	u32			ddp_stag;
+	u64			ddp_to;
+
+	/*
+	 * For each FPDU, main RX loop runs through 3 stages:
+	 * Receiving protocol headers, placing DDP payload and receiving
+	 * trailer information (CRC + eventual padding).
+	 * Next two variables keep state on receive status of the
+	 * current FPDU part (hdr, data, trailer).
+	 */
+	int			fpdu_part_rcvd;/* bytes in pkt part copied */
+	int			fpdu_part_rem; /* bytes in pkt part not seen */
+
+	int			skb_new;      /* pending unread bytes in skb */
+	int			skb_offset;   /* offset in skb */
+	int			skb_copied;   /* processed bytes in skb */
+
+	int			pbl_idx;	/* Index into current PBL */
+
+	int			sge_idx;	/* current sge in rx */
+	unsigned int		sge_off;	/* already rcvd in curr. sge */
+
+	enum siw_rx_state	state;
+
+	u32			inval_stag;
+
+	u8			first_ddp_seg:1,   /* this is first DDP seg */
+				more_ddp_segs:1,   /* more DDP segs expected */
+				rx_suspend:1,	   /* stop rcv DDP segs. */
+				unused:1,
+				prev_rdmap_opcode:4; /* opcode of prev msg */
+	char			pad;		/* # of pad bytes expected */
+};
+
+#define siw_rx_data(qp, rctx)	\
+	(iwarp_pktinfo[__rdmap_opcode(&rctx->hdr.ctrl)].proc_data(qp, rctx))
+
+/*
+ * Shorthands for short packets w/o payload
+ * to be transmitted more efficient.
+ */
+struct siw_send_pkt {
+	struct iwarp_send	send;
+	__be32			crc;
+};
+
+struct siw_write_pkt {
+	struct iwarp_rdma_write	write;
+	__be32			crc;
+};
+
+struct siw_rreq_pkt {
+	struct iwarp_rdma_rreq	rreq;
+	__be32			crc;
+};
+
+struct siw_rresp_pkt {
+	struct iwarp_rdma_rresp	rresp;
+	__be32			crc;
+};
+
+struct siw_iwarp_tx {
+	union {
+		union iwarp_hdrs		hdr;
+
+		/* Generic part of FPDU header */
+		struct iwarp_ctrl		ctrl;
+		struct iwarp_ctrl_untagged	c_untagged;
+		struct iwarp_ctrl_tagged	c_tagged;
+
+		/* FPDU headers */
+		struct iwarp_rdma_write		rwrite;
+		struct iwarp_rdma_rreq		rreq;
+		struct iwarp_rdma_rresp		rresp;
+		struct iwarp_terminate		terminate;
+		struct iwarp_send		send;
+		struct iwarp_send_inv		send_inv;
+
+		/* complete short FPDUs */
+		struct siw_send_pkt		send_pkt;
+		struct siw_write_pkt		write_pkt;
+		struct siw_rreq_pkt		rreq_pkt;
+		struct siw_rresp_pkt		rresp_pkt;
+	} pkt;
+
+	struct mpa_trailer			trailer;
+	/* DDP MSN for untagged messages */
+	u32			ddp_msn[RDMAP_UNTAGGED_QN_COUNT];
+
+	enum siw_tx_ctx		state;
+	wait_queue_head_t	waitq;
+	u16			ctrl_len;	/* ddp+rdmap hdr */
+	u16			ctrl_sent;
+	int			burst;
+
+	int			bytes_unsent;	/* ddp payload bytes */
+
+	struct shash_desc	*mpa_crc_hd;
+
+	atomic_t		in_use;		/* tx currently under way */
+
+	u8			do_crc:1,	/* do crc for segment */
+				use_sendpage:1,	/* send w/o copy */
+				tx_suspend:1,	/* stop sending DDP segs. */
+				pad:2,		/* # pad in current fpdu */
+				orq_fence:1,	/* ORQ full or Send fenced */
+				unused:2;
+
+	u16			fpdu_len;	/* len of FPDU to tx */
+
+	int			tcp_seglen;	/* remaining tcp seg space */
+
+	struct siw_wqe		wqe_active;
+
+	int			pbl_idx;	/* Index into current PBL */
+	int			sge_idx;	/* current sge in tx */
+	u32			sge_off;	/* already sent in curr. sge */
+	int			in_syscall;	/* TX out of user context */
+};
+
+struct siw_qp {
+	struct ib_qp		ofa_qp;
+	struct siw_objhdr	hdr;
+	struct list_head	devq;
+	int			cpu;
+	int			kernel_verbs;
+	struct siw_iwarp_rx	rx_ctx;
+	struct siw_iwarp_tx	tx_ctx;
+
+	struct siw_cep		*cep;
+	struct rw_semaphore	state_lock;
+
+	struct siw_pd		*pd;
+	struct siw_cq		*scq;
+	struct siw_cq		*rcq;
+	struct siw_srq		*srq;
+
+	struct siw_qp_attrs	attrs;
+
+	struct siw_sqe		*sendq;	/* send queue element array */
+	uint32_t		sq_get;	/* consumer index into sq array */
+	uint32_t		sq_put;	/* kernel prod. index into sq array */
+	struct llist_node	tx_list;
+
+	struct siw_sqe		*irq;	/* inbound read queue element array */
+	uint32_t		irq_get;/* consumer index into irq array */
+	uint32_t		irq_put;/* producer index into irq array */
+
+	struct siw_rqe		*recvq;	/* recv queue element array */
+	uint32_t		rq_get;	/* consumer index into rq array */
+	uint32_t		rq_put;	/* kernel prod. index into rq array */
+
+	struct siw_sqe		*orq; /* outbound read queue element array */
+	uint32_t		orq_get;/* consumer index into orq array */
+	uint32_t		orq_put;/* shared producer index for ORQ */
+
+	spinlock_t		sq_lock;
+	spinlock_t		rq_lock;
+	spinlock_t		orq_lock;
+};
+
+#define RX_QP(rx)		container_of(rx, struct siw_qp, rx_ctx)
+#define TX_QP(tx)		container_of(tx, struct siw_qp, tx_ctx)
+#define QP_ID(qp)		((qp)->hdr.id)
+#define OBJ_ID(obj)		((obj)->hdr.id)
+#define RX_QPID(rx)		QP_ID(RX_QP(rx))
+#define TX_QPID(tx)		QP_ID(TX_QP(tx))
+
+/* helper macros */
+#define tx_wqe(qp)		(&(qp)->tx_ctx.wqe_active)
+#define rx_wqe(qp)		(&(qp)->rx_ctx.wqe_active)
+#define rx_mem(qp)		((qp)->rx_ctx.wqe_active.mem[0].obj)
+#define tx_type(wqe)		((wqe)->sqe.opcode)
+#define rx_type(wqe)		((wqe)->rqe.opcode)
+#define tx_flags(wqe)		((wqe)->sqe.flags)
+
+#define tx_more_wqe(qp)		(!siw_sq_empty(qp) || !siw_irq_empty(qp))
+
+struct iwarp_msg_info {
+	int			hdr_len;
+	struct iwarp_ctrl	ctrl;
+	int	(*proc_data)(struct siw_qp *qp, struct siw_iwarp_rx *rctx);
+};
+
+extern struct iwarp_msg_info iwarp_pktinfo[RDMAP_TERMINATE + 1];
+extern struct siw_dev *siw;
+
+
+/* QP general functions */
+int siw_qp_modify(struct siw_qp *qp, struct siw_qp_attrs *attr,
+		  enum siw_qp_attr_mask mask);
+int siw_qp_mpa_rts(struct siw_qp *qp, enum mpa_v2_ctrl ctrl);
+void siw_qp_llp_close(struct siw_qp *qp);
+void siw_qp_cm_drop(struct siw_qp *qp, int when);
+void siw_send_terminate(struct siw_qp *qp, u8 layer, u8 etype, u8 ecode);
+
+
+struct ib_qp *siw_get_ofaqp(struct ib_device *dev, int id);
+void siw_qp_get_ref(struct ib_qp *qp);
+void siw_qp_put_ref(struct ib_qp *qp);
+
+enum siw_qp_state siw_map_ibstate(enum ib_qp_state state);
+
+int siw_check_mem(struct siw_pd *pd, struct siw_mem *mem, u64 addr,
+		  enum siw_access_flags perm, int len);
+int siw_check_sge(struct siw_pd *pd, struct siw_sge *sge,
+		  union siw_mem_resolved *mem, enum siw_access_flags perm,
+		  u32 off, int len);
+int siw_check_sgl(struct siw_pd *pd, struct siw_wqe *wqe,
+		  enum siw_access_flags perm);
+
+void siw_read_to_orq(struct siw_sqe *rreq, struct siw_sqe *sqe);
+int siw_sqe_complete(struct siw_qp *qp, struct siw_sqe *sqe, u32 bytes,
+		     enum siw_wc_status status);
+int siw_rqe_complete(struct siw_qp *qp, struct siw_rqe *rqe, u32 bytes,
+		     enum siw_wc_status status);
+void siw_qp_llp_data_ready(struct sock *sock);
+void siw_qp_llp_write_space(struct sock *sock);
+
+/* SIW user memory management */
+
+#define CHUNK_SHIFT	9	/* sets number of pages per chunk */
+#define PAGES_PER_CHUNK	(_AC(1, UL) << CHUNK_SHIFT)
+#define CHUNK_MASK	(~(PAGES_PER_CHUNK - 1))
+#define PAGE_CHUNK_SIZE	(PAGES_PER_CHUNK * sizeof(struct page *))
+
+/*
+ * siw_get_upage()
+ *
+ * Get page pointer for address on given umem.
+ *
+ * @umem: two dimensional list of page pointers
+ * @addr: user virtual address
+ */
+static inline struct page *siw_get_upage(struct siw_umem *umem, u64 addr)
+{
+	unsigned int	page_idx	= (addr - umem->fp_addr) >> PAGE_SHIFT,
+			chunk_idx	= page_idx >> CHUNK_SHIFT,
+			page_in_chunk	= page_idx & ~CHUNK_MASK;
+
+	if (likely(page_idx < umem->num_pages))
+		return umem->page_chunk[chunk_idx].p[page_in_chunk];
+
+	return NULL;
+}
+
+extern struct siw_umem *siw_umem_get(u64 start, u64 len);
+extern void siw_umem_release(struct siw_umem *umem);
+extern struct siw_pbl *siw_pbl_alloc(u32 num_buf);
+extern u64 siw_pbl_get_buffer(struct siw_pbl *pbl, u64 off, int *len, int *idx);
+extern void siw_pbl_free(struct siw_pbl *pbl);
+
+
+/* QP TX path functions */
+extern int siw_run_sq(void *arg);
+extern int siw_qp_sq_process(struct siw_qp *qp);
+extern int siw_sq_start(struct siw_qp *qp);
+extern int siw_activate_tx(struct siw_qp *qp);
+extern void siw_stop_tx_thread(int nr_cpu);
+
+/* QP RX path functions */
+extern int siw_proc_send(struct siw_qp *qp, struct siw_iwarp_rx *rx);
+extern int siw_proc_rreq(struct siw_qp *qp, struct siw_iwarp_rx *rx);
+extern int siw_proc_rresp(struct siw_qp *qp, struct siw_iwarp_rx *rx);
+extern int siw_proc_write(struct siw_qp *qp, struct siw_iwarp_rx *rx);
+extern int siw_proc_terminate(struct siw_qp *qp, struct siw_iwarp_rx *rx);
+extern int siw_proc_unsupp(struct siw_qp *qp, struct siw_iwarp_rx *rx);
+
+extern int siw_tcp_rx_data(read_descriptor_t *rd_desc, struct sk_buff *skb,
+			   unsigned int off, size_t len);
+
+/* MPA utilities */
+static inline int siw_crc_array(struct shash_desc *desc, u8 *start,
+				size_t len)
+{
+	return crypto_shash_update(desc, start, len);
+}
+
+static inline int siw_crc_page(struct shash_desc *desc, struct page *p,
+			       int off, int len)
+{
+	return crypto_shash_update(desc, page_address(p) + off, len);
+}
+
+extern struct task_struct *qp_tx_thread[];
+extern int default_tx_cpu;
+
+
+/* Varia */
+extern void siw_cq_flush(struct siw_cq *cq);
+extern void siw_sq_flush(struct siw_qp *qp);
+extern void siw_rq_flush(struct siw_qp *qp);
+extern int siw_reap_cqe(struct siw_cq *cq, struct ib_wc *wc);
+
+/* RDMA core event dipatching */
+extern void siw_qp_event(struct siw_qp *qp, enum ib_event_type type);
+extern void siw_cq_event(struct siw_cq *cq, enum ib_event_type type);
+extern void siw_srq_event(struct siw_srq *srq, enum ib_event_type type);
+extern void siw_port_event(struct siw_dev *dev, u8 port,
+			   enum ib_event_type type);
+
+
+static inline struct siw_qp *siw_qp_ofa2siw(struct ib_qp *ofa_qp)
+{
+	return container_of(ofa_qp, struct siw_qp, ofa_qp);
+}
+
+static inline int siw_sq_empty(struct siw_qp *qp)
+{
+	return qp->sendq[qp->sq_get % qp->attrs.sq_size].flags == 0;
+}
+
+static inline struct siw_sqe *sq_get_next(struct siw_qp *qp)
+{
+	struct siw_sqe *sqe = &qp->sendq[qp->sq_get % qp->attrs.sq_size];
+
+	if (sqe->flags & SIW_WQE_VALID)
+		return sqe;
+
+	return NULL;
+}
+
+static inline struct siw_sqe *orq_get_current(struct siw_qp *qp)
+{
+	return &qp->orq[qp->orq_get % qp->attrs.orq_size];
+}
+
+static inline struct siw_sqe *orq_get_tail(struct siw_qp *qp)
+{
+	if (likely(qp->attrs.orq_size))
+		return &qp->orq[qp->orq_put % qp->attrs.orq_size];
+
+	pr_warn("QP[%d]: ORQ has zero length", QP_ID(qp));
+	return NULL;
+}
+
+static inline struct siw_sqe *orq_get_free(struct siw_qp *qp)
+{
+	struct siw_sqe *orq_e = orq_get_tail(qp);
+
+	if (orq_e && orq_e->flags == 0)
+		return orq_e;
+
+	return NULL;
+}
+
+static inline int siw_orq_empty(struct siw_qp *qp)
+{
+	return qp->orq[qp->orq_get % qp->attrs.orq_size].flags == 0 ? 1 : 0;
+}
+
+static inline struct siw_sqe *irq_alloc_free(struct siw_qp *qp)
+{
+	struct siw_sqe *irq_e = &qp->irq[qp->irq_put % qp->attrs.irq_size];
+
+	if (irq_e->flags == 0) {
+		qp->irq_put++;
+		return irq_e;
+	}
+	return NULL;
+}
+
+static inline int siw_irq_empty(struct siw_qp *qp)
+{
+	return qp->irq[qp->irq_get % qp->attrs.irq_size].flags == 0;
+}
+
+static inline struct siw_mr *siw_mem2mr(struct siw_mem *m)
+{
+	if (!SIW_MEM_IS_MW(m))
+		return container_of(m, struct siw_mr, mem);
+	return m->mr;
+}
+
+#endif
diff --git a/drivers/infiniband/sw/siw/siw_ae.c b/drivers/infiniband/sw/siw/siw_ae.c
new file mode 100644
index 000000000000..9f053bab4365
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_ae.c
@@ -0,0 +1,113 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/net.h>
+#include <linux/scatterlist.h>
+#include <linux/highmem.h>
+#include <net/sock.h>
+#include <net/tcp_states.h>
+#include <net/tcp.h>
+
+#include <rdma/iw_cm.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+
+#include "siw.h"
+#include "siw_obj.h"
+#include "siw_cm.h"
+
+
+void siw_qp_event(struct siw_qp *qp, enum ib_event_type etype)
+{
+	struct ib_event event;
+	struct ib_qp	*ofa_qp = &qp->ofa_qp;
+
+	event.event = etype;
+	event.device = ofa_qp->device;
+	event.element.qp = ofa_qp;
+
+	if (!(qp->attrs.flags & SIW_QP_IN_DESTROY) && ofa_qp->event_handler) {
+		dprint(DBG_EH, ": reporting %d\n", etype);
+		(*ofa_qp->event_handler)(&event, ofa_qp->qp_context);
+	}
+}
+
+void siw_cq_event(struct siw_cq *cq, enum ib_event_type etype)
+{
+	struct ib_event event;
+	struct ib_cq	*ofa_cq = &cq->ofa_cq;
+
+	event.event = etype;
+	event.device = ofa_cq->device;
+	event.element.cq = ofa_cq;
+
+	if (ofa_cq->event_handler) {
+		dprint(DBG_EH, ": reporting %d\n", etype);
+		(*ofa_cq->event_handler)(&event, ofa_cq->cq_context);
+	}
+}
+
+void siw_srq_event(struct siw_srq *srq, enum ib_event_type etype)
+{
+	struct ib_event event;
+	struct ib_srq	*ofa_srq = &srq->ofa_srq;
+
+	event.event = etype;
+	event.device = ofa_srq->device;
+	event.element.srq = ofa_srq;
+
+	if (ofa_srq->event_handler) {
+		dprint(DBG_EH, ": reporting %d\n", etype);
+		(*ofa_srq->event_handler)(&event, ofa_srq->srq_context);
+	}
+}
+
+void siw_port_event(struct siw_dev *sdev, u8 port, enum ib_event_type etype)
+{
+	struct ib_event event;
+
+	event.event = etype;
+	event.device = &sdev->ofa_dev;
+	event.element.port_num = port;
+
+	dprint(DBG_EH, ": reporting %d\n", etype);
+	ib_dispatch_event(&event);
+}
diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
new file mode 100644
index 000000000000..69db149a3c30
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -0,0 +1,2270 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *          Fredy Neeser <nfd-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *          Greg Joyce <greg-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ * Copyright (c) 2017, Open Grid Computing, Inc. 
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/net.h>
+#include <linux/inetdevice.h>
+#include <linux/workqueue.h>
+#include <net/sock.h>
+#include <net/tcp.h>
+#include <linux/tcp.h>
+
+
+#include <rdma/iw_cm.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+
+#include "siw.h"
+#include "siw_cm.h"
+#include "siw_obj.h"
+
+static bool mpa_crc_strict = true;
+module_param(mpa_crc_strict, bool, 0644);
+bool mpa_crc_required;
+module_param(mpa_crc_required, bool, 0644);
+static bool tcp_nodelay = true;
+module_param(tcp_nodelay, bool, 0644);
+static u_char  mpa_version = MPA_REVISION_2;
+module_param(mpa_version, byte, 0644);
+static bool peer_to_peer;	/* default false: no need for P2P mode */
+module_param(peer_to_peer, bool, 0644);
+
+MODULE_PARM_DESC(mpa_crc_required, "MPA CRC required");
+MODULE_PARM_DESC(mpa_crc_strict, "MPA CRC off enforced");
+MODULE_PARM_DESC(tcp_nodelay, "Set TCP NODELAY and TCP_QUICKACK");
+MODULE_PARM_DESC(mpa_version, "MPA version number");
+MODULE_PARM_DESC(peer_to_peer, "MPAv2 Peer-to-Peer RTR negotiation");
+
+/*
+ * Set to any combination of
+ * MPA_V2_RDMA_NO_RTR, MPA_V2_RDMA_READ_RTR, MPA_V2_RDMA_WRITE_RTR
+ */
+static __be16 rtr_type = MPA_V2_RDMA_READ_RTR|MPA_V2_RDMA_WRITE_RTR;
+static const bool relaxed_ird_negotiation = 1;
+
+/*
+ * siw_sock_nodelay() - Disable Nagle algorithm
+ */
+static int siw_sock_nodelay(struct socket *sock)
+{
+	int val = 1, rv;
+       
+	rv = kernel_setsockopt(sock, SOL_TCP, TCP_NODELAY, (char *)&val,
+			       sizeof(val));
+	if (rv)
+		return rv;
+
+	return kernel_setsockopt(sock, SOL_TCP, TCP_QUICKACK,
+				 (char *)&val, sizeof(val));
+}
+
+static void siw_cm_llp_state_change(struct sock *);
+static void siw_cm_llp_data_ready(struct sock *);
+static void siw_cm_llp_write_space(struct sock *);
+static void siw_cm_llp_error_report(struct sock *);
+static int siw_cm_upcall(struct siw_cep *, enum iw_cm_event_type, int);
+
+static void siw_sk_assign_cm_upcalls(struct sock *sk)
+{
+	write_lock_bh(&sk->sk_callback_lock);
+	sk->sk_state_change = siw_cm_llp_state_change;
+	sk->sk_data_ready   = siw_cm_llp_data_ready;
+	sk->sk_write_space  = siw_cm_llp_write_space;
+	sk->sk_error_report = siw_cm_llp_error_report;
+	write_unlock_bh(&sk->sk_callback_lock);
+}
+
+static void siw_sk_save_upcalls(struct sock *sk)
+{
+	struct siw_cep *cep = sk_to_cep(sk);
+
+	BUG_ON(!cep);
+
+	write_lock_bh(&sk->sk_callback_lock);
+	cep->sk_state_change = sk->sk_state_change;
+	cep->sk_data_ready   = sk->sk_data_ready;
+	cep->sk_write_space  = sk->sk_write_space;
+	cep->sk_error_report = sk->sk_error_report;
+	write_unlock_bh(&sk->sk_callback_lock);
+}
+
+static void siw_sk_restore_upcalls(struct sock *sk, struct siw_cep *cep)
+{
+	sk->sk_state_change	= cep->sk_state_change;
+	sk->sk_data_ready	= cep->sk_data_ready;
+	sk->sk_write_space	= cep->sk_write_space;
+	sk->sk_error_report	= cep->sk_error_report;
+	sk->sk_user_data	= NULL;
+}
+
+static void siw_qp_socket_assoc(struct siw_cep *cep, struct siw_qp *qp)
+{
+	struct socket *s = cep->llp.sock;
+	struct sock *sk = s->sk;
+
+	write_lock_bh(&sk->sk_callback_lock);
+
+	qp->attrs.llp_stream_handle = s;
+	sk->sk_data_ready = siw_qp_llp_data_ready;
+	sk->sk_write_space = siw_qp_llp_write_space;
+
+	write_unlock_bh(&sk->sk_callback_lock);
+}
+
+
+static void siw_socket_disassoc(struct socket *s)
+{
+	struct sock	*sk = s->sk;
+	struct siw_cep	*cep;
+
+	if (sk) {
+		write_lock_bh(&sk->sk_callback_lock);
+		cep = sk_to_cep(sk);
+		if (cep) {
+			siw_sk_restore_upcalls(sk, cep);
+			siw_cep_put(cep);
+		} else
+			pr_warn("cannot restore sk callbacks: no ep\n");
+		write_unlock_bh(&sk->sk_callback_lock);
+	} else
+		pr_warn("cannot restore sk callbacks: no sk\n");
+}
+
+static void siw_rtr_data_ready(struct sock *sk)
+{
+	struct siw_cep		*cep;
+	struct siw_qp		*qp = NULL;
+	read_descriptor_t	rd_desc;
+
+	read_lock(&sk->sk_callback_lock);
+
+	cep = sk_to_cep(sk);
+	if (!cep) {
+		WARN_ON(1);
+		goto out;
+	}
+	qp = sk_to_qp(sk);
+
+	memset(&rd_desc, 0, sizeof(rd_desc));
+	rd_desc.arg.data = qp;
+	rd_desc.count = 1;
+
+	tcp_read_sock(sk, &rd_desc, siw_tcp_rx_data);
+	/*
+	 * Check if first frame was successfully processed.
+	 * Signal connection full establishment if yes.
+	 * Failed data processing would have already scheduled
+	 * connection drop.
+	 */
+	if (qp->rx_ctx.rx_suspend == 0  && qp->rx_ctx.rx_suspend == 0)
+		siw_cm_upcall(cep, IW_CM_EVENT_ESTABLISHED, 0);
+out:
+	read_unlock(&sk->sk_callback_lock);
+	if (qp)
+		siw_qp_socket_assoc(cep, qp);
+}
+
+void siw_sk_assign_rtr_upcalls(struct siw_cep *cep)
+{
+	struct sock *sk = cep->llp.sock->sk;
+
+	write_lock_bh(&sk->sk_callback_lock);
+	sk->sk_data_ready = siw_rtr_data_ready;
+	sk->sk_write_space = siw_qp_llp_write_space;
+	write_unlock_bh(&sk->sk_callback_lock);
+}
+
+static inline int kernel_peername(struct socket *s, struct sockaddr_in *addr)
+{
+	int unused;
+
+	return s->ops->getname(s, (struct sockaddr *)addr, &unused, 1);
+}
+
+static inline int kernel_localname(struct socket *s, struct sockaddr_in *addr)
+{
+	int unused;
+
+	return s->ops->getname(s, (struct sockaddr *)addr, &unused, 0);
+}
+
+static void siw_cep_socket_assoc(struct siw_cep *cep, struct socket *s)
+{
+	cep->llp.sock = s;
+	siw_cep_get(cep);
+	s->sk->sk_user_data = cep;
+
+	siw_sk_save_upcalls(s->sk);
+	siw_sk_assign_cm_upcalls(s->sk);
+}
+
+static struct siw_cep *siw_cep_alloc(struct siw_dev  *sdev)
+{
+	struct siw_cep *cep = kzalloc(sizeof(*cep), GFP_KERNEL);
+
+	if (cep) {
+		unsigned long flags;
+
+		INIT_LIST_HEAD(&cep->listenq);
+		INIT_LIST_HEAD(&cep->devq);
+		INIT_LIST_HEAD(&cep->work_freelist);
+
+		kref_init(&cep->ref);
+		cep->state = SIW_EPSTATE_IDLE;
+		init_waitqueue_head(&cep->waitq);
+		spin_lock_init(&cep->lock);
+		cep->sdev = sdev;
+		cep->enhanced_rdma_conn_est = false;
+
+		spin_lock_irqsave(&sdev->idr_lock, flags);
+		list_add_tail(&cep->devq, &sdev->cep_list);
+		spin_unlock_irqrestore(&sdev->idr_lock, flags);
+		atomic_inc(&sdev->num_cep);
+
+		dprint(DBG_OBJ|DBG_CM, "(CEP 0x%p): New Object\n", cep);
+	}
+	return cep;
+}
+
+static void siw_cm_free_work(struct siw_cep *cep)
+{
+	struct list_head	*w, *tmp;
+	struct siw_cm_work	*work;
+
+	list_for_each_safe(w, tmp, &cep->work_freelist) {
+		work = list_entry(w, struct siw_cm_work, list);
+		list_del(&work->list);
+		kfree(work);
+	}
+}
+
+static void siw_cancel_mpatimer(struct siw_cep *cep)
+{
+	spin_lock_bh(&cep->lock);
+	if (cep->mpa_timer) {
+		if (cancel_delayed_work(&cep->mpa_timer->work)) {
+			siw_cep_put(cep);
+			kfree(cep->mpa_timer); /* not needed again */
+		}
+		cep->mpa_timer = NULL;
+	}
+	spin_unlock_bh(&cep->lock);
+}
+
+static void siw_put_work(struct siw_cm_work *work)
+{
+	INIT_LIST_HEAD(&work->list);
+	spin_lock_bh(&work->cep->lock);
+	list_add(&work->list, &work->cep->work_freelist);
+	spin_unlock_bh(&work->cep->lock);
+}
+
+static void siw_cep_set_inuse(struct siw_cep *cep)
+{
+	unsigned long flags;
+	int rv;
+retry:
+	dprint(DBG_CM, " (CEP 0x%p): use %d\n",
+		cep, cep->in_use);
+
+	spin_lock_irqsave(&cep->lock, flags);
+
+	if (cep->in_use) {
+		spin_unlock_irqrestore(&cep->lock, flags);
+		rv = wait_event_interruptible(cep->waitq, !cep->in_use);
+		if (signal_pending(current))
+			flush_signals(current);
+		goto retry;
+	} else {
+		cep->in_use = 1;
+		spin_unlock_irqrestore(&cep->lock, flags);
+	}
+}
+
+static void siw_cep_set_free(struct siw_cep *cep)
+{
+	unsigned long flags;
+
+	dprint(DBG_CM, " (CEP 0x%p): use %d\n",
+		cep, cep->in_use);
+
+	spin_lock_irqsave(&cep->lock, flags);
+	cep->in_use = 0;
+	spin_unlock_irqrestore(&cep->lock, flags);
+
+	wake_up(&cep->waitq);
+}
+
+
+static void __siw_cep_dealloc(struct kref *ref)
+{
+	struct siw_cep *cep = container_of(ref, struct siw_cep, ref);
+	struct siw_dev *sdev = cep->sdev;
+	unsigned long flags;
+
+	dprint(DBG_OBJ|DBG_CM, "(CEP 0x%p): Free Object\n", cep);
+
+	WARN_ON(cep->listen_cep);
+
+	/* kfree(NULL) is save */
+	kfree(cep->mpa.pdata);
+	spin_lock_bh(&cep->lock);
+	if (!list_empty(&cep->work_freelist))
+		siw_cm_free_work(cep);
+	spin_unlock_bh(&cep->lock);
+
+	spin_lock_irqsave(&sdev->idr_lock, flags);
+	list_del(&cep->devq);
+	spin_unlock_irqrestore(&sdev->idr_lock, flags);
+	atomic_dec(&sdev->num_cep);
+	kfree(cep);
+}
+
+static struct siw_cm_work *siw_get_work(struct siw_cep *cep)
+{
+	struct siw_cm_work	*work = NULL;
+
+	spin_lock_bh(&cep->lock);
+	if (!list_empty(&cep->work_freelist)) {
+		work = list_entry(cep->work_freelist.next, struct siw_cm_work,
+				  list);
+		list_del_init(&work->list);
+	}
+	spin_unlock_bh(&cep->lock);
+	return work;
+}
+
+static int siw_cm_alloc_work(struct siw_cep *cep, int num)
+{
+	struct siw_cm_work	*work;
+
+	BUG_ON(!list_empty(&cep->work_freelist));
+
+	while (num--) {
+		work = kmalloc(sizeof(*work), GFP_KERNEL);
+		if (!work) {
+			if (!(list_empty(&cep->work_freelist)))
+				siw_cm_free_work(cep);
+			dprint(DBG_ON, " Failed\n");
+			return -ENOMEM;
+		}
+		work->cep = cep;
+		INIT_LIST_HEAD(&work->list);
+		list_add(&work->list, &cep->work_freelist);
+	}
+	return 0;
+}
+
+/*
+ * siw_cm_upcall()
+ *
+ * Upcall to IWCM to inform about async connection events
+ */
+static int siw_cm_upcall(struct siw_cep *cep, enum iw_cm_event_type reason,
+			 int status)
+{
+	struct iw_cm_event	event;
+	struct iw_cm_id		*cm_id;
+
+	memset(&event, 0, sizeof(event));
+	event.status = status;
+	event.event = reason;
+
+	if (reason == IW_CM_EVENT_CONNECT_REQUEST) {
+		event.provider_data = cep;
+		cm_id = cep->listen_cep->cm_id;
+	} else
+		cm_id = cep->cm_id;
+
+	/* Signal private data and address information */
+	if (reason == IW_CM_EVENT_CONNECT_REQUEST ||
+	    reason == IW_CM_EVENT_CONNECT_REPLY) {
+		u16 pd_len = be16_to_cpu(cep->mpa.hdr.params.pd_len);
+
+		if (pd_len && cep->enhanced_rdma_conn_est)
+			pd_len -= sizeof(struct mpa_v2_data);
+
+		if (pd_len) {
+			/*
+			 * hand over MPA private data
+			 */
+			event.private_data_len = pd_len;
+			event.private_data = cep->mpa.pdata;
+			/* Hide MPA V2 IRD/ORD control */
+			if (cep->enhanced_rdma_conn_est)
+				event.private_data +=
+					sizeof(struct mpa_v2_data);
+		}
+		to_sockaddr_in(event.local_addr) = cep->llp.laddr;
+		to_sockaddr_in(event.remote_addr) = cep->llp.raddr;
+	}
+	/* Signal IRD and ORD */
+	if (reason == IW_CM_EVENT_ESTABLISHED ||
+	    reason == IW_CM_EVENT_CONNECT_REPLY) {
+		/* Signal negotiated IRD/ORD values we will use */
+		event.ird = cep->ird;
+		event.ord = cep->ord;
+	} else if (reason == IW_CM_EVENT_CONNECT_REQUEST) {
+		event.ird = cep->ord;
+		event.ord = cep->ird;
+	}
+	dprint(DBG_CM,
+	       " (QP%d): cep=0x%p, id=0x%p, dev=%s, reason=%d, status=%d\n",
+		cep->qp ? QP_ID(cep->qp) : -1, cep, cm_id,
+		cm_id->device->name, reason, status);
+
+	return cm_id->event_handler(cm_id, &event);
+}
+
+void siw_send_terminate(struct siw_qp *qp, u8 layer, u8 etype, u8 ecode)
+{
+	struct iwarp_terminate	pkt;
+
+	memset(&pkt, 0, sizeof(pkt));
+	pkt.term_ctrl = (layer & 0xf) | ((etype & 0xf) << 4) |
+			((u32)ecode << 8);
+	pkt.term_ctrl = cpu_to_be32(pkt.term_ctrl);
+
+	/*
+	 * TODO: send TERMINATE
+	 */
+	dprint(DBG_CM, "(QP%d): Todo\n", QP_ID(qp));
+}
+
+/*
+ * siw_qp_cm_drop()
+ *
+ * Drops established LLP connection if present and not already
+ * scheduled for dropping. Called from user context, SQ workqueue
+ * or receive IRQ. Caller signals if socket can be immediately
+ * closed (basically, if not in IRQ).
+ */
+void siw_qp_cm_drop(struct siw_qp *qp, int schedule)
+{
+	struct siw_cep *cep = qp->cep;
+
+	qp->rx_ctx.rx_suspend = 1;
+	qp->tx_ctx.tx_suspend = 1;
+
+	if (!qp->cep)
+		return;
+
+	if (schedule)
+		siw_cm_queue_work(cep, SIW_CM_WORK_CLOSE_LLP);
+	else {
+		siw_cep_set_inuse(cep);
+
+		if (cep->state == SIW_EPSTATE_CLOSED) {
+			dprint(DBG_CM, "(): cep=0x%p, already closed\n", cep);
+			goto out;
+		}
+		/*
+		 * Immediately close socket
+		 */
+		dprint(DBG_CM, "(QP%d): immediate close, cep state %d\n",
+			cep->qp ? QP_ID(cep->qp) : -1, cep->state);
+
+		if (cep->cm_id) {
+			switch (cep->state) {
+
+			case SIW_EPSTATE_AWAIT_MPAREP:
+				siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY,
+					      -EINVAL);
+				break;
+
+			case SIW_EPSTATE_RDMA_MODE:
+				siw_cm_upcall(cep, IW_CM_EVENT_CLOSE, 0);
+
+				break;
+
+			case SIW_EPSTATE_IDLE:
+			case SIW_EPSTATE_LISTENING:
+			case SIW_EPSTATE_CONNECTING:
+			case SIW_EPSTATE_AWAIT_MPAREQ:
+			case SIW_EPSTATE_RECVD_MPAREQ:
+			case SIW_EPSTATE_CLOSED:
+			default:
+
+				break;
+			}
+			cep->cm_id->rem_ref(cep->cm_id);
+			cep->cm_id = NULL;
+			siw_cep_put(cep);
+		}
+		cep->state = SIW_EPSTATE_CLOSED;
+
+		if (cep->llp.sock) {
+			siw_socket_disassoc(cep->llp.sock);
+			sock_release(cep->llp.sock);
+			cep->llp.sock = NULL;
+		}
+		if (cep->qp) {
+			BUG_ON(qp != cep->qp);
+			cep->qp = NULL;
+			siw_qp_put(qp);
+		}
+out:
+		siw_cep_set_free(cep);
+	}
+}
+
+
+void siw_cep_put(struct siw_cep *cep)
+{
+	dprint(DBG_OBJ|DBG_CM, "(CEP 0x%p): New refcount: %d\n",
+		cep, refcount_read(&cep->ref) - 1);
+
+	BUG_ON(refcount_read(&cep->ref) < 1);
+	kref_put(&cep->ref, __siw_cep_dealloc);
+}
+
+void siw_cep_get(struct siw_cep *cep)
+{
+	kref_get(&cep->ref);
+	dprint(DBG_OBJ|DBG_CM, "(CEP 0x%p): New refcount: %d\n",
+		cep, refcount_read(&cep->ref));
+}
+
+
+
+static inline int ksock_recv(struct socket *sock, char *buf, size_t size,
+			     int flags)
+{
+	struct kvec iov = {buf, size};
+	struct msghdr msg = {.msg_name = NULL, .msg_flags = flags};
+
+	return kernel_recvmsg(sock, &msg, &iov, 1, size, flags);
+}
+
+/*
+ * Expects params->pd_len in host byte order
+ *
+ * TODO: We might want to combine the arguments params and pdata to a single
+ * pointer to a struct siw_mpa_info as defined in siw_cm.h.
+ * This way, all private data parameters would be in a common struct.
+ */
+static int siw_send_mpareqrep(struct siw_cep *cep, const void *pdata,
+			      u8 pd_len)
+{
+	struct socket	*s = cep->llp.sock;
+	struct mpa_rr	*rr = &cep->mpa.hdr;
+	struct kvec	iov[3];
+	struct msghdr	msg;
+	int		rv;
+	int		iovec_num = 0;
+	int		mpa_len;
+
+	memset(&msg, 0, sizeof(msg));
+
+	iov[iovec_num].iov_base = rr;
+	iov[iovec_num].iov_len = sizeof(*rr);
+	mpa_len = sizeof(*rr);
+
+	if (cep->enhanced_rdma_conn_est) {
+		iovec_num++;
+		iov[iovec_num].iov_base = &cep->mpa.v2_ctrl;
+		iov[iovec_num].iov_len = sizeof(cep->mpa.v2_ctrl);
+		mpa_len += sizeof(cep->mpa.v2_ctrl);
+	}
+	if (pd_len) {
+		iovec_num++;
+		iov[iovec_num].iov_base = (char *)pdata;
+		iov[iovec_num].iov_len = pd_len;
+		mpa_len += pd_len;
+	}
+	if (cep->enhanced_rdma_conn_est)
+		pd_len += sizeof(cep->mpa.v2_ctrl);
+
+	rr->params.pd_len = cpu_to_be16(pd_len);
+
+	rv = kernel_sendmsg(s, &msg, iov, iovec_num + 1, mpa_len);
+
+	return rv < 0 ? rv : 0;
+}
+
+/*
+ * Receive MPA Request/Reply header.
+ *
+ * Returns 0 if complete MPA Request/Reply haeder including
+ * eventual private data was received. Returns -EAGAIN if
+ * header was partially received or negative error code otherwise.
+ *
+ * Context: May be called in process context only
+ */
+static int siw_recv_mpa_rr(struct siw_cep *cep)
+{
+	struct mpa_rr	*hdr = &cep->mpa.hdr;
+	struct socket	*s = cep->llp.sock;
+	u16		pd_len;
+	int		rcvd, to_rcv;
+
+	if (cep->mpa.bytes_rcvd < sizeof(struct mpa_rr)) {
+
+		rcvd = ksock_recv(s, (char *)hdr + cep->mpa.bytes_rcvd,
+				  sizeof(struct mpa_rr) -
+				  cep->mpa.bytes_rcvd, 0);
+
+		if (rcvd <= 0)
+			return -ECONNABORTED;
+
+		cep->mpa.bytes_rcvd += rcvd;
+
+		if (cep->mpa.bytes_rcvd < sizeof(struct mpa_rr))
+			return -EAGAIN;
+
+		if (be16_to_cpu(hdr->params.pd_len) > MPA_MAX_PRIVDATA)
+			return -EPROTO;
+	}
+	pd_len = be16_to_cpu(hdr->params.pd_len);
+
+	/*
+	 * At least the MPA Request/Reply header (frame not including
+	 * private data) has been received.
+	 * Receive (or continue receiving) any private data.
+	 */
+	to_rcv = pd_len - (cep->mpa.bytes_rcvd - sizeof(struct mpa_rr));
+
+	if (!to_rcv) {
+		/*
+		 * We must have hdr->params.pd_len == 0 and thus received a
+		 * complete MPA Request/Reply frame.
+		 * Check against peer protocol violation.
+		 */
+		u32 word;
+
+		rcvd = ksock_recv(s, (char *)&word, sizeof(word), MSG_DONTWAIT);
+		if (rcvd == -EAGAIN)
+			return 0;
+
+		if (rcvd == 0) {
+			dprint(DBG_CM, " peer EOF\n");
+			return -EPIPE;
+		}
+		if (rcvd < 0) {
+			dprint(DBG_CM, " ERROR: %d:\n", rcvd);
+			return rcvd;
+		}
+		dprint(DBG_CM, " peer sent extra data: %d\n", rcvd);
+		return -EPROTO;
+	}
+
+	/*
+	 * At this point, we must have hdr->params.pd_len != 0.
+	 * A private data buffer gets allocated if hdr->params.pd_len != 0.
+	 */
+	if (!cep->mpa.pdata) {
+		cep->mpa.pdata = kmalloc(pd_len + 4, GFP_KERNEL);
+		if (!cep->mpa.pdata)
+			return -ENOMEM;
+	}
+	rcvd = ksock_recv(s, cep->mpa.pdata + cep->mpa.bytes_rcvd
+			  - sizeof(struct mpa_rr), to_rcv + 4, MSG_DONTWAIT);
+
+	if (rcvd < 0)
+		return rcvd;
+
+	if (rcvd > to_rcv)
+		return -EPROTO;
+
+	cep->mpa.bytes_rcvd += rcvd;
+
+	if (to_rcv == rcvd) {
+		dprint(DBG_CM, " %d bytes private_data received\n", pd_len);
+
+		return 0;
+	}
+	return -EAGAIN;
+}
+
+
+/*
+ * siw_proc_mpareq()
+ *
+ * Read MPA Request from socket and signal new connection to IWCM
+ * if success. Caller must hold lock on corresponding listening CEP.
+ */
+static int siw_proc_mpareq(struct siw_cep *cep)
+{
+	struct mpa_rr	*req;
+	int		version, rv;
+	u16		pd_len;
+
+	rv = siw_recv_mpa_rr(cep);
+	if (rv)
+		goto out;
+
+	req = &cep->mpa.hdr;
+
+	version = __mpa_rr_revision(req->params.bits);
+	pd_len = be16_to_cpu(req->params.pd_len);
+
+	if (version > MPA_REVISION_2) {
+		/* allow for 0, 1, and 2 only */
+		rv = -EPROTO;
+		goto out;
+	}
+	if (memcmp(req->key, MPA_KEY_REQ, 16)) {
+		rv = -EPROTO;
+		goto out;
+	}
+	/* Prepare for sending MPA reply */
+	memcpy(req->key, MPA_KEY_REP, 16);
+
+	if (version == MPA_REVISION_2 &&
+	    (req->params.bits & MPA_RR_FLAG_ENHANCED)) {
+		/*
+		 * MPA version 2 must signal IRD/ORD values and P2P mode
+		 * in private data if header flag MPA_RR_FLAG_ENHANCED
+		 * is set.
+		 */
+		if (pd_len < sizeof(struct mpa_v2_data))
+			goto reject_conn;
+
+		cep->enhanced_rdma_conn_est = true;
+	}
+
+	/* MPA Markers: currently not supported. Marker TX to be added. */
+	if (req->params.bits & MPA_RR_FLAG_MARKERS)
+		goto reject_conn;
+
+	if (req->params.bits & MPA_RR_FLAG_CRC) {
+		/*
+		 * RFC 5044, page 27: CRC MUST be used if peer requests it.
+		 * siw specific: 'mpa_crc_strict' parameter to reject
+		 * connection with CRC if local CRC off enforced by
+		 * 'mpa_crc_strict' module parameter.
+		 */
+		if (!mpa_crc_required && mpa_crc_strict)
+			goto reject_conn;
+
+		/* Enable CRC if requested by module parameter */
+		if (mpa_crc_required)
+			req->params.bits |= MPA_RR_FLAG_CRC;
+	}
+
+	if (cep->enhanced_rdma_conn_est) {
+		struct mpa_v2_data *v2 = (struct mpa_v2_data *)cep->mpa.pdata;
+
+		/*
+		 * Peer requested ORD becomes requested local IRD,
+		 * peer requested IRD becomes requested local ORD.
+		 * IRD and ORD get limited by global maximum values.
+		 */
+		cep->ord = ntohs(v2->ird) & MPA_IRD_ORD_MASK;
+		cep->ord = min(cep->ord, SIW_MAX_ORD_QP);
+		cep->ird = ntohs(v2->ord) & MPA_IRD_ORD_MASK;
+		cep->ird = min(cep->ird, SIW_MAX_IRD_QP);
+
+		/* May get overwritten by locally negotiated values */
+		cep->mpa.v2_ctrl.ird = htons(cep->ird);
+		cep->mpa.v2_ctrl.ord = htons(cep->ord);
+
+		/*
+		 * Support for peer sent zero length Write or Read to
+		 * let local side enter RTS. Writes are preferred.
+		 * Sends would require pre-posting a Receive and are
+		 * not supported.
+		 * Propose zero length Write if none of Read and Write
+		 * is indicated.
+		 */
+		if (v2->ird & MPA_V2_PEER_TO_PEER) {
+			cep->mpa.v2_ctrl.ird |= MPA_V2_PEER_TO_PEER;
+
+			if (v2->ord & MPA_V2_RDMA_WRITE_RTR)
+				cep->mpa.v2_ctrl.ord |= MPA_V2_RDMA_WRITE_RTR;
+			else if (v2->ord & MPA_V2_RDMA_READ_RTR)
+				cep->mpa.v2_ctrl.ord |= MPA_V2_RDMA_READ_RTR;
+			else
+				cep->mpa.v2_ctrl.ord |= MPA_V2_RDMA_WRITE_RTR;
+		}
+	}
+
+	cep->state = SIW_EPSTATE_RECVD_MPAREQ;
+
+	/* Keep reference until IWCM accepts/rejects */
+	siw_cep_get(cep);
+	rv = siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REQUEST, 0);
+	if (rv)
+		siw_cep_put(cep);
+out:
+	return rv;
+
+reject_conn:
+	dprint(DBG_CM|DBG_ON, " Reject: CRC %d:%d:%d, M %d:%d\n",
+		req->params.bits & MPA_RR_FLAG_CRC ? 1 : 0,
+		mpa_crc_required, mpa_crc_strict,
+		req->params.bits & MPA_RR_FLAG_MARKERS ? 1 : 0, 0);
+
+	req->params.bits &= ~MPA_RR_FLAG_MARKERS;
+	req->params.bits |= MPA_RR_FLAG_REJECT;
+
+	if (!mpa_crc_required && mpa_crc_strict)
+		req->params.bits &= ~MPA_RR_FLAG_CRC;
+
+	if (pd_len)
+		kfree(cep->mpa.pdata);
+
+	cep->mpa.pdata = NULL;
+
+	(void)siw_send_mpareqrep(cep, NULL, 0);
+
+	return -EOPNOTSUPP;
+}
+
+
+static int siw_proc_mpareply(struct siw_cep *cep)
+{
+	struct siw_qp_attrs	qp_attrs;
+	enum siw_qp_attr_mask	qp_attr_mask;
+	struct siw_qp		*qp = cep->qp;
+	struct mpa_rr		*rep;
+	int			rv;
+	u16			rep_ord;
+	u16			rep_ird;
+	bool			ird_insufficient = false;
+	enum mpa_v2_ctrl	mpa_p2p_mode = MPA_V2_RDMA_NO_RTR;
+
+	rv = siw_recv_mpa_rr(cep);
+	if (rv != -EAGAIN)
+		siw_cancel_mpatimer(cep);
+	if (rv)
+		goto out_err;
+
+	rep = &cep->mpa.hdr;
+
+	if (__mpa_rr_revision(rep->params.bits) > MPA_REVISION_2) {
+		/* allow for 0, 1,  and 2 only */
+		rv = -EPROTO;
+		goto out_err;
+	}
+	if (memcmp(rep->key, MPA_KEY_REP, 16)) {
+		rv = -EPROTO;
+		goto out_err;
+	}
+	if (rep->params.bits & MPA_RR_FLAG_REJECT) {
+		dprint(DBG_CM, "(cep=0x%p): Got MPA reject\n", cep);
+		(void)siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY,
+				    -ECONNRESET);
+
+		rv = -ECONNRESET;
+		goto out;
+	}
+	if ((rep->params.bits & MPA_RR_FLAG_MARKERS)
+		|| (mpa_crc_required && !(rep->params.bits & MPA_RR_FLAG_CRC))
+		|| (mpa_crc_strict && !mpa_crc_required
+			&& (rep->params.bits & MPA_RR_FLAG_CRC))) {
+
+		dprint(DBG_CM|DBG_ON, " Reply unsupp: CRC %d:%d:%d, M %d:%d\n",
+			rep->params.bits & MPA_RR_FLAG_CRC ? 1 : 0,
+			mpa_crc_required, mpa_crc_strict,
+			rep->params.bits & MPA_RR_FLAG_MARKERS ? 1 : 0, 0);
+
+		(void)siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY,
+				    -ECONNREFUSED);
+		rv = -EINVAL;
+		goto out;
+	}
+
+	if (cep->enhanced_rdma_conn_est) {
+		struct mpa_v2_data *v2;
+
+		if (__mpa_rr_revision(rep->params.bits) < MPA_REVISION_2 ||
+		    !(rep->params.bits & MPA_RR_FLAG_ENHANCED)) {
+			/*
+			 * Protocol failure: The responder MUST reply with
+			 * MPA version 2 and MUST set MPA_RR_FLAG_ENHANCED.
+			 */
+			dprint(DBG_CM|DBG_ON,
+				" MPA reply error: version %d, enhanced %d\n",
+				__mpa_rr_revision(rep->params.bits),
+				rep->params.bits & MPA_RR_FLAG_ENHANCED ? 1:0);
+			(void)siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY,
+					    -ECONNRESET);
+			rv = -EINVAL;
+			goto out;
+		}
+		v2 = (struct mpa_v2_data *)cep->mpa.pdata;
+		rep_ird = ntohs(v2->ird) & MPA_IRD_ORD_MASK;
+		rep_ord = ntohs(v2->ord) & MPA_IRD_ORD_MASK;
+
+		if (cep->ird < rep_ord &&
+		    (relaxed_ird_negotiation == false ||
+		     rep_ord > cep->sdev->attrs.max_ird)) {
+			dprint(DBG_CM, " IRD %d, REP_ORD %d, MAX_ORD %d\n",
+				cep->ird, rep_ord, cep->sdev->attrs.max_ord);
+			ird_insufficient = true;
+		}
+		if (cep->ord > rep_ird && relaxed_ird_negotiation == false) {
+			dprint(DBG_CM, " ORD %d, REP_IRD %d\n",
+				cep->ord, rep_ird);
+			ird_insufficient = true;
+		}
+		/*
+		 * Always report negotiated peer values to user,
+		 * even if IRD/ORD negotiation failed
+		 */
+		cep->ird = rep_ord;
+		cep->ord = rep_ird;
+
+		if (ird_insufficient) {
+			/*
+			 * If the initiator IRD is insuffient for the
+			 * responder ORD, send a TERM.
+			 */
+			siw_send_terminate(qp, RDMAP_ERROR_LAYER_LLP,
+					   LLP_ETYPE_MPA,
+					   LLP_ECODE_INSUFFICIENT_IRD);
+			rv = -ENOMEM;
+			goto out_err;
+		}
+
+		if (cep->mpa.v2_ctrl_req.ird & MPA_V2_PEER_TO_PEER)
+			mpa_p2p_mode = cep->mpa.v2_ctrl_req.ord &
+				(MPA_V2_RDMA_WRITE_RTR | MPA_V2_RDMA_READ_RTR);
+
+		/*
+		 * Check if we requested P2P mode, and if peer agrees
+		 */
+		if (mpa_p2p_mode != MPA_V2_RDMA_NO_RTR) {
+			if ((mpa_p2p_mode & v2->ord) == 0) {
+				/*
+				 * We requested RTR mode(s), but the peer
+				 * did not pick any mode we support.
+				 */
+				dprint(DBG_ON,
+					" RTR mode:  Req %2x, Got %2x\n",
+					mpa_p2p_mode,
+					v2->ord & (MPA_V2_RDMA_WRITE_RTR |
+						   MPA_V2_RDMA_READ_RTR));
+
+				siw_send_terminate(qp, RDMAP_ERROR_LAYER_LLP,
+						   LLP_ETYPE_MPA,
+						   LLP_ECODE_NO_MATCHING_RTR);
+				rv = -EPROTO;
+				goto out_err;
+			}
+			mpa_p2p_mode = v2->ord &
+				(MPA_V2_RDMA_WRITE_RTR | MPA_V2_RDMA_READ_RTR);
+		}
+	}
+
+	memset(&qp_attrs, 0, sizeof(qp_attrs));
+	if (cep->mpa.hdr.params.bits & MPA_RR_FLAG_CRC)
+		qp_attrs.flags = SIW_MPA_CRC;
+	qp_attrs.irq_size = cep->ird;
+	qp_attrs.orq_size = cep->ord;
+	qp_attrs.llp_stream_handle = cep->llp.sock;
+	qp_attrs.state = SIW_QP_STATE_RTS;
+
+	qp_attr_mask = SIW_QP_ATTR_STATE | SIW_QP_ATTR_LLP_HANDLE |
+		       SIW_QP_ATTR_ORD | SIW_QP_ATTR_IRD | SIW_QP_ATTR_MPA;
+
+	/* Move socket RX/TX under QP control */
+	down_write(&qp->state_lock);
+	if (qp->attrs.state > SIW_QP_STATE_RTR) {
+		rv = -EINVAL;
+		up_write(&qp->state_lock);
+		goto out_err;
+	}
+	rv = siw_qp_modify(qp, &qp_attrs, qp_attr_mask);
+
+	siw_qp_socket_assoc(cep, qp);
+
+	up_write(&qp->state_lock);
+
+	/* Send extra RDMA frame to trigger peer RTS if negotiated */
+	if (mpa_p2p_mode != MPA_V2_RDMA_NO_RTR) {
+		rv = siw_qp_mpa_rts(qp, mpa_p2p_mode);
+		if (rv)
+			goto out_err;
+	}
+
+	if (!rv) {
+		rv = siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY, 0);
+		if (!rv)
+			cep->state = SIW_EPSTATE_RDMA_MODE;
+
+		goto out;
+	}
+
+out_err:
+	(void)siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY, -EINVAL);
+out:
+	return rv;
+}
+
+/*
+ * siw_accept_newconn - accept an incoming pending connection
+ *
+ */
+static void siw_accept_newconn(struct siw_cep *cep)
+{
+	struct socket		*s = cep->llp.sock;
+	struct socket		*new_s = NULL;
+	struct siw_cep		*new_cep = NULL;
+	int			rv = 0; /* debug only. should disappear */
+
+	if (cep->state != SIW_EPSTATE_LISTENING)
+		goto error;
+
+	new_cep = siw_cep_alloc(cep->sdev);
+	if (!new_cep)
+		goto error;
+
+	if (siw_cm_alloc_work(new_cep, 4) != 0)
+		goto error;
+
+	/*
+	 * Copy saved socket callbacks from listening CEP
+	 * and assign new socket with new CEP
+	 */
+	new_cep->sk_state_change = cep->sk_state_change;
+	new_cep->sk_data_ready   = cep->sk_data_ready;
+	new_cep->sk_write_space  = cep->sk_write_space;
+	new_cep->sk_error_report = cep->sk_error_report;
+
+	rv = kernel_accept(s, &new_s, O_NONBLOCK);
+	if (rv != 0) {
+		/*
+		 * TODO: Already aborted by peer?
+		 * Is there anything we should do?
+		 */
+		dprint(DBG_CM|DBG_ON,
+			"(cep=0x%p): ERROR: kernel_accept(): rv=%d\n",
+			cep, rv);
+		goto error;
+	}
+	new_cep->llp.sock = new_s;
+	siw_cep_get(new_cep);
+	new_s->sk->sk_user_data = new_cep;
+
+	dprint(DBG_CM, "(cep=0x%p, s=0x%p, new_s=0x%p): LLP conn accepted\n",
+		cep, s, new_s);
+
+	rv = siw_sock_nodelay(new_s);
+	if (rv != 0) {
+		dprint(DBG_CM|DBG_ON,
+			"(cep=0x%p): ERROR: siw_sock_nodelay(): rv=%d\n",
+			cep, rv);
+		goto error;
+	}
+
+	rv = kernel_peername(new_s, &new_cep->llp.raddr);
+	if (rv != 0) {
+		dprint(DBG_CM|DBG_ON,
+			"(cep=0x%p): ERROR: kernel_peername(): rv=%d\n",
+			cep, rv);
+		goto error;
+	}
+	rv = kernel_localname(new_s, &new_cep->llp.laddr);
+	if (rv != 0) {
+		dprint(DBG_CM|DBG_ON,
+			"(cep=0x%p): ERROR: kernel_localname(): rv=%d\n",
+			cep, rv);
+		goto error;
+	}
+
+	new_cep->state = SIW_EPSTATE_AWAIT_MPAREQ;
+
+	rv = siw_cm_queue_work(new_cep, SIW_CM_WORK_MPATIMEOUT);
+	if (rv)
+		goto error;
+	/*
+	 * See siw_proc_mpareq() etc. for the use of new_cep->listen_cep.
+	 */
+	new_cep->listen_cep = cep;
+	siw_cep_get(cep);
+
+	if (atomic_read(&new_s->sk->sk_rmem_alloc)) {
+		/*
+		 * MPA REQ already queued
+		 */
+		dprint(DBG_CM, "(cep=0x%p): Immediate MPA req.\n", cep);
+
+		siw_cep_set_inuse(new_cep);
+		rv = siw_proc_mpareq(new_cep);
+		siw_cep_set_free(new_cep);
+
+		if (rv != -EAGAIN) {
+			siw_cep_put(cep);
+			new_cep->listen_cep = NULL;
+			if (rv)
+				goto error;
+		}
+	}
+	return;
+
+error:
+	if (new_cep)
+		siw_cep_put(new_cep);
+
+	if (new_s) {
+		siw_socket_disassoc(new_s);
+		sock_release(new_s);
+		new_cep->llp.sock = NULL;
+	}
+	dprint(DBG_CM|DBG_ON, "(cep=0x%p): ERROR: rv=%d\n", cep, rv);
+}
+
+
+static void siw_cm_work_handler(struct work_struct *w)
+{
+	struct siw_cm_work	*work;
+	struct siw_cep		*cep;
+	int release_cep = 0, rv = 0;
+
+	work = container_of(w, struct siw_cm_work, work.work);
+	cep = work->cep;
+
+	dprint(DBG_CM, " (QP%d): WORK type: %d, CEP: 0x%p, state: %d\n",
+		cep->qp ? QP_ID(cep->qp) : -1, work->type, cep, cep->state);
+
+	siw_cep_set_inuse(cep);
+
+	switch (work->type) {
+
+	case SIW_CM_WORK_ACCEPT:
+
+		siw_accept_newconn(cep);
+		break;
+
+	case SIW_CM_WORK_READ_MPAHDR:
+
+		switch (cep->state) {
+
+		case SIW_EPSTATE_AWAIT_MPAREQ:
+
+			if (cep->listen_cep) {
+				siw_cep_set_inuse(cep->listen_cep);
+
+				if (cep->listen_cep->state ==
+				    SIW_EPSTATE_LISTENING)
+					rv = siw_proc_mpareq(cep);
+				else
+					rv = -EFAULT;
+
+				siw_cep_set_free(cep->listen_cep);
+
+				if (rv != -EAGAIN) {
+					siw_cep_put(cep->listen_cep);
+					cep->listen_cep = NULL;
+					if (rv)
+						siw_cep_put(cep);
+				}
+			}
+			break;
+
+		case SIW_EPSTATE_AWAIT_MPAREP:
+
+			rv = siw_proc_mpareply(cep);
+			break;
+
+		default:
+			/*
+			 * CEP already moved out of MPA handshake.
+			 * any connection management already done.
+			 * silently ignore the mpa packet.
+			 */
+			dprint(DBG_CM,
+				"(): CEP not in MPA handshake state: %d\n",
+				cep->state);
+			if (cep->state == SIW_EPSTATE_RDMA_MODE) {
+				cep->llp.sock->sk->sk_data_ready(
+					cep->llp.sock->sk);
+				pr_info("cep already in RDMA mode");
+			} else
+				pr_info("cep out of state: %d\n", cep->state);
+		}
+		if (rv && rv != EAGAIN)
+			release_cep = 1;
+
+		break;
+
+	case SIW_CM_WORK_CLOSE_LLP:
+		/*
+		 * QP scheduled LLP close
+		 */
+		dprint(DBG_CM, "(): SIW_CM_WORK_CLOSE_LLP, cep->state=%d\n",
+			cep->state);
+
+		if (cep->cm_id)
+			siw_cm_upcall(cep, IW_CM_EVENT_CLOSE, 0);
+
+		release_cep = 1;
+
+		break;
+
+	case SIW_CM_WORK_PEER_CLOSE:
+
+		dprint(DBG_CM, "(): SIW_CM_WORK_PEER_CLOSE, cep->state=%d\n",
+			cep->state);
+
+		if (cep->cm_id) {
+			switch (cep->state) {
+
+			case SIW_EPSTATE_AWAIT_MPAREP:
+				/*
+				 * MPA reply not received, but connection drop
+				 */
+				siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY,
+					      -ECONNRESET);
+				break;
+
+			case SIW_EPSTATE_RDMA_MODE:
+				/*
+				 * NOTE: IW_CM_EVENT_DISCONNECT is given just
+				 *       to transition IWCM into CLOSING.
+				 *       FIXME: is that needed?
+				 */
+				siw_cm_upcall(cep, IW_CM_EVENT_DISCONNECT, 0);
+				siw_cm_upcall(cep, IW_CM_EVENT_CLOSE, 0);
+
+				break;
+
+			default:
+
+				break;
+				/*
+				 * for these states there is no connection
+				 * known to the IWCM.
+				 */
+			}
+		} else {
+			switch (cep->state) {
+
+			case SIW_EPSTATE_RECVD_MPAREQ:
+				/*
+				 * Wait for the CM to call its accept/reject
+				 */
+				dprint(DBG_CM,
+					"(): MPAREQ received, wait for CM\n");
+				break;
+			case SIW_EPSTATE_AWAIT_MPAREQ:
+				/*
+				 * Socket close before MPA request received.
+				 */
+				dprint(DBG_CM,
+					"(): await MPAREQ: drop Listener\n");
+				siw_cep_put(cep->listen_cep);
+				cep->listen_cep = NULL;
+
+				break;
+
+			default:
+				break;
+			}
+		}
+		release_cep = 1;
+
+		break;
+
+	case SIW_CM_WORK_MPATIMEOUT:
+
+		cep->mpa_timer = NULL;
+
+		if (cep->state == SIW_EPSTATE_AWAIT_MPAREP) {
+			/*
+			 * MPA request timed out:
+			 * Hide any partially received private data and signal
+			 * timeout
+			 */
+			cep->mpa.hdr.params.pd_len = 0;
+
+			if (cep->cm_id)
+				siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY,
+					      -ETIMEDOUT);
+			release_cep = 1;
+
+		} else if (cep->state == SIW_EPSTATE_AWAIT_MPAREQ) {
+			/*
+			 * No MPA request received after peer TCP stream setup.
+			 */
+			if (cep->listen_cep) {
+				siw_cep_put(cep->listen_cep);
+				cep->listen_cep = NULL;
+			}
+			release_cep = 1;
+		}
+		break;
+
+	default:
+		BUG();
+	}
+
+	if (release_cep) {
+		dprint(DBG_CM,
+		" (CEP 0x%p): Release: timer=%s, sock=0x%p, QP%d, id=0x%p\n",
+			cep, cep->mpa_timer ? "y" : "n", cep->llp.sock,
+			cep->qp ? QP_ID(cep->qp) : -1, cep->cm_id);
+
+		siw_cancel_mpatimer(cep);
+
+		cep->state = SIW_EPSTATE_CLOSED;
+
+		if (cep->qp) {
+			struct siw_qp *qp = cep->qp;
+			/*
+			 * Serialize a potential race with application
+			 * closing the QP and calling siw_qp_cm_drop()
+			 */
+			siw_qp_get(qp);
+			siw_cep_set_free(cep);
+
+			siw_qp_llp_close(qp);
+			siw_qp_put(qp);
+
+			siw_cep_set_inuse(cep);
+			cep->qp = NULL;
+			siw_qp_put(qp);
+		}
+		if (cep->llp.sock) {
+			siw_socket_disassoc(cep->llp.sock);
+			sock_release(cep->llp.sock);
+			cep->llp.sock = NULL;
+		}
+		if (cep->cm_id) {
+			cep->cm_id->rem_ref(cep->cm_id);
+			cep->cm_id = NULL;
+			siw_cep_put(cep);
+		}
+	}
+
+	siw_cep_set_free(cep);
+
+	dprint(DBG_CM, " (Exit): WORK type: %d, CEP: 0x%p\n", work->type, cep);
+	siw_put_work(work);
+	siw_cep_put(cep);
+}
+
+static struct workqueue_struct *siw_cm_wq;
+
+int siw_cm_queue_work(struct siw_cep *cep, enum siw_work_type type)
+{
+	struct siw_cm_work *work = siw_get_work(cep);
+	unsigned long delay = 0;
+
+	if (!work) {
+		dprint(DBG_ON, " Failed\n");
+		return -ENOMEM;
+	}
+	work->type = type;
+	work->cep = cep;
+
+	siw_cep_get(cep);
+
+	INIT_DELAYED_WORK(&work->work, siw_cm_work_handler);
+
+	if (type == SIW_CM_WORK_MPATIMEOUT) {
+		cep->mpa_timer = work;
+
+		if (cep->state == SIW_EPSTATE_AWAIT_MPAREP)
+			delay = MPAREQ_TIMEOUT;
+		else
+			delay = MPAREP_TIMEOUT;
+	}
+	dprint(DBG_CM,
+		" (QP%d): WORK type: %d, CEP: 0x%p, work 0x%p, timeout %lu\n",
+		cep->qp ? QP_ID(cep->qp) : -1, type, cep, work, delay);
+
+	queue_delayed_work(siw_cm_wq, &work->work, delay);
+
+	return 0;
+}
+
+static void siw_cm_llp_data_ready(struct sock *sk)
+{
+	struct siw_cep	*cep;
+
+	read_lock(&sk->sk_callback_lock);
+
+	cep = sk_to_cep(sk);
+	if (!cep) {
+		WARN_ON(1);
+		goto out;
+	}
+
+	dprint(DBG_CM, "(): cep 0x%p, state: %d\n", cep, cep->state);
+
+	switch (cep->state) {
+
+	case SIW_EPSTATE_RDMA_MODE:
+	case SIW_EPSTATE_LISTENING:
+
+		break;
+
+	case SIW_EPSTATE_AWAIT_MPAREQ:
+	case SIW_EPSTATE_AWAIT_MPAREP:
+
+		siw_cm_queue_work(cep, SIW_CM_WORK_READ_MPAHDR);
+		break;
+
+	default:
+		dprint(DBG_CM, "(): Unexpected DATA, state %d\n", cep->state);
+		break;
+	}
+out:
+	read_unlock(&sk->sk_callback_lock);
+}
+
+static void siw_cm_llp_write_space(struct sock *sk)
+{
+	struct siw_cep	*cep = sk_to_cep(sk);
+
+	if (cep)
+		dprint(DBG_CM, "(): cep: 0x%p, state: %d\n", cep, cep->state);
+}
+
+static void siw_cm_llp_error_report(struct sock *sk)
+{
+	struct siw_cep	*cep = sk_to_cep(sk);
+
+	dprint(DBG_CM, "(): error: %d, state: %d\n", sk->sk_err, sk->sk_state);
+
+	if (cep) {
+		cep->sk_error = sk->sk_err;
+		dprint(DBG_CM, "(): cep->state: %d\n", cep->state);
+		cep->sk_error_report(sk);
+	}
+}
+
+static void siw_cm_llp_state_change(struct sock *sk)
+{
+	struct siw_cep	*cep;
+	struct socket	*s;
+	void (*orig_state_change)(struct sock *);
+
+
+	read_lock(&sk->sk_callback_lock);
+
+	cep = sk_to_cep(sk);
+	if (!cep) {
+		WARN_ON(1);
+		read_unlock(&sk->sk_callback_lock);
+		return;
+	}
+	orig_state_change = cep->sk_state_change;
+
+	s = sk->sk_socket;
+
+	dprint(DBG_CM, "(): cep: 0x%p, state: %d\n", cep, cep->state);
+
+	switch (sk->sk_state) {
+
+	case TCP_ESTABLISHED:
+		/*
+		 * handle accepting socket as special case where only
+		 * new connection is possible
+		 */
+		siw_cm_queue_work(cep, SIW_CM_WORK_ACCEPT);
+
+		break;
+
+	case TCP_CLOSE:
+	case TCP_CLOSE_WAIT:
+
+		if (cep->qp)
+			cep->qp->tx_ctx.tx_suspend = 1;
+		siw_cm_queue_work(cep, SIW_CM_WORK_PEER_CLOSE);
+
+		break;
+
+	default:
+		dprint(DBG_CM, "Unexpected sock state %d\n", sk->sk_state);
+	}
+	read_unlock(&sk->sk_callback_lock);
+	orig_state_change(sk);
+}
+
+static int kernel_bindconnect(struct socket *s,
+			      struct sockaddr *laddr, int laddrlen,
+			      struct sockaddr *raddr, int raddrlen, int flags)
+{
+	int err, s_val = 1;
+	/*
+	 * XXX
+	 * Tentative fix. Should not be needed but sometimes iwcm
+	 * chooses ports in use
+	 */
+	err = kernel_setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (char *)&s_val,
+				sizeof(s_val));
+	if (err < 0)
+		goto done;
+
+	err = s->ops->bind(s, laddr, laddrlen);
+	if (err < 0)
+		goto done;
+
+	err = s->ops->connect(s, raddr, raddrlen, flags);
+	if (err < 0)
+		goto done;
+
+	err = s->ops->getname(s, laddr, &s_val, 0);
+
+done:
+	return err;
+}
+
+
+int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
+{
+	struct siw_dev	*sdev = siw_dev_ofa2siw(id->device);
+	struct siw_qp	*qp;
+	struct siw_cep	*cep = NULL;
+	struct socket	*s = NULL;
+	struct sockaddr	*laddr, *raddr;
+	bool p2p_mode = peer_to_peer;
+
+	u16 pd_len = params->private_data_len;
+	int version = mpa_version, rv;
+
+	if (pd_len > MPA_MAX_PRIVDATA)
+		return -EINVAL;
+
+	if (params->ird > sdev->attrs.max_ird ||
+	    params->ord > sdev->attrs.max_ord)
+		return -ENOMEM;
+
+	qp = siw_qp_id2obj(sdev, params->qpn);
+	BUG_ON(!qp);
+
+	dprint(DBG_CM, "(id=0x%p, QP%d): dev(id)=%s, netdev=%s\n",
+		id, QP_ID(qp), sdev->ofa_dev.name, sdev->netdev->name);
+	dprint(DBG_CM, "(id=0x%p, QP%d): laddr=(0x%x,%d), raddr=(0x%x,%d)\n",
+		id, QP_ID(qp),
+		ntohl(to_sockaddr_in(id->local_addr).sin_addr.s_addr),
+		ntohs(to_sockaddr_in(id->local_addr).sin_port),
+		ntohl(to_sockaddr_in(id->remote_addr).sin_addr.s_addr),
+		ntohs(to_sockaddr_in(id->remote_addr).sin_port));
+
+	laddr = (struct sockaddr *)&id->local_addr;
+	raddr = (struct sockaddr *)&id->remote_addr;
+
+	rv = sock_create(AF_INET, SOCK_STREAM, IPPROTO_TCP, &s);
+	if (rv < 0)
+		goto error;
+
+	/*
+	 * NOTE: For simplification, connect() is called in blocking
+	 * mode. Might be reconsidered for async connection setup at
+	 * TCP level.
+	 */
+	rv = kernel_bindconnect(s, laddr, sizeof(*laddr), raddr,
+				sizeof(*raddr), 0);
+	if (rv != 0) {
+		dprint(DBG_CM, "(id=0x%p, QP%d): kernel_bindconnect: rv=%d\n",
+			id, QP_ID(qp), rv);
+		goto error;
+	}
+	rv = siw_sock_nodelay(s);
+	if (rv != 0) {
+		dprint(DBG_CM, "(id=0x%p, QP%d): siw_sock_nodelay(): rv=%d\n",
+			id, QP_ID(qp), rv);
+		goto error;
+	}
+	cep = siw_cep_alloc(sdev);
+	if (!cep) {
+		rv =  -ENOMEM;
+		goto error;
+	}
+	siw_cep_set_inuse(cep);
+
+	/* Associate QP with CEP */
+	siw_cep_get(cep);
+	qp->cep = cep;
+
+	/* siw_qp_get(qp) already done by QP lookup */
+	cep->qp = qp;
+
+	id->add_ref(id);
+	cep->cm_id = id;
+
+	rv = siw_cm_alloc_work(cep, 4);
+	if (rv != 0) {
+		rv = -ENOMEM;
+		goto error;
+	}
+	cep->ird = params->ird;
+	cep->ord = params->ord;
+
+	if (p2p_mode && cep->ord == 0)
+		cep->ord = 1;
+
+	cep->state = SIW_EPSTATE_CONNECTING;
+
+	dprint(DBG_CM, " (id=0x%p, QP%d): pd_len = %u\n",
+		id, QP_ID(qp), pd_len);
+
+	rv = kernel_peername(s, &cep->llp.raddr);
+	if (rv)
+		goto error;
+
+	rv = kernel_localname(s, &cep->llp.laddr);
+	if (rv)
+		goto error;
+
+	/*
+	 * Associate CEP with socket
+	 */
+	siw_cep_socket_assoc(cep, s);
+
+	cep->state = SIW_EPSTATE_AWAIT_MPAREP;
+
+	/*
+	 * Set MPA Request bits: CRC if required, no MPA Markers,
+	 * MPA Rev. according to module parameter 'mpa_version', Key 'Request'.
+	 */
+	cep->mpa.hdr.params.bits = 0;
+	if (version > MPA_REVISION_2) {
+		pr_warn("siw_connect: set MPA version to %u\n", MPA_REVISION_2);
+		version = MPA_REVISION_2;
+		/* Adjust also module parameter */
+		mpa_version = MPA_REVISION_2;
+	}
+	__mpa_rr_set_revision(&cep->mpa.hdr.params.bits, version);
+
+	if (mpa_crc_required)
+		cep->mpa.hdr.params.bits |= MPA_RR_FLAG_CRC;
+
+	/*
+	 * If MPA version == 2:
+	 * o Include ORD and IRD.
+	 * o Indicate peer-to-peer mode, if required by module
+	 *   parameter 'peer_to_peer'.
+	 */
+	if (version == MPA_REVISION_2) {
+		cep->enhanced_rdma_conn_est = true;
+		cep->mpa.hdr.params.bits |= MPA_RR_FLAG_ENHANCED;
+
+		cep->mpa.v2_ctrl.ird = htons(cep->ird);
+		cep->mpa.v2_ctrl.ord = htons(cep->ord);
+
+		if (p2p_mode) {
+			cep->mpa.v2_ctrl.ird |= MPA_V2_PEER_TO_PEER;
+			cep->mpa.v2_ctrl.ord |= rtr_type;
+		}
+		/* Remember own P2P mode requested */
+		cep->mpa.v2_ctrl_req.ird = cep->mpa.v2_ctrl.ird;
+		cep->mpa.v2_ctrl_req.ord = cep->mpa.v2_ctrl.ord;
+	}
+
+	memcpy(cep->mpa.hdr.key, MPA_KEY_REQ, 16);
+
+	rv = siw_send_mpareqrep(cep, params->private_data, pd_len);
+	/*
+	 * Reset private data.
+	 */
+	cep->mpa.hdr.params.pd_len = 0;
+
+	if (rv >= 0) {
+		rv = siw_cm_queue_work(cep, SIW_CM_WORK_MPATIMEOUT);
+		if (!rv) {
+			dprint(DBG_CM, "(id=0x%p, cep=0x%p QP%d): Exit\n",
+				id, cep, QP_ID(qp));
+			siw_cep_set_free(cep);
+			return 0;
+		}
+	}
+error:
+	dprint(DBG_CM, " Failed: %d\n", rv);
+
+	if (cep) {
+		siw_socket_disassoc(s);
+		sock_release(s);
+		cep->llp.sock = NULL;
+
+		cep->qp = NULL;
+
+		cep->cm_id = NULL;
+		id->rem_ref(id);
+		siw_cep_put(cep);
+
+		qp->cep = NULL;
+		siw_cep_put(cep);
+
+		cep->state = SIW_EPSTATE_CLOSED;
+
+		siw_cep_set_free(cep);
+
+		siw_cep_put(cep);
+
+	} else if (s)
+		sock_release(s);
+
+	siw_qp_put(qp);
+
+	return rv;
+}
+
+/*
+ * siw_accept - Let SoftiWARP accept an RDMA connection request
+ *
+ * @id:		New connection management id to be used for accepted
+ *		connection request
+ * @params:	Connection parameters provided by ULP for accepting connection
+ *
+ * Transition QP to RTS state, associate new CM id @id with accepted CEP
+ * and get prepared for TCP input by installing socket callbacks.
+ * Then send MPA Reply and generate the "connection established" event.
+ * Socket callbacks must be installed before sending MPA Reply, because
+ * the latter may cause a first RDMA message to arrive from the RDMA Initiator
+ * side very quickly, at which time the socket callbacks must be ready.
+ */
+int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
+{
+	struct siw_dev		*sdev = siw_dev_ofa2siw(id->device);
+	struct siw_cep		*cep = (struct siw_cep *)id->provider_data;
+	struct siw_qp		*qp;
+	struct siw_qp_attrs	qp_attrs;
+	int rv, max_priv_data = MPA_MAX_PRIVDATA;
+	bool wait_for_peer_rts = false;
+
+	siw_cep_set_inuse(cep);
+	siw_cep_put(cep);
+
+	/* Free lingering inbound private data */
+	if (cep->mpa.hdr.params.pd_len) {
+		cep->mpa.hdr.params.pd_len = 0;
+		kfree(cep->mpa.pdata);
+		cep->mpa.pdata = NULL;
+	}
+	siw_cancel_mpatimer(cep);
+
+	if (cep->state != SIW_EPSTATE_RECVD_MPAREQ) {
+		if (cep->state == SIW_EPSTATE_CLOSED) {
+
+			dprint(DBG_CM, "(id=0x%p): Out of State\n", id);
+
+			siw_cep_set_free(cep);
+			siw_cep_put(cep);
+
+			return -ECONNRESET;
+		}
+		BUG();
+	}
+
+	qp = siw_qp_id2obj(sdev, params->qpn);
+	BUG_ON(!qp); /* The OFA core should prevent this */
+
+	down_write(&qp->state_lock);
+	if (qp->attrs.state > SIW_QP_STATE_RTR) {
+		rv = -EINVAL;
+		up_write(&qp->state_lock);
+		goto error;
+	}
+
+	dprint(DBG_CM, "(id=0x%p, QP%d): dev(id)=%s\n",
+		id, QP_ID(qp), sdev->ofa_dev.name);
+
+	if (params->ord > sdev->attrs.max_ord ||
+	    params->ird > sdev->attrs.max_ird) {
+		dprint(DBG_CM|DBG_ON,
+			"(id=0x%p, QP%d): ORD %d (max %d), IRD %d (max %d)\n",
+			id, QP_ID(qp),
+			params->ord, sdev->attrs.max_ord,
+			params->ird, sdev->attrs.max_ird);
+		rv = -EINVAL;
+		up_write(&qp->state_lock);
+		goto error;
+	}
+	if (cep->enhanced_rdma_conn_est)
+		max_priv_data -= sizeof(struct mpa_v2_data);
+
+	if (params->private_data_len > max_priv_data) {
+		dprint(DBG_CM|DBG_ON,
+			"(id=0x%p, QP%d): Private data length: %d (max %d)\n",
+			id, QP_ID(qp),
+			params->private_data_len, max_priv_data);
+		rv =  -EINVAL;
+		up_write(&qp->state_lock);
+		goto error;
+	}
+
+	if (cep->enhanced_rdma_conn_est) {
+		if (params->ord > cep->ord) {
+			if (relaxed_ird_negotiation)
+				params->ord = cep->ord;
+			else {
+				cep->ird = params->ird;
+				cep->ord = params->ord;
+				rv =  -EINVAL;
+				up_write(&qp->state_lock);
+				goto error;
+			}
+		}
+		if (params->ird < cep->ird) {
+			if (relaxed_ird_negotiation &&
+			    cep->ird <= sdev->attrs.max_ird)
+				params->ird = cep->ird;
+			else {
+				rv = -ENOMEM;
+				up_write(&qp->state_lock);
+				goto error;
+			}
+		}
+		if (cep->mpa.v2_ctrl.ord &
+		    (MPA_V2_RDMA_WRITE_RTR | MPA_V2_RDMA_READ_RTR))
+			wait_for_peer_rts = true;
+		/*
+		 * Signal back negotiated IRD and ORD values
+		 */
+		cep->mpa.v2_ctrl.ord = htons(params->ord & MPA_IRD_ORD_MASK) |
+				(cep->mpa.v2_ctrl.ord & ~MPA_V2_MASK_IRD_ORD);
+		cep->mpa.v2_ctrl.ird = htons(params->ird & MPA_IRD_ORD_MASK) |
+				(cep->mpa.v2_ctrl.ird & ~MPA_V2_MASK_IRD_ORD);
+	}
+	cep->ird = params->ird;
+	cep->ord = params->ord;
+
+	cep->cm_id = id;
+	id->add_ref(id);
+
+	memset(&qp_attrs, 0, sizeof(qp_attrs));
+	qp_attrs.orq_size = cep->ord;
+	qp_attrs.irq_size = cep->ird;
+	qp_attrs.llp_stream_handle = cep->llp.sock;
+	if (cep->mpa.hdr.params.bits & MPA_RR_FLAG_CRC)
+		qp_attrs.flags = SIW_MPA_CRC;
+	qp_attrs.state = SIW_QP_STATE_RTS;
+
+	dprint(DBG_CM, "(id=0x%p, QP%d): Moving to RTS\n", id, QP_ID(qp));
+
+	/* Associate QP with CEP */
+	siw_cep_get(cep);
+	qp->cep = cep;
+
+	/* siw_qp_get(qp) already done by QP lookup */
+	cep->qp = qp;
+
+	cep->state = SIW_EPSTATE_RDMA_MODE;
+
+	/* Move socket RX/TX under QP control */
+	rv = siw_qp_modify(qp, &qp_attrs, SIW_QP_ATTR_STATE|
+					  SIW_QP_ATTR_LLP_HANDLE|
+					  SIW_QP_ATTR_ORD|
+					  SIW_QP_ATTR_IRD|
+					  SIW_QP_ATTR_MPA);
+	up_write(&qp->state_lock);
+
+	if (rv)
+		goto error;
+
+	dprint(DBG_CM, "(id=0x%p, QP%d): %d bytes private_data\n",
+			id, QP_ID(qp), params->private_data_len);
+
+	dprint(DBG_CM, "(id=0x%p, QP%d): Sending MPA Reply\n", id, QP_ID(qp));
+
+	rv = siw_send_mpareqrep(cep, params->private_data,
+				params->private_data_len);
+	if (rv != 0)
+		goto error;
+
+	if (wait_for_peer_rts)
+		siw_sk_assign_rtr_upcalls(cep);
+	else {
+		siw_qp_socket_assoc(cep, qp);
+		rv = siw_cm_upcall(cep, IW_CM_EVENT_ESTABLISHED, 0);
+		if (rv)
+			goto error;
+	}
+	siw_cep_set_free(cep);
+
+	return 0;
+error:
+	siw_socket_disassoc(cep->llp.sock);
+	sock_release(cep->llp.sock);
+	cep->llp.sock = NULL;
+
+	cep->state = SIW_EPSTATE_CLOSED;
+
+	if (cep->cm_id) {
+		cep->cm_id->rem_ref(id);
+		cep->cm_id = NULL;
+	}
+	if (qp->cep) {
+		siw_cep_put(cep);
+		qp->cep = NULL;
+	}
+	cep->qp = NULL;
+	siw_qp_put(qp);
+
+	siw_cep_set_free(cep);
+	siw_cep_put(cep);
+
+	return rv;
+}
+
+/*
+ * siw_reject()
+ *
+ * Local connection reject case. Send private data back to peer,
+ * close connection and dereference connection id.
+ */
+int siw_reject(struct iw_cm_id *id, const void *pdata, u8 pd_len)
+{
+	struct siw_cep	*cep = (struct siw_cep *)id->provider_data;
+
+	siw_cep_set_inuse(cep);
+	siw_cep_put(cep);
+
+	siw_cancel_mpatimer(cep);
+
+	if (cep->state != SIW_EPSTATE_RECVD_MPAREQ) {
+		if (cep->state == SIW_EPSTATE_CLOSED) {
+
+			dprint(DBG_CM, "(id=0x%p): Out of State\n", id);
+
+			siw_cep_set_free(cep);
+			siw_cep_put(cep); /* should be last reference */
+
+			return -ECONNRESET;
+		}
+		BUG();
+	}
+	dprint(DBG_CM, "(id=0x%p): cep->state=%d\n", id, cep->state);
+	dprint(DBG_CM, " Reject: %d: %x\n", pd_len, pd_len ? *(char *)pdata:0);
+
+	if (__mpa_rr_revision(cep->mpa.hdr.params.bits) >= MPA_REVISION_1) {
+		cep->mpa.hdr.params.bits |= MPA_RR_FLAG_REJECT; /* reject */
+		(void)siw_send_mpareqrep(cep, pdata, pd_len);
+	}
+	siw_socket_disassoc(cep->llp.sock);
+	sock_release(cep->llp.sock);
+	cep->llp.sock = NULL;
+
+	cep->state = SIW_EPSTATE_CLOSED;
+
+	siw_cep_set_free(cep);
+	siw_cep_put(cep);
+
+	return 0;
+}
+
+static int siw_listen_address(struct iw_cm_id *id, int backlog,
+			      struct sockaddr *laddr)
+{
+	struct socket		*s;
+	struct siw_cep		*cep = NULL;
+	int			rv = 0, s_val;
+
+	rv = sock_create(AF_INET, SOCK_STREAM, IPPROTO_TCP, &s);
+	if (rv < 0) {
+		dprint(DBG_CM|DBG_ON,
+			"(id=0x%p): ERROR: sock_create(): rv=%d\n", id, rv);
+		return rv;
+	}
+
+	/*
+	 * Probably to be removed later. Allows binding
+	 * local port when still in TIME_WAIT from last close.
+	 */
+	s_val = 1;
+	rv = kernel_setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (char *)&s_val,
+			       sizeof(s_val));
+	if (rv != 0) {
+		dprint(DBG_CM|DBG_ON,
+			"(id=0x%p): ERROR: kernel_setsockopt(): rv=%d\n",
+			id, rv);
+		goto error;
+	}
+
+	rv = s->ops->bind(s, laddr, sizeof(*laddr));
+	if (rv != 0) {
+		dprint(DBG_CM|DBG_ON, "(id=0x%p): ERROR: bind(): rv=%d\n",
+			id, rv);
+		goto error;
+	}
+
+	cep = siw_cep_alloc(siw_dev_ofa2siw(id->device));
+	if (!cep) {
+		rv = -ENOMEM;
+		goto error;
+	}
+	siw_cep_socket_assoc(cep, s);
+
+	rv = siw_cm_alloc_work(cep, backlog);
+	if (rv != 0) {
+		dprint(DBG_CM|DBG_ON,
+			"(id=0x%p): ERROR: alloc_work(backlog=%d): rv=%d\n",
+			id, backlog, rv);
+		goto error;
+	}
+
+	rv = s->ops->listen(s, backlog);
+	if (rv != 0) {
+		dprint(DBG_CM|DBG_ON, "(id=0x%p): ERROR: listen() rv=%d\n",
+			id, rv);
+		goto error;
+	}
+
+	/*
+	 * TODO: Do we really need the copies of local_addr and remote_addr
+	 *	 in CEP ???
+	 */
+	memcpy(&cep->llp.laddr, &id->local_addr, sizeof(cep->llp.laddr));
+	memcpy(&cep->llp.raddr, &id->remote_addr, sizeof(cep->llp.raddr));
+
+	cep->cm_id = id;
+	id->add_ref(id);
+
+	/*
+	 * In case of a wildcard rdma_listen on a multi-homed device,
+	 * a listener's IWCM id is associated with more than one listening CEP.
+	 *
+	 * We currently use id->provider_data in three different ways:
+	 *
+	 * o For a listener's IWCM id, id->provider_data points to
+	 *   the list_head of the list of listening CEPs.
+	 *   Uses: siw_create_listen(), siw_destroy_listen()
+	 *
+	 * o For a passive-side IWCM id, id->provider_data points to
+	 *   the CEP itself. This is a consequence of
+	 *   - siw_cm_upcall() setting event.provider_data = cep and
+	 *   - the IWCM's cm_conn_req_handler() setting provider_data of the
+	 *     new passive-side IWCM id equal to event.provider_data
+	 *   Uses: siw_accept(), siw_reject()
+	 *
+	 * o For an active-side IWCM id, id->provider_data is not used at all.
+	 *
+	 */
+	if (!id->provider_data) {
+		id->provider_data = kmalloc(sizeof(struct list_head),
+					    GFP_KERNEL);
+		if (!id->provider_data) {
+			rv = -ENOMEM;
+			goto error;
+		}
+		INIT_LIST_HEAD((struct list_head *)id->provider_data);
+	}
+
+	dprint(DBG_CM,
+		"(id=0x%p): dev=%s, netdev=%s, provider_data=0x%p, cep=0x%p\n",
+		id, id->device->name,
+		siw_dev_ofa2siw(id->device)->netdev->name,
+		id->provider_data, cep);
+
+	list_add_tail(&cep->listenq, (struct list_head *)id->provider_data);
+	cep->state = SIW_EPSTATE_LISTENING;
+
+	return 0;
+
+error:
+	dprint(DBG_CM, " Failed: %d\n", rv);
+
+	if (cep) {
+		siw_cep_set_inuse(cep);
+
+		if (cep->cm_id) {
+			cep->cm_id->rem_ref(cep->cm_id);
+			cep->cm_id = NULL;
+		}
+		cep->llp.sock = NULL;
+		siw_socket_disassoc(s);
+		cep->state = SIW_EPSTATE_CLOSED;
+
+		siw_cep_set_free(cep);
+		siw_cep_put(cep);
+	}
+	sock_release(s);
+
+	return rv;
+}
+
+static void siw_drop_listeners(struct iw_cm_id *id)
+{
+	struct list_head	*p, *tmp;
+	/*
+	 * In case of a wildcard rdma_listen on a multi-homed device,
+	 * a listener's IWCM id is associated with more than one listening CEP.
+	 */
+	list_for_each_safe(p, tmp, (struct list_head *)id->provider_data) {
+		struct siw_cep *cep = list_entry(p, struct siw_cep, listenq);
+
+		list_del(p);
+
+		dprint(DBG_CM, "(id=0x%p): drop CEP 0x%p, state %d\n",
+			id, cep, cep->state);
+		siw_cep_set_inuse(cep);
+
+		if (cep->cm_id) {
+			cep->cm_id->rem_ref(cep->cm_id);
+			cep->cm_id = NULL;
+		}
+		if (cep->llp.sock) {
+			siw_socket_disassoc(cep->llp.sock);
+			sock_release(cep->llp.sock);
+			cep->llp.sock = NULL;
+		}
+		cep->state = SIW_EPSTATE_CLOSED;
+		siw_cep_set_free(cep);
+		siw_cep_put(cep);
+	}
+}
+
+/*
+ * siw_create_listen - Create resources for a listener's IWCM ID @id
+ *
+ * Listens on the socket addresses id->local_addr and id->remote_addr.
+ *
+ * If the listener's @id provides a specific local IP address, at most one
+ * listening socket is created and associated with @id.
+ *
+ * If the listener's @id provides the wildcard (zero) local IP address,
+ * a separate listen is performed for each local IP address of the device
+ * by creating a listening socket and binding to that local IP address.
+ *
+ */
+int siw_create_listen(struct iw_cm_id *id, int backlog)
+{
+	struct ib_device	*ofa_dev = id->device;
+	struct siw_dev		*sdev = siw_dev_ofa2siw(ofa_dev);
+	int			rv = 0;
+
+	dprint(DBG_CM, "(id=0x%p): dev(id)=%s, netdev=%s backlog=%d\n",
+		id, ofa_dev->name, sdev->netdev->name, backlog);
+
+	if (to_sockaddr_in(id->local_addr).sin_family == AF_INET) {
+		/* IPv4 */
+		struct sockaddr_in	laddr = to_sockaddr_in(id->local_addr);
+		u8			*l_ip, *r_ip;
+		struct in_device	*in_dev;
+
+		l_ip = (u8 *) &to_sockaddr_in(id->local_addr).sin_addr.s_addr;
+		r_ip = (u8 *) &to_sockaddr_in(id->remote_addr).sin_addr.s_addr;
+		dprint(DBG_CM,
+			"(id=0x%p): laddr: ipv4=%d.%d.%d.%d, port=%d; "
+			"raddr: ipv4=%d.%d.%d.%d, port=%d\n",
+			id, l_ip[0], l_ip[1], l_ip[2], l_ip[3],
+			ntohs(to_sockaddr_in(id->local_addr).sin_port),
+			r_ip[0], r_ip[1], r_ip[2], r_ip[3],
+			ntohs(to_sockaddr_in(id->remote_addr).sin_port));
+
+		in_dev = in_dev_get(sdev->netdev);
+		if (!in_dev) {
+			dprint(DBG_CM|DBG_ON,
+				"(id=0x%p): netdev has no in_device\n", id);
+			return -ENODEV;
+		}
+
+		for_ifa(in_dev) {
+			/*
+			 * Create a listening socket if id->local_addr
+			 * contains the wildcard IP address OR
+			 * the IP address of the interface.
+			 */
+			if (ipv4_is_zeronet(
+			    to_sockaddr_in(id->local_addr).sin_addr.s_addr) ||
+			    to_sockaddr_in(id->local_addr).sin_addr.s_addr ==
+			    ifa->ifa_address) {
+				laddr.sin_addr.s_addr = ifa->ifa_address;
+
+				l_ip = (u8 *) &laddr.sin_addr.s_addr;
+				dprint(DBG_CM,
+				"(id=0x%p): bind: ipv4=%d.%d.%d.%d, port=%d\n",
+					id, l_ip[0], l_ip[1], l_ip[2],
+					l_ip[3], ntohs(laddr.sin_port));
+
+				rv = siw_listen_address(id, backlog,
+						(struct sockaddr *)&laddr);
+				if (rv)
+					break;
+			}
+		}
+		endfor_ifa(in_dev);
+		in_dev_put(in_dev);
+
+		if (rv && id->provider_data)
+			siw_drop_listeners(id);
+
+	} else {
+		/* IPv6 */
+		rv = -EAFNOSUPPORT;
+		dprint(DBG_CM|DBG_ON, "(id=0x%p): TODO: IPv6 support\n", id);
+	}
+	if (!rv)
+		dprint(DBG_CM, "(id=0x%p): Success\n", id);
+
+	return rv;
+}
+
+
+int siw_destroy_listen(struct iw_cm_id *id)
+{
+
+	dprint(DBG_CM, "(id=0x%p): dev(id)=%s, netdev=%s\n",
+		id, id->device->name,
+		siw_dev_ofa2siw(id->device)->netdev->name);
+
+	if (!id->provider_data) {
+		/*
+		 * TODO: See if there's a way to avoid getting any
+		 *       listener ids without a list of CEPs
+		 */
+		dprint(DBG_CM, "(id=0x%p): Listener id: no CEP(s)\n", id);
+		return 0;
+	}
+	siw_drop_listeners(id);
+	kfree(id->provider_data);
+	id->provider_data = NULL;
+
+	return 0;
+}
+
+int siw_cm_init(void)
+{
+	/*
+	 * create_single_workqueue for strict ordering
+	 */
+	siw_cm_wq = create_singlethread_workqueue("siw_cm_wq");
+	if (!siw_cm_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void siw_cm_exit(void)
+{
+	if (siw_cm_wq) {
+		flush_workqueue(siw_cm_wq);
+		destroy_workqueue(siw_cm_wq);
+	}
+}
diff --git a/drivers/infiniband/sw/siw/siw_cm.h b/drivers/infiniband/sw/siw/siw_cm.h
new file mode 100644
index 000000000000..393c346fda20
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_cm.h
@@ -0,0 +1,154 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *          Greg Joyce <greg-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ * Copyright (c) 2017, Open Grid Computing, Inc. 
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#ifndef _SIW_CM_H
+#define _SIW_CM_H
+
+#include <net/sock.h>
+#include <linux/tcp.h>
+
+#include <rdma/iw_cm.h>
+
+
+enum siw_cep_state {
+	SIW_EPSTATE_IDLE = 1,
+	SIW_EPSTATE_LISTENING,
+	SIW_EPSTATE_CONNECTING,
+	SIW_EPSTATE_AWAIT_MPAREQ,
+	SIW_EPSTATE_RECVD_MPAREQ,
+	SIW_EPSTATE_AWAIT_MPAREP,
+	SIW_EPSTATE_RDMA_MODE,
+	SIW_EPSTATE_CLOSED
+};
+
+struct siw_mpa_info {
+	struct mpa_rr		hdr;	/* peer mpa hdr in host byte order */
+	struct mpa_v2_data	v2_ctrl;
+	struct mpa_v2_data	v2_ctrl_req;
+	char			*pdata;
+	int			bytes_rcvd;
+};
+
+struct siw_llp_info {
+	struct socket		*sock;
+	struct sockaddr_in	laddr;	/* redundant with socket info above */
+	struct sockaddr_in	raddr;	/* dito, consider removal */
+	struct siw_sk_upcalls	sk_def_upcalls;
+};
+
+struct siw_dev;
+
+struct siw_cep {
+	struct iw_cm_id		*cm_id;
+	struct siw_dev		*sdev;
+
+	struct list_head	devq;
+	/*
+	 * The provider_data element of a listener IWCM ID
+	 * refers to a list of one or more listener CEPs
+	 */
+	struct list_head	listenq;
+	struct siw_cep		*listen_cep;
+	struct siw_qp		*qp;
+	spinlock_t		lock;
+	wait_queue_head_t	waitq;
+	struct kref		ref;
+	enum siw_cep_state	state;
+	short			in_use;
+	struct siw_cm_work	*mpa_timer;
+	struct list_head	work_freelist;
+	struct siw_llp_info	llp;
+	struct siw_mpa_info	mpa;
+	int			ord;
+	int			ird;
+	bool			enhanced_rdma_conn_est;
+	int			sk_error; /* not (yet) used XXX */
+
+	/* Saved upcalls of socket llp.sock */
+	void    (*sk_state_change)(struct sock *sk);
+	void    (*sk_data_ready)(struct sock *sk);
+	void    (*sk_write_space)(struct sock *sk);
+	void    (*sk_error_report)(struct sock *sk);
+};
+
+#define MPAREQ_TIMEOUT	(HZ*10)
+#define MPAREP_TIMEOUT	(HZ*5)
+
+enum siw_work_type {
+	SIW_CM_WORK_ACCEPT	= 1,
+	SIW_CM_WORK_READ_MPAHDR,
+	SIW_CM_WORK_CLOSE_LLP,		/* close socket */
+	SIW_CM_WORK_PEER_CLOSE,		/* socket indicated peer close */
+	SIW_CM_WORK_MPATIMEOUT
+};
+
+struct siw_cm_work {
+	struct delayed_work	work;
+	struct list_head	list;
+	enum siw_work_type	type;
+	struct siw_cep	*cep;
+};
+
+/*
+ * With kernel 3.12, OFA ddressing changed from sockaddr_in to
+ * sockaddr_storage
+ */
+#define to_sockaddr_in(a) (*(struct sockaddr_in *)(&(a)))
+
+extern int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *parm);
+extern int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *param);
+extern int siw_reject(struct iw_cm_id *id, const void *data, u8 len);
+extern int siw_create_listen(struct iw_cm_id *id, int backlog);
+extern int siw_destroy_listen(struct iw_cm_id *id);
+
+extern void siw_cep_get(struct siw_cep *cep);
+extern void siw_cep_put(struct siw_cep *cep);
+extern int siw_cm_queue_work(struct siw_cep *cep, enum siw_work_type type);
+
+extern int siw_cm_init(void);
+extern void siw_cm_exit(void);
+
+/*
+ * TCP socket interface
+ */
+#define sk_to_qp(sk)	(((struct siw_cep *)((sk)->sk_user_data))->qp)
+#define sk_to_cep(sk)	((struct siw_cep *)((sk)->sk_user_data))
+
+#endif
diff --git a/drivers/infiniband/sw/siw/siw_cq.c b/drivers/infiniband/sw/siw/siw_cq.c
new file mode 100644
index 000000000000..ce294eda5f7b
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_cq.c
@@ -0,0 +1,164 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/list.h>
+
+#include <rdma/iw_cm.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+
+#include "siw.h"
+#include "siw_obj.h"
+#include "siw_cm.h"
+
+static int siw_wc_op_siw2ofa[SIW_NUM_OPCODES] = {
+	[SIW_OP_WRITE]		= IB_WC_RDMA_WRITE,
+	[SIW_OP_SEND]		= IB_WC_SEND,
+	[SIW_OP_SEND_WITH_IMM]	= IB_WC_SEND,
+	[SIW_OP_READ]		= IB_WC_RDMA_READ,
+	[SIW_OP_READ_LOCAL_INV]	= IB_WC_RDMA_READ,
+	[SIW_OP_COMP_AND_SWAP]	= IB_WC_COMP_SWAP,
+	[SIW_OP_FETCH_AND_ADD]	= IB_WC_FETCH_ADD,
+	[SIW_OP_INVAL_STAG]	= IB_WC_LOCAL_INV,
+	[SIW_OP_REG_MR]		= IB_WC_REG_MR,
+	[SIW_OP_RECEIVE]	= IB_WC_RECV,
+	[SIW_OP_READ_RESPONSE]	= -1 /* not used */
+};
+
+
+static struct {
+	enum siw_opcode   siw;
+	enum ib_wc_opcode ofa;
+} map_cqe_status[SIW_NUM_WC_STATUS] = {
+	{SIW_WC_SUCCESS,		IB_WC_SUCCESS},
+	{SIW_WC_LOC_LEN_ERR,		IB_WC_LOC_LEN_ERR},
+	{SIW_WC_LOC_PROT_ERR,		IB_WC_LOC_PROT_ERR},
+	{SIW_WC_LOC_QP_OP_ERR,		IB_WC_LOC_QP_OP_ERR},
+	{SIW_WC_WR_FLUSH_ERR,		IB_WC_WR_FLUSH_ERR},
+	{SIW_WC_BAD_RESP_ERR,		IB_WC_BAD_RESP_ERR},
+	{SIW_WC_LOC_ACCESS_ERR,		IB_WC_LOC_ACCESS_ERR},
+	{SIW_WC_REM_ACCESS_ERR,		IB_WC_REM_ACCESS_ERR},
+	{SIW_WC_REM_INV_REQ_ERR,	IB_WC_REM_INV_REQ_ERR},
+	{SIW_WC_GENERAL_ERR,		IB_WC_GENERAL_ERR}
+};
+
+/*
+ * translate wc into ofa syntax
+ */
+static void siw_wc_siw2ofa(struct siw_cqe *cqe, struct ib_wc *ofa_wc)
+{
+	memset(ofa_wc, 0, sizeof(*ofa_wc));
+
+	ofa_wc->wr_id = cqe->id;
+	ofa_wc->status = map_cqe_status[cqe->status].ofa;
+	ofa_wc->byte_len = cqe->bytes;
+	ofa_wc->qp = &((struct siw_qp *)cqe->qp)->ofa_qp;
+
+	ofa_wc->opcode = siw_wc_op_siw2ofa[cqe->opcode];
+	/*
+	 * ofa_wc->imm_data = 0;
+	 * ofa_wc->vendor_err = 0;
+	 * ofa_wc->src_qp = 0;
+	 * ofa_wc->wc_flags = 0; ADD immediate data support
+	 * ofa_wc->pkey_index = 0;
+	 * ofa_wc->slid = 0;
+	 * ofa_wc->sl = 0;
+	 * ofa_wc->dlid_path_bits = 0;
+	 * ofa_wc->port_num = 0;
+	 */
+}
+
+/*
+ * Reap one CQE from the CQ.
+ *
+ * Caller must hold qp read lock
+ *
+ * TODO: Provide routine which can read more than one CQE
+ */
+int siw_reap_cqe(struct siw_cq *cq, struct ib_wc *ofa_wc)
+{
+	struct siw_cqe *cqe;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cq->lock, flags);
+
+	cqe = &cq->queue[cq->cq_get % cq->num_cqe];
+	if (cqe->flags & SIW_WQE_VALID) {
+		siw_wc_siw2ofa(cqe, ofa_wc);
+
+		if (cq->kernel_verbs) {
+			dprint(DBG_WR,
+				" QP%d, CQ%d: Reap WQE type: %d at idx %d\n",
+				QP_ID((struct siw_qp *)cqe->qp), OBJ_ID(cq),
+				cqe->opcode, cq->cq_get % cq->num_cqe);
+			siw_qp_put(cqe->qp);
+		}
+		cqe->flags = 0;
+		cq->cq_get++;
+
+		/* Make cqe state visible to all */
+		smp_wmb();
+
+		spin_unlock_irqrestore(&cq->lock, flags);
+		return 1;
+	}
+	spin_unlock_irqrestore(&cq->lock, flags);
+	return 0;
+}
+
+/*
+ * siw_cq_flush()
+ *
+ * Flush all CQ elements. No CQ lock is taken.
+ */
+void siw_cq_flush(struct siw_cq *cq)
+{
+	struct ib_wc wc;
+
+	int got, total = 0;
+
+	dprint(DBG_CM|DBG_OBJ, "(CQ%d:) Enter\n", OBJ_ID(cq));
+
+	do {
+		got = siw_reap_cqe(cq, &wc);
+		total += got;
+	} while (got > 0);
+}
diff --git a/drivers/infiniband/sw/siw/siw_debug.c b/drivers/infiniband/sw/siw/siw_debug.c
new file mode 100644
index 000000000000..4ebca92cfcf1
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_debug.c
@@ -0,0 +1,442 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *          Fredy Neeser <nfd-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <net/tcp.h>
+#include <linux/list.h>
+#include <linux/debugfs.h>
+
+#include <rdma/iw_cm.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+
+#include "siw.h"
+#include "siw_cm.h"
+#include "siw_obj.h"
+
+#define FDENTRY(f) (f->f_path.dentry)
+
+
+static struct dentry *siw_debugfs;
+
+static ssize_t siw_show_qps(struct file *f, char __user *buf, size_t space,
+			    loff_t *ppos)
+{
+	struct siw_dev	*sdev = FDENTRY(f)->d_inode->i_private;
+	struct list_head *pos, *tmp;
+	char *kbuf = NULL;
+	int len = 0, n, num_qp;
+
+	if (*ppos)
+		goto out;
+
+	kbuf = kmalloc(space, GFP_KERNEL);
+	if (!kbuf)
+		goto out;
+
+	num_qp = atomic_read(&sdev->num_qp);
+	if (!num_qp)
+		goto out;
+
+	len = snprintf(kbuf, space, "%s: %d QPs\n", sdev->ofa_dev.name, num_qp);
+	if (len > space) {
+		len = space;
+		goto out;
+	}
+	space -= len;
+	n = snprintf(kbuf + len, space,
+		     "%-15s%-6s%-6s%-5s%-5s%-5s%-5s%-5s%-20s%s\n",
+		     "QP-ID", "State", "Ref's", "SQ", "RQ", "IRQ", "ORQ",
+		     "s/r", "Sock", "CEP");
+
+	if (n > space) {
+		len += space;
+		goto out;
+	}
+	len += n;
+	space -= n;
+
+	list_for_each_safe(pos, tmp, &sdev->qp_list) {
+		struct siw_qp *qp = list_entry(pos, struct siw_qp, devq);
+
+		n = snprintf(kbuf + len, space,
+			"%-15d%-6d%-6d%-5d%-5d%-5d%-5d%d/%-3d0x%-18p0x%-18p\n",
+			     QP_ID(qp),
+			     qp->attrs.state,
+			     refcount_read(&qp->hdr.ref),
+			     qp->attrs.sq_size,
+			     qp->attrs.rq_size,
+			     qp->attrs.irq_size,
+			     qp->attrs.orq_size,
+			     tx_wqe(qp) ? 1 : 0,
+			     rx_wqe(qp) ? 1 : 0,
+			     qp->attrs.llp_stream_handle,
+			     qp->cep);
+		if (n < space) {
+			len += n;
+			space -= n;
+		} else {
+			len += space;
+			break;
+		}
+	}
+out:
+	if (len)
+		len = simple_read_from_buffer(buf, len, ppos, kbuf, len);
+
+	kfree(kbuf);
+
+	return len;
+};
+
+static ssize_t siw_show_ceps(struct file *f, char __user *buf, size_t space,
+			     loff_t *ppos)
+{
+	struct siw_dev	*sdev = FDENTRY(f)->d_inode->i_private;
+	struct list_head *pos, *tmp;
+	char *kbuf = NULL;
+	int len = 0, n, num_cep;
+
+	if (*ppos)
+		goto out;
+
+	kbuf = kmalloc(space, GFP_KERNEL);
+	if (!kbuf)
+		goto out;
+
+	num_cep = atomic_read(&sdev->num_cep);
+	if (!num_cep)
+		goto out;
+
+	len = snprintf(kbuf, space, "%s: %d CEPs\n", sdev->ofa_dev.name,
+		       num_cep);
+	if (len > space) {
+		len = space;
+		goto out;
+	}
+	space -= len;
+
+	n = snprintf(kbuf + len, space,
+		     "%-20s%-6s%-6s%-9s%-5s%-3s%-4s%-21s%-9s\n",
+		     "CEP", "State", "Ref's", "QP-ID", "LQ", "LC", "U", "Sock",
+		     "CM-ID");
+
+	if (n > space) {
+		len += space;
+		goto out;
+	}
+	len += n;
+	space -= n;
+
+	list_for_each_safe(pos, tmp, &sdev->cep_list) {
+		struct siw_cep *cep = list_entry(pos, struct siw_cep, devq);
+
+		n = snprintf(kbuf + len, space,
+			     "0x%-18p%-6d%-6d%-9d%-5s%-3s%-4d0x%-18p 0x%-16p\n",
+			     cep, cep->state,
+			     refcount_read(&cep->ref),
+			     cep->qp ? QP_ID(cep->qp) : -1,
+			     list_empty(&cep->listenq) ? "n" : "y",
+			     cep->listen_cep ? "y" : "n",
+			     cep->in_use,
+			     cep->llp.sock,
+			     cep->cm_id);
+		if (n < space) {
+			len += n;
+			space -= n;
+		} else {
+			len += space;
+			break;
+		}
+	}
+out:
+	if (len)
+		len = simple_read_from_buffer(buf, len, ppos, kbuf, len);
+
+	kfree(kbuf);
+
+	return len;
+};
+
+static ssize_t siw_show_stats(struct file *f, char __user *buf, size_t space,
+			      loff_t *ppos)
+{
+	struct siw_dev	*sdev = FDENTRY(f)->d_inode->i_private;
+	char *kbuf = NULL;
+	int len = 0;
+
+	if (*ppos)
+		goto out;
+
+	kbuf = kmalloc(space, GFP_KERNEL);
+	if (!kbuf)
+		goto out;
+
+	len =  snprintf(kbuf, space, "Allocated SIW Objects:\n"
+		"Device %s (%s):\t"
+		"%s: %d, %s %d, %s: %d, %s: %d, %s: %d, %s: %d, %s: %d\n",
+		sdev->ofa_dev.name,
+		sdev->netdev->flags & IFF_UP ? "IFF_UP" : "IFF_DOWN",
+		"CXs", atomic_read(&sdev->num_ctx),
+		"PDs", atomic_read(&sdev->num_pd),
+		"QPs", atomic_read(&sdev->num_qp),
+		"CQs", atomic_read(&sdev->num_cq),
+		"SRQs", atomic_read(&sdev->num_srq),
+		"MRs", atomic_read(&sdev->num_mem),
+		"CEPs", atomic_read(&sdev->num_cep));
+	if (len > space)
+		len = space;
+out:
+	if (len)
+		len = simple_read_from_buffer(buf, len, ppos, kbuf, len);
+
+	kfree(kbuf);
+	return len;
+}
+
+static const struct file_operations siw_qp_debug_fops = {
+	.owner	= THIS_MODULE,
+	.read	= siw_show_qps
+};
+
+static const struct file_operations siw_cep_debug_fops = {
+	.owner	= THIS_MODULE,
+	.read	= siw_show_ceps
+};
+
+static const struct file_operations siw_stats_debug_fops = {
+	.owner	= THIS_MODULE,
+	.read	= siw_show_stats
+};
+
+void siw_debugfs_add_device(struct siw_dev *sdev)
+{
+	struct dentry	*entry;
+
+	if (!siw_debugfs)
+		return;
+
+	sdev->debugfs = debugfs_create_dir(sdev->ofa_dev.name, siw_debugfs);
+	if (sdev->debugfs) {
+		entry = debugfs_create_file("qp", 0400, sdev->debugfs,
+					    (void *)sdev, &siw_qp_debug_fops);
+		if (!entry)
+			dprint(DBG_DM, ": could not create 'qp' entry\n");
+
+		entry = debugfs_create_file("cep", 0400, sdev->debugfs,
+					    (void *)sdev, &siw_cep_debug_fops);
+		if (!entry)
+			dprint(DBG_DM, ": could not create 'cep' entry\n");
+
+		entry = debugfs_create_file("stats", 0400, sdev->debugfs,
+					    (void *)sdev,
+					    &siw_stats_debug_fops);
+		if (!entry)
+			dprint(DBG_DM, ": could not create 'stats' entry\n");
+	}
+}
+
+void siw_debugfs_del_device(struct siw_dev *sdev)
+{
+	debugfs_remove_recursive(sdev->debugfs);
+	sdev->debugfs = NULL;
+}
+
+void siw_debug_init(void)
+{
+	siw_debugfs = debugfs_create_dir("siw", NULL);
+
+	if (!siw_debugfs || siw_debugfs == ERR_PTR(-ENODEV)) {
+		dprint(DBG_DM, ": could not init debugfs\n");
+		siw_debugfs = NULL;
+	}
+}
+
+void siw_debugfs_delete(void)
+{
+	debugfs_remove_recursive(siw_debugfs);
+	siw_debugfs = NULL;
+}
+
+void siw_print_qp_attr_mask(enum ib_qp_attr_mask attr_mask, char *msg)
+{
+	pr_info("-------- %s -------\n", msg);
+	if (IB_QP_STATE & attr_mask)
+		pr_info("IB_QP_STATE\n");
+	if (IB_QP_CUR_STATE & attr_mask)
+		pr_info("IB_QP_CUR_STATE\n");
+	if (IB_QP_EN_SQD_ASYNC_NOTIFY & attr_mask)
+		pr_info("IB_QP_EN_SQD_ASYNC_NOTIFY\n");
+	if (IB_QP_ACCESS_FLAGS & attr_mask)
+		pr_info("IB_QP_ACCESS_FLAGS\n");
+	if (IB_QP_PKEY_INDEX & attr_mask)
+		pr_info("IB_QP_PKEY_INDEX\n");
+	if (IB_QP_PORT & attr_mask)
+		pr_info("IB_QP_PORT\n");
+	if (IB_QP_QKEY & attr_mask)
+		pr_info("IB_QP_QKEY\n");
+	if (IB_QP_AV & attr_mask)
+		pr_info("IB_QP_AV\n");
+	if (IB_QP_PATH_MTU & attr_mask)
+		pr_info("IB_QP_PATH_MTU\n");
+	if (IB_QP_TIMEOUT & attr_mask)
+		pr_info("IB_QP_TIMEOUT\n");
+	if (IB_QP_RETRY_CNT & attr_mask)
+		pr_info("IB_QP_RETRY_CNT\n");
+	if (IB_QP_RNR_RETRY & attr_mask)
+		pr_info("IB_QP_RNR_RETRY\n");
+	if (IB_QP_RQ_PSN & attr_mask)
+		pr_info("IB_QP_RQ_PSN\n");
+	if (IB_QP_MAX_QP_RD_ATOMIC & attr_mask)
+		pr_info("IB_QP_MAX_QP_RD_ATOMIC\n");
+	if (IB_QP_ALT_PATH & attr_mask)
+		pr_info("IB_QP_ALT_PATH\n");
+	if (IB_QP_MIN_RNR_TIMER & attr_mask)
+		pr_info("IB_QP_MIN_RNR_TIMER\n");
+	if (IB_QP_SQ_PSN & attr_mask)
+		pr_info("IB_QP_SQ_PSN\n");
+	if (IB_QP_MAX_DEST_RD_ATOMIC & attr_mask)
+		pr_info("IB_QP_MAX_DEST_RD_ATOMIC\n");
+	if (IB_QP_PATH_MIG_STATE & attr_mask)
+		pr_info("IB_QP_PATH_MIG_STATE\n");
+	if (IB_QP_CAP & attr_mask)
+		pr_info("IB_QP_CAP\n");
+	if (IB_QP_DEST_QPN & attr_mask)
+		pr_info("IB_QP_DEST_QPN\n");
+	pr_info("-------- %s -(end)-\n", msg);
+}
+
+void siw_print_hdr(union iwarp_hdrs *hdr, int qp_id, char *msg)
+{
+	switch (__rdmap_opcode(&hdr->ctrl)) {
+
+	case RDMAP_RDMA_WRITE:
+		pr_info("QP%04d %s(WRITE, MPA len %d): %08x %016llx\n",
+			qp_id, msg, ntohs(hdr->ctrl.mpa_len),
+			hdr->rwrite.sink_stag, hdr->rwrite.sink_to);
+		break;
+
+	case RDMAP_RDMA_READ_REQ:
+		pr_info("QP%04d %s(RREQ, MPA len %d): %08x %08x "
+			"%08x %08x %016llx %08x %08x %016llx\n",
+			qp_id, msg,
+			ntohs(hdr->ctrl.mpa_len),
+			hdr->rreq.ddp_qn, hdr->rreq.ddp_msn,
+			hdr->rreq.ddp_mo, hdr->rreq.sink_stag,
+			hdr->rreq.sink_to, hdr->rreq.read_size,
+			hdr->rreq.source_stag, hdr->rreq.source_to);
+
+		break;
+	case RDMAP_RDMA_READ_RESP:
+		pr_info("QP%04d %s(RRESP, MPA len %d): %08x %016llx\n",
+			qp_id, msg, ntohs(hdr->ctrl.mpa_len),
+			hdr->rresp.sink_stag, hdr->rresp.sink_to);
+		break;
+
+	case RDMAP_SEND:
+		pr_info("QP%04d %s(SEND, MPA len %d): %08x %08x %08x\n",
+			qp_id, msg, ntohs(hdr->ctrl.mpa_len),
+			hdr->send.ddp_qn, hdr->send.ddp_msn, hdr->send.ddp_mo);
+		break;
+
+	case RDMAP_SEND_INVAL:
+		pr_info("QP%04d %s(S_INV, MPA len %d): %08x %08x %08x\n",
+			qp_id, msg, ntohs(hdr->ctrl.mpa_len),
+			hdr->send.ddp_qn, hdr->send.ddp_msn,
+			hdr->send.ddp_mo);
+		break;
+
+	case RDMAP_SEND_SE:
+		pr_info("QP%04d %s(S_SE, MPA len %d): %08x %08x %08x\n",
+			qp_id, msg, ntohs(hdr->ctrl.mpa_len),
+			hdr->send.ddp_qn, hdr->send.ddp_msn,
+			hdr->send.ddp_mo);
+		break;
+
+	case RDMAP_SEND_SE_INVAL:
+		pr_info("QP%04d %s(S_SE_INV, MPA len %d): %08x %08x %08x\n",
+			qp_id, msg, ntohs(hdr->ctrl.mpa_len),
+			hdr->send.ddp_qn, hdr->send.ddp_msn,
+			hdr->send.ddp_mo);
+		break;
+
+	case RDMAP_TERMINATE:
+		pr_info("QP%04d %s(TERM, MPA len %d):\n", qp_id, msg,
+			ntohs(hdr->ctrl.mpa_len));
+		break;
+
+	default:
+		pr_info("QP%04d %s ?????\n", qp_id, msg);
+		break;
+	}
+}
+
+void siw_print_rctx(struct siw_iwarp_rx *rctx)
+{
+	pr_info("---RX Context---\n");
+	siw_print_hdr(&rctx->hdr, RX_QPID(rctx), "\nCurrent Pkt:\t");
+	pr_info("Skbuf State:\tp:0x%p, new:%d, off:%d, copied:%d\n",
+		rctx->skb, rctx->skb_new, rctx->skb_offset, rctx->skb_copied);
+	pr_info("FPDU State:\trx_state:%d,\n\t\trcvd:%d, rem:%d, pad:%d\n",
+		rctx->state, rctx->fpdu_part_rcvd,
+		rctx->fpdu_part_rem, rctx->pad);
+	pr_info("Rx Mem:\t\tp:0x%p, stag:0x%08x, mem_id:%d\n",
+		&rctx->wqe_active, rctx->ddp_stag, rctx->ddp_stag >> 8);
+	pr_info("DDP State:\tprev_op:%d, first_seg:%d, more_segs:%d\n",
+		rctx->prev_rdmap_opcode, rctx->first_ddp_seg,
+		rctx->more_ddp_segs);
+	pr_info("MPA State:\tlen:%d, crc_enabled:%d, crc:0x%x\n",
+		ntohs(rctx->hdr.ctrl.mpa_len), rctx->mpa_crc_hd ? 1 : 0,
+		rctx->trailer.crc);
+	pr_info("----------------\n");
+}
+
+#if DPRINT_MASK > 0
+char ib_qp_state_to_string[IB_QPS_ERR+1][sizeof "RESET"] = {
+	[IB_QPS_RESET]	= "RESET",
+	[IB_QPS_INIT]	= "INIT",
+	[IB_QPS_RTR]	= "RTR",
+	[IB_QPS_RTS]	= "RTS",
+	[IB_QPS_SQD]	= "SQD",
+	[IB_QPS_SQE]	= "SQE",
+	[IB_QPS_ERR]	= "ERR"
+};
+#endif
diff --git a/drivers/infiniband/sw/siw/siw_debug.h b/drivers/infiniband/sw/siw/siw_debug.h
new file mode 100644
index 000000000000..2f5327945d2f
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_debug.h
@@ -0,0 +1,178 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Fredy Neeser <nfd-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *          Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#ifndef _SIW_DEBUG_H
+#define _SIW_DEBUG_H
+
+#include <linux/uaccess.h>
+#include <linux/hardirq.h>	/* in_interrupt() */
+
+/*
+ * dprint: Selective debug printing
+ *
+ * Use an OR combination of DBG_* as dbgcat in dprint*(dbgcat,...)
+ * to assign debug messages to categories:
+ *
+ * dbgcat	Debug message belongs to category
+ * ----------------------------------------------------------------------------
+ * DBG_ON	Always on, for really important events or error conditions
+ * DBG_TMP	Temporarily on for fine-grained debugging
+ * DBQ_OBJ	Object management (object construction/destruction/refcounting)
+ * DBG_MM	Memory management
+ * DBG_EH	Event handling (completion events and asynchronous events)
+ * DBG_CM	Connection management, QP states
+ * DBG_WR	Work requests
+ * DBG_TX	iWARP TX path
+ * DBG_RX	iWARP RX path
+ * DBG_SK	Socket operations
+ * DBG_IRQ	Interrupt context (SoftIRQ or HardIRQ)
+ * DBG_DM	Device management
+ * DBG_HDR	Packet HDRs
+ * DBG_ALL	All categories above
+ */
+#define DBG_OFF		0
+#define DBG_ON		0x00000001
+#define DBG_TMP		0x00000002
+#define DBG_OBJ		0x00000004
+#define DBG_MM		0x00000008
+#define DBG_EH		0x00000010
+#define DBG_CM		0x00000020
+#define DBG_WR		0x00000040
+#define DBG_TX		0x00000080
+#define DBG_RX		0x00000100
+#define DBG_SK		0x00000200
+#define DBG_IRQ		0x00000800
+#define DBG_DM		0x00001000
+#define DBG_HDR		0x00002000
+#define DBG_CQ		0x00004000
+#define DBG_ALL		(DBG_IRQ|DBG_SK|DBG_RX|DBG_TX|DBG_WR|\
+			DBG_CM|DBG_EH|DBG_MM|DBG_OBJ|DBG_TMP|\
+			DBG_DM|DBG_ON|DBG_HDR|DBG_CQ)
+#define DBG_ALL_NOHDR	(DBG_IRQ|DBG_SK|DBG_RX|DBG_TX|DBG_WR|\
+			DBG_CM|DBG_EH|DBG_MM|DBG_OBJ|DBG_TMP|\
+			DBG_DM|DBG_ON)
+#define DBG_CTRL	(DBG_ON|DBG_CM|DBG_DM)
+
+/*
+ * Set DPRINT_MASK to tailor your debugging needs:
+ *
+ * DPRINT_MASK value		Enables debug messages for
+ * ---------------------------------------------------------------------
+ * DBG_ON			Important events / error conditions only
+ *				(minimum number of debug messages)
+ * OR-ed combination of DBG_*	Selective debugging
+ * DBG_TX|DBG_ON		+ transmit path
+ * DBG_ALL			All categories
+ */
+#define DPRINT_MASK	(DBG_ON)
+
+struct siw_dev;
+struct siw_iwarp_rx;
+union iwarp_hdrs;
+
+extern void siw_debug_init(void);
+extern void siw_debugfs_add_device(struct siw_dev *dev);
+extern void siw_debugfs_del_device(struct siw_dev *dev);
+extern void siw_debugfs_delete(void);
+
+extern void siw_print_hdr(union iwarp_hdrs *hdr, int id, char *msg);
+extern void siw_print_rctx(struct siw_iwarp_rx *rctx);
+extern void siw_print_qp_attr_mask(enum ib_qp_attr_mask mask, char *msg);
+
+#ifndef refcount_read
+#define refcount_read(x)	atomic_read(x.refcount.refs)
+#endif
+
+#if DPRINT_MASK > 0
+
+/**
+ * dprint - Selective debug print for process, SoftIRQ or HardIRQ context
+ *
+ * Debug print with selectable debug categories,
+ * starting with header
+ * - "( pid /cpu) __func__" for process context
+ * - "( irq /cpu) __func__" for IRQ context
+ *
+ * @dbgcat	: Set of debug categories (OR-ed combination of DBG_* above),
+ *		  to which this debug message is assigned.
+ * @fmt		: printf compliant format string
+ * @args	: printf compliant argument list
+ */
+#define dprint(dbgcat, fmt, args...)				\
+	do {							\
+		if ((dbgcat) & DPRINT_MASK) {			\
+			if (!in_interrupt())			\
+				pr_info("(%5d/%1d) %s" fmt,	\
+					current->pid,		\
+					current->on_cpu,	\
+					__func__, ## args);	\
+			else					\
+				pr_info("( irq /%1d) %s" fmt,	\
+					current->on_cpu,	\
+					__func__, ## args);	\
+		}						\
+	} while (0)
+
+
+#define siw_dprint_rctx(r)	siw_print_rctx(r)
+
+extern char ib_qp_state_to_string[IB_QPS_ERR+1][sizeof "RESET"];
+
+#else
+
+#define dprint(dbgcat, fmt, args...)	do { } while (0)
+#define siw_dprint_rctx(r)	do { } while (0)
+
+#endif
+
+
+#if DPRINT_MASK & DBG_HDR
+#define siw_dprint_hdr(h, i, m)	siw_print_hdr(h, i, m)
+#else
+#define siw_dprint_hdr(h, i, m)	do { } while (0)
+#endif
+
+#if DPRINT_MASK & DBG_CM
+#define siw_dprint_qp_attr_mask(mask)\
+		siw_print_qp_attr_mask(mask, (char *)__func__)
+#else
+#define siw_dprint_qp_attr_mask(mask)	do { } while (0)
+#endif
+
+#endif
diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
new file mode 100644
index 000000000000..2efd4a02c39a
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -0,0 +1,754 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/netdevice.h>
+#include <linux/inetdevice.h>
+#include <net/net_namespace.h>
+#include <linux/rtnetlink.h>
+#include <linux/if_arp.h>
+#include <linux/list.h>
+#include <linux/kernel.h>
+#include <linux/dma-mapping.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+
+#include "siw.h"
+#include "siw_obj.h"
+#include "siw_cm.h"
+#include "siw_verbs.h"
+#include <linux/kthread.h>
+
+
+MODULE_AUTHOR("Bernard Metzler");
+MODULE_DESCRIPTION("Software iWARP Driver");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION("0.2");
+
+extern bool mpa_crc_required;
+
+#define SIW_MAX_IF 12
+static int if_cnt;
+static char *iface_list[SIW_MAX_IF] = {[0 ... (SIW_MAX_IF-1)] = '\0'};
+module_param_array(iface_list, charp, &if_cnt, 0444);
+MODULE_PARM_DESC(iface_list, "Interface list siw attaches to if present");
+
+static bool loopback_enabled = 1;
+module_param(loopback_enabled, bool, 0644);
+MODULE_PARM_DESC(loopback_enabled, "enable_loopback");
+
+LIST_HEAD(siw_devlist);
+
+static int cpu_cnt;
+static char *tx_cpu_list[MAX_CPU] = {[0 ... (MAX_CPU-1)] = '\0'};
+module_param_array(tx_cpu_list, charp, &cpu_cnt, 0444);
+MODULE_PARM_DESC(tx_cpu_list, "List of CPUs siw TX thread shall be bound to");
+
+int default_tx_cpu = -1;
+struct task_struct *qp_tx_thread[MAX_CPU];
+struct crypto_shash *siw_crypto_shash;
+
+static ssize_t show_sw_version(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct siw_dev *sdev = container_of(dev, struct siw_dev, ofa_dev.dev);
+
+	return sprintf(buf, "%x\n", sdev->attrs.version);
+}
+
+static DEVICE_ATTR(sw_version, 0444, show_sw_version, NULL);
+
+static struct device_attribute *siw_dev_attributes[] = {
+	&dev_attr_sw_version
+};
+
+static void siw_device_release(struct device *dev)
+{
+	pr_info("%s device released\n", dev_name(dev));
+}
+
+static struct device siw_generic_dma_device = {
+	.dma_ops		= &siw_dma_generic_ops,
+	.init_name		= "software-rdma-v2",
+	.release		= siw_device_release
+};
+
+static struct bus_type siw_bus = {
+	.name = "siw",
+};
+
+static int siw_modify_port(struct ib_device *ofa_dev, u8 port, int mask,
+			   struct ib_port_modify *props)
+{
+	return -EOPNOTSUPP;
+}
+
+
+static void siw_device_register(struct siw_dev *sdev)
+{
+	struct ib_device *ofa_dev = &sdev->ofa_dev;
+	int rv, i;
+	static int dev_id = 1;
+
+	rv = ib_register_device(ofa_dev, NULL);
+	if (rv) {
+		dprint(DBG_DM|DBG_ON, " %s: ib register error: rv=%d\n",
+			ofa_dev->name, rv);
+		return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(siw_dev_attributes); ++i) {
+		rv = device_create_file(&ofa_dev->dev, siw_dev_attributes[i]);
+		if (rv) {
+			dprint(DBG_DM|DBG_ON, " %s: create file error: rv=%d\n",
+				ofa_dev->name, rv);
+			ib_unregister_device(ofa_dev);
+			return;
+		}
+	}
+	siw_debugfs_add_device(sdev);
+
+	sdev->attrs.vendor_part_id = dev_id++;
+
+	dprint(DBG_DM, ": '%s' at '%s', HWaddr=%02x.%02x.%02x.%02x.%02x.%02x\n",
+		ofa_dev->name, sdev->netdev->name,
+		*(u8 *)sdev->netdev->dev_addr,
+		*((u8 *)sdev->netdev->dev_addr + 1),
+		*((u8 *)sdev->netdev->dev_addr + 2),
+		*((u8 *)sdev->netdev->dev_addr + 3),
+		*((u8 *)sdev->netdev->dev_addr + 4),
+		*((u8 *)sdev->netdev->dev_addr + 5));
+
+	sdev->is_registered = 1;
+}
+
+static void siw_device_deregister(struct siw_dev *sdev)
+{
+	int i;
+
+	siw_debugfs_del_device(sdev);
+
+	if (sdev->is_registered) {
+
+		dprint(DBG_DM, ": deregister %s at %s\n", sdev->ofa_dev.name,
+			sdev->netdev->name);
+
+		for (i = 0; i < ARRAY_SIZE(siw_dev_attributes); ++i)
+			device_remove_file(&sdev->ofa_dev.dev,
+					   siw_dev_attributes[i]);
+
+		ib_unregister_device(&sdev->ofa_dev);
+	}
+	if (atomic_read(&sdev->num_ctx) || atomic_read(&sdev->num_srq) ||
+	    atomic_read(&sdev->num_mem) || atomic_read(&sdev->num_cep) ||
+	    atomic_read(&sdev->num_qp) || atomic_read(&sdev->num_cq) ||
+	    atomic_read(&sdev->num_pd)) {
+		pr_warn("SIW at %s: orphaned resources!\n", sdev->netdev->name);
+		pr_warn("CTX %d, SRQ %d, QP %d, CQ %d, MEM %d, CEP %d, PD %d\n",
+			atomic_read(&sdev->num_ctx),
+			atomic_read(&sdev->num_srq),
+			atomic_read(&sdev->num_qp),
+			atomic_read(&sdev->num_cq),
+			atomic_read(&sdev->num_mem),
+			atomic_read(&sdev->num_cep),
+			atomic_read(&sdev->num_pd));
+	}
+	i = 0;
+
+	while (!list_empty(&sdev->cep_list)) {
+		struct siw_cep *cep = list_entry(sdev->cep_list.next,
+						 struct siw_cep, devq);
+		list_del(&cep->devq);
+		dprint(DBG_ON, ": Free CEP (0x%p), state: %d\n",
+			cep, cep->state);
+		kfree(cep);
+		i++;
+	}
+	if (i)
+		pr_warn("siw_device_deregister: free'd %d CEPs\n", i);
+
+	sdev->is_registered = 0;
+}
+
+static void siw_device_destroy(struct siw_dev *sdev)
+{
+	dprint(DBG_DM, ": destroy siw device at %s\n", sdev->netdev->name);
+
+	siw_idr_release(sdev);
+	kfree(sdev->ofa_dev.iwcm);
+	dev_put(sdev->netdev);
+	ib_dealloc_device(&sdev->ofa_dev);
+}
+
+
+static int siw_match_iflist(struct net_device *dev)
+{
+	int i;
+
+	if (if_cnt == 0)
+		return 1;
+
+	if_cnt = min((int)SIW_MAX_IF, if_cnt);
+
+	for (i = 0; i < if_cnt; i++)
+		if (!strcmp(iface_list[i], dev->name))
+			return 1;
+	return 0;
+}
+
+static struct siw_dev *siw_dev_from_netdev(struct net_device *dev)
+{
+	if (!list_empty(&siw_devlist)) {
+		struct list_head *pos;
+
+		list_for_each(pos, &siw_devlist) {
+			struct siw_dev *sdev =
+				list_entry(pos, struct siw_dev, list);
+			if (sdev->netdev == dev)
+				return sdev;
+		}
+	}
+	return NULL;
+}
+
+static int siw_tx_qualified(int cpu)
+{
+	int i;
+
+	if (cpu_cnt == 0)
+		return 1;
+
+	for (i = 0; i < cpu_cnt; i++) {
+		int new_cpu;
+	       
+		if (kstrtoint(tx_cpu_list[i], 0, &new_cpu))
+			continue;
+		if (cpu == new_cpu)
+			return 1;
+	}
+	return 0;
+}
+
+static int siw_create_tx_threads(int max_threads, int check_qualified)
+{
+	int cpu, rv, assigned = 0;
+
+	if (max_threads < 0 || max_threads > MAX_CPU)
+		return 0;
+
+	for_each_online_cpu(cpu) {
+		if (siw_tx_qualified(cpu)) {
+			qp_tx_thread[cpu] =
+				kthread_create(siw_run_sq,
+					(unsigned long *)(long)cpu,
+					"qp_tx_thread/%d", cpu);
+			kthread_bind(qp_tx_thread[cpu], cpu);
+			if (IS_ERR(qp_tx_thread)) {
+				rv = PTR_ERR(qp_tx_thread);
+				qp_tx_thread[cpu] = NULL;
+				pr_info("Binding TX thread to CPU %d failed",
+					cpu);
+				break;
+			}
+			wake_up_process(qp_tx_thread[cpu]);
+			assigned++;
+			if (default_tx_cpu < 0)
+				default_tx_cpu = cpu;
+			if (assigned >= max_threads)
+				break;
+		}
+	}
+	return assigned;
+}
+
+static int siw_dev_qualified(struct net_device *netdev)
+{
+	if (!siw_match_iflist(netdev)) {
+		dprint(DBG_DM, ": %s (not selected)\n",
+			netdev->name);
+		return 0;
+	}
+	/*
+	 * Additional hardware support can be added here
+	 * (e.g. ARPHRD_FDDI, ARPHRD_ATM, ...) - see
+	 * <linux/if_arp.h> for type identifiers.
+	 */
+	if (netdev->type == ARPHRD_ETHER ||
+	    netdev->type == ARPHRD_IEEE802 ||
+	    netdev->type == ARPHRD_INFINIBAND ||
+	    (netdev->type == ARPHRD_LOOPBACK && loopback_enabled))
+		return 1;
+
+	return 0;
+}
+
+static void siw_verbs_sq_flush(struct ib_qp *ofa_qp)
+{
+	struct siw_qp *qp = siw_qp_ofa2siw(ofa_qp);
+
+	down_write(&qp->state_lock);
+	siw_sq_flush(qp);
+	up_write(&qp->state_lock);
+}
+
+static void siw_verbs_rq_flush(struct ib_qp *ofa_qp)
+{
+	struct siw_qp *qp = siw_qp_ofa2siw(ofa_qp);
+
+	down_write(&qp->state_lock);
+	siw_rq_flush(qp);
+	up_write(&qp->state_lock);
+}
+
+static struct ib_ah *siw_create_ah(struct ib_pd *pd, struct rdma_ah_attr *attr,
+				   struct ib_udata *udata)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static int siw_destroy_ah(struct ib_ah *ah)
+{
+	return -EOPNOTSUPP;
+}
+
+
+static struct siw_dev *siw_device_create(struct net_device *netdev)
+{
+	struct siw_dev *sdev = (struct siw_dev *)ib_alloc_device(sizeof(*sdev));
+	struct ib_device *ofa_dev;
+
+	if (!sdev)
+		goto out;
+
+	ofa_dev = &sdev->ofa_dev;
+
+	ofa_dev->iwcm = kmalloc(sizeof(struct iw_cm_verbs), GFP_KERNEL);
+	if (!ofa_dev->iwcm) {
+		ib_dealloc_device(ofa_dev);
+		sdev = NULL;
+		goto out;
+	}
+
+	sdev->netdev = netdev;
+	list_add_tail(&sdev->list, &siw_devlist);
+
+	strcpy(ofa_dev->name, SIW_IBDEV_PREFIX);
+	strlcpy(ofa_dev->name + strlen(SIW_IBDEV_PREFIX), netdev->name,
+		IB_DEVICE_NAME_MAX - strlen(SIW_IBDEV_PREFIX));
+
+	memset(&ofa_dev->node_guid, 0, sizeof(ofa_dev->node_guid));
+	if (netdev->type != ARPHRD_LOOPBACK)
+		memcpy(&ofa_dev->node_guid, netdev->dev_addr, 6);
+	else {
+		/*
+		 * The loopback device does not have a HW address,
+		 * but connection mangagement lib expects gid != 0
+		 */
+		size_t gidlen = min_t(size_t, strlen(ofa_dev->name), 6);
+
+		memcpy(&ofa_dev->node_guid, ofa_dev->name, gidlen);
+	}
+	ofa_dev->owner = THIS_MODULE;
+
+	ofa_dev->uverbs_cmd_mask =
+	    (1ull << IB_USER_VERBS_CMD_GET_CONTEXT) |
+	    (1ull << IB_USER_VERBS_CMD_QUERY_DEVICE) |
+	    (1ull << IB_USER_VERBS_CMD_QUERY_PORT) |
+	    (1ull << IB_USER_VERBS_CMD_ALLOC_PD) |
+	    (1ull << IB_USER_VERBS_CMD_DEALLOC_PD) |
+	    (1ull << IB_USER_VERBS_CMD_REG_MR) |
+	    (1ull << IB_USER_VERBS_CMD_DEREG_MR) |
+	    (1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL) |
+	    (1ull << IB_USER_VERBS_CMD_CREATE_CQ) |
+	    (1ull << IB_USER_VERBS_CMD_POLL_CQ) |
+	    (1ull << IB_USER_VERBS_CMD_REQ_NOTIFY_CQ) |
+	    (1ull << IB_USER_VERBS_CMD_DESTROY_CQ) |
+	    (1ull << IB_USER_VERBS_CMD_CREATE_QP) |
+	    (1ull << IB_USER_VERBS_CMD_QUERY_QP) |
+	    (1ull << IB_USER_VERBS_CMD_MODIFY_QP) |
+	    (1ull << IB_USER_VERBS_CMD_DESTROY_QP) |
+	    (1ull << IB_USER_VERBS_CMD_POST_SEND) |
+	    (1ull << IB_USER_VERBS_CMD_POST_RECV) |
+	    (1ull << IB_USER_VERBS_CMD_CREATE_SRQ) |
+	    (1ull << IB_USER_VERBS_CMD_MODIFY_SRQ) |
+	    (1ull << IB_USER_VERBS_CMD_QUERY_SRQ) |
+	    (1ull << IB_USER_VERBS_CMD_DESTROY_SRQ) |
+	    (1ull << IB_USER_VERBS_CMD_REG_MR) |
+	    (1ull << IB_USER_VERBS_CMD_DEREG_MR) |
+	    (1ull << IB_USER_VERBS_CMD_POST_SRQ_RECV);
+
+	ofa_dev->node_type = RDMA_NODE_RNIC;
+	memcpy(ofa_dev->node_desc, SIW_NODE_DESC_COMMON,
+	       sizeof(SIW_NODE_DESC_COMMON));
+
+	/*
+	 * Current model (one-to-one device association):
+	 * One Softiwarp device per net_device or, equivalently,
+	 * per physical port.
+	 */
+	ofa_dev->phys_port_cnt = 1;
+
+	ofa_dev->num_comp_vectors = num_possible_cpus();
+	ofa_dev->dev.parent = &siw_generic_dma_device;
+	ofa_dev->query_device = siw_query_device;
+	ofa_dev->query_port = siw_query_port;
+	ofa_dev->get_port_immutable = siw_get_port_immutable;
+	ofa_dev->query_qp = siw_query_qp;
+	ofa_dev->modify_port = siw_modify_port;
+	ofa_dev->query_pkey = siw_query_pkey;
+	ofa_dev->query_gid = siw_query_gid;
+	ofa_dev->alloc_ucontext = siw_alloc_ucontext;
+	ofa_dev->dealloc_ucontext = siw_dealloc_ucontext;
+	ofa_dev->mmap = siw_mmap;
+	ofa_dev->alloc_pd = siw_alloc_pd;
+	ofa_dev->dealloc_pd = siw_dealloc_pd;
+	ofa_dev->create_ah = siw_create_ah;
+	ofa_dev->destroy_ah = siw_destroy_ah;
+	ofa_dev->create_qp = siw_create_qp;
+	ofa_dev->modify_qp = siw_verbs_modify_qp;
+	ofa_dev->destroy_qp = siw_destroy_qp;
+	ofa_dev->create_cq = siw_create_cq;
+	ofa_dev->destroy_cq = siw_destroy_cq;
+	ofa_dev->resize_cq = NULL;
+	ofa_dev->poll_cq = siw_poll_cq;
+	ofa_dev->get_dma_mr = siw_get_dma_mr;
+	ofa_dev->reg_user_mr = siw_reg_user_mr;
+	ofa_dev->dereg_mr = siw_dereg_mr;
+	ofa_dev->alloc_mr = siw_alloc_mr;
+	ofa_dev->map_mr_sg = siw_map_mr_sg;
+	ofa_dev->dealloc_mw = NULL;
+
+	ofa_dev->create_srq = siw_create_srq;
+	ofa_dev->modify_srq = siw_modify_srq;
+	ofa_dev->query_srq = siw_query_srq;
+	ofa_dev->destroy_srq = siw_destroy_srq;
+	ofa_dev->post_srq_recv = siw_post_srq_recv;
+
+	ofa_dev->attach_mcast = NULL;
+	ofa_dev->detach_mcast = NULL;
+	ofa_dev->process_mad = siw_no_mad;
+
+	ofa_dev->req_notify_cq = siw_req_notify_cq;
+	ofa_dev->post_send = siw_post_send;
+	ofa_dev->post_recv = siw_post_receive;
+
+	ofa_dev->drain_sq = siw_verbs_sq_flush;
+	ofa_dev->drain_rq = siw_verbs_rq_flush;
+
+	ofa_dev->dev.dma_ops = &dma_virt_ops;
+
+	ofa_dev->iwcm->connect = siw_connect;
+	ofa_dev->iwcm->accept = siw_accept;
+	ofa_dev->iwcm->reject = siw_reject;
+	ofa_dev->iwcm->create_listen = siw_create_listen;
+	ofa_dev->iwcm->destroy_listen = siw_destroy_listen;
+	ofa_dev->iwcm->add_ref = siw_qp_get_ref;
+	ofa_dev->iwcm->rem_ref = siw_qp_put_ref;
+	ofa_dev->iwcm->get_qp = siw_get_ofaqp;
+
+	sdev->attrs.version = VERSION_ID_SOFTIWARP;
+	sdev->attrs.vendor_id = SIW_VENDOR_ID;
+	sdev->attrs.vendor_part_id = SIW_VENDORT_PART_ID;
+	sdev->attrs.sw_version = VERSION_ID_SOFTIWARP;
+	sdev->attrs.max_qp = SIW_MAX_QP;
+	sdev->attrs.max_qp_wr = SIW_MAX_QP_WR;
+	sdev->attrs.max_ord = SIW_MAX_ORD_QP;
+	sdev->attrs.max_ird = SIW_MAX_IRD_QP;
+	sdev->attrs.cap_flags = IB_DEVICE_MEM_MGT_EXTENSIONS;
+	sdev->attrs.max_sge = SIW_MAX_SGE;
+	sdev->attrs.max_sge_rd = SIW_MAX_SGE_RD;
+	sdev->attrs.max_cq = SIW_MAX_CQ;
+	sdev->attrs.max_cqe = SIW_MAX_CQE;
+	sdev->attrs.max_mr = SIW_MAX_MR;
+	sdev->attrs.max_mr_size = rlimit(RLIMIT_MEMLOCK);
+	sdev->attrs.max_pd = SIW_MAX_PD;
+	sdev->attrs.max_mw = SIW_MAX_MW;
+	sdev->attrs.max_fmr = SIW_MAX_FMR;
+	sdev->attrs.max_srq = SIW_MAX_SRQ;
+	sdev->attrs.max_srq_wr = SIW_MAX_SRQ_WR;
+	sdev->attrs.max_srq_sge = SIW_MAX_SGE;
+
+	siw_idr_init(sdev);
+	INIT_LIST_HEAD(&sdev->cep_list);
+	INIT_LIST_HEAD(&sdev->qp_list);
+
+	atomic_set(&sdev->num_ctx, 0);
+	atomic_set(&sdev->num_srq, 0);
+	atomic_set(&sdev->num_qp, 0);
+	atomic_set(&sdev->num_cq, 0);
+	atomic_set(&sdev->num_mem, 0);
+	atomic_set(&sdev->num_pd, 0);
+	atomic_set(&sdev->num_cep, 0);
+
+	sdev->is_registered = 0;
+out:
+	if (sdev)
+		dev_hold(netdev);
+
+	return sdev;
+}
+
+
+
+static int siw_netdev_event(struct notifier_block *nb, unsigned long event,
+			    void *arg)
+{
+	struct net_device	*netdev = netdev_notifier_info_to_dev(arg);
+	struct in_device	*in_dev;
+	struct siw_dev		*sdev;
+
+	dprint(DBG_DM, " (dev=%s): Event %lu\n", netdev->name, event);
+
+	if (dev_net(netdev) != &init_net)
+		goto done;
+
+	sdev = siw_dev_from_netdev(netdev);
+
+	switch (event) {
+
+	case NETDEV_UP:
+		if (!sdev)
+			break;
+
+		if (sdev->is_registered) {
+			sdev->state = IB_PORT_ACTIVE;
+			siw_port_event(sdev, 1, IB_EVENT_PORT_ACTIVE);
+			break;
+		}
+
+		in_dev = in_dev_get(netdev);
+		if (!in_dev) {
+			dprint(DBG_DM, ": %s: no in_dev\n", netdev->name);
+			sdev->state = IB_PORT_INIT;
+			break;
+		}
+
+		if (in_dev->ifa_list) {
+			sdev->state = IB_PORT_ACTIVE;
+			siw_device_register(sdev);
+		} else {
+			dprint(DBG_DM, ": %s: no ifa\n", netdev->name);
+			sdev->state = IB_PORT_INIT;
+		}
+		in_dev_put(in_dev);
+
+		break;
+
+	case NETDEV_DOWN:
+		if (sdev && sdev->is_registered) {
+			sdev->state = IB_PORT_DOWN;
+			siw_port_event(sdev, 1, IB_EVENT_PORT_ERR);
+			break;
+		}
+		break;
+
+	case NETDEV_REGISTER:
+		if (!sdev) {
+			if (!siw_dev_qualified(netdev))
+				break;
+
+			sdev = siw_device_create(netdev);
+			if (sdev) {
+				sdev->state = IB_PORT_INIT;
+				dprint(DBG_DM, ": new siw device for %s\n",
+					netdev->name);
+			}
+		}
+		break;
+
+	case NETDEV_UNREGISTER:
+		if (sdev) {
+			if (sdev->is_registered)
+				siw_device_deregister(sdev);
+			list_del(&sdev->list);
+			siw_device_destroy(sdev);
+		}
+		break;
+
+	case NETDEV_CHANGEADDR:
+		if (sdev->is_registered)
+			siw_port_event(sdev, 1, IB_EVENT_LID_CHANGE);
+
+		break;
+	/*
+	 * Todo: Below netdev events are currently not handled.
+	 */
+	case NETDEV_CHANGEMTU:
+	case NETDEV_GOING_DOWN:
+	case NETDEV_CHANGE:
+
+		break;
+
+	default:
+		break;
+	}
+done:
+	return NOTIFY_OK;
+}
+
+static struct notifier_block siw_netdev_nb = {
+	.notifier_call = siw_netdev_event,
+};
+
+/*
+ * siw_init_module - Initialize Softiwarp module and register with netdev
+ *                   subsystem to create Softiwarp devices per net_device
+ */
+static __init int siw_init_module(void)
+{
+	int rv;
+	int nr_cpu;
+
+	if (SENDPAGE_THRESH < SIW_MAX_INLINE) {
+		pr_info("siw: sendpage threshold too small: %u\n",
+			(int)SENDPAGE_THRESH);
+		rv = EINVAL;
+		goto out;
+	}
+	/*
+	 * The xprtrdma module needs at least some rudimentary bus to set
+	 * some devices path MTU.
+	 */
+	rv = bus_register(&siw_bus);
+	if (rv)
+		goto out_nobus;
+
+	siw_generic_dma_device.bus = &siw_bus;
+
+	rv = device_register(&siw_generic_dma_device);
+	if (rv)
+		goto out;
+
+	rv = siw_cm_init();
+	if (rv)
+		goto out_unregister;
+
+	if (DPRINT_MASK)
+		siw_debug_init();
+
+	/*
+	 * Allocate CRC SHASH object. Fail loading siw only, if CRC is
+	 * required by kernel module
+	 */
+	siw_crypto_shash = crypto_alloc_shash("crc32c", 0, 0);
+	if (IS_ERR(siw_crypto_shash)) {
+		pr_info("siw: Loading CRC32c failed: %ld\n",
+			PTR_ERR(siw_crypto_shash));
+		siw_crypto_shash = NULL;
+		if (mpa_crc_required == true)
+			goto out_unregister;
+	}
+	rv = register_netdevice_notifier(&siw_netdev_nb);
+	if (rv) {
+		siw_debugfs_delete();
+		goto out_unregister;
+	}
+	for (nr_cpu = 0; nr_cpu < MAX_CPU; nr_cpu++)
+		qp_tx_thread[nr_cpu] = NULL;
+
+	if (siw_create_tx_threads(MAX_CPU, 1) == 0) {
+		pr_info("Try starting default TX thread\n");
+		if (siw_create_tx_threads(1, 0) == 0) {
+			pr_info("Could not start any TX thread\n");
+			goto out_unregister;
+		}
+	}
+	pr_info("SoftiWARP attached\n");
+	return 0;
+
+out_unregister:
+	for (nr_cpu = 0; nr_cpu < MAX_CPU; nr_cpu++) {
+		if (qp_tx_thread[nr_cpu]) {
+			siw_stop_tx_thread(nr_cpu);
+			qp_tx_thread[nr_cpu] = NULL;
+		}
+	}
+	device_unregister(&siw_generic_dma_device);
+
+	if (siw_crypto_shash)
+		crypto_free_shash(siw_crypto_shash);
+out:
+	bus_unregister(&siw_bus);
+out_nobus:
+	pr_info("SoftIWARP attach failed. Error: %d\n", rv);
+	siw_cm_exit();
+
+	return rv;
+}
+
+
+static void __exit siw_exit_module(void)
+{
+	int nr_cpu;
+
+	for (nr_cpu = 0; nr_cpu < MAX_CPU; nr_cpu++) {
+		if (qp_tx_thread[nr_cpu]) {
+			siw_stop_tx_thread(nr_cpu);
+			qp_tx_thread[nr_cpu] = NULL;
+		}
+	}
+	unregister_netdevice_notifier(&siw_netdev_nb);
+
+	siw_cm_exit();
+
+	while (!list_empty(&siw_devlist)) {
+		struct siw_dev  *sdev =
+			list_entry(siw_devlist.next, struct siw_dev, list);
+		list_del(&sdev->list);
+		if (sdev->is_registered)
+			siw_device_deregister(sdev);
+
+		siw_device_destroy(sdev);
+	}
+	if (siw_crypto_shash)
+		crypto_free_shash(siw_crypto_shash);
+
+	siw_debugfs_delete();
+
+	device_unregister(&siw_generic_dma_device);
+
+	bus_unregister(&siw_bus);
+
+	pr_info("SoftiWARP detached\n");
+}
+
+module_init(siw_init_module);
+module_exit(siw_exit_module);
diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
new file mode 100644
index 000000000000..0affa31c8520
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_mem.c
@@ -0,0 +1,403 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Animesh Trivedi <atr-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *          Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#include <linux/version.h>
+#include <linux/scatterlist.h>
+#include <linux/gfp.h>
+#include <rdma/ib_verbs.h>
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+#include <linux/pid.h>
+#include <linux/sched/mm.h>
+
+#include "siw.h"
+#include "siw_debug.h"
+
+static void siw_umem_update_stats(struct work_struct *work)
+{
+	struct siw_umem *umem = container_of(work, struct siw_umem, work);
+	struct mm_struct *mm_s = umem->mm_s;
+
+	BUG_ON(!mm_s);
+
+	down_write(&mm_s->mmap_sem);
+	mm_s->pinned_vm -= umem->num_pages;
+	up_write(&mm_s->mmap_sem);
+
+	mmput(mm_s);
+
+	kfree(umem->page_chunk);
+	kfree(umem);
+}
+
+static void siw_free_plist(struct siw_page_chunk *chunk, int num_pages)
+{
+	struct page **p = chunk->p;
+
+	while (num_pages--) {
+		put_page(*p);
+		p++;
+	}
+}
+
+void siw_umem_release(struct siw_umem *umem)
+{
+	struct task_struct *task = get_pid_task(umem->pid, PIDTYPE_PID);
+	int i, num_pages = umem->num_pages;
+
+	for (i = 0; num_pages; i++) {
+		int to_free = min_t(int, PAGES_PER_CHUNK, num_pages);
+
+		siw_free_plist(&umem->page_chunk[i], to_free);
+		kfree(umem->page_chunk[i].p);
+		num_pages -= to_free;
+	}
+	put_pid(umem->pid);
+	if (task) {
+		struct mm_struct *mm_s = get_task_mm(task);
+
+		put_task_struct(task);
+		if (mm_s) {
+			if (down_write_trylock(&mm_s->mmap_sem)) {
+				mm_s->pinned_vm -= umem->num_pages;
+				up_write(&mm_s->mmap_sem);
+				mmput(mm_s);
+			} else {
+				/*
+				 * Schedule delayed accounting if
+				 * mm semaphore not available
+				 */
+				INIT_WORK(&umem->work, siw_umem_update_stats);
+				umem->mm_s = mm_s;
+				schedule_work(&umem->work);
+
+				return;
+			}
+		}
+	}
+	kfree(umem->page_chunk);
+	kfree(umem);
+}
+
+void siw_pbl_free(struct siw_pbl *pbl)
+{
+	kfree(pbl);
+}
+
+/*
+ * Get physical address backed by PBL element. Address is referenced
+ * by linear byte offset into list of variably sized PB elements.
+ * Optionally, provide remaining len within current element, and
+ * current PBL index for later resume at same element.
+ */
+u64 siw_pbl_get_buffer(struct siw_pbl *pbl, u64 off, int *len, int *idx)
+{
+	int i = idx ? *idx : 0;
+
+	while (i < pbl->num_buf) {
+		struct siw_pble *pble = &pbl->pbe[i];
+
+		if (pble->pbl_off + pble->size > off) {
+			u64 pble_off = off - pble->pbl_off;
+
+			if (len)
+				*len = pble->size - pble_off;
+			if (idx)
+				*idx = i;
+
+			return pble->addr + pble_off;
+		}
+		i++;
+	}
+	if (len)
+		*len = 0;
+	return 0;
+}
+
+struct siw_pbl *siw_pbl_alloc(u32 num_buf)
+{
+	struct siw_pbl *pbl;
+	int buf_size = sizeof(*pbl);
+
+	if (num_buf == 0)
+		return ERR_PTR(-EINVAL);
+
+	buf_size += ((num_buf - 1) * sizeof(struct siw_pble));
+
+	pbl = kzalloc(buf_size, GFP_KERNEL);
+	if (!pbl)
+		return ERR_PTR(-ENOMEM);
+
+	pbl->max_buf = num_buf;
+
+	return pbl;
+}
+
+struct siw_umem *siw_umem_get(u64 start, u64 len)
+{
+	struct siw_umem *umem;
+	u64 first_page_va;
+	unsigned long mlock_limit;
+	int num_pages, num_chunks, i, rv = 0;
+
+	if (!can_do_mlock())
+		return ERR_PTR(-EPERM);
+
+	if (!len)
+		return ERR_PTR(-EINVAL);
+
+	first_page_va = start & PAGE_MASK;
+	num_pages = PAGE_ALIGN(start + len - first_page_va) >> PAGE_SHIFT;
+	num_chunks = (num_pages >> CHUNK_SHIFT) + 1;
+
+	umem = kzalloc(sizeof(*umem), GFP_KERNEL);
+	if (!umem)
+		return ERR_PTR(-ENOMEM);
+
+	umem->pid = get_task_pid(current, PIDTYPE_PID);
+
+	down_write(&current->mm->mmap_sem);
+
+	mlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+
+	if (num_pages + current->mm->pinned_vm > mlock_limit) {
+		dprint(DBG_ON|DBG_MM,
+			": pages req: %d, limit: %lu, pinned: %lu\n",
+			num_pages, mlock_limit, current->mm->pinned_vm);
+		rv = -ENOMEM;
+		goto out;
+	}
+	umem->fp_addr = first_page_va;
+
+	umem->page_chunk = kcalloc(num_chunks, sizeof(struct siw_page_chunk),
+				   GFP_KERNEL);
+	if (!umem->page_chunk) {
+		rv = -ENOMEM;
+		goto out;
+	}
+	for (i = 0; num_pages; i++) {
+		int got, nents = min_t(int, num_pages, PAGES_PER_CHUNK);
+
+		umem->page_chunk[i].p = kcalloc(nents, sizeof(struct page *),
+						GFP_KERNEL);
+		if (!umem->page_chunk[i].p) {
+			rv = -ENOMEM;
+			goto out;
+		}
+		got = 0;
+		while (nents) {
+			struct page **plist = &umem->page_chunk[i].p[got];
+
+			rv = get_user_pages(first_page_va, nents, FOLL_WRITE,
+					    plist, NULL);
+			if (rv < 0)
+				goto out;
+
+			umem->num_pages += rv;
+			current->mm->pinned_vm += rv;
+			first_page_va += rv * PAGE_SIZE;
+			nents -= rv;
+			got += rv;
+		}
+		num_pages -= got;
+	}
+out:
+	up_write(&current->mm->mmap_sem);
+
+	if (rv > 0)
+		return umem;
+
+	siw_umem_release(umem);
+
+	return ERR_PTR(rv);
+}
+
+/*
+ * DMA mapping/address translation functions.
+ * Used to populate siw private DMA mapping functions of
+ * struct dma_map_ops. 
+ */
+static void *siw_dma_generic_alloc(struct device *dev, size_t size,
+				   dma_addr_t *dma_handle, gfp_t gfp,
+				   unsigned long attrs)
+{
+	struct page *page;
+	void *kva = NULL;
+
+	page = alloc_pages(gfp, get_order(size));
+	if (page)
+		kva = page_address(page);
+	if (dma_handle)
+		*dma_handle = (dma_addr_t)kva;
+
+	return kva;
+}
+
+static void siw_dma_generic_free(struct device *dev, size_t size,
+				 void *vaddr, dma_addr_t dma_handle,
+				 unsigned long attrs)
+{
+	free_pages((unsigned long) vaddr, get_order(size));
+}
+
+static dma_addr_t siw_dma_generic_map_page(struct device *dev,
+					   struct page *page,
+					   unsigned long offset,
+					   size_t size,
+					   enum dma_data_direction dir,
+					   unsigned long attrs)
+{
+	BUG_ON(!valid_dma_direction(dir));
+
+	return (u64)(page_address(page) + offset);
+}
+
+static void siw_dma_generic_unmap_page(struct device *dev,
+				       dma_addr_t handle,
+				       size_t size,
+				       enum dma_data_direction dir,
+				       unsigned long attrs)
+{
+	/* NOP */
+}
+
+static int siw_dma_generic_map_sg(struct device *dev, struct scatterlist *sgl,
+				  int nents, enum dma_data_direction dir,
+				  unsigned long attrs)
+{
+	struct scatterlist *se;
+	int i;
+
+	BUG_ON(!valid_dma_direction(dir));
+
+	for_each_sg(sgl, se, nents, i) {
+		/* This is just a validity check */
+		if (unlikely(page_address(sg_page(se)) == NULL)) {
+			nents = 0;
+			break;
+		}
+		se->dma_address =
+			(dma_addr_t)(page_address(sg_page(se)) + se->offset);
+		sg_dma_len(se) = se->length;
+	}
+	return nents;
+}
+
+static void siw_dma_generic_unmap_sg(struct device *dev,
+				    struct scatterlist *sg,
+				    int nents,
+				    enum dma_data_direction dir,
+				    unsigned long attrs)
+{
+	/* NOP */
+}
+
+static void siw_generic_sync_single_for_cpu(struct device *dev,
+					    dma_addr_t dma_handle,
+					    size_t size,
+					    enum dma_data_direction dir)
+{
+	/* NOP */
+}
+
+
+static void siw_generic_sync_single_for_device(struct device *dev,
+					       dma_addr_t dma_handle,
+					       size_t size,
+					       enum dma_data_direction dir)
+{
+	/* NOP */
+}
+
+static void siw_generic_sync_sg_for_cpu(struct device *dev,
+					struct scatterlist *sg,
+					int nents,
+					enum dma_data_direction dir)
+{
+	/* NOP */
+}
+
+static void siw_generic_sync_sg_for_device(struct device *dev,
+					   struct scatterlist *sg,
+					   int nents,
+					   enum dma_data_direction dir)
+{
+	/* NOP */
+}
+
+static int siw_dma_generic_mapping_error(struct device *dev,
+					 dma_addr_t dma_addr)
+{
+	return dma_addr == 0;
+}
+
+static int siw_dma_generic_supported(struct device *dev, u64 mask)
+{
+	return 1;
+}
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4, 13, 0)
+static int siw_dma_generic_set_mask(struct device *dev, u64 mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+
+	*dev->dma_mask = mask;
+
+	return 0;
+}
+#endif
+
+const struct dma_map_ops siw_dma_generic_ops = {
+	.alloc			= siw_dma_generic_alloc,
+	.free			= siw_dma_generic_free,
+	.map_page		= siw_dma_generic_map_page,
+	.unmap_page		= siw_dma_generic_unmap_page,
+	.map_sg			= siw_dma_generic_map_sg,
+	.unmap_sg		= siw_dma_generic_unmap_sg,
+	.sync_single_for_cpu	= siw_generic_sync_single_for_cpu,
+	.sync_single_for_device	= siw_generic_sync_single_for_device,
+	.sync_sg_for_cpu	= siw_generic_sync_sg_for_cpu,
+	.sync_sg_for_device	= siw_generic_sync_sg_for_device,
+	.mapping_error		= siw_dma_generic_mapping_error,
+	.dma_supported		= siw_dma_generic_supported,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4, 13, 0)
+	.set_dma_mask		= siw_dma_generic_set_mask,
+#endif
+	.is_phys		= 1
+};
diff --git a/drivers/infiniband/sw/siw/siw_obj.c b/drivers/infiniband/sw/siw/siw_obj.c
new file mode 100644
index 000000000000..db8e0a29b02b
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_obj.c
@@ -0,0 +1,428 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#include <linux/spinlock.h>
+#include <linux/kref.h>
+#include <linux/vmalloc.h>
+
+#include "siw.h"
+#include "siw_obj.h"
+#include "siw_cm.h"
+
+
+void siw_objhdr_init(struct siw_objhdr *hdr)
+{
+	kref_init(&hdr->ref);
+}
+
+void siw_idr_init(struct siw_dev *sdev)
+{
+	spin_lock_init(&sdev->idr_lock);
+
+	idr_init(&sdev->qp_idr);
+	idr_init(&sdev->cq_idr);
+	idr_init(&sdev->pd_idr);
+	idr_init(&sdev->mem_idr);
+}
+
+void siw_idr_release(struct siw_dev *sdev)
+{
+	idr_destroy(&sdev->qp_idr);
+	idr_destroy(&sdev->cq_idr);
+	idr_destroy(&sdev->pd_idr);
+	idr_destroy(&sdev->mem_idr);
+}
+
+static inline int siw_add_obj(spinlock_t *lock, struct idr *idr,
+			      struct siw_objhdr *obj)
+{
+	unsigned long flags;
+	int id, pre_id;
+
+	do {
+		get_random_bytes(&pre_id, sizeof(pre_id));
+		pre_id &= 0xffffff;
+	} while (pre_id == 0);
+again:
+	spin_lock_irqsave(lock, flags);
+	id = idr_alloc(idr, obj, pre_id, 0xffffff - 1, GFP_KERNEL);
+	spin_unlock_irqrestore(lock, flags);
+
+	if (id > 0) {
+		siw_objhdr_init(obj);
+		obj->id = id;
+		dprint(DBG_OBJ, "(OBJ%d): IDR New Object\n", id);
+	} else if (id == -ENOSPC && pre_id != 1) {
+		pre_id = 1;
+		goto again;
+	} else {
+		BUG_ON(id == 0);
+		dprint(DBG_OBJ|DBG_ON, "(OBJ??): IDR New Object failed!\n");
+	}
+	return id > 0 ? 0 : id;
+}
+
+static inline struct siw_objhdr *siw_get_obj(struct idr *idr, int id)
+{
+	struct siw_objhdr *obj = idr_find(idr, id);
+
+	if (obj)
+		kref_get(&obj->ref);
+
+	return obj;
+}
+
+struct siw_cq *siw_cq_id2obj(struct siw_dev *sdev, int id)
+{
+	struct siw_objhdr *obj = siw_get_obj(&sdev->cq_idr, id);
+
+	if (obj)
+		return container_of(obj, struct siw_cq, hdr);
+
+	return NULL;
+}
+
+struct siw_qp *siw_qp_id2obj(struct siw_dev *sdev, int id)
+{
+	struct siw_objhdr *obj = siw_get_obj(&sdev->qp_idr, id);
+
+	if (obj)
+		return container_of(obj, struct siw_qp, hdr);
+
+	return NULL;
+}
+
+/*
+ * siw_mem_id2obj()
+ *
+ * resolves memory from stag given by id. might be called from:
+ * o process context before sending out of sgl, or
+ * o in softirq when resolving target memory
+ */
+struct siw_mem *siw_mem_id2obj(struct siw_dev *sdev, int id)
+{
+	struct siw_objhdr *obj;
+
+	rcu_read_lock();
+	obj = siw_get_obj(&sdev->mem_idr, id);
+	rcu_read_unlock();
+
+	if (obj) {
+		dprint(DBG_MM|DBG_OBJ, "(MEM%d): New refcount: %d\n",
+		       obj->id, refcount_read(&obj->ref));
+
+		return container_of(obj, struct siw_mem, hdr);
+	}
+	dprint(DBG_MM|DBG_OBJ|DBG_ON, "(MEM%d): not found!\n", id);
+
+	return NULL;
+}
+
+int siw_qp_add(struct siw_dev *sdev, struct siw_qp *qp)
+{
+	int rv = siw_add_obj(&sdev->idr_lock, &sdev->qp_idr, &qp->hdr);
+
+	if (!rv) {
+		dprint(DBG_OBJ, "(QP%d): New Object\n", QP_ID(qp));
+		qp->hdr.sdev = sdev;
+	}
+	return rv;
+}
+
+int siw_cq_add(struct siw_dev *sdev, struct siw_cq *cq)
+{
+	int rv = siw_add_obj(&sdev->idr_lock, &sdev->cq_idr, &cq->hdr);
+
+	if (!rv) {
+		dprint(DBG_OBJ, "(CQ%d): New Object\n", cq->hdr.id);
+		cq->hdr.sdev = sdev;
+	}
+	return rv;
+}
+
+int siw_pd_add(struct siw_dev *sdev, struct siw_pd *pd)
+{
+	int rv = siw_add_obj(&sdev->idr_lock, &sdev->pd_idr, &pd->hdr);
+
+	if (!rv) {
+		dprint(DBG_OBJ, "(PD%d): New Object\n", pd->hdr.id);
+		pd->hdr.sdev = sdev;
+	}
+	return rv;
+}
+
+/*
+ * Stag lookup is based on its index part only (24 bits).
+ * The code avoids special Stag of zero and tries to randomize
+ * STag values between 1 and SIW_STAG_MAX.
+ */
+int siw_mem_add(struct siw_dev *sdev, struct siw_mem *m)
+{
+	unsigned long flags;
+	int id, pre_id;
+
+	do {
+		get_random_bytes(&pre_id, sizeof(pre_id));
+		pre_id &= 0xffffff;
+	} while (pre_id == 0);
+again:
+	spin_lock_irqsave(&sdev->idr_lock, flags);
+	id = idr_alloc(&sdev->mem_idr, m, pre_id, SIW_STAG_MAX, GFP_KERNEL);
+	spin_unlock_irqrestore(&sdev->idr_lock, flags);
+
+	if (id == -ENOSPC || id > SIW_STAG_MAX) {
+		if (pre_id == 1) {
+			dprint(DBG_OBJ|DBG_MM|DBG_ON,
+				"(IDR): New Object failed: %d\n", pre_id);
+			return -ENOSPC;
+		}
+		pre_id = 1;
+		goto again;
+	}
+	siw_objhdr_init(&m->hdr);
+	m->hdr.id = id;
+	m->hdr.sdev = sdev;
+	dprint(DBG_OBJ|DBG_MM, "(IDR%d): New Object\n", id);
+
+	return 0;
+}
+
+void siw_remove_obj(spinlock_t *lock, struct idr *idr,
+		      struct siw_objhdr *hdr)
+{
+	unsigned long	flags;
+
+	dprint(DBG_OBJ, "(OBJ%d): IDR Remove Object\n", hdr->id);
+
+	spin_lock_irqsave(lock, flags);
+	idr_remove(idr, hdr->id);
+	spin_unlock_irqrestore(lock, flags);
+}
+
+
+/********** routines to put objs back and free if no ref left *****/
+
+static void siw_free_cq(struct kref *ref)
+{
+	struct siw_cq *cq =
+		(container_of(container_of(ref, struct siw_objhdr, ref),
+			      struct siw_cq, hdr));
+
+	dprint(DBG_OBJ, "(CQ%d): Free Object\n", cq->hdr.id);
+
+	atomic_dec(&cq->hdr.sdev->num_cq);
+	if (cq->queue)
+		vfree(cq->queue);
+	kfree(cq);
+}
+
+static void siw_free_qp(struct kref *ref)
+{
+	struct siw_qp	*qp =
+		container_of(container_of(ref, struct siw_objhdr, ref),
+			     struct siw_qp, hdr);
+	struct siw_dev	*sdev = qp->hdr.sdev;
+	unsigned long flags;
+
+	dprint(DBG_OBJ|DBG_CM, "(QP%d): Free Object\n", QP_ID(qp));
+
+	if (qp->cep)
+		siw_cep_put(qp->cep);
+
+	siw_remove_obj(&sdev->idr_lock, &sdev->qp_idr, &qp->hdr);
+
+	spin_lock_irqsave(&sdev->idr_lock, flags);
+	list_del(&qp->devq);
+	spin_unlock_irqrestore(&sdev->idr_lock, flags);
+
+	if (qp->sendq)
+		vfree(qp->sendq);
+	if (qp->recvq)
+		vfree(qp->recvq);
+	if (qp->irq)
+		vfree(qp->irq);
+	if (qp->orq)
+		vfree(qp->orq);
+
+	atomic_dec(&sdev->num_qp);
+	kfree(qp);
+}
+
+static void siw_free_pd(struct kref *ref)
+{
+	struct siw_pd	*pd =
+		container_of(container_of(ref, struct siw_objhdr, ref),
+			     struct siw_pd, hdr);
+
+	dprint(DBG_OBJ, "(PD%d): Free Object\n", pd->hdr.id);
+
+	atomic_dec(&pd->hdr.sdev->num_pd);
+	kfree(pd);
+}
+
+static void siw_free_mem(struct kref *ref)
+{
+	struct siw_mem *m;
+
+	m = container_of(container_of(ref, struct siw_objhdr, ref),
+			 struct siw_mem, hdr);
+
+	dprint(DBG_MM|DBG_OBJ, "(MEM%d): Free\n", OBJ_ID(m));
+
+	atomic_dec(&m->hdr.sdev->num_mem);
+
+	if (SIW_MEM_IS_MW(m)) {
+		struct siw_mw *mw = container_of(m, struct siw_mw, mem);
+
+		kfree_rcu(mw, rcu);
+	} else {
+		struct siw_mr *mr = container_of(m, struct siw_mr, mem);
+
+		dprint(DBG_MM|DBG_OBJ, "(MEM%d): Release obj %p, (PBL %d)\n",
+			OBJ_ID(m), mr->mem_obj, mr->mem.is_pbl ? 1 : 0);
+		if (mr->mem_obj) {
+			if (mr->mem.is_pbl == 0)
+				siw_umem_release(mr->umem);
+			else
+				siw_pbl_free(mr->pbl);
+		}
+		kfree_rcu(mr, rcu);
+	}
+}
+
+
+void siw_cq_put(struct siw_cq *cq)
+{
+	dprint(DBG_OBJ, "(CQ%d): Old refcount: %d\n",
+		OBJ_ID(cq), refcount_read(&cq->hdr.ref));
+	kref_put(&cq->hdr.ref, siw_free_cq);
+}
+
+void siw_qp_put(struct siw_qp *qp)
+{
+	dprint(DBG_OBJ, "(QP%d): Old refcount: %d\n",
+		QP_ID(qp), refcount_read(&qp->hdr.ref));
+	kref_put(&qp->hdr.ref, siw_free_qp);
+}
+
+void siw_pd_put(struct siw_pd *pd)
+{
+	dprint(DBG_OBJ, "(PD%d): Old refcount: %d\n",
+		OBJ_ID(pd), refcount_read(&pd->hdr.ref));
+	kref_put(&pd->hdr.ref, siw_free_pd);
+}
+
+void siw_mem_put(struct siw_mem *m)
+{
+	dprint(DBG_MM|DBG_OBJ, "(MEM%d): Old refcount: %d\n",
+		OBJ_ID(m), refcount_read(&m->hdr.ref));
+	kref_put(&m->hdr.ref, siw_free_mem);
+}
+
+
+/***** routines for WQE handling ***/
+
+static inline void siw_unref_mem_sgl(union siw_mem_resolved *mem, int num_sge)
+{
+	while (num_sge--) {
+		if (mem->obj != NULL) {
+			siw_mem_put(mem->obj);
+			mem->obj = NULL;
+			mem++;
+		} else
+			break;
+	}
+}
+
+void siw_wqe_put_mem(struct siw_wqe *wqe, enum siw_opcode op)
+{
+	switch (op) {
+
+	case SIW_OP_SEND:
+	case SIW_OP_WRITE:
+	case SIW_OP_SEND_WITH_IMM:
+	case SIW_OP_SEND_REMOTE_INV:
+	case SIW_OP_READ:
+	case SIW_OP_READ_LOCAL_INV:
+		if (!(wqe->sqe.flags & SIW_WQE_INLINE))
+			siw_unref_mem_sgl(wqe->mem, wqe->sqe.num_sge);
+		break;
+
+	case SIW_OP_RECEIVE:
+		siw_unref_mem_sgl(wqe->mem, wqe->rqe.num_sge);
+		break;
+
+	case SIW_OP_READ_RESPONSE:
+		siw_unref_mem_sgl(wqe->mem, 1);
+		break;
+
+	default:
+		/*
+		 * SIW_OP_INVAL_STAG and SIW_OP_REG_MR
+		 * do not hold memory references
+		 */
+		break;
+	}
+}
+
+int siw_invalidate_stag(struct siw_pd *pd, u32 stag)
+{
+	u32 stag_idx = stag >> 8;
+	struct siw_mem *mem = siw_mem_id2obj(pd->hdr.sdev, stag_idx);
+	int rv = 0;
+
+	if (unlikely(!mem)) {
+		dprint(DBG_ON, ": STag %u unknown\n", stag_idx);
+		return -EINVAL;
+	}
+	if (unlikely(siw_mem2mr(mem)->pd != pd)) {
+		dprint(DBG_ON, ": PD mismatch for STag %u\n", stag_idx);
+		rv = -EINVAL;
+		goto out;
+	}
+	/*
+	 * Per RDMA verbs definition, an STag may already be in invalid
+	 * state if invalidation is requested. So no state check here.
+	 */
+	mem->stag_valid = 0;
+
+	dprint(DBG_MM, ": STag %u now invalid\n", stag_idx);
+out:
+	siw_mem_put(mem);
+	return rv;
+}
diff --git a/drivers/infiniband/sw/siw/siw_obj.h b/drivers/infiniband/sw/siw/siw_obj.h
new file mode 100644
index 000000000000..55f0ff24e8d7
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_obj.h
@@ -0,0 +1,113 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#ifndef _SIW_OBJ_H
+#define _SIW_OBJ_H
+
+#include <linux/idr.h>
+#include <linux/rwsem.h>
+#include <linux/version.h>
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+
+#include <rdma/ib_verbs.h>
+
+#include "siw_debug.h"
+
+
+static inline struct siw_dev *siw_dev_ofa2siw(struct ib_device *ofa_dev)
+{
+	return container_of(ofa_dev, struct siw_dev, ofa_dev);
+}
+
+static inline struct siw_mr *siw_mr_ofa2siw(struct ib_mr *ofa_mr)
+{
+	return container_of(ofa_mr, struct siw_mr, ofa_mr);
+}
+
+static inline void siw_cq_get(struct siw_cq *cq)
+{
+	kref_get(&cq->hdr.ref);
+	dprint(DBG_OBJ, "(CQ%d): New refcount: %d\n",
+		OBJ_ID(cq), refcount_read(&cq->hdr.ref));
+}
+static inline void siw_qp_get(struct siw_qp *qp)
+{
+	kref_get(&qp->hdr.ref);
+	dprint(DBG_OBJ, "(QP%d): New refcount: %d\n",
+		OBJ_ID(qp), refcount_read(&qp->hdr.ref));
+}
+static inline void siw_pd_get(struct siw_pd *pd)
+{
+	kref_get(&pd->hdr.ref);
+	dprint(DBG_OBJ, "(PD%d): New refcount: %d\n",
+		OBJ_ID(pd), refcount_read(&pd->hdr.ref));
+}
+static inline void siw_mem_get(struct siw_mem *mem)
+{
+	kref_get(&mem->hdr.ref);
+	dprint(DBG_OBJ|DBG_MM, "(MEM%d): New refcount: %d\n",
+		OBJ_ID(mem), refcount_read(&mem->hdr.ref));
+}
+
+extern void siw_remove_obj(spinlock_t *lock, struct idr *idr,
+				struct siw_objhdr *hdr);
+
+extern void siw_objhdr_init(struct siw_objhdr *hdr);
+extern void siw_idr_init(struct siw_dev *dev);
+extern void siw_idr_release(struct siw_dev *dev);
+
+extern struct siw_cq *siw_cq_id2obj(struct siw_dev *dev, int id);
+extern struct siw_qp *siw_qp_id2obj(struct siw_dev *dev, int id);
+extern struct siw_mem *siw_mem_id2obj(struct siw_dev *dev, int id);
+
+extern int siw_qp_add(struct siw_dev *dev, struct siw_qp *qp);
+extern int siw_cq_add(struct siw_dev *dev, struct siw_cq *cq);
+extern int siw_pd_add(struct siw_dev *dev, struct siw_pd *pd);
+extern int siw_mem_add(struct siw_dev *dev, struct siw_mem *mem);
+
+extern struct siw_wqe *siw_freeq_wqe_get(struct siw_qp *qp);
+
+extern void siw_cq_put(struct siw_cq *cq);
+extern void siw_qp_put(struct siw_qp *qp);
+extern void siw_pd_put(struct siw_pd *pd);
+extern void siw_mem_put(struct siw_mem *mem);
+extern void siw_wqe_put_mem(struct siw_wqe *wqe, enum siw_opcode opcode);
+
+extern int siw_invalidate_stag(struct siw_pd *pd, u32 stag);
+#endif
diff --git a/drivers/infiniband/sw/siw/siw_qp.c b/drivers/infiniband/sw/siw/siw_qp.c
new file mode 100644
index 000000000000..35c0a64a0a6c
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_qp.c
@@ -0,0 +1,1172 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *          Fredy Neeser <nfd-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/net.h>
+#include <linux/file.h>
+#include <linux/scatterlist.h>
+#include <linux/highmem.h>
+#include <linux/vmalloc.h>
+#include <asm/barrier.h>
+#include <net/sock.h>
+#include <net/tcp_states.h>
+#include <net/tcp.h>
+
+#include <rdma/iw_cm.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+
+#include "siw.h"
+#include "siw_obj.h"
+#include "siw_cm.h"
+
+
+#if DPRINT_MASK > 0
+static char siw_qp_state_to_string[SIW_QP_STATE_COUNT][sizeof "TERMINATE"] = {
+	[SIW_QP_STATE_IDLE]		= "IDLE",
+	[SIW_QP_STATE_RTR]		= "RTR",
+	[SIW_QP_STATE_RTS]		= "RTS",
+	[SIW_QP_STATE_CLOSING]		= "CLOSING",
+	[SIW_QP_STATE_TERMINATE]	= "TERMINATE",
+	[SIW_QP_STATE_ERROR]		= "ERROR"
+};
+#endif
+
+extern struct crypto_shash *siw_crypto_shash;
+
+/*
+ * iWARP (RDMAP, DDP and MPA) parameters as well as Softiwarp settings on a
+ * per-RDMAP message basis. Please keep order of initializer. All MPA len
+ * is initialized to minimum packet size.
+ */
+struct iwarp_msg_info iwarp_pktinfo[RDMAP_TERMINATE + 1] = { {
+	/* RDMAP_RDMA_WRITE */
+	.hdr_len = sizeof(struct iwarp_rdma_write),
+	.ctrl.mpa_len = htons(sizeof(struct iwarp_rdma_write) - 2),
+	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_TAGGED | DDP_FLAG_LAST
+		| cpu_to_be16(DDP_VERSION << 8)
+		| cpu_to_be16(RDMAP_VERSION << 6)
+		| cpu_to_be16(RDMAP_RDMA_WRITE),
+	.proc_data = siw_proc_write
+},
+{	/* RDMAP_RDMA_READ_REQ */
+	.hdr_len = sizeof(struct iwarp_rdma_rreq),
+	.ctrl.mpa_len = htons(sizeof(struct iwarp_rdma_rreq) - 2),
+	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_LAST
+		| cpu_to_be16(DDP_VERSION << 8)
+		| cpu_to_be16(RDMAP_VERSION << 6)
+		| cpu_to_be16(RDMAP_RDMA_READ_REQ),
+	.proc_data = siw_proc_rreq
+},
+{	/* RDMAP_RDMA_READ_RESP */
+	.hdr_len = sizeof(struct iwarp_rdma_rresp),
+	.ctrl.mpa_len = htons(sizeof(struct iwarp_rdma_rresp) - 2),
+	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_TAGGED | DDP_FLAG_LAST
+		| cpu_to_be16(DDP_VERSION << 8)
+		| cpu_to_be16(RDMAP_VERSION << 6)
+		| cpu_to_be16(RDMAP_RDMA_READ_RESP),
+	.proc_data = siw_proc_rresp
+},
+{	/* RDMAP_SEND */
+	.hdr_len = sizeof(struct iwarp_send),
+	.ctrl.mpa_len = htons(sizeof(struct iwarp_send) - 2),
+	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_LAST
+		| cpu_to_be16(DDP_VERSION << 8)
+		| cpu_to_be16(RDMAP_VERSION << 6)
+		| cpu_to_be16(RDMAP_SEND),
+	.proc_data = siw_proc_send
+},
+{	/* RDMAP_SEND_INVAL */
+	.hdr_len = sizeof(struct iwarp_send_inv),
+	.ctrl.mpa_len = htons(sizeof(struct iwarp_send_inv) - 2),
+	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_LAST
+		| cpu_to_be16(DDP_VERSION << 8)
+		| cpu_to_be16(RDMAP_VERSION << 6)
+		| cpu_to_be16(RDMAP_SEND_INVAL),
+	.proc_data = siw_proc_send
+},
+{	/* RDMAP_SEND_SE */
+	.hdr_len = sizeof(struct iwarp_send),
+	.ctrl.mpa_len = htons(sizeof(struct iwarp_send) - 2),
+	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_LAST
+		| cpu_to_be16(DDP_VERSION << 8)
+		| cpu_to_be16(RDMAP_VERSION << 6)
+		| cpu_to_be16(RDMAP_SEND_SE),
+	.proc_data = siw_proc_send
+},
+{	/* RDMAP_SEND_SE_INVAL */
+	.hdr_len = sizeof(struct iwarp_send_inv),
+	.ctrl.mpa_len = htons(sizeof(struct iwarp_send_inv) - 2),
+	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_LAST
+		| cpu_to_be16(DDP_VERSION << 8)
+		| cpu_to_be16(RDMAP_VERSION << 6)
+		| cpu_to_be16(RDMAP_SEND_SE_INVAL),
+	.proc_data = siw_proc_send
+},
+{	/* RDMAP_TERMINATE */
+	.hdr_len = sizeof(struct iwarp_terminate),
+	.ctrl.mpa_len = htons(sizeof(struct iwarp_terminate) - 2),
+	.ctrl.ddp_rdmap_ctrl = DDP_FLAG_LAST
+		| cpu_to_be16(DDP_VERSION << 8)
+		| cpu_to_be16(RDMAP_VERSION << 6)
+		| cpu_to_be16(RDMAP_TERMINATE),
+	.proc_data = siw_proc_terminate
+} };
+
+void siw_qp_llp_data_ready(struct sock *sk)
+{
+	struct siw_qp		*qp;
+
+	read_lock(&sk->sk_callback_lock);
+
+	if (unlikely(!sk->sk_user_data || !sk_to_qp(sk))) {
+		dprint(DBG_ON, " No QP: %p\n", sk->sk_user_data);
+		goto done;
+	}
+	qp = sk_to_qp(sk);
+
+	if (likely(!qp->rx_ctx.rx_suspend &&
+		   down_read_trylock(&qp->state_lock))) {
+		read_descriptor_t rd_desc = {.arg.data = qp, .count = 1};
+
+		dprint(DBG_SK|DBG_RX, "(QP%d): state (before read_sock)=%d\n",
+			QP_ID(qp), qp->attrs.state);
+
+		if (likely(qp->attrs.state == SIW_QP_STATE_RTS))
+			/*
+			 * Implements data receive operation during
+			 * socket callback. TCP gracefully catches
+			 * the case where there is nothing to receive
+			 * (not calling siw_tcp_rx_data() then).
+			 */
+			tcp_read_sock(sk, &rd_desc, siw_tcp_rx_data);
+
+		dprint(DBG_SK|DBG_RX, "(QP%d): state (after read_sock)=%d\n",
+			QP_ID(qp), qp->attrs.state);
+
+		up_read(&qp->state_lock);
+	} else {
+		dprint(DBG_SK|DBG_RX, "(QP%d): Unable to RX: rx_suspend: %d\n",
+			QP_ID(qp), qp->rx_ctx.rx_suspend);
+	}
+done:
+	read_unlock(&sk->sk_callback_lock);
+}
+
+
+void siw_qp_llp_close(struct siw_qp *qp)
+{
+	dprint(DBG_CM, "(QP%d): Enter: SIW QP state = %s, cep=0x%p\n",
+		QP_ID(qp), siw_qp_state_to_string[qp->attrs.state],
+		qp->cep);
+
+	down_write(&qp->state_lock);
+
+	dprint(DBG_CM, "(QP%d): state locked\n", QP_ID(qp));
+
+	qp->rx_ctx.rx_suspend = 1;
+	qp->tx_ctx.tx_suspend = 1;
+	qp->attrs.llp_stream_handle = NULL;
+
+	switch (qp->attrs.state) {
+
+	case SIW_QP_STATE_RTS:
+	case SIW_QP_STATE_RTR:
+	case SIW_QP_STATE_IDLE:
+	case SIW_QP_STATE_TERMINATE:
+
+		qp->attrs.state = SIW_QP_STATE_ERROR;
+
+		break;
+	/*
+	 * SIW_QP_STATE_CLOSING:
+	 *
+	 * This is a forced close. shall the QP be moved to
+	 * ERROR or IDLE ?
+	 */
+	case SIW_QP_STATE_CLOSING:
+		if (tx_wqe(qp)->wr_status == SIW_WR_IDLE)
+			qp->attrs.state = SIW_QP_STATE_ERROR;
+		else
+			qp->attrs.state = SIW_QP_STATE_IDLE;
+
+		break;
+
+	default:
+		dprint(DBG_CM, " No state transition needed: %d\n",
+			qp->attrs.state);
+		break;
+	}
+	siw_sq_flush(qp);
+	siw_rq_flush(qp);
+
+	/*
+	 * dereference closing CEP
+	 */
+	if (qp->cep) {
+		siw_cep_put(qp->cep);
+		qp->cep = NULL;
+	}
+
+	up_write(&qp->state_lock);
+	dprint(DBG_CM, "(QP%d): Exit: SIW QP state = %s, cep=0x%p\n",
+		QP_ID(qp), siw_qp_state_to_string[qp->attrs.state],
+		qp->cep);
+}
+
+
+/*
+ * socket callback routine informing about newly available send space.
+ * Function schedules SQ work for processing SQ items.
+ */
+void siw_qp_llp_write_space(struct sock *sk)
+{
+	struct siw_cep	*cep = sk_to_cep(sk);
+
+	cep->sk_write_space(sk);
+
+	if (!test_bit(SOCK_NOSPACE, &sk->sk_socket->flags))
+		siw_sq_start(cep->qp);
+}
+
+static int siw_qp_readq_init(struct siw_qp *qp, int irq_size, int orq_size)
+{
+	dprint(DBG_CM|DBG_WR, "(QP%d): %d %d\n", QP_ID(qp), irq_size, orq_size);
+
+	if (!irq_size)
+		irq_size = 1;
+	if (!orq_size)
+		orq_size = 1;
+
+	qp->attrs.irq_size = irq_size;
+	qp->attrs.orq_size = orq_size;
+
+	qp->irq = vmalloc(irq_size * sizeof(struct siw_sqe));
+	if (!qp->irq) {
+		dprint(DBG_ON, "(QP%d): Failed\n", QP_ID(qp));
+		qp->attrs.irq_size = 0;
+		return -ENOMEM;
+	}
+	qp->orq = vmalloc(orq_size * sizeof(struct siw_sqe));
+	if (!qp->orq) {
+		dprint(DBG_ON, "(QP%d): Failed\n", QP_ID(qp));
+		qp->attrs.orq_size = 0;
+		qp->attrs.irq_size = 0;
+		vfree(qp->irq);
+		return -ENOMEM;
+	}
+	memset(qp->irq, 0, irq_size * sizeof(struct siw_sqe));
+	memset(qp->orq, 0, orq_size * sizeof(struct siw_sqe));
+
+	return 0;
+}
+
+
+static int siw_qp_enable_crc(struct siw_qp *qp)
+{
+	struct siw_iwarp_rx *c_rx = &qp->rx_ctx;
+	struct siw_iwarp_tx *c_tx = &qp->tx_ctx;
+	int rv = 0;
+
+	if (siw_crypto_shash == NULL) {
+		rv = -ENOSYS;
+		goto error;
+	}
+	c_tx->mpa_crc_hd = kzalloc(sizeof(struct shash_desc) +
+				   crypto_shash_descsize(siw_crypto_shash),
+				   GFP_KERNEL);
+	c_rx->mpa_crc_hd = kzalloc(sizeof(struct shash_desc) +
+				   crypto_shash_descsize(siw_crypto_shash),
+				   GFP_KERNEL);
+	if (!c_tx->mpa_crc_hd || !c_rx->mpa_crc_hd) {
+		rv = -ENOMEM;
+		goto error;
+	}
+	c_tx->mpa_crc_hd->tfm = siw_crypto_shash;
+	c_rx->mpa_crc_hd->tfm = siw_crypto_shash;
+
+	return 0;
+error:
+	dprint(DBG_ON, "(QP%d): Failed loading crc32c: error=%d.",
+			QP_ID(qp), rv);
+
+	kfree(c_tx->mpa_crc_hd);
+	kfree(c_rx->mpa_crc_hd);
+
+	c_tx->mpa_crc_hd = c_rx->mpa_crc_hd = NULL;
+
+	return rv;
+}
+
+/*
+ * Send a non signalled READ or WRITE to peer side as negotiated
+ * with MPAv2 P2P setup protocol. The work request is only created
+ * as a current active WR and does not consume Send Queue space.
+ *
+ * Caller must hold QP state lock.
+ */
+int siw_qp_mpa_rts(struct siw_qp *qp, enum mpa_v2_ctrl ctrl)
+{
+	struct siw_wqe	*wqe = tx_wqe(qp);
+	unsigned long flags;
+	int rv = 0;
+
+	spin_lock_irqsave(&qp->sq_lock, flags);
+
+	if (unlikely(wqe->wr_status != SIW_WR_IDLE)) {
+		spin_unlock_irqrestore(&qp->sq_lock, flags);
+		return -EIO;
+	}
+	memset(wqe->mem, 0, sizeof(*wqe->mem) * SIW_MAX_SGE);
+
+	wqe->wr_status = SIW_WR_QUEUED;
+	wqe->sqe.flags = 0;
+	wqe->sqe.num_sge = 1;
+	wqe->sqe.sge[0].length = 0;
+	wqe->sqe.sge[0].laddr = 0;
+	wqe->sqe.sge[0].lkey = 0;
+	/*
+	 * While it must not be checked for inbound zero length
+	 * READ/WRITE, some HW may treat STag 0 special.
+	 */
+	wqe->sqe.rkey = 1;
+	wqe->sqe.raddr = 0;
+	wqe->processed = 0;
+
+	if (ctrl & MPA_V2_RDMA_WRITE_RTR)
+		wqe->sqe.opcode = SIW_OP_WRITE;
+	else if (ctrl & MPA_V2_RDMA_READ_RTR) {
+		struct siw_sqe	*rreq;
+
+		wqe->sqe.opcode = SIW_OP_READ;
+
+		spin_lock(&qp->orq_lock);
+
+		rreq = orq_get_free(qp);
+		if (rreq) {
+			siw_read_to_orq(rreq, &wqe->sqe);
+			qp->orq_put++;
+		} else
+			rv = -EIO;
+
+		spin_unlock(&qp->orq_lock);
+	} else
+		rv = -EINVAL;
+
+	if (rv)
+		wqe->wr_status = SIW_WR_IDLE;
+
+	spin_unlock_irqrestore(&qp->sq_lock, flags);
+
+	if (!rv)
+		siw_sq_start(qp);
+
+	return rv;
+}
+
+/*
+ * handle all attrs other than state
+ */
+static void siw_qp_modify_nonstate(struct siw_qp *qp,
+				  struct siw_qp_attrs *attrs,
+				  enum siw_qp_attr_mask mask)
+{
+	if (mask & SIW_QP_ATTR_ACCESS_FLAGS) {
+		if (attrs->flags & SIW_RDMA_BIND_ENABLED)
+			qp->attrs.flags |= SIW_RDMA_BIND_ENABLED;
+		else
+			qp->attrs.flags &= ~SIW_RDMA_BIND_ENABLED;
+
+		if (attrs->flags & SIW_RDMA_WRITE_ENABLED)
+			qp->attrs.flags |= SIW_RDMA_WRITE_ENABLED;
+		else
+			qp->attrs.flags &= ~SIW_RDMA_WRITE_ENABLED;
+
+		if (attrs->flags & SIW_RDMA_READ_ENABLED)
+			qp->attrs.flags |= SIW_RDMA_READ_ENABLED;
+		else
+			qp->attrs.flags &= ~SIW_RDMA_READ_ENABLED;
+	}
+}
+
+/*
+ * caller holds qp->state_lock
+ */
+int siw_qp_modify(struct siw_qp *qp, struct siw_qp_attrs *attrs,
+		  enum siw_qp_attr_mask mask)
+{
+	int	drop_conn = 0, rv = 0;
+
+	if (!mask)
+		return 0;
+
+	dprint(DBG_CM, "(QP%d)\n", QP_ID(qp));
+
+	if (mask != SIW_QP_ATTR_STATE)
+		siw_qp_modify_nonstate(qp, attrs, mask);
+
+	if (!(mask & SIW_QP_ATTR_STATE))
+		return 0;
+
+	dprint(DBG_CM, "(QP%d): SIW QP state: %s => %s\n", QP_ID(qp),
+		siw_qp_state_to_string[qp->attrs.state],
+		siw_qp_state_to_string[attrs->state]);
+
+
+	switch (qp->attrs.state) {
+
+	case SIW_QP_STATE_IDLE:
+	case SIW_QP_STATE_RTR:
+
+		switch (attrs->state) {
+
+		case SIW_QP_STATE_RTS:
+
+			if (attrs->flags & SIW_MPA_CRC) {
+				rv = siw_qp_enable_crc(qp);
+				if (rv)
+					break;
+			}
+			if (!(mask & SIW_QP_ATTR_LLP_HANDLE)) {
+				dprint(DBG_ON, "(QP%d): socket?\n", QP_ID(qp));
+				rv = -EINVAL;
+				break;
+			}
+			if (!(mask & SIW_QP_ATTR_MPA)) {
+				dprint(DBG_ON, "(QP%d): MPA?\n", QP_ID(qp));
+				rv = -EINVAL;
+				break;
+			}
+			dprint(DBG_CM, "(QP%d): Enter RTS\n", QP_ID(qp));
+			dprint(DBG_CM, " peer 0x%08x, local 0x%08x\n",
+				qp->cep->llp.raddr.sin_addr.s_addr,
+				qp->cep->llp.laddr.sin_addr.s_addr);
+			/*
+			 * Initialize global iWARP TX state
+			 */
+			qp->tx_ctx.ddp_msn[RDMAP_UNTAGGED_QN_SEND] = 0;
+			qp->tx_ctx.ddp_msn[RDMAP_UNTAGGED_QN_RDMA_READ] = 0;
+			qp->tx_ctx.ddp_msn[RDMAP_UNTAGGED_QN_TERMINATE] = 0;
+
+			/*
+			 * Initialize global iWARP RX state
+			 */
+			qp->rx_ctx.ddp_msn[RDMAP_UNTAGGED_QN_SEND] = 1;
+			qp->rx_ctx.ddp_msn[RDMAP_UNTAGGED_QN_RDMA_READ] = 1;
+			qp->rx_ctx.ddp_msn[RDMAP_UNTAGGED_QN_TERMINATE] = 1;
+
+			/*
+			 * init IRD free queue, caller has already checked
+			 * limits.
+			 */
+			rv = siw_qp_readq_init(qp, attrs->irq_size,
+					       attrs->orq_size);
+			if (rv)
+				break;
+
+			qp->attrs.llp_stream_handle = attrs->llp_stream_handle;
+			qp->attrs.state = SIW_QP_STATE_RTS;
+
+			break;
+
+		case SIW_QP_STATE_ERROR:
+			siw_rq_flush(qp);
+			qp->attrs.state = SIW_QP_STATE_ERROR;
+			if (qp->cep) {
+				siw_cep_put(qp->cep);
+				qp->cep = NULL;
+			}
+			break;
+
+		case SIW_QP_STATE_RTR:
+			/* ignore */
+			break;
+
+		default:
+			dprint(DBG_CM,
+				" QP state transition undefined: %s => %s\n",
+				siw_qp_state_to_string[qp->attrs.state],
+				siw_qp_state_to_string[attrs->state]);
+			break;
+		}
+		break;
+
+	case SIW_QP_STATE_RTS:
+
+		switch (attrs->state) {
+
+		case SIW_QP_STATE_CLOSING:
+			/*
+			 * Verbs: move to IDLE if SQ and ORQ are empty.
+			 * Move to ERROR otherwise. But first of all we must
+			 * close the connection. So we keep CLOSING or ERROR
+			 * as a transient state, schedule connection drop work
+			 * and wait for the socket state change upcall to
+			 * come back closed.
+			 */
+			if (tx_wqe(qp)->wr_status == SIW_WR_IDLE)
+				qp->attrs.state = SIW_QP_STATE_CLOSING;
+			else {
+				qp->attrs.state = SIW_QP_STATE_ERROR;
+				siw_sq_flush(qp);
+			}
+			siw_rq_flush(qp);
+
+			drop_conn = 1;
+			break;
+
+		case SIW_QP_STATE_TERMINATE:
+			qp->attrs.state = SIW_QP_STATE_TERMINATE;
+			/*
+			 * To be extended for flexible error layer,
+			 * type and code.
+			 */
+			siw_send_terminate(qp, RDMAP_ERROR_LAYER_RDMA,
+					   RDMAP_ETYPE_CATASTROPHIC,
+					   0);
+			drop_conn = 1;
+
+			break;
+
+		case SIW_QP_STATE_ERROR:
+			/*
+			 * This is an emergency close.
+			 *
+			 * Any in progress transmit operation will get
+			 * cancelled.
+			 * This will likely result in a protocol failure,
+			 * if a TX operation is in transit. The caller
+			 * could unconditional wait to give the current
+			 * operation a chance to complete.
+			 * Esp., how to handle the non-empty IRQ case?
+			 * The peer was asking for data transfer at a valid
+			 * point in time.
+			 */
+			siw_sq_flush(qp);
+			siw_rq_flush(qp);
+			qp->attrs.state = SIW_QP_STATE_ERROR;
+			drop_conn = 1;
+
+			break;
+
+		default:
+			dprint(DBG_ON,
+				" QP state transition undefined: %s => %s\n",
+				siw_qp_state_to_string[qp->attrs.state],
+				siw_qp_state_to_string[attrs->state]);
+			break;
+		}
+		break;
+
+	case SIW_QP_STATE_TERMINATE:
+
+		switch (attrs->state) {
+
+		case SIW_QP_STATE_ERROR:
+			siw_rq_flush(qp);
+			qp->attrs.state = SIW_QP_STATE_ERROR;
+
+			if (tx_wqe(qp)->wr_status != SIW_WR_IDLE)
+				siw_sq_flush(qp);
+
+			break;
+
+		default:
+			dprint(DBG_ON,
+				" QP state transition undefined: %s => %s\n",
+				siw_qp_state_to_string[qp->attrs.state],
+				siw_qp_state_to_string[attrs->state]);
+		}
+		break;
+
+	case SIW_QP_STATE_CLOSING:
+
+		switch (attrs->state) {
+
+		case SIW_QP_STATE_IDLE:
+			BUG_ON(tx_wqe(qp)->wr_status != SIW_WR_IDLE);
+			qp->attrs.state = SIW_QP_STATE_IDLE;
+
+			break;
+
+		case SIW_QP_STATE_CLOSING:
+			/*
+			 * The LLP may already moved the QP to closing
+			 * due to graceful peer close init
+			 */
+			break;
+
+		case SIW_QP_STATE_ERROR:
+			/*
+			 * QP was moved to CLOSING by LLP event
+			 * not yet seen by user.
+			 */
+			qp->attrs.state = SIW_QP_STATE_ERROR;
+
+			if (tx_wqe(qp)->wr_status != SIW_WR_IDLE)
+				siw_sq_flush(qp);
+
+			siw_rq_flush(qp);
+
+			break;
+
+		default:
+			dprint(DBG_CM,
+				" QP state transition undefined: %s => %s\n",
+				siw_qp_state_to_string[qp->attrs.state],
+				siw_qp_state_to_string[attrs->state]);
+			return -ECONNABORTED;
+		}
+		break;
+
+	default:
+		dprint(DBG_CM, " NOP: State: %d\n", qp->attrs.state);
+		break;
+	}
+	if (drop_conn)
+		siw_qp_cm_drop(qp, 0);
+
+	return rv;
+}
+
+struct ib_qp *siw_get_ofaqp(struct ib_device *ofa_dev, int id)
+{
+	struct siw_qp *qp =  siw_qp_id2obj(siw_dev_ofa2siw(ofa_dev), id);
+
+	dprint(DBG_OBJ, ": dev_name: %s, OFA QPID: %d, QP: %p\n",
+		ofa_dev->name, id, qp);
+	if (qp) {
+		/*
+		 * siw_qp_id2obj() increments object reference count
+		 */
+		siw_qp_put(qp);
+		dprint(DBG_OBJ, " QPID: %d\n", QP_ID(qp));
+		return &qp->ofa_qp;
+	}
+	return (struct ib_qp *)NULL;
+}
+
+/*
+ * siw_check_mem()
+ *
+ * Check protection domain, STAG state, access permissions and
+ * address range for memory object.
+ *
+ * @pd:		Protection Domain memory should belong to
+ * @mem:	memory to be checked
+ * @addr:	starting addr of mem
+ * @perms:	requested access permissions
+ * @len:	len of memory interval to be checked
+ *
+ */
+int siw_check_mem(struct siw_pd *pd, struct siw_mem *mem, u64 addr,
+		  enum siw_access_flags perms, int len)
+{
+	if (siw_mem2mr(mem)->pd != pd) {
+		dprint(DBG_WR|DBG_ON, "(PD%d): PD mismatch %p : %p\n",
+			OBJ_ID(pd),
+			siw_mem2mr(mem)->pd, pd);
+
+		return -EINVAL;
+	}
+	if (mem->stag_valid == 0) {
+		dprint(DBG_WR|DBG_ON, "(PD%d): STAG 0x%08x invalid\n",
+			OBJ_ID(pd), OBJ_ID(mem));
+		return -EPERM;
+	}
+	/*
+	 * check access permissions
+	 */
+	if ((mem->perms & perms) < perms) {
+		dprint(DBG_WR|DBG_ON, "(PD%d): permissions 0x%08x < 0x%08x\n",
+			OBJ_ID(pd), mem->perms, perms);
+		return -EPERM;
+	}
+	/*
+	 * Check address interval: we relax check to allow memory shrinked
+	 * from the start address _after_ placing or fetching len bytes.
+	 * TODO: this relaxation is probably overdone
+	 */
+	if (addr < mem->va || addr + len > mem->va + mem->len) {
+		dprint(DBG_WR|DBG_ON, "(PD%d): MEM interval len %d "
+			"[0x%016llx, 0x%016llx) out of bounds "
+			"[0x%016llx, 0x%016llx) for LKey=0x%08x\n",
+			OBJ_ID(pd), len, (unsigned long long)addr,
+			(unsigned long long)(addr + len),
+			(unsigned long long)mem->va,
+			(unsigned long long)(mem->va + mem->len),
+			OBJ_ID(mem));
+
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ * siw_check_sge()
+ *
+ * Check SGE for access rights in given interval
+ *
+ * @pd:		Protection Domain memory should belong to
+ * @sge:	SGE to be checked
+ * @mem:	resulting memory reference if successful
+ * @perms:	requested access permissions
+ * @off:	starting offset in SGE
+ * @len:	len of memory interval to be checked
+ *
+ * NOTE: Function references SGE's memory object (mem->obj)
+ * if not yet done. New reference is kept if check went ok and
+ * released if check failed. If mem->obj is already valid, no new
+ * lookup is being done and mem is not released it check fails.
+ */
+int
+siw_check_sge(struct siw_pd *pd, struct siw_sge *sge,
+	      union siw_mem_resolved *mem, enum siw_access_flags perms,
+	      u32 off, int len)
+{
+	struct siw_dev	*sdev = pd->hdr.sdev;
+	int		new_ref = 0, rv = 0;
+
+	if (len + off > sge->length) {
+		rv = -EPERM;
+		goto fail;
+	}
+	if (mem->obj == NULL) {
+		mem->obj = siw_mem_id2obj(sdev, sge->lkey >> 8);
+		if (mem->obj == NULL) {
+			rv = -EINVAL;
+			goto fail;
+		}
+		new_ref = 1;
+	}
+
+	rv = siw_check_mem(pd, mem->obj, sge->laddr + off, perms, len);
+	if (rv)
+		goto fail;
+
+	return 0;
+
+fail:
+	if (new_ref) {
+		siw_mem_put(mem->obj);
+		mem->obj = NULL;
+	}
+	return rv;
+}
+
+void siw_read_to_orq(struct siw_sqe *rreq, struct siw_sqe *sqe)
+{
+	rreq->id = sqe->id;
+	rreq->opcode = sqe->opcode;
+	rreq->sge[0].laddr = sqe->sge[0].laddr;
+	rreq->sge[0].length = sqe->sge[0].length;
+	rreq->sge[0].lkey = sqe->sge[0].lkey;
+	rreq->sge[1].lkey = sqe->sge[1].lkey;
+	rreq->flags = sqe->flags | SIW_WQE_VALID;
+	rreq->num_sge = 1;
+}
+
+/*
+ * Must be called with SQ locked
+ */
+int siw_activate_tx(struct siw_qp *qp)
+{
+	struct siw_sqe	*sqe;
+	struct siw_wqe	*wqe = tx_wqe(qp);
+	int rv = 1;
+
+	/*
+	 * This codes prefers pending READ Responses over SQ processing
+	 */
+	sqe = &qp->irq[qp->irq_get % qp->attrs.irq_size];
+
+	if (sqe->flags & SIW_WQE_VALID) {
+		memset(wqe->mem, 0, sizeof(*wqe->mem) * SIW_MAX_SGE);
+		wqe->wr_status = SIW_WR_QUEUED;
+
+		/* start READ RESPONSE */
+		wqe->sqe.opcode = SIW_OP_READ_RESPONSE;
+		wqe->sqe.flags = 0;
+		wqe->sqe.num_sge = 1;
+		wqe->sqe.sge[0].length = sqe->sge[0].length;
+		wqe->sqe.sge[0].laddr = sqe->sge[0].laddr;
+		wqe->sqe.sge[0].lkey = sqe->sge[0].lkey;
+		wqe->sqe.rkey = sqe->rkey;
+		wqe->sqe.raddr = sqe->raddr;
+
+		wqe->processed = 0;
+		qp->irq_get++;
+		/* mark current IRQ entry free */
+		smp_store_mb(sqe->flags, 0);
+
+		goto out;
+	}
+
+	sqe = sq_get_next(qp);
+	if (sqe) {
+		memset(wqe->mem, 0, sizeof(*wqe->mem) * SIW_MAX_SGE);
+		wqe->wr_status = SIW_WR_QUEUED;
+
+		/* First copy SQE to kernel private memory */
+		memcpy(&wqe->sqe, sqe, sizeof(*sqe));
+
+		if (wqe->sqe.opcode >= SIW_NUM_OPCODES) {
+			rv = -EINVAL;
+			goto out;
+		}
+
+		if (wqe->sqe.flags & SIW_WQE_INLINE) {
+			if (wqe->sqe.opcode != SIW_OP_SEND &&
+			    wqe->sqe.opcode != SIW_OP_WRITE) {
+				rv = -EINVAL;
+				goto out;
+			}
+			if (wqe->sqe.sge[0].length > SIW_MAX_INLINE) {
+				rv = -EINVAL;
+				goto out;
+			}
+			wqe->sqe.sge[0].laddr = (u64)&wqe->sqe.sge[1];
+			wqe->sqe.sge[0].lkey = 0;
+			wqe->sqe.num_sge = 1;
+		}
+
+		if (wqe->sqe.flags & SIW_WQE_READ_FENCE) {
+			/* A READ cannot be fenced */
+			if (unlikely(wqe->sqe.opcode == SIW_OP_READ ||
+			    wqe->sqe.opcode == SIW_OP_READ_LOCAL_INV)) {
+				pr_info("QP[%d]: cannot fence READ\n",
+					QP_ID(qp));
+				rv = -EINVAL;
+				goto out;
+			}
+			spin_lock(&qp->orq_lock);
+
+			if (!siw_orq_empty(qp)) {
+				qp->tx_ctx.orq_fence = 1;
+				rv = 0;
+			}
+			spin_unlock(&qp->orq_lock);
+
+		} else if (wqe->sqe.opcode == SIW_OP_READ ||
+			   wqe->sqe.opcode == SIW_OP_READ_LOCAL_INV) {
+			struct siw_sqe	*rreq;
+
+			wqe->sqe.num_sge = 1;
+
+			spin_lock(&qp->orq_lock);
+
+			rreq = orq_get_free(qp);
+			if (rreq) {
+				/*
+				 * Make an immediate copy in ORQ to be ready
+				 * to process loopback READ reply
+				 */
+				siw_read_to_orq(rreq, &wqe->sqe);
+				qp->orq_put++;
+			} else {
+				qp->tx_ctx.orq_fence = 1;
+				rv = 0;
+			}
+			spin_unlock(&qp->orq_lock);
+		}
+
+		/* Clear SQE, can be re-used by application */
+		smp_store_mb(sqe->flags, 0);
+		qp->sq_get++;
+	} else
+		rv = 0;
+
+out:
+	if (unlikely(rv < 0)) {
+		pr_warn("QP[%d]: error %d in activate_tx\n", QP_ID(qp), rv);
+		wqe->wr_status = SIW_WR_IDLE;
+	}
+	return rv;
+}
+
+static void siw_cq_notify(struct siw_cq *cq, u32 flags)
+{
+	u32 cq_notify;
+
+	if (unlikely(!cq->ofa_cq.comp_handler))
+		return;
+
+	cq_notify = _load_shared(*cq->notify);
+
+	if ((cq_notify & SIW_NOTIFY_NEXT_COMPLETION) ||
+	    ((cq_notify & SIW_NOTIFY_SOLICITED) &&
+	     (flags & SIW_WQE_SOLICITED))) {
+		/* de-arm CQ */
+		smp_store_mb(*cq->notify, SIW_NOTIFY_NOT);
+		(*cq->ofa_cq.comp_handler)(&cq->ofa_cq, cq->ofa_cq.cq_context);
+	}
+}
+
+int siw_sqe_complete(struct siw_qp *qp, struct siw_sqe *sqe, u32 bytes,
+		     enum siw_wc_status status)
+{
+	struct siw_cq *cq = qp->scq;
+	struct siw_cqe *cqe;
+	u32 idx;
+	int rv = 0;
+
+	if (cq) {
+		u32 sqe_flags = sqe->flags;
+		unsigned long flags;
+
+		spin_lock_irqsave(&cq->lock, flags);
+
+		idx = cq->cq_put % cq->num_cqe;
+		cqe = &cq->queue[idx];
+
+		if (!cqe->flags) {
+			cqe->id = sqe->id;
+			cqe->opcode = sqe->opcode;
+			cqe->status = status;
+			cqe->imm_data = 0;
+			cqe->bytes = bytes;
+
+			if (cq->kernel_verbs) {
+				siw_qp_get(qp);
+				cqe->qp = qp;
+			} else
+				cqe->qp_id = QP_ID(qp);
+
+			/* mark CQE valid for application */
+			smp_store_mb(cqe->flags, SIW_WQE_VALID);
+			/* recycle SQE */
+			smp_store_mb(sqe->flags, 0);
+
+			cq->cq_put++;
+			spin_unlock_irqrestore(&cq->lock, flags);
+			siw_cq_notify(cq, sqe_flags);
+		} else {
+			spin_unlock_irqrestore(&cq->lock, flags);
+			rv = -ENOMEM;
+			siw_cq_event(cq, IB_EVENT_CQ_ERR);
+		}
+	} else /* recycle SQE */
+		smp_store_mb(sqe->flags, 0);
+
+	return rv;
+}
+
+int siw_rqe_complete(struct siw_qp *qp, struct siw_rqe *rqe, u32 bytes,
+		     enum siw_wc_status status)
+{
+	struct siw_cq *cq = qp->rcq;
+	struct siw_cqe *cqe;
+	u32 idx;
+	int rv = 0;
+
+	if (cq) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&cq->lock, flags);
+
+		idx = cq->cq_put % cq->num_cqe;
+		cqe = &cq->queue[idx];
+
+		if (!cqe->flags) {
+			cqe->id = rqe->id;
+			cqe->opcode = SIW_OP_RECEIVE;
+			cqe->status = status;
+			cqe->imm_data = 0;
+			cqe->bytes = bytes;
+
+			if (cq->kernel_verbs) {
+				siw_qp_get(qp);
+				cqe->qp = qp;
+			} else
+				cqe->qp_id = QP_ID(qp);
+
+			/* mark CQE valid for application */
+			smp_store_mb(cqe->flags, SIW_WQE_VALID);
+			/* recycle RQE */
+			smp_store_mb(rqe->flags, 0);
+
+			cq->cq_put++;
+			spin_unlock_irqrestore(&cq->lock, flags);
+			siw_cq_notify(cq, SIW_WQE_SIGNALLED);
+		} else {
+			spin_unlock_irqrestore(&cq->lock, flags);
+			rv = -ENOMEM;
+			siw_cq_event(cq, IB_EVENT_CQ_ERR);
+		}
+	} else /* recycle RQE */
+		smp_store_mb(rqe->flags, 0);
+
+	return rv;
+}
+
+/*
+ * siw_sq_flush()
+ *
+ * Flush SQ and ORRQ entries to CQ.
+ *
+ * TODO: Add termination code for in-progress WQE.
+ * TODO: an in-progress WQE may have been partially
+ *       processed. It should be enforced, that transmission
+ *       of a started DDP segment must be completed if possible
+ *       by any chance.
+ *
+ * Must be called with QP state write lock held.
+ * Therefore, SQ and ORQ lock must not be taken.
+ */
+void siw_sq_flush(struct siw_qp *qp)
+{
+	struct siw_sqe	*sqe;
+	struct siw_wqe	*wqe = tx_wqe(qp);
+	int		async_event = 0;
+
+	dprint(DBG_OBJ|DBG_CM|DBG_WR, "(QP%d): Enter\n", QP_ID(qp));
+	/*
+	 * Start with completing any work currently on the ORQ
+	 */
+	for (;;) {
+		if (qp->attrs.orq_size == 0)
+			break;
+
+		sqe = &qp->orq[qp->orq_get % qp->attrs.orq_size];
+		if (!sqe->flags)
+			break;
+
+		if (siw_sqe_complete(qp, sqe, 0,
+				     SIW_WC_WR_FLUSH_ERR) != 0)
+			break;
+
+		qp->orq_get++;
+	}
+	/*
+	 * Flush an in-progess WQE if present
+	 */
+	if (wqe->wr_status != SIW_WR_IDLE) {
+		/*
+		 * TODO: Add iWARP Termination code
+		 */
+		dprint(DBG_WR,
+			" (QP%d): Flush current SQE %p, type %d, status %d\n",
+			QP_ID(qp), wqe, tx_type(wqe), wqe->wr_status);
+
+		siw_wqe_put_mem(wqe, tx_type(wqe));
+
+		if (tx_type(wqe) != SIW_OP_READ_RESPONSE &&
+			((tx_type(wqe) != SIW_OP_READ &&
+			  tx_type(wqe) != SIW_OP_READ_LOCAL_INV) ||
+			wqe->wr_status == SIW_WR_QUEUED))
+			/*
+			 * An in-progress RREQUEST is already in
+			 * the ORQ
+			 */
+			siw_sqe_complete(qp, &wqe->sqe, wqe->bytes,
+					 SIW_WC_WR_FLUSH_ERR);
+
+		wqe->wr_status = SIW_WR_IDLE;
+	}
+	/*
+	 * Flush the Send Queue
+	 */
+	while (qp->attrs.sq_size) {
+		sqe = &qp->sendq[qp->sq_get % qp->attrs.sq_size];
+		if (!sqe->flags)
+			break;
+
+		async_event = 1;
+		if (siw_sqe_complete(qp, sqe, 0, SIW_WC_WR_FLUSH_ERR) != 0)
+			/* Shall IB_EVENT_SQ_DRAINED be supressed ? */
+			break;
+
+		sqe->flags = 0;
+		qp->sq_get++;
+	}
+	if (async_event)
+		siw_qp_event(qp, IB_EVENT_SQ_DRAINED);
+}
+
+/*
+ * siw_rq_flush()
+ *
+ * Flush recv queue entries to CQ. 
+ *
+ * Must be called with QP state write lock held.
+ * Therefore, RQ lock must not be taken.
+ */
+void siw_rq_flush(struct siw_qp *qp)
+{
+	struct siw_wqe		*wqe = rx_wqe(qp);
+
+	dprint(DBG_OBJ|DBG_CM|DBG_WR, "(QP%d): Enter\n", QP_ID(qp));
+
+	/*
+	 * Flush an in-progess WQE if present
+	 */
+	if (wqe->wr_status != SIW_WR_IDLE) {
+		dprint(DBG_WR,
+			" (QP%d): Flush current RQE %p, type %d, status %d\n",
+			QP_ID(qp), wqe, rx_type(wqe), wqe->wr_status);
+		siw_wqe_put_mem(wqe, rx_type(wqe));
+		if (rx_type(wqe) == SIW_OP_RECEIVE) {
+			siw_rqe_complete(qp, &wqe->rqe, wqe->bytes,
+					 SIW_WC_WR_FLUSH_ERR);
+		} else if (rx_type(wqe) != SIW_OP_READ &&
+			   rx_type(wqe) != SIW_OP_READ_RESPONSE &&
+			   rx_type(wqe) != SIW_OP_WRITE) {
+			siw_sqe_complete(qp, &wqe->sqe, 0, SIW_WC_WR_FLUSH_ERR);
+		}
+		wqe->wr_status = SIW_WR_IDLE;
+	}
+	/*
+	 * Flush the Receive Queue
+	 */
+	while (qp->attrs.rq_size) {
+		struct siw_rqe *rqe =
+			&qp->recvq[qp->rq_get % qp->attrs.rq_size];
+
+		if (!rqe->flags)
+			break;
+
+		if (siw_rqe_complete(qp, rqe, 0, SIW_WC_WR_FLUSH_ERR) != 0)
+			break;
+
+		rqe->flags = 0;
+		qp->rq_get++;
+	}
+}
diff --git a/drivers/infiniband/sw/siw/siw_qp_rx.c b/drivers/infiniband/sw/siw/siw_qp_rx.c
new file mode 100644
index 000000000000..f89f213687bf
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -0,0 +1,1381 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *          Fredy Neeser <nfd-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/net.h>
+#include <linux/scatterlist.h>
+#include <linux/highmem.h>
+#include <net/sock.h>
+#include <net/tcp_states.h>
+#include <net/tcp.h>
+
+#include <rdma/iw_cm.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+
+#include "siw.h"
+#include "siw_obj.h"
+#include "siw_cm.h"
+
+
+/*
+ * ----------------------------
+ * DDP reassembly for Softiwarp
+ * ----------------------------
+ * For the ordering of transmitted DDP segments, the relevant iWARP ordering
+ * rules are as follows:
+ *
+ * - RDMAP (RFC 5040): Section 7.5, Rule 17:
+ *   "RDMA Read Response Message processing at the Remote Peer (reading
+ *    the specified Tagged Buffer) MUST be started only after the RDMA
+ *    Read Request Message has been Delivered by the DDP layer (thus,
+ *    all previous RDMA Messages have been properly submitted for
+ *    ordered Placement)."
+ *
+ * - DDP (RFC 5041): Section 5.3:
+ *   "At the Data Source, DDP:
+ *    o MUST transmit DDP Messages in the order they were submitted to
+ *      the DDP layer,
+ *    o SHOULD transmit DDP Segments within a DDP Message in increasing
+ *      MO order for Untagged DDP Messages, and in increasing TO order
+ *      for Tagged DDP Messages."
+ *
+ * Combining these rules implies that, although RDMAP does not provide
+ * ordering between operations that are generated from the two ends of an
+ * RDMAP stream, DDP *must not* transmit an RDMA Read Response Message before
+ * it has finished transmitting SQ operations that were already submitted
+ * to the DDP layer. It follows that an iWARP transmitter must fully
+ * serialize RDMAP messages belonging to the same QP.
+ *
+ * Given that a TCP socket receives DDP segments in peer transmit order,
+ * we obtain the following ordering of received DDP segments:
+ *
+ * (i)  the received DDP segments of RDMAP messages for the same QP
+ *      cannot be interleaved
+ * (ii) the received DDP segments of a single RDMAP message *should*
+ *      arrive in order.
+ *
+ * The Softiwarp transmitter obeys rule #2 in DDP Section 5.3.
+ * With this property, the "should" becomes a "must" in (ii) above,
+ * which simplifies DDP reassembly considerably.
+ * The Softiwarp receiver currently relies on this property
+ * and reports an error if DDP segments of the same RDMAP message
+ * do not arrive in sequence.
+ */
+
+static inline int siw_crc_rxhdr(struct siw_iwarp_rx *ctx)
+{
+	crypto_shash_init(ctx->mpa_crc_hd);
+
+	return siw_crc_array(ctx->mpa_crc_hd, (u8 *)&ctx->hdr,
+			     ctx->fpdu_part_rcvd);
+}
+
+/*
+ * siw_rx_umem()
+ *
+ * Receive data of @len into target referenced by @rctx.
+ * This function does not check if umem is within bounds requested by
+ * @len and @t_off. @umem_ends indicates if routine should
+ * not update chunk position pointers after the point it is
+ * currently receiving
+ *
+ * @rctx:	Receive Context
+ * @umem:	siw representation of target memory
+ * @dest_addr:	1, if rctx chunk pointer should not be updated after len.
+ */
+static int siw_rx_umem(struct siw_iwarp_rx *rctx, struct siw_umem *umem,
+		       u64 dest_addr, int len)
+{
+	void	*dest;
+	int	pg_off = dest_addr & ~PAGE_MASK,
+		copied = 0,
+		bytes,
+		rv;
+
+	while (len) {
+		struct page *p = siw_get_upage(umem, dest_addr);
+
+		if (unlikely(!p)) {
+			pr_warn("siw_rx_umem: QP[%d]: bogus addr: %p, %p\n",
+				RX_QPID(rctx),
+				(void *)dest_addr, (void *)umem->fp_addr);
+			/* siw internal error */
+			rctx->skb_copied += copied;
+			rctx->skb_new -= copied;
+			copied = -EFAULT;
+
+			goto out;
+		}
+
+		bytes  = min(len, (int)PAGE_SIZE - pg_off);
+		dest = kmap_atomic(p);
+
+		rv = skb_copy_bits(rctx->skb, rctx->skb_offset, dest + pg_off,
+				   bytes);
+
+		dprint(DBG_RX,
+			"(QP%d): skb_copy_bits():: Page %p, bytes=%u, rv=%d\n",
+			RX_QPID(rctx), p, bytes, rv);
+
+		if (likely(!rv)) {
+			if (rctx->mpa_crc_hd)
+				rv = siw_crc_page(rctx->mpa_crc_hd, p, pg_off,
+						  bytes);
+
+			rctx->skb_offset += bytes;
+			copied += bytes;
+			len -= bytes;
+			dest_addr += bytes;
+			pg_off = 0;
+		}
+		kunmap_atomic(dest);
+
+		if (unlikely(rv)) {
+			rctx->skb_copied += copied;
+			rctx->skb_new -= copied;
+			copied = -EFAULT;
+
+			dprint(DBG_RX|DBG_ON, "(QP%d): failed with %d\n",
+				RX_QPID(rctx), rv);
+
+			goto out;
+		}
+	}
+	/*
+	 * store chunk position for resume
+	 */
+	rctx->skb_copied += copied;
+	rctx->skb_new -= copied;
+out:
+	return copied;
+}
+
+static inline int siw_rx_kva(struct siw_iwarp_rx *rctx, void *kva, int len)
+{
+	int rv;
+
+	dprint(DBG_RX, "(QP%d): receive %d bytes into %p\n", RX_QPID(rctx),
+		len, kva);
+
+	rv = skb_copy_bits(rctx->skb, rctx->skb_offset, kva, len);
+	if (likely(!rv)) {
+		rctx->skb_offset += len;
+		rctx->skb_copied += len;
+		rctx->skb_new -= len;
+		if (rctx->mpa_crc_hd) {
+			rv = siw_crc_array(rctx->mpa_crc_hd, kva, len);
+			if (rv)
+				goto error;
+		}
+		return len;
+	}
+	dprint(DBG_ON, "(QP%d): failed: len %d, addr %p, rv %d\n",
+		RX_QPID(rctx), len, kva, rv);
+error:
+	return rv;
+}
+
+static int siw_rx_pbl(struct siw_iwarp_rx *rctx, struct siw_mr *mr,
+		      u64 addr, int len)
+{
+	struct siw_pbl *pbl = mr->pbl;
+	u64 offset = addr - mr->mem.va;
+	int copied = 0;
+
+	while (len) {
+		int bytes;
+		u64 buf_addr = siw_pbl_get_buffer(pbl, offset, &bytes,
+						  &rctx->pbl_idx);
+		if (buf_addr == 0)
+			break;
+		bytes = min(bytes, len);
+		if (siw_rx_kva(rctx, (void *)buf_addr, bytes) == bytes) {
+			copied += bytes;
+			offset += bytes;
+			len -= bytes;
+		} else
+			break;
+	}
+	return copied;
+}
+
+/*
+ * siw_rresp_check_ntoh()
+ *
+ * Check incoming RRESP fragment header against expected
+ * header values and update expected values for potential next
+ * fragment.
+ *
+ * NOTE: This function must be called only if a RRESP DDP segment
+ *       starts but not for fragmented consecutive pieces of an
+ *       already started DDP segement.
+ */
+static inline int siw_rresp_check_ntoh(struct siw_iwarp_rx *rctx)
+{
+	struct iwarp_rdma_rresp	*rresp = &rctx->hdr.rresp;
+	struct siw_wqe		*wqe = &rctx->wqe_active;
+
+	u32 sink_stag = be32_to_cpu(rresp->sink_stag);
+	u64 sink_to   = be64_to_cpu(rresp->sink_to);
+
+	if (rctx->first_ddp_seg) {
+		rctx->ddp_stag = wqe->sqe.sge[0].lkey;
+		rctx->ddp_to = wqe->sqe.sge[0].laddr;
+		rctx->pbl_idx = 0;
+	}
+	if (rctx->ddp_stag != sink_stag) {
+		dprint(DBG_RX|DBG_ON,
+			" received STAG=%08x, expected STAG=%08x\n",
+			sink_stag, rctx->ddp_stag);
+		return -EINVAL;
+	}
+	if (rctx->ddp_to != sink_to) {
+		dprint(DBG_RX|DBG_ON,
+			" received TO=%016llx, expected TO=%016llx\n",
+			(unsigned long long)sink_to,
+			(unsigned long long)rctx->ddp_to);
+		return -EINVAL;
+	}
+	if (!rctx->more_ddp_segs && (wqe->processed + rctx->fpdu_part_rem
+				     != wqe->bytes)) {
+		dprint(DBG_RX|DBG_ON,
+			" RRESP len error, peer sent %d, RREQ asked %d\n",
+			wqe->processed + rctx->fpdu_part_rem, wqe->bytes);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ * siw_write_check_ntoh()
+ *
+ * Check incoming WRITE fragment header against expected
+ * header values and update expected values for potential next
+ * fragment
+ *
+ * NOTE: This function must be called only if a WRITE DDP segment
+ *       starts but not for fragmented consecutive pieces of an
+ *       already started DDP segement.
+ */
+static inline int siw_write_check_ntoh(struct siw_iwarp_rx *rctx)
+{
+	struct iwarp_rdma_write	*write = &rctx->hdr.rwrite;
+
+	u32 sink_stag = be32_to_cpu(write->sink_stag);
+	u64 sink_to   = be64_to_cpu(write->sink_to);
+
+	if (rctx->first_ddp_seg) {
+		rctx->ddp_stag = sink_stag;
+		rctx->ddp_to = sink_to;
+		rctx->pbl_idx = 0;
+	} else {
+		if (rctx->ddp_stag != sink_stag) {
+			dprint(DBG_RX|DBG_ON,
+				" received STAG=%08x, expected STAG=%08x\n",
+				sink_stag, rctx->ddp_stag);
+			return -EINVAL;
+		}
+		if (rctx->ddp_to != sink_to) {
+			dprint(DBG_RX|DBG_ON,
+				" received TO=%016llx, expected TO=%016llx\n",
+				(unsigned long long)sink_to,
+				(unsigned long long)rctx->ddp_to);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+/*
+ * siw_send_check_ntoh()
+ *
+ * Check incoming SEND fragment header against expected
+ * header values and update expected MSN if no next
+ * fragment expected
+ *
+ * NOTE: This function must be called only if a SEND DDP segment
+ *       starts but not for fragmented consecutive pieces of an
+ *       already started DDP segement.
+ */
+static inline int siw_send_check_ntoh(struct siw_iwarp_rx *rctx)
+{
+	struct iwarp_send_inv	*send = &rctx->hdr.send_inv;
+	struct siw_wqe		*wqe = &rctx->wqe_active;
+
+	u32 ddp_msn = be32_to_cpu(send->ddp_msn);
+	u32 ddp_mo  = be32_to_cpu(send->ddp_mo);
+	u32 ddp_qn  = be32_to_cpu(send->ddp_qn);
+
+	if (ddp_qn != RDMAP_UNTAGGED_QN_SEND) {
+		dprint(DBG_RX|DBG_ON, " Invalid DDP QN %d for SEND\n",
+			ddp_qn);
+		return -EINVAL;
+	}
+	if (unlikely(ddp_msn != rctx->ddp_msn[RDMAP_UNTAGGED_QN_SEND])) {
+		dprint(DBG_RX|DBG_ON, " received MSN=%u, expected MSN=%u\n",
+			ddp_msn, rctx->ddp_msn[RDMAP_UNTAGGED_QN_SEND]);
+		return -EINVAL;
+	}
+	if (unlikely(ddp_mo != wqe->processed)) {
+		dprint(DBG_RX|DBG_ON, " Received MO=%u, expected MO=%u\n",
+			ddp_mo, wqe->processed);
+		return -EINVAL;
+	}
+	if (rctx->first_ddp_seg) {
+		/* initialize user memory write position */
+		rctx->sge_idx = 0;
+		rctx->sge_off = 0;
+		rctx->pbl_idx = 0;
+		/* only valid for SEND_INV and SEND_SE_INV operations */
+		rctx->inval_stag = be32_to_cpu(send->inval_stag);
+	}
+	if (unlikely(wqe->bytes < wqe->processed + rctx->fpdu_part_rem)) {
+		dprint(DBG_RX|DBG_ON, " Receive space short: (%d - %d) < %d\n",
+			wqe->bytes, wqe->processed, rctx->fpdu_part_rem);
+		wqe->wc_status = SIW_WC_LOC_LEN_ERR;
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct siw_wqe *siw_rqe_get(struct siw_qp *qp)
+{
+	struct siw_rqe *rqe;
+	struct siw_srq *srq = qp->srq;
+	struct siw_wqe *wqe = NULL;
+	unsigned long flags;
+	bool srq_used = false;
+
+	if (srq) {
+		/*
+		 * 'srq_used' usage:
+		 * convince gcc we know what we do. testing validity
+		 * of 'srq' should be sufficient but gives
+		 * "‘flags’ may be used uninitialized ..." later for unlock
+		 */
+		srq_used = true;
+		spin_lock_irqsave(&srq->lock, flags);
+		rqe = &srq->recvq[srq->rq_get % srq->num_rqe];
+	} else
+		rqe = &qp->recvq[qp->rq_get % qp->attrs.rq_size];
+
+	if (likely(rqe->flags == SIW_WQE_VALID)) {
+		int num_sge = rqe->num_sge;
+
+		if (likely(num_sge <= SIW_MAX_SGE)) {
+			int i = 0;
+
+			wqe = rx_wqe(qp);
+			rx_type(wqe) = SIW_OP_RECEIVE;
+			wqe->wr_status = SIW_WR_INPROGRESS;
+			wqe->bytes = 0;
+			wqe->processed = 0;
+
+			wqe->rqe.id = rqe->id;
+			wqe->rqe.num_sge = num_sge;
+
+			while (i < num_sge) {
+				wqe->rqe.sge[i].laddr = rqe->sge[i].laddr;
+				wqe->rqe.sge[i].lkey = rqe->sge[i].lkey;
+				wqe->rqe.sge[i].length = rqe->sge[i].length;
+				wqe->bytes += wqe->rqe.sge[i].length;
+				wqe->mem[i].obj = NULL;
+				i++;
+			}
+			/* can be re-used by appl */
+			smp_store_mb(rqe->flags, 0);
+		} else {
+			pr_info("RQE: too many SGE's: %d\n", rqe->num_sge);
+			goto out;
+		}
+		if (srq_used == false)
+			qp->rq_get++;
+		else {
+			if (srq->armed) {
+				/* Test SRQ limit */
+				u32 off = (srq->rq_get + srq->limit) %
+					  srq->num_rqe;
+				struct siw_rqe *rqe2 = &srq->recvq[off];
+
+				if (!(rqe2->flags & SIW_WQE_VALID)) {
+					srq->armed = 0;
+					siw_srq_event(srq,
+						IB_EVENT_SRQ_LIMIT_REACHED);
+				}
+			}
+			srq->rq_get++;
+		}
+	}
+out:
+	if (srq_used)
+		spin_unlock_irqrestore(&srq->lock, flags);
+
+	return wqe;
+}
+
+/*
+ * siw_proc_send:
+ *
+ * Process one incoming SEND and place data into memory referenced by
+ * receive wqe.
+ *
+ * Function supports partially received sends (suspending/resuming
+ * current receive wqe processing)
+ *
+ * return value:
+ *	0:       reached the end of a DDP segment
+ *	-EAGAIN: to be called again to finish the DDP segment
+ */
+int siw_proc_send(struct siw_qp *qp, struct siw_iwarp_rx *rctx)
+{
+	struct siw_wqe		*wqe;
+	struct siw_sge		*sge;
+	u32			data_bytes,	/* all data bytes available */
+				rcvd_bytes;	/* sum of data bytes rcvd */
+	int rv = 0;
+
+	if (rctx->first_ddp_seg) {
+		wqe = siw_rqe_get(qp);
+		if (unlikely(!wqe))
+			return -ENOENT;
+	} else
+		wqe = rx_wqe(qp);
+
+	if (rctx->state == SIW_GET_DATA_START) {
+		rv = siw_send_check_ntoh(rctx);
+		if (unlikely(rv)) {
+			siw_qp_event(qp, IB_EVENT_QP_FATAL);
+			return rv;
+		}
+		if (!rctx->fpdu_part_rem) /* zero length SEND */
+			return 0;
+	}
+	data_bytes = min(rctx->fpdu_part_rem, rctx->skb_new);
+	rcvd_bytes = 0;
+
+	/* A zero length SEND will skip below loop */
+	while (data_bytes) {
+		struct siw_pd *pd;
+		struct siw_mr *mr;
+		union siw_mem_resolved *mem;
+		u32 sge_bytes;	/* data bytes avail for SGE */
+
+		sge = &wqe->rqe.sge[rctx->sge_idx];
+
+		if (!sge->length) {
+			/* just skip empty sge's */
+			rctx->sge_idx++;
+			rctx->sge_off = 0;
+			rctx->pbl_idx = 0;
+			continue;
+		}
+		sge_bytes = min(data_bytes, sge->length - rctx->sge_off);
+		mem = &wqe->mem[rctx->sge_idx];
+
+		/*
+		 * check with QP's PD if no SRQ present, SRQ's PD otherwise
+		 */
+		pd = qp->srq == NULL ? qp->pd : qp->srq->pd;
+
+		rv = siw_check_sge(pd, sge, mem, SIW_MEM_LWRITE, rctx->sge_off,
+				   sge_bytes);
+		if (unlikely(rv)) {
+			siw_qp_event(qp, IB_EVENT_QP_ACCESS_ERR);
+			break;
+		}
+		mr = siw_mem2mr(mem->obj);
+		if (mr->mem_obj == NULL)
+			rv = siw_rx_kva(rctx,
+					(void *)(sge->laddr + rctx->sge_off),
+					sge_bytes);
+		else if (!mr->mem.is_pbl)
+			rv = siw_rx_umem(rctx, mr->umem,
+					 sge->laddr + rctx->sge_off, sge_bytes);
+		else
+			rv = siw_rx_pbl(rctx, mr,
+					sge->laddr + rctx->sge_off, sge_bytes);
+
+		if (unlikely(rv != sge_bytes)) {
+			wqe->processed += rcvd_bytes;
+			return -EINVAL;
+		}
+		rctx->sge_off += rv;
+
+		if (rctx->sge_off == sge->length) {
+			rctx->sge_idx++;
+			rctx->sge_off = 0;
+			rctx->pbl_idx = 0;
+		}
+		data_bytes -= rv;
+		rcvd_bytes += rv;
+
+		rctx->fpdu_part_rem -= rv;
+		rctx->fpdu_part_rcvd += rv;
+	}
+	wqe->processed += rcvd_bytes;
+
+	if (!rctx->fpdu_part_rem)
+		return 0;
+
+	return (rv < 0) ? rv : -EAGAIN;
+}
+
+/*
+ * siw_proc_write:
+ *
+ * Place incoming WRITE after referencing and checking target buffer
+
+ * Function supports partially received WRITEs (suspending/resuming
+ * current receive processing)
+ *
+ * return value:
+ *	0:       reached the end of a DDP segment
+ *	-EAGAIN: to be called again to finish the DDP segment
+ */
+
+int siw_proc_write(struct siw_qp *qp, struct siw_iwarp_rx *rctx)
+{
+	struct siw_dev		*dev = qp->hdr.sdev;
+	struct siw_mem		*mem;
+	struct siw_mr		*mr;
+	int			bytes,
+				rv;
+
+	if (rctx->state == SIW_GET_DATA_START) {
+
+		if (!rctx->fpdu_part_rem) /* zero length WRITE */
+			return 0;
+
+		rv = siw_write_check_ntoh(rctx);
+		if (unlikely(rv)) {
+			siw_qp_event(qp, IB_EVENT_QP_FATAL);
+			return rv;
+		}
+	}
+	bytes = min(rctx->fpdu_part_rem, rctx->skb_new);
+
+	if (rctx->first_ddp_seg) {
+		rx_mem(qp) = siw_mem_id2obj(dev, rctx->ddp_stag >> 8);
+		rx_wqe(qp)->wr_status = SIW_WR_INPROGRESS;
+		rx_type(rx_wqe(qp)) = SIW_OP_WRITE;
+	}
+	if (unlikely(!rx_mem(qp))) {
+		dprint(DBG_RX|DBG_ON,
+			"(QP%d): Sink STag not found/invalid,  STag=0x%08x\n",
+			QP_ID(qp), rctx->ddp_stag);
+		return -EINVAL;
+	}
+	mem = rx_mem(qp);
+	/*
+	 * Rtag not checked against mem's tag again because
+	 * hdr check guarantees same tag as before if fragmented
+	 */
+	rv = siw_check_mem(qp->pd, mem, rctx->ddp_to + rctx->fpdu_part_rcvd,
+			   SIW_MEM_RWRITE, bytes);
+	if (unlikely(rv)) {
+		siw_qp_event(qp, IB_EVENT_QP_ACCESS_ERR);
+		return rv;
+	}
+
+	mr = siw_mem2mr(mem);
+	if (mr->mem_obj == NULL)
+		rv = siw_rx_kva(rctx,
+				(void *)(rctx->ddp_to + rctx->fpdu_part_rcvd),
+				bytes);
+	else if (!mr->mem.is_pbl)
+		rv = siw_rx_umem(rctx, mr->umem,
+				 rctx->ddp_to + rctx->fpdu_part_rcvd, bytes);
+	else
+		rv = siw_rx_pbl(rctx, mr,
+				rctx->ddp_to + rctx->fpdu_part_rcvd, bytes);
+
+	if (unlikely(rv != bytes))
+		return -EINVAL;
+
+	rctx->fpdu_part_rem -= rv;
+	rctx->fpdu_part_rcvd += rv;
+
+	if (!rctx->fpdu_part_rem) {
+		rctx->ddp_to += rctx->fpdu_part_rcvd;
+		return 0;
+	}
+
+	return (rv < 0) ? rv : -EAGAIN;
+}
+
+/*
+ * inbound RREQ's cannot carry user data.
+ */
+int siw_proc_rreq(struct siw_qp *qp, struct siw_iwarp_rx *rctx)
+{
+	if (!rctx->fpdu_part_rem)
+		return 0;
+
+	dprint(DBG_ON|DBG_RX, "(QP%d): RREQ with MPA len %d\n", QP_ID(qp),
+		be16_to_cpu(rctx->hdr.ctrl.mpa_len));
+
+	return -EPROTO;
+}
+
+/*
+ * siw_init_rresp:
+ *
+ * Process inbound RDMA READ REQ. Produce a pseudo READ RESPONSE WQE.
+ * Put it at the tail of the IRQ, if there is another WQE currently in
+ * transmit processing. If not, make it the current WQE to be processed
+ * and schedule transmit processing.
+ *
+ * Can be called from softirq context and from process
+ * context (RREAD socket loopback case!)
+ *
+ * return value:
+ *	0:      success,
+ *		failure code otherwise
+ */
+
+static int siw_init_rresp(struct siw_qp *qp, struct siw_iwarp_rx *rctx)
+{
+	struct siw_wqe *tx_work = tx_wqe(qp);
+	struct siw_sqe *resp;
+
+	uint64_t	raddr	= be64_to_cpu(rctx->hdr.rreq.sink_to),
+			laddr	= be64_to_cpu(rctx->hdr.rreq.source_to);
+	uint32_t	length	= be32_to_cpu(rctx->hdr.rreq.read_size),
+			lkey	= be32_to_cpu(rctx->hdr.rreq.source_stag),
+			rkey	= be32_to_cpu(rctx->hdr.rreq.sink_stag);
+	int run_sq = 1, rv = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qp->sq_lock, flags);
+
+	if (tx_work->wr_status == SIW_WR_IDLE) {
+		/*
+		 * immediately schedule READ response w/o
+		 * consuming IRQ entry: IRQ must be empty.
+		 */
+		tx_work->processed = 0;
+		tx_work->mem[0].obj = NULL;
+		tx_work->wr_status = SIW_WR_QUEUED;
+		resp = &tx_work->sqe;
+	} else {
+		resp = irq_alloc_free(qp);
+		run_sq = 0;
+	}
+	if (likely(resp)) {
+		resp->opcode = SIW_OP_READ_RESPONSE;
+
+		resp->sge[0].length = length;
+		resp->sge[0].laddr = laddr;
+		resp->sge[0].lkey = lkey;
+
+		resp->raddr = raddr;
+		resp->rkey = rkey;
+		resp->num_sge = length ? 1 : 0;
+
+		/* RRESP now valid as current TX wqe or placed into IRQ */
+		smp_store_mb(resp->flags, SIW_WQE_VALID);
+	} else {
+		dprint(DBG_RX|DBG_ON, ": QP[%d]: IRQ %d exceeded %d!\n",
+			QP_ID(qp), qp->irq_put % qp->attrs.irq_size,
+			qp->attrs.irq_size);
+		rv = -EPROTO;
+	}
+
+	spin_unlock_irqrestore(&qp->sq_lock, flags);
+
+	if (run_sq)
+		siw_sq_start(qp);
+
+	return rv;
+}
+
+/*
+ * Only called at start of Read.Resonse processing.
+ * Transfer pending Read from tip of ORQ into currrent rx wqe,
+ * but keep ORQ entry valid until Read.Response processing done.
+ * No Queue locking needed.
+ */
+static int siw_orqe_start_rx(struct siw_qp *qp)
+{
+	struct siw_sqe *orqe;
+	struct siw_wqe *wqe = NULL;
+
+	/* make sure ORQ indices are current */
+	smp_mb();
+
+	orqe = orq_get_current(qp);
+	if (_load_shared(orqe->flags) & SIW_WQE_VALID) {
+		wqe = rx_wqe(qp);
+		wqe->sqe.id = orqe->id;
+		wqe->sqe.opcode = orqe->opcode;
+		wqe->sqe.sge[0].laddr = orqe->sge[0].laddr;
+		wqe->sqe.sge[0].lkey = orqe->sge[0].lkey;
+		wqe->sqe.sge[0].length = orqe->sge[0].length;
+		wqe->sqe.flags = orqe->flags;
+		wqe->sqe.num_sge = 1;
+		wqe->bytes = orqe->sge[0].length;
+		wqe->processed = 0;
+		wqe->mem[0].obj = NULL;
+		/* make sure WQE is completely written before valid */
+		smp_wmb();
+		wqe->wr_status = SIW_WR_INPROGRESS;
+
+		return 0;
+	}
+	return -EPROTO;
+}
+
+
+/*
+ * siw_proc_rresp:
+ *
+ * Place incoming RRESP data into memory referenced by RREQ WQE
+ * which is at the tip of the ORQ
+ *
+ * Function supports partially received RRESP's (suspending/resuming
+ * current receive processing)
+ */
+int siw_proc_rresp(struct siw_qp *qp, struct siw_iwarp_rx *rctx)
+{
+	struct siw_wqe		*wqe = rx_wqe(qp);
+	union siw_mem_resolved	*mem;
+	struct siw_sge		*sge;
+	struct siw_mr		*mr;
+	int			bytes,
+				rv;
+
+	if (rctx->first_ddp_seg) {
+		if (unlikely(wqe->wr_status != SIW_WR_IDLE)) {
+			pr_warn("QP[%d]: Start RRESP: RX status %d, op %d\n",
+				QP_ID(qp), wqe->wr_status,
+				wqe->sqe.opcode);
+			rv = -EPROTO;
+			goto done;
+		}
+		/*
+		 * fetch pending RREQ from orq
+		 */
+		rv = siw_orqe_start_rx(qp);
+		if (rv) {
+			dprint(DBG_RX|DBG_ON, "(QP%d): ORQ empty at idx %d\n",
+				QP_ID(qp),
+				qp->orq_get % qp->attrs.orq_size);
+			goto done;
+		}
+		rv = siw_rresp_check_ntoh(rctx);
+		if (unlikely(rv)) {
+			siw_qp_event(qp, IB_EVENT_QP_FATAL);
+			goto done;
+		}
+	} else {
+		if (unlikely(wqe->wr_status != SIW_WR_INPROGRESS)) {
+			pr_warn("QP[%d]: Resume RRESP: status %d\n",
+				QP_ID(qp), wqe->wr_status);
+			rv = -EPROTO;
+			goto done;
+		}
+	}
+	if (!rctx->fpdu_part_rem) /* zero length RRESPONSE */
+		return 0;
+
+	sge = wqe->sqe.sge; /* there is only one */
+	mem = &wqe->mem[0];
+
+	if (mem->obj == NULL) {
+		/*
+		 * check target memory which resolves memory on first fragment
+		 */
+		rv = siw_check_sge(qp->pd, sge, mem, SIW_MEM_LWRITE, 0,
+				   wqe->bytes);
+		if (rv) {
+			dprint(DBG_RX|DBG_ON, "(QP%d): siw_check_sge: %d\n",
+				QP_ID(qp), rv);
+			wqe->wc_status = SIW_WC_LOC_PROT_ERR;
+			siw_qp_event(qp, IB_EVENT_QP_ACCESS_ERR);
+			goto done;
+		}
+	}
+	bytes = min(rctx->fpdu_part_rem, rctx->skb_new);
+
+	mr = siw_mem2mr(mem->obj);
+	if (mr->mem_obj == NULL)
+		rv = siw_rx_kva(rctx, (void *)(sge->laddr + wqe->processed),
+				bytes);
+	else if (!mr->mem.is_pbl)
+		rv = siw_rx_umem(rctx, mr->umem, sge->laddr + wqe->processed,
+				 bytes);
+	else
+		rv = siw_rx_pbl(rctx, mr, sge->laddr + wqe->processed,
+				 bytes);
+	if (rv != bytes) {
+		wqe->wc_status = SIW_WC_GENERAL_ERR;
+		rv = -EINVAL;
+		goto done;
+	}
+	rctx->fpdu_part_rem -= rv;
+	rctx->fpdu_part_rcvd += rv;
+
+	wqe->processed += rv;
+	if (!rctx->fpdu_part_rem) {
+		rctx->ddp_to += rctx->fpdu_part_rcvd;
+		return 0;
+	}
+done:
+	return (rv < 0) ? rv : -EAGAIN;
+}
+
+
+int siw_proc_unsupp(struct siw_qp *qp, struct siw_iwarp_rx *rctx)
+{
+	return -ECONNRESET;
+}
+
+
+int siw_proc_terminate(struct siw_qp *qp, struct siw_iwarp_rx *rctx)
+{
+	dprint(DBG_ON, " (QP%d): RX Terminate: type=%d, layer=%d, code=%d\n",
+		QP_ID(qp),
+		__rdmap_term_etype(&rctx->hdr.terminate),
+		__rdmap_term_layer(&rctx->hdr.terminate),
+		__rdmap_term_ecode(&rctx->hdr.terminate));
+
+	return -ECONNRESET;
+}
+
+
+static int siw_get_trailer(struct siw_qp *qp, struct siw_iwarp_rx *rctx)
+{
+	struct sk_buff	*skb = rctx->skb;
+	u8		*tbuf = (u8 *)&rctx->trailer.crc - rctx->pad;
+	int		avail;
+
+	avail = min(rctx->skb_new, rctx->fpdu_part_rem);
+
+	dprint(DBG_RX, " (QP%d): to recv %d, avail %d, pad %d, skb_new %d\n",
+		QP_ID(qp), rctx->fpdu_part_rem, avail, rctx->pad,
+		rctx->skb_new);
+
+	skb_copy_bits(skb, rctx->skb_offset,
+		      tbuf + rctx->fpdu_part_rcvd, avail);
+
+	rctx->fpdu_part_rcvd += avail;
+	rctx->fpdu_part_rem -= avail;
+
+	rctx->skb_new -= avail;
+	rctx->skb_offset += avail;
+	rctx->skb_copied += avail;
+
+	if (!rctx->fpdu_part_rem) {
+		__be32	crc_in, crc_own = 0;
+		/*
+		 * check crc if required
+		 */
+		if (!rctx->mpa_crc_hd)
+			return 0;
+
+		if (rctx->pad && siw_crc_array(rctx->mpa_crc_hd,
+					       tbuf, rctx->pad) != 0)
+			return -EINVAL;
+
+		crypto_shash_final(rctx->mpa_crc_hd, (u8 *)&crc_own);
+
+		/*
+		 * CRC32 is computed, transmitted and received directly in NBO,
+		 * so there's never a reason to convert byte order.
+		 */
+		crc_in = rctx->trailer.crc;
+
+		if (crc_in != crc_own) {
+			dprint(DBG_RX|DBG_ON,
+				" (QP%d): CRC ERROR in:=%08x, own=%08x\n",
+				QP_ID(qp), crc_in, crc_own);
+			return -EINVAL;
+		}
+		return 0;
+	}
+	return -EAGAIN;
+}
+
+
+static int siw_get_hdr(struct siw_iwarp_rx *rctx)
+{
+	struct sk_buff		*skb = rctx->skb;
+	struct iwarp_ctrl	*c_hdr = &rctx->hdr.ctrl;
+	u8			opcode;
+
+	int bytes;
+
+	if (rctx->fpdu_part_rcvd < sizeof(struct iwarp_ctrl)) {
+		/*
+		 * copy first fix part of iwarp hdr
+		 */
+		bytes = min_t(int, rctx->skb_new, sizeof(struct iwarp_ctrl)
+				- rctx->fpdu_part_rcvd);
+
+		skb_copy_bits(skb, rctx->skb_offset,
+			      (char *)c_hdr + rctx->fpdu_part_rcvd, bytes);
+
+		rctx->fpdu_part_rcvd += bytes;
+
+		rctx->skb_new -= bytes;
+		rctx->skb_offset += bytes;
+		rctx->skb_copied += bytes;
+
+		if (!rctx->skb_new ||
+			rctx->fpdu_part_rcvd < sizeof(struct iwarp_ctrl))
+			return -EAGAIN;
+
+		if (__ddp_version(c_hdr) != DDP_VERSION) {
+			dprint(DBG_RX|DBG_ON, " dversion %d\n",
+				__ddp_version(c_hdr));
+			return -EINVAL;
+		}
+		if (__rdmap_version(c_hdr) != RDMAP_VERSION) {
+			dprint(DBG_RX|DBG_ON, " rversion %d\n",
+				__rdmap_version(c_hdr));
+			return -EINVAL;
+		}
+		opcode = __rdmap_opcode(c_hdr);
+
+		if (opcode > RDMAP_TERMINATE) {
+			dprint(DBG_RX|DBG_ON, " opcode %d\n", opcode);
+			return -EINVAL;
+		}
+		dprint(DBG_RX, "(QP%d): New Header, opcode:%d\n",
+			RX_QPID(rctx), opcode);
+	} else
+		opcode = __rdmap_opcode(c_hdr);
+	/*
+	 * figure out len of current hdr: variable length of
+	 * iwarp hdr forces us to copy hdr information
+	 */
+	bytes = min(rctx->skb_new,
+		  iwarp_pktinfo[opcode].hdr_len - rctx->fpdu_part_rcvd);
+
+	skb_copy_bits(skb, rctx->skb_offset,
+		      (char *)c_hdr + rctx->fpdu_part_rcvd, bytes);
+
+	rctx->fpdu_part_rcvd += bytes;
+
+	rctx->skb_new -= bytes;
+	rctx->skb_offset += bytes;
+	rctx->skb_copied += bytes;
+
+	if (rctx->fpdu_part_rcvd == iwarp_pktinfo[opcode].hdr_len) {
+		/*
+		 * HDR receive completed. Check if the current DDP segment
+		 * starts a new RDMAP message or continues a previously
+		 * started RDMAP message.
+		 *
+		 * Note well from the comments on DDP reassembly:
+		 * - Support for unordered reception of DDP segments
+		 *   (or FPDUs) from different RDMAP messages is not needed.
+		 * - Unordered reception of DDP segments of the same
+		 *   RDMAP message is not supported. It is probably not
+		 *   needed with most peers.
+		 */
+		siw_dprint_hdr(&rctx->hdr, RX_QPID(rctx), "HDR received");
+
+		if (rctx->more_ddp_segs != 0) {
+			rctx->first_ddp_seg = 0;
+			if (rctx->prev_rdmap_opcode != opcode) {
+				dprint(DBG_ON,
+					"packet intersection: %d <> %d\n",
+					rctx->prev_rdmap_opcode, opcode);
+				return -EPROTO;
+			}
+		} else {
+			rctx->prev_rdmap_opcode = opcode;
+			rctx->first_ddp_seg = 1;
+		}
+		rctx->more_ddp_segs =
+			c_hdr->ddp_rdmap_ctrl & DDP_FLAG_LAST ? 0 : 1;
+
+		return 0;
+	}
+	return -EAGAIN;
+}
+
+static inline int siw_fpdu_payload_len(struct siw_iwarp_rx *rctx)
+{
+	return be16_to_cpu(rctx->hdr.ctrl.mpa_len) - rctx->fpdu_part_rcvd
+		+ MPA_HDR_SIZE;
+}
+
+static inline int siw_fpdu_trailer_len(struct siw_iwarp_rx *rctx)
+{
+	int mpa_len = be16_to_cpu(rctx->hdr.ctrl.mpa_len) + MPA_HDR_SIZE;
+
+	return MPA_CRC_SIZE + (-mpa_len & 0x3);
+}
+
+
+
+static void siw_check_tx_fence(struct siw_qp *qp)
+{
+	struct siw_wqe *tx_waiting = tx_wqe(qp);
+	struct siw_sqe *rreq;
+	int resume_tx = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qp->orq_lock, flags);
+
+	rreq = orq_get_current(qp);
+
+	/* free current orq entry */
+	smp_store_mb(rreq->flags, 0);
+
+	if (qp->tx_ctx.orq_fence) {
+		if (unlikely(tx_waiting->wr_status != SIW_WR_QUEUED)) {
+			pr_warn("QP[%d]: Resume from fence: status %d wrong\n",
+				QP_ID(qp), tx_waiting->wr_status);
+			goto out;
+		}
+		/* resume SQ processing */
+		if (tx_waiting->sqe.opcode == SIW_OP_READ ||
+		    tx_waiting->sqe.opcode == SIW_OP_READ_LOCAL_INV) {
+
+			rreq = orq_get_tail(qp);
+			if (unlikely(!rreq)) {
+				pr_warn("QP[%d]: no ORQ\n", QP_ID(qp));
+				goto out;
+			}
+			siw_read_to_orq(rreq, &tx_waiting->sqe);
+
+			qp->orq_put++;
+			qp->tx_ctx.orq_fence = 0;
+			resume_tx = 1;
+
+		} else if (siw_orq_empty(qp)) {
+
+			qp->tx_ctx.orq_fence = 0;
+			resume_tx = 1;
+		} else
+			pr_warn("QP[%d]:  Resume from fence: error: %d:%d\n",
+				QP_ID(qp), qp->orq_get, qp->orq_put);
+	}
+	qp->orq_get++;
+out:
+	spin_unlock_irqrestore(&qp->orq_lock, flags);
+
+	if (resume_tx)
+		siw_sq_start(qp);
+}
+
+/*
+ * siw_rdmap_complete()
+ *
+ * Complete processing of an RDMA message after receiving all
+ * DDP segmens or ABort processing after encountering error case.
+ *
+ *   o SENDs + RRESPs will need for completion,
+ *   o RREQs need for  READ RESPONSE initialization
+ *   o WRITEs need memory dereferencing
+ *
+ * TODO: Failed WRITEs need local error to be surfaced.
+ */
+
+static inline int
+siw_rdmap_complete(struct siw_qp *qp, int error)
+{
+	struct siw_iwarp_rx	*rctx = &qp->rx_ctx;
+	struct siw_wqe		*wqe = rx_wqe(qp);
+	enum siw_wc_status	wc_status = wqe->wc_status;
+
+	u8 opcode = __rdmap_opcode(&rctx->hdr.ctrl);
+	int rv = 0;
+
+	switch (opcode) {
+
+	case RDMAP_SEND_SE:
+	case RDMAP_SEND_SE_INVAL:
+		wqe->rqe.flags |= SIW_WQE_SOLICITED;
+	case RDMAP_SEND:
+	case RDMAP_SEND_INVAL:
+		if (wqe->wr_status == SIW_WR_IDLE)
+			break;
+
+		rctx->ddp_msn[RDMAP_UNTAGGED_QN_SEND]++;
+
+		if (error != 0 && wc_status == SIW_WC_SUCCESS)
+			wc_status = SIW_WC_GENERAL_ERR;
+
+		/*
+		 * Handle STag invalidation request
+		 */
+		if (wc_status == SIW_WC_SUCCESS &&
+		    (opcode == RDMAP_SEND_INVAL ||
+		     opcode == RDMAP_SEND_SE_INVAL)) {
+			rv = siw_invalidate_stag(qp->pd, rctx->inval_stag);
+			if (rv)
+				wc_status = SIW_WC_REM_INV_REQ_ERR;
+		}
+		rv = siw_rqe_complete(qp, &wqe->rqe, wqe->processed,
+				      wc_status);
+		siw_wqe_put_mem(wqe, SIW_OP_RECEIVE);
+
+		break;
+
+	case RDMAP_RDMA_READ_RESP:
+		if (wqe->wr_status == SIW_WR_IDLE)
+			break;
+
+		rctx->ddp_msn[RDMAP_UNTAGGED_QN_RDMA_READ]++;
+		if (error != 0) {
+			if  (rctx->state == SIW_GET_HDR || error == -ENODATA)
+				/*  eventual RREQ in ORQ left untouched */
+				break;
+
+			if (wc_status == SIW_WC_SUCCESS)
+				wc_status = SIW_WC_GENERAL_ERR;
+		} else if (qp->kernel_verbs &&
+			   rx_type(wqe) == SIW_OP_READ_LOCAL_INV) {
+			/*
+			 * Handle any STag invalidation request
+			 */
+			rv = siw_invalidate_stag(qp->pd, wqe->sqe.sge[0].lkey);
+			if (rv && wc_status == SIW_WC_SUCCESS) {
+				wc_status = SIW_WC_GENERAL_ERR;
+				error = rv;
+			}
+		}
+		/*
+		 * All errors turn the wqe into signalled.
+		 */
+		if ((wqe->sqe.flags & SIW_WQE_SIGNALLED) || error != 0)
+			rv = siw_sqe_complete(qp, &wqe->sqe, wqe->processed,
+					      wc_status);
+		siw_wqe_put_mem(wqe, SIW_OP_READ);
+
+		if (error == 0)
+			siw_check_tx_fence(qp);
+		break;
+
+	case RDMAP_RDMA_READ_REQ:
+		if (error == 0)
+			rv = siw_init_rresp(qp, rctx);
+
+		break;
+
+	case RDMAP_RDMA_WRITE:
+		if (wqe->wr_status == SIW_WR_IDLE)
+			break;
+
+		/*
+		 * Free References from memory object if
+		 * attached to receive context (inbound WRITE).
+		 * While a zero-length WRITE is allowed,
+		 * no memory reference got created.
+		 */
+		if (rx_mem(qp)) {
+			siw_mem_put(rx_mem(qp));
+			rx_mem(qp) = NULL;
+		}
+		break;
+
+	default:
+		break;
+	}
+	wqe->wr_status = SIW_WR_IDLE;
+
+	return rv;
+}
+
+/*
+ * siw_tcp_rx_data()
+ *
+ * Main routine to consume inbound TCP payload
+ *
+ * @rd_desc:	read descriptor
+ * @skb:	socket buffer
+ * @off:	offset in skb
+ * @len:	skb->len - offset : payload in skb
+ */
+int siw_tcp_rx_data(read_descriptor_t *rd_desc, struct sk_buff *skb,
+		    unsigned int off, size_t len)
+{
+	struct siw_qp		*qp = rd_desc->arg.data;
+	struct siw_iwarp_rx	*rctx = &qp->rx_ctx;
+	int			rv;
+
+	rctx->skb = skb;
+	rctx->skb_new = skb->len - off;
+	rctx->skb_offset = off;
+	rctx->skb_copied = 0;
+
+	dprint(DBG_RX, "(QP%d): new data %d\n",
+		QP_ID(qp), rctx->skb_new);
+
+	while (rctx->skb_new) {
+		int run_completion = 1;
+
+		if (unlikely(rctx->rx_suspend)) {
+			/* Do not process any more data */
+			rctx->skb_copied += rctx->skb_new;
+			break;
+		}
+		switch (rctx->state) {
+
+		case SIW_GET_HDR:
+			rv = siw_get_hdr(rctx);
+			if (!rv) {
+				if (rctx->mpa_crc_hd &&
+				    siw_crc_rxhdr(rctx) != 0) {
+					rv = -EINVAL;
+					break;
+				}
+				rctx->fpdu_part_rem =
+					siw_fpdu_payload_len(rctx);
+
+				if (rctx->fpdu_part_rem)
+					rctx->pad = -rctx->fpdu_part_rem & 0x3;
+				else
+					rctx->pad = 0;
+
+				rctx->state = SIW_GET_DATA_START;
+				rctx->fpdu_part_rcvd = 0;
+			}
+			break;
+
+		case SIW_GET_DATA_MORE:
+			/*
+			 * Another data fragment of the same DDP segment.
+			 * Setting first_ddp_seg = 0 avoids repeating
+			 * initializations that shall occur only once per
+			 * DDP segment.
+			 */
+			rctx->first_ddp_seg = 0;
+
+		case SIW_GET_DATA_START:
+			/*
+			 * Headers will be checked by the opcode-specific
+			 * data receive function below.
+			 */
+			rv = siw_rx_data(qp, rctx);
+			if (!rv) {
+				rctx->fpdu_part_rem =
+					siw_fpdu_trailer_len(rctx);
+				rctx->fpdu_part_rcvd = 0;
+				rctx->state = SIW_GET_TRAILER;
+			} else {
+				if (unlikely(rv == -ECONNRESET))
+					run_completion = 0;
+				else
+					rctx->state = SIW_GET_DATA_MORE;
+			}
+			break;
+
+		case SIW_GET_TRAILER:
+			/*
+			 * read CRC + any padding
+			 */
+			rv = siw_get_trailer(qp, rctx);
+			if (!rv) {
+				/*
+				 * FPDU completed.
+				 * complete RDMAP message if last fragment
+				 */
+				rctx->state = SIW_GET_HDR;
+				rctx->fpdu_part_rcvd = 0;
+
+				if (!(rctx->hdr.ctrl.ddp_rdmap_ctrl
+					& DDP_FLAG_LAST))
+					/* more frags */
+					break;
+
+				rv = siw_rdmap_complete(qp, 0);
+				run_completion = 0;
+			}
+			break;
+
+		default:
+			pr_warn("QP[%d]: RX out of state\n", QP_ID(qp));
+			rv = -EPROTO;
+			run_completion = 0;
+		}
+
+		if (unlikely(rv != 0 && rv != -EAGAIN)) {
+			/*
+			 * TODO: implement graceful error handling including
+			 *       generation (and processing) of TERMINATE
+			 *       messages.
+			 *
+			 *	 for now we are left with a bogus rx status
+			 *	 unable to receive any further byte.
+			 *	 BUT: code must handle difference between
+			 *	 errors:
+			 *
+			 *	 o protocol syntax (FATAL, framing lost)
+			 *	 o crc	(FATAL, framing lost since we do not
+			 *	        trust packet header (??))
+			 *	 o local resource (maybe non fatal, framing
+			 *	   not lost)
+			 *
+			 */
+			if (rctx->state > SIW_GET_HDR && run_completion)
+				siw_rdmap_complete(qp, rv);
+
+			dprint(DBG_RX|DBG_ON,
+				"(QP%d): RX ERROR %d at RX state %d\n",
+				QP_ID(qp), rv, rctx->state);
+
+			siw_dprint_rctx(rctx);
+			/*
+			 * Calling siw_cm_queue_work() is safe without
+			 * releasing qp->state_lock because the QP state
+			 * will be transitioned to SIW_QP_STATE_ERROR
+			 * by the siw_work_handler() workqueue handler
+			 * after we return from siw_qp_llp_data_ready().
+			 */
+			siw_qp_cm_drop(qp, 1);
+
+			break;
+		}
+		if (rv) {
+			dprint(DBG_RX,
+				"(QP%d): FPDU frag. state %d, missing %d\n",
+				QP_ID(qp), rctx->state, rctx->fpdu_part_rem);
+			break;
+		}
+	}
+	return rctx->skb_copied;
+}
diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
new file mode 100644
index 000000000000..076047df1846
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -0,0 +1,1342 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/net.h>
+#include <linux/scatterlist.h>
+#include <linux/highmem.h>
+#include <linux/llist.h>
+#include <net/sock.h>
+#include <net/tcp_states.h>
+#include <net/tcp.h>
+#include <linux/cpu.h>
+
+#include <rdma/iw_cm.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+
+#include "siw.h"
+#include "siw_obj.h"
+#include "siw_cm.h"
+
+#include <linux/kthread.h>
+
+static bool zcopy_tx = false;
+module_param(zcopy_tx, bool, 0644);
+MODULE_PARM_DESC(zcopy_tx, "Zero copy user data transmit if possible");
+
+static int gso_seg_limit;
+module_param(gso_seg_limit, int, 0644);
+MODULE_PARM_DESC(gso_seg_limit, "Limit TCP GSO to value if set\n");
+
+static inline int siw_crc_txhdr(struct siw_iwarp_tx *ctx)
+{
+	crypto_shash_init(ctx->mpa_crc_hd);
+	return siw_crc_array(ctx->mpa_crc_hd, (u8 *)&ctx->pkt,
+			     ctx->ctrl_len);
+}
+
+#define MAX_HDR_INLINE					\
+	(((uint32_t)(sizeof(struct siw_rreq_pkt) -	\
+	sizeof(struct iwarp_send))) & 0xF8)
+
+static inline struct page *siw_get_pblpage(struct siw_mr *mr,
+					   u64 addr, int *idx)
+{
+	struct siw_pbl *pbl = mr->pbl;
+	u64 offset = addr - mr->mem.va;
+	u64 paddr = siw_pbl_get_buffer(pbl, offset, NULL, idx);
+
+	if (paddr)
+		return virt_to_page(paddr);
+	return NULL;
+}
+
+/*
+ * Copy short payload at provided destination address and
+ * update address pointer to the address behind data
+ * including potential padding
+ */
+static int siw_try_1seg(struct siw_iwarp_tx *c_tx, char *payload)
+{
+	struct siw_wqe *wqe = &c_tx->wqe_active;
+	struct siw_sge *sge = &wqe->sqe.sge[0];
+	u32 bytes = sge->length;
+
+	if (bytes > MAX_HDR_INLINE || wqe->sqe.num_sge != 1)
+		return -1;
+
+	if (bytes == 0)
+		return 0;
+
+	if (tx_flags(wqe) & SIW_WQE_INLINE)
+		memcpy(payload, &wqe->sqe.sge[1], bytes);
+	else {
+		struct siw_mr *mr = siw_mem2mr(wqe->mem[0].obj);
+
+		if (!mr->mem_obj) /* Kernel client using kva */
+			memcpy(payload, (void *)sge->laddr, bytes);
+		else if (c_tx->in_syscall) {
+			if (copy_from_user(payload,
+					   (void *)sge->laddr,
+					   bytes)) {
+				WARN_ON(1);
+				return -1;
+			}
+		} else {
+			unsigned int off = sge->laddr & ~PAGE_MASK;
+			struct page *p;
+			char *buffer;
+			int pbl_idx = 0;
+
+			if (!mr->mem.is_pbl)
+				p = siw_get_upage(mr->umem, sge->laddr);
+			else
+				p = siw_get_pblpage(mr, sge->laddr, &pbl_idx);
+
+			BUG_ON(!p);
+
+			buffer = kmap_atomic(p);
+
+			if (likely(PAGE_SIZE - off >= bytes)) {
+				memcpy(payload, buffer + off, bytes);
+				kunmap_atomic(buffer);
+			} else {
+				unsigned long part = bytes - (PAGE_SIZE - off);
+
+				memcpy(payload, buffer + off, part);
+				kunmap_atomic(buffer);
+				payload += part;
+
+				if (!mr->mem.is_pbl)
+					p = siw_get_upage(mr->umem,
+							  sge->laddr + part);
+				else
+					p = siw_get_pblpage(mr,
+							    sge->laddr + part,
+							    &pbl_idx);
+				BUG_ON(!p);
+
+				buffer = kmap_atomic(p);
+				memcpy(payload, buffer, bytes - part);
+				kunmap_atomic(buffer);
+			}
+		}
+	}
+	return (int)bytes;
+}
+
+#define PKT_FRAGMENTED 1
+#define PKT_COMPLETE 0
+
+/*
+ * siw_qp_prepare_tx()
+ *
+ * Prepare tx state for sending out one fpdu. Builds complete pkt
+ * if no user data or only immediate data are present.
+ *
+ * returns PKT_COMPLETE if complete pkt built, PKT_FRAGMENTED otherwise.
+ */
+static int siw_qp_prepare_tx(struct siw_iwarp_tx *c_tx)
+{
+	struct siw_wqe		*wqe = &c_tx->wqe_active;
+	char			*crc = NULL;
+	int			data = 0;
+
+	switch (tx_type(wqe)) {
+
+	case SIW_OP_READ:
+	case SIW_OP_READ_LOCAL_INV:
+		memcpy(&c_tx->pkt.ctrl,
+		       &iwarp_pktinfo[RDMAP_RDMA_READ_REQ].ctrl,
+		       sizeof(struct iwarp_ctrl));
+
+		c_tx->pkt.rreq.rsvd = 0;
+		c_tx->pkt.rreq.ddp_qn = htonl(RDMAP_UNTAGGED_QN_RDMA_READ);
+		c_tx->pkt.rreq.ddp_msn =
+			htonl(++c_tx->ddp_msn[RDMAP_UNTAGGED_QN_RDMA_READ]);
+		c_tx->pkt.rreq.ddp_mo = 0;
+		c_tx->pkt.rreq.sink_stag = htonl(wqe->sqe.sge[0].lkey);
+		c_tx->pkt.rreq.sink_to =
+			cpu_to_be64(wqe->sqe.sge[0].laddr); /* abs addr! */
+		c_tx->pkt.rreq.source_stag = htonl(wqe->sqe.rkey);
+		c_tx->pkt.rreq.source_to = cpu_to_be64(wqe->sqe.raddr);
+		c_tx->pkt.rreq.read_size = htonl(wqe->sqe.sge[0].length);
+
+		c_tx->ctrl_len = sizeof(struct iwarp_rdma_rreq);
+		crc = (char *)&c_tx->pkt.rreq_pkt.crc;
+		break;
+
+	case SIW_OP_SEND:
+		if (tx_flags(wqe) & SIW_WQE_SOLICITED)
+			memcpy(&c_tx->pkt.ctrl,
+			       &iwarp_pktinfo[RDMAP_SEND_SE].ctrl,
+			       sizeof(struct iwarp_ctrl));
+		else
+			memcpy(&c_tx->pkt.ctrl,
+			       &iwarp_pktinfo[RDMAP_SEND].ctrl,
+			       sizeof(struct iwarp_ctrl));
+
+		c_tx->pkt.send.ddp_qn = RDMAP_UNTAGGED_QN_SEND;
+		c_tx->pkt.send.ddp_msn =
+			htonl(++c_tx->ddp_msn[RDMAP_UNTAGGED_QN_SEND]);
+		c_tx->pkt.send.ddp_mo = 0;
+
+		c_tx->pkt.send_inv.inval_stag = 0;
+
+		c_tx->ctrl_len = sizeof(struct iwarp_send);
+
+		crc = (char *)&c_tx->pkt.send_pkt.crc;
+		data = siw_try_1seg(c_tx, crc);
+		break;
+
+	case SIW_OP_SEND_REMOTE_INV:
+		if (tx_flags(wqe) & SIW_WQE_SOLICITED)
+			memcpy(&c_tx->pkt.ctrl,
+			       &iwarp_pktinfo[RDMAP_SEND_SE_INVAL].ctrl,
+			       sizeof(struct iwarp_ctrl));
+		else
+			memcpy(&c_tx->pkt.ctrl,
+			       &iwarp_pktinfo[RDMAP_SEND_INVAL].ctrl,
+			       sizeof(struct iwarp_ctrl));
+
+		c_tx->pkt.send.ddp_qn = RDMAP_UNTAGGED_QN_SEND;
+		c_tx->pkt.send.ddp_msn =
+			htonl(++c_tx->ddp_msn[RDMAP_UNTAGGED_QN_SEND]);
+		c_tx->pkt.send.ddp_mo = 0;
+
+		c_tx->pkt.send_inv.inval_stag = cpu_to_be32(wqe->sqe.rkey);
+
+		c_tx->ctrl_len = sizeof(struct iwarp_send_inv);
+
+		crc = (char *)&c_tx->pkt.send_pkt.crc;
+		data = siw_try_1seg(c_tx, crc);
+		break;
+
+	case SIW_OP_WRITE:
+		memcpy(&c_tx->pkt.ctrl, &iwarp_pktinfo[RDMAP_RDMA_WRITE].ctrl,
+		       sizeof(struct iwarp_ctrl));
+
+		c_tx->pkt.rwrite.sink_stag = htonl(wqe->sqe.rkey);
+		c_tx->pkt.rwrite.sink_to = cpu_to_be64(wqe->sqe.raddr);
+		c_tx->ctrl_len = sizeof(struct iwarp_rdma_write);
+
+		crc = (char *)&c_tx->pkt.write_pkt.crc;
+		data = siw_try_1seg(c_tx, crc);
+		break;
+
+	case SIW_OP_READ_RESPONSE:
+		memcpy(&c_tx->pkt.ctrl,
+		       &iwarp_pktinfo[RDMAP_RDMA_READ_RESP].ctrl,
+		       sizeof(struct iwarp_ctrl));
+
+		/* NBO */
+		c_tx->pkt.rresp.sink_stag = cpu_to_be32(wqe->sqe.rkey);
+		c_tx->pkt.rresp.sink_to = cpu_to_be64(wqe->sqe.raddr);
+
+		c_tx->ctrl_len = sizeof(struct iwarp_rdma_rresp);
+
+		crc = (char *)&c_tx->pkt.write_pkt.crc;
+		data = siw_try_1seg(c_tx, crc);
+		break;
+
+	default:
+		dprint(DBG_ON, "Unsupported WQE type %d\n", tx_type(wqe));
+		BUG();
+		break;
+	}
+	c_tx->ctrl_sent = 0;
+
+	if (data >= 0) {
+		if (data > 0) {
+			wqe->processed = data;
+
+			c_tx->pkt.ctrl.mpa_len =
+				htons(c_tx->ctrl_len + data - MPA_HDR_SIZE);
+
+			/* compute eventual pad */
+			data += -(int)data & 0x3;
+			/* point CRC after data or pad */
+			crc += data;
+			c_tx->ctrl_len += data;
+
+			if (!(c_tx->pkt.ctrl.ddp_rdmap_ctrl & DDP_FLAG_TAGGED))
+				c_tx->pkt.c_untagged.ddp_mo = 0;
+			else
+				c_tx->pkt.c_tagged.ddp_to =
+				    cpu_to_be64(wqe->sqe.raddr);
+		}
+
+		*(u32 *)crc = 0;
+		/*
+		 * Do complete CRC if enabled and short packet
+		 */
+		if (c_tx->mpa_crc_hd) {
+			if (siw_crc_txhdr(c_tx) != 0)
+				return -EINVAL;
+			crypto_shash_final(c_tx->mpa_crc_hd, (u8 *)crc);
+		}
+		c_tx->ctrl_len += MPA_CRC_SIZE;
+
+		return PKT_COMPLETE;
+	}
+	c_tx->ctrl_len += MPA_CRC_SIZE;
+	c_tx->sge_idx = 0;
+	c_tx->sge_off = 0;
+	c_tx->pbl_idx = 0;
+
+	/*
+	 * Allow direct sending out of user buffer if WR is non signalled
+	 * and payload is over threshold and no CRC is enabled.
+	 * Per RDMA verbs, the application should not change the send buffer
+	 * until the work completed. In iWarp, work completion is only
+	 * local delivery to TCP. TCP may reuse the buffer for
+	 * retransmission. Changing unsent data also breaks the CRC,
+	 * if applied.
+	 */
+	if (zcopy_tx
+	    && wqe->bytes > SENDPAGE_THRESH
+	    && !(tx_flags(wqe) & SIW_WQE_SIGNALLED)
+	    && tx_type(wqe) != SIW_OP_READ
+	    && tx_type(wqe) != SIW_OP_READ_LOCAL_INV)
+		c_tx->use_sendpage = 1;
+	else
+		c_tx->use_sendpage = 0;
+
+	return PKT_FRAGMENTED;
+}
+
+/*
+ * Send out one complete control type FPDU, or header of FPDU carrying
+ * data. Used for fixed sized packets like Read.Requests or zero length
+ * SENDs, WRITEs, READ.Responses, or header only.
+ */
+static inline int siw_tx_ctrl(struct siw_iwarp_tx *c_tx, struct socket *s,
+			      int flags)
+{
+	struct msghdr msg = {.msg_flags = flags};
+	struct kvec iov = {
+		.iov_base = (char *)&c_tx->pkt.ctrl + c_tx->ctrl_sent,
+		.iov_len = c_tx->ctrl_len - c_tx->ctrl_sent};
+
+	int rv = kernel_sendmsg(s, &msg, &iov, 1,
+				c_tx->ctrl_len - c_tx->ctrl_sent);
+
+	dprint(DBG_TX, " (QP%d): op=%d, %d of %d sent (%d)\n",
+		TX_QPID(c_tx), __rdmap_opcode(&c_tx->pkt.ctrl),
+		c_tx->ctrl_sent + rv, c_tx->ctrl_len, rv);
+
+	if (rv >= 0) {
+		c_tx->ctrl_sent += rv;
+
+		if (c_tx->ctrl_sent == c_tx->ctrl_len) {
+			siw_dprint_hdr(&c_tx->pkt.hdr, TX_QPID(c_tx),
+					"HDR/CTRL sent");
+			rv = 0;
+		} else if (c_tx->ctrl_sent < c_tx->ctrl_len)
+			rv = -EAGAIN;
+		else
+			BUG();
+	}
+	return rv;
+}
+
+/*
+ * 0copy TCP transmit interface:  Push page array page by page,
+ * or use do_tcp_sendpages, if exported.
+ *
+ * Using sendpage to push page by page appears to be less efficient
+ * than using sendmsg, even if data are copied.
+ *
+ * A general performance limitation might be the extra four bytes
+ * trailer checksum segment to be pushed after user data.
+ */
+static int siw_tcp_sendpages(struct socket *s, struct page **page,
+			     int offset, size_t size)
+{
+	struct sock *sk = s->sk;
+	int i = 0, rv = 0, sent = 0,
+	    flags = MSG_MORE|MSG_DONTWAIT|MSG_SENDPAGE_NOTLAST;
+
+	while (size) {
+		size_t bytes = min_t(size_t, PAGE_SIZE - offset, size);
+
+		if (size + offset <= PAGE_SIZE)
+	       		flags = MSG_MORE|MSG_DONTWAIT;
+
+		tcp_rate_check_app_limited(sk);
+try_page_again:
+		lock_sock(sk);
+		rv = do_tcp_sendpages(sk, page[i], offset, bytes, flags);
+		release_sock(sk);
+
+		if (rv > 0) {
+			size -= rv;
+			sent += rv;
+			if (rv != bytes) {
+				offset += rv;
+				bytes -= rv;
+				goto try_page_again;
+			}
+			offset = 0;
+		} else {
+			if (rv  == -EAGAIN || rv == 0)
+				break;
+			return rv;
+		}
+		i++;
+	}
+	return sent;
+}
+
+/*
+ * siw_0copy_tx()
+ *
+ * Pushes list of pages to TCP socket. If pages from multiple
+ * SGE's, all referenced pages of each SGE are pushed in one
+ * shot.
+ */
+static int siw_0copy_tx(struct socket *s, struct page **page,
+			struct siw_sge *sge, unsigned int offset,
+			unsigned int size)
+{
+	int i = 0, sent = 0, rv;
+	int sge_bytes = min(sge->length - offset, size);
+
+	offset  = (sge->laddr + offset) & ~PAGE_MASK;
+
+	while (sent != size) {
+
+		rv = siw_tcp_sendpages(s, &page[i], offset, sge_bytes);
+		if (rv >= 0) {
+			sent += rv;
+			if (size == sent || sge_bytes > rv)
+				break;
+
+			i += PAGE_ALIGN(sge_bytes + offset) >> PAGE_SHIFT;
+			sge++;
+			sge_bytes = min(sge->length, size - sent);
+			offset = sge->laddr & ~PAGE_MASK;
+		} else {
+			sent = rv;
+			break;
+		}
+	}
+	return sent;
+}
+
+#define MAX_TRAILER (MPA_CRC_SIZE + 4)
+
+/*
+ * siw_tx_hdt() tries to push a complete packet to TCP where all
+ * packet fragments are referenced by the elements of one iovec.
+ * For the data portion, each involved page must be referenced by
+ * one extra element. All sge's data can be non-aligned to page
+ * boundaries. Two more elements are referencing iWARP header
+ * and trailer:
+ * MAX_ARRAY = 64KB/PAGE_SIZE + 1 + (2 * (SIW_MAX_SGE - 1) + HDR + TRL
+ */
+#define MAX_ARRAY ((0xffff / PAGE_SIZE) + 1 + (2 * (SIW_MAX_SGE - 1) + 2))
+
+/*
+ * Write out iov referencing hdr, data and trailer of current FPDU.
+ * Update transmit state dependent on write return status
+ */
+static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struct socket *s)
+{
+	struct siw_wqe		*wqe = &c_tx->wqe_active;
+	struct siw_sge		*sge = &wqe->sqe.sge[c_tx->sge_idx],
+				*first_sge = sge;
+	union siw_mem_resolved	*mem = &wqe->mem[c_tx->sge_idx];
+	struct siw_mr		*mr = NULL;
+
+	struct kvec		iov[MAX_ARRAY];
+	struct page		*page_array[MAX_ARRAY];
+	struct msghdr		msg = {.msg_flags = MSG_DONTWAIT|MSG_EOR};
+
+	int			seg = 0, do_crc = c_tx->do_crc, is_kva = 0, rv;
+	unsigned int		data_len = c_tx->bytes_unsent,
+				hdr_len = 0,
+				trl_len = 0,
+				sge_off = c_tx->sge_off,
+				sge_idx = c_tx->sge_idx,
+				pbl_idx = c_tx->pbl_idx;
+
+	if (c_tx->state == SIW_SEND_HDR) {
+		if (c_tx->use_sendpage) {
+			rv = siw_tx_ctrl(c_tx, s, MSG_DONTWAIT|MSG_MORE);
+			if (rv)
+				goto done;
+
+			c_tx->state = SIW_SEND_DATA;
+		} else {
+			iov[0].iov_base =
+				(char *)&c_tx->pkt.ctrl + c_tx->ctrl_sent;
+			iov[0].iov_len = hdr_len =
+				c_tx->ctrl_len - c_tx->ctrl_sent;
+			seg = 1;
+			siw_dprint_hdr(&c_tx->pkt.hdr, TX_QPID(c_tx),
+					"HDR to send");
+		}
+	}
+
+	wqe->processed += data_len;
+
+	while (data_len) { /* walk the list of SGE's */
+		unsigned int	sge_len = min(sge->length - sge_off, data_len);
+		unsigned int	fp_off = (sge->laddr + sge_off) & ~PAGE_MASK;
+
+		BUG_ON(!sge_len);
+
+		if (!(tx_flags(wqe) & SIW_WQE_INLINE)) {
+			mr = siw_mem2mr(mem->obj);
+			if (!mr->mem_obj)
+				is_kva = 1;
+		} else
+			is_kva = 1;
+
+		if (is_kva && !c_tx->use_sendpage) {
+			/*
+			 * tx from kernel virtual address: either inline data
+			 * or memory region with assigned kernel buffer
+			 */
+			iov[seg].iov_base = (void *)(sge->laddr + sge_off);
+			iov[seg].iov_len = sge_len;
+
+			if (do_crc)
+				siw_crc_array(c_tx->mpa_crc_hd,
+					      iov[seg].iov_base, sge_len);
+			sge_off += sge_len;
+			data_len -= sge_len;
+			seg++;
+			goto sge_done;
+		}
+
+		while (sge_len) {
+			size_t plen = min((int)PAGE_SIZE - fp_off, sge_len);
+
+			BUG_ON(plen <= 0);
+			if (!is_kva) {
+				struct page *p;
+
+				if (mr->mem.is_pbl)
+					p = siw_get_pblpage(mr,
+						sge->laddr + sge_off,
+						&pbl_idx);
+				else
+					p = siw_get_upage(mr->umem, sge->laddr
+							  + sge_off);
+				BUG_ON(!p);
+				page_array[seg] = p;
+
+				if (!c_tx->use_sendpage) {
+					iov[seg].iov_base = kmap(p) + fp_off;
+					iov[seg].iov_len = plen;
+				}
+				if (do_crc)
+					siw_crc_page(c_tx->mpa_crc_hd, p,
+						     fp_off, plen);
+			} else {
+				u64 pa = ((sge->laddr + sge_off) & PAGE_MASK);
+
+				page_array[seg] = virt_to_page(pa);
+				if (do_crc)
+					siw_crc_array(c_tx->mpa_crc_hd,
+						(void *)(sge->laddr + sge_off),
+						plen);
+			}
+
+			sge_len -= plen;
+			sge_off += plen;
+			data_len -= plen;
+			fp_off = 0;
+
+			if (++seg > (int)MAX_ARRAY) {
+				dprint(DBG_ON, "(QP%d): Too many fragments\n",
+				       TX_QPID(c_tx));
+				if (!is_kva && !c_tx->use_sendpage) {
+					int i = (hdr_len > 0) ? 1 : 0;
+
+					seg--;
+					while (i < seg)
+						kunmap(page_array[i++]);
+				}
+				wqe->processed -= c_tx->bytes_unsent;
+				rv = -EMSGSIZE;
+				goto done_crc;
+			}
+		}
+sge_done:
+		/* Update SGE variables at end of SGE */
+		if (sge_off == sge->length &&
+		    (data_len != 0 || wqe->processed < wqe->bytes)) {
+			sge_idx++;
+			sge++;
+			mem++;
+			sge_off = 0;
+		}
+	}
+	/* trailer */
+	if (likely(c_tx->state != SIW_SEND_TRAILER)) {
+		iov[seg].iov_base = &c_tx->trailer.pad[4 - c_tx->pad];
+		iov[seg].iov_len = trl_len = MAX_TRAILER - (4 - c_tx->pad);
+	} else {
+		iov[seg].iov_base = &c_tx->trailer.pad[c_tx->ctrl_sent];
+		iov[seg].iov_len = trl_len = MAX_TRAILER - c_tx->ctrl_sent;
+	}
+
+	if (c_tx->pad) {
+		*(u32 *)c_tx->trailer.pad = 0;
+		if (do_crc)
+			siw_crc_array(c_tx->mpa_crc_hd,
+				      (u8 *)&c_tx->trailer.crc - c_tx->pad,
+				      c_tx->pad);
+	}
+	if (!c_tx->mpa_crc_hd)
+		c_tx->trailer.crc = 0;
+	else if (do_crc)
+		crypto_shash_final(c_tx->mpa_crc_hd,
+				   (u8 *)&c_tx->trailer.crc);
+
+	data_len = c_tx->bytes_unsent;
+
+	if (c_tx->use_sendpage) {
+		rv = siw_0copy_tx(s, page_array, first_sge, c_tx->sge_off,
+				  data_len);
+		if (rv == data_len) {
+			rv = kernel_sendmsg(s, &msg, &iov[seg], 1, trl_len);
+			if (rv > 0)
+				rv += data_len;
+			else
+				rv = data_len;
+		}
+	} else {
+		rv = kernel_sendmsg(s, &msg, iov, seg + 1,
+				    hdr_len + data_len + trl_len);
+		if (!is_kva) {
+			int i = (hdr_len > 0) ? 1 : 0;
+
+			while (i < seg)
+				kunmap(page_array[i++]);
+		}
+		dprint(DBG_HDR, " QP[%d]: sendmsg rv = %d\n", TX_QPID(c_tx),
+			rv);
+	}
+	if (rv < (int)hdr_len) {
+		/* Not even complete hdr pushed or negative rv */
+		wqe->processed -= data_len;
+		if (rv >= 0) {
+			c_tx->ctrl_sent += rv;
+			rv = -EAGAIN;
+		}
+		goto done_crc;
+	}
+
+	rv -= hdr_len;
+
+	if (rv >= (int)data_len) {
+		/* all user data pushed to TCP or no data to push */
+		if (data_len > 0 && wqe->processed < wqe->bytes) {
+			/* Save the current state for next tx */
+			c_tx->sge_idx = sge_idx;
+			c_tx->sge_off = sge_off;
+			c_tx->pbl_idx = pbl_idx;
+		}
+		rv -= data_len;
+
+		if (rv == trl_len) /* all pushed */
+			rv = 0;
+		else {
+			c_tx->state = SIW_SEND_TRAILER;
+			c_tx->ctrl_len = MAX_TRAILER;
+			c_tx->ctrl_sent = rv + 4 - c_tx->pad;
+			c_tx->bytes_unsent = 0;
+			rv = -EAGAIN;
+		}
+
+	} else if (data_len > 0) {
+		/* Maybe some user data pushed to TCP */
+		c_tx->state = SIW_SEND_DATA;
+		wqe->processed -= data_len - rv;
+
+		if (rv) {
+			/*
+			 * Some bytes out. Recompute tx state based
+			 * on old state and bytes pushed
+			 */
+			unsigned int sge_unsent;
+
+			c_tx->bytes_unsent -= rv;
+			sge = &wqe->sqe.sge[c_tx->sge_idx];
+			sge_unsent = sge->length - c_tx->sge_off;
+
+			while (sge_unsent <= rv) {
+				rv -= sge_unsent;
+				c_tx->sge_idx++;
+				c_tx->sge_off = 0;
+				sge++;
+				sge_unsent = sge->length;
+			}
+			c_tx->sge_off += rv;
+			BUG_ON(c_tx->sge_off >= sge->length);
+		}
+		rv = -EAGAIN;
+	}
+done_crc:
+	c_tx->do_crc = 0;
+done:
+	return rv;
+}
+
+static void siw_update_tcpseg(struct siw_iwarp_tx *c_tx, struct socket *s)
+{
+	struct tcp_sock *tp = tcp_sk(s->sk);
+
+	if (tp->gso_segs) {
+		if (gso_seg_limit == 0)
+			c_tx->tcp_seglen =
+				tp->mss_cache * tp->gso_segs;
+		else
+			c_tx->tcp_seglen = tp->mss_cache *
+				min_t(unsigned int, gso_seg_limit,
+				      tp->gso_segs);
+	} else
+		c_tx->tcp_seglen = tp->mss_cache;
+}
+
+/*
+ * siw_unseg_txlen()
+ *
+ * Compute complete tcp payload len if packet would not
+ * get fragmented
+ */
+static inline int siw_unseg_txlen(struct siw_iwarp_tx *c_tx)
+{
+	int pad = c_tx->bytes_unsent ? -c_tx->bytes_unsent & 0x3 : 0;
+
+	return c_tx->bytes_unsent + c_tx->ctrl_len + pad + MPA_CRC_SIZE;
+}
+
+
+/*
+ * siw_prepare_fpdu()
+ *
+ * Prepares transmit context to send out one FPDU if FPDU will contain
+ * user data and user data are not immediate data.
+ * Computes maximum FPDU length to fill up TCP MSS if possible.
+ *
+ * @qp:		QP from which to transmit
+ * @wqe:	Current WQE causing transmission
+ *
+ * TODO: Take into account real available sendspace on socket
+ *       to avoid header misalignment due to send pausing within
+ *       fpdu transmission
+ */
+static void siw_prepare_fpdu(struct siw_qp *qp, struct siw_wqe *wqe)
+{
+	struct siw_iwarp_tx	*c_tx  = &qp->tx_ctx;
+	int data_len;
+
+	c_tx->ctrl_len = iwarp_pktinfo[__rdmap_opcode(&c_tx->pkt.ctrl)].hdr_len;
+	c_tx->ctrl_sent = 0;
+
+	/*
+	 * Update target buffer offset if any
+	 */
+	if (!(c_tx->pkt.ctrl.ddp_rdmap_ctrl & DDP_FLAG_TAGGED))
+		/* Untagged message */
+		c_tx->pkt.c_untagged.ddp_mo = cpu_to_be32(wqe->processed);
+	else	/* Tagged message */
+		c_tx->pkt.c_tagged.ddp_to =
+		    cpu_to_be64(wqe->sqe.raddr + wqe->processed);
+
+	data_len = wqe->bytes - wqe->processed;
+	if (data_len + c_tx->ctrl_len + MPA_CRC_SIZE > c_tx->tcp_seglen) {
+		/* Trim DDP payload to fit into current TCP segment */
+		data_len = c_tx->tcp_seglen - (c_tx->ctrl_len + MPA_CRC_SIZE);
+		c_tx->pkt.ctrl.ddp_rdmap_ctrl &= ~DDP_FLAG_LAST;
+		c_tx->pad = 0;
+	} else {
+		c_tx->pkt.ctrl.ddp_rdmap_ctrl |= DDP_FLAG_LAST;
+		c_tx->pad = -data_len & 0x3;
+	}
+	c_tx->bytes_unsent = data_len;
+
+	c_tx->pkt.ctrl.mpa_len =
+		htons(c_tx->ctrl_len + data_len - MPA_HDR_SIZE);
+
+	/*
+	 * Init MPA CRC computation
+	 */
+	if (c_tx->mpa_crc_hd) {
+		siw_crc_txhdr(c_tx);
+		c_tx->do_crc = 1;
+	}
+}
+
+/*
+ * siw_check_sgl_tx()
+ *
+ * Check permissions for a list of SGE's (SGL).
+ * A successful check will have all memory referenced
+ * for transmission resolved and assigned to the WQE.
+ *
+ * @pd:		Protection Domain SGL should belong to
+ * @wqe:	WQE to be checked
+ * @perms:	requested access permissions
+ *
+ */
+
+int siw_check_sgl_tx(struct siw_pd *pd, struct siw_wqe *wqe,
+		     enum siw_access_flags perms)
+{
+	struct siw_sge		*sge = &wqe->sqe.sge[0];
+	union siw_mem_resolved	*mem = &wqe->mem[0];
+	int	num_sge = wqe->sqe.num_sge,
+		len = 0;
+
+	dprint(DBG_WR, "(PD%d): Enter\n", OBJ_ID(pd));
+
+	if (unlikely(num_sge > SIW_MAX_SGE))
+		return -EINVAL;
+
+	while (num_sge-- > 0) {
+		dprint(DBG_WR, "(PD%d): perms=0x%x, len=%d, sge->len=%d\n",
+			OBJ_ID(pd), perms, len, sge->length);
+		/*
+		 * rdma verbs: do not check stag for a zero length sge
+		 */
+		if (sge->length &&
+		    siw_check_sge(pd, sge, mem, perms, 0, sge->length) != 0) {
+			len = -EINVAL;
+			break;
+		}
+		len += sge->length;
+		sge++;
+		mem++;
+	}
+	return len;
+}
+
+/*
+ * siw_qp_sq_proc_tx()
+ *
+ * Process one WQE which needs transmission on the wire.
+ */
+static int siw_qp_sq_proc_tx(struct siw_qp *qp, struct siw_wqe *wqe)
+{
+	struct siw_iwarp_tx	*c_tx = &qp->tx_ctx;
+	struct socket		*s = qp->attrs.llp_stream_handle;
+	int			rv = 0,
+				burst_len = qp->tx_ctx.burst;
+
+	if (unlikely(wqe->wr_status == SIW_WR_IDLE))
+		return 0;
+
+	if (!burst_len)
+		burst_len = SQ_USER_MAXBURST;
+
+	if (wqe->wr_status == SIW_WR_QUEUED) {
+		if (!(wqe->sqe.flags & SIW_WQE_INLINE)) {
+			if (tx_type(wqe) == SIW_OP_READ_RESPONSE)
+				wqe->sqe.num_sge = 1;
+
+			if (tx_type(wqe) != SIW_OP_READ &&
+			    tx_type(wqe) != SIW_OP_READ_LOCAL_INV) {
+				/*
+				 * Reference memory to be tx'd
+				 */
+				rv = siw_check_sgl_tx(qp->pd, wqe,
+						      SIW_MEM_LREAD);
+				if (rv < 0)
+					goto tx_done;
+
+				wqe->bytes = rv;
+			} else
+				wqe->bytes = 0;
+		} else {
+			wqe->bytes = wqe->sqe.sge[0].length;
+			if (!qp->kernel_verbs) {
+				if (wqe->bytes > SIW_MAX_INLINE)
+					return -EINVAL;
+				wqe->sqe.sge[0].laddr = (u64)&wqe->sqe.sge[1];
+			}
+		}
+		wqe->wr_status = SIW_WR_INPROGRESS;
+		wqe->processed = 0;
+
+		siw_update_tcpseg(c_tx, s);
+
+		rv = siw_qp_prepare_tx(c_tx);
+		if (rv == PKT_FRAGMENTED) {
+			c_tx->state = SIW_SEND_HDR;
+			siw_prepare_fpdu(qp, wqe);
+		} else if (rv == PKT_COMPLETE)
+			c_tx->state = SIW_SEND_SHORT_FPDU;
+		else
+			goto tx_done;
+	}
+
+next_segment:
+	dprint(DBG_WR|DBG_TX,
+		" QP(%d): WR type %d, state %d, data %u, sent %u, id %llx\n",
+		QP_ID(qp), tx_type(wqe), wqe->wr_status, wqe->bytes,
+		wqe->processed, wqe->sqe.id);
+
+	if (--burst_len == 0) {
+		rv = -EINPROGRESS;
+		goto tx_done;
+	}
+	if (c_tx->state == SIW_SEND_SHORT_FPDU) {
+		enum siw_opcode tx_type = tx_type(wqe);
+
+		/*
+		 * Always end current TCP segment (no MSG_MORE flag):
+		 * trying to fill segment would result in excessive delay.
+		 */
+		rv = siw_tx_ctrl(c_tx, s, MSG_DONTWAIT);
+
+		if (!rv && tx_type != SIW_OP_READ &&
+		    tx_type != SIW_OP_READ_LOCAL_INV)
+			wqe->processed = wqe->bytes;
+
+		goto tx_done;
+
+	} else
+		rv = siw_tx_hdt(c_tx, s);
+
+	if (!rv) {
+		/*
+		 * One segment sent. Processing completed if last
+		 * segment, Do next segment otherwise.
+		 */
+		if (unlikely(c_tx->tx_suspend)) {
+			/*
+			 * Verbs, 6.4.: Try stopping sending after a full
+			 * DDP segment if the connection goes down
+			 * (== peer halfclose)
+			 */
+			rv = -ECONNABORTED;
+			goto tx_done;
+		}
+		if (c_tx->pkt.ctrl.ddp_rdmap_ctrl & DDP_FLAG_LAST) {
+			dprint(DBG_TX, "(QP%d): WR completed\n", QP_ID(qp));
+			goto tx_done;
+		}
+		c_tx->state = SIW_SEND_HDR;
+
+		siw_update_tcpseg(c_tx, s);
+
+		siw_prepare_fpdu(qp, wqe);
+		goto next_segment;
+	}
+tx_done:
+	qp->tx_ctx.burst = burst_len;
+	return rv;
+}
+
+static int siw_fastreg_mr(struct siw_pd *pd, struct siw_sqe *sqe)
+{
+	struct siw_mem *mem = siw_mem_id2obj(pd->hdr.sdev, sqe->rkey >> 8);
+	struct siw_mr *mr;
+	int rv = 0;
+
+	dprint(DBG_MM, ": STag %u (%x) Enter\n", sqe->rkey >> 8, sqe->rkey);
+
+	if (!mem) {
+		dprint(DBG_ON, ": STag %u unknown\n", sqe->rkey >> 8);
+		return -EINVAL;
+	}
+	mr = siw_mem2mr(mem);
+	if (&mr->ofa_mr != (void *)sqe->ofa_mr) {
+		dprint(DBG_ON, ": STag %u: unexpected MR\n", sqe->rkey >> 8);
+		rv = -EINVAL;
+		goto out;
+	}
+	if (mr->pd != pd) {
+		dprint(DBG_ON, ": PD mismatch: %p != %p\n", mr->pd, pd);
+		rv = -EINVAL;
+		goto out;
+	}
+	if (mem->stag_valid) {
+		dprint(DBG_ON, ": STag already valid: %u\n",
+			sqe->rkey >> 8);
+		rv = -EINVAL;
+		goto out;
+	}
+	mem->perms = sqe->access;
+	mem->stag_valid = 1;
+	dprint(DBG_MM, ": STag now valid: %u\n", sqe->rkey >> 8);
+out:
+	siw_mem_put(mem);
+	return rv;
+}
+
+static int siw_qp_sq_proc_local(struct siw_qp *qp, struct siw_wqe *wqe)
+{
+	int rv;
+
+	switch (tx_type(wqe)) {
+
+	case SIW_OP_REG_MR:
+		rv = siw_fastreg_mr(qp->pd, &wqe->sqe);
+		break;
+
+	case SIW_OP_INVAL_STAG:
+		rv = siw_invalidate_stag(qp->pd, wqe->sqe.rkey);
+		break;
+
+	default:
+		rv = -EINVAL;
+	}
+	return rv;
+}
+
+
+/*
+ * siw_qp_sq_process()
+ *
+ * Core TX path routine for RDMAP/DDP/MPA using a TCP kernel socket.
+ * Sends RDMAP payload for the current SQ WR @wqe of @qp in one or more
+ * MPA FPDUs, each containing a DDP segment.
+ *
+ * SQ processing may occur in user context as a result of posting
+ * new WQE's or from siw_sq_work_handler() context. Processing in
+ * user context is limited to non-kernel verbs users.
+ *
+ * SQ processing may get paused anytime, possibly in the middle of a WR
+ * or FPDU, if insufficient send space is available. SQ processing
+ * gets resumed from siw_sq_work_handler(), if send space becomes
+ * available again.
+ *
+ * Must be called with the QP state read-locked.
+ *
+ * TODO:
+ * To be solved more seriously: an outbound RREQ can be satisfied
+ * by the corresponding RRESP _before_ it gets assigned to the ORQ.
+ * This happens regularly in RDMA READ via loopback case. Since both
+ * outbound RREQ and inbound RRESP can be handled by the same CPU
+ * locking the ORQ is dead-lock prone and thus not an option.
+ * Tentatively, the RREQ gets assigned to the ORQ _before_ being
+ * sent (and pulled back in case of send failure).
+ */
+int siw_qp_sq_process(struct siw_qp *qp)
+{
+	struct siw_wqe		*wqe = tx_wqe(qp);
+	enum siw_opcode		tx_type;
+	unsigned long		flags;
+	int			rv = 0;
+
+	wait_event(qp->tx_ctx.waitq, !atomic_read(&qp->tx_ctx.in_use));
+
+	if (atomic_inc_return(&qp->tx_ctx.in_use) > 1) {
+		pr_warn("SIW: QP[%d] already active\n", QP_ID(qp));
+		goto done;
+	}
+next_wqe:
+	/*
+	 * Stop QP processing if SQ state changed
+	 */
+	if (unlikely(qp->tx_ctx.tx_suspend)) {
+		dprint(DBG_WR|DBG_TX, "(QP%d): tx suspend\n", QP_ID(qp));
+		goto done;
+	}
+	tx_type = tx_type(wqe);
+
+	if (tx_type <= SIW_OP_READ_RESPONSE)
+		rv = siw_qp_sq_proc_tx(qp, wqe);
+	else
+		rv = siw_qp_sq_proc_local(qp, wqe);
+
+	if (!rv) {
+		/*
+		 * WQE processing done
+		 */
+		switch (tx_type) {
+
+		case SIW_OP_SEND:
+		case SIW_OP_SEND_REMOTE_INV:
+		case SIW_OP_WRITE:
+			siw_wqe_put_mem(wqe, tx_type);
+		case SIW_OP_INVAL_STAG:
+		case SIW_OP_REG_MR:
+			if (tx_flags(wqe) & SIW_WQE_SIGNALLED)
+				siw_sqe_complete(qp, &wqe->sqe, wqe->bytes,
+						 SIW_WC_SUCCESS);
+			break;
+
+		case SIW_OP_READ:
+		case SIW_OP_READ_LOCAL_INV:
+			/*
+			 * already enqueued to ORQ queue
+			 */
+			break;
+
+		case SIW_OP_READ_RESPONSE:
+			siw_wqe_put_mem(wqe, tx_type);
+			break;
+
+		default:
+			BUG();
+		}
+
+		spin_lock_irqsave(&qp->sq_lock, flags);
+		wqe->wr_status = SIW_WR_IDLE;
+		rv = siw_activate_tx(qp);
+		spin_unlock_irqrestore(&qp->sq_lock, flags);
+
+		if (unlikely(rv <= 0))
+			goto done;
+
+		goto next_wqe;
+
+	} else if (rv == -EAGAIN) {
+		dprint(DBG_WR|DBG_TX,
+			"(QP%d): SQ paused: hd/tr %d of %d, data %d\n",
+			QP_ID(qp), qp->tx_ctx.ctrl_sent, qp->tx_ctx.ctrl_len,
+			qp->tx_ctx.bytes_unsent);
+		rv = 0;
+		goto done;
+	} else if (rv == -EINPROGRESS) {
+		siw_sq_start(qp);
+		rv = 0;
+		goto done;
+	} else {
+		/*
+		 * WQE processing failed.
+		 * Verbs 8.3.2:
+		 * o It turns any WQE into a signalled WQE.
+		 * o Local catastrophic error must be surfaced
+		 * o QP must be moved into Terminate state: done by code
+		 *   doing socket state change processing
+		 *
+		 * o TODO: Termination message must be sent.
+		 * o TODO: Implement more precise work completion errors,
+		 *         see enum ib_wc_status in ib_verbs.h
+		 */
+		dprint(DBG_ON, " (QP%d): WQE type %d processing failed: %d\n",
+				QP_ID(qp), tx_type(wqe), rv);
+
+		spin_lock_irqsave(&qp->sq_lock, flags);
+		/*
+		 * RREQ may have already been completed by inbound RRESP!
+		 */
+		if (tx_type == SIW_OP_READ ||
+		    tx_type == SIW_OP_READ_LOCAL_INV) {
+			/* Cleanup pending entry in ORQ */
+			qp->orq_put--;
+			qp->orq[qp->orq_put % qp->attrs.orq_size].flags = 0;
+		}
+		spin_unlock_irqrestore(&qp->sq_lock, flags);
+		/*
+		 * immediately suspends further TX processing
+		 */
+		if (!qp->tx_ctx.tx_suspend)
+			siw_qp_cm_drop(qp, 0);
+
+		switch (tx_type) {
+
+		case SIW_OP_SEND:
+		case SIW_OP_SEND_REMOTE_INV:
+		case SIW_OP_SEND_WITH_IMM:
+		case SIW_OP_WRITE:
+		case SIW_OP_READ:
+		case SIW_OP_READ_LOCAL_INV:
+			siw_wqe_put_mem(wqe, tx_type);
+		case SIW_OP_INVAL_STAG:
+		case SIW_OP_REG_MR:
+			siw_sqe_complete(qp, &wqe->sqe, wqe->bytes,
+					 SIW_WC_LOC_QP_OP_ERR);
+
+			siw_qp_event(qp, IB_EVENT_QP_FATAL);
+
+			break;
+
+		case SIW_OP_READ_RESPONSE:
+			dprint(DBG_WR|DBG_TX|DBG_ON,
+				"(QP%d): Processing RRESPONSE failed: %d\n",
+				QP_ID(qp), rv);
+
+			siw_qp_event(qp, IB_EVENT_QP_REQ_ERR);
+
+			siw_wqe_put_mem(wqe, SIW_OP_READ_RESPONSE);
+
+			break;
+
+		default:
+			BUG();
+		}
+		wqe->wr_status = SIW_WR_IDLE;
+	}
+done:
+	atomic_dec(&qp->tx_ctx.in_use);
+	wake_up(&qp->tx_ctx.waitq);
+
+	return rv;
+}
+
+static void siw_sq_resume(struct siw_qp *qp)
+{
+
+	if (down_read_trylock(&qp->state_lock)) {
+		if (likely(qp->attrs.state == SIW_QP_STATE_RTS &&
+			!qp->tx_ctx.tx_suspend)) {
+
+			int rv = siw_qp_sq_process(qp);
+
+			up_read(&qp->state_lock);
+
+			if (unlikely(rv < 0)) {
+				pr_info("QP[%d]: SQ task failed: %d\n",
+					QP_ID(qp), rv);
+				if (!qp->tx_ctx.tx_suspend)
+					siw_qp_cm_drop(qp, 0);
+			}
+		} else
+			up_read(&qp->state_lock);
+	} else
+		pr_info("QP[%d]: Resume SQ while QP locked\n", QP_ID(qp));
+
+	siw_qp_put(qp);
+}
+
+struct tx_task_t {
+	struct llist_head active;
+	wait_queue_head_t waiting;
+};
+
+DEFINE_PER_CPU(struct tx_task_t, tx_task_g);
+extern struct task_struct *qp_tx_thread[];
+
+void siw_stop_tx_thread(int nr_cpu)
+{
+	kthread_stop(qp_tx_thread[nr_cpu]);
+	wake_up(&per_cpu(tx_task_g, nr_cpu).waiting);
+}
+
+int siw_run_sq(void *data)
+{
+	const int nr_cpu = (unsigned int)(long)data;
+	struct llist_node *active;
+	struct siw_qp *qp;
+	struct tx_task_t *tx_task = &per_cpu(tx_task_g, nr_cpu);
+
+	init_llist_head(&tx_task->active);
+	init_waitqueue_head(&tx_task->waiting);
+
+	pr_info("Started siw TX thread on CPU %u\n", nr_cpu);
+
+	while (1) {
+		struct llist_node *fifo_list = NULL;
+
+		wait_event_interruptible(tx_task->waiting,
+					 !llist_empty(&tx_task->active) ||
+					 kthread_should_stop());
+
+		if (kthread_should_stop())
+			break;
+
+		active = llist_del_all(&tx_task->active);
+		/*
+		 * llist_del_all returns a list with newest entry first.
+		 * Re-order list for fairness among QP's.
+		 */
+		while (active) {
+			struct llist_node *tmp = active;
+
+			active = llist_next(active);
+			tmp->next = fifo_list;
+			fifo_list = tmp;
+		}
+		while (fifo_list) {
+			qp = container_of(fifo_list, struct siw_qp, tx_list);
+			fifo_list = llist_next(fifo_list);
+			qp->tx_list.next = NULL;
+
+			siw_sq_resume(qp);
+		}
+	}
+	active = llist_del_all(&tx_task->active);
+	if (active != NULL) {
+		llist_for_each_entry(qp, active, tx_list) {
+			qp->tx_list.next = NULL;
+			siw_sq_resume(qp);
+		}
+	}
+	pr_info("Stopped siw TX thread on CPU %u\n", nr_cpu);
+	return 0;
+}
+
+int siw_sq_start(struct siw_qp *qp)
+{
+	int cpu = qp->cpu;
+
+	if (tx_wqe(qp)->wr_status == SIW_WR_IDLE)
+		goto out;
+
+	dprint(DBG_TX|DBG_OBJ, "(qp%d)\n", QP_ID(qp));
+
+	if (!cpu_online(cpu) || qp_tx_thread[cpu] == NULL)
+		cpu = default_tx_cpu;
+
+	if (unlikely(cpu < 0)) {
+		WARN_ON(1);
+		goto out;
+	}
+	if (!llist_empty(&per_cpu(tx_task_g, cpu).active)) {
+		int new_cpu;
+
+		for_each_online_cpu(new_cpu) {
+			if (qp_tx_thread[new_cpu] != NULL &&
+			    llist_empty(&per_cpu(tx_task_g, new_cpu).active)) {
+				cpu = new_cpu;
+				qp->cpu = new_cpu;
+				break;
+			}
+		}
+	}
+
+	siw_qp_get(qp);
+	llist_add(&qp->tx_list, &per_cpu(tx_task_g, cpu).active);
+
+	wake_up(&per_cpu(tx_task_g, cpu).waiting);
+out:
+	return 0;
+}
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
new file mode 100644
index 000000000000..b119b3c2a31e
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -0,0 +1,1933 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+
+#include <rdma/iw_cm.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+
+#include "siw.h"
+#include "siw_verbs.h"
+#include "siw_obj.h"
+#include "siw_cm.h"
+
+static int ib_qp_state_to_siw_qp_state[IB_QPS_ERR+1] = {
+	[IB_QPS_RESET]	= SIW_QP_STATE_IDLE,
+	[IB_QPS_INIT]	= SIW_QP_STATE_IDLE,
+	[IB_QPS_RTR]	= SIW_QP_STATE_RTR,
+	[IB_QPS_RTS]	= SIW_QP_STATE_RTS,
+	[IB_QPS_SQD]	= SIW_QP_STATE_CLOSING,
+	[IB_QPS_SQE]	= SIW_QP_STATE_TERMINATE,
+	[IB_QPS_ERR]	= SIW_QP_STATE_ERROR
+};
+
+static inline struct siw_pd *siw_pd_ofa2siw(struct ib_pd *ofa_pd)
+{
+	return container_of(ofa_pd, struct siw_pd, ofa_pd);
+}
+
+static inline struct siw_ucontext *siw_ctx_ofa2siw(struct ib_ucontext *ofa_ctx)
+{
+	return container_of(ofa_ctx, struct siw_ucontext, ib_ucontext);
+}
+
+static inline struct siw_cq *siw_cq_ofa2siw(struct ib_cq *ofa_cq)
+{
+	return container_of(ofa_cq, struct siw_cq, ofa_cq);
+}
+
+static inline struct siw_srq *siw_srq_ofa2siw(struct ib_srq *ofa_srq)
+{
+	return container_of(ofa_srq, struct siw_srq, ofa_srq);
+}
+
+static u32 siw_insert_uobj(struct siw_ucontext *uctx, void *vaddr, u32 size)
+{
+	struct siw_uobj *uobj;
+	u32	key = SIW_INVAL_UOBJ_KEY;
+
+	uobj = kzalloc(sizeof(*uobj), GFP_KERNEL);
+	if (!uobj)
+		goto out;
+
+	size = PAGE_ALIGN(size);
+
+	spin_lock(&uctx->uobj_lock);
+
+	if (list_empty(&uctx->uobj_list))
+		uctx->uobj_key = 0;
+
+	key = uctx->uobj_key;
+
+	uobj->key = uctx->uobj_key;
+	uctx->uobj_key += size; /* advance for next object */
+
+	if (key > SIW_MAX_UOBJ_KEY) {
+		uctx->uobj_key -= size;
+		key = SIW_INVAL_UOBJ_KEY;
+		kfree(uobj);
+		goto out;
+	}
+	uobj->size = size;
+	uobj->addr = vaddr;
+
+	list_add_tail(&uobj->list, &uctx->uobj_list);
+out:
+	spin_unlock(&uctx->uobj_lock);
+
+	return key;
+}
+
+static struct siw_uobj *siw_remove_uobj(struct siw_ucontext *uctx, u32 key,
+					u32 size)
+{
+	struct list_head *pos, *nxt;
+
+	spin_lock(&uctx->uobj_lock);
+
+	list_for_each_safe(pos, nxt, &uctx->uobj_list) {
+		struct siw_uobj *uobj = list_entry(pos, struct siw_uobj, list);
+
+		if (uobj->key == key && uobj->size == size) {
+			list_del(&uobj->list);
+			spin_unlock(&uctx->uobj_lock);
+			return uobj;
+		}
+	}
+	spin_unlock(&uctx->uobj_lock);
+
+	return NULL;
+}
+
+int siw_mmap(struct ib_ucontext *ctx, struct vm_area_struct *vma)
+{
+	struct siw_ucontext     *uctx = siw_ctx_ofa2siw(ctx);
+	struct siw_uobj         *uobj;
+	u32     key = vma->vm_pgoff << PAGE_SHIFT;
+	int     size = vma->vm_end - vma->vm_start;
+	int     rv = -EINVAL;
+
+	/*
+	 * Must be page aligned
+	 */
+	if (vma->vm_start & (PAGE_SIZE - 1)) {
+		pr_warn("map not page aligned\n");
+		goto out;
+	}
+
+	uobj = siw_remove_uobj(uctx, key, size);
+	if (!uobj) {
+		pr_warn("mmap lookup failed: %u, %d\n", key, size);
+		goto out;
+	}
+	rv = remap_vmalloc_range(vma, uobj->addr, 0);
+	if (rv)
+		pr_warn("remap_vmalloc_range failed: %u, %d\n", key, size);
+
+	kfree(uobj);
+out:
+	return rv;
+}
+
+
+struct ib_ucontext *siw_alloc_ucontext(struct ib_device *ofa_dev,
+				       struct ib_udata *udata)
+{
+	struct siw_ucontext *ctx = NULL;
+	struct siw_dev *sdev = siw_dev_ofa2siw(ofa_dev);
+	int rv;
+
+	dprint(DBG_CM, "(device=%s)\n", ofa_dev->name);
+
+	if (atomic_inc_return(&sdev->num_ctx) > SIW_MAX_CONTEXT) {
+		dprint(DBG_ON, ": Out of CONTEXT's\n");
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	spin_lock_init(&ctx->uobj_lock);
+	INIT_LIST_HEAD(&ctx->uobj_list);
+	ctx->uobj_key = 0;
+
+	ctx->sdev = sdev;
+	if (udata) {
+		struct siw_uresp_alloc_ctx uresp;
+
+		memset(&uresp, 0, sizeof(uresp));
+		uresp.dev_id = sdev->attrs.vendor_part_id;
+
+		rv = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
+		if (rv)
+			goto err_out;
+	}
+	return &ctx->ib_ucontext;
+
+err_out:
+	kfree(ctx);
+
+	atomic_dec(&sdev->num_ctx);
+	return ERR_PTR(rv);
+}
+
+int siw_dealloc_ucontext(struct ib_ucontext *ofa_ctx)
+{
+	struct siw_ucontext *ctx = siw_ctx_ofa2siw(ofa_ctx);
+
+	atomic_dec(&ctx->sdev->num_ctx);
+	kfree(ctx);
+	return 0;
+}
+
+int siw_query_device(struct ib_device *ofa_dev, struct ib_device_attr *attr,
+		     struct ib_udata *unused)
+{
+	struct siw_dev *sdev = siw_dev_ofa2siw(ofa_dev);
+	/*
+	 * A process context is needed to report avail memory resources.
+	 */
+	if (in_interrupt())
+		return -EINVAL;
+
+	memset(attr, 0, sizeof(*attr));
+
+	attr->max_mr_size = rlimit(RLIMIT_MEMLOCK); /* per process */
+	attr->vendor_id = sdev->attrs.vendor_id;
+	attr->vendor_part_id = sdev->attrs.vendor_part_id;
+	attr->max_qp = sdev->attrs.max_qp;
+	attr->max_qp_wr = sdev->attrs.max_qp_wr;
+
+	attr->max_qp_rd_atom = sdev->attrs.max_ord;
+	attr->max_qp_init_rd_atom = sdev->attrs.max_ird;
+	attr->max_res_rd_atom = sdev->attrs.max_qp * sdev->attrs.max_ird;
+	attr->device_cap_flags = sdev->attrs.cap_flags;
+	attr->max_sge = sdev->attrs.max_sge;
+	attr->max_sge_rd = sdev->attrs.max_sge_rd;
+	attr->max_cq = sdev->attrs.max_cq;
+	attr->max_cqe = sdev->attrs.max_cqe;
+	attr->max_mr = sdev->attrs.max_mr;
+	attr->max_pd = sdev->attrs.max_pd;
+	attr->max_mw = sdev->attrs.max_mw;
+	attr->max_fmr = sdev->attrs.max_fmr;
+	attr->max_srq = sdev->attrs.max_srq;
+	attr->max_srq_wr = sdev->attrs.max_srq_wr;
+	attr->max_srq_sge = sdev->attrs.max_srq_sge;
+	attr->max_fast_reg_page_list_len = SIW_MAX_SGE_PBL;
+
+	memcpy(&attr->sys_image_guid, sdev->netdev->dev_addr, 6);
+
+	/*
+	 * TODO: understand what of the following should
+	 * get useful information
+	 *
+	 * attr->fw_ver;
+	 * attr->max_ah
+	 * attr->max_map_per_fmr
+	 * attr->max_ee
+	 * attr->max_rdd
+	 * attr->max_ee_rd_atom;
+	 * attr->max_ee_init_rd_atom;
+	 * attr->max_raw_ipv6_qp
+	 * attr->max_raw_ethy_qp
+	 * attr->max_mcast_grp
+	 * attr->max_mcast_qp_attach
+	 * attr->max_total_mcast_qp_attach
+	 * attr->max_pkeys
+	 * attr->atomic_cap;
+	 * attr->page_size_cap;
+	 * attr->hw_ver;
+	 * attr->local_ca_ack_delay;
+	 */
+	return 0;
+}
+
+/*
+ * Approximate translation of real MTU for IB.
+ *
+ * TODO: is that needed for RNIC's? We may have a medium
+ *       which reports MTU of 64kb and have to degrade to 4k??
+ */
+static inline enum ib_mtu siw_mtu_net2ofa(unsigned short mtu)
+{
+	if (mtu >= 4096)
+		return IB_MTU_4096;
+	if (mtu >= 2048)
+		return IB_MTU_2048;
+	if (mtu >= 1024)
+		return IB_MTU_1024;
+	if (mtu >= 512)
+		return IB_MTU_512;
+	if (mtu >= 256)
+		return IB_MTU_256;
+	return IB_MTU_4096;
+}
+
+int siw_query_port(struct ib_device *ofa_dev, u8 port,
+		     struct ib_port_attr *attr)
+{
+	struct siw_dev *sdev = siw_dev_ofa2siw(ofa_dev);
+
+	memset(attr, 0, sizeof(*attr));
+
+	attr->state = sdev->state;
+	attr->max_mtu = siw_mtu_net2ofa(sdev->netdev->mtu);
+	attr->active_mtu = attr->max_mtu;
+	attr->gid_tbl_len = 1;
+	attr->port_cap_flags = IB_PORT_CM_SUP;	/* ?? */
+	attr->port_cap_flags |= IB_PORT_DEVICE_MGMT_SUP;
+	attr->max_msg_sz = -1;
+	attr->pkey_tbl_len = 1;
+	attr->active_width = 2;
+	attr->active_speed = 2;
+	attr->phys_state = sdev->state == IB_PORT_ACTIVE ? 5 : 3;
+	/*
+	 * All zero
+	 *
+	 * attr->lid = 0;
+	 * attr->bad_pkey_cntr = 0;
+	 * attr->qkey_viol_cntr = 0;
+	 * attr->sm_lid = 0;
+	 * attr->lmc = 0;
+	 * attr->max_vl_num = 0;
+	 * attr->sm_sl = 0;
+	 * attr->subnet_timeout = 0;
+	 * attr->init_type_repy = 0;
+	 */
+	return 0;
+}
+
+int siw_get_port_immutable(struct ib_device *ofa_dev, u8 port,
+			   struct ib_port_immutable *port_immutable)
+{
+	struct ib_port_attr attr;
+	int rv = siw_query_port(ofa_dev, port, &attr);
+
+	if (rv)
+		return rv;
+
+	port_immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	port_immutable->gid_tbl_len = attr.gid_tbl_len;
+	port_immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
+
+	return 0;
+}
+
+int siw_query_pkey(struct ib_device *ofa_dev, u8 port, u16 idx, u16 *pkey)
+{
+	/* Report the default pkey */
+	*pkey = 0xffff;
+	return 0;
+}
+
+int siw_query_gid(struct ib_device *ofa_dev, u8 port, int idx,
+		   union ib_gid *gid)
+{
+	struct siw_dev *sdev = siw_dev_ofa2siw(ofa_dev);
+
+	/* subnet_prefix == interface_id == 0; */
+	memset(gid, 0, sizeof(*gid));
+	memcpy(&gid->raw[0], sdev->netdev->dev_addr, 6);
+
+	return 0;
+}
+
+struct ib_pd *siw_alloc_pd(struct ib_device *ofa_dev,
+			   struct ib_ucontext *context, struct ib_udata *udata)
+{
+	struct siw_pd	*pd = NULL;
+	struct siw_dev	*sdev  = siw_dev_ofa2siw(ofa_dev);
+	int rv;
+
+	if (atomic_inc_return(&sdev->num_pd) > SIW_MAX_PD) {
+		dprint(DBG_ON, ": Out of PD's\n");
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	pd = kmalloc(sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		dprint(DBG_ON, ": malloc\n");
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	rv = siw_pd_add(sdev, pd);
+	if (rv) {
+		dprint(DBG_ON, ": siw_pd_add\n");
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	if (context) {
+		if (ib_copy_to_udata(udata, &pd->hdr.id, sizeof(pd->hdr.id))) {
+			rv = -EFAULT;
+			goto err_out_idr;
+		}
+	}
+	return &pd->ofa_pd;
+
+err_out_idr:
+	siw_remove_obj(&sdev->idr_lock, &sdev->pd_idr, &pd->hdr);
+err_out:
+	kfree(pd);
+	atomic_dec(&sdev->num_pd);
+
+	return ERR_PTR(rv);
+}
+
+int siw_dealloc_pd(struct ib_pd *ofa_pd)
+{
+	struct siw_pd	*pd = siw_pd_ofa2siw(ofa_pd);
+	struct siw_dev	*sdev = siw_dev_ofa2siw(ofa_pd->device);
+
+	siw_remove_obj(&sdev->idr_lock, &sdev->pd_idr, &pd->hdr);
+	siw_pd_put(pd);
+
+	return 0;
+}
+
+void siw_qp_get_ref(struct ib_qp *ofa_qp)
+{
+	struct siw_qp	*qp = siw_qp_ofa2siw(ofa_qp);
+
+	dprint(DBG_OBJ|DBG_CM, "(QP%d): Get Reference\n", QP_ID(qp));
+	siw_qp_get(qp);
+}
+
+
+void siw_qp_put_ref(struct ib_qp *ofa_qp)
+{
+	struct siw_qp	*qp = siw_qp_ofa2siw(ofa_qp);
+
+	dprint(DBG_OBJ|DBG_CM, "(QP%d): Put Reference\n", QP_ID(qp));
+	siw_qp_put(qp);
+}
+
+int siw_no_mad(struct ib_device *ofa_dev, int flags, u8 port,
+	       const struct ib_wc *wc, const struct ib_grh *grh,
+	       const struct ib_mad_hdr *in_mad, size_t in_mad_size,
+	       struct ib_mad_hdr *out_mad, size_t *out_mad_size,
+	       u16 *outmad_pkey_index)
+{
+	return -EOPNOTSUPP;
+}
+
+
+/*
+ * siw_create_qp()
+ *
+ * Create QP of requested size on given device.
+ *
+ * @ofa_pd:	OFA PD contained in siw PD
+ * @attrs:	Initial QP attributes.
+ * @udata:	used to provide QP ID, SQ and RQ size back to user.
+ */
+
+struct ib_qp *siw_create_qp(struct ib_pd *ofa_pd,
+			    struct ib_qp_init_attr *attrs,
+			    struct ib_udata *udata)
+{
+	struct siw_qp			*qp = NULL;
+	struct siw_pd			*pd = siw_pd_ofa2siw(ofa_pd);
+	struct ib_device		*ofa_dev = ofa_pd->device;
+	struct siw_dev			*sdev = siw_dev_ofa2siw(ofa_dev);
+	struct siw_cq			*scq = NULL, *rcq = NULL;
+
+	unsigned long flags;
+	int num_sqe, num_rqe, rv = 0;
+
+	dprint(DBG_OBJ|DBG_CM, ": new QP on device %s\n",
+		ofa_dev->name);
+
+	if (atomic_inc_return(&sdev->num_qp) > SIW_MAX_QP) {
+		dprint(DBG_ON, ": Out of QP's\n");
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	if (attrs->qp_type != IB_QPT_RC) {
+		dprint(DBG_ON, ": Only RC QP's supported\n");
+		rv = -EINVAL;
+		goto err_out;
+	}
+	if ((attrs->cap.max_send_wr > SIW_MAX_QP_WR) ||
+	    (attrs->cap.max_recv_wr > SIW_MAX_QP_WR) ||
+	    (attrs->cap.max_send_sge > SIW_MAX_SGE)  ||
+	    (attrs->cap.max_recv_sge > SIW_MAX_SGE)) {
+		dprint(DBG_ON, ": QP Size!\n");
+		rv = -EINVAL;
+		goto err_out;
+	}
+	if (attrs->cap.max_inline_data > SIW_MAX_INLINE) {
+		dprint(DBG_ON, ": Max Inline Send %d > %d!\n",
+		       attrs->cap.max_inline_data, (int)SIW_MAX_INLINE);
+		rv = -EINVAL;
+		goto err_out;
+	}
+	/*
+	 * NOTE: we allow for zero element SQ and RQ WQE's SGL's
+	 * but not for a QP unable to hold any WQE (SQ + RQ)
+	 */
+	if (attrs->cap.max_send_wr + attrs->cap.max_recv_wr == 0) {
+		rv = -EINVAL;
+		goto err_out;
+	}
+
+	scq = siw_cq_id2obj(sdev, ((struct siw_cq *)attrs->send_cq)->hdr.id);
+	rcq = siw_cq_id2obj(sdev, ((struct siw_cq *)attrs->recv_cq)->hdr.id);
+
+	if (!scq || (!rcq && !attrs->srq)) {
+		dprint(DBG_OBJ, ": Fail: SCQ: 0x%p, RCQ: 0x%p\n",
+			scq, rcq);
+		rv = -EINVAL;
+		goto err_out;
+	}
+	qp = kzalloc(sizeof(*qp), GFP_KERNEL);
+	if (!qp) {
+		dprint(DBG_ON, ": kzalloc\n");
+		rv = -ENOMEM;
+		goto err_out;
+	}
+
+	init_rwsem(&qp->state_lock);
+	spin_lock_init(&qp->sq_lock);
+	spin_lock_init(&qp->rq_lock);
+	spin_lock_init(&qp->orq_lock);
+
+	init_waitqueue_head(&qp->tx_ctx.waitq);
+
+	if (!ofa_pd->uobject)
+		qp->kernel_verbs = 1;
+
+	rv = siw_qp_add(sdev, qp);
+	if (rv)
+		goto err_out;
+
+	num_sqe = roundup_pow_of_two(attrs->cap.max_send_wr);
+	num_rqe = roundup_pow_of_two(attrs->cap.max_recv_wr);
+
+	if (qp->kernel_verbs)
+		qp->sendq = vmalloc(num_sqe * sizeof(struct siw_sqe));
+	else
+		qp->sendq = vmalloc_user(num_sqe * sizeof(struct siw_sqe));
+
+	if (qp->sendq == NULL) {
+		pr_warn("QP(%d): send queue size %d alloc failed\n",
+			QP_ID(qp), num_sqe);
+		rv = -ENOMEM;
+		goto err_out_idr;
+	}
+	if (attrs->sq_sig_type != IB_SIGNAL_REQ_WR) {
+		if (attrs->sq_sig_type == IB_SIGNAL_ALL_WR)
+			qp->attrs.flags |= SIW_SIGNAL_ALL_WR;
+		else {
+			rv = -EINVAL;
+			goto err_out_idr;
+		}
+	}
+	qp->pd  = pd;
+	qp->scq = scq;
+	qp->rcq = rcq;
+
+	if (attrs->srq) {
+		/*
+		 * SRQ support.
+		 * Verbs 6.3.7: ignore RQ size, if SRQ present
+		 * Verbs 6.3.5: do not check PD of SRQ against PD of QP
+		 */
+		qp->srq = siw_srq_ofa2siw(attrs->srq);
+		qp->attrs.rq_size = 0;
+		dprint(DBG_OBJ, " QP(%d): SRQ(%p) attached\n",
+			QP_ID(qp), qp->srq);
+	} else if (num_rqe) {
+		if (qp->kernel_verbs)
+			qp->recvq = vmalloc(num_rqe * sizeof(struct siw_rqe));
+		else
+			qp->recvq = vmalloc_user(num_rqe *
+						 sizeof(struct siw_rqe));
+
+		if (qp->recvq == NULL) {
+			pr_warn("QP(%d): recv queue size %d alloc failed\n",
+				QP_ID(qp), num_rqe);
+			rv = -ENOMEM;
+			goto err_out_idr;
+		}
+
+		qp->attrs.rq_size = num_rqe;
+	}
+	qp->attrs.sq_size = num_sqe;
+	qp->attrs.sq_max_sges = attrs->cap.max_send_sge;
+	/*
+	 * ofed has no max_send_sge_rdmawrite
+	 */
+	qp->attrs.sq_max_sges_rdmaw = attrs->cap.max_send_sge;
+	qp->attrs.rq_max_sges = attrs->cap.max_recv_sge;
+
+	qp->attrs.state = SIW_QP_STATE_IDLE;
+
+	/* vmalloc_user already zeroes SQ and RQ memory */
+	if (qp->kernel_verbs) {
+		if (qp->sendq)
+			memset(qp->sendq, 0, num_sqe * sizeof(struct siw_sqe));
+		if (qp->recvq)
+			memset(qp->recvq, 0, num_rqe * sizeof(struct siw_rqe));
+	}
+	if (udata) {
+		struct siw_uresp_create_qp uresp;
+		struct siw_ucontext *ctx;
+
+		memset(&uresp, 0, sizeof(uresp));
+		ctx = siw_ctx_ofa2siw(ofa_pd->uobject->context);
+
+		uresp.sq_key = uresp.rq_key = SIW_INVAL_UOBJ_KEY;
+		uresp.num_sqe = num_sqe;
+		uresp.num_rqe = num_rqe;
+		uresp.qp_id = QP_ID(qp);
+
+		if (qp->sendq) {
+			uresp.sq_key = siw_insert_uobj(ctx, qp->sendq,
+					num_sqe * sizeof(struct siw_sqe));
+			if (uresp.sq_key > SIW_MAX_UOBJ_KEY)
+				pr_warn("Preparing mmap SQ failed\n");
+		}
+		if (qp->recvq) {
+			uresp.rq_key = siw_insert_uobj(ctx, qp->recvq,
+					num_rqe * sizeof(struct siw_rqe));
+			if (uresp.rq_key > SIW_MAX_UOBJ_KEY)
+				pr_warn("Preparing mmap RQ failed\n");
+		}
+		rv = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
+		if (rv)
+			goto err_out_idr;
+	}
+	atomic_set(&qp->tx_ctx.in_use, 0);
+
+	qp->ofa_qp.qp_num = QP_ID(qp);
+
+	siw_pd_get(pd);
+
+	INIT_LIST_HEAD(&qp->devq);
+	spin_lock_irqsave(&sdev->idr_lock, flags);
+	list_add_tail(&qp->devq, &sdev->qp_list);
+	spin_unlock_irqrestore(&sdev->idr_lock, flags);
+
+	qp->cpu = (smp_processor_id() + 1) % MAX_CPU;
+
+	return &qp->ofa_qp;
+
+err_out_idr:
+	siw_remove_obj(&sdev->idr_lock, &sdev->qp_idr, &qp->hdr);
+err_out:
+	if (scq)
+		siw_cq_put(scq);
+	if (rcq)
+		siw_cq_put(rcq);
+
+	if (qp) {
+		if (qp->sendq)
+			vfree(qp->sendq);
+		if (qp->recvq)
+			vfree(qp->recvq);
+		kfree(qp);
+	}
+	atomic_dec(&sdev->num_qp);
+
+	return ERR_PTR(rv);
+}
+
+/*
+ * Minimum siw_query_qp() verb interface.
+ *
+ * @qp_attr_mask is not used but all available information is provided
+ */
+int siw_query_qp(struct ib_qp *ofa_qp, struct ib_qp_attr *qp_attr,
+		 int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr)
+{
+	struct siw_qp *qp;
+	struct siw_dev *sdev;
+
+	if (ofa_qp && qp_attr && qp_init_attr) {
+		qp = siw_qp_ofa2siw(ofa_qp);
+		sdev = siw_dev_ofa2siw(ofa_qp->device);
+	} else
+		return -EINVAL;
+
+	qp_attr->cap.max_inline_data = SIW_MAX_INLINE;
+	qp_attr->cap.max_send_wr = qp->attrs.sq_size;
+	qp_attr->cap.max_send_sge = qp->attrs.sq_max_sges;
+	qp_attr->cap.max_recv_wr = qp->attrs.rq_size;
+	qp_attr->cap.max_recv_sge = qp->attrs.rq_max_sges;
+	qp_attr->path_mtu = siw_mtu_net2ofa(sdev->netdev->mtu);
+	qp_attr->max_rd_atomic = qp->attrs.irq_size;
+	qp_attr->max_dest_rd_atomic = qp->attrs.orq_size;
+
+	qp_attr->qp_access_flags = IB_ACCESS_LOCAL_WRITE |
+			IB_ACCESS_REMOTE_WRITE | IB_ACCESS_REMOTE_READ;
+
+	qp_init_attr->qp_type = ofa_qp->qp_type;
+	qp_init_attr->send_cq = ofa_qp->send_cq;
+	qp_init_attr->recv_cq = ofa_qp->recv_cq;
+	qp_init_attr->srq = ofa_qp->srq;
+
+	qp_init_attr->cap = qp_attr->cap;
+
+	return 0;
+}
+
+int siw_verbs_modify_qp(struct ib_qp *ofa_qp, struct ib_qp_attr *attr,
+			int attr_mask, struct ib_udata *udata)
+{
+	struct siw_qp_attrs	new_attrs;
+	enum siw_qp_attr_mask	siw_attr_mask = 0;
+	struct siw_qp		*qp = siw_qp_ofa2siw(ofa_qp);
+	int			rv = 0;
+
+	if (!attr_mask) {
+		dprint(DBG_CM, "(QP%d): attr_mask==0 ignored\n", QP_ID(qp));
+		goto out;
+	}
+	siw_dprint_qp_attr_mask(attr_mask);
+
+	memset(&new_attrs, 0, sizeof(new_attrs));
+
+	if (attr_mask & IB_QP_ACCESS_FLAGS) {
+
+		siw_attr_mask |= SIW_QP_ATTR_ACCESS_FLAGS;
+
+		if (attr->qp_access_flags & IB_ACCESS_REMOTE_READ)
+			new_attrs.flags |= SIW_RDMA_READ_ENABLED;
+		if (attr->qp_access_flags & IB_ACCESS_REMOTE_WRITE)
+			new_attrs.flags |= SIW_RDMA_WRITE_ENABLED;
+		if (attr->qp_access_flags & IB_ACCESS_MW_BIND)
+			new_attrs.flags |= SIW_RDMA_BIND_ENABLED;
+	}
+	if (attr_mask & IB_QP_STATE) {
+		dprint(DBG_CM, "(QP%d): Desired IB QP state: %s\n",
+			   QP_ID(qp), ib_qp_state_to_string[attr->qp_state]);
+
+		new_attrs.state = ib_qp_state_to_siw_qp_state[attr->qp_state];
+
+		if (new_attrs.state > SIW_QP_STATE_RTS)
+			qp->tx_ctx.tx_suspend = 1;
+
+		siw_attr_mask |= SIW_QP_ATTR_STATE;
+	}
+	if (!attr_mask)
+		goto out;
+
+	down_write(&qp->state_lock);
+
+	rv = siw_qp_modify(qp, &new_attrs, siw_attr_mask);
+
+	up_write(&qp->state_lock);
+
+out:
+	dprint(DBG_CM, "(QP%d): Exit with %d\n", QP_ID(qp), rv);
+	return rv;
+}
+
+int siw_destroy_qp(struct ib_qp *ofa_qp)
+{
+	struct siw_qp		*qp = siw_qp_ofa2siw(ofa_qp);
+	struct siw_qp_attrs	qp_attrs;
+
+	dprint(DBG_CM, "(QP%d): SIW QP state=%d, cep=0x%p\n",
+		QP_ID(qp), qp->attrs.state, qp->cep);
+
+	/*
+	 * Mark QP as in process of destruction to prevent from eventual async
+	 * callbacks to OFA core
+	 */
+	qp->attrs.flags |= SIW_QP_IN_DESTROY;
+	qp->rx_ctx.rx_suspend = 1;
+
+	down_write(&qp->state_lock);
+
+	qp_attrs.state = SIW_QP_STATE_ERROR;
+	(void)siw_qp_modify(qp, &qp_attrs, SIW_QP_ATTR_STATE);
+
+	if (qp->cep) {
+		siw_cep_put(qp->cep);
+		qp->cep = NULL;
+	}
+
+	up_write(&qp->state_lock);
+
+	if (qp->rx_ctx.mpa_crc_hd)
+		kfree(qp->rx_ctx.mpa_crc_hd);
+
+	if (qp->tx_ctx.mpa_crc_hd)
+		kfree(qp->tx_ctx.mpa_crc_hd);
+
+	/* Drop references */
+	siw_cq_put(qp->scq);
+	siw_cq_put(qp->rcq);
+	siw_pd_put(qp->pd);
+	qp->scq = qp->rcq = NULL;
+
+	siw_qp_put(qp);
+
+	return 0;
+}
+
+/*
+ * siw_copy_sgl()
+ *
+ * Copy SGL from OFA representation to local
+ * representation.
+ */
+static inline void siw_copy_sgl(struct ib_sge *ofa_sge, struct siw_sge *siw_sge,
+			       int num_sge)
+{
+	while (num_sge--) {
+		siw_sge->laddr = ofa_sge->addr;
+		siw_sge->length = ofa_sge->length;
+		siw_sge->lkey = ofa_sge->lkey;
+
+		siw_sge++; ofa_sge++;
+	}
+}
+
+/*
+ * siw_copy_inline_sgl()
+ *
+ * Prepare sgl of inlined data for sending. For userland callers
+ * function checks if given buffer addresses and len's are within
+ * process context bounds.
+ * Data from all provided sge's are copied together into the wqe,
+ * referenced by a single sge.
+ */
+static int siw_copy_inline_sgl(struct ib_send_wr *ofa_wr, struct siw_sqe *sqe)
+{
+	struct ib_sge	*ofa_sge = ofa_wr->sg_list;
+	void		*kbuf	 = &sqe->sge[1];
+	int		num_sge	 = ofa_wr->num_sge,
+			bytes	 = 0;
+
+	sqe->sge[0].laddr = (u64)kbuf;
+	sqe->sge[0].lkey = 0;
+
+	while (num_sge--) {
+		if (!ofa_sge->length) {
+			ofa_sge++;
+			continue;
+		}
+		bytes += ofa_sge->length;
+		if (bytes > SIW_MAX_INLINE) {
+			bytes = -EINVAL;
+			break;
+		}
+		memcpy(kbuf, (void *)(uintptr_t)ofa_sge->addr, ofa_sge->length);
+
+		kbuf += ofa_sge->length;
+		ofa_sge++;
+	}
+	sqe->sge[0].length = bytes > 0 ? bytes : 0;
+	sqe->num_sge = bytes > 0 ? 1 : 0;
+
+	return bytes;
+}
+
+
+/*
+ * siw_post_send()
+ *
+ * Post a list of S-WR's to a SQ.
+ *
+ * @ofa_qp:	OFA QP contained in siw QP
+ * @wr:		Null terminated list of user WR's
+ * @bad_wr:	Points to failing WR in case of synchronous failure.
+ */
+int siw_post_send(struct ib_qp *ofa_qp, struct ib_send_wr *wr,
+		  struct ib_send_wr **bad_wr)
+{
+	struct siw_qp	*qp = siw_qp_ofa2siw(ofa_qp);
+	struct siw_wqe	*wqe = tx_wqe(qp);
+
+	unsigned long flags;
+	int rv = 0;
+
+	dprint(DBG_WR|DBG_TX, "(QP%d): state=%d\n",
+		QP_ID(qp), qp->attrs.state);
+
+	/*
+	 * Try to acquire QP state lock. Must be non-blocking
+	 * to accommodate kernel clients needs.
+	 */
+	if (!down_read_trylock(&qp->state_lock)) {
+		*bad_wr = wr;
+		return -ENOTCONN;
+	}
+
+	if (unlikely(qp->attrs.state != SIW_QP_STATE_RTS)) {
+		dprint(DBG_WR, "(QP%d): state=%d\n",
+			QP_ID(qp), qp->attrs.state);
+		up_read(&qp->state_lock);
+		*bad_wr = wr;
+		return -ENOTCONN;
+	}
+	if (wr && qp->kernel_verbs == 0) {
+		dprint(DBG_WR|DBG_ON, "(QP%d): user mapped SQ with OFA WR\n",
+			QP_ID(qp));
+		up_read(&qp->state_lock);
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&qp->sq_lock, flags);
+
+	while (wr) {
+		u32 idx = qp->sq_put % qp->attrs.sq_size;
+		struct siw_sqe *sqe = &qp->sendq[idx];
+
+		if (sqe->flags) {
+			dprint(DBG_WR, "(QP%d): SQ full\n", QP_ID(qp));
+			rv = -ENOMEM;
+			break;
+		}
+		if (wr->num_sge > qp->attrs.sq_max_sges) {
+			/*
+			 * NOTE: we allow for zero length wr's here.
+			 */
+			dprint(DBG_WR, "(QP%d): Num SGE: %d\n",
+				QP_ID(qp), wr->num_sge);
+			rv = -EINVAL;
+			break;
+		}
+		sqe->id = wr->wr_id;
+		sqe->flags = 0;
+
+		if ((wr->send_flags & IB_SEND_SIGNALED) ||
+		    (qp->attrs.flags & SIW_SIGNAL_ALL_WR))
+			sqe->flags |= SIW_WQE_SIGNALLED;
+
+		if (wr->send_flags & IB_SEND_FENCE)
+			sqe->flags |= SIW_WQE_READ_FENCE;
+
+
+		switch (wr->opcode) {
+
+		case IB_WR_SEND:
+		case IB_WR_SEND_WITH_INV:
+			if (wr->send_flags & IB_SEND_SOLICITED)
+				sqe->flags |= SIW_WQE_SOLICITED;
+
+			if (!(wr->send_flags & IB_SEND_INLINE)) {
+				siw_copy_sgl(wr->sg_list, sqe->sge,
+					     wr->num_sge);
+				sqe->num_sge = wr->num_sge;
+			} else {
+				rv = siw_copy_inline_sgl(wr, sqe);
+				if (rv <= 0) {
+					rv = -EINVAL;
+					break;
+				}
+				sqe->flags |= SIW_WQE_INLINE;
+				sqe->num_sge = 1;
+			}
+			if (wr->opcode == IB_WR_SEND)
+				sqe->opcode = SIW_OP_SEND;
+			else {
+				sqe->opcode = SIW_OP_SEND_REMOTE_INV;
+				sqe->rkey = wr->ex.invalidate_rkey;
+			}
+			break;
+
+		case IB_WR_RDMA_READ_WITH_INV:
+		case IB_WR_RDMA_READ:
+			/*
+			 * OFED WR restricts RREAD sink to SGL containing
+			 * 1 SGE only. we could relax to SGL with multiple
+			 * elements referring the SAME ltag or even sending
+			 * a private per-rreq tag referring to a checked
+			 * local sgl with MULTIPLE ltag's. would be easy
+			 * to do...
+			 */
+			if (unlikely(wr->num_sge != 1)) {
+				rv = -EINVAL;
+				break;
+			}
+			siw_copy_sgl(wr->sg_list, &sqe->sge[0], 1);
+			/*
+			 * NOTE: zero length RREAD is allowed!
+			 */
+			sqe->raddr	= rdma_wr(wr)->remote_addr;
+			sqe->rkey	= rdma_wr(wr)->rkey;
+			sqe->num_sge	= 1;
+
+			if (wr->opcode == IB_WR_RDMA_READ)
+				sqe->opcode = SIW_OP_READ;
+			else
+				sqe->opcode = SIW_OP_READ_LOCAL_INV;
+			break;
+
+		case IB_WR_RDMA_WRITE:
+			if (!(wr->send_flags & IB_SEND_INLINE)) {
+				siw_copy_sgl(wr->sg_list, &sqe->sge[0],
+					     wr->num_sge);
+				sqe->num_sge = wr->num_sge;
+			} else {
+				rv = siw_copy_inline_sgl(wr, sqe);
+				if (unlikely(rv < 0)) {
+					rv = -EINVAL;
+					break;
+				}
+				sqe->flags |= SIW_WQE_INLINE;
+				sqe->num_sge = 1;
+			}
+			sqe->raddr	= rdma_wr(wr)->remote_addr;
+			sqe->rkey	= rdma_wr(wr)->rkey;
+			sqe->opcode	= SIW_OP_WRITE;
+
+			break;
+
+		case IB_WR_REG_MR:
+			sqe->ofa_mr = (uint64_t)reg_wr(wr)->mr;
+			sqe->rkey = reg_wr(wr)->key;
+			sqe->access = SIW_MEM_LREAD;
+			if (reg_wr(wr)->access & IB_ACCESS_LOCAL_WRITE)
+				sqe->access |= SIW_MEM_LWRITE;
+			if (reg_wr(wr)->access & IB_ACCESS_REMOTE_WRITE)
+				sqe->access |= SIW_MEM_RWRITE;
+			if (reg_wr(wr)->access & IB_ACCESS_REMOTE_READ)
+				sqe->access |= SIW_MEM_RREAD;
+			sqe->opcode = SIW_OP_REG_MR;
+
+			break;
+
+		case IB_WR_LOCAL_INV:
+			sqe->rkey = wr->ex.invalidate_rkey;
+			sqe->opcode = SIW_OP_INVAL_STAG;
+
+			break;
+
+		default:
+			dprint(DBG_WR|DBG_TX|DBG_ON,
+				"(QP%d): IB_WR %d not supported\n",
+				QP_ID(qp), wr->opcode);
+			rv = -EINVAL;
+			break;
+		}
+		dprint(DBG_WR|DBG_TX, "(QP%d): opcode %d, flags 0x%x\n",
+			QP_ID(qp), sqe->opcode, sqe->flags);
+		if (unlikely(rv < 0))
+			break;
+
+		/* make SQE only vaild after completely written */
+		smp_wmb();
+		sqe->flags |= SIW_WQE_VALID;
+
+		qp->sq_put++;
+		wr = wr->next;
+	}
+
+	/*
+	 * Send directly if SQ processing is not in progress.
+	 * Eventual immediate errors (rv < 0) do not affect the involved
+	 * RI resources (Verbs, 8.3.1) and thus do not prevent from SQ
+	 * processing, if new work is already pending. But rv must be passed
+	 * to caller.
+	 */
+	if (wqe->wr_status != SIW_WR_IDLE) {
+		spin_unlock_irqrestore(&qp->sq_lock, flags);
+		goto skip_direct_sending;
+	}
+	rv = siw_activate_tx(qp);
+	spin_unlock_irqrestore(&qp->sq_lock, flags);
+
+	if (rv <= 0)
+		goto skip_direct_sending;
+
+	if (qp->kernel_verbs)
+		siw_sq_start(qp);
+	else {
+		qp->tx_ctx.in_syscall = 1;
+
+		if (siw_qp_sq_process(qp) != 0 && !(qp->tx_ctx.tx_suspend))
+			siw_qp_cm_drop(qp, 0);
+
+		qp->tx_ctx.in_syscall = 0;
+	}
+
+skip_direct_sending:
+
+	up_read(&qp->state_lock);
+
+	if (rv >= 0)
+		return 0;
+	/*
+	 * Immediate error
+	 */
+	dprint(DBG_WR|DBG_ON, "(QP%d): error=%d\n", QP_ID(qp), rv);
+
+	*bad_wr = wr;
+	return rv;
+}
+
+/*
+ * siw_post_receive()
+ *
+ * Post a list of R-WR's to a RQ.
+ *
+ * @ofa_qp:	OFA QP contained in siw QP
+ * @wr:		Null terminated list of user WR's
+ * @bad_wr:	Points to failing WR in case of synchronous failure.
+ */
+int siw_post_receive(struct ib_qp *ofa_qp, struct ib_recv_wr *wr,
+		     struct ib_recv_wr **bad_wr)
+{
+	struct siw_qp	*qp = siw_qp_ofa2siw(ofa_qp);
+	int rv = 0;
+
+	dprint(DBG_WR|DBG_TX, "(QP%d): state=%d\n", QP_ID(qp),
+		qp->attrs.state);
+
+	if (qp->srq) {
+		*bad_wr = wr;
+		return -EOPNOTSUPP; /* what else from errno.h? */
+	}
+	/*
+	 * Try to acquire QP state lock. Must be non-blocking
+	 * to accommodate kernel clients needs.
+	 */
+	if (!down_read_trylock(&qp->state_lock)) {
+		*bad_wr = wr;
+		return -ENOTCONN;
+	}
+	if (qp->kernel_verbs == 0) {
+		dprint(DBG_WR|DBG_ON, "(QP%d): user mapped RQ with OFA WR\n",
+			QP_ID(qp));
+		up_read(&qp->state_lock);
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+	if (qp->attrs.state > SIW_QP_STATE_RTS) {
+		up_read(&qp->state_lock);
+		dprint(DBG_ON, " (QP%d): state=%d\n", QP_ID(qp),
+			qp->attrs.state);
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+	while (wr) {
+		u32 idx = qp->rq_put % qp->attrs.rq_size;
+		struct siw_rqe *rqe = &qp->recvq[idx];
+
+		if (rqe->flags) {
+			dprint(DBG_WR, "(QP%d): RQ full\n", QP_ID(qp));
+			rv = -ENOMEM;
+			break;
+		}
+		if (wr->num_sge > qp->attrs.rq_max_sges) {
+			dprint(DBG_WR|DBG_ON, "(QP%d): Num SGE: %d\n",
+				QP_ID(qp), wr->num_sge);
+			rv = -EINVAL;
+			break;
+		}
+		rqe->id = wr->wr_id;
+		rqe->num_sge = wr->num_sge;
+		siw_copy_sgl(wr->sg_list, rqe->sge, wr->num_sge);
+
+		/* make sure RQE is completely written before valid */
+		smp_wmb();
+
+		rqe->flags = SIW_WQE_VALID;
+
+
+		qp->rq_put++;
+		wr = wr->next;
+	}
+	if (rv < 0) {
+		dprint(DBG_WR|DBG_ON, "(QP%d): error=%d\n", QP_ID(qp), rv);
+		*bad_wr = wr;
+	}
+	up_read(&qp->state_lock);
+
+	return rv > 0 ? 0 : rv;
+}
+
+int siw_destroy_cq(struct ib_cq *ofa_cq)
+{
+	struct siw_cq		*cq  = siw_cq_ofa2siw(ofa_cq);
+	struct ib_device	*ofa_dev = ofa_cq->device;
+	struct siw_dev		*sdev = siw_dev_ofa2siw(ofa_dev);
+
+	siw_cq_flush(cq);
+
+	siw_remove_obj(&sdev->idr_lock, &sdev->cq_idr, &cq->hdr);
+	siw_cq_put(cq);
+
+	return 0;
+}
+
+/*
+ * siw_create_cq()
+ *
+ * Create CQ of requested size on given device.
+ *
+ * @ofa_dev:	OFA device contained in siw device
+ * @size:	maximum number of CQE's allowed.
+ * @ib_context: user context.
+ * @udata:	used to provide CQ ID back to user.
+ */
+
+struct ib_cq *siw_create_cq(struct ib_device *ofa_dev,
+			    const struct ib_cq_init_attr *attr,
+			    struct ib_ucontext *ib_context,
+			    struct ib_udata *udata)
+{
+	struct siw_cq			*cq = NULL;
+	struct siw_dev			*sdev = siw_dev_ofa2siw(ofa_dev);
+	struct siw_uresp_create_cq	uresp;
+	int rv, size = attr->cqe;
+
+	if (!ofa_dev) {
+		pr_warn("NO OFA device\n");
+		rv = -ENODEV;
+		goto err_out;
+	}
+	if (atomic_inc_return(&sdev->num_cq) > SIW_MAX_CQ) {
+		dprint(DBG_ON, ": Out of CQ's\n");
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	if (size < 1 || size > SIW_MAX_CQE) {
+		dprint(DBG_ON, ": CQE: %d\n", size);
+		rv = -EINVAL;
+		goto err_out;
+	}
+	cq = kzalloc(sizeof(*cq), GFP_KERNEL);
+	if (!cq) {
+		dprint(DBG_ON, ":  kmalloc\n");
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	size = roundup_pow_of_two(size);
+	cq->ofa_cq.cqe = size;
+	cq->num_cqe = size;
+
+	if (!ib_context) {
+		cq->kernel_verbs = 1;
+		cq->queue = vmalloc(size * sizeof(struct siw_cqe)
+				+ sizeof(struct siw_cq_ctrl));
+	} else
+		cq->queue = vmalloc_user(size * sizeof(struct siw_cqe)
+				+ sizeof(struct siw_cq_ctrl));
+
+	if (cq->queue == NULL) {
+		rv = -ENOMEM;
+		pr_info("siw_create_cq: vmalloc");
+		goto err_out;
+	}
+	if (cq->kernel_verbs)
+		memset(cq->queue, 0, size * sizeof(struct siw_cqe)
+			+ sizeof(struct siw_cq_ctrl));
+
+	rv = siw_cq_add(sdev, cq);
+	if (rv)
+		goto err_out;
+
+	spin_lock_init(&cq->lock);
+
+	cq->notify = &((struct siw_cq_ctrl *)&cq->queue[size])->notify;
+
+	if (!cq->kernel_verbs) {
+		struct siw_ucontext *ctx = siw_ctx_ofa2siw(ib_context);
+
+		uresp.cq_key = siw_insert_uobj(ctx, cq->queue,
+					size * sizeof(struct siw_cqe) +
+					sizeof(struct siw_cq_ctrl));
+
+		if (uresp.cq_key > SIW_MAX_UOBJ_KEY)
+			pr_warn("Preparing mmap CQ failed\n");
+
+		uresp.cq_id = OBJ_ID(cq);
+		uresp.num_cqe = size;
+
+		rv = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
+		if (rv)
+			goto err_out_idr;
+	}
+	return &cq->ofa_cq;
+
+err_out_idr:
+	siw_remove_obj(&sdev->idr_lock, &sdev->cq_idr, &cq->hdr);
+err_out:
+	dprint(DBG_OBJ, ": CQ creation failed %d", rv);
+
+	if (cq && cq->queue)
+		vfree(cq->queue);
+
+	kfree(cq);
+	atomic_dec(&sdev->num_cq);
+
+	return ERR_PTR(rv);
+}
+
+/*
+ * siw_poll_cq()
+ *
+ * Reap CQ entries if available and copy work completion status into
+ * array of WC's provided by caller. Returns number of reaped CQE's.
+ *
+ * @ofa_cq:	OFA CQ contained in siw CQ.
+ * @num_cqe:	Maximum number of CQE's to reap.
+ * @wc:		Array of work completions to be filled by siw.
+ */
+int siw_poll_cq(struct ib_cq *ofa_cq, int num_cqe, struct ib_wc *wc)
+{
+	struct siw_cq		*cq  = siw_cq_ofa2siw(ofa_cq);
+	int			i;
+
+	for (i = 0; i < num_cqe; i++) {
+		if (!(siw_reap_cqe(cq, wc)))
+			break;
+		wc++;
+	}
+	return i;
+}
+
+/*
+ * siw_req_notify_cq()
+ *
+ * Request notification for new CQE's added to that CQ.
+ * Defined flags:
+ * o SIW_CQ_NOTIFY_SOLICITED lets siw trigger a notification
+ *   event if a WQE with notification flag set enters the CQ
+ * o SIW_CQ_NOTIFY_NEXT_COMP lets siw trigger a notification
+ *   event if a WQE enters the CQ.
+ * o IB_CQ_REPORT_MISSED_EVENTS: return value will provide the
+ *   number of not reaped CQE's regardless of its notification
+ *   type and current or new CQ notification settings.
+ *
+ * @ofa_cq:	OFA CQ contained in siw CQ.
+ * @flags:	Requested notification flags.
+ */
+int siw_req_notify_cq(struct ib_cq *ofa_cq, enum ib_cq_notify_flags flags)
+{
+	struct siw_cq	 *cq  = siw_cq_ofa2siw(ofa_cq);
+
+	dprint(DBG_EH|DBG_CQ, "(CQ%d:) flags: 0x%8x\n", OBJ_ID(cq), flags);
+
+	if ((flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED)
+		/* CQ event for next solicited completion */
+		smp_store_mb(*cq->notify, SIW_NOTIFY_SOLICITED);
+	else
+		/* CQ event for any signalled completion */
+		smp_store_mb(*cq->notify, SIW_NOTIFY_ALL);
+
+	if (flags & IB_CQ_REPORT_MISSED_EVENTS)
+		return cq->cq_put - cq->cq_get;
+	return 0;
+}
+
+/*
+ * siw_dereg_mr()
+ *
+ * Release Memory Region.
+ *
+ * TODO: Update function if Memory Windows are supported by siw:
+ *       Is OFED core checking for MW dependencies for current
+ *       MR before calling MR deregistration?.
+ *
+ * @ofa_mr:     OFA MR contained in siw MR.
+ */
+int siw_dereg_mr(struct ib_mr *ofa_mr)
+{
+	struct siw_mr	*mr;
+	struct siw_dev	*sdev = siw_dev_ofa2siw(ofa_mr->device);
+
+	mr = siw_mr_ofa2siw(ofa_mr);
+
+	dprint(DBG_OBJ|DBG_MM, "(MEM%d): Dereg MR, object %p, #ref's: %d\n",
+		mr->mem.hdr.id, mr->mem_obj,
+		refcount_read(&mr->mem.hdr.ref));
+
+	mr->mem.stag_valid = 0;
+
+	siw_pd_put(mr->pd);
+	siw_remove_obj(&sdev->idr_lock, &sdev->mem_idr, &mr->mem.hdr);
+	siw_mem_put(&mr->mem);
+
+	return 0;
+}
+
+static struct siw_mr *siw_create_mr(struct siw_dev *sdev, void *mem_obj,
+				    u64 start, u64 len, int rights)
+{
+	struct siw_mr *mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+
+	if (!mr)
+		return NULL;
+
+	mr->mem.stag_valid = 0;
+
+	if (siw_mem_add(sdev, &mr->mem) < 0) {
+		dprint(DBG_ON, ": siw_mem_add\n");
+		kfree(mr);
+		return NULL;
+	}
+	dprint(DBG_OBJ|DBG_MM, "(MEM%d): New MR, object %p\n",
+		mr->mem.hdr.id, mem_obj);
+
+	mr->ofa_mr.lkey = mr->ofa_mr.rkey = mr->mem.hdr.id << 8;
+
+	mr->mem.va  = start;
+	mr->mem.len = len;
+	mr->mem.mr  = NULL;
+	mr->mem.perms = SIW_MEM_LREAD | /* not selectable in OFA */
+		(rights & IB_ACCESS_REMOTE_READ  ? SIW_MEM_RREAD  : 0) |
+		(rights & IB_ACCESS_LOCAL_WRITE  ? SIW_MEM_LWRITE : 0) |
+		(rights & IB_ACCESS_REMOTE_WRITE ? SIW_MEM_RWRITE : 0);
+
+	mr->mem_obj = mem_obj;
+
+	return mr;
+}
+
+/*
+ * siw_reg_user_mr()
+ *
+ * Register Memory Region.
+ *
+ * @ofa_pd:	OFA PD contained in siw PD.
+ * @start:	starting address of MR (virtual address)
+ * @len:	len of MR
+ * @rnic_va:	not used by siw
+ * @rights:	MR access rights
+ * @udata:	user buffer to communicate STag and Key.
+ */
+struct ib_mr *siw_reg_user_mr(struct ib_pd *ofa_pd, u64 start, u64 len,
+			      u64 rnic_va, int rights, struct ib_udata *udata)
+{
+	struct siw_mr		*mr = NULL;
+	struct siw_pd		*pd = siw_pd_ofa2siw(ofa_pd);
+	struct siw_umem		*umem = NULL;
+	struct siw_ureq_reg_mr	ureq;
+	struct siw_uresp_reg_mr	uresp;
+	struct siw_dev		*sdev = pd->hdr.sdev;
+
+	unsigned long mem_limit = rlimit(RLIMIT_MEMLOCK);
+	int rv;
+
+	dprint(DBG_MM|DBG_OBJ,
+		" start: 0x%016llx, va: 0x%016llx, len: %llu, ctx: %p\n",
+		(unsigned long long)start, (unsigned long long)rnic_va,
+		(unsigned long long)len, ofa_pd->uobject->context);
+
+	if (atomic_inc_return(&sdev->num_mem) > SIW_MAX_MR) {
+		dprint(DBG_ON, ": Out of MRs: %d\n",
+			atomic_read(&sdev->num_mem));
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	if (!len) {
+		rv = -EINVAL;
+		goto err_out;
+	}
+	if (mem_limit != RLIM_INFINITY) {
+		unsigned long num_pages =
+			(PAGE_ALIGN(len + (start & ~PAGE_MASK))) >> PAGE_SHIFT;
+		mem_limit >>= PAGE_SHIFT;
+
+		if (num_pages > mem_limit - current->mm->locked_vm) {
+			dprint(DBG_ON|DBG_MM,
+				": pages req: %lu, limit: %lu, locked: %lu\n",
+				num_pages, mem_limit, current->mm->locked_vm);
+			rv = -ENOMEM;
+			goto err_out;
+		}
+	}
+	umem = siw_umem_get(start, len);
+	if (IS_ERR(umem)) {
+		dprint(DBG_MM, " siw_umem_get:%ld LOCKED:%lu, LIMIT:%lu\n",
+			PTR_ERR(umem), current->mm->locked_vm,
+			current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >>
+			PAGE_SHIFT);
+		rv = PTR_ERR(umem);
+		umem = NULL;
+		goto err_out;
+	}
+	mr = siw_create_mr(sdev, umem, start, len, rights);
+	if (!mr) {
+		rv = -ENOMEM;
+		goto err_out;
+	}
+
+	if (udata) {
+		rv = ib_copy_from_udata(&ureq, udata, sizeof(ureq));
+		if (rv)
+			goto err_out_mr;
+
+		mr->ofa_mr.lkey |= ureq.stag_key;
+		mr->ofa_mr.rkey |= ureq.stag_key; /* XXX ??? */
+		uresp.stag = mr->ofa_mr.lkey;
+
+		rv = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
+		if (rv)
+			goto err_out_mr;
+	}
+	mr->pd = pd;
+	siw_pd_get(pd);
+
+	mr->mem.stag_valid = 1;
+
+	return &mr->ofa_mr;
+
+err_out_mr:
+	siw_remove_obj(&sdev->idr_lock, &sdev->mem_idr, &mr->mem.hdr);
+	kfree(mr);
+
+err_out:
+	if (umem)
+		siw_umem_release(umem);
+
+	atomic_dec(&sdev->num_mem);
+
+	return ERR_PTR(rv);
+}
+
+struct ib_mr *siw_alloc_mr(struct ib_pd *ofa_pd, enum ib_mr_type mr_type,
+			   u32 max_sge)
+{
+	struct siw_mr	*mr;
+	struct siw_pd	*pd = siw_pd_ofa2siw(ofa_pd);
+	struct siw_dev	*sdev = pd->hdr.sdev;
+	struct siw_pbl	*pbl = NULL;
+	int rv;
+
+	if (atomic_inc_return(&sdev->num_mem) > SIW_MAX_MR) {
+		dprint(DBG_ON, ": Out of MRs: %d\n",
+			atomic_read(&sdev->num_mem));
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	if (mr_type != IB_MR_TYPE_MEM_REG) {
+		dprint(DBG_ON, ": Unsupported MR type's: %d\n", mr_type);
+		rv = -EOPNOTSUPP;
+		goto err_out;
+	}
+	if (max_sge > SIW_MAX_SGE_PBL) {
+		dprint(DBG_ON, ": Too many SGE's: %d\n", max_sge);
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	pbl = siw_pbl_alloc(max_sge);
+	if (IS_ERR(pbl)) {
+		rv = PTR_ERR(pbl);
+		dprint(DBG_ON, ": siw_pbl_alloc failed: %d\n", rv);
+		pbl = NULL;
+		goto err_out;
+	}
+	mr = siw_create_mr(sdev, pbl, 0, max_sge * PAGE_SIZE, 0);
+	if (!mr) {
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	mr->mem.is_pbl = 1;
+	mr->pd = pd;
+	siw_pd_get(pd);
+
+	dprint(DBG_MM, " MEM(%d): Created with %u SGEs\n", OBJ_ID(&mr->mem),
+		max_sge);
+
+	return &mr->ofa_mr;
+
+err_out:
+	if (pbl)
+		siw_pbl_free(pbl);
+
+	dprint(DBG_ON, ": failed: %d\n", rv);
+
+	atomic_dec(&sdev->num_mem);
+
+	return ERR_PTR(rv);
+}
+
+/* Just used to count number of pages being mapped */
+static int siw_set_pbl_page(struct ib_mr *ofa_mr, u64 buf_addr)
+{
+	return 0;
+}
+
+int siw_map_mr_sg(struct ib_mr *ofa_mr, struct scatterlist *sl, int num_sle,
+		  unsigned int *sg_off)
+{
+	struct scatterlist *slp;
+	struct siw_mr *mr = siw_mr_ofa2siw(ofa_mr);
+	struct siw_pbl *pbl = mr->pbl;
+	struct siw_pble *pble = pbl->pbe;
+	u64 pbl_size;
+	int i, rv;
+
+	if (!pbl) {
+		dprint(DBG_ON, ": No PBL allocated\n");
+		return -EINVAL;
+	}
+	if (pbl->max_buf < num_sle) {
+		dprint(DBG_ON, ": Too many SG entries: %u : %u\n",
+			mr->pbl->max_buf, num_sle);
+		return -ENOMEM;
+	}
+
+	for_each_sg(sl, slp, num_sle, i) {
+		if (sg_dma_len(slp) == 0) {
+			pr_warn("siw_map_mr_sg: empty sge\n");
+			return -EINVAL;
+		}
+		if (i == 0) {
+			pble->addr = sg_dma_address(slp);
+			pble->size = sg_dma_len(slp);
+			pble->pbl_off = 0;
+			pbl_size = pble->size;
+			pbl->num_buf = 1;
+			continue;
+		}
+		/* Merge PBL entries if adjacent */
+		if (pble->addr + pble->size == sg_dma_address(slp))
+			pble->size += sg_dma_len(slp);
+		else {
+			pble++;
+			pbl->num_buf++;
+			pble->addr = sg_dma_address(slp);
+			pble->size = sg_dma_len(slp);
+			pble->pbl_off = pbl_size;
+		}
+		pbl_size += sg_dma_len(slp);
+
+		dprint(DBG_MM,
+			" MEM(%d): SGE[%d], size %llu, addr %p, total %llu\n",
+			OBJ_ID(&mr->mem), i, pble->size, (void *)pble->addr,
+			pbl_size);
+	}
+	rv = ib_sg_to_pages(ofa_mr, sl, num_sle, sg_off, siw_set_pbl_page);
+	if (rv > 0) {
+		mr->mem.len = ofa_mr->length;
+		mr->mem.va = ofa_mr->iova;
+		dprint(DBG_MM, " MEM(%d): %llu byte, %u SLE into %u entries\n",
+			OBJ_ID(&mr->mem), mr->mem.len, num_sle, pbl->num_buf);
+	}
+	return rv;
+}
+
+/*
+ * siw_get_dma_mr()
+ *
+ * Create a (empty) DMA memory region, where no umem is attached.
+ */
+struct ib_mr *siw_get_dma_mr(struct ib_pd *ofa_pd, int rights)
+{
+	struct siw_mr	*mr;
+	struct siw_pd	*pd = siw_pd_ofa2siw(ofa_pd);
+	struct siw_dev	*sdev = pd->hdr.sdev;
+	int rv;
+
+	if (atomic_inc_return(&sdev->num_mem) > SIW_MAX_MR) {
+		dprint(DBG_ON, ": Out of MRs: %d\n",
+			atomic_read(&sdev->num_mem));
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	mr = siw_create_mr(sdev, NULL, 0, ULONG_MAX, rights);
+	if (!mr) {
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	mr->mem.stag_valid = 1;
+
+	mr->pd = pd;
+	siw_pd_get(pd);
+
+	dprint(DBG_MM, ": MEM(%d): created DMA MR\n", OBJ_ID(&mr->mem));
+
+	return &mr->ofa_mr;
+
+err_out:
+	atomic_dec(&sdev->num_mem);
+
+	return ERR_PTR(rv);
+}
+
+
+/*
+ * siw_create_srq()
+ *
+ * Create Shared Receive Queue of attributes @init_attrs
+ * within protection domain given by @ofa_pd.
+ *
+ * @ofa_pd:	OFA PD contained in siw PD.
+ * @init_attrs:	SRQ init attributes.
+ * @udata:	not used by siw.
+ */
+struct ib_srq *siw_create_srq(struct ib_pd *ofa_pd,
+			      struct ib_srq_init_attr *init_attrs,
+			      struct ib_udata *udata)
+{
+	struct siw_srq		*srq = NULL;
+	struct ib_srq_attr	*attrs = &init_attrs->attr;
+	struct siw_pd		*pd = siw_pd_ofa2siw(ofa_pd);
+	struct siw_dev		*sdev = pd->hdr.sdev;
+
+	int kernel_verbs = ofa_pd->uobject ? 0 : 1;
+	int rv;
+
+	if (atomic_inc_return(&sdev->num_srq) > SIW_MAX_SRQ) {
+		dprint(DBG_ON, " Out of SRQ's\n");
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	if (attrs->max_wr == 0 || attrs->max_wr > SIW_MAX_SRQ_WR ||
+	    attrs->max_sge > SIW_MAX_SGE || attrs->srq_limit > attrs->max_wr) {
+		rv = -EINVAL;
+		goto err_out;
+	}
+
+	srq = kzalloc(sizeof(*srq), GFP_KERNEL);
+	if (!srq) {
+		dprint(DBG_ON, " malloc\n");
+		rv = -ENOMEM;
+		goto err_out;
+	}
+
+	srq->max_sge = attrs->max_sge;
+	srq->num_rqe = roundup_pow_of_two(attrs->max_wr);
+	atomic_set(&srq->space, srq->num_rqe);
+
+	srq->limit = attrs->srq_limit;
+	if (srq->limit)
+		srq->armed = 1;
+
+	if (kernel_verbs)
+		srq->recvq = vmalloc(srq->num_rqe * sizeof(struct siw_rqe));
+	else
+		srq->recvq = vmalloc_user(srq->num_rqe *
+					  sizeof(struct siw_rqe));
+
+	if (srq->recvq == NULL) {
+		rv = -ENOMEM;
+		goto err_out;
+	}
+	if (kernel_verbs) {
+		memset(srq->recvq, 0, srq->num_rqe * sizeof(struct siw_rqe));
+		srq->kernel_verbs = 1;
+	} else if (udata) {
+		struct siw_uresp_create_srq uresp;
+		struct siw_ucontext *ctx;
+
+		memset(&uresp, 0, sizeof(uresp));
+		ctx = siw_ctx_ofa2siw(ofa_pd->uobject->context);
+
+		uresp.num_rqe = srq->num_rqe;
+		uresp.srq_key = siw_insert_uobj(ctx, srq->recvq,
+					srq->num_rqe * sizeof(struct siw_rqe));
+
+		if (uresp.srq_key > SIW_MAX_UOBJ_KEY)
+			pr_warn("Preparing mmap SRQ failed\n");
+
+		rv = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
+		if (rv)
+			goto err_out;
+	}
+	srq->pd	= pd;
+	siw_pd_get(pd);
+
+	spin_lock_init(&srq->lock);
+
+	dprint(DBG_OBJ|DBG_CM, ": new SRQ on device %s\n",
+		sdev->ofa_dev.name);
+	return &srq->ofa_srq;
+
+err_out:
+	if (srq) {
+		if (srq->recvq)
+			vfree(srq->recvq);
+		kfree(srq);
+	}
+	atomic_dec(&sdev->num_srq);
+
+	return ERR_PTR(rv);
+}
+
+/*
+ * siw_modify_srq()
+ *
+ * Modify SRQ. The caller may resize SRQ and/or set/reset notification
+ * limit and (re)arm IB_EVENT_SRQ_LIMIT_REACHED notification.
+ *
+ * NOTE: it is unclear if OFA allows for changing the MAX_SGE
+ * parameter. siw_modify_srq() does not check the attrs->max_sge param.
+ */
+int siw_modify_srq(struct ib_srq *ofa_srq, struct ib_srq_attr *attrs,
+		   enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
+{
+	struct siw_srq	*srq = siw_srq_ofa2siw(ofa_srq);
+	unsigned long	flags;
+	int rv = 0;
+
+	spin_lock_irqsave(&srq->lock, flags);
+
+	if (attr_mask & IB_SRQ_MAX_WR) {
+		/* resize request not yet supported */
+		rv = -EOPNOTSUPP;
+		goto out;
+	}
+	if (attr_mask & IB_SRQ_LIMIT) {
+		if (attrs->srq_limit) {
+			if (unlikely(attrs->srq_limit > srq->num_rqe)) {
+				rv = -EINVAL;
+				goto out;
+			}
+			srq->armed = 1;
+		} else
+			srq->armed = 0;
+
+		srq->limit = attrs->srq_limit;
+	}
+out:
+	spin_unlock_irqrestore(&srq->lock, flags);
+
+	return rv;
+}
+
+/*
+ * siw_query_srq()
+ *
+ * Query SRQ attributes.
+ */
+int siw_query_srq(struct ib_srq *ofa_srq, struct ib_srq_attr *attrs)
+{
+	struct siw_srq	*srq = siw_srq_ofa2siw(ofa_srq);
+	unsigned long	flags;
+
+	spin_lock_irqsave(&srq->lock, flags);
+
+	attrs->max_wr = srq->num_rqe;
+	attrs->max_sge = srq->max_sge;
+	attrs->srq_limit = srq->limit;
+
+	spin_unlock_irqrestore(&srq->lock, flags);
+
+	return 0;
+}
+
+/*
+ * siw_destroy_srq()
+ *
+ * Destroy SRQ.
+ * It is assumed that the SRQ is not referenced by any
+ * QP anymore - the code trusts the OFA environment to keep track
+ * of QP references.
+ */
+int siw_destroy_srq(struct ib_srq *ofa_srq)
+{
+	struct siw_srq		*srq = siw_srq_ofa2siw(ofa_srq);
+	struct siw_dev		*sdev = srq->pd->hdr.sdev;
+
+	dprint(DBG_OBJ, ": Destroy SRQ\n");
+
+	siw_pd_put(srq->pd);
+
+	vfree(srq->recvq);
+	kfree(srq);
+
+	atomic_dec(&sdev->num_srq);
+
+	return 0;
+}
+
+
+/*
+ * siw_post_srq_recv()
+ *
+ * Post a list of receive queue elements to SRQ.
+ * NOTE: The function does not check or lock a certain SRQ state
+ *       during the post operation. The code simply trusts the
+ *       OFA environment.
+ *
+ * @ofa_srq:	OFA SRQ contained in siw SRQ
+ * @wr:		List of R-WR's
+ * @bad_wr:	Updated to failing WR if posting fails.
+ */
+int siw_post_srq_recv(struct ib_srq *ofa_srq, struct ib_recv_wr *wr,
+		      struct ib_recv_wr **bad_wr)
+{
+	struct siw_srq	*srq = siw_srq_ofa2siw(ofa_srq);
+	int rv = 0;
+
+	if (srq->kernel_verbs == 0) {
+		dprint(DBG_WR|DBG_ON, "SRQ %p: mapped SRQ with OFA WR\n", srq);
+		rv = -EINVAL;
+		goto out;
+	}
+	while (wr) {
+		u32 idx = srq->rq_put % srq->num_rqe;
+		struct siw_rqe *rqe = &srq->recvq[idx];
+
+		if (rqe->flags) {
+			dprint(DBG_WR, "SRQ full\n");
+			rv = -ENOMEM;
+			break;
+		}
+		if (wr->num_sge > srq->max_sge) {
+			dprint(DBG_WR|DBG_ON, "Num SGE: %d\n", wr->num_sge);
+			rv = -EINVAL;
+			break;
+		}
+		rqe->id = wr->wr_id;
+		rqe->num_sge = wr->num_sge;
+		siw_copy_sgl(wr->sg_list, rqe->sge, wr->num_sge);
+
+		/* Make sure S-RQE is completely written before valid */
+		smp_wmb();
+
+		rqe->flags = SIW_WQE_VALID;
+
+		srq->rq_put++;
+		wr = wr->next;
+	}
+out:
+	if (unlikely(rv < 0)) {
+		dprint(DBG_WR|DBG_ON, "(SRQ %p): error=%d\n",
+			srq, rv);
+		*bad_wr = wr;
+	}
+	return rv;
+}
diff --git a/drivers/infiniband/sw/siw/siw_verbs.h b/drivers/infiniband/sw/siw/siw_verbs.h
new file mode 100644
index 000000000000..009ecc46a7ab
--- /dev/null
+++ b/drivers/infiniband/sw/siw/siw_verbs.h
@@ -0,0 +1,119 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#ifndef _SIW_VERBS_H
+#define _SIW_VERBS_H
+
+#include <linux/errno.h>
+
+#include <rdma/iw_cm.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_user_verbs.h>
+
+#include "siw.h"
+#include "siw_cm.h"
+
+
+extern struct ib_ucontext *siw_alloc_ucontext(struct ib_device *ibdev,
+					      struct ib_udata *udata);
+extern int siw_dealloc_ucontext(struct ib_ucontext *ucontext);
+extern int siw_query_port(struct ib_device *ibdev, u8 port,
+			  struct ib_port_attr *attr);
+extern int siw_get_port_immutable(struct ib_device *ibdev, u8 port,
+				  struct ib_port_immutable *port_imm);
+extern int siw_query_device(struct ib_device *ibdev,
+			    struct ib_device_attr *attr,
+			    struct ib_udata *udata);
+extern struct ib_cq *siw_create_cq(struct ib_device *ibdev,
+				   const struct ib_cq_init_attr *attr,
+				   struct ib_ucontext *ucontext,
+				   struct ib_udata *udata);
+extern int siw_no_mad(struct ib_device *ofa_dev, int flags, u8 port,
+		      const struct ib_wc *wc, const struct ib_grh *grh,
+		      const struct ib_mad_hdr *in_mad, size_t in_mad_size,
+		      struct ib_mad_hdr *out_mad, size_t *out_mad_size,
+		      u16 *outmad_pkey_index);
+extern int siw_query_port(struct ib_device *ibdev, u8 port,
+			  struct ib_port_attr *attr);
+extern int siw_query_pkey(struct ib_device *ibdev, u8 port,
+			  u16 idx, u16 *pkey);
+extern int siw_query_gid(struct ib_device *ibdev, u8 port, int idx,
+			 union ib_gid *gid);
+extern struct ib_pd *siw_alloc_pd(struct ib_device *ibdev,
+				  struct ib_ucontext *ucontext,
+				  struct ib_udata *udata);
+extern int siw_dealloc_pd(struct ib_pd *pd);
+extern struct ib_qp *siw_create_qp(struct ib_pd *pd,
+				  struct ib_qp_init_attr *attr,
+				   struct ib_udata *udata);
+extern int siw_query_qp(struct ib_qp *ofa_qp, struct ib_qp_attr *qp_attr,
+			int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr);
+extern int siw_verbs_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
+			       int attr_mask, struct ib_udata *udata);
+extern int siw_destroy_qp(struct ib_qp *ibqp);
+extern int siw_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
+			 struct ib_send_wr **bad_wr);
+extern int siw_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
+			    struct ib_recv_wr **bad_wr);
+extern int siw_destroy_cq(struct ib_cq *ibcq);
+extern int siw_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
+extern int siw_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
+extern struct ib_mr *siw_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
+				     u64 rnic_va, int rights,
+				     struct ib_udata *udata);
+extern struct ib_mr *siw_alloc_mr(struct ib_pd *ibpd, enum ib_mr_type mr_type,
+				  u32 max_sge);
+extern struct ib_mr *siw_get_dma_mr(struct ib_pd *ibpd, int rights);
+extern int siw_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sl,
+			 int num_sle, unsigned int *sg_off);
+extern int siw_dereg_mr(struct ib_mr *ibmr);
+extern struct ib_srq *siw_create_srq(struct ib_pd *ibpd,
+				     struct ib_srq_init_attr *attr,
+				     struct ib_udata *udata);
+extern int siw_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
+			  enum ib_srq_attr_mask mask, struct ib_udata *udata);
+extern int siw_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr);
+extern int siw_destroy_srq(struct ib_srq *ibsrq);
+extern int siw_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
+			     struct ib_recv_wr **bad_wr);
+extern int siw_mmap(struct ib_ucontext *ibctx, struct vm_area_struct *vma);
+
+extern struct dma_map_ops siw_dma_generic_ops;
+
+#endif
diff --git a/include/uapi/rdma/siw_user.h b/include/uapi/rdma/siw_user.h
new file mode 100644
index 000000000000..9bf1448d54e7
--- /dev/null
+++ b/include/uapi/rdma/siw_user.h
@@ -0,0 +1,220 @@
+/*
+ * Software iWARP device driver for Linux
+ *
+ * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
+ *
+ * Copyright (c) 2008-2017, IBM Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ *   Redistribution and use in source and binary forms, with or
+ *   without modification, are permitted provided that the following
+ *   conditions are met:
+ *
+ *   - Redistributions of source code must retain the above copyright notice,
+ *     this list of conditions and the following disclaimer.
+ *
+ *   - Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *
+ *   - Neither the name of IBM nor the names of its contributors may be
+ *     used to endorse or promote products derived from this software without
+ *     specific prior written permission.
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
+#ifndef _SIW_USER_H
+#define _SIW_USER_H
+
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+
+/*Common string that is matched to accept the device by the user library*/
+#define SIW_NODE_DESC_COMMON	"Software iWARP stack"
+
+#define SIW_IBDEV_PREFIX "siw_"
+
+#define VERSION_ID_SOFTIWARP	2
+
+#define SIW_MAX_SGE		6
+#define SIW_MAX_UOBJ_KEY	0xffffff
+#define SIW_INVAL_UOBJ_KEY	(SIW_MAX_UOBJ_KEY + 1)
+
+struct siw_uresp_create_cq {
+	uint32_t	cq_id;
+	uint32_t	num_cqe;
+	uint32_t	cq_key;
+};
+
+struct siw_uresp_create_qp {
+	uint32_t	qp_id;
+	uint32_t	num_sqe;
+	uint32_t	num_rqe;
+	uint32_t	sq_key;
+	uint32_t	rq_key;
+};
+
+struct siw_ureq_reg_mr {
+	uint8_t	stag_key;
+	uint8_t	reserved[3];
+};
+
+struct siw_uresp_reg_mr {
+	uint32_t	stag;
+};
+
+struct siw_uresp_create_srq {
+	uint32_t	num_rqe;
+	uint32_t	srq_key;
+};
+
+struct siw_uresp_alloc_ctx {
+	uint32_t	dev_id;
+};
+
+enum siw_opcode {
+	SIW_OP_WRITE		= 0,
+	SIW_OP_READ		= 1,
+	SIW_OP_READ_LOCAL_INV	= 2,
+	SIW_OP_SEND		= 3,
+	SIW_OP_SEND_WITH_IMM	= 4,
+	SIW_OP_SEND_REMOTE_INV	= 5,
+
+	/* Unsupported */
+	SIW_OP_FETCH_AND_ADD	= 6,
+	SIW_OP_COMP_AND_SWAP	= 7,
+
+	SIW_OP_RECEIVE		= 8,
+	/* provider internal SQE */
+	SIW_OP_READ_RESPONSE	= 9,
+	/*
+	 * below opcodes valid for
+	 * in-kernel clients only
+	 */
+	SIW_OP_INVAL_STAG	= 10,
+	SIW_OP_REG_MR		= 11,
+	SIW_NUM_OPCODES		= 12
+};
+
+/* Keep it same as ibv_sge to allow for memcpy */
+struct siw_sge {
+	uint64_t	laddr;
+	uint32_t	length;
+	uint32_t	lkey;
+};
+
+/*
+ * Inline data are kept within the work request itself occupying
+ * the space of sge[1] .. sge[n]. Therefore, inline data cannot be
+ * supported if SIW_MAX_SGE is below 2 elements.
+ */
+#define SIW_MAX_INLINE	(sizeof(struct siw_sge) * (SIW_MAX_SGE - 1))
+
+#if SIW_MAX_SGE < 2
+#error "SIW_MAX_SGE must be at least 2"
+#endif
+
+enum siw_wqe_flags { 
+	SIW_WQE_VALID           = 1,
+	SIW_WQE_INLINE          = (1 << 1),
+	SIW_WQE_SIGNALLED       = (1 << 2),
+	SIW_WQE_SOLICITED       = (1 << 3),
+	SIW_WQE_READ_FENCE	= (1 << 4),
+	SIW_WQE_COMPLETED       = (1 << 5)
+};
+
+/* Send Queue Element */
+struct siw_sqe {
+	uint64_t	id;
+	uint16_t	flags;
+	uint8_t		num_sge;
+	/* Contains enum siw_opcode values */
+	uint8_t		opcode;
+	uint32_t	rkey;
+	union {
+		uint64_t	raddr;
+		uint64_t	ofa_mr;
+	};
+	union {
+		struct siw_sge	sge[SIW_MAX_SGE];
+		uint32_t	access;
+	};
+};
+
+/* Receive Queue Element */
+struct siw_rqe {
+	uint64_t	id;
+	uint16_t	flags;
+	uint8_t		num_sge;
+	/*
+	 * only used by kernel driver,
+	 * ignored if set by user
+	 */
+	uint8_t		opcode;
+	uint32_t	imm_data;
+	struct siw_sge	sge[SIW_MAX_SGE];
+};
+
+enum siw_notify_flags {
+	SIW_NOTIFY_NOT			= (0),
+	SIW_NOTIFY_SOLICITED		= (1 << 0),
+	SIW_NOTIFY_NEXT_COMPLETION	= (1 << 1),
+	SIW_NOTIFY_MISSED_EVENTS	= (1 << 2),
+	SIW_NOTIFY_ALL = SIW_NOTIFY_SOLICITED |
+			SIW_NOTIFY_NEXT_COMPLETION |
+			SIW_NOTIFY_MISSED_EVENTS
+};
+
+enum siw_wc_status {
+	SIW_WC_SUCCESS		= 0,
+	SIW_WC_LOC_LEN_ERR	= 1,
+	SIW_WC_LOC_PROT_ERR	= 2,
+	SIW_WC_LOC_QP_OP_ERR	= 3,
+	SIW_WC_WR_FLUSH_ERR	= 4,
+	SIW_WC_BAD_RESP_ERR	= 5,
+	SIW_WC_LOC_ACCESS_ERR	= 6,
+	SIW_WC_REM_ACCESS_ERR	= 7,
+	SIW_WC_REM_INV_REQ_ERR	= 8,
+	SIW_WC_GENERAL_ERR	= 9,
+	SIW_NUM_WC_STATUS	= 10
+};
+
+struct siw_cqe {
+	uint64_t	id;
+	uint8_t		flags;
+	uint8_t		opcode;
+	uint16_t	status;
+	uint32_t	bytes;
+	uint64_t	imm_data;
+	/* QP number or QP pointer */
+	union { 
+		void	*qp;
+		uint64_t qp_id;
+	};
+};
+
+/*
+ * Shared structure between user and kernel
+ * to control CQ arming.
+ */
+struct siw_cq_ctrl {
+	enum siw_notify_flags	notify;
+};
+
+#endif
-- 
2.13.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
