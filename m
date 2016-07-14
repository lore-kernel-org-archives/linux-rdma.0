From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next] IB/rxe: Substitute ib to rdma in file names
Date: Thu, 14 Jul 2016 11:52:39 +0300
Message-ID: <1468486359-16035-1-git-send-email-monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Change prefix of module name and public inclue file name from ib to
rdma.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 MAINTAINERS                           |   2 +-
 drivers/infiniband/hw/Makefile        |   2 +-
 drivers/infiniband/hw/rxe/Kconfig     |   2 +-
 drivers/infiniband/hw/rxe/Makefile    |   4 +-
 drivers/infiniband/hw/rxe/rxe_verbs.h |   4 +-
 include/uapi/rdma/Kbuild              |   2 +-
 include/uapi/rdma/ib_user_rxe.h       | 144 ----------------------------------
 7 files changed, 8 insertions(+), 152 deletions(-)
 delete mode 100644 include/uapi/rdma/ib_user_rxe.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5328a94..cddafe8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7437,7 +7437,7 @@ S:	Supported
 W:	https://github.com/SoftRoCE/rxe-dev/wiki/rxe-dev:-Home
 Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 F:	drivers/infiniband/hw/rxe/
-F:	include/uapi/rdma/ib_user_rxe.h
+F:	include/uapi/rdma/rdma_user_rxe.h
 
 MEMBARRIER SUPPORT
 M:	Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index 739e5c1..9e696a8 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -9,4 +9,4 @@ obj-$(CONFIG_INFINIBAND_NES)		+= nes/
 obj-$(CONFIG_INFINIBAND_OCRDMA)		+= ocrdma/
 obj-$(CONFIG_INFINIBAND_USNIC)		+= usnic/
 obj-$(CONFIG_INFINIBAND_HFI1)		+= hfi1/
-obj-$(CONFIG_INFINIBAND_RXE)		+= rxe/
+obj-$(CONFIG_RDMA_RXE)			+= rxe/
diff --git a/drivers/infiniband/hw/rxe/Kconfig b/drivers/infiniband/hw/rxe/Kconfig
index a199d0d..1e4e628 100644
--- a/drivers/infiniband/hw/rxe/Kconfig
+++ b/drivers/infiniband/hw/rxe/Kconfig
@@ -1,4 +1,4 @@
-config INFINIBAND_RXE
+config RDMA_RXE
 	tristate "Software RDMA over Ethernet (RoCE) driver"
 	depends on INET && PCI && INFINIBAND
 	depends on NET_UDP_TUNNEL
diff --git a/drivers/infiniband/hw/rxe/Makefile b/drivers/infiniband/hw/rxe/Makefile
index 7cf7774..3b3fb9d 100644
--- a/drivers/infiniband/hw/rxe/Makefile
+++ b/drivers/infiniband/hw/rxe/Makefile
@@ -1,6 +1,6 @@
-obj-$(CONFIG_INFINIBAND_RXE) += ib_rxe.o
+obj-$(CONFIG_RDMA_RXE) += rdma_rxe.o
 
-ib_rxe-y := \
+rdma_rxe-y := \
 	rxe.o \
 	rxe_comp.o \
 	rxe_req.o \
diff --git a/drivers/infiniband/hw/rxe/rxe_verbs.h b/drivers/infiniband/hw/rxe/rxe_verbs.h
index feeb41e..cac1d52 100644
--- a/drivers/infiniband/hw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/hw/rxe/rxe_verbs.h
@@ -35,7 +35,7 @@
 #define RXE_VERBS_H
 
 #include <linux/interrupt.h>
-#include <rdma/ib_user_rxe.h>
+#include <rdma/rdma_user_rxe.h>
 #include "rxe_pool.h"
 #include "rxe_task.h"
 
@@ -372,7 +372,7 @@ struct rxe_port {
 	u32			qp_gsi_index;
 };
 
