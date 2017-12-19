From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 05/11] IB/{rdmavt, hfi1,
 qib}: Remove get_card_name() downcall
Date: Mon, 18 Dec 2017 19:56:44 -0800
Message-ID: <20171219035642.2126.67593.stgit@scvm10.sc.intel.com>
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

rdmavt has a down call to client drivers to retrieve a crafted card
name.

This name should be the IB defined name.

Rather than craft the name each time it is needed, simply retrieve
the IB allocated name from the IB device.

Update the function name to reflect its application.

Clean up driver code to match this change.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c    |    8 --------
 drivers/infiniband/hw/hfi1/hfi.h       |    1 -
 drivers/infiniband/hw/hfi1/verbs.c     |    1 -
 drivers/infiniband/hw/qib/qib.h        |    1 -
 drivers/infiniband/hw/qib/qib_driver.c |    8 --------
 drivers/infiniband/hw/qib/qib_verbs.c  |    1 -
 drivers/infiniband/sw/rdmavt/trace.h   |    4 ++--
 drivers/infiniband/sw/rdmavt/vt.c      |    1 -
 drivers/infiniband/sw/rdmavt/vt.h      |    6 +++---
 include/rdma/rdma_vt.h                 |   18 +++++++++++-------
 10 files changed, 16 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 4f65ac6..4561719 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -167,14 +167,6 @@ static int hfi1_caps_get(char *buffer, const struct kernel_param *kp)
 	return iname;
 }
 
