From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH V2 for-4.1 9/9] RDMA/ocrdma: Update ocrdma version number
Date: Tue, 19 May 2015 11:32:40 +0530
Message-ID: <1432015360-15447-10-git-send-email-selvin.xavier@avagotech.com>
References: <1432015360-15447-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432015360-15447-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Updating the driver version to 10.6.0.0

Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index ee9e335..b396344 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -40,7 +40,7 @@
 #include <be_roce.h>
 #include "ocrdma_sli.h"
 
-#define OCRDMA_ROCE_DRV_VERSION "10.4.205.0u"
+#define OCRDMA_ROCE_DRV_VERSION "10.6.0.0"
 
 #define OCRDMA_ROCE_DRV_DESC "Emulex OneConnect RoCE Driver"
 #define OCRDMA_NODE_DESC "Emulex OneConnect RoCE HCA"
-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