-/* callbacks from ib_rxe to network interface layer */
+/* callbacks from rdma_rxe to network interface layer */
 struct rxe_ifc_ops {
 	void (*release)(struct rxe_dev *rxe);
 	__be64 (*node_guid)(struct rxe_dev *rxe);
diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
index 3000b72..4edb0f2 100644
--- a/include/uapi/rdma/Kbuild
+++ b/include/uapi/rdma/Kbuild
@@ -6,4 +6,4 @@ header-y += ib_user_verbs.h
 header-y += rdma_netlink.h
 header-y += rdma_user_cm.h
 header-y += hfi/
-header-y += ib_user_rxe.h
+header-y += rdma_user_rxe.h
diff --git a/include/uapi/rdma/ib_user_rxe.h b/include/uapi/rdma/ib_user_rxe.h
deleted file mode 100644
index 19f9615..0000000
--- a/include/uapi/rdma/ib_user_rxe.h
+++ /dev/null
@@ -1,144 +0,0 @@
-/*
- * Copyright (c) 2016 Mellanox Technologies Ltd. All rights reserved.
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
- *	- Redistributions of source code must retain the above
- *	  copyright notice, this list of conditions and the following
- *	  disclaimer.
- *
- *	- Redistributions in binary form must reproduce the above
- *	  copyright notice, this list of conditions and the following
- *	  disclaimer in the documentation and/or other materials
- *	  provided with the distribution.
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
-#ifndef IB_RXE_H
-#define IB_RXE_H
-
-#include <linux/types.h>
-
-union rxe_gid {
-	__u8	raw[16];
-	struct {
-		__be64	subnet_prefix;
-		__be64	interface_id;
-	} global;
-};
-
-struct rxe_global_route {
-	union rxe_gid	dgid;
-	__u32		flow_label;
-	__u8		sgid_index;
-	__u8		hop_limit;
-	__u8		traffic_class;
-};
-
-struct rxe_av {
-	__u8			port_num;
-	__u8			network_type;
-	struct rxe_global_route	grh;
-	union {
-		struct sockaddr		_sockaddr;
-		struct sockaddr_in	_sockaddr_in;
-		struct sockaddr_in6	_sockaddr_in6;
-	} sgid_addr, dgid_addr;
-};
-
-struct rxe_send_wr {
-	__u64			wr_id;
-	__u32			num_sge;
-	__u32			opcode;
-	__u32			send_flags;
-	union {
-		__be32		imm_data;
-		__u32		invalidate_rkey;
-	} ex;
-	union {
-		struct {
-			__u64	remote_addr;
-			__u32	rkey;
-		} rdma;
-		struct {
-			__u64	remote_addr;
-			__u64	compare_add;
-			__u64	swap;
-			__u32	rkey;
-		} atomic;
-		struct {
-			__u32	remote_qpn;
-			__u32	remote_qkey;
-			__u16	pkey_index;
-		} ud;
-		struct {
-			struct ib_mr *mr;
-			__u32        key;
-			int          access;
-		} reg;
-	} wr;
-};
-
-struct rxe_sge {
-	__u64	addr;
-	__u32	length;
-	__u32	lkey;
-};
-
-struct mminfo {
-	__u64			offset;
-	__u32			size;
-	__u32			pad;
-};
-
-struct rxe_dma_info {
-	__u32			length;
-	__u32			resid;
-	__u32			cur_sge;
-	__u32			num_sge;
-	__u32			sge_offset;
-	union {
-		__u8		inline_data[0];
-		struct rxe_sge	sge[0];
-	};
-};
-
-struct rxe_send_wqe {
-	struct rxe_send_wr	wr;
-	struct rxe_av		av;
-	__u32			status;
-	__u32			state;
-	__u64			iova;
-	__u32			mask;
-	__u32			first_psn;
-	__u32			last_psn;
-	__u32			ack_length;
-	__u32			ssn;
-	__u32			has_rd_atomic;
-	struct rxe_dma_info	dma;
-};
-
-struct rxe_recv_wqe {
-	__u64			wr_id;
-	__u32			num_sge;
-	__u32			padding;
-	struct rxe_dma_info	dma;
-};
-
-#endif /* IB_RXE_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
