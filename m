From: Bill Pemberton <wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>
Subject: [PATCH 407/493] infiniband: remove use of __devexit
Date: Mon, 19 Nov 2012 13:25:56 -0500
Message-ID: <1353349642-3677-407-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

CONFIG_HOTPLUG is going away as an option so __devexit is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> 
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> 
Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> 
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org 
---
 drivers/infiniband/hw/amso1100/c2.c        | 2 +-
 drivers/infiniband/hw/amso1100/c2.h        | 4 ++--
 drivers/infiniband/hw/amso1100/c2_pd.c     | 2 +-
 drivers/infiniband/hw/amso1100/c2_qp.c     | 2 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c   | 2 +-
 drivers/infiniband/hw/ehca/ehca_main.c     | 2 +-
 drivers/infiniband/hw/ipath/ipath_driver.c | 4 ++--
 drivers/infiniband/hw/mthca/mthca_main.c   | 2 +-
 drivers/infiniband/hw/nes/nes.c            | 2 +-
 drivers/infiniband/hw/qib/qib_init.c       | 4 ++--
 10 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2.c b/drivers/infiniband/hw/amso1100/c2.c
index 9a51635..958c2e1 100644
--- a/drivers/infiniband/hw/amso1100/c2.c
+++ b/drivers/infiniband/hw/amso1100/c2.c
@@ -1191,7 +1191,7 @@ static int c2_probe(struct pci_dev *pcidev,
 	return ret;
 }
 
-static void __devexit c2_remove(struct pci_dev *pcidev)
+static void c2_remove(struct pci_dev *pcidev)
 {
 	struct c2_dev *c2dev = pci_get_drvdata(pcidev);
 	struct net_device *netdev = c2dev->netdev;
diff --git a/drivers/infiniband/hw/amso1100/c2.h b/drivers/infiniband/hw/amso1100/c2.h
index a79750b..ba7a1208 100644
--- a/drivers/infiniband/hw/amso1100/c2.h
+++ b/drivers/infiniband/hw/amso1100/c2.h
@@ -499,7 +499,7 @@ extern int c2_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 extern int c2_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *ib_wr,
 			   struct ib_recv_wr **bad_wr);
 extern void c2_init_qp_table(struct c2_dev *c2dev);
-extern void __devexit c2_cleanup_qp_table(struct c2_dev *c2dev);
+extern void c2_cleanup_qp_table(struct c2_dev *c2dev);
 extern void c2_set_qp_state(struct c2_qp *, int);
 extern struct c2_qp *c2_find_qpn(struct c2_dev *c2dev, int qpn);
 
@@ -507,7 +507,7 @@ extern struct c2_qp *c2_find_qpn(struct c2_dev *c2dev, int qpn);
 extern int c2_pd_alloc(struct c2_dev *c2dev, int privileged, struct c2_pd *pd);
 extern void c2_pd_free(struct c2_dev *c2dev, struct c2_pd *pd);
 extern int c2_init_pd_table(struct c2_dev *c2dev);
-extern void __devexit c2_cleanup_pd_table(struct c2_dev *c2dev);
+extern void c2_cleanup_pd_table(struct c2_dev *c2dev);
 
 /* CQs */
 extern int c2_init_cq(struct c2_dev *c2dev, int entries,
diff --git a/drivers/infiniband/hw/amso1100/c2_pd.c b/drivers/infiniband/hw/amso1100/c2_pd.c
index b87a64e..f3e81dc 100644
--- a/drivers/infiniband/hw/amso1100/c2_pd.c
+++ b/drivers/infiniband/hw/amso1100/c2_pd.c
@@ -84,7 +84,7 @@ int c2_init_pd_table(struct c2_dev *c2dev)
 	return 0;
 }
 
-void __devexit c2_cleanup_pd_table(struct c2_dev *c2dev)
+void c2_cleanup_pd_table(struct c2_dev *c2dev)
 {
 	kfree(c2dev->pd_table.table);
 }
