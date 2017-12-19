From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 04/11] IB/{rdmavt, hfi1,
 qib}: Self determine driver name
Date: Mon, 18 Dec 2017 19:56:37 -0800
Message-ID: <20171219035635.2126.59763.stgit@scvm10.sc.intel.com>
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

Currently the HFI and QIB drivers allow the IB core to assign a unit
number to the driver name string.

If multiple devices exist in a system, there is a possibility that the
device unit number and the IB core number will be mismatched.

Fix by using the driver defined unit number to generate the device
name.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/init.c     |    2 ++
 drivers/infiniband/hw/hfi1/verbs.c    |    3 ---
 drivers/infiniband/hw/qib/qib_init.c  |    2 ++
 drivers/infiniband/hw/qib/qib_verbs.c |    1 -
 include/rdma/rdma_vt.h                |   13 +++++++++++++
 5 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index c84af52..a86ad2d 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1285,6 +1285,8 @@ struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra)
 			       "Could not allocate unit ID: error %d\n", -ret);
 		goto bail;
 	}
+	rvt_set_ibdev_name(&dd->verbs_dev.rdi, "%s_%d", class_name(), dd->unit);
+
 	/*
 	 * Initialize all locks for the device. This needs to be as early as
 	 * possible so locks are usable.
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 2487190..81fcff3 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1850,7 +1850,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	struct hfi1_ibport *ibp = &ppd->ibport_data;
 	unsigned i;
 	int ret;
-	size_t lcpysz = IB_DEVICE_NAME_MAX;
 
 	for (i = 0; i < dd->num_pports; i++)
 		init_ibport(ppd + i);
@@ -1878,8 +1877,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	 */
 	if (!ib_hfi1_sys_image_guid)
 		ib_hfi1_sys_image_guid = ibdev->node_guid;
-	lcpysz = strlcpy(ibdev->name, class_name(), lcpysz);
-	strlcpy(ibdev->name + lcpysz, "_%d", IB_DEVICE_NAME_MAX - lcpysz);
 	ibdev->owner = THIS_MODULE;
 	ibdev->phys_port_cnt = dd->num_pports;
 	ibdev->dev.parent = &dd->pcidev->dev;
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 5243ad3..4f9d38b 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -1119,6 +1119,8 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 			      "Could not allocate unit ID: error %d\n", -ret);
 		goto bail;
 	}
+	rvt_set_ibdev_name(&dd->verbs_dev.rdi, "%s%d", "qib", dd->unit);
+
 	dd->int_counter = alloc_percpu(u64);
 	if (!dd->int_counter) {
 		ret = -ENOMEM;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index c550005..373b80b 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1571,7 +1571,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	if (!ib_qib_sys_image_guid)
 		ib_qib_sys_image_guid = ppd->guid;
 
-	strlcpy(ibdev->name, "qib%d", IB_DEVICE_NAME_MAX);
 	ibdev->owner = THIS_MODULE;
 	ibdev->node_guid = ppd->guid;
 	ibdev->phys_port_cnt = dd->num_pports;
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 1ba84a7..b57784e 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -419,6 +419,19 @@ struct rvt_dev_info {
 
 };
 
+/**
+ * rvt_set_ibdev_name - Craft an IB device name from client info
+ * @rdi: pointer to the client rvt_dev_info structure
+ * @name: client specific name
+ * @unit: client specific unit number.
+ */
+static inline void rvt_set_ibdev_name(struct rvt_dev_info *rdi,
+				      const char *fmt, const char *name,
+				      const int unit)
+{
+	snprintf(rdi->ibdev.name, sizeof(rdi->ibdev.name), fmt, name, unit);
+}
+
 static inline struct rvt_pd *ibpd_to_rvtpd(struct ib_pd *ibpd)
 {
 	return container_of(ibpd, struct rvt_pd, ibpd);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
