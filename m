From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 for-next 16/16] RDMA/ocrdma: Update the ocrdma module version string
Date: Tue, 10 Jun 2014 19:32:27 +0530
Message-ID: <f301d39a-4ecf-4ca8-8c72-dee30c1257b4@CMEXHTCAS1.ad.emulex.com>
References: <1402408947-2074-1-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-2-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-3-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-4-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-5-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-6-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-7-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-8-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-9-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-10-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-11-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-12-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-13-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-14-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-15-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-16-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402408947-2074-16-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Updating the ocrdma driver version string

Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 5716513..b43456a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -40,7 +40,7 @@
 #include <be_roce.h>
 #include "ocrdma_sli.h"
 
-#define OCRDMA_ROCE_DRV_VERSION "10.2.145.0u"
+#define OCRDMA_ROCE_DRV_VERSION "10.2.287.0u"
 
 #define OCRDMA_ROCE_DRV_DESC "Emulex OneConnect RoCE Driver"
 #define OCRDMA_NODE_DESC "Emulex OneConnect RoCE HCA"
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