-const char *get_card_name(struct rvt_dev_info *rdi)
-{
-	struct hfi1_ibdev *ibdev = container_of(rdi, struct hfi1_ibdev, rdi);
-	struct hfi1_devdata *dd = container_of(ibdev,
-					       struct hfi1_devdata, verbs_dev);
-	return get_unit_name(dd->unit);
-}
-
 struct pci_dev *get_pci_dev(struct rvt_dev_info *rdi)
 {
 	struct hfi1_ibdev *ibdev = container_of(rdi, struct hfi1_ibdev, rdi);
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index e12a80b..88fa934 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1976,7 +1976,6 @@ int get_platform_config_field(struct hfi1_devdata *dd,
 			      u32 *data, u32 len);
 
 const char *get_unit_name(int unit);
-const char *get_card_name(struct rvt_dev_info *rdi);
 struct pci_dev *get_pci_dev(struct rvt_dev_info *rdi);
 
 /*
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 81fcff3..e05f843 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1896,7 +1896,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	 * Fill in rvt info object.
 	 */
 	dd->verbs_dev.rdi.driver_f.port_callback = hfi1_create_port_files;
-	dd->verbs_dev.rdi.driver_f.get_card_name = get_card_name;
 	dd->verbs_dev.rdi.driver_f.get_pci_dev = get_pci_dev;
 	dd->verbs_dev.rdi.driver_f.check_ah = hfi1_check_ah;
 	dd->verbs_dev.rdi.driver_f.notify_new_ah = hfi1_notify_new_ah;
diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 092ed81..34c5254 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1429,7 +1429,6 @@ int qib_pcie_ddinit(struct qib_devdata *, struct pci_dev *,
 dma_addr_t qib_map_page(struct pci_dev *, struct page *, unsigned long,
 			  size_t, int);
 const char *qib_get_unit_name(int unit);
-const char *qib_get_card_name(struct rvt_dev_info *rdi);
 struct pci_dev *qib_get_pci_dev(struct rvt_dev_info *rdi);
 
 /*
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 33d3335..9b13680 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -89,14 +89,6 @@
 	return iname;
 }
 
-const char *qib_get_card_name(struct rvt_dev_info *rdi)
-{
-	struct qib_ibdev *ibdev = container_of(rdi, struct qib_ibdev, rdi);
-	struct qib_devdata *dd = container_of(ibdev,
-					      struct qib_devdata, verbs_dev);
-	return qib_get_unit_name(dd->unit);
-}
-
 struct pci_dev *qib_get_pci_dev(struct rvt_dev_info *rdi)
 {
 	struct qib_ibdev *ibdev = container_of(rdi, struct qib_ibdev, rdi);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 373b80b..fabee76 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1585,7 +1585,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	 * Fill in rvt info object.
 	 */
 	dd->verbs_dev.rdi.driver_f.port_callback = qib_create_port_files;
-	dd->verbs_dev.rdi.driver_f.get_card_name = qib_get_card_name;
 	dd->verbs_dev.rdi.driver_f.get_pci_dev = qib_get_pci_dev;
 	dd->verbs_dev.rdi.driver_f.check_ah = qib_check_ah;
 	dd->verbs_dev.rdi.driver_f.check_send_wqe = qib_check_send_wqe;
diff --git a/drivers/infiniband/sw/rdmavt/trace.h b/drivers/infiniband/sw/rdmavt/trace.h
index bb4b1e7..36ddbd2 100644
--- a/drivers/infiniband/sw/rdmavt/trace.h
+++ b/drivers/infiniband/sw/rdmavt/trace.h
@@ -45,8 +45,8 @@
  *
  */
 
-#define RDI_DEV_ENTRY(rdi)   __string(dev, rdi->driver_f.get_card_name(rdi))
-#define RDI_DEV_ASSIGN(rdi)  __assign_str(dev, rdi->driver_f.get_card_name(rdi))
+#define RDI_DEV_ENTRY(rdi)   __string(dev, rvt_get_ibdev_name(rdi))
+#define RDI_DEV_ASSIGN(rdi)  __assign_str(dev, rvt_get_ibdev_name(rdi))
 
 #include "trace_rvt.h"
 #include "trace_qp.h"
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 64bdd44..088fb2d 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -413,7 +413,6 @@ static noinline int check_support(struct rvt_dev_info *rdi, int verb)
 		 * required for rdmavt to function.
 		 */
 		if ((!rdi->driver_f.port_callback) ||
-		    (!rdi->driver_f.get_card_name) ||
 		    (!rdi->driver_f.get_pci_dev))
 			return -EINVAL;
 		break;
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index f363505..8823b2e 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -63,19 +63,19 @@
 
 #define rvt_pr_info(rdi, fmt, ...) \
 	__rvt_pr_info(rdi->driver_f.get_pci_dev(rdi), \
-		      rdi->driver_f.get_card_name(rdi), \
+		      rvt_get_ibdev_name(rdi), \
 		      fmt, \
 		      ##__VA_ARGS__)
 
 #define rvt_pr_warn(rdi, fmt, ...) \
 	__rvt_pr_warn(rdi->driver_f.get_pci_dev(rdi), \
-		      rdi->driver_f.get_card_name(rdi), \
+		      rvt_get_ibdev_name(rdi), \
 		      fmt, \
 		      ##__VA_ARGS__)
 
 #define rvt_pr_err(rdi, fmt, ...) \
 	__rvt_pr_err(rdi->driver_f.get_pci_dev(rdi), \
-		     rdi->driver_f.get_card_name(rdi), \
+		     rvt_get_ibdev_name(rdi), \
 		     fmt, \
 		     ##__VA_ARGS__)
 
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index b57784e..4118324 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -228,13 +228,6 @@ struct rvt_driver_provided {
 	int (*port_callback)(struct ib_device *, u8, struct kobject *);
 
 	/*
-	 * Returns a string to represent the device for which is being
-	 * registered. This is primarily used for error and debug messages on
-	 * the console.
-	 */
-	const char * (*get_card_name)(struct rvt_dev_info *rdi);
-
-	/*
 	 * Returns a pointer to the undelying hardware's PCI device. This is
 	 * used to display information as to what hardware is being referenced
 	 * in an output message
@@ -432,6 +425,17 @@ static inline void rvt_set_ibdev_name(struct rvt_dev_info *rdi,
 	snprintf(rdi->ibdev.name, sizeof(rdi->ibdev.name), fmt, name, unit);
 }
 
+/**
+ * rvt_get_ibdev_name - return the IB name
+ * @rdi: rdmavt device
+ *
+ * Return the registered name of the device.
+ */
+static inline const char *rvt_get_ibdev_name(const struct rvt_dev_info *rdi)
+{
+	return rdi->ibdev.name;
+}
+
 static inline struct rvt_pd *ibpd_to_rvtpd(struct ib_pd *ibpd)
 {
 	return container_of(ibpd, struct rvt_pd, ibpd);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
