From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 43/77] IB/ipath: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:15 -0800
Message-ID: <1360179649-22465-44-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Mike Marciniszyn <infinipath@intel.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Marciniszyn <infinipath@intel.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/ipath/ipath_driver.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index 7b371f5..fcdaeea 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -194,11 +194,6 @@ static struct ipath_devdata *ipath_alloc_devdata(struct pci_dev *pdev)
 	struct ipath_devdata *dd;
 	int ret;
 
-	if (!idr_pre_get(&unit_table, GFP_KERNEL)) {
-		dd = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
-
 	dd = vzalloc(sizeof(*dd));
 	if (!dd) {
 		dd = ERR_PTR(-ENOMEM);
@@ -206,9 +201,10 @@ static struct ipath_devdata *ipath_alloc_devdata(struct pci_dev *pdev)
 	}
 	dd->ipath_unit = -1;
 
+	idr_preload(GFP_KERNEL);
 	spin_lock_irqsave(&ipath_devs_lock, flags);
 
-	ret = idr_get_new(&unit_table, dd, &dd->ipath_unit);
+	ret = idr_alloc(&unit_table, dd, 0, 0, GFP_KERNEL);
 	if (ret < 0) {
 		printk(KERN_ERR IPATH_DRV_NAME
 		       ": Could not allocate unit ID: error %d\n", -ret);
@@ -216,6 +212,7 @@ static struct ipath_devdata *ipath_alloc_devdata(struct pci_dev *pdev)
 		dd = ERR_PTR(ret);
 		goto bail_unlock;
 	}
+	dd->ipath_unit = ret;
 
 	dd->pcidev = pdev;
 	pci_set_drvdata(pdev, dd);
@@ -224,7 +221,7 @@ static struct ipath_devdata *ipath_alloc_devdata(struct pci_dev *pdev)
 
 bail_unlock:
 	spin_unlock_irqrestore(&ipath_devs_lock, flags);
-
+	idr_preload_end();
 bail:
 	return dd;
 }
@@ -2503,11 +2500,6 @@ static int __init infinipath_init(void)
 	 * the PCI subsystem.
 	 */
 	idr_init(&unit_table);
-	if (!idr_pre_get(&unit_table, GFP_KERNEL)) {
-		printk(KERN_ERR IPATH_DRV_NAME ": idr_pre_get() failed\n");
-		ret = -ENOMEM;
-		goto bail;
-	}
 
 	ret = pci_register_driver(&ipath_driver);
 	if (ret < 0) {
-- 
1.8.1
