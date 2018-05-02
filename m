From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-next 08/14] IB/{hfi1,
 qib}: Add handling of kernel restart
Date: Wed, 02 May 2018 06:43:15 -0700
Message-ID: <20180502134312.20730.58453.stgit@scvm10.sc.intel.com>
References: <20180502133831.20730.42677.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180502133831.20730.42677.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Alex Estrin <alex.estrin@intel.com>

A warm restart will fail to unload the driver, leaving link state
potentially flapping up to the point the BIOS resets the adapter.
Correct the issue by hooking the shutdown pci method,
which will bring port down.

Cc: <stable@vger.kernel.org> # 4.9.x
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Alex Estrin <alex.estrin@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>

---
v1->v2
limit shutdown callback function to stop device HW only.
---
 drivers/infiniband/hw/hfi1/hfi.h     |    1 +
 drivers/infiniband/hw/hfi1/init.c    |   13 +++++++++++++
 drivers/infiniband/hw/qib/qib.h      |    1 +
 drivers/infiniband/hw/qib/qib_init.c |   13 +++++++++++++
 4 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index cac2c62..9c97c18 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1856,6 +1856,7 @@ struct cc_state *get_cc_state_protected(struct hfi1_pportdata *ppd)
 #define HFI1_HAS_SDMA_TIMEOUT  0x8
 #define HFI1_HAS_SEND_DMA      0x10   /* Supports Send DMA */
 #define HFI1_FORCED_FREEZE     0x80   /* driver forced freeze mode */
+#define HFI1_SHUTDOWN          0x100  /* device is shutting down */
 
 /* IB dword length mask in PBC (lower 11 bits); same for all chips */
 #define HFI1_PBC_LENGTH_MASK                     ((1 << 11) - 1)
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 6309edf..790542c 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1058,6 +1058,10 @@ static void shutdown_device(struct hfi1_devdata *dd)
 	unsigned pidx;
 	int i;
 
+	if (dd->flags & HFI1_SHUTDOWN)
+		return;
+	dd->flags |= HFI1_SHUTDOWN;
+
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 		ppd = dd->pport + pidx;
 
@@ -1391,6 +1395,7 @@ void hfi1_disable_after_error(struct hfi1_devdata *dd)
 
 static void remove_one(struct pci_dev *);
 static int init_one(struct pci_dev *, const struct pci_device_id *);
+static void shutdown_one(struct pci_dev *);
 
 #define DRIVER_LOAD_MSG "Intel " DRIVER_NAME " loaded: "
 #define PFX DRIVER_NAME ": "
@@ -1407,6 +1412,7 @@ void hfi1_disable_after_error(struct hfi1_devdata *dd)
 	.name = DRIVER_NAME,
 	.probe = init_one,
 	.remove = remove_one,
+	.shutdown = shutdown_one,
 	.id_table = hfi1_pci_tbl,
 	.err_handler = &hfi1_pci_err_handler,
 };
@@ -1816,6 +1822,13 @@ static void remove_one(struct pci_dev *pdev)
 	postinit_cleanup(dd);
 }
 
+static void shutdown_one(struct pci_dev *pdev)
+{
+	struct hfi1_devdata *dd = pci_get_drvdata(pdev);
+
+	shutdown_device(dd);
+}
+
 /**
  * hfi1_create_rcvhdrq - create a receive header queue
  * @dd: the hfi1_ib device
diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 4607245..43a68d7 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1228,6 +1228,7 @@ int qib_cdev_init(int minor, const char *name,
 #define QIB_BADINTR           0x8000 /* severe interrupt problems */
 #define QIB_DCA_ENABLED       0x10000 /* Direct Cache Access enabled */
 #define QIB_HAS_QSFP          0x20000 /* device (card instance) has QSFP */
+#define QIB_SHUTDOWN          0x40000 /* device is shutting down */
 
 /*
  * values for ppd->lflags (_ib_port_ related flags)
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 6c68f8a..0155202 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -841,6 +841,10 @@ static void qib_shutdown_device(struct qib_devdata *dd)
 	struct qib_pportdata *ppd;
 	unsigned pidx;
 
+	if (dd->flags & QIB_SHUTDOWN)
+		return;
+	dd->flags |= QIB_SHUTDOWN;
+
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 		ppd = dd->pport + pidx;
 
@@ -1182,6 +1186,7 @@ void qib_disable_after_error(struct qib_devdata *dd)
 
 static void qib_remove_one(struct pci_dev *);
 static int qib_init_one(struct pci_dev *, const struct pci_device_id *);
+static void qib_shutdown_one(struct pci_dev *);
 
 #define DRIVER_LOAD_MSG "Intel " QIB_DRV_NAME " loaded: "
 #define PFX QIB_DRV_NAME ": "
@@ -1199,6 +1204,7 @@ void qib_disable_after_error(struct qib_devdata *dd)
 	.name = QIB_DRV_NAME,
 	.probe = qib_init_one,
 	.remove = qib_remove_one,
+	.shutdown = qib_shutdown_one,
 	.id_table = qib_pci_tbl,
 	.err_handler = &qib_pci_err_handler,
 };
@@ -1549,6 +1555,13 @@ static void qib_remove_one(struct pci_dev *pdev)
 	qib_postinit_cleanup(dd);
 }
 
+static void qib_shutdown_one(struct pci_dev *pdev)
+{
+	struct qib_devdata *dd = pci_get_drvdata(pdev);
+
+	qib_shutdown_device(dd);
+}
+
 /**
  * qib_create_rcvhdrq - create a receive header queue
  * @dd: the qlogic_ib device
