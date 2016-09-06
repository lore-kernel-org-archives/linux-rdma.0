From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 08/13] IB/hfi1: Fix locking scheme for affinity
 settings
Date: Tue, 06 Sep 2016 04:36:18 -0700
Message-ID: <20160906113559.27413.41290.stgit@scvm10.sc.intel.com>
References: <20160906112758.27413.46860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906112758.27413.46860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Existing locking scheme in affinity.c file using the
&node_affinity.lock spinlock is not very elegant.
We acquire the lock to get hfi1_affinity_node entry,
unlock, and then use the entry without the lock held.
With more functions being added, which access and
modify the entries, this can lead to race conditions.
This patch makes this locking scheme more consistent.
It changes the spinlock to mutex. Since all the code
is executed in a user process context there is no need
for a spinlock. This also allows to keep the lock
not only while we look up for the node affinity entry,
but over the whole section where the entry is being used.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/affinity.c |   91 ++++++++++++++++++---------------
 drivers/infiniband/hw/hfi1/affinity.h |    3 -
 2 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index 0566393..17c805a 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -55,7 +55,7 @@
 
 struct hfi1_affinity_node_list node_affinity = {
 	.list = LIST_HEAD_INIT(node_affinity.list),
-	.lock = __SPIN_LOCK_UNLOCKED(&node_affinity.lock),
+	.lock = __MUTEX_INITIALIZER(node_affinity.lock)
 };
 
 /* Name of IRQ types, indexed by enum irq_type */
@@ -159,14 +159,14 @@ void node_affinity_destroy(void)
 	struct list_head *pos, *q;
 	struct hfi1_affinity_node *entry;
 
-	spin_lock(&node_affinity.lock);
+	mutex_lock(&node_affinity.lock);
 	list_for_each_safe(pos, q, &node_affinity.list) {
 		entry = list_entry(pos, struct hfi1_affinity_node,
 				   list);
 		list_del(pos);
 		kfree(entry);
 	}
-	spin_unlock(&node_affinity.lock);
+	mutex_unlock(&node_affinity.lock);
 	kfree(hfi1_per_node_cntr);
 }
 
@@ -233,9 +233,8 @@ int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 	if (cpumask_first(local_mask) >= nr_cpu_ids)
 		local_mask = topology_core_cpumask(0);
 
-	spin_lock(&node_affinity.lock);
+	mutex_lock(&node_affinity.lock);
 	entry = node_affinity_lookup(dd->node);
