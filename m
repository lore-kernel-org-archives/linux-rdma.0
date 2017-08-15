From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 4/8] RDMA/core: Move port capabilities to UAPI
Date: Tue, 15 Aug 2017 12:14:27 +0300
Message-ID: <20170815091431.12822-5-leon@kernel.org>
References: <20170815091431.12822-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815091431.12822-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Provide to user space applications ability to reuse kernel
port capabilities enum.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h  | 48 ++++++++++++++++++++++++------------------------
 include/uapi/rdma/rdma.h | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 24 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0aced267cc53..a7cd54061f48 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -392,30 +392,30 @@ enum ib_port_state {
 };
 
 enum ib_port_cap_flags {
-	IB_PORT_SM				= 1 <<  1,
-	IB_PORT_NOTICE_SUP			= 1 <<  2,
-	IB_PORT_TRAP_SUP			= 1 <<  3,
-	IB_PORT_OPT_IPD_SUP                     = 1 <<  4,
-	IB_PORT_AUTO_MIGR_SUP			= 1 <<  5,
-	IB_PORT_SL_MAP_SUP			= 1 <<  6,
-	IB_PORT_MKEY_NVRAM			= 1 <<  7,
-	IB_PORT_PKEY_NVRAM			= 1 <<  8,
-	IB_PORT_LED_INFO_SUP			= 1 <<  9,
-	IB_PORT_SM_DISABLED			= 1 << 10,
-	IB_PORT_SYS_IMAGE_GUID_SUP		= 1 << 11,
-	IB_PORT_PKEY_SW_EXT_PORT_TRAP_SUP	= 1 << 12,
-	IB_PORT_EXTENDED_SPEEDS_SUP             = 1 << 14,
-	IB_PORT_CM_SUP				= 1 << 16,
-	IB_PORT_SNMP_TUNNEL_SUP			= 1 << 17,
-	IB_PORT_REINIT_SUP			= 1 << 18,
-	IB_PORT_DEVICE_MGMT_SUP			= 1 << 19,
-	IB_PORT_VENDOR_CLASS_SUP		= 1 << 20,
-	IB_PORT_DR_NOTICE_SUP			= 1 << 21,
-	IB_PORT_CAP_MASK_NOTICE_SUP		= 1 << 22,
-	IB_PORT_BOOT_MGMT_SUP			= 1 << 23,
-	IB_PORT_LINK_LATENCY_SUP		= 1 << 24,
-	IB_PORT_CLIENT_REG_SUP			= 1 << 25,
-	IB_PORT_IP_BASED_GIDS			= 1 << 26,
+	IB_PORT_SM				= RDMA_PORT_SM,
+	IB_PORT_NOTICE_SUP			= RDMA_PORT_NOTICE,
+	IB_PORT_TRAP_SUP			= RDMA_PORT_TRAP,
+	IB_PORT_OPT_IPD_SUP                     = RDMA_PORT_OPT_IPD,
+	IB_PORT_AUTO_MIGR_SUP			= RDMA_PORT_AUTO_MIGR,
+	IB_PORT_SL_MAP_SUP			= RDMA_PORT_SL_MAP,
+	IB_PORT_MKEY_NVRAM			= RDMA_PORT_MKEY_NVRAM,
+	IB_PORT_PKEY_NVRAM			= RDMA_PORT_PKEY_NVRAM,
+	IB_PORT_LED_INFO_SUP			= RDMA_PORT_LED_INFO,
+	IB_PORT_SM_DISABLED			= RDMA_PORT_SM_DISABLED,
+	IB_PORT_SYS_IMAGE_GUID_SUP		= RDMA_PORT_SYS_IMAGE_GUID,
+	IB_PORT_PKEY_SW_EXT_PORT_TRAP_SUP	= RDMA_PORT_PKEY_SW_EXT_PORT_TRAP,
+	IB_PORT_EXTENDED_SPEEDS_SUP             = RDMA_PORT_EXTENDED_SPEEDS,
+	IB_PORT_CM_SUP				= RDMA_PORT_CM,
+	IB_PORT_SNMP_TUNNEL_SUP			= RDMA_PORT_SNMP_TUNNEL,
+	IB_PORT_REINIT_SUP			= RDMA_PORT_REINIT,
+	IB_PORT_DEVICE_MGMT_SUP			= RDMA_PORT_DEVICE_MGMT,
+	IB_PORT_VENDOR_CLASS_SUP		= RDMA_PORT_VENDOR_CLASS,
+	IB_PORT_DR_NOTICE_SUP			= RDMA_PORT_DR_NOTICE,
+	IB_PORT_CAP_MASK_NOTICE_SUP		= RDMA_PORT_CAP_MASK_NOTICE,
+	IB_PORT_BOOT_MGMT_SUP			= RDMA_PORT_BOOT_MGMT,
+	IB_PORT_LINK_LATENCY_SUP		= RDMA_PORT_LINK_LATENCY,
+	IB_PORT_CLIENT_REG_SUP			= RDMA_PORT_CLIENT_REG,
+	IB_PORT_IP_BASED_GIDS			= RDMA_PORT_IP_BASED_GIDS,
 };
 
 enum ib_port_width {
diff --git a/include/uapi/rdma/rdma.h b/include/uapi/rdma/rdma.h
index 75c1baad313b..397796e63a3a 100644
--- a/include/uapi/rdma/rdma.h
+++ b/include/uapi/rdma/rdma.h
@@ -110,4 +110,37 @@ enum rdma_node_type {
 	RDMA_NODE_RNIC		= 4,
 	RDMA_NODE_USNIC_UDP	= 6,
 };
+
+/*
+ * This capability flags are taken from
+ * InfiniBandTM Architecture Specification Volume 1, Revision 1.3
+ * 14.2.5.6 PORTINFO - CapabilityMask
+ *
+ */
+enum rdma_port_cap {
+	RDMA_PORT_SM				= 1 <<  1,
+	RDMA_PORT_NOTICE			= 1 <<  2,
+	RDMA_PORT_TRAP				= 1 <<  3,
+	RDMA_PORT_OPT_IPD			= 1 <<  4,
+	RDMA_PORT_AUTO_MIGR			= 1 <<  5,
+	RDMA_PORT_SL_MAP			= 1 <<  6,
+	RDMA_PORT_MKEY_NVRAM			= 1 <<  7,
+	RDMA_PORT_PKEY_NVRAM			= 1 <<  8,
+	RDMA_PORT_LED_INFO			= 1 <<  9,
+	RDMA_PORT_SM_DISABLED			= 1 << 10,
+	RDMA_PORT_SYS_IMAGE_GUID		= 1 << 11,
+	RDMA_PORT_PKEY_SW_EXT_PORT_TRAP		= 1 << 12,
+	RDMA_PORT_EXTENDED_SPEEDS		= 1 << 14,
+	RDMA_PORT_CM				= 1 << 16,
+	RDMA_PORT_SNMP_TUNNEL			= 1 << 17,
+	RDMA_PORT_REINIT			= 1 << 18,
+	RDMA_PORT_DEVICE_MGMT			= 1 << 19,
+	RDMA_PORT_VENDOR_CLASS			= 1 << 20,
+	RDMA_PORT_DR_NOTICE			= 1 << 21,
+	RDMA_PORT_CAP_MASK_NOTICE		= 1 << 22,
+	RDMA_PORT_BOOT_MGMT			= 1 << 23,
+	RDMA_PORT_LINK_LATENCY			= 1 << 24,
+	RDMA_PORT_CLIENT_REG			= 1 << 25,
+	RDMA_PORT_IP_BASED_GIDS			= 1 << 26,
+};
 #endif /* _RDMA_H */
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
