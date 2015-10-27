From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 1/5] Add ibv_poll_cq_ex verb
Date: Tue, 27 Oct 2015 18:51:36 +0200
Message-ID: <1445964700-13235-2-git-send-email-matanb@mellanox.com>
References: <1445964700-13235-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445964700-13235-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an extension verb for ibv_poll_cq. It allows the user to poll
the cq for specific wc fields only, while allowing to extend the wc.
The verb calls the provider in order to fill the WC with the required
information.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                   |   5 +-
 include/infiniband/compiler.h |  89 +++++++++++++++++
 include/infiniband/verbs.h    | 215 ++++++++++++++++++++++++++++++++++++++++++
 man/ibv_poll_cq_ex.3          | 171 +++++++++++++++++++++++++++++++++
 4 files changed, 478 insertions(+), 2 deletions(-)
 create mode 100644 include/infiniband/compiler.h
 create mode 100644 man/ibv_poll_cq_ex.3

diff --git a/Makefile.am b/Makefile.am
index c85e98a..339bcec 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -44,7 +44,8 @@ libibverbsincludedir = $(includedir)/infiniband
 
 libibverbsinclude_HEADERS = include/infiniband/arch.h include/infiniband/driver.h \
     include/infiniband/kern-abi.h include/infiniband/opcode.h include/infiniband/verbs.h \
-    include/infiniband/sa-kern-abi.h include/infiniband/sa.h include/infiniband/marshall.h
+    include/infiniband/sa-kern-abi.h include/infiniband/sa.h include/infiniband/marshall.h \
+    include/infiniband/compiler.h
 
 man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_rc_pingpong.1 man/ibv_uc_pingpong.1 man/ibv_ud_pingpong.1	\
@@ -63,7 +64,7 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_rate_to_mbps.3  \
     man/ibv_create_qp_ex.3 man/ibv_create_srq_ex.3 man/ibv_open_xrcd.3  \
     man/ibv_get_srq_num.3 man/ibv_open_qp.3 \
