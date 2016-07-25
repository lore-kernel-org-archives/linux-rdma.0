From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] IB/hfi1: Add global structure for affinity assignments
Date: Mon, 25 Jul 2016 07:52:36 -0700
Message-ID: <20160725145235.25070.78546.stgit@scvm10.sc.intel.com>
References: <20160701230127.20160.68709.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701230127.20160.68709.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When HFI units get initialized, they each use their own mask copy for
affinity assignments. On a multi-HFI system, affinity assignments
overbook CPU cores as each HFI doesn't have knowledge of affinity
assignments for other HFI units. Therefore, some CPU cores are never
used for interrupt handlers in systems with high number of CPU cores
per NUMA node.

For multi-HFI systems, SDMA engine interrupt assignments start all over
from the first CPU in the local NUMA node after the first HFI
initialization. This change allows assignments to continue where the
last HFI unit left off.

Add global structure for affinity assignments for multiple HFIs to share
affinity mask.

Reviewed-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--

changes since v1:
-----------------
Remove char buf[] that was accidentally put back after being removed in another
patch [1]. Also patch up one of the trace messages to not need scnprintf().

[1]
https://git.kernel.org/cgit/linux/kernel/git/dledford/rdma.git/commit/?id=f242d93ae92032f78840471e5c2bfc2d04ae324c
---
 drivers/infiniband/hw/hfi1/affinity.c |  245 +++++++++++++++++++++++----------
 drivers/infiniband/hw/hfi1/affinity.h |   25 +++
 drivers/infiniband/hw/hfi1/chip.c     |   20 +--
 drivers/infiniband/hw/hfi1/init.c     |    5 +
 4 files changed, 198 insertions(+), 97 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index 14d7eeb..1647699 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -53,6 +53,11 @@
 #include "sdma.h"
 #include "trace.h"
 
+struct hfi1_affinity_node_list node_affinity = {
+	.list = LIST_HEAD_INIT(node_affinity.list),
+	.lock = __SPIN_LOCK_UNLOCKED(&node_affinity.lock),
+};
+
 /* Name of IRQ types, indexed by enum irq_type */
 static const char * const irq_type_names[] = {
 	"SDMA",
@@ -69,45 +74,100 @@ static inline void init_cpu_mask_set(struct cpu_mask_set *set)
 }
 
 /* Initialize non-HT cpu cores mask */
-int init_real_cpu_mask(struct hfi1_devdata *dd)
+void init_real_cpu_mask(void)
 {
-	struct hfi1_affinity *info;
 	int possible, curr_cpu, i, ht;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
-
-	cpumask_clear(&info->real_cpu_mask);
+	cpumask_clear(&node_affinity.real_cpu_mask);
 
 	/* Start with cpu online mask as the real cpu mask */
-	cpumask_copy(&info->real_cpu_mask, cpu_online_mask);
+	cpumask_copy(&node_affinity.real_cpu_mask, cpu_online_mask);
 
 	/*
 	 * Remove HT cores from the real cpu mask.  Do this in two steps below.
 	 */
-	possible = cpumask_weight(&info->real_cpu_mask);
+	possible = cpumask_weight(&node_affinity.real_cpu_mask);
 	ht = cpumask_weight(topology_sibling_cpumask(
-					cpumask_first(&info->real_cpu_mask)));
+				cpumask_first(&node_affinity.real_cpu_mask)));
 	/*
 	 * Step 1.  Skip over the first N HT siblings and use them as the
 	 * "real" cores.  Assumes that HT cores are not enumerated in
 	 * succession (except in the single core case).
 	 */
-	curr_cpu = cpumask_first(&info->real_cpu_mask);
+	curr_cpu = cpumask_first(&node_affinity.real_cpu_mask);
 	for (i = 0; i < possible / ht; i++)
