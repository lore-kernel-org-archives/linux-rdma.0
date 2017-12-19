From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 10/11] IB/{hfi1,
 qib}: Fix a concurrency issue with device name in logging
Date: Mon, 18 Dec 2017 19:57:21 -0800
Message-ID: <20171219035718.2126.72986.stgit@scvm10.sc.intel.com>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219034753.2126.78386.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The get_unit_name() function crafts a string based on the device name
and the device unit number.  It then stores this in a static variable.

This has concurrency issues as can be seen with this log:

hfi1 0000:02:00.0: hfi1_1: read_idle_message: read idle message 0x203
hfi1 0000:01:00.0: hfi1_1: read_idle_message: read idle message 0x203

The PCI device ID (0000:02:00.0 vs. 0000:01:00.0) is correct for the
message, but the device string hfi1_1 is incorrect (it should be
hfi1_0 for the second log message).

Remove get_unit_name() function.

Instead, use the rvt accessor rvt_get_ibdev_name() to get the IB name
string.

Clean up any hfi1_early_xx calls that can now use the new path.

QIB has the same (qib_get_unit_name()) issue.  Updating as necessary.

Remove qib_get_unit_name() function.

Update log message that has redundant device name.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c      |    5 ++---
 drivers/infiniband/hw/hfi1/driver.c    |    8 --------
 drivers/infiniband/hw/hfi1/hfi.h       |   22 ++++++++++++----------
 drivers/infiniband/hw/qib/qib.h        |    7 +++----
 drivers/infiniband/hw/qib/qib_driver.c |    8 --------
 drivers/infiniband/hw/qib/qib_eeprom.c |    3 +--
 6 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 99c7347..e63988c 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14929,9 +14929,8 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 
 		if (num_vls < HFI1_MIN_VLS_SUPPORTED ||
 		    num_vls > HFI1_MAX_VLS_SUPPORTED) {
-			hfi1_early_err(&pdev->dev,
-				       "Invalid num_vls %u, using %u VLs\n",
-				    num_vls, HFI1_MAX_VLS_SUPPORTED);
+			dd_dev_err(dd, "Invalid num_vls %u, using %u VLs\n",
+				   num_vls, HFI1_MAX_VLS_SUPPORTED);
 			num_vls = HFI1_MAX_VLS_SUPPORTED;
 		}
 		ppd->vls_supported = num_vls;
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 4561719..067b29f 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -159,14 +159,6 @@ static int hfi1_caps_get(char *buffer, const struct kernel_param *kp)
 	return scnprintf(buffer, PAGE_SIZE, "0x%lx", cap_mask);
 }
 
