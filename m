From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 16/28] IB/hfi1: Add sysfs entry to override SDMA interrupt
 affinity
Date: Mon, 25 Jul 2016 13:39:27 -0700
Message-ID: <20160725203926.4800.70331.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add sysfs entry to allow user to override affinity for SDMA
engine interrupts.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/affinity.c |   68 +++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/affinity.h |    4 ++
 drivers/infiniband/hw/hfi1/sysfs.c    |   25 ++++++++++++
 3 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index c9dcbd5..79575ee 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -47,6 +47,7 @@
 #include <linux/topology.h>
 #include <linux/cpumask.h>
 #include <linux/module.h>
+#include <linux/cpumask.h>
 
 #include "hfi.h"
 #include "affinity.h"
@@ -673,3 +674,70 @@ void hfi1_put_proc_affinity(int cpu)
 	}
 	spin_unlock(&affinity->lock);
 }
+
+/* Prevents concurrent reads and writes of the sdma_affinity attrib */
+static DEFINE_MUTEX(sdma_affinity_mutex);
+
+int hfi1_set_sdma_affinity(struct hfi1_devdata *dd, const char *buf,
+			   size_t count)
+{
+	struct hfi1_affinity_node *entry;
+	struct cpumask mask;
+	int ret, i;
+
+	spin_lock(&node_affinity.lock);
+	entry = node_affinity_lookup(dd->node);
+	spin_unlock(&node_affinity.lock);
+
+	if (!entry)
+		return -EINVAL;
+
+	ret = cpulist_parse(buf, &mask);
+	if (ret)
+		return ret;
+
+	if (!cpumask_subset(&mask, cpu_online_mask) || cpumask_empty(&mask)) {
+		dd_dev_warn(dd, "Invalid CPU mask\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&sdma_affinity_mutex);
+	/* reset the SDMA interrupt affinity details */
+	init_cpu_mask_set(&entry->def_intr);
+	cpumask_copy(&entry->def_intr.mask, &mask);
+	/*
+	 * Reassign the affinity for each SDMA interrupt.
+	 */
+	for (i = 0; i < dd->num_msix_entries; i++) {
+		struct hfi1_msix_entry *msix;
+
+		msix = &dd->msix_entries[i];
+		if (msix->type != IRQ_SDMA)
+			continue;
+
+		ret = hfi1_get_irq_affinity(dd, msix);
+
+		if (ret)
+			break;
+	}
+
+	mutex_unlock(&sdma_affinity_mutex);
+	return ret ? ret : strnlen(buf, PAGE_SIZE);
+}
+
+int hfi1_get_sdma_affinity(struct hfi1_devdata *dd, char *buf)
+{
+	struct hfi1_affinity_node *entry;
+
+	spin_lock(&node_affinity.lock);
+	entry = node_affinity_lookup(dd->node);
+	spin_unlock(&node_affinity.lock);
+
+	if (!entry)
+		return -EINVAL;
+
+	mutex_lock(&sdma_affinity_mutex);
+	cpumap_print_to_pagebuf(true, buf, &entry->def_intr.mask);
+	mutex_unlock(&sdma_affinity_mutex);
+	return strnlen(buf, PAGE_SIZE);
+}
diff --git a/drivers/infiniband/hw/hfi1/affinity.h b/drivers/infiniband/hw/hfi1/affinity.h
index f784de5..8879cf7 100644
--- a/drivers/infiniband/hw/hfi1/affinity.h
+++ b/drivers/infiniband/hw/hfi1/affinity.h
@@ -102,6 +102,10 @@ int hfi1_get_proc_affinity(int);
 /* Release a CPU used by a user process. */
 void hfi1_put_proc_affinity(int);
 
+int hfi1_get_sdma_affinity(struct hfi1_devdata *dd, char *buf);
+int hfi1_set_sdma_affinity(struct hfi1_devdata *dd, const char *buf,
+			   size_t count);
+
 struct hfi1_affinity_node {
 	int node;
 	struct cpu_mask_set def_intr;
diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sysfs.c
index 91fc2ae..74c84c6 100644
--- a/drivers/infiniband/hw/hfi1/sysfs.c
+++ b/drivers/infiniband/hw/hfi1/sysfs.c
@@ -49,6 +49,7 @@
 #include "hfi.h"
 #include "mad.h"
 #include "trace.h"
+#include "affinity.h"
 
 /*
  * Start of per-port congestion control structures and support code
@@ -622,6 +623,27 @@ static ssize_t show_tempsense(struct device *device,
 	return ret;
 }
 
+static ssize_t show_sdma_affinity(struct device *device,
+				  struct device_attribute *attr, char *buf)
+{
+	struct hfi1_ibdev *dev =
+		container_of(device, struct hfi1_ibdev, rdi.ibdev.dev);
+	struct hfi1_devdata *dd = dd_from_dev(dev);
+
+	return hfi1_get_sdma_affinity(dd, buf);
+}
+
+static ssize_t store_sdma_affinity(struct device *device,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	struct hfi1_ibdev *dev =
+		container_of(device, struct hfi1_ibdev, rdi.ibdev.dev);
+	struct hfi1_devdata *dd = dd_from_dev(dev);
+
+	return hfi1_set_sdma_affinity(dd, buf, count);
+}
+
 /*
  * end of per-unit (or driver, in some cases, but replicated
  * per unit) functions
@@ -636,6 +658,8 @@ static DEVICE_ATTR(serial, S_IRUGO, show_serial, NULL);
 static DEVICE_ATTR(boardversion, S_IRUGO, show_boardversion, NULL);
 static DEVICE_ATTR(tempsense, S_IRUGO, show_tempsense, NULL);
 static DEVICE_ATTR(chip_reset, S_IWUSR, NULL, store_chip_reset);
+static DEVICE_ATTR(sdma_affinity, S_IWUSR | S_IRUGO, show_sdma_affinity,
+		   store_sdma_affinity);
 
 static struct device_attribute *hfi1_attributes[] = {
 	&dev_attr_hw_rev,
@@ -646,6 +670,7 @@ static struct device_attribute *hfi1_attributes[] = {
 	&dev_attr_boardversion,
 	&dev_attr_tempsense,
 	&dev_attr_chip_reset,
+	&dev_attr_sdma_affinity,
 };
 
 int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
