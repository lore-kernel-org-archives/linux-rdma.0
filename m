From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 2/8] RDMA/core: Export device capabilities flags
Date: Tue, 15 Aug 2017 12:14:25 +0300
Message-ID: <20170815091431.12822-3-leon@kernel.org>
References: <20170815091431.12822-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815091431.12822-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Provide to the user space application the ability
to understand device capabilities.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h           |  68 ++++++++++++------------
 include/uapi/rdma/ib_user_verbs.h |   1 +
 include/uapi/rdma/rdma.h          | 106 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 140 insertions(+), 35 deletions(-)
 create mode 100644 include/uapi/rdma/rdma.h

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 80ede01d2237..bfedcda04ef7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -157,22 +157,21 @@ enum rdma_link_layer {
 };
 
 enum ib_device_cap_flags {
-	IB_DEVICE_RESIZE_MAX_WR			= (1 << 0),
-	IB_DEVICE_BAD_PKEY_CNTR			= (1 << 1),
-	IB_DEVICE_BAD_QKEY_CNTR			= (1 << 2),
-	IB_DEVICE_RAW_MULTI			= (1 << 3),
-	IB_DEVICE_AUTO_PATH_MIG			= (1 << 4),
-	IB_DEVICE_CHANGE_PHY_PORT		= (1 << 5),
-	IB_DEVICE_UD_AV_PORT_ENFORCE		= (1 << 6),
-	IB_DEVICE_CURR_QP_STATE_MOD		= (1 << 7),
-	IB_DEVICE_SHUTDOWN_PORT			= (1 << 8),
+	IB_DEVICE_RESIZE_MAX_WR			= RDMA_DEV_RESIZE_MAX_WR,
+	IB_DEVICE_BAD_PKEY_CNTR			= RDMA_DEV_BAD_PKEY_CNTR,
+	IB_DEVICE_BAD_QKEY_CNTR			= RDMA_DEV_BAD_QKEY_CNTR,
+	IB_DEVICE_RAW_MULTI			= RDMA_DEV_RAW_MULTI,
+	IB_DEVICE_AUTO_PATH_MIG			= RDMA_DEV_AUTO_PATH_MIG,
+	IB_DEVICE_CHANGE_PHY_PORT		= RDMA_DEV_CHANGE_PHY_PORT,
+	IB_DEVICE_UD_AV_PORT_ENFORCE		= RDMA_DEV_UD_AV_PORT_ENFORCE,
+	IB_DEVICE_CURR_QP_STATE_MOD		= RDMA_DEV_CURR_QP_STATE_MOD,
+	IB_DEVICE_SHUTDOWN_PORT			= RDMA_DEV_SHUTDOWN_PORT,
 	/* Not in use, former INIT_TYPE		= (1 << 9),*/
-	IB_DEVICE_PORT_ACTIVE_EVENT		= (1 << 10),
-	IB_DEVICE_SYS_IMAGE_GUID		= (1 << 11),
-	IB_DEVICE_RC_RNR_NAK_GEN		= (1 << 12),
-	IB_DEVICE_SRQ_RESIZE			= (1 << 13),
-	IB_DEVICE_N_NOTIFY_CQ			= (1 << 14),
-
+	IB_DEVICE_PORT_ACTIVE_EVENT		= RDMA_DEV_PORT_ACTIVE_EVENT,
+	IB_DEVICE_SYS_IMAGE_GUID		= RDMA_DEV_SYS_IMAGE_GUID,
+	IB_DEVICE_RC_RNR_NAK_GEN		= RDMA_DEV_RC_RNR_NAK_GEN,
+	IB_DEVICE_SRQ_RESIZE			= RDMA_DEV_SRQ_RESIZE,
+	IB_DEVICE_N_NOTIFY_CQ			= RDMA_DEV_N_NOTIFY_CQ,
 	/*
 	 * This device supports a per-device lkey or stag that can be
 	 * used without performing a memory registration for the local
@@ -180,9 +179,9 @@ enum ib_device_cap_flags {
 	 * instead of use the local_dma_lkey flag in the ib_pd structure,
 	 * which will always contain a usable lkey.
 	 */
-	IB_DEVICE_LOCAL_DMA_LKEY		= (1 << 15),
+	IB_DEVICE_LOCAL_DMA_LKEY		= RDMA_DEV_LOCAL_DMA_LKEY,
 	/* Reserved, old SEND_W_INV		= (1 << 16),*/
-	IB_DEVICE_MEM_WINDOW			= (1 << 17),
+	IB_DEVICE_MEM_WINDOW			= RDMA_DEV_MEM_WINDOW,
 	/*
 	 * Devices should set IB_DEVICE_UD_IP_SUM if they support
 	 * insertion of UDP and TCP checksum on outgoing UD IPoIB
@@ -190,10 +189,9 @@ enum ib_device_cap_flags {
 	 * incoming messages.  Setting this flag implies that the
 	 * IPoIB driver may set NETIF_F_IP_CSUM for datagram mode.
 	 */
-	IB_DEVICE_UD_IP_CSUM			= (1 << 18),
-	IB_DEVICE_UD_TSO			= (1 << 19),
-	IB_DEVICE_XRC				= (1 << 20),
-
+	IB_DEVICE_UD_IP_CSUM			= RDMA_DEV_UD_IP_CSUM,
+	IB_DEVICE_UD_TSO			= RDMA_DEV_UD_TSO,
+	IB_DEVICE_XRC				= RDMA_DEV_XRC,
 	/*
 	 * This device supports the IB "base memory management extension",
 	 * which includes support for fast registrations (IB_WR_REG_MR,
@@ -203,28 +201,28 @@ enum ib_device_cap_flags {
 	 * IB_WR_RDMA_READ_WITH_INV verb for RDMA READs that invalidate the
 	 * stag.
 	 */
-	IB_DEVICE_MEM_MGT_EXTENSIONS		= (1 << 21),
-	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK	= (1 << 22),
-	IB_DEVICE_MEM_WINDOW_TYPE_2A		= (1 << 23),
-	IB_DEVICE_MEM_WINDOW_TYPE_2B		= (1 << 24),
-	IB_DEVICE_RC_IP_CSUM			= (1 << 25),
+	IB_DEVICE_MEM_MGT_EXTENSIONS		= RDMA_DEV_MEM_MGT_EXTENSIONS,
+	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK	= RDMA_DEV_BLOCK_MULTICAST_LOOPBACK,
+	IB_DEVICE_MEM_WINDOW_TYPE_2A		= RDMA_DEV_MEM_WINDOW_TYPE_2A,
+	IB_DEVICE_MEM_WINDOW_TYPE_2B		= RDMA_DEV_MEM_WINDOW_TYPE_2B,
+	IB_DEVICE_RC_IP_CSUM			= RDMA_DEV_RC_IP_CSUM,
 	/* Deprecated. Please use IB_RAW_PACKET_CAP_IP_CSUM. */
-	IB_DEVICE_RAW_IP_CSUM			= (1 << 26),
+	IB_DEVICE_RAW_IP_CSUM			= RDMA_DEV_RAW_IP_CSUM,
 	/*
 	 * Devices should set IB_DEVICE_CROSS_CHANNEL if they
 	 * support execution of WQEs that involve synchronization
 	 * of I/O operations with single completion queue managed
 	 * by hardware.
 	 */
-	IB_DEVICE_CROSS_CHANNEL			= (1 << 27),
-	IB_DEVICE_MANAGED_FLOW_STEERING		= (1 << 29),
-	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
-	IB_DEVICE_ON_DEMAND_PAGING		= (1ULL << 31),
-	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
-	IB_DEVICE_VIRTUAL_FUNCTION		= (1ULL << 33),
+	IB_DEVICE_CROSS_CHANNEL			= RDMA_DEV_CROSS_CHANNEL,
+	IB_DEVICE_MANAGED_FLOW_STEERING		= RDMA_DEV_MANAGED_FLOW_STEERING,
+	IB_DEVICE_SIGNATURE_HANDOVER		= RDMA_DEV_SIGNATURE_HANDOVER,
+	IB_DEVICE_ON_DEMAND_PAGING		= RDMA_DEV_ON_DEMAND_PAGING,
+	IB_DEVICE_SG_GAPS_REG			= RDMA_DEV_SG_GAPS_REG,
+	IB_DEVICE_VIRTUAL_FUNCTION		= RDMA_DEV_VIRTUAL_FUNCTION,
 	/* Deprecated. Please use IB_RAW_PACKET_CAP_SCATTER_FCS. */
-	IB_DEVICE_RAW_SCATTER_FCS		= (1ULL << 34),
-	IB_DEVICE_RDMA_NETDEV_OPA_VNIC		= (1ULL << 35),
+	IB_DEVICE_RAW_SCATTER_FCS		= RDMA_DEV_RAW_SCATTER_FCS,
+	IB_DEVICE_RDMA_NETDEV_OPA_VNIC		= RDMA_DEV_RDMA_NETDEV_OPA_VNIC,
 };
 
 enum ib_signature_prot_cap {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 9a0b6479fe0c..803106ffa93c 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -37,6 +37,7 @@
 #define IB_USER_VERBS_H
 
 #include <linux/types.h>
+#include <rdma/rdma.h>
 
 /*
  * Increment this value if any changes that break userspace ABI
diff --git a/include/uapi/rdma/rdma.h b/include/uapi/rdma/rdma.h
new file mode 100644
index 000000000000..dcdf61474118
--- /dev/null
+++ b/include/uapi/rdma/rdma.h
@@ -0,0 +1,106 @@
+/*
+ * Copyright (c) 2017 Mellanox Technologies.  All rights reserved.
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
+#ifndef _RDMA_H
+#define _RDMA_H
+
+enum rdma_dev_cap {
+	RDMA_DEV_RESIZE_MAX_WR			= (1 << 0),
+	RDMA_DEV_BAD_PKEY_CNTR			= (1 << 1),
+	RDMA_DEV_BAD_QKEY_CNTR			= (1 << 2),
+	RDMA_DEV_RAW_MULTI			= (1 << 3),
+	RDMA_DEV_AUTO_PATH_MIG			= (1 << 4),
+	RDMA_DEV_CHANGE_PHY_PORT		= (1 << 5),
+	RDMA_DEV_UD_AV_PORT_ENFORCE		= (1 << 6),
+	RDMA_DEV_CURR_QP_STATE_MOD		= (1 << 7),
+	RDMA_DEV_SHUTDOWN_PORT			= (1 << 8),
+	/* Not in use, former INIT_TYPE		= (1 << 9),*/
+	RDMA_DEV_PORT_ACTIVE_EVENT		= (1 << 10),
+	RDMA_DEV_SYS_IMAGE_GUID			= (1 << 11),
+	RDMA_DEV_RC_RNR_NAK_GEN			= (1 << 12),
+	RDMA_DEV_SRQ_RESIZE			= (1 << 13),
+	RDMA_DEV_N_NOTIFY_CQ			= (1 << 14),
+
+	/*
+	 * This device supports a per-device lkey or stag that can be
+	 * used without performing a memory registration for the local
+	 * memory.  Note that ULPs should never check this flag, but
+	 * instead of use the local_dma_lkey flag in the ib_pd structure,
+	 * which will always contain a usable lkey.
+	 */
+	RDMA_DEV_LOCAL_DMA_LKEY			= (1 << 15),
+	/* Reserved, old SEND_W_INV		= (1 << 16),*/
+	RDMA_DEV_MEM_WINDOW			= (1 << 17),
+	/*
+	 * Devices should set RDMA_DEV_UD_IP_SUM if they support
+	 * insertion of UDP and TCP checksum on outgoing UD IPoIB
+	 * messages and can verify the validity of checksum for
+	 * incoming messages.  Setting this flag implies that the
+	 * IPoIB driver may set NETIF_F_IP_CSUM for datagram mode.
+	 */
+	RDMA_DEV_UD_IP_CSUM			= (1 << 18),
+	RDMA_DEV_UD_TSO				= (1 << 19),
+	RDMA_DEV_XRC				= (1 << 20),
+
+	/*
+	 * This device supports the IB "base memory management extension",
+	 * which includes support for fast registrations (IB_WR_REG_MR,
+	 * IB_WR_LOCAL_INV and IB_WR_SEND_WITH_INV verbs).  This flag should
+	 * also be set by any iWarp device which must support FRs to comply
+	 * to the iWarp verbs spec.  iWarp devices also support the
+	 * IB_WR_RDMA_READ_WITH_INV verb for RDMA READs that invalidate the
+	 * stag.
+	 */
+	RDMA_DEV_MEM_MGT_EXTENSIONS		= (1 << 21),
+	RDMA_DEV_BLOCK_MULTICAST_LOOPBACK	= (1 << 22),
+	RDMA_DEV_MEM_WINDOW_TYPE_2A		= (1 << 23),
+	RDMA_DEV_MEM_WINDOW_TYPE_2B		= (1 << 24),
+	RDMA_DEV_RC_IP_CSUM			= (1 << 25),
+	/* Deprecated. Please use IB_RAW_PACKET_CAP_IP_CSUM. */
+	RDMA_DEV_RAW_IP_CSUM			= (1 << 26),
+	/*
+	 * Devices should set RDMA_DEV_CROSS_CHANNEL if they
+	 * support execution of WQEs that involve synchronization
+	 * of I/O operations with single completion queue managed
+	 * by hardware.
+	 */
+	RDMA_DEV_CROSS_CHANNEL			= (1 << 27),
+	RDMA_DEV_MANAGED_FLOW_STEERING		= (1 << 29),
+	RDMA_DEV_SIGNATURE_HANDOVER		= (1 << 30),
+	RDMA_DEV_ON_DEMAND_PAGING		= (1ULL << 31),
+	RDMA_DEV_SG_GAPS_REG			= (1ULL << 32),
+	RDMA_DEV_VIRTUAL_FUNCTION		= (1ULL << 33),
+	/* Deprecated. Please use IB_RAW_PACKET_CAP_SCATTER_FCS. */
+	RDMA_DEV_RAW_SCATTER_FCS		= (1ULL << 34),
+	RDMA_DEV_RDMA_NETDEV_OPA_VNIC		= (1ULL << 35),
+};
+#endif /* _RDMA_H */
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