-const char *get_unit_name(int unit)
-{
-	static char iname[16];
-
-	snprintf(iname, sizeof(iname), DRIVER_NAME "_%u", unit);
-	return iname;
-}
-
 struct pci_dev *get_pci_dev(struct rvt_dev_info *rdi)
 {
 	struct hfi1_ibdev *ibdev = container_of(rdi, struct hfi1_ibdev, rdi);
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 88fa934..869c2bf 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1975,7 +1975,6 @@ int get_platform_config_field(struct hfi1_devdata *dd,
 			      table_type, int table_index, int field_index,
 			      u32 *data, u32 len);
 
-const char *get_unit_name(int unit);
 struct pci_dev *get_pci_dev(struct rvt_dev_info *rdi);
 
 /*
@@ -2126,39 +2125,42 @@ static inline u64 hfi1_pkt_base_sdma_integrity(struct hfi1_devdata *dd)
 
 #define dd_dev_emerg(dd, fmt, ...) \
 	dev_emerg(&(dd)->pcidev->dev, "%s: " fmt, \
-		  get_unit_name((dd)->unit), ##__VA_ARGS__)
+		  rvt_get_ibdev_name(&(dd)->verbs_dev.rdi), ##__VA_ARGS__)
 
 #define dd_dev_err(dd, fmt, ...) \
 	dev_err(&(dd)->pcidev->dev, "%s: " fmt, \
-			get_unit_name((dd)->unit), ##__VA_ARGS__)
+		rvt_get_ibdev_name(&(dd)->verbs_dev.rdi), ##__VA_ARGS__)
 
 #define dd_dev_err_ratelimited(dd, fmt, ...) \
 	dev_err_ratelimited(&(dd)->pcidev->dev, "%s: " fmt, \
-			get_unit_name((dd)->unit), ##__VA_ARGS__)
+			    rvt_get_ibdev_name(&(dd)->verbs_dev.rdi), \
+			    ##__VA_ARGS__)
 
 #define dd_dev_warn(dd, fmt, ...) \
 	dev_warn(&(dd)->pcidev->dev, "%s: " fmt, \
-			get_unit_name((dd)->unit), ##__VA_ARGS__)
+		 rvt_get_ibdev_name(&(dd)->verbs_dev.rdi), ##__VA_ARGS__)
 
 #define dd_dev_warn_ratelimited(dd, fmt, ...) \
 	dev_warn_ratelimited(&(dd)->pcidev->dev, "%s: " fmt, \
-			get_unit_name((dd)->unit), ##__VA_ARGS__)
+			     rvt_get_ibdev_name(&(dd)->verbs_dev.rdi), \
+			     ##__VA_ARGS__)
 
 #define dd_dev_info(dd, fmt, ...) \
 	dev_info(&(dd)->pcidev->dev, "%s: " fmt, \
-			get_unit_name((dd)->unit), ##__VA_ARGS__)
+		 rvt_get_ibdev_name(&(dd)->verbs_dev.rdi), ##__VA_ARGS__)
 
 #define dd_dev_info_ratelimited(dd, fmt, ...) \
 	dev_info_ratelimited(&(dd)->pcidev->dev, "%s: " fmt, \
-			get_unit_name((dd)->unit), ##__VA_ARGS__)
+			     rvt_get_ibdev_name(&(dd)->verbs_dev.rdi), \
+			     ##__VA_ARGS__)
 
 #define dd_dev_dbg(dd, fmt, ...) \
 	dev_dbg(&(dd)->pcidev->dev, "%s: " fmt, \
-		get_unit_name((dd)->unit), ##__VA_ARGS__)
+		rvt_get_ibdev_name(&(dd)->verbs_dev.rdi), ##__VA_ARGS__)
 
 #define hfi1_dev_porterr(dd, port, fmt, ...) \
 	dev_err(&(dd)->pcidev->dev, "%s: port %u: " fmt, \
-			get_unit_name((dd)->unit), (port), ##__VA_ARGS__)
+		rvt_get_ibdev_name(&(dd)->verbs_dev.rdi), (port), ##__VA_ARGS__)
 
 /*
  * this is used for formatting hw error messages...
diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 34c5254..0235f76 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1428,7 +1428,6 @@ int qib_pcie_ddinit(struct qib_devdata *, struct pci_dev *,
  */
 dma_addr_t qib_map_page(struct pci_dev *, struct page *, unsigned long,
 			  size_t, int);
-const char *qib_get_unit_name(int unit);
 struct pci_dev *qib_get_pci_dev(struct rvt_dev_info *rdi);
 
 /*
@@ -1487,15 +1486,15 @@ static inline void qib_flush_wc(void)
 
 #define qib_dev_err(dd, fmt, ...) \
 	dev_err(&(dd)->pcidev->dev, "%s: " fmt, \
-		qib_get_unit_name((dd)->unit), ##__VA_ARGS__)
+		rvt_get_ibdev_name(&(dd)->verbs_dev.rdi), ##__VA_ARGS__)
 
 #define qib_dev_warn(dd, fmt, ...) \
 	dev_warn(&(dd)->pcidev->dev, "%s: " fmt, \
-		qib_get_unit_name((dd)->unit), ##__VA_ARGS__)
+		 rvt_get_ibdev_name(&(dd)->verbs_dev.rdi), ##__VA_ARGS__)
 
 #define qib_dev_porterr(dd, port, fmt, ...) \
 	dev_err(&(dd)->pcidev->dev, "%s: IB%u:%u " fmt, \
-		qib_get_unit_name((dd)->unit), (dd)->unit, (port), \
+		rvt_get_ibdev_name(&(dd)->verbs_dev.rdi), (dd)->unit, (port), \
 		##__VA_ARGS__)
 
 #define qib_devinfo(pcidev, fmt, ...) \
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 9b13680..3117cc5 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -81,14 +81,6 @@
 
 struct qlogic_ib_stats qib_stats;
 
-const char *qib_get_unit_name(int unit)
-{
-	static char iname[16];
-
-	snprintf(iname, sizeof(iname), "infinipath%u", unit);
-	return iname;
-}
-
 struct pci_dev *qib_get_pci_dev(struct rvt_dev_info *rdi)
 {
 	struct qib_ibdev *ibdev = container_of(rdi, struct qib_ibdev, rdi);
diff --git a/drivers/infiniband/hw/qib/qib_eeprom.c b/drivers/infiniband/hw/qib/qib_eeprom.c
index 33a2e74..5838b3b 100644
--- a/drivers/infiniband/hw/qib/qib_eeprom.c
+++ b/drivers/infiniband/hw/qib/qib_eeprom.c
@@ -163,8 +163,7 @@ void qib_get_eeprom_info(struct qib_devdata *dd)
 			if (bguid[6] == 0xff) {
 				if (bguid[5] == 0xff) {
 					qib_dev_err(dd,
-						"Can't set %s GUID from base, wraps to OUI!\n",
-						qib_get_unit_name(t));
+						    "Can't set GUID from base, wraps to OUI!\n");
 					dd->base_guid = 0;
 					goto bail;
 				}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
