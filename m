From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH 1/3] IB/core: Align coding style of ib_device_cap_flags structure
Date: Sun, 13 Dec 2015 08:18:34 +0200
Message-ID: <1449987516-31608-2-git-send-email-leon@leon.nu>
References: <1449987516-31608-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449987516-31608-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Modify enum ib_device_cap_flags such that other patches which add new
enum values pass strict checkpatch.pl checks.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 60 ++++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 9a68a19..bcf40ad 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -105,24 +105,24 @@ enum rdma_link_layer {
 };
 
 enum ib_device_cap_flags {
-	IB_DEVICE_RESIZE_MAX_WR		= 1,
-	IB_DEVICE_BAD_PKEY_CNTR		= (1<<1),
-	IB_DEVICE_BAD_QKEY_CNTR		= (1<<2),
-	IB_DEVICE_RAW_MULTI		= (1<<3),
-	IB_DEVICE_AUTO_PATH_MIG		= (1<<4),
-	IB_DEVICE_CHANGE_PHY_PORT	= (1<<5),
-	IB_DEVICE_UD_AV_PORT_ENFORCE	= (1<<6),
-	IB_DEVICE_CURR_QP_STATE_MOD	= (1<<7),
-	IB_DEVICE_SHUTDOWN_PORT		= (1<<8),
-	IB_DEVICE_INIT_TYPE		= (1<<9),
-	IB_DEVICE_PORT_ACTIVE_EVENT	= (1<<10),
-	IB_DEVICE_SYS_IMAGE_GUID	= (1<<11),
-	IB_DEVICE_RC_RNR_NAK_GEN	= (1<<12),
-	IB_DEVICE_SRQ_RESIZE		= (1<<13),
-	IB_DEVICE_N_NOTIFY_CQ		= (1<<14),
-	IB_DEVICE_LOCAL_DMA_LKEY	= (1<<15),
-	IB_DEVICE_RESERVED		= (1<<16), /* old SEND_W_INV */
-	IB_DEVICE_MEM_WINDOW		= (1<<17),
+	IB_DEVICE_RESIZE_MAX_WR		= (1 << 0),
+	IB_DEVICE_BAD_PKEY_CNTR		= (1 << 1),
+	IB_DEVICE_BAD_QKEY_CNTR		= (1 << 2),
+	IB_DEVICE_RAW_MULTI		= (1 << 3),
+	IB_DEVICE_AUTO_PATH_MIG		= (1 << 4),
+	IB_DEVICE_CHANGE_PHY_PORT	= (1 << 5),
+	IB_DEVICE_UD_AV_PORT_ENFORCE	= (1 << 6),
+	IB_DEVICE_CURR_QP_STATE_MOD	= (1 << 7),
+	IB_DEVICE_SHUTDOWN_PORT		= (1 << 8),
+	IB_DEVICE_INIT_TYPE		= (1 << 9),
+	IB_DEVICE_PORT_ACTIVE_EVENT	= (1 << 10),
+	IB_DEVICE_SYS_IMAGE_GUID	= (1 << 11),
+	IB_DEVICE_RC_RNR_NAK_GEN	= (1 << 12),
+	IB_DEVICE_SRQ_RESIZE		= (1 << 13),
+	IB_DEVICE_N_NOTIFY_CQ		= (1 << 14),
+	IB_DEVICE_LOCAL_DMA_LKEY	= (1 << 15),
+	IB_DEVICE_RESERVED		= (1 << 16), /* old SEND_W_INV */
+	IB_DEVICE_MEM_WINDOW		= (1 << 17),
 	/*
 	 * Devices should set IB_DEVICE_UD_IP_SUM if they support
 	 * insertion of UDP and TCP checksum on outgoing UD IPoIB
@@ -130,18 +130,18 @@ enum ib_device_cap_flags {
 	 * incoming messages.  Setting this flag implies that the
 	 * IPoIB driver may set NETIF_F_IP_CSUM for datagram mode.
 	 */
-	IB_DEVICE_UD_IP_CSUM		= (1<<18),
-	IB_DEVICE_UD_TSO		= (1<<19),
-	IB_DEVICE_XRC			= (1<<20),
-	IB_DEVICE_MEM_MGT_EXTENSIONS	= (1<<21),
-	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1<<22),
-	IB_DEVICE_MEM_WINDOW_TYPE_2A	= (1<<23),
-	IB_DEVICE_MEM_WINDOW_TYPE_2B	= (1<<24),
-	IB_DEVICE_RC_IP_CSUM		= (1<<25),
-	IB_DEVICE_RAW_IP_CSUM		= (1<<26),
-	IB_DEVICE_MANAGED_FLOW_STEERING = (1<<29),
-	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30),
-	IB_DEVICE_ON_DEMAND_PAGING	= (1<<31),
+	IB_DEVICE_UD_IP_CSUM		= (1 << 18),
+	IB_DEVICE_UD_TSO		= (1 << 19),
+	IB_DEVICE_XRC			= (1 << 20),
+	IB_DEVICE_MEM_MGT_EXTENSIONS	= (1 << 21),
+	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1 << 22),
+	IB_DEVICE_MEM_WINDOW_TYPE_2A	= (1 << 23),
+	IB_DEVICE_MEM_WINDOW_TYPE_2B	= (1 << 24),
+	IB_DEVICE_RC_IP_CSUM		= (1 << 25),
+	IB_DEVICE_RAW_IP_CSUM		= (1 << 26),
+	IB_DEVICE_MANAGED_FLOW_STEERING = (1 << 29),
+	IB_DEVICE_SIGNATURE_HANDOVER	= (1 << 30),
+	IB_DEVICE_ON_DEMAND_PAGING	= (1 << 31),
 };
 
 enum ib_signature_prot_cap {
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
