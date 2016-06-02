From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] IB/usnic: Remove unused DMA attributes
Date: Thu, 02 Jun 2016 11:45:01 +0200
Message-ID: <1464860701-11376-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Benvenuti <benve@cisco.com>, Dave Goodell <dgoodell@cisco.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
List-Id: linux-rdma@vger.kernel.org

The DMA attributes are set but never used.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/infiniband/hw/usnic/usnic_uiom.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 7209fbc03ccb..a0b6ebee4d8a 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -36,7 +36,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/sched.h>
 #include <linux/hugetlb.h>
-#include <linux/dma-attrs.h>
 #include <linux/iommu.h>
 #include <linux/workqueue.h>
 #include <linux/list.h>
@@ -112,10 +111,6 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 	int i;
 	int flags;
 	dma_addr_t pa;
-	DEFINE_DMA_ATTRS(attrs);
-
-	if (dmasync)
-		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
 
 	if (!can_do_mlock())
 		return -EPERM;
-- 
1.9.1
