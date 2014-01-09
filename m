From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 for-next 1/6] IB/usnic: Update ABI and Version file for UDP support
Date: Thu,  9 Jan 2014 14:48:14 -0800
Message-ID: <1389307699-11545-2-git-send-email-umalhi@cisco.com>
References: <1389307699-11545-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389307699-11545-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Expand the kernel/userspace interface so userspace may push down
a socket file descriptor to usNIC.  Also, bump up the abi and version
numbers.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic.h     |  4 ++--
 drivers/infiniband/hw/usnic/usnic_abi.h | 12 ++++++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic.h b/drivers/infiniband/hw/usnic/usnic.h
index d741c76..5be13d8 100644
--- a/drivers/infiniband/hw/usnic/usnic.h
+++ b/drivers/infiniband/hw/usnic/usnic.h
@@ -23,7 +23,7 @@
 
 #define PCI_DEVICE_ID_CISCO_VIC_USPACE_NIC	0x00cf	/* User space NIC */
 
-#define DRV_VERSION    "1.0.2"
-#define DRV_RELDATE    "September 09, 2013"
+#define DRV_VERSION    "1.0.3"
+#define DRV_RELDATE    "December 19, 2013"
 
 #endif /* USNIC_H_ */
diff --git a/drivers/infiniband/hw/usnic/usnic_abi.h b/drivers/infiniband/hw/usnic/usnic_abi.h
index 7eb49f4..730a371 100644
--- a/drivers/infiniband/hw/usnic/usnic_abi.h
+++ b/drivers/infiniband/hw/usnic/usnic_abi.h
@@ -21,7 +21,7 @@
 #define USNIC_ABI_H
 
 /* ABI between userspace and kernel */
-#define USNIC_UVERBS_ABI_VERSION	2
+#define USNIC_UVERBS_ABI_VERSION	3
 
 #define USNIC_QP_GRP_MAX_WQS		8
 #define USNIC_QP_GRP_MAX_RQS		8
@@ -30,7 +30,8 @@
 enum usnic_transport_type {
 	USNIC_TRANSPORT_UNKNOWN		= 0,
 	USNIC_TRANSPORT_ROCE_CUSTOM	= 1,
-	USNIC_TRANSPORT_MAX		= 2,
+	USNIC_TRANSPORT_IPV4_UDP	= 2,
+	USNIC_TRANSPORT_MAX		= 3,
 };
 
 struct usnic_transport_spec {
@@ -39,9 +40,16 @@ struct usnic_transport_spec {
 		struct {
 			uint16_t	port_num;
 		} usnic_roce;
+		struct {
+			uint32_t	sock_fd;
+		} udp;
 	};
 };
 
+struct usnic_ib_create_qp_cmd {
+	struct usnic_transport_spec	spec;
+};
+
 /*TODO: Future - usnic_modify_qp needs to pass in generic filters */
 struct usnic_ib_create_qp_resp {
 	u32				vfid;
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
