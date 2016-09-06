From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 03/13] IB/core: Add ib headers for general use
Date: Tue, 06 Sep 2016 04:34:49 -0700
Message-ID: <20160906113440.27413.84782.stgit@scvm10.sc.intel.com>
References: <20160906112758.27413.46860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906112758.27413.46860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add IB headers, defines, and accessors that are identical
in both qib and hfi1 into the core includes.

The accessors for be maintenance of __be64 fields since
alignment is potentially invalid and can differ based on
the presense of the GRH.

{hfi1,qib}_ib_headers will be ib_headers.
{hfi1,qib|_other_headers will be ib_other_headers.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/ib_hdrs.h |  178 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 178 insertions(+), 0 deletions(-)
 create mode 100644 include/rdma/ib_hdrs.h

diff --git a/include/rdma/ib_hdrs.h b/include/rdma/ib_hdrs.h
new file mode 100644
index 0000000..879faf6
--- /dev/null
+++ b/include/rdma/ib_hdrs.h
@@ -0,0 +1,178 @@
+/*
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#ifndef IB_HDRS_H
+#define IB_HDRS_H
+
+#include <linux/types.h>
+#include <asm/unaligned.h>
+#include <rdma/ib_verbs.h>
+
+#define IB_SEQ_NAK	(3 << 29)
+
+/* AETH NAK opcode values */
+#define IB_RNR_NAK                      0x20
+#define IB_NAK_PSN_ERROR                0x60
+#define IB_NAK_INVALID_REQUEST          0x61
+#define IB_NAK_REMOTE_ACCESS_ERROR      0x62
+#define IB_NAK_REMOTE_OPERATIONAL_ERROR 0x63
+#define IB_NAK_INVALID_RD_REQUEST       0x64
+
+#define IB_BTH_REQ_ACK		BIT(31)
+#define IB_BTH_SOLICITED	BIT(23)
+#define IB_BTH_MIG_REQ		BIT(22)
+
+#define IB_GRH_VERSION		6
+#define IB_GRH_VERSION_MASK	0xF
+#define IB_GRH_VERSION_SHIFT	28
+#define IB_GRH_TCLASS_MASK	0xFF
+#define IB_GRH_TCLASS_SHIFT	20
+#define IB_GRH_FLOW_MASK	0xFFFFF
+#define IB_GRH_FLOW_SHIFT	0
+#define IB_GRH_NEXT_HDR		0x1B
+
+struct ib_reth {
+	__be64 vaddr;        /* potentially unaligned */
+	__be32 rkey;
+	__be32 length;
+} __packed;
+
+struct ib_atomic_eth {
+	__be64 vaddr;        /* potentially unaligned */
+	__be32 rkey;
+	__be64 swap_data;    /* potentially unaligned */
+	__be64 compare_data; /* potentially unaligned */
+} __packed;
+
+union ib_ehdrs {
+	struct {
+		__be32 deth[2];
+		__be32 imm_data;
+	} ud;
+	struct {
+		struct ib_reth reth;
+		__be32 imm_data;
+	} rc;
+	struct {
+		__be32 aeth;
+		__be64 atomic_ack_eth; /* potentially unaligned */
+	} at;
+	__be32 imm_data;
+	__be32 aeth;
+	__be32 ieth;
+	struct ib_atomic_eth atomic_eth;
+}  __packed;
+
+struct ib_other_headers {
+	__be32 bth[3];
+	union ib_ehdrs u;
+} __packed;
+
+struct ib_header {
+	__be16 lrh[4];
+	union {
+		struct {
+			struct ib_grh grh;
+			struct ib_other_headers oth;
+		} l;
+		struct ib_other_headers oth;
+	} u;
+} __packed;
+
+/* accessors for unaligned __be64 items */
+
+static u64 ib_u64_get(__be64 *p)
+{
+	return get_unaligned_be64(p);
+}
+
+static void ib_u64_put(u64 val, __be64 *p)
+{
+	put_unaligned_be64(val, p);
+}
+
+static inline u64 get_ib_reth_vaddr(struct ib_reth *reth)
+{
+	return ib_u64_get(&reth->vaddr);
+}
+
+static inline void put_ib_reth_vaddr(u64 val, struct ib_reth *reth)
+{
+	ib_u64_put(val, &reth->vaddr);
+}
+
+static inline u64 get_ib_ateth_vaddr(struct ib_atomic_eth *ateth)
+{
+	return ib_u64_get(&ateth->vaddr);
+}
+
+static inline void put_ib_ateth_vaddr(u64 val, struct ib_atomic_eth *ateth)
+{
+	ib_u64_put(val, &ateth->vaddr);
+}
+
+static inline u64 get_ib_ateth_swap(struct ib_atomic_eth *ateth)
+{
+	return ib_u64_get(&ateth->swap_data);
+}
+
+static inline void put_ib_ateth_swap(u64 val, struct ib_atomic_eth *ateth)
+{
+	ib_u64_put(val, &ateth->swap_data);
+}
+
+static inline u64 get_ib_ateth_compare(struct ib_atomic_eth *ateth)
+{
+	return ib_u64_get(&ateth->compare_data);
+}
+
+static inline void put_ib_ateth_compare(u64 val, struct ib_atomic_eth *ateth)
+{
+	ib_u64_put(val, &ateth->compare_data);
+}
+
+#endif                          /* IB_HDRS_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
