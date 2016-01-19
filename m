From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/31] staging/rdma/hfi1: Begin to use rdmavt for verbs
Date: Tue, 19 Jan 2016 14:41:33 -0800
Message-ID: <20160119224133.32765.54910.stgit@scvm10.sc.intel.com>
References: <20160119223610.32765.10571.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223610.32765.10571.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch begins to make use of rdmavt by registering with it and
providing access to the header files. This is just the beginning of
rdmavt support in hfi1.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/Kconfig |    2 +-
 drivers/staging/rdma/hfi1/chip.c  |    2 +-
 drivers/staging/rdma/hfi1/diag.c  |    2 +-
 drivers/staging/rdma/hfi1/hfi.h   |    3 +--
 drivers/staging/rdma/hfi1/init.c  |    5 +++--
 drivers/staging/rdma/hfi1/intr.c  |    2 +-
 drivers/staging/rdma/hfi1/mad.c   |    5 +++--
 drivers/staging/rdma/hfi1/qp.c    |    4 ++--
 drivers/staging/rdma/hfi1/sysfs.c |   18 +++++++++---------
 drivers/staging/rdma/hfi1/verbs.c |   15 ++++++++++-----
 drivers/staging/rdma/hfi1/verbs.h |    8 ++++++--
 11 files changed, 38 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/Kconfig b/drivers/staging/rdma/hfi1/Kconfig
index bd0249b..846c240 100644
--- a/drivers/staging/rdma/hfi1/Kconfig
+++ b/drivers/staging/rdma/hfi1/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_HFI1
 	tristate "Intel OPA Gen1 support"
-	depends on X86_64
+	depends on X86_64 && INFINIBAND_RDMAVT
 	select MMU_NOTIFIER
 	default m
 	---help---
diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 63d5d71..da2718f 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -9925,7 +9925,7 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			sdma_all_running(dd);
 
 			/* Signal the IB layer that the port has went active */
-			event.device = &dd->verbs_dev.ibdev;
+			event.device = &dd->verbs_dev.rdi.ibdev;
 			event.element.port_num = ppd->port;
 			event.event = IB_EVENT_PORT_ACTIVE;
 		}
diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 0c88317..fbe9b15 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -860,7 +860,7 @@ static ssize_t hfi1_snoop_write(struct file *fp, const char __user *data,
 			vl = sc4;
 		} else {
 			sl = (byte_two >> 4) & 0xf;
-			ibp = to_iport(&dd->verbs_dev.ibdev, 1);
+			ibp = to_iport(&dd->verbs_dev.rdi.ibdev, 1);
 			sc5 = ibp->sl_to_sc[sl];
 			vl = sc_to_vlt(dd, sc5);
 			if (vl != sc4) {
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 23d7e02..dbea286 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -65,8 +65,7 @@
 #include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
-#include <linux/mmu_notifier.h>
-#include <linux/rbtree.h>
+#include <rdma/rdma_vt.h>
 
 #include "chip_registers.h"
 #include "common.h"
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 27b31fc..b4076b2 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -56,6 +56,7 @@
 #include <linux/module.h>
 #include <linux/printk.h>
 #include <linux/hrtimer.h>
+#include <rdma/rdma_vt.h>
 
 #include "hfi.h"
 #include "device.h"
@@ -983,7 +984,7 @@ void hfi1_free_devdata(struct hfi1_devdata *dd)
 	rcu_barrier(); /* wait for rcu callbacks to complete */
 	free_percpu(dd->int_counter);
 	free_percpu(dd->rcv_limit);
-	ib_dealloc_device(&dd->verbs_dev.ibdev);
+	ib_dealloc_device(&dd->verbs_dev.rdi.ibdev);
 }
 
 /*
@@ -1079,7 +1080,7 @@ struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra)
 bail:
 	if (!list_empty(&dd->list))
 		list_del_init(&dd->list);
-	ib_dealloc_device(&dd->verbs_dev.ibdev);
+	ib_dealloc_device(&dd->verbs_dev.rdi.ibdev);
 	return ERR_PTR(ret);
 }
 
diff --git a/drivers/staging/rdma/hfi1/intr.c b/drivers/staging/rdma/hfi1/intr.c
index 426582b..1283f2d 100644
--- a/drivers/staging/rdma/hfi1/intr.c
+++ b/drivers/staging/rdma/hfi1/intr.c
@@ -98,7 +98,7 @@ static void signal_ib_event(struct hfi1_pportdata *ppd, enum ib_event_type ev)
 	 */
 	if (!(dd->flags & HFI1_INITTED))
 		return;
-	event.device = &dd->verbs_dev.ibdev;
+	event.device = &dd->verbs_dev.rdi.ibdev;
 	event.element.port_num = ppd->port;
 	event.event = ev;
 	ib_dispatch_event(&event);
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index aa84781..ed88a5a 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -1388,7 +1388,7 @@ static int set_pkeys(struct hfi1_devdata *dd, u8 port, u16 *pkeys)
 		(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_PKEYS, 0);
 
 		event.event = IB_EVENT_PKEY_CHANGE;
-		event.device = &dd->verbs_dev.ibdev;
+		event.device = &dd->verbs_dev.rdi.ibdev;
 		event.element.port_num = port;
 		ib_dispatch_event(&event);
 	}
