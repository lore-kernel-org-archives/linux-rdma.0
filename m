From: Bill Pemberton <wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>
Subject: [PATCH 210/493] infiniband: remove use of __devinit
Date: Mon, 19 Nov 2012 13:22:39 -0500
Message-ID: <1353349642-3677-210-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

CONFIG_HOTPLUG is going away as an option so __devinit is no longer
needed.

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
index 60cd99e..9a51635 100644
--- a/drivers/infiniband/hw/amso1100/c2.c
+++ b/drivers/infiniband/hw/amso1100/c2.c
@@ -920,7 +920,7 @@ static struct net_device *c2_devinit(struct c2_dev *c2dev,
 	return netdev;
 }
 
-static int __devinit c2_probe(struct pci_dev *pcidev,
+static int c2_probe(struct pci_dev *pcidev,
 			      const struct pci_device_id *ent)
 {
 	int ret = 0, i;
diff --git a/drivers/infiniband/hw/amso1100/c2.h b/drivers/infiniband/hw/amso1100/c2.h
index 6ae698e..a79750b 100644
--- a/drivers/infiniband/hw/amso1100/c2.h
+++ b/drivers/infiniband/hw/amso1100/c2.h
@@ -498,7 +498,7 @@ extern int c2_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 			struct ib_send_wr **bad_wr);
 extern int c2_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *ib_wr,
 			   struct ib_recv_wr **bad_wr);
-extern void __devinit c2_init_qp_table(struct c2_dev *c2dev);
+extern void c2_init_qp_table(struct c2_dev *c2dev);
 extern void __devexit c2_cleanup_qp_table(struct c2_dev *c2dev);
 extern void c2_set_qp_state(struct c2_qp *, int);
 extern struct c2_qp *c2_find_qpn(struct c2_dev *c2dev, int qpn);
@@ -506,7 +506,7 @@ extern struct c2_qp *c2_find_qpn(struct c2_dev *c2dev, int qpn);
 /* PDs */
 extern int c2_pd_alloc(struct c2_dev *c2dev, int privileged, struct c2_pd *pd);
 extern void c2_pd_free(struct c2_dev *c2dev, struct c2_pd *pd);
-extern int __devinit c2_init_pd_table(struct c2_dev *c2dev);
+extern int c2_init_pd_table(struct c2_dev *c2dev);
 extern void __devexit c2_cleanup_pd_table(struct c2_dev *c2dev);
 
 /* CQs */
diff --git a/drivers/infiniband/hw/amso1100/c2_pd.c b/drivers/infiniband/hw/amso1100/c2_pd.c
index 161f2a2..b87a64e 100644
--- a/drivers/infiniband/hw/amso1100/c2_pd.c
+++ b/drivers/infiniband/hw/amso1100/c2_pd.c
@@ -70,7 +70,7 @@ void c2_pd_free(struct c2_dev *c2dev, struct c2_pd *pd)
 	spin_unlock(&c2dev->pd_table.lock);
 }
 
-int __devinit c2_init_pd_table(struct c2_dev *c2dev)
+int c2_init_pd_table(struct c2_dev *c2dev)
 {
 
 	c2dev->pd_table.last = 0;
diff --git a/drivers/infiniband/hw/amso1100/c2_qp.c b/drivers/infiniband/hw/amso1100/c2_qp.c
index 0d7b6f23..9a3b579 100644
--- a/drivers/infiniband/hw/amso1100/c2_qp.c
+++ b/drivers/infiniband/hw/amso1100/c2_qp.c
@@ -1010,7 +1010,7 @@ out:
 	return err;
 }
 
-void __devinit c2_init_qp_table(struct c2_dev *c2dev)
+void c2_init_qp_table(struct c2_dev *c2dev)
 {
 	spin_lock_init(&c2dev->qp_table.lock);
 	idr_init(&c2dev->qp_table.idr);
diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c b/drivers/infiniband/hw/amso1100/c2_rnic.c
index e4a7315..9ea4002 100644
--- a/drivers/infiniband/hw/amso1100/c2_rnic.c
+++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
@@ -442,7 +442,7 @@ static int c2_rnic_close(struct c2_dev *c2dev)
  * involves initializing the various limits and resource pools that
  * comprise the RNIC instance.
  */
-int __devinit c2_rnic_init(struct c2_dev *c2dev)
+int c2_rnic_init(struct c2_dev *c2dev)
 {
 	int err;
 	u32 qsize, msgsize;
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 832e7a7..2458974 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -713,7 +713,7 @@ static struct attribute_group ehca_dev_attr_grp = {
 	.attrs = ehca_dev_attrs
 };
 
-static int __devinit ehca_probe(struct platform_device *dev,
+static int ehca_probe(struct platform_device *dev,
 				const struct of_device_id *id)
 {
 	struct ehca_shca *shca;
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index eb3d422..e5fd2b9 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -128,7 +128,7 @@ const char *ipath_ibcstatus_str[] = {
 };
 
 static void __devexit ipath_remove_one(struct pci_dev *);
-static int __devinit ipath_init_one(struct pci_dev *,
+static int ipath_init_one(struct pci_dev *,
 				    const struct pci_device_id *);
 
 /* Only needed for registration, nothing else needs this info */
@@ -392,7 +392,7 @@ done:
 
 static void cleanup_device(struct ipath_devdata *dd);
 
-static int __devinit ipath_init_one(struct pci_dev *pdev,
+static int ipath_init_one(struct pci_dev *pdev,
 				    const struct pci_device_id *ent)
 {
 	int ret, len, j;
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index 4dda1dd..eee56ba 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -1139,7 +1139,7 @@ int __mthca_restart_one(struct pci_dev *pdev)
 	return __mthca_init_one(pdev, hca_type);
 }
 
-static int __devinit mthca_init_one(struct pci_dev *pdev,
+static int mthca_init_one(struct pci_dev *pdev,
 				    const struct pci_device_id *id)
 {
 	int ret;
diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index cc15f3f..95a5f57 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -444,7 +444,7 @@ static irqreturn_t nes_interrupt(int irq, void *dev_id)
 /**
  * nes_probe - Device initialization
  */
-static int __devinit nes_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
+static int nes_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 {
 	struct net_device *netdev = NULL;
 	struct nes_device *nesdev = NULL;
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index a7de247..42ca4cb 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1135,7 +1135,7 @@ void qib_disable_after_error(struct qib_devdata *dd)
 }
 
 static void __devexit qib_remove_one(struct pci_dev *);
-static int __devinit qib_init_one(struct pci_dev *,
+static int qib_init_one(struct pci_dev *,
 				  const struct pci_device_id *);
 
 #define DRIVER_LOAD_MSG "QLogic " QIB_DRV_NAME " loaded: "
@@ -1342,7 +1342,7 @@ static void qib_postinit_cleanup(struct qib_devdata *dd)
 	qib_free_devdata(dd);
 }
 
-static int __devinit qib_init_one(struct pci_dev *pdev,
+static int qib_init_one(struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
 {
 	int ret, j, pidx, initfail;
-- 
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