-		curr_cpu = cpumask_next(curr_cpu, &info->real_cpu_mask);
+		curr_cpu = cpumask_next(curr_cpu, &node_affinity.real_cpu_mask);
 	/*
 	 * Step 2.  Remove the remaining HT siblings.  Use cpumask_next() to
 	 * skip any gaps.
 	 */
 	for (; i < possible; i++) {
-		cpumask_clear_cpu(curr_cpu, &info->real_cpu_mask);
-		curr_cpu = cpumask_next(curr_cpu, &info->real_cpu_mask);
+		cpumask_clear_cpu(curr_cpu, &node_affinity.real_cpu_mask);
+		curr_cpu = cpumask_next(curr_cpu, &node_affinity.real_cpu_mask);
 	}
+}
 
-	dd->affinity = info;
-	return 0;
+void node_affinity_init(void)
+{
+	cpumask_copy(&node_affinity.proc.mask, cpu_online_mask);
+	/*
+	 * The real cpu mask is part of the affinity struct but it has to be
+	 * initialized early. It is needed to calculate the number of user
+	 * contexts in set_up_context_variables().
+	 */
+	init_real_cpu_mask();
+}
+
+void node_affinity_destroy(void)
+{
+	struct list_head *pos, *q;
+	struct hfi1_affinity_node *entry;
+
+	spin_lock(&node_affinity.lock);
+	list_for_each_safe(pos, q, &node_affinity.list) {
+		entry = list_entry(pos, struct hfi1_affinity_node,
+				   list);
+		list_del(pos);
+		kfree(entry);
+	}
+	spin_unlock(&node_affinity.lock);
+}
+
+static struct hfi1_affinity_node *node_affinity_allocate(int node)
+{
+	struct hfi1_affinity_node *entry;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return NULL;
+	entry->node = node;
+	INIT_LIST_HEAD(&entry->list);
+
+	return entry;
+}
+
+/*
+ * It appends an entry to the list.
+ * It *must* be called with node_affinity.lock held.
+ */
+static void node_affinity_add_tail(struct hfi1_affinity_node *entry)
+{
+	list_add_tail(&entry->list, &node_affinity.list);
+}
+
+/* It must be called with node_affinity.lock held */
+static struct hfi1_affinity_node *node_affinity_lookup(int node)
+{
+	struct list_head *pos;
+	struct hfi1_affinity_node *entry;
+
+	list_for_each(pos, &node_affinity.list) {
+		entry = list_entry(pos, struct hfi1_affinity_node, list);
+		if (entry->node == node)
+			return entry;
+	}
+
+	return NULL;
 }
 
 /*
@@ -121,10 +181,10 @@ int init_real_cpu_mask(struct hfi1_devdata *dd)
  * to the node relative 1 as necessary.
  *
  */
