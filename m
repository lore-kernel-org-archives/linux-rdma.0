From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next] IB/usnic: Set userspace/kernel ABI ver to 4
Date: Wed, 15 Jan 2014 17:02:43 -0800
Message-ID: <1389834163-16719-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

usNIC userspace/kernel ABI should be set to 4 instead of 3.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_abi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_abi.h b/drivers/infiniband/hw/usnic/usnic_abi.h
index 014bcfc..04a6622 100644
--- a/drivers/infiniband/hw/usnic/usnic_abi.h
+++ b/drivers/infiniband/hw/usnic/usnic_abi.h
@@ -21,7 +21,7 @@
 #define USNIC_ABI_H
 
 /* ABI between userspace and kernel */
-#define USNIC_UVERBS_ABI_VERSION	3
+#define USNIC_UVERBS_ABI_VERSION	4
 
 #define USNIC_QP_GRP_MAX_WQS		8
 #define USNIC_QP_GRP_MAX_RQS		8
-- 
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
