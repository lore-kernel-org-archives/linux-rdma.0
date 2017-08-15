From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v2 06/23] RDMA/core: Cleanup device capability enum
Date: Tue, 15 Aug 2017 11:54:35 +0300
Message-ID: <20170815085452.3546-7-leon@kernel.org>
References: <20170815085452.3546-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815085452.3546-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Cleanup patch prior exporting the ib_device_cap_flags
to the user space. In this patch, we are aligning the
indentation, removing IB_DEVICE_INIT_TYPE and IB_DEVICE_RESERVED
fields, because it is not used in the kernel.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 3c9c514bcd7d..4ce188128aa9 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -170,7 +170,7 @@ enum ib_device_cap_flags {
 	IB_DEVICE_UD_AV_PORT_ENFORCE		= (1 << 6),
 	IB_DEVICE_CURR_QP_STATE_MOD		= (1 << 7),
 	IB_DEVICE_SHUTDOWN_PORT			= (1 << 8),
-	IB_DEVICE_INIT_TYPE			= (1 << 9),
+	/* Not in use, former INIT_TYPE		= (1 << 9),*/
 	IB_DEVICE_PORT_ACTIVE_EVENT		= (1 << 10),
 	IB_DEVICE_SYS_IMAGE_GUID		= (1 << 11),
 	IB_DEVICE_RC_RNR_NAK_GEN		= (1 << 12),
@@ -185,7 +185,7 @@ enum ib_device_cap_flags {
 	 * which will always contain a usable lkey.
 	 */
 	IB_DEVICE_LOCAL_DMA_LKEY		= (1 << 15),
-	IB_DEVICE_RESERVED /* old SEND_W_INV */	= (1 << 16),
+	/* Reserved, old SEND_W_INV		= (1 << 16),*/
 	IB_DEVICE_MEM_WINDOW			= (1 << 17),
 	/*
 	 * Devices should set IB_DEVICE_UD_IP_SUM if they support
@@ -220,7 +220,7 @@ enum ib_device_cap_flags {
 	 * of I/O operations with single completion queue managed
 	 * by hardware.
 	 */
-	IB_DEVICE_CROSS_CHANNEL		= (1 << 27),
+	IB_DEVICE_CROSS_CHANNEL			= (1 << 27),
 	IB_DEVICE_MANAGED_FLOW_STEERING		= (1 << 29),
 	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
 	IB_DEVICE_ON_DEMAND_PAGING		= (1ULL << 31),
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
