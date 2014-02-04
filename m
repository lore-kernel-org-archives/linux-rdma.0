From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 07/17] RDMA/ocrdma: update version string
Date: Tue, 4 Feb 2014 11:57:00 +0530
Message-ID: <9f0c9b2a-3e31-4b43-8cf2-b151896e6ea7@CMEXHTCAS2.ad.emulex.com>
References: <1391495230-28021-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391495230-28021-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, selvin.xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Update the driver vrsion string and node description string

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h      |    4 +++-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 24fe248..00b3a29 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -39,7 +39,9 @@
 #include <be_roce.h>
 #include "ocrdma_sli.h"
 
-#define OCRDMA_ROCE_DEV_VERSION "1.0.0"
+#define OCRDMA_ROCE_DRV_VERSION "10.2.145.0u"
+
+#define OCRDMA_ROCE_DRV_DESC "Emulex OneConnect RoCE Driver"
 #define OCRDMA_NODE_DESC "Emulex OneConnect RoCE HCA"
 
 #define OCRDMA_MAX_AH 512
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index b000466..b301f64 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -41,8 +41,8 @@
 #include "ocrdma_hw.h"
 #include "ocrdma_abi.h"
 
-MODULE_VERSION(OCRDMA_ROCE_DEV_VERSION);
-MODULE_DESCRIPTION("Emulex RoCE HCA Driver");
+MODULE_VERSION(OCRDMA_ROCE_DRV_VERSION);
+MODULE_DESCRIPTION(OCRDMA_ROCE_DRV_DESC " " OCRDMA_ROCE_DRV_VERSION);
 MODULE_AUTHOR("Emulex Corporation");
 MODULE_LICENSE("GPL");
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
