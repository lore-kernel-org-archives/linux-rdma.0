From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH for-next 5/5] RDMA/ocrdma: Bump up ocrdma version number to 11.0.0.0
Date: Tue, 20 Oct 2015 14:18:00 +0530
Message-ID: <1445330880-3912-6-git-send-email-selvin.xavier@avagotech.com>
References: <1445330880-3912-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445330880-3912-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Updating the version number to 11.0.0.0

Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 8cd57c7..8f047f9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -55,7 +55,7 @@
 #include <be_roce.h>
 #include "ocrdma_sli.h"
 
-#define OCRDMA_ROCE_DRV_VERSION "10.6.0.0"
+#define OCRDMA_ROCE_DRV_VERSION "11.0.0.0"
 
 #define OCRDMA_ROCE_DRV_DESC "Emulex OneConnect RoCE Driver"
 #define OCRDMA_NODE_DESC "Emulex OneConnect RoCE HCA"
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
