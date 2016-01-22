From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 01/10] IB/qib: Begin to use rdmavt for verbs
Date: Fri, 22 Jan 2016 12:44:29 -0800
Message-ID: <20160122204424.2022.43236.stgit@scvm10.sc.intel.com>
References: <20160122204145.2022.26449.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122204145.2022.26449.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch begins to make use of rdmavt by registering with it and
providing access to the header files. This is just the beginning of
rdmavt support in qib.

Most functionality is still being done in the driver, set flags so that
rdmavt will let qib continue to handle mr, qp, and cq init.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/Kconfig     |    2 +-
 drivers/infiniband/hw/qib/qib.h       |    1 +
 drivers/infiniband/hw/qib/qib_init.c  |    5 +++--
 drivers/infiniband/hw/qib/qib_intr.c  |    2 +-
 drivers/infiniband/hw/qib/qib_mad.c   |    5 +++--
 drivers/infiniband/hw/qib/qib_sysfs.c |   20 ++++++++++----------
 drivers/infiniband/hw/qib/qib_verbs.c |   19 ++++++++++++++-----
 drivers/infiniband/hw/qib/qib_verbs.h |    8 ++++++--
 8 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/qib/Kconfig b/drivers/infiniband/hw/qib/Kconfig
index 495be09..e0fdb92 100644
--- a/drivers/infiniband/hw/qib/Kconfig
+++ b/drivers/infiniband/hw/qib/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_QIB
 	tristate "Intel PCIe HCA support"
-	depends on 64BIT
+	depends on 64BIT && INFINIBAND_RDMAVT
 	---help---
 	This is a low-level driver for Intel PCIe QLE InfiniBand host
 	channel adapters.  This driver does not support the Intel
diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 7df16f7..0e68e1f 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -52,6 +52,7 @@
 #include <linux/kref.h>
 #include <linux/sched.h>
 #include <linux/kthread.h>
+#include <rdma/rdma_vt.h>
 
 #include "qib_common.h"
 #include "qib_verbs.h"
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 4ff340f..47190f1 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -42,6 +42,7 @@
 #ifdef CONFIG_INFINIBAND_QIB_DCA
 #include <linux/dca.h>
 #endif
+#include <rdma/rdma_vt.h>
 
 #include "qib.h"
 #include "qib_common.h"
@@ -1081,7 +1082,7 @@ void qib_free_devdata(struct qib_devdata *dd)
 	qib_dbg_ibdev_exit(&dd->verbs_dev);
 #endif
 	free_percpu(dd->int_counter);
-	ib_dealloc_device(&dd->verbs_dev.ibdev);
+	ib_dealloc_device(&dd->verbs_dev.rdi.ibdev);
 }
 
 u64 qib_int_counter(struct qib_devdata *dd)
@@ -1171,7 +1172,7 @@ struct qib_devdata *qib_alloc_devdata(struct pci_dev *pdev, size_t extra)
 bail:
 	if (!list_empty(&dd->list))
 		list_del_init(&dd->list);
-	ib_dealloc_device(&dd->verbs_dev.ibdev);
+	ib_dealloc_device(&dd->verbs_dev.rdi.ibdev);
 	return ERR_PTR(ret);
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_intr.c b/drivers/infiniband/hw/qib/qib_intr.c
index 086616d..a014fd4 100644
--- a/drivers/infiniband/hw/qib/qib_intr.c
+++ b/drivers/infiniband/hw/qib/qib_intr.c
@@ -74,7 +74,7 @@ static void signal_ib_event(struct qib_pportdata *ppd, enum ib_event_type ev)
 	struct ib_event event;
 	struct qib_devdata *dd = ppd->dd;
 
-	event.device = &dd->verbs_dev.ibdev;
+	event.device = &dd->verbs_dev.rdi.ibdev;
 	event.element.port_num = ppd->port;
 	event.event = ev;
 	ib_dispatch_event(&event);
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 9625e7c..c65d3aa 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -1028,7 +1028,7 @@ static int set_pkeys(struct qib_devdata *dd, u8 port, u16 *pkeys)
 		(void) dd->f_set_ib_cfg(ppd, QIB_IB_CFG_PKEYS, 0);
 
 		event.event = IB_EVENT_PKEY_CHANGE;
