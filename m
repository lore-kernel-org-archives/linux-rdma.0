From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 04/32] IB/rxe: Bit mask and lengths declaration for different opcodes
Date: Tue, 22 Sep 2015 10:30:47 +0300
Message-ID: <1442907075-13228-5-git-send-email-kamalh@mellanox.com>
References: <1442907075-13228-1-git-send-email-kamalh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442907075-13228-1-git-send-email-kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

header bit mask definitions and header lengths declaration of the
rxe_opcode_info struct and rxe_wr_opcode_info struct.

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/staging/rxe/rxe_opcode.h | 128 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)
 create mode 100644 drivers/staging/rxe/rxe_opcode.h

diff --git a/drivers/staging/rxe/rxe_opcode.h b/drivers/staging/rxe/rxe_opcode.h
new file mode 100644
index 0000000..3682c16
--- /dev/null
+++ b/drivers/staging/rxe/rxe_opcode.h
@@ -0,0 +1,128 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#ifndef RXE_OPCODE_H
+#define RXE_OPCODE_H
+
+/*
+ * contains header bit mask definitions and header lengths
+ * declaration of the rxe_opcode_info struct and
+ * rxe_wr_opcode_info struct
+ */
+
+enum rxe_wr_mask {
+	WR_INLINE_MASK			= BIT(0),
+	WR_ATOMIC_MASK			= BIT(1),
+	WR_SEND_MASK			= BIT(2),
+	WR_READ_MASK			= BIT(3),
+	WR_WRITE_MASK			= BIT(4),
+	WR_LOCAL_MASK			= BIT(5),
+
+	WR_READ_OR_WRITE_MASK		= WR_READ_MASK | WR_WRITE_MASK,
+	WR_READ_WRITE_OR_SEND_MASK	= WR_READ_OR_WRITE_MASK | WR_SEND_MASK,
+	WR_WRITE_OR_SEND_MASK		= WR_WRITE_MASK | WR_SEND_MASK,
+	WR_ATOMIC_OR_READ_MASK		= WR_ATOMIC_MASK | WR_READ_MASK,
+};
+
+#define WR_MAX_QPT		(8)
+
+struct rxe_wr_opcode_info {
+	char			*name;
+	enum rxe_wr_mask	mask[WR_MAX_QPT];
+};
+
+extern struct rxe_wr_opcode_info rxe_wr_opcode_info[];
+
+enum rxe_hdr_type {
+	RXE_LRH,
+	RXE_GRH,
+	RXE_BTH,
+	RXE_RETH,
+	RXE_AETH,
+	RXE_ATMETH,
+	RXE_ATMACK,
+	RXE_IETH,
+	RXE_RDETH,
+	RXE_DETH,
+	RXE_IMMDT,
+	RXE_PAYLOAD,
+	NUM_HDR_TYPES
+};
+
+enum rxe_hdr_mask {
+	RXE_LRH_MASK		= BIT(RXE_LRH),
+	RXE_GRH_MASK		= BIT(RXE_GRH),
+	RXE_BTH_MASK		= BIT(RXE_BTH),
+	RXE_IMMDT_MASK		= BIT(RXE_IMMDT),
+	RXE_RETH_MASK		= BIT(RXE_RETH),
+	RXE_AETH_MASK		= BIT(RXE_AETH),
+	RXE_ATMETH_MASK		= BIT(RXE_ATMETH),
+	RXE_ATMACK_MASK		= BIT(RXE_ATMACK),
+	RXE_IETH_MASK		= BIT(RXE_IETH),
+	RXE_RDETH_MASK		= BIT(RXE_RDETH),
+	RXE_DETH_MASK		= BIT(RXE_DETH),
+	RXE_PAYLOAD_MASK	= BIT(RXE_PAYLOAD),
+
+	RXE_REQ_MASK		= BIT(NUM_HDR_TYPES + 0),
+	RXE_ACK_MASK		= BIT(NUM_HDR_TYPES + 1),
+	RXE_SEND_MASK		= BIT(NUM_HDR_TYPES + 2),
+	RXE_WRITE_MASK		= BIT(NUM_HDR_TYPES + 3),
+	RXE_READ_MASK		= BIT(NUM_HDR_TYPES + 4),
+	RXE_ATOMIC_MASK		= BIT(NUM_HDR_TYPES + 5),
+
+	RXE_RWR_MASK		= BIT(NUM_HDR_TYPES + 6),
+	RXE_COMP_MASK		= BIT(NUM_HDR_TYPES + 7),
+
+	RXE_START_MASK		= BIT(NUM_HDR_TYPES + 8),
+	RXE_MIDDLE_MASK		= BIT(NUM_HDR_TYPES + 9),
+	RXE_END_MASK		= BIT(NUM_HDR_TYPES + 10),
+
+	RXE_LOOPBACK_MASK	= BIT(NUM_HDR_TYPES + 12),
+
+	RXE_READ_OR_ATOMIC	= (RXE_READ_MASK | RXE_ATOMIC_MASK),
+	RXE_WRITE_OR_SEND	= (RXE_WRITE_MASK | RXE_SEND_MASK),
+};
+
+#define OPCODE_NONE		(-1)
+#define RXE_NUM_OPCODE		256
+
+struct rxe_opcode_info {
+	char			*name;
+	enum rxe_hdr_mask	mask;
+	int			length;
+	int			offset[NUM_HDR_TYPES];
+};
+
+extern struct rxe_opcode_info rxe_opcode[RXE_NUM_OPCODE];
+
+#endif /* RXE_OPCODE_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