diff --git a/drivers/infiniband/hw/amso1100/c2_qp.c b/drivers/infiniband/hw/amso1100/c2_qp.c
index 9a3b579..28cd5cb 100644
--- a/drivers/infiniband/hw/amso1100/c2_qp.c
+++ b/drivers/infiniband/hw/amso1100/c2_qp.c
@@ -1016,7 +1016,7 @@ void c2_init_qp_table(struct c2_dev *c2dev)
 	idr_init(&c2dev->qp_table.idr);
 }
 
-void __devexit c2_cleanup_qp_table(struct c2_dev *c2dev)
+void c2_cleanup_qp_table(struct c2_dev *c2dev)
 {
 	idr_destroy(&c2dev->qp_table.idr);
 }
diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c b/drivers/infiniband/hw/amso1100/c2_rnic.c
index 9ea4002..b7c9869 100644
--- a/drivers/infiniband/hw/amso1100/c2_rnic.c
+++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
@@ -611,7 +611,7 @@ int c2_rnic_init(struct c2_dev *c2dev)
 /*
  * Called by c2_remove to cleanup the RNIC resources.
  */
-void __devexit c2_rnic_term(struct c2_dev *c2dev)
+void c2_rnic_term(struct c2_dev *c2dev)
 {
 
 	/* Close the open adapter instance */
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 2458974..8772615 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -879,7 +879,7 @@ probe1:
 	return -EINVAL;
 }
 
-static int __devexit ehca_remove(struct platform_device *dev)
+static int ehca_remove(struct platform_device *dev)
 {
 	struct ehca_shca *shca = dev_get_drvdata(&dev->dev);
 	unsigned long flags;
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index e5fd2b9..88dc1d9 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -127,7 +127,7 @@ const char *ipath_ibcstatus_str[] = {
 	"LTState1C", "LTState1D", "LTState1E", "LTState1F"
 };
 
-static void __devexit ipath_remove_one(struct pci_dev *);
+static void ipath_remove_one(struct pci_dev *);
 static int ipath_init_one(struct pci_dev *,
 				    const struct pci_device_id *);
 
@@ -737,7 +737,7 @@ static void cleanup_device(struct ipath_devdata *dd)
 	kfree(tmp);
 }
 
-static void __devexit ipath_remove_one(struct pci_dev *pdev)
+static void ipath_remove_one(struct pci_dev *pdev)
 {
 	struct ipath_devdata *dd = pci_get_drvdata(pdev);
 
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index 5ccae15..8b6b11d 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -1162,7 +1162,7 @@ static int mthca_init_one(struct pci_dev *pdev,
 	return ret;
 }
 
-static void __devexit mthca_remove_one(struct pci_dev *pdev)
+static void mthca_remove_one(struct pci_dev *pdev)
 {
 	mutex_lock(&mthca_device_mutex);
 	__mthca_remove_one(pdev);
diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 95a5f57..5b152a3 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -749,7 +749,7 @@ static int nes_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 /**
  * nes_remove - unload from kernel
  */
-static void __devexit nes_remove(struct pci_dev *pcidev)
+static void nes_remove(struct pci_dev *pcidev)
 {
 	struct nes_device *nesdev = pci_get_drvdata(pcidev);
 	struct net_device *netdev;
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 42ca4cb..58b657e 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1134,7 +1134,7 @@ void qib_disable_after_error(struct qib_devdata *dd)
 		*dd->devstatusp |= QIB_STATUS_HWERROR;
 }
 
-static void __devexit qib_remove_one(struct pci_dev *);
+static void qib_remove_one(struct pci_dev *);
 static int qib_init_one(struct pci_dev *,
 				  const struct pci_device_id *);
 
@@ -1448,7 +1448,7 @@ bail:
 	return ret;
 }
 
-static void __devexit qib_remove_one(struct pci_dev *pdev)
+static void qib_remove_one(struct pci_dev *pdev)
 {
 	struct qib_devdata *dd = pci_get_drvdata(pdev);
 	int ret;
-- 
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
