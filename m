From: <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 12/14] RDMA/ocrdma: Added ABI versioning support.
Date: Mon, 26 Aug 2013 15:27:49 +0530
Message-ID: <8230fec8-a89c-4d2a-b813-0758015ecad1@CMEXHTCAS1.ad.emulex.com>
References: <1377511071-16967-1-git-send-email-bgottumukka@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377511071-16967-1-git-send-email-bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Added ABI versioning support between provider driver
and library.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_abi.h  | 1 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_abi.h b/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
index e5ea9a9..fbac8eb 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
@@ -28,6 +28,7 @@
 #ifndef __OCRDMA_ABI_H__
 #define __OCRDMA_ABI_H__
 
+#define OCRDMA_ABI_VERSION 1
 /* user kernel communication data structures. */
 
 struct ocrdma_alloc_ucontext_resp {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 7d43ba9..56e0049 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -39,6 +39,7 @@
 #include "ocrdma_ah.h"
 #include "be_roce.h"
 #include "ocrdma_hw.h"
+#include "ocrdma_abi.h"
 
 MODULE_VERSION(OCRDMA_ROCE_DEV_VERSION);
 MODULE_DESCRIPTION("Emulex RoCE HCA Driver");
@@ -265,6 +266,7 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 	memcpy(dev->ibdev.node_desc, OCRDMA_NODE_DESC,
 	       sizeof(OCRDMA_NODE_DESC));
 	dev->ibdev.owner = THIS_MODULE;
+	dev->ibdev.uverbs_abi_ver = OCRDMA_ABI_VERSION;
 	dev->ibdev.uverbs_cmd_mask =
 	    OCRDMA_UVERBS(GET_CONTEXT) |
 	    OCRDMA_UVERBS(QUERY_DEVICE) |
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
