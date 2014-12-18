From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/14] RDMA/ocrdma: Update the ocrdma module version string
Date: Thu, 18 Dec 2014 14:13:08 +0530
Message-ID: <587d37fe-bc3d-4104-b4ac-b4435b11a116@CMEXHTCAS1.ad.emulex.com>
References: <1418892188-6623-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418892188-6623-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Updating the ocrdma driver version string

Signed-off-by: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 4dcec05..c9780d9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -40,7 +40,7 @@
 #include <be_roce.h>
 #include "ocrdma_sli.h"
 
-#define OCRDMA_ROCE_DRV_VERSION "10.2.287.0u"
+#define OCRDMA_ROCE_DRV_VERSION "10.4.205.0u"
 
 #define OCRDMA_ROCE_DRV_DESC "Emulex OneConnect RoCE Driver"
 #define OCRDMA_NODE_DESC "Emulex OneConnect RoCE HCA"
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