-	spin_unlock(&node_affinity.lock);
 
 	/*
 	 * If this is the first time this NUMA node's affinity is used,
@@ -246,6 +245,7 @@ int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 		if (!entry) {
 			dd_dev_err(dd,
 				   "Unable to allocate global affinity node\n");
+			mutex_unlock(&node_affinity.lock);
 			return -ENOMEM;
 		}
 		init_cpu_mask_set(&entry->def_intr);
@@ -302,15 +302,18 @@ int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 					     &entry->general_intr_mask);
 		}
 
-		spin_lock(&node_affinity.lock);
 		node_affinity_add_tail(entry);
-		spin_unlock(&node_affinity.lock);
 	}
-
+	mutex_unlock(&node_affinity.lock);
 	return 0;
 }
 
-int hfi1_get_irq_affinity(struct hfi1_devdata *dd, struct hfi1_msix_entry *msix)
+/*
+ * Function sets the irq affinity for msix.
+ * It *must* be called with node_affinity.lock held.
+ */
+static int get_irq_affinity(struct hfi1_devdata *dd,
+			    struct hfi1_msix_entry *msix)
 {
 	int ret;
 	cpumask_var_t diff;
@@ -328,9 +331,7 @@ int hfi1_get_irq_affinity(struct hfi1_devdata *dd, struct hfi1_msix_entry *msix)
 	if (!ret)
 		return -ENOMEM;
 
-	spin_lock(&node_affinity.lock);
 	entry = node_affinity_lookup(dd->node);
-	spin_unlock(&node_affinity.lock);
 
 	switch (msix->type) {
 	case IRQ_SDMA:
@@ -360,7 +361,6 @@ int hfi1_get_irq_affinity(struct hfi1_devdata *dd, struct hfi1_msix_entry *msix)
 	 * finds its CPU here.
 	 */
 	if (cpu == -1 && set) {
-		spin_lock(&node_affinity.lock);
 		if (cpumask_equal(&set->mask, &set->used)) {
 			/*
 			 * We've used up all the CPUs, bump up the generation
@@ -372,7 +372,6 @@ int hfi1_get_irq_affinity(struct hfi1_devdata *dd, struct hfi1_msix_entry *msix)
 		cpumask_andnot(diff, &set->mask, &set->used);
 		cpu = cpumask_first(diff);
 		cpumask_set_cpu(cpu, &set->used);
-		spin_unlock(&node_affinity.lock);
 	}
 
 	switch (msix->type) {
@@ -395,6 +394,16 @@ int hfi1_get_irq_affinity(struct hfi1_devdata *dd, struct hfi1_msix_entry *msix)
 	return 0;
 }
 
+int hfi1_get_irq_affinity(struct hfi1_devdata *dd, struct hfi1_msix_entry *msix)
+{
+	int ret;
+
+	mutex_lock(&node_affinity.lock);
+	ret = get_irq_affinity(dd, msix);
+	mutex_unlock(&node_affinity.lock);
+	return ret;
+}
+
 void hfi1_put_irq_affinity(struct hfi1_devdata *dd,
 			   struct hfi1_msix_entry *msix)
 {
@@ -402,9 +411,8 @@ void hfi1_put_irq_affinity(struct hfi1_devdata *dd,
 	struct hfi1_ctxtdata *rcd;
 	struct hfi1_affinity_node *entry;
 
-	spin_lock(&node_affinity.lock);
+	mutex_lock(&node_affinity.lock);
 	entry = node_affinity_lookup(dd->node);
-	spin_unlock(&node_affinity.lock);
 
 	switch (msix->type) {
 	case IRQ_SDMA:
@@ -420,21 +428,21 @@ void hfi1_put_irq_affinity(struct hfi1_devdata *dd,
 			set = &entry->rcv_intr;
 		break;
 	default:
+		mutex_unlock(&node_affinity.lock);
 		return;
 	}
 
 	if (set) {
-		spin_lock(&node_affinity.lock);
 		cpumask_andnot(&set->used, &set->used, &msix->mask);
 		if (cpumask_empty(&set->used) && set->gen) {
 			set->gen--;
 			cpumask_copy(&set->used, &set->mask);
 		}
-		spin_unlock(&node_affinity.lock);
 	}
 
 	irq_set_affinity_hint(msix->msix.vector, NULL);
 	cpumask_clear(&msix->mask);
+	mutex_unlock(&node_affinity.lock);
 }
 
 /* This should be called with node_affinity.lock held */
@@ -535,7 +543,7 @@ int hfi1_get_proc_affinity(int node)
 	if (!ret)
 		goto free_available_mask;
 
-	spin_lock(&affinity->lock);
+	mutex_lock(&affinity->lock);
 	/*
 	 * If we've used all available HW threads, clear the mask and start
 	 * overloading.
@@ -643,7 +651,8 @@ int hfi1_get_proc_affinity(int node)
 		cpu = -1;
 	else
 		cpumask_set_cpu(cpu, &set->used);
-	spin_unlock(&affinity->lock);
+
+	mutex_unlock(&affinity->lock);
 	hfi1_cdbg(PROC, "Process assigned to CPU %d", cpu);
 
 	free_cpumask_var(intrs_mask);
@@ -664,19 +673,17 @@ void hfi1_put_proc_affinity(int cpu)
 
 	if (cpu < 0)
 		return;
-	spin_lock(&affinity->lock);
+
+	mutex_lock(&affinity->lock);
 	cpumask_clear_cpu(cpu, &set->used);
 	hfi1_cdbg(PROC, "Returning CPU %d for future process assignment", cpu);
 	if (cpumask_empty(&set->used) && set->gen) {
 		set->gen--;
 		cpumask_copy(&set->used, &set->mask);
 	}
-	spin_unlock(&affinity->lock);
+	mutex_unlock(&affinity->lock);
 }
 
-/* Prevents concurrent reads and writes of the sdma_affinity attrib */
-static DEFINE_MUTEX(sdma_affinity_mutex);
-
 int hfi1_set_sdma_affinity(struct hfi1_devdata *dd, const char *buf,
 			   size_t count)
 {
@@ -684,16 +691,19 @@ int hfi1_set_sdma_affinity(struct hfi1_devdata *dd, const char *buf,
 	cpumask_var_t mask;
 	int ret, i;
 
-	spin_lock(&node_affinity.lock);
+	mutex_lock(&node_affinity.lock);
 	entry = node_affinity_lookup(dd->node);
-	spin_unlock(&node_affinity.lock);
 
-	if (!entry)
-		return -EINVAL;
+	if (!entry) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 
 	ret = zalloc_cpumask_var(&mask, GFP_KERNEL);
-	if (!ret)
-		return -ENOMEM;
+	if (!ret) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
 
 	ret = cpulist_parse(buf, mask);
 	if (ret)
@@ -705,13 +715,11 @@ int hfi1_set_sdma_affinity(struct hfi1_devdata *dd, const char *buf,
 		goto out;
 	}
 
-	mutex_lock(&sdma_affinity_mutex);
 	/* reset the SDMA interrupt affinity details */
 	init_cpu_mask_set(&entry->def_intr);
 	cpumask_copy(&entry->def_intr.mask, mask);
-	/*
-	 * Reassign the affinity for each SDMA interrupt.
-	 */
+
+	/* Reassign the affinity for each SDMA interrupt. */
 	for (i = 0; i < dd->num_msix_entries; i++) {
 		struct hfi1_msix_entry *msix;
 
@@ -719,14 +727,15 @@ int hfi1_set_sdma_affinity(struct hfi1_devdata *dd, const char *buf,
 		if (msix->type != IRQ_SDMA)
 			continue;
 
-		ret = hfi1_get_irq_affinity(dd, msix);
+		ret = get_irq_affinity(dd, msix);
 
 		if (ret)
 			break;
 	}
-	mutex_unlock(&sdma_affinity_mutex);
 out:
 	free_cpumask_var(mask);
+unlock:
+	mutex_unlock(&node_affinity.lock);
 	return ret ? ret : strnlen(buf, PAGE_SIZE);
 }
 
@@ -734,15 +743,15 @@ int hfi1_get_sdma_affinity(struct hfi1_devdata *dd, char *buf)
 {
 	struct hfi1_affinity_node *entry;
 
-	spin_lock(&node_affinity.lock);
+	mutex_lock(&node_affinity.lock);
 	entry = node_affinity_lookup(dd->node);
-	spin_unlock(&node_affinity.lock);
 
-	if (!entry)
+	if (!entry) {
+		mutex_unlock(&node_affinity.lock);
 		return -EINVAL;
+	}
 
-	mutex_lock(&sdma_affinity_mutex);
 	cpumap_print_to_pagebuf(true, buf, &entry->def_intr.mask);
-	mutex_unlock(&sdma_affinity_mutex);
+	mutex_unlock(&node_affinity.lock);
 	return strnlen(buf, PAGE_SIZE);
 }
diff --git a/drivers/infiniband/hw/hfi1/affinity.h b/drivers/infiniband/hw/hfi1/affinity.h
index 8879cf7..b89ea3c 100644
--- a/drivers/infiniband/hw/hfi1/affinity.h
+++ b/drivers/infiniband/hw/hfi1/affinity.h
@@ -121,8 +121,7 @@ struct hfi1_affinity_node_list {
 	int num_core_siblings;
 	int num_online_nodes;
 	int num_online_cpus;
-	/* protect affinity node list */
-	spinlock_t lock;
+	struct mutex lock; /* protects affinity nodes */
 };
 
 int node_affinity_init(void);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