-		event.device = &dd->verbs_dev.ibdev;
+		event.device = &dd->verbs_dev.rdi.ibdev;
 		event.element.port_num = port;
 		ib_dispatch_event(&event);
 	}
@@ -2483,7 +2483,8 @@ int qib_create_agents(struct qib_ibdev *dev)
 
 	for (p = 0; p < dd->num_pports; p++) {
 		ibp = &dd->pport[p].ibport_data;
-		agent = ib_register_mad_agent(&dev->ibdev, p + 1, IB_QPT_SMI,
+		agent = ib_register_mad_agent(&dev->rdi.ibdev, p + 1,
+					      IB_QPT_SMI,
 					      NULL, 0, send_handler,
 					      NULL, NULL, 0);
 		if (IS_ERR(agent)) {
diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index 81f56cd..72a160e 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -502,7 +502,7 @@ static ssize_t show_rev(struct device *device, struct device_attribute *attr,
 			char *buf)
 {
 	struct qib_ibdev *dev =
-		container_of(device, struct qib_ibdev, ibdev.dev);
+		container_of(device, struct qib_ibdev, rdi.ibdev.dev);
 
 	return sprintf(buf, "%x\n", dd_from_dev(dev)->minrev);
 }
@@ -511,7 +511,7 @@ static ssize_t show_hca(struct device *device, struct device_attribute *attr,
 			char *buf)
 {
 	struct qib_ibdev *dev =
-		container_of(device, struct qib_ibdev, ibdev.dev);
+		container_of(device, struct qib_ibdev, rdi.ibdev.dev);
 	struct qib_devdata *dd = dd_from_dev(dev);
 	int ret;
 
@@ -533,7 +533,7 @@ static ssize_t show_boardversion(struct device *device,
 				 struct device_attribute *attr, char *buf)
 {
 	struct qib_ibdev *dev =
-		container_of(device, struct qib_ibdev, ibdev.dev);
+		container_of(device, struct qib_ibdev, rdi.ibdev.dev);
 	struct qib_devdata *dd = dd_from_dev(dev);
 
 	/* The string printed here is already newline-terminated. */
@@ -545,7 +545,7 @@ static ssize_t show_localbus_info(struct device *device,
 				  struct device_attribute *attr, char *buf)
 {
 	struct qib_ibdev *dev =
-		container_of(device, struct qib_ibdev, ibdev.dev);
+		container_of(device, struct qib_ibdev, rdi.ibdev.dev);
 	struct qib_devdata *dd = dd_from_dev(dev);
 
 	/* The string printed here is already newline-terminated. */
@@ -557,7 +557,7 @@ static ssize_t show_nctxts(struct device *device,
 			   struct device_attribute *attr, char *buf)
 {
 	struct qib_ibdev *dev =
-		container_of(device, struct qib_ibdev, ibdev.dev);
+		container_of(device, struct qib_ibdev, rdi.ibdev.dev);
 	struct qib_devdata *dd = dd_from_dev(dev);
 
 	/* Return the number of user ports (contexts) available. */
@@ -572,7 +572,7 @@ static ssize_t show_nfreectxts(struct device *device,
 			   struct device_attribute *attr, char *buf)
 {
 	struct qib_ibdev *dev =
-		container_of(device, struct qib_ibdev, ibdev.dev);
+		container_of(device, struct qib_ibdev, rdi.ibdev.dev);
 	struct qib_devdata *dd = dd_from_dev(dev);
 
 	/* Return the number of free user ports (contexts) available. */
@@ -583,7 +583,7 @@ static ssize_t show_serial(struct device *device,
 			   struct device_attribute *attr, char *buf)
 {
 	struct qib_ibdev *dev =
-		container_of(device, struct qib_ibdev, ibdev.dev);
+		container_of(device, struct qib_ibdev, rdi.ibdev.dev);
 	struct qib_devdata *dd = dd_from_dev(dev);
 
 	buf[sizeof(dd->serial)] = '\0';
@@ -597,7 +597,7 @@ static ssize_t store_chip_reset(struct device *device,
 				size_t count)
 {
 	struct qib_ibdev *dev =
-		container_of(device, struct qib_ibdev, ibdev.dev);
+		container_of(device, struct qib_ibdev, rdi.ibdev.dev);
 	struct qib_devdata *dd = dd_from_dev(dev);
 	int ret;
 
@@ -618,7 +618,7 @@ static ssize_t show_tempsense(struct device *device,
 			      struct device_attribute *attr, char *buf)
 {
 	struct qib_ibdev *dev =
-		container_of(device, struct qib_ibdev, ibdev.dev);
+		container_of(device, struct qib_ibdev, rdi.ibdev.dev);
 	struct qib_devdata *dd = dd_from_dev(dev);
 	int ret;
 	int idx;
@@ -778,7 +778,7 @@ bail:
  */
 int qib_verbs_register_sysfs(struct qib_devdata *dd)
 {
-	struct ib_device *dev = &dd->verbs_dev.ibdev;
+	struct ib_device *dev = &dd->verbs_dev.rdi.ibdev;
 	int i, ret;
 
 	for (i = 0; i < ARRAY_SIZE(qib_attributes); ++i) {
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index baf1e42..f8975ea 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2091,7 +2091,7 @@ static int qib_port_immutable(struct ib_device *ibdev, u8 port_num,
 int qib_register_ib_device(struct qib_devdata *dd)
 {
 	struct qib_ibdev *dev = &dd->verbs_dev;
-	struct ib_device *ibdev = &dev->ibdev;
+	struct ib_device *ibdev = &dev->rdi.ibdev;
 	struct qib_pportdata *ppd = dd->pport;
 	unsigned i, lk_tab_size;
 	int ret;
@@ -2279,7 +2279,17 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	snprintf(ibdev->node_desc, sizeof(ibdev->node_desc),
 		 "Intel Infiniband HCA %s", init_utsname()->nodename);
 
-	ret = ib_register_device(ibdev, qib_create_port_files);
+	/*
+	 * Fill in rvt info object.
+	 */
+	dd->verbs_dev.rdi.driver_f.port_callback = qib_create_port_files;
+	dd->verbs_dev.rdi.dparms.props.max_pd = ib_qib_max_pds;
+	dd->verbs_dev.rdi.flags = (RVT_FLAG_MR_INIT_DRIVER |
+				   RVT_FLAG_QP_INIT_DRIVER |
+				   RVT_FLAG_CQ_INIT_DRIVER);
+
+
+	ret = rvt_register_device(&dd->verbs_dev.rdi);
 	if (ret)
 		goto err_reg;
 
@@ -2296,7 +2306,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 err_class:
 	qib_free_agents(dev);
 err_agents:
-	ib_unregister_device(ibdev);
+	rvt_unregister_device(&dd->verbs_dev.rdi);
 err_reg:
 err_tx:
 	while (!list_empty(&dev->txreq_free)) {
@@ -2325,7 +2335,6 @@ bail:
 void qib_unregister_ib_device(struct qib_devdata *dd)
 {
 	struct qib_ibdev *dev = &dd->verbs_dev;
-	struct ib_device *ibdev = &dev->ibdev;
 	u32 qps_inuse;
 	unsigned lk_tab_size;
 
@@ -2333,7 +2342,7 @@ void qib_unregister_ib_device(struct qib_devdata *dd)
 
 	qib_free_agents(dev);
 
-	ib_unregister_device(ibdev);
+	rvt_unregister_device(&dd->verbs_dev.rdi);
 
 	if (!list_empty(&dev->piowait))
 		qib_dev_err(dd, "piowait list not empty!\n");
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 6c5e777..e175301 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -45,6 +45,7 @@
 #include <linux/completion.h>
 #include <rdma/ib_pack.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/rdma_vt.h>
 
 struct qib_ctxtdata;
 struct qib_pportdata;
@@ -752,7 +753,7 @@ struct qib_ibport {
 
 
 struct qib_ibdev {
-	struct ib_device ibdev;
+	struct rvt_dev_info rdi;
 	struct list_head pending_mmaps;
 	spinlock_t mmap_offset_lock; /* protect mmap_offset */
 	u32 mmap_offset;
@@ -845,7 +846,10 @@ static inline struct qib_qp *to_iqp(struct ib_qp *ibqp)
 
 static inline struct qib_ibdev *to_idev(struct ib_device *ibdev)
 {
-	return container_of(ibdev, struct qib_ibdev, ibdev);
+	struct rvt_dev_info *rdi;
+
+	rdi = container_of(ibdev, struct rvt_dev_info, ibdev);
+	return container_of(rdi, struct qib_ibdev, rdi);
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