-void hfi1_dev_affinity_init(struct hfi1_devdata *dd)
+int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 {
 	int node = pcibus_to_node(dd->pcidev->bus);
-	struct hfi1_affinity *info = dd->affinity;
+	struct hfi1_affinity_node *entry;
 	const struct cpumask *local_mask;
 	int curr_cpu, possible, i;
 
@@ -132,55 +192,75 @@ void hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 		node = numa_node_id();
 	dd->node = node;
 
-	spin_lock_init(&info->lock);
-
-	init_cpu_mask_set(&info->def_intr);
-	init_cpu_mask_set(&info->rcv_intr);
-	init_cpu_mask_set(&info->proc);
-
 	local_mask = cpumask_of_node(dd->node);
 	if (cpumask_first(local_mask) >= nr_cpu_ids)
 		local_mask = topology_core_cpumask(0);
-	/* Use the "real" cpu mask of this node as the default */
-	cpumask_and(&info->def_intr.mask, &info->real_cpu_mask, local_mask);
-
-	/*  fill in the receive list */
-	possible = cpumask_weight(&info->def_intr.mask);
-	curr_cpu = cpumask_first(&info->def_intr.mask);
-	if (possible == 1) {
-		/*  only one CPU, everyone will use it */
-		cpumask_set_cpu(curr_cpu, &info->rcv_intr.mask);
-	} else {
-		/*
-		 * Retain the first CPU in the default list for the control
-		 * context.
-		 */
-		curr_cpu = cpumask_next(curr_cpu, &info->def_intr.mask);
-		/*
-		 * Remove the remaining kernel receive queues from
-		 * the default list and add them to the receive list.
-		 */
-		for (i = 0; i < dd->n_krcv_queues - 1; i++) {
-			cpumask_clear_cpu(curr_cpu, &info->def_intr.mask);
-			cpumask_set_cpu(curr_cpu, &info->rcv_intr.mask);
-			curr_cpu = cpumask_next(curr_cpu, &info->def_intr.mask);
-			if (curr_cpu >= nr_cpu_ids)
-				break;
+
+	spin_lock(&node_affinity.lock);
+	entry = node_affinity_lookup(dd->node);
+	spin_unlock(&node_affinity.lock);
+
+	/*
+	 * If this is the first time this NUMA node's affinity is used,
+	 * create an entry in the global affinity structure and initialize it.
+	 */
+	if (!entry) {
+		entry = node_affinity_allocate(node);
+		if (!entry) {
+			dd_dev_err(dd,
+				   "Unable to allocate global affinity node\n");
+			return -ENOMEM;
 		}
-	}
+		init_cpu_mask_set(&entry->def_intr);
+		init_cpu_mask_set(&entry->rcv_intr);
+		/* Use the "real" cpu mask of this node as the default */
+		cpumask_and(&entry->def_intr.mask, &node_affinity.real_cpu_mask,
+			    local_mask);
+
+		/* fill in the receive list */
+		possible = cpumask_weight(&entry->def_intr.mask);
+		curr_cpu = cpumask_first(&entry->def_intr.mask);
+
+		if (possible == 1) {
+			/* only one CPU, everyone will use it */
+			cpumask_set_cpu(curr_cpu, &entry->rcv_intr.mask);
+		} else {
+			/*
+			 * Retain the first CPU in the default list for the
+			 * control context.
+			 */
+			curr_cpu = cpumask_next(curr_cpu,
+						&entry->def_intr.mask);
 
-	cpumask_copy(&info->proc.mask, cpu_online_mask);
-}
+			/*
+			 * Remove the remaining kernel receive queues from
+			 * the default list and add them to the receive list.
+			 */
+			for (i = 0; i < dd->n_krcv_queues - 1; i++) {
+				cpumask_clear_cpu(curr_cpu,
+						  &entry->def_intr.mask);
+				cpumask_set_cpu(curr_cpu,
+						&entry->rcv_intr.mask);
+				curr_cpu = cpumask_next(curr_cpu,
+							&entry->def_intr.mask);
+				if (curr_cpu >= nr_cpu_ids)
+					break;
+			}
+		}
 
-void hfi1_dev_affinity_free(struct hfi1_devdata *dd)
-{
-	kfree(dd->affinity);
+		spin_lock(&node_affinity.lock);
+		node_affinity_add_tail(entry);
+		spin_unlock(&node_affinity.lock);
+	}
+
+	return 0;
 }
 
 int hfi1_get_irq_affinity(struct hfi1_devdata *dd, struct hfi1_msix_entry *msix)
 {
 	int ret;
 	cpumask_var_t diff;
+	struct hfi1_affinity_node *entry;
 	struct cpu_mask_set *set;
 	struct sdma_engine *sde = NULL;
 	struct hfi1_ctxtdata *rcd = NULL;
@@ -194,21 +274,25 @@ int hfi1_get_irq_affinity(struct hfi1_devdata *dd, struct hfi1_msix_entry *msix)
 	if (!ret)
 		return -ENOMEM;
 
+	spin_lock(&node_affinity.lock);
+	entry = node_affinity_lookup(dd->node);
+	spin_unlock(&node_affinity.lock);
+
 	switch (msix->type) {
 	case IRQ_SDMA:
 		sde = (struct sdma_engine *)msix->arg;
 		scnprintf(extra, 64, "engine %u", sde->this_idx);
 		/* fall through */
 	case IRQ_GENERAL:
-		set = &dd->affinity->def_intr;
+		set = &entry->def_intr;
 		break;
 	case IRQ_RCVCTXT:
 		rcd = (struct hfi1_ctxtdata *)msix->arg;
 		if (rcd->ctxt == HFI1_CTRL_CTXT) {
-			set = &dd->affinity->def_intr;
+			set = &entry->def_intr;
 			cpu = cpumask_first(&set->mask);
 		} else {
-			set = &dd->affinity->rcv_intr;
+			set = &entry->rcv_intr;
 		}
 		scnprintf(extra, 64, "ctxt %u", rcd->ctxt);
 		break;
@@ -222,8 +306,8 @@ int hfi1_get_irq_affinity(struct hfi1_devdata *dd, struct hfi1_msix_entry *msix)
 	 * is set above.  Skip accounting for it.  Everything else finds its
 	 * CPU here.
 	 */
-	if (cpu == -1) {
-		spin_lock(&dd->affinity->lock);
+	if (cpu == -1 && set) {
+		spin_lock(&node_affinity.lock);
 		if (cpumask_equal(&set->mask, &set->used)) {
 			/*
 			 * We've used up all the CPUs, bump up the generation
@@ -235,7 +319,7 @@ int hfi1_get_irq_affinity(struct hfi1_devdata *dd, struct hfi1_msix_entry *msix)
 		cpumask_andnot(diff, &set->mask, &set->used);
 		cpu = cpumask_first(diff);
 		cpumask_set_cpu(cpu, &set->used);
-		spin_unlock(&dd->affinity->lock);
+		spin_unlock(&node_affinity.lock);
 	}
 
 	switch (msix->type) {
@@ -263,30 +347,35 @@ void hfi1_put_irq_affinity(struct hfi1_devdata *dd,
 {
 	struct cpu_mask_set *set = NULL;
 	struct hfi1_ctxtdata *rcd;
+	struct hfi1_affinity_node *entry;
+
+	spin_lock(&node_affinity.lock);
+	entry = node_affinity_lookup(dd->node);
+	spin_unlock(&node_affinity.lock);
 
 	switch (msix->type) {
 	case IRQ_SDMA:
 	case IRQ_GENERAL:
-		set = &dd->affinity->def_intr;
+		set = &entry->def_intr;
 		break;
 	case IRQ_RCVCTXT:
 		rcd = (struct hfi1_ctxtdata *)msix->arg;
 		/* only do accounting for non control contexts */
 		if (rcd->ctxt != HFI1_CTRL_CTXT)
-			set = &dd->affinity->rcv_intr;
+			set = &entry->rcv_intr;
 		break;
 	default:
 		return;
 	}
 
 	if (set) {
-		spin_lock(&dd->affinity->lock);
+		spin_lock(&node_affinity.lock);
 		cpumask_andnot(&set->used, &set->used, &msix->mask);
 		if (cpumask_empty(&set->used) && set->gen) {
 			set->gen--;
 			cpumask_copy(&set->used, &set->mask);
 		}
-		spin_unlock(&dd->affinity->lock);
+		spin_unlock(&node_affinity.lock);
 	}
 
 	irq_set_affinity_hint(msix->msix.vector, NULL);
@@ -297,9 +386,10 @@ int hfi1_get_proc_affinity(struct hfi1_devdata *dd, int node)
 {
 	int cpu = -1, ret;
 	cpumask_var_t diff, mask, intrs;
+	struct hfi1_affinity_node *entry;
 	const struct cpumask *node_mask,
 		*proc_mask = tsk_cpus_allowed(current);
-	struct cpu_mask_set *set = &dd->affinity->proc;
+	struct cpu_mask_set *set = &node_affinity.proc;
 
 	/*
 	 * check whether process/context affinity has already
@@ -338,7 +428,7 @@ int hfi1_get_proc_affinity(struct hfi1_devdata *dd, int node)
 	if (!ret)
 		goto free_mask;
 
-	spin_lock(&dd->affinity->lock);
+	spin_lock(&node_affinity.lock);
 	/*
 	 * If we've used all available CPUs, clear the mask and start
 	 * overloading.
@@ -348,13 +438,14 @@ int hfi1_get_proc_affinity(struct hfi1_devdata *dd, int node)
 		cpumask_clear(&set->used);
 	}
 
+	entry = node_affinity_lookup(dd->node);
 	/* CPUs used by interrupt handlers */
-	cpumask_copy(intrs, (dd->affinity->def_intr.gen ?
-			     &dd->affinity->def_intr.mask :
-			     &dd->affinity->def_intr.used));
-	cpumask_or(intrs, intrs, (dd->affinity->rcv_intr.gen ?
-				  &dd->affinity->rcv_intr.mask :
-				  &dd->affinity->rcv_intr.used));
+	cpumask_copy(intrs, (entry->def_intr.gen ?
+			     &entry->def_intr.mask :
+			     &entry->def_intr.used));
+	cpumask_or(intrs, intrs, (entry->rcv_intr.gen ?
+				  &entry->rcv_intr.mask :
+				  &entry->rcv_intr.used));
 	hfi1_cdbg(PROC, "CPUs used by interrupts: %*pbl",
 		  cpumask_pr_args(intrs));
 
@@ -400,7 +491,7 @@ int hfi1_get_proc_affinity(struct hfi1_devdata *dd, int node)
 		cpu = -1;
 	else
 		cpumask_set_cpu(cpu, &set->used);
-	spin_unlock(&dd->affinity->lock);
+	spin_unlock(&node_affinity.lock);
 
 	free_cpumask_var(intrs);
 free_mask:
@@ -413,16 +504,16 @@ done:
 
 void hfi1_put_proc_affinity(struct hfi1_devdata *dd, int cpu)
 {
-	struct cpu_mask_set *set = &dd->affinity->proc;
+	struct cpu_mask_set *set = &node_affinity.proc;
 
 	if (cpu < 0)
 		return;
-	spin_lock(&dd->affinity->lock);
+	spin_lock(&node_affinity.lock);
 	cpumask_clear_cpu(cpu, &set->used);
 	if (cpumask_empty(&set->used) && set->gen) {
 		set->gen--;
 		cpumask_copy(&set->used, &set->mask);
 	}
-	spin_unlock(&dd->affinity->lock);
+	spin_unlock(&node_affinity.lock);
 }
 
diff --git a/drivers/infiniband/hw/hfi1/affinity.h b/drivers/infiniband/hw/hfi1/affinity.h
index 20f52fe..ad3e730 100644
--- a/drivers/infiniband/hw/hfi1/affinity.h
+++ b/drivers/infiniband/hw/hfi1/affinity.h
@@ -82,11 +82,9 @@ struct hfi1_affinity {
 struct hfi1_msix_entry;
 
 /* Initialize non-HT cpu cores mask */
-int init_real_cpu_mask(struct hfi1_devdata *);
+void init_real_cpu_mask(void);
 /* Initialize driver affinity data */
-void hfi1_dev_affinity_init(struct hfi1_devdata *);
-/* Free driver affinity data */
-void hfi1_dev_affinity_free(struct hfi1_devdata *);
+int hfi1_dev_affinity_init(struct hfi1_devdata *);
 /*
  * Set IRQ affinity to a CPU. The function will determine the
  * CPU and set the affinity to it.
@@ -105,4 +103,23 @@ int hfi1_get_proc_affinity(struct hfi1_devdata *, int);
 /* Release a CPU used by a user process. */
 void hfi1_put_proc_affinity(struct hfi1_devdata *, int);
 
+struct hfi1_affinity_node {
+	int node;
+	struct cpu_mask_set def_intr;
+	struct cpu_mask_set rcv_intr;
+	struct list_head list;
+};
+
+struct hfi1_affinity_node_list {
+	struct list_head list;
+	struct cpumask real_cpu_mask;
+	struct cpu_mask_set proc;
+	/* protect affinity node list */
+	spinlock_t lock;
+};
+
+void node_affinity_init(void);
+void node_affinity_destroy(void);
+extern struct hfi1_affinity_node_list node_affinity;
+
 #endif /* _HFI1_AFFINITY_H */
diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 97ce886..0de6c0c 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -63,6 +63,7 @@
 #include "efivar.h"
 #include "platform.h"
 #include "aspm.h"
+#include "affinity.h"
 
 #define NUM_IB_PORTS 1
 
@@ -12838,7 +12839,7 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	 */
 	if (num_user_contexts < 0)
 		num_user_contexts =
-			cpumask_weight(&dd->affinity->real_cpu_mask);
+			cpumask_weight(&node_affinity.real_cpu_mask);
 
 	total_contexts = num_kernel_contexts + num_user_contexts;
 
@@ -14468,19 +14469,6 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 		 (dd->revision >> CCE_REVISION_SW_SHIFT)
 		    & CCE_REVISION_SW_MASK);
 
-	/*
-	 * The real cpu mask is part of the affinity struct but has to be
-	 * initialized earlier than the rest of the affinity struct because it
-	 * is needed to calculate the number of user contexts in
-	 * set_up_context_variables(). However, hfi1_dev_affinity_init(),
-	 * which initializes the rest of the affinity struct members,
-	 * depends on set_up_context_variables() for the number of kernel
-	 * contexts, so it cannot be called before set_up_context_variables().
-	 */
-	ret = init_real_cpu_mask(dd);
-	if (ret)
-		goto bail_cleanup;
-
 	ret = set_up_context_variables(dd);
 	if (ret)
 		goto bail_cleanup;
@@ -14494,7 +14482,9 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	/* set up KDETH QP prefix in both RX and TX CSRs */
 	init_kdeth_qp(dd);
 
-	hfi1_dev_affinity_init(dd);
+	ret = hfi1_dev_affinity_init(dd);
+	if (ret)
+		goto bail_cleanup;
 
 	/* send contexts must be set up before receive contexts */
 	ret = init_send_contexts(dd);
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index eed971c..b0c3e8a 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -64,6 +64,7 @@
 #include "debugfs.h"
 #include "verbs.h"
 #include "aspm.h"
+#include "affinity.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
@@ -1004,7 +1005,6 @@ static void __hfi1_free_devdata(struct kobject *kobj)
 	rcu_barrier(); /* wait for rcu callbacks to complete */
 	free_percpu(dd->int_counter);
 	free_percpu(dd->rcv_limit);
-	hfi1_dev_affinity_free(dd);
 	free_percpu(dd->send_schedule);
 	rvt_dealloc_device(&dd->verbs_dev.rdi);
 }
@@ -1198,6 +1198,8 @@ static int __init hfi1_mod_init(void)
 	if (ret)
 		goto bail;
 
+	node_affinity_init();
+
 	/* validate max MTU before any devices start */
 	if (!valid_opa_max_mtu(hfi1_max_mtu)) {
 		pr_err("Invalid max_mtu 0x%x, using 0x%x instead\n",
@@ -1278,6 +1280,7 @@ module_init(hfi1_mod_init);
 static void __exit hfi1_mod_cleanup(void)
 {
 	pci_unregister_driver(&hfi1_pci_driver);
+	node_affinity_destroy();
 	hfi1_wss_exit();
 	hfi1_dbg_exit();
 	hfi1_cpulist_count = 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