-    man/ibv_query_device_ex.3
+    man/ibv_query_device_ex.3 man/ibv_poll_cq_ex.3
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
diff --git a/include/infiniband/compiler.h b/include/infiniband/compiler.h
new file mode 100644
index 0000000..b4bab98
--- /dev/null
+++ b/include/infiniband/compiler.h
@@ -0,0 +1,89 @@
+/*
+ * Copyright (c) 2015 Mellanox, Ltd.  All rights reserved.
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
+#ifndef _COMPILER_
+#define _COMPILER_
+
+#if (__GNUC__ > 3 || (__GNUC__ == 3 && __GNUC_MINOR__ >= 4))
+#define ibv_popcount64		__builtin_popcountll
+#endif
+
+#ifndef __has_builtin
+	#define __has_builtin(x) 0 /* Compatibility with non-clang compilers. */
+#endif
+
+#if __has_builtin(__builtin_popcountll) && !defined(ibv_popcount64)
+	#define ibv_popcount64		__builtin_popcountll
+#endif
+
+#ifndef ibv_popcount64
+/* From FreeBSD:
+ * Copyright (C) 1995, 1996, 1997, and 1998 WIDE Project.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of the project nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE PROJECT AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE PROJECT OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+static inline int ibv_popcount64(uint64_t _x)
+{
+	_x = (_x & 0x5555555555555555) + ((_x & 0xaaaaaaaaaaaaaaaa) >> 1);
+	_x = (_x & 0x3333333333333333) + ((_x & 0xcccccccccccccccc) >> 2);
+	_x = (_x + (_x >> 4)) & 0x0f0f0f0f0f0f0f0f;
+	_x = (_x + (_x >> 8));
+	_x = (_x + (_x >> 16));
+	_x = (_x + (_x >> 32)) & 0x000000ff;
+	return _x;
+}
+#endif
+
+#endif
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index ae22768..479bfca 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -41,6 +41,7 @@
 #include <stddef.h>
 #include <errno.h>
 #include <string.h>
+#include <infiniband/compiler.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -377,6 +378,186 @@ struct ibv_wc {
 	uint8_t			dlid_path_bits;
 };
 
+enum {
+	IBV_WC_FEATURE_FLAGS = IBV_WC_EX_GRH | IBV_WC_EX_IMM
+};
+
+enum {
+	IBV_WC_STANDARD_FLAGS = IBV_WC_EX_WITH_BYTE_LEN		|
+				 IBV_WC_EX_WITH_IMM		|
+				 IBV_WC_EX_WITH_QP_NUM		|
+				 IBV_WC_EX_WITH_SRC_QP		|
+				 IBV_WC_EX_WITH_PKEY_INDEX	|
+				 IBV_WC_EX_WITH_SLID		|
+				 IBV_WC_EX_WITH_SL		|
+				 IBV_WC_EX_WITH_DLID_PATH_BITS
+};
+
+enum ibv_wc_flags_ex {
+	IBV_WC_EX_GRH			= 1 << 0,
+	IBV_WC_EX_IMM			= 1 << 1,
+	IBV_WC_EX_WITH_BYTE_LEN		= 1 << 2,
+	IBV_WC_EX_WITH_IMM		= 1 << 3,
+	IBV_WC_EX_WITH_QP_NUM		= 1 << 4,
+	IBV_WC_EX_WITH_SRC_QP		= 1 << 5,
+	IBV_WC_EX_WITH_PKEY_INDEX	= 1 << 6,
+	IBV_WC_EX_WITH_SLID		= 1 << 7,
+	IBV_WC_EX_WITH_SL		= 1 << 8,
+	IBV_WC_EX_WITH_DLID_PATH_BITS	= 1 << 9,
+};
+
+/* fields order in wc_ex
+ *	uint32_t		byte_len,
+ *	uint32_t		imm_data;	// in network byte order
+ *	uint32_t		qp_num;
+ *	uint32_t		src_qp;
+ *	uint16_t		pkey_index;
+ *	uint16_t		slid;
+ *	uint8_t			sl;
+ *	uint8_t			dlid_path_bits;
+ */
+
+enum {
+	IBV_WC_EX_WITH_64BIT_FIELDS = 0
+};
+
+enum {
+	IBV_WC_EX_WITH_32BIT_FIELDS = IBV_WC_EX_WITH_BYTE_LEN		|
+				      IBV_WC_EX_WITH_IMM		|
+				      IBV_WC_EX_WITH_QP_NUM		|
+				      IBV_WC_EX_WITH_SRC_QP
+};
+
+enum {
+	IBV_WC_EX_WITH_16BIT_FIELDS = IBV_WC_EX_WITH_PKEY_INDEX		|
+				      IBV_WC_EX_WITH_SLID
+};
+
+enum {
+	IBV_WC_EX_WITH_8BIT_FIELDS = IBV_WC_EX_WITH_SL			|
+				     IBV_WC_EX_WITH_DLID_PATH_BITS
+};
+
+struct ibv_wc_ex {
+	uint64_t		wr_id;
+	/* wc_flags is a combination of ibv_wc_flags_ex flags. This dynamically
+	 * defines the valid fields in buffer[0].
+	 */
+	uint64_t		wc_flags;
+	uint32_t		status;
+	uint32_t		opcode;
+	uint32_t		vendor_err;
+	uint32_t		reserved;
+	uint8_t			buffer[0];
+};
+
+static inline size_t ibv_wc_ex_get_offsetof64(uint64_t cq_creation_wc_flags,
+					      enum ibv_wc_flags_ex flag)
+{
+	return ibv_popcount64(cq_creation_wc_flags &
+			      IBV_WC_EX_WITH_64BIT_FIELDS &
+			      (flag - 1)) * sizeof(uint64_t);
+}
+
+static inline size_t ibv_wc_ex_get_offsetof32(uint64_t cq_creation_wc_flags,
+					      enum ibv_wc_flags_ex flag)
+{
+	return ibv_popcount64(cq_creation_wc_flags &
+			      (IBV_WC_EX_WITH_64BIT_FIELDS)) *
+		sizeof(uint64_t) +
+		ibv_popcount64(cq_creation_wc_flags &
+			       IBV_WC_EX_WITH_32BIT_FIELDS &
+			       (flag - 1)) * sizeof(uint32_t);
+}
+
+static inline size_t ibv_wc_ex_get_offsetof16(uint64_t cq_creation_wc_flags,
+					      enum ibv_wc_flags_ex flag)
+{
+	return ibv_popcount64(cq_creation_wc_flags &
+			      (IBV_WC_EX_WITH_64BIT_FIELDS)) *
+		sizeof(uint64_t) +
+		ibv_popcount64(cq_creation_wc_flags &
+			       (IBV_WC_EX_WITH_32BIT_FIELDS)) *
+		sizeof(uint32_t) +
+		ibv_popcount64(cq_creation_wc_flags &
+			       IBV_WC_EX_WITH_16BIT_FIELDS &
+			       (flag - 1)) * sizeof(uint16_t);
+}
+
+static inline size_t ibv_wc_ex_get_offsetof8(uint64_t cq_creation_wc_flags,
+					     enum ibv_wc_flags_ex flag)
+{
+	return ibv_popcount64(cq_creation_wc_flags &
+			      (IBV_WC_EX_WITH_64BIT_FIELDS)) *
+		sizeof(uint64_t) +
+		ibv_popcount64(cq_creation_wc_flags &
+			       (IBV_WC_EX_WITH_32BIT_FIELDS)) *
+		sizeof(uint32_t) +
+		ibv_popcount64(cq_creation_wc_flags &
+			       (IBV_WC_EX_WITH_16BIT_FIELDS)) *
+		sizeof(uint16_t) +
+		ibv_popcount64(cq_creation_wc_flags &
+			       IBV_WC_EX_WITH_8BIT_FIELDS &
+			       (flag - 1)) * sizeof(uint8_t);
+}
+
+static inline uint64_t ibv_wc_ex_get64(const struct ibv_wc_ex *wc_ex,
+				       uint64_t cq_creation_wc_flags,
+				       enum ibv_wc_flags_ex flag)
+{
+	uint64_t *pdata = (uint64_t *)(wc_ex->buffer +
+				       ibv_wc_ex_get_offsetof64(cq_creation_wc_flags,
+								flag));
+
+	return *pdata;
+}
+
+static inline uint32_t ibv_wc_ex_get32(const struct ibv_wc_ex *wc_ex,
+				       uint64_t cq_creation_wc_flags,
+				       enum ibv_wc_flags_ex flag)
+{
+	uint32_t *pdata = (uint32_t *)(wc_ex->buffer +
+				       ibv_wc_ex_get_offsetof32(cq_creation_wc_flags,
+								flag));
+
+	return *pdata;
+}
+
+static inline uint16_t ibv_wc_ex_get16(const struct ibv_wc_ex *wc_ex,
+				       uint64_t cq_creation_wc_flags,
+				       enum ibv_wc_flags_ex flag)
+{
+	uint16_t *pdata = (uint16_t *)(wc_ex->buffer +
+				       ibv_wc_ex_get_offsetof16(cq_creation_wc_flags,
+								flag));
+
+	return *pdata;
+}
+
+static inline uint8_t ibv_wc_ex_get8(const struct ibv_wc_ex *wc_ex,
+				     uint64_t cq_creation_wc_flags,
+				     enum ibv_wc_flags_ex flag)
+{
+	uint8_t *pdata = (uint8_t *)(wc_ex->buffer +
+				     ibv_wc_ex_get_offsetof8(cq_creation_wc_flags,
+							     flag));
+
+	return *pdata;
+}
+
+static inline size_t ibv_wc_ex_get_size(uint64_t flags)
+{
+	return ((ibv_popcount64(flags & IBV_WC_EX_WITH_64BIT_FIELDS) *
+		 sizeof(uint64_t) +
+		 ibv_popcount64(flags & IBV_WC_EX_WITH_32BIT_FIELDS) *
+		 sizeof(uint32_t) +
+		 ibv_popcount64(flags & IBV_WC_EX_WITH_16BIT_FIELDS) *
+		 sizeof(uint16_t) +
+		 ibv_popcount64(flags & IBV_WC_EX_WITH_8BIT_FIELDS) *
+		 sizeof(uint8_t) + (sizeof(uint64_t) - 1)) &
+		~(sizeof(uint64_t) - 1)) + sizeof(struct ibv_wc_ex);
+}
+
 enum ibv_access_flags {
 	IBV_ACCESS_LOCAL_WRITE		= 1,
 	IBV_ACCESS_REMOTE_WRITE		= (1<<1),
@@ -1019,8 +1200,16 @@ enum verbs_context_mask {
 	VERBS_CONTEXT_RESERVED	= 1 << 5
 };
 
+struct ibv_poll_cq_ex_attr {
+	unsigned int	max_entries;
+	uint32_t	comp_mask;
+};
+
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*poll_cq_ex)(struct ibv_cq *ibcq,
+			  struct ibv_wc_ex *wc,
+			  struct ibv_poll_cq_ex_attr *attr);
 	int (*query_device_ex)(struct ibv_context *context,
 			       const struct ibv_query_device_ex_input *input,
 			       struct ibv_device_attr_ex *attr,
@@ -1367,6 +1556,32 @@ ibv_create_srq_ex(struct ibv_context *context,
 }
 
 /**
+ * ibv_poll_cq_ex - Poll a CQ for work completions
+ * @cq:the CQ being polled
+ * @wc:array of at least @max_entries of &struct ibv_wc_ex where completions
+ *   will be returned
+ * @attr: Poll cq attributs
+ *
+ * Poll a CQ for (possibly multiple) completions.  If the return value
+ * is < 0, an error occurred.  If the return value is >= 0, it is the
+ * number of completions returned.  If the return value is
+ * non-negative and strictly less than max_entries, then the CQ was
+ * emptied.
+ */
+
+static inline int ibv_poll_cq_ex(struct ibv_cq *ibcq,
+				 struct ibv_wc_ex *wc,
+				 struct ibv_poll_cq_ex_attr *attr)
+{
+	struct verbs_context *vctx = verbs_get_ctx_op(ibcq->context,
+						      poll_cq_ex);
+	if (!vctx)
+		return ENOSYS;
+
+	return vctx->poll_cq_ex(ibcq, wc, attr);
+}
+
+/**
  * ibv_modify_srq - Modifies the attributes for the specified SRQ.
  * @srq: The SRQ to modify.
  * @srq_attr: On input, specifies the SRQ attributes to modify.  On output,
diff --git a/man/ibv_poll_cq_ex.3 b/man/ibv_poll_cq_ex.3
new file mode 100644
index 0000000..8f336bc
--- /dev/null
+++ b/man/ibv_poll_cq_ex.3
@@ -0,0 +1,171 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_POLL_CQ_EX 3 2006-10-31 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_poll_cq_ex \- poll a completion queue (CQ)
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_poll_cq_ex(struct ibv_cq " "*cq" ", struct ibv_wc_ex " "*wc" ,
+.BI "                   struct ibv_poll_cq_ex_attr " "*attr");
+.fi
+.SH "DESCRIPTION"
+.B ibv_poll_cq_ex()
+polls the CQ
+.I cq
+for work completions according to the pointer argument
+.I attr
+of type struct ibv_poll_cq_ex_attr which is defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_poll_cq_ex_attr {
+.in +8
+unsigned int    max_entries; /* the number of maximum wc_ex entries in array to return */
+uint32_t        comp_mask;   /* which commands extensions are available */
+.in -8
+};
+
+The first work completions (up to max_entries) are returned by this command.
+.I wc\fR is an array of type struct ibv_wc_ex which is also defined in <infiniband/verbs.h>.
+.PP
+.nf
+struct ibv_wc_ex {
+.in +8
+uint64_t                wr_id;       /* ID of the completed Work Request (WR) */
+uint64_t                wc_flags;    /* Combination of ibv_wc_flags_ex flags. Dynamically defines the fields exist in buffer[0] and hence defines the ibv_wc_ex's size. */
+uint32_t                status;      /* Status of the operation */
+uint32_t                opcode;      /* Operation type specified in the completed WR */
+uint32_t                vendor_err;  /* Vendor error syndrome */
+uint32_t                reserved;    /* For future usage
+uint8_t                 buffer[0];   /* Other attributes, as described in wc_flags */
+.in -8
+};
+
+enum ibv_wc_flags_ex {
+.in +8
+IBV_WC_EX_GRH                           = 1 << 0,  /* GRH is present (valid only for UD QPs) */
+IBV_WC_EX_IMM                           = 1 << 1,  /* Action was carried with immediate data */
+IBV_WC_EX_WITH_BYTE_LEN                 = 1 << 2,  /* The returned wc_ex contains byte_len field */
+IBV_WC_EX_WITH_IMM                      = 1 << 3,  /* The returned wc_ex contains imm_data field */
+IBV_WC_EX_WITH_QP_NUM                   = 1 << 4,  /* The returned wc_ex contains qp_num field */
+IBV_WC_EX_WITH_SRC_QP                   = 1 << 5,  /* The returned wc_ex contains src_qp field */
+IBV_WC_EX_WITH_PKEY_INDEX               = 1 << 6,  /* The returned wc_ex contains pkey_index field */
+IBV_WC_EX_WITH_SLID                     = 1 << 7,  /* The returned wc_ex contains slid field */
+IBV_WC_EX_WITH_SL                       = 1 << 8,  /* The returned wc_ex contains sl field */
+IBV_WC_EX_WITH_DLID_PATH_BITS           = 1 << 9,  /* The returned wc_ex contains dlid_path_bits field */
+.in -8
+};
+
+.fi
+wc_flags describes which of the fields in buffer[0] have a valid value. The order of these fields and sizes are always the following:
+.nf
+uint32_t        byte_len,
+uint32_t        imm_data;             /* in network byte order */
+uint32_t        qp_num;
+uint32_t        src_qp;
+uint16_t        pkey_index;
+uint16_t        slid;
+uint8_t         sl;
+uint8_t         dlid_path_bits;
+
+.fi
+Upon creating a CQ using ibv_create_cq_ex, the required wc_flags are given.
+The user is advised to build a custom wc_ex struct that represents those field.
+For example, if 
+.I IBV_WC_EX_WITH_QP_NUM\fR and 
+.I IBV_WC_EX_WITH_DLID_PATH_BITS\fR are given to ibv_create_cq_ex in wc_flags parameter, the user is advised to build the following struct:
+
+.nf
+struct user_custom_wc {
+.in +8
+struct ibv_wc_ex     wc_ex;
+uint32_t             qp_num;
+uint8_t              dlid_path_bits;
+.in -8
+}
+
+.fi
+This allows the user to use ibv_poll_cq_ex with an array of type struct user_custom_cq.
+An alternative is to use the following functions:
+.nf
+static inline size_t ibv_wc_ex_get_offsetof64(uint64_t cq_creation_wc_flags,
+					      enum ibv_wc_flags_ex flag);
+static inline size_t ibv_wc_ex_get_offsetof32(uint64_t cq_creation_wc_flags,
+					      enum ibv_wc_flags_ex flag);
+static inline size_t ibv_wc_ex_get_offsetof16(uint64_t cq_creation_wc_flags,
+					      enum ibv_wc_flags_ex flag);
+static inline size_t ibv_wc_ex_get_offsetof8(uint64_t cq_creation_wc_flags,
+					     enum ibv_wc_flags_ex flag);
+static inline uint64_t ibv_wc_ex_get64(const struct ibv_wc_ex *wc_ex,
+				       uint64_t cq_creation_wc_flags,
+				       enum ibv_wc_flags_ex flag);
+static inline uint32_t ibv_wc_ex_get32(const struct ibv_wc_ex *wc_ex,
+				       uint64_t cq_creation_wc_flags,
+				       enum ibv_wc_flags_ex flag);
+static inline uint16_t ibv_wc_ex_get16(const struct ibv_wc_ex *wc_ex,
+				       uint64_t cq_creation_wc_flags,
+				       enum ibv_wc_flags_ex flag);
+static inline uint8_t ibv_wc_ex_get8(const struct ibv_wc_ex *wc_ex,
+				     uint64_t cq_creation_wc_flags,
+				     enum ibv_wc_flags_ex flag);
+static inline size_t ibv_wc_ex_get_size(uint64_t flags);
+
+.fi
+.PP
+The
+.I ibv_wc_ex_get_offsetxx\fR functions get the wc_flags that were used to create the CQ with and return the offset of the field in the returned WC.
+It's assumed that this flag exists in the returned wc_ex (meaning wc_ex->wc_flags & flag != 0).
+.PP
+.I ibv_wc_ex_getxx\fR functions return the value of this field given in flag. The same assumption as in
+.I ibv_wc_ex_get_offsetxx\fR also holds here.
+xx refers to the size of the required fields in bits. This size must match the sizes described above.
+.PP
+.I ibv_wc_ex_get_size\fR returns the size of a WC which is returned from CQs created with wc_flags given as the flags parameter.
+
+Users could use these functions by defining an array of ibv_wc_ex_get_size bytes:
+
+.nf
+struct ibv_wc_ex     *wc_ex = calloc(num_entries, ibv_wc_ex_get_size(cq_wc_creation_flags));
+
+.fi
+This array could be used for ibv_poll_cq_ex.
+After calling ibv_poll_cq_ex, the fields could be extracted using:
+
+.nf
+if (wc_ex->wc_flags & IBV_WC_EX_WITH_SL) {
+.in +8
+uint8_t sl = ibv_wc_ex_get8(wc_ex, cq_wc_creation_flags, IBV_WC_EX_WITH_SL);
+.in -8
+}
+
+.fi
+Please note that in x86, using SSE4.2 machine with "-mpopcount" compilation flag will cause these functions to run faster.
+
+Fields that aren't available for a completion won't be indicated in wc_ex->wc_flags and their values are undefined.
+
+.PP
+Not all
+.I wc\fR attributes are always valid. If the completion status is other than
+.B IBV_WC_SUCCESS\fR,
+only the following attributes are valid: wr_id, status, qp_num (if its respective wc_flags bit is set), and vendor_err.
+.SH "RETURN VALUE"
+On success, 
+.B ibv_poll_cq_ex()
+returns a non-negative value equal to the number of completions
+found.  On failure, a negative value is returned.
+.SH "NOTES"
+.PP
+Each polled completion is removed from the CQ and cannot be returned to it.
+.PP
+The user should consume work completions at a rate that prevents CQ
+overrun from occurrence.  In case of a CQ overrun, the async event
+.B IBV_EVENT_CQ_ERR
+will be triggered, and the CQ cannot be used.
+.SH "SEE ALSO"
+.BR ibv_poll_cq (3),
+.BR ibv_post_send (3),
+.BR ibv_post_recv (3)
+.SH "AUTHORS"
+.TP
+Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
