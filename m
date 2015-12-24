From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 6/6] IB/uapi: expose device capability flags
Date: Thu, 24 Dec 2015 15:39:27 +0100
Message-ID: <1450967967-12479-7-git-send-email-hch@lst.de>
References: <1450967967-12479-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450967967-12479-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Expose the device capability flags which can be queried through uverbs in
the uapi headers.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 include/rdma/ib_verbs.h      | 94 +++++++++++++++-----------------------------
 include/uapi/rdma/ib_verbs.h | 66 +++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+), 62 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 48bfcf5..b8d4113 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -151,68 +151,38 @@ enum rdma_link_layer {
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
-	IB_DEVICE_INIT_TYPE			= (1 << 9),
-	IB_DEVICE_PORT_ACTIVE_EVENT		= (1 << 10),
-	IB_DEVICE_SYS_IMAGE_GUID		= (1 << 11),
-	IB_DEVICE_RC_RNR_NAK_GEN		= (1 << 12),
-	IB_DEVICE_SRQ_RESIZE			= (1 << 13),
-	IB_DEVICE_N_NOTIFY_CQ			= (1 << 14),
-
-	/*
-	 * This device supports a per-device lkey or stag that can be
-	 * used without performing a memory registration for the local
-	 * memory.  Note that ULPs should never check this flag, but
-	 * instead of use the local_dma_lkey flag in the ib_pd structure,
-	 * which will always contain a usable lkey.
-	 */
-	IB_DEVICE_LOCAL_DMA_LKEY		= (1 << 15),
-	IB_DEVICE_RESERVED /* old SEND_W_INV */	= (1 << 16),
-	IB_DEVICE_MEM_WINDOW			= (1 << 17),
-	/*
-	 * Devices should set IB_DEVICE_UD_IP_SUM if they support
-	 * insertion of UDP and TCP checksum on outgoing UD IPoIB
-	 * messages and can verify the validity of checksum for
-	 * incoming messages.  Setting this flag implies that the
-	 * IPoIB driver may set NETIF_F_IP_CSUM for datagram mode.
-	 */
-	IB_DEVICE_UD_IP_CSUM			= (1 << 18),
-	IB_DEVICE_UD_TSO			= (1 << 19),
-	IB_DEVICE_XRC				= (1 << 20),
-
-	/*
-	 * This device supports the IB "base memory management extension",
-	 * which includes support for fast registrations (IB_WR_REG_MR,
-	 * IB_WR_LOCAL_INV and IB_WR_SEND_WITH_INV verbs).  This flag should
-	 * also be set by any iWarp device which must support FRs to comply
-	 * to the iWarp verbs spec.  iWarp devices also support the
-	 * IB_WR_RDMA_READ_WITH_INV verb for RDMA READs that invalidate the
-	 * stag.
-	 */
-	IB_DEVICE_MEM_MGT_EXTENSIONS		= (1 << 21),
-	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK	= (1 << 22),
-	IB_DEVICE_MEM_WINDOW_TYPE_2A		= (1 << 23),
-	IB_DEVICE_MEM_WINDOW_TYPE_2B		= (1 << 24),
-	IB_DEVICE_RC_IP_CSUM			= (1 << 25),
-	IB_DEVICE_RAW_IP_CSUM			= (1 << 26),
-	/*
-	 * Devices should set IB_DEVICE_CROSS_CHANNEL if they
-	 * support execution of WQEs that involve synchronization
-	 * of I/O operations with single completion queue managed
-	 * by hardware.
-	 */
-	IB_DEVICE_CROSS_CHANNEL		= (1 << 27),
-	IB_DEVICE_MANAGED_FLOW_STEERING		= (1 << 29),
-	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
-	IB_DEVICE_ON_DEMAND_PAGING		= (1 << 31),
+	IB_DEVICE_RESIZE_MAX_WR		= IB_UVERBS_DEVICE_RESIZE_MAX_WR,
+	IB_DEVICE_BAD_PKEY_CNTR		= IB_UVERBS_DEVICE_BAD_PKEY_CNTR,
+	IB_DEVICE_BAD_QKEY_CNTR		= IB_UVERBS_DEVICE_BAD_QKEY_CNTR,
+	IB_DEVICE_RAW_MULTI		= IB_UVERBS_DEVICE_RAW_MULTI,
+	IB_DEVICE_AUTO_PATH_MIG		= IB_UVERBS_DEVICE_AUTO_PATH_MIG,
+	IB_DEVICE_CHANGE_PHY_PORT	= IB_UVERBS_DEVICE_CHANGE_PHY_PORT,
+	IB_DEVICE_UD_AV_PORT_ENFORCE	= IB_UVERBS_DEVICE_UD_AV_PORT_ENFORCE,
+	IB_DEVICE_CURR_QP_STATE_MOD	= IB_UVERBS_DEVICE_UD_AV_PORT_ENFORCE,
+	IB_DEVICE_SHUTDOWN_PORT		= IB_UVERBS_DEVICE_SHUTDOWN_PORT,
+	IB_DEVICE_INIT_TYPE		= IB_UVERBS_DEVICE_INIT_TYPE,
+	IB_DEVICE_PORT_ACTIVE_EVENT	= IB_UVERBS_DEVICE_PORT_ACTIVE_EVENT,
+	IB_DEVICE_SYS_IMAGE_GUID	= IB_UVERBS_DEVICE_SYS_IMAGE_GUID,
+	IB_DEVICE_RC_RNR_NAK_GEN	= IB_UVERBS_DEVICE_RC_RNR_NAK_GEN,
+	IB_DEVICE_SRQ_RESIZE		= IB_UVERBS_DEVICE_SRQ_RESIZE,
+	IB_DEVICE_N_NOTIFY_CQ		= IB_UVERBS_DEVICE_N_NOTIFY_CQ,
+	IB_DEVICE_LOCAL_DMA_LKEY	= IB_UVERBS_DEVICE_LOCAL_DMA_LKEY,
+	IB_DEVICE_MEM_WINDOW		= IB_UVERBS_DEVICE_MEM_WINDOW,
+	IB_DEVICE_UD_IP_CSUM		= IB_UVERBS_DEVICE_UD_IP_CSUM,
+	IB_DEVICE_UD_TSO		= IB_UVERBS_DEVICE_UD_TSO,
+	IB_DEVICE_XRC			= IB_UVERBS_DEVICE_XRC,
+	IB_DEVICE_MEM_MGT_EXTENSIONS	= IB_UVERBS_DEVICE_MEM_MGT_EXTENSIONS,
+	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK =
+			IB_UVERBS_DEVICE_BLOCK_MULTICAST_LOOPBACK,
+	IB_DEVICE_MEM_WINDOW_TYPE_2A	= IB_UVERBS_DEVICE_MEM_WINDOW_TYPE_2A,
+	IB_DEVICE_MEM_WINDOW_TYPE_2B	= IB_UVERBS_DEVICE_MEM_WINDOW_TYPE_2B,
+	IB_DEVICE_RC_IP_CSUM		= IB_UVERBS_DEVICE_RC_IP_CSUM,
+	IB_DEVICE_RAW_IP_CSUM		= IB_UVERBS_DEVICE_RAW_IP_CSUM,
+	IB_DEVICE_CROSS_CHANNEL		= IB_UVERBS_DEVICE_CROSS_CHANNEL,
+	IB_DEVICE_MANAGED_FLOW_STEERING	=
+			IB_UVERBS_DEVICE_MANAGED_FLOW_STEERING,
+	IB_DEVICE_SIGNATURE_HANDOVER	= IB_UVERBS_DEVICE_SIGNATURE_HANDOVER,
+	IB_DEVICE_ON_DEMAND_PAGING	= IB_UVERBS_DEVICE_ON_DEMAND_PAGING,
 };
 
 enum ib_signature_prot_cap {
diff --git a/include/uapi/rdma/ib_verbs.h b/include/uapi/rdma/ib_verbs.h
index fbadb29..8bba4c4 100644
--- a/include/uapi/rdma/ib_verbs.h
+++ b/include/uapi/rdma/ib_verbs.h
@@ -7,6 +7,72 @@
  * having to pull that into the kernel-internal internal ib_verbs.h
  */
 
+enum ib_uverbs_device_cap_flags {
+	IB_UVERBS_DEVICE_RESIZE_MAX_WR		= (1 << 0),
+	IB_UVERBS_DEVICE_BAD_PKEY_CNTR		= (1 << 1),
+	IB_UVERBS_DEVICE_BAD_QKEY_CNTR		= (1 << 2),
+	IB_UVERBS_DEVICE_RAW_MULTI		= (1 << 3),
+	IB_UVERBS_DEVICE_AUTO_PATH_MIG		= (1 << 4),
+	IB_UVERBS_DEVICE_CHANGE_PHY_PORT	= (1 << 5),
+	IB_UVERBS_DEVICE_UD_AV_PORT_ENFORCE	= (1 << 6),
+	IB_UVERBS_DEVICE_CURR_QP_STATE_MOD	= (1 << 7),
+	IB_UVERBS_DEVICE_SHUTDOWN_PORT		= (1 << 8),
+	IB_UVERBS_DEVICE_INIT_TYPE		= (1 << 9),
+	IB_UVERBS_DEVICE_PORT_ACTIVE_EVENT	= (1 << 10),
+	IB_UVERBS_DEVICE_SYS_IMAGE_GUID		= (1 << 11),
+	IB_UVERBS_DEVICE_RC_RNR_NAK_GEN		= (1 << 12),
+	IB_UVERBS_DEVICE_SRQ_RESIZE		= (1 << 13),
+	IB_UVERBS_DEVICE_N_NOTIFY_CQ		= (1 << 14),
+
+	/*
+	 * This device supports a per-device lkey or stag that can be
+	 * used without performing a memory registration for the local
+	 * memory.  Note that ULPs should never check this flag, but
+	 * instead of use the local_dma_lkey flag in the ib_pd structure,
+	 * which will always contain a usable lkey.
+	 */
+	IB_UVERBS_DEVICE_LOCAL_DMA_LKEY		= (1 << 15),
+	IB_UVERBS_DEVICE_MEM_WINDOW		= (1 << 17),
+
+	/*
+	 * Devices should set IB_UVERBS_DEVICE_UD_IP_SUM if they support
+	 * insertion of UDP and TCP checksum on outgoing UD IPoIB
+	 * messages and can verify the validity of checksum for
+	 * incoming messages.  Setting this flag implies that the
+	 * IPoIB driver may set NETIF_F_IP_CSUM for datagram mode.
+	 */
+	IB_UVERBS_DEVICE_UD_IP_CSUM		= (1 << 18),
+	IB_UVERBS_DEVICE_UD_TSO			= (1 << 19),
+	IB_UVERBS_DEVICE_XRC			= (1 << 20),
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
+	IB_UVERBS_DEVICE_MEM_MGT_EXTENSIONS	= (1 << 21),
+	IB_UVERBS_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1 << 22),
+	IB_UVERBS_DEVICE_MEM_WINDOW_TYPE_2A	= (1 << 23),
+	IB_UVERBS_DEVICE_MEM_WINDOW_TYPE_2B	= (1 << 24),
+	IB_UVERBS_DEVICE_RC_IP_CSUM		= (1 << 25),
+	IB_UVERBS_DEVICE_RAW_IP_CSUM		= (1 << 26),
+
+	/*
+	 * Devices should set IB_UVERBS_DEVICE_CROSS_CHANNEL if they
+	 * support execution of WQEs that involve synchronization
+	 * of I/O operations with single completion queue managed
+	 * by hardware.
+	 */
+	IB_UVERBS_DEVICE_CROSS_CHANNEL		= (1 << 27),
+	IB_UVERBS_DEVICE_MANAGED_FLOW_STEERING	= (1 << 29),
+	IB_UVERBS_DEVICE_SIGNATURE_HANDOVER	= (1 << 30),
+	IB_UVERBS_DEVICE_ON_DEMAND_PAGING	= (1 << 31),
+};
+
 enum ib_uverbs_wr_opcode {
 	IB_UVERBS_WR_RDMA_WRITE			= 0,
 	IB_UVERBS_WR_RDMA_WRITE_WITH_IMM	= 1,
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
