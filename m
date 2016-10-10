From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/6] IB/hfi1: Remove redundant sysfs irq affinity entry
Date: Mon, 10 Oct 2016 06:14:50 -0700
Message-ID: <20161010131450.17586.15776.stgit@scvm10.sc.intel.com>
References: <20161010131249.17586.23789.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161010131249.17586.23789.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The IRQ affinity entry is not needed after the irq notifier patch has been
added to the hfi1 driver.
The irq affinity settings for SDMA engine should be set using the standard
/proc/irq/<N>/ interface.

Reviewed-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/affinity.c |   72 ---------------------------------
 drivers/infiniband/hw/hfi1/affinity.h |    4 --
 drivers/infiniband/hw/hfi1/sysfs.c    |   25 -----------
 3 files changed, 0 insertions(+), 101 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index a26a9a0..67ea85a 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -775,75 +775,3 @@ void hfi1_put_proc_affinity(int cpu)
 	}
 	mutex_unlock(&affinity->lock);
 }
-
-int hfi1_set_sdma_affinity(struct hfi1_devdata *dd, const char *buf,
-			   size_t count)
-{
-	struct hfi1_affinity_node *entry;
-	cpumask_var_t mask;
-	int ret, i;
-
-	mutex_lock(&node_affinity.lock);
-	entry = node_affinity_lookup(dd->node);
-
-	if (!entry) {
-		ret = -EINVAL;
-		goto unlock;
-	}
-
-	ret = zalloc_cpumask_var(&mask, GFP_KERNEL);
-	if (!ret) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
-
-	ret = cpulist_parse(buf, mask);
-	if (ret)
-		goto out;
-
-	if (!cpumask_subset(mask, cpu_online_mask) || cpumask_empty(mask)) {
-		dd_dev_warn(dd, "Invalid CPU mask\n");
-		ret = -EINVAL;
-		goto out;
-	}
-
-	/* reset the SDMA interrupt affinity details */
-	init_cpu_mask_set(&entry->def_intr);
-	cpumask_copy(&entry->def_intr.mask, mask);
-
-	/* Reassign the affinity for each SDMA interrupt. */
-	for (i = 0; i < dd->num_msix_entries; i++) {
-		struct hfi1_msix_entry *msix;
-
-		msix = &dd->msix_entries[i];
-		if (msix->type != IRQ_SDMA)
-			continue;
-
-		ret = get_irq_affinity(dd, msix);
-
-		if (ret)
-			break;
-	}
-out:
-	free_cpumask_var(mask);
-unlock:
-	mutex_unlock(&node_affinity.lock);
-	return ret ? ret : strnlen(buf, PAGE_SIZE);
-}
-
-int hfi1_get_sdma_affinity(struct hfi1_devdata *dd, char *buf)
-{
-	struct hfi1_affinity_node *entry;
-
-	mutex_lock(&node_affinity.lock);
-	entry = node_affinity_lookup(dd->node);
-
-	if (!entry) {
-		mutex_unlock(&node_affinity.lock);
-		return -EINVAL;
-	}
-
-	cpumap_print_to_pagebuf(true, buf, &entry->def_intr.mask);
-	mutex_unlock(&node_affinity.lock);
-	return strnlen(buf, PAGE_SIZE);
-}
diff --git a/drivers/infiniband/hw/hfi1/affinity.h b/drivers/infiniband/hw/hfi1/affinity.h
index b89ea3c..42e6331 100644
--- a/drivers/infiniband/hw/hfi1/affinity.h
+++ b/drivers/infiniband/hw/hfi1/affinity.h
@@ -102,10 +102,6 @@ int hfi1_get_proc_affinity(int);
 /* Release a CPU used by a user process. */
 void hfi1_put_proc_affinity(int);
 
-int hfi1_get_sdma_affinity(struct hfi1_devdata *dd, char *buf);
-int hfi1_set_sdma_affinity(struct hfi1_devdata *dd, const char *buf,
-			   size_t count);
-
 struct hfi1_affinity_node {
 	int node;
 	struct cpu_mask_set def_intr;
diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sysfs.c
index edba224..919a547 100644
--- a/drivers/infiniband/hw/hfi1/sysfs.c
+++ b/drivers/infiniband/hw/hfi1/sysfs.c
@@ -49,7 +49,6 @@
 #include "hfi.h"
 #include "mad.h"
 #include "trace.h"
-#include "affinity.h"
 
 /*
  * Start of per-port congestion control structures and support code
@@ -623,27 +622,6 @@ static ssize_t show_tempsense(struct device *device,
 	return ret;
 }
 
-static ssize_t show_sdma_affinity(struct device *device,
-				  struct device_attribute *attr, char *buf)
-{
-	struct hfi1_ibdev *dev =
-		container_of(device, struct hfi1_ibdev, rdi.ibdev.dev);
-	struct hfi1_devdata *dd = dd_from_dev(dev);
-
-	return hfi1_get_sdma_affinity(dd, buf);
-}
-
-static ssize_t store_sdma_affinity(struct device *device,
-				   struct device_attribute *attr,
-				   const char *buf, size_t count)
-{
-	struct hfi1_ibdev *dev =
-		container_of(device, struct hfi1_ibdev, rdi.ibdev.dev);
-	struct hfi1_devdata *dd = dd_from_dev(dev);
-
-	return hfi1_set_sdma_affinity(dd, buf, count);
-}
-
 /*
  * end of per-unit (or driver, in some cases, but replicated
  * per unit) functions
@@ -658,8 +636,6 @@ static DEVICE_ATTR(serial, S_IRUGO, show_serial, NULL);
 static DEVICE_ATTR(boardversion, S_IRUGO, show_boardversion, NULL);
 static DEVICE_ATTR(tempsense, S_IRUGO, show_tempsense, NULL);
 static DEVICE_ATTR(chip_reset, S_IWUSR, NULL, store_chip_reset);
-static DEVICE_ATTR(sdma_affinity, S_IWUSR | S_IRUGO, show_sdma_affinity,
-		   store_sdma_affinity);
 
 static struct device_attribute *hfi1_attributes[] = {
 	&dev_attr_hw_rev,
@@ -670,7 +646,6 @@ static struct device_attribute *hfi1_attributes[] = {
 	&dev_attr_boardversion,
 	&dev_attr_tempsense,
 	&dev_attr_chip_reset,
-	&dev_attr_sdma_affinity,
 };
 
 int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