@@ -4171,7 +4171,8 @@ int hfi1_create_agents(struct hfi1_ibdev *dev)
 
 	for (p = 0; p < dd->num_pports; p++) {
 		ibp = &dd->pport[p].ibport_data;
-		agent = ib_register_mad_agent(&dev->ibdev, p + 1, IB_QPT_SMI,
+		agent = ib_register_mad_agent(&dev->rdi.ibdev, p + 1,
+					      IB_QPT_SMI,
 					      NULL, 0, send_handler,
 					      NULL, NULL, 0);
 		if (IS_ERR(agent)) {
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index ce03681..bb447b5 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -1570,7 +1570,7 @@ struct qp_iter *qp_iter_init(struct hfi1_ibdev *dev)
 		return NULL;
 
 	iter->dev = dev;
-	iter->specials = dev->ibdev.phys_port_cnt * 2;
+	iter->specials = dev->rdi.ibdev.phys_port_cnt * 2;
 	if (qp_iter_next(iter)) {
 		kfree(iter);
 		return NULL;
@@ -1610,7 +1610,7 @@ int qp_iter_next(struct qp_iter *iter)
 				struct hfi1_ibport *ibp;
 				int pidx;
 
-				pidx = n % dev->ibdev.phys_port_cnt;
+				pidx = n % dev->rdi.ibdev.phys_port_cnt;
 				ppd = &dd_from_dev(dev)->pport[pidx];
 				ibp = &ppd->ibport_data;
 
diff --git a/drivers/staging/rdma/hfi1/sysfs.c b/drivers/staging/rdma/hfi1/sysfs.c
index 1dd6727..d05b9f3 100644
--- a/drivers/staging/rdma/hfi1/sysfs.c
+++ b/drivers/staging/rdma/hfi1/sysfs.c
@@ -446,7 +446,7 @@ static ssize_t show_rev(struct device *device, struct device_attribute *attr,
 			char *buf)
 {
 	struct hfi1_ibdev *dev =
-		container_of(device, struct hfi1_ibdev, ibdev.dev);
+		container_of(device, struct hfi1_ibdev, rdi.ibdev.dev);
 
 	return sprintf(buf, "%x\n", dd_from_dev(dev)->minrev);
 }
@@ -455,7 +455,7 @@ static ssize_t show_hfi(struct device *device, struct device_attribute *attr,
 			char *buf)
 {
 	struct hfi1_ibdev *dev =
-		container_of(device, struct hfi1_ibdev, ibdev.dev);
+		container_of(device, struct hfi1_ibdev, rdi.ibdev.dev);
 	struct hfi1_devdata *dd = dd_from_dev(dev);
 	int ret;
 
@@ -470,7 +470,7 @@ static ssize_t show_boardversion(struct device *device,
 				 struct device_attribute *attr, char *buf)
 {
 	struct hfi1_ibdev *dev =
-		container_of(device, struct hfi1_ibdev, ibdev.dev);
+		container_of(device, struct hfi1_ibdev, rdi.ibdev.dev);
 	struct hfi1_devdata *dd = dd_from_dev(dev);
 
 	/* The string printed here is already newline-terminated. */
@@ -482,7 +482,7 @@ static ssize_t show_nctxts(struct device *device,
 			   struct device_attribute *attr, char *buf)
 {
 	struct hfi1_ibdev *dev =
-		container_of(device, struct hfi1_ibdev, ibdev.dev);
+		container_of(device, struct hfi1_ibdev, rdi.ibdev.dev);
 	struct hfi1_devdata *dd = dd_from_dev(dev);
 
 	/*
@@ -500,7 +500,7 @@ static ssize_t show_nfreectxts(struct device *device,
 			   struct device_attribute *attr, char *buf)
 {
 	struct hfi1_ibdev *dev =
-		container_of(device, struct hfi1_ibdev, ibdev.dev);
+		container_of(device, struct hfi1_ibdev, rdi.ibdev.dev);
 	struct hfi1_devdata *dd = dd_from_dev(dev);
 
 	/* Return the number of free user ports (contexts) available. */
@@ -511,7 +511,7 @@ static ssize_t show_serial(struct device *device,
 			   struct device_attribute *attr, char *buf)
 {
 	struct hfi1_ibdev *dev =
-		container_of(device, struct hfi1_ibdev, ibdev.dev);
+		container_of(device, struct hfi1_ibdev, rdi.ibdev.dev);
 	struct hfi1_devdata *dd = dd_from_dev(dev);
 
 	return scnprintf(buf, PAGE_SIZE, "%s", dd->serial);
@@ -523,7 +523,7 @@ static ssize_t store_chip_reset(struct device *device,
 				size_t count)
 {
 	struct hfi1_ibdev *dev =
-		container_of(device, struct hfi1_ibdev, ibdev.dev);
+		container_of(device, struct hfi1_ibdev, rdi.ibdev.dev);
 	struct hfi1_devdata *dd = dd_from_dev(dev);
 	int ret;
 
@@ -552,7 +552,7 @@ static ssize_t show_tempsense(struct device *device,
 			      struct device_attribute *attr, char *buf)
 {
 	struct hfi1_ibdev *dev =
-		container_of(device, struct hfi1_ibdev, ibdev.dev);
+		container_of(device, struct hfi1_ibdev, rdi.ibdev.dev);
 	struct hfi1_devdata *dd = dd_from_dev(dev);
 	struct hfi1_temp temp;
 	int ret;
@@ -700,7 +700,7 @@ bail:
  */
 int hfi1_verbs_register_sysfs(struct hfi1_devdata *dd)
 {
-	struct ib_device *dev = &dd->verbs_dev.ibdev;
+	struct ib_device *dev = &dd->verbs_dev.rdi.ibdev;
 	int i, ret;
 
 	for (i = 0; i < ARRAY_SIZE(hfi1_attributes); ++i) {
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 09b8d41..0692ec4 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1903,7 +1903,7 @@ static void verbs_txreq_kmem_cache_ctor(void *obj)
 int hfi1_register_ib_device(struct hfi1_devdata *dd)
 {
 	struct hfi1_ibdev *dev = &dd->verbs_dev;
-	struct ib_device *ibdev = &dev->ibdev;
+	struct ib_device *ibdev = &dev->rdi.ibdev;
 	struct hfi1_pportdata *ppd = dd->pport;
 	unsigned i, lk_tab_size;
 	int ret;
@@ -2069,7 +2069,13 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	strncpy(ibdev->node_desc, init_utsname()->nodename,
 		sizeof(ibdev->node_desc));
 
-	ret = ib_register_device(ibdev, hfi1_create_port_files);
+	/*
+	 * Fill in rvt info object.
+	 */
+	dd->verbs_dev.rdi.driver_f.port_callback = hfi1_create_port_files;
+	dd->verbs_dev.rdi.dparms.props.max_pd = hfi1_max_pds;
+
+	ret = rvt_register_device(&dd->verbs_dev.rdi);
 	if (ret)
 		goto err_reg;
 
@@ -2086,7 +2092,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 err_class:
 	hfi1_free_agents(dev);
 err_agents:
-	ib_unregister_device(ibdev);
+	rvt_unregister_device(&dd->verbs_dev.rdi);
 err_reg:
 err_verbs_txreq:
 	kmem_cache_destroy(dev->verbs_txreq_cache);
@@ -2102,13 +2108,12 @@ bail:
 void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 {
 	struct hfi1_ibdev *dev = &dd->verbs_dev;
-	struct ib_device *ibdev = &dev->ibdev;
 
 	hfi1_verbs_unregister_sysfs(dd);
 
 	hfi1_free_agents(dev);
 
-	ib_unregister_device(ibdev);
+	rvt_unregister_device(&dd->verbs_dev.rdi);
 
 	if (!list_empty(&dev->txwait))
 		dd_dev_err(dd, "txwait list not empty!\n");
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index a163fc2..58fb122 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -62,6 +62,7 @@
 #include <rdma/ib_pack.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_mad.h>
+#include <rdma/rdma_vt.h>
 
 struct hfi1_ctxtdata;
 struct hfi1_pportdata;
@@ -749,7 +750,7 @@ struct hfi1_ibport {
 
 struct hfi1_qp_ibdev;
 struct hfi1_ibdev {
-	struct ib_device ibdev;
+	struct rvt_dev_info rdi; /* Must be first */
 	struct list_head pending_mmaps;
 	spinlock_t mmap_offset_lock; /* protect mmap_offset */
 	u32 mmap_offset;
@@ -843,7 +844,10 @@ static inline struct hfi1_qp *to_iqp(struct ib_qp *ibqp)
 
 static inline struct hfi1_ibdev *to_idev(struct ib_device *ibdev)
 {
-	return container_of(ibdev, struct hfi1_ibdev, ibdev);
+	struct rvt_dev_info *rdi;
+
+	rdi = container_of(ibdev, struct rvt_dev_info, ibdev);
+	return container_of(rdi, struct hfi1_ibdev, rdi);
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
