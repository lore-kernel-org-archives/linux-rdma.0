From: Bill Pemberton <wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>
Subject: [PATCH 068/493] infiniband: remove use of __devexit_p
Date: Mon, 19 Nov 2012 13:20:17 -0500
Message-ID: <1353349642-3677-68-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
needed.

Signed-off-by: Bill Pemberton <wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> 
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> 
Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> 
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org 
---
 drivers/infiniband/hw/amso1100/c2.c        | 2 +-
 drivers/infiniband/hw/ipath/ipath_driver.c | 2 +-
 drivers/infiniband/hw/mthca/mthca_main.c   | 2 +-
 drivers/infiniband/hw/nes/nes.c            | 2 +-
 drivers/infiniband/hw/qib/qib_init.c       | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2.c b/drivers/infiniband/hw/amso1100/c2.c
index 5ce7b9e..60cd99e 100644
--- a/drivers/infiniband/hw/amso1100/c2.c
+++ b/drivers/infiniband/hw/amso1100/c2.c
@@ -1236,7 +1236,7 @@ static struct pci_driver c2_pci_driver = {
 	.name = DRV_NAME,
 	.id_table = c2_pci_table,
 	.probe = c2_probe,
-	.remove = __devexit_p(c2_remove),
+	.remove = c2_remove,
 };
 
 static int __init c2_init_module(void)
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index bfca37b..eb3d422 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -148,7 +148,7 @@ MODULE_DEVICE_TABLE(pci, ipath_pci_tbl);
 static struct pci_driver ipath_driver = {
 	.name = IPATH_DRV_NAME,
 	.probe = ipath_init_one,
-	.remove = __devexit_p(ipath_remove_one),
+	.remove = ipath_remove_one,
 	.id_table = ipath_pci_tbl,
 	.driver = {
 		.groups = ipath_driver_attr_groups,
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index aa12a53..4dda1dd 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -1199,7 +1199,7 @@ static struct pci_driver mthca_driver = {
 	.name		= DRV_NAME,
 	.id_table	= mthca_pci_table,
 	.probe		= mthca_init_one,
-	.remove		= __devexit_p(mthca_remove_one)
+	.remove		= mthca_remove_one
 };
 
 static void __init __mthca_check_profile_val(const char *name, int *pval,
diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 748db2d..cc15f3f 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -810,7 +810,7 @@ static struct pci_driver nes_pci_driver = {
 	.name = DRV_NAME,
 	.id_table = nes_pci_table,
 	.probe = nes_probe,
-	.remove = __devexit_p(nes_remove),
+	.remove = nes_remove,
 };
 
 static ssize_t nes_show_adapter(struct device_driver *ddp, char *buf)
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 4443adf..a7de247 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1153,7 +1153,7 @@ MODULE_DEVICE_TABLE(pci, qib_pci_tbl);
 struct pci_driver qib_driver = {
 	.name = QIB_DRV_NAME,
 	.probe = qib_init_one,
-	.remove = __devexit_p(qib_remove_one),
+	.remove = qib_remove_one,
 	.id_table = qib_pci_tbl,
 	.err_handler = &qib_pci_err_handler,
 };
-- 
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
