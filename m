From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Fix style issues
Date: Wed, 9 Nov 2011 13:35:55 -0500
Message-ID: <20111109183555.10372.50251.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

More style issues revealed with checkpatch.pl -f.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_driver.c |    3 +--
 drivers/infiniband/hw/qib/qib_init.c   |    2 +-
 drivers/infiniband/hw/qib/qib_sd7220.c |    2 +-
 drivers/infiniband/hw/qib/qib_sysfs.c  |    2 +-
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index a8c2296..a68ccfb 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -374,9 +374,8 @@ static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
 						lnh == QIB_LRH_GRH,
 						qp,
 						be32_to_cpu(ohdr->bth[0]));
-				if (ruc_res) {
+				if (ruc_res)
 					goto unlock;
-				}
 
 				/* Only deal with RDMA Writes for now */
 				if (opcode <
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index f7506cd..b1c9919 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1015,7 +1015,7 @@ static int __devinit qib_init_one(struct pci_dev *,
 #define DRIVER_LOAD_MSG "QLogic " QIB_DRV_NAME " loaded: "
 #define PFX QIB_DRV_NAME ": "
 
-static const struct pci_device_id qib_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(qib_pci_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_PATHSCALE, PCI_DEVICE_ID_QLOGIC_IB_6120) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_IB_7220) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_IB_7322) },
diff --git a/drivers/infiniband/hw/qib/qib_sd7220.c b/drivers/infiniband/hw/qib/qib_sd7220.c
index de1a4b2..ac065dd 100644
--- a/drivers/infiniband/hw/qib/qib_sd7220.c
+++ b/drivers/infiniband/hw/qib/qib_sd7220.c
@@ -300,7 +300,7 @@ bail:
 }
 
 static void qib_sd_trimdone_monitor(struct qib_devdata *dd,
-       const char *where)
+	const char *where)
 {
 	int ret, chn, baduns;
 	u64 val;
diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index 78fbd56..dae5160 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -150,7 +150,7 @@ static ssize_t show_status(struct qib_pportdata *ppd, char *buf)
  * For userland compatibility, these offsets must remain fixed.
  * They are strings for QIB_STATUS_*
  */
-static const char *qib_status_str[] = {
+static const char * const qib_status_str[] = {
 	"Initted",
 	"",
 	"",


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
