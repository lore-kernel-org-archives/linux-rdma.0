From: Stefan Hasko <hasko.stevo@gmail.com>
Subject: [PATCH 2/2] drivers: infiniband: hw: cxgb4: fix cast warning
Date: Sat, 22 Dec 2012 03:29:21 +0100
Message-ID: <1356143361-31783-1-git-send-email-hasko.stevo@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-kernel@vger.kernel.org, Stefan Hasko <hasko.stevo@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Fixed compile warning cast to pointer from integer of different size

Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>
---
 drivers/infiniband/hw/cxgb4/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index cb4ecd7..314ec4a 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -413,7 +413,7 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p qpshift %lu "
 	     "qpmask 0x%x cqshift %lu cqmask 0x%x\n",
 	     (unsigned)pci_resource_len(rdev->lldi.pdev, 2),
-	     (void *)pci_resource_start(rdev->lldi.pdev, 2),
+	     (void *)(unsigned long)pci_resource_start(rdev->lldi.pdev, 2),
 	     rdev->lldi.db_reg,
 	     rdev->lldi.gts_reg,
 	     rdev->qpshift, rdev->qpmask,
-- 
1.7.10.4
