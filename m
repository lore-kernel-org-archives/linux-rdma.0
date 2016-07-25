From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] IB/hfi1: Refine user process affinity algorithm
Date: Mon, 25 Jul 2016 07:54:57 -0700
Message-ID: <20160725145456.25718.93734.stgit@scvm10.sc.intel.com>
References: <20160701230138.20160.5753.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701230138.20160.5753.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When performing process affinity recommendations for MPI ranks, the current
algorithm doesn't take into account multiple HFI units. Also, real
cores and HT cores are not distinguished from one another. Therefore,
all HT cores are recommended to be assigned first within the local NUMA
node before recommending the assignments of cores in other NUMA nodes.
It's ideal to assign all real cores across all NUMA nodes first, then all
HT 1 cores, then all HT 2 cores, and so on to balance CPU workload. CPU
cores in other NUMA nodes could be running interrupt handlers, and this is
not taken into account.

To balance the CPU workload for user processes, the following
recommendation algorithm is used:

 For each user process that is opening a context on HFI Y:
  a) If all cores are assigned to user processes, start assignments all
	 over from the first core
  b) Assign real cores first, then HT cores (First set of HT cores on
	 all physical cores, then second set of HT cores, and, so on) in the
	 following order:

	 1. Same NUMA node as HFI Y and not running an IRQ handler
	 2. Same NUMA node as HFI Y and running an IRQ handler
	 3. Different NUMA node to HFI Y and not running an IRQ handler
	 4. Different NUMA node to HFI Y and running an IRQ handler
  c) Mark core as assigned in the global affinity structure. As user
	 processes are done, remove core assignments from global affinity
	 structure.

This implementation allows an arbitrary number of HT cores and provides
support for multiple HFIs.

This is being included in the kernel rather than user space due to the
fact that user space has no way of knowing the CPU recommendations for
contexts running as part of other jobs.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--

Changes since v1:
----------------
Resolve conflicts introduced by the previous two patches.
---
 drivers/infiniband/hw/hfi1/affinity.c |  213 +++++++++++++++++++++++++--------
 drivers/infiniband/hw/hfi1/affinity.h |    8 +
 drivers/infiniband/hw/hfi1/file_ops.c |   15 ++
 3 files changed, 174 insertions(+), 62 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index eb88927..c9dcbd5 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -116,7 +116,17 @@ int node_affinity_init(void)
 	struct pci_dev *dev = NULL;
 	const struct pci_device_id *ids = hfi1_pci_tbl;
 
+	cpumask_clear(&node_affinity.proc.used);
 	cpumask_copy(&node_affinity.proc.mask, cpu_online_mask);
+
+	node_affinity.proc.gen = 0;
+	node_affinity.num_core_siblings =
+				cpumask_weight(topology_sibling_cpumask(
+					cpumask_first(&node_affinity.proc.mask)
+					));
+	node_affinity.num_online_nodes = num_online_nodes();
+	node_affinity.num_online_cpus = num_online_cpus();
+
 	/*
 	 * The real cpu mask is part of the affinity struct but it has to be
 	 * initialized early. It is needed to calculate the number of user
@@ -401,7 +411,7 @@ void hfi1_put_irq_affinity(struct hfi1_devdata *dd,
 		set = &entry->def_intr;
 		break;
 	case IRQ_GENERAL:
-		/* Don't accounting for general contexts */
+		/* Don't do accounting for general contexts */
 		break;
 	case IRQ_RCVCTXT:
 		rcd = (struct hfi1_ctxtdata *)msix->arg;
@@ -427,14 +437,47 @@ void hfi1_put_irq_affinity(struct hfi1_devdata *dd,
 	cpumask_clear(&msix->mask);
 }
 
-int hfi1_get_proc_affinity(struct hfi1_devdata *dd, int node)
+/* This should be called with node_affinity.lock held */
+static void find_hw_thread_mask(uint hw_thread_no, cpumask_var_t hw_thread_mask,
+				struct hfi1_affinity_node_list *affinity)
+{
+	int possible, curr_cpu, i;
+	uint num_cores_per_socket = node_affinity.num_online_cpus /
+					affinity->num_core_siblings /
+						node_affinity.num_online_nodes;
+
+	cpumask_copy(hw_thread_mask, &affinity->proc.mask);
+	if (affinity->num_core_siblings > 0) {
+		/* Removing other siblings not needed for now */
+		possible = cpumask_weight(hw_thread_mask);
+		curr_cpu = cpumask_first(hw_thread_mask);
+		for (i = 0;
+		     i < num_cores_per_socket * node_affinity.num_online_nodes;
+		     i++)
+			curr_cpu = cpumask_next(curr_cpu, hw_thread_mask);
+
+		for (; i < possible; i++) {
+			cpumask_clear_cpu(curr_cpu, hw_thread_mask);
+			curr_cpu = cpumask_next(curr_cpu, hw_thread_mask);
+		}
+
+		/* Identifying correct HW threads within physical cores */
+		cpumask_shift_left(hw_thread_mask, hw_thread_mask,
+				   num_cores_per_socket *
+				   node_affinity.num_online_nodes *
+				   hw_thread_no);
+	}
+}
+
+int hfi1_get_proc_affinity(int node)
 {
-	int cpu = -1, ret;
-	cpumask_var_t diff, mask, intrs;
+	int cpu = -1, ret, i;
 	struct hfi1_affinity_node *entry;
+	cpumask_var_t diff, hw_thread_mask, available_mask, intrs_mask;
 	const struct cpumask *node_mask,
 		*proc_mask = tsk_cpus_allowed(current);
-	struct cpu_mask_set *set = &node_affinity.proc;
+	struct hfi1_affinity_node_list *affinity = &node_affinity;
+	struct cpu_mask_set *set = &affinity->proc;
 
 	/*
 	 * check whether process/context affinity has already
@@ -460,22 +503,41 @@ int hfi1_get_proc_affinity(struct hfi1_devdata *dd, int node)
 
 	/*
 	 * The process does not have a preset CPU affinity so find one to
-	 * recommend. We prefer CPUs on the same NUMA as the device.
+	 * recommend using the following algorithm:
+	 *
+	 * For each user process that is opening a context on HFI Y:
+	 *  a) If all cores are filled, reinitialize the bitmask
+	 *  b) Fill real cores first, then HT cores (First set of HT
+	 *     cores on all physical cores, then second set of HT core,
+	 *     and, so on) in the following order:
+	 *
+	 *     1. Same NUMA node as HFI Y and not running an IRQ
+	 *        handler
+	 *     2. Same NUMA node as HFI Y and running an IRQ handler
+	 *     3. Different NUMA node to HFI Y and not running an IRQ
+	 *        handler
+	 *     4. Different NUMA node to HFI Y and running an IRQ
+	 *        handler
+	 *  c) Mark core as filled in the bitmask. As user processes are
+	 *     done, clear cores from the bitmask.
 	 */
 
 	ret = zalloc_cpumask_var(&diff, GFP_KERNEL);
 	if (!ret)
 		goto done;
-	ret = zalloc_cpumask_var(&mask, GFP_KERNEL);
+	ret = zalloc_cpumask_var(&hw_thread_mask, GFP_KERNEL);
 	if (!ret)
 		goto free_diff;
-	ret = zalloc_cpumask_var(&intrs, GFP_KERNEL);
+	ret = zalloc_cpumask_var(&available_mask, GFP_KERNEL);
 	if (!ret)
-		goto free_mask;
+		goto free_hw_thread_mask;
+	ret = zalloc_cpumask_var(&intrs_mask, GFP_KERNEL);
+	if (!ret)
+		goto free_available_mask;
 
-	spin_lock(&node_affinity.lock);
+	spin_lock(&affinity->lock);
 	/*
-	 * If we've used all available CPUs, clear the mask and start
+	 * If we've used all available HW threads, clear the mask and start
 	 * overloading.
 	 */
 	if (cpumask_equal(&set->mask, &set->used)) {
@@ -489,82 +551,125 @@ int hfi1_get_proc_affinity(struct hfi1_devdata *dd, int node)
 	 */
 	entry = node_affinity_lookup(node);
 	if (entry) {
-		cpumask_copy(intrs, (entry->def_intr.gen ?
-				     &entry->def_intr.mask :
-				     &entry->def_intr.used));
-		cpumask_or(intrs, intrs, (entry->rcv_intr.gen ?
-					  &entry->rcv_intr.mask :
-					  &entry->rcv_intr.used));
-		cpumask_or(intrs, intrs, &entry->general_intr_mask);
+		cpumask_copy(intrs_mask, (entry->def_intr.gen ?
+					  &entry->def_intr.mask :
+					  &entry->def_intr.used));
+		cpumask_or(intrs_mask, intrs_mask, (entry->rcv_intr.gen ?
+						    &entry->rcv_intr.mask :
+						    &entry->rcv_intr.used));
+		cpumask_or(intrs_mask, intrs_mask, &entry->general_intr_mask);
 	}
 	hfi1_cdbg(PROC, "CPUs used by interrupts: %*pbl",
-		  cpumask_pr_args(intrs));
+		  cpumask_pr_args(intrs_mask));
+
+	cpumask_copy(hw_thread_mask, &set->mask);
 
 	/*
-	 * If we don't have a NUMA node requested, preference is towards
-	 * device NUMA node
+	 * If HT cores are enabled, identify which HW threads within the
+	 * physical cores should be used.
 	 */
-	if (node == -1)
-		node = dd->node;
+	if (affinity->num_core_siblings > 0) {
+		for (i = 0; i < affinity->num_core_siblings; i++) {
+			find_hw_thread_mask(i, hw_thread_mask, affinity);
+
+			/*
+			 * If there's at least one available core for this HW
+			 * thread number, stop looking for a core.
+			 *
+			 * diff will always be not empty at least once in this
+			 * loop as the used mask gets reset when
+			 * (set->mask == set->used) before this loop.
+			 */
+			cpumask_andnot(diff, hw_thread_mask, &set->used);
+			if (!cpumask_empty(diff))
+				break;
+		}
+	}
+	hfi1_cdbg(PROC, "Same available HW thread on all physical CPUs: %*pbl",
+		  cpumask_pr_args(hw_thread_mask));
+
 	node_mask = cpumask_of_node(node);
-	hfi1_cdbg(PROC, "device on NUMA %u, CPUs %*pbl", node,
+	hfi1_cdbg(PROC, "Device on NUMA %u, CPUs %*pbl", node,
 		  cpumask_pr_args(node_mask));
 
-	/* diff will hold all unused cpus */
-	cpumask_andnot(diff, &set->mask, &set->used);
-	hfi1_cdbg(PROC, "unused CPUs (all) %*pbl", cpumask_pr_args(diff));
-
-	/* get cpumask of available CPUs on preferred NUMA */
-	cpumask_and(mask, diff, node_mask);
-	hfi1_cdbg(PROC, "available cpus on NUMA %*pbl", cpumask_pr_args(mask));
+	/* Get cpumask of available CPUs on preferred NUMA */
+	cpumask_and(available_mask, hw_thread_mask, node_mask);
+	cpumask_andnot(available_mask, available_mask, &set->used);
+	hfi1_cdbg(PROC, "Available CPUs on NUMA %u: %*pbl", node,
+		  cpumask_pr_args(available_mask));
 
 	/*
 	 * At first, we don't want to place processes on the same
-	 * CPUs as interrupt handlers.
+	 * CPUs as interrupt handlers. Then, CPUs running interrupt
+	 * handlers are used.
+	 *
+	 * 1) If diff is not empty, then there are CPUs not running
+	 *    non-interrupt handlers available, so diff gets copied
+	 *    over to available_mask.
+	 * 2) If diff is empty, then all CPUs not running interrupt
+	 *    handlers are taken, so available_mask contains all
+	 *    available CPUs running interrupt handlers.
+	 * 3) If available_mask is empty, then all CPUs on the
+	 *    preferred NUMA node are taken, so other NUMA nodes are
+	 *    used for process assignments using the same method as
+	 *    the preferred NUMA node.
 	 */
-	cpumask_andnot(diff, mask, intrs);
+	cpumask_andnot(diff, available_mask, intrs_mask);
 	if (!cpumask_empty(diff))
-		cpumask_copy(mask, diff);
+		cpumask_copy(available_mask, diff);
 
-	/*
-	 * if we don't have a cpu on the preferred NUMA, get
-	 * the list of the remaining available CPUs
-	 */
-	if (cpumask_empty(mask)) {
-		cpumask_andnot(diff, &set->mask, &set->used);
-		cpumask_andnot(mask, diff, node_mask);
+	/* If we don't have CPUs on the preferred node, use other NUMA nodes */
+	if (cpumask_empty(available_mask)) {
+		cpumask_andnot(available_mask, hw_thread_mask, &set->used);
+		/* Excluding preferred NUMA cores */
+		cpumask_andnot(available_mask, available_mask, node_mask);
+		hfi1_cdbg(PROC,
+			  "Preferred NUMA node cores are taken, cores available in other NUMA nodes: %*pbl",
+			  cpumask_pr_args(available_mask));
+
+		/*
+		 * At first, we don't want to place processes on the same
+		 * CPUs as interrupt handlers.
+		 */
+		cpumask_andnot(diff, available_mask, intrs_mask);
+		if (!cpumask_empty(diff))
+			cpumask_copy(available_mask, diff);
 	}
-	hfi1_cdbg(PROC, "possible CPUs for process %*pbl",
-		  cpumask_pr_args(mask));
+	hfi1_cdbg(PROC, "Possible CPUs for process: %*pbl",
+		  cpumask_pr_args(available_mask));
 
-	cpu = cpumask_first(mask);
+	cpu = cpumask_first(available_mask);
 	if (cpu >= nr_cpu_ids) /* empty */
 		cpu = -1;
 	else
 		cpumask_set_cpu(cpu, &set->used);
-	spin_unlock(&node_affinity.lock);
-
-	free_cpumask_var(intrs);
-free_mask:
-	free_cpumask_var(mask);
+	spin_unlock(&affinity->lock);
+	hfi1_cdbg(PROC, "Process assigned to CPU %d", cpu);
+
+	free_cpumask_var(intrs_mask);
+free_available_mask:
+	free_cpumask_var(available_mask);
+free_hw_thread_mask:
+	free_cpumask_var(hw_thread_mask);
 free_diff:
 	free_cpumask_var(diff);
 done:
 	return cpu;
 }
 
-void hfi1_put_proc_affinity(struct hfi1_devdata *dd, int cpu)
+void hfi1_put_proc_affinity(int cpu)
 {
-	struct cpu_mask_set *set = &node_affinity.proc;
+	struct hfi1_affinity_node_list *affinity = &node_affinity;
+	struct cpu_mask_set *set = &affinity->proc;
 
 	if (cpu < 0)
 		return;
-	spin_lock(&node_affinity.lock);
+	spin_lock(&affinity->lock);
 	cpumask_clear_cpu(cpu, &set->used);
+	hfi1_cdbg(PROC, "Returning CPU %d for future process assignment", cpu);
 	if (cpumask_empty(&set->used) && set->gen) {
 		set->gen--;
 		cpumask_copy(&set->used, &set->mask);
 	}
-	spin_unlock(&node_affinity.lock);
+	spin_unlock(&affinity->lock);
 }
-
diff --git a/drivers/infiniband/hw/hfi1/affinity.h b/drivers/infiniband/hw/hfi1/affinity.h
index 003860e..f784de5 100644
--- a/drivers/infiniband/hw/hfi1/affinity.h
+++ b/drivers/infiniband/hw/hfi1/affinity.h
@@ -73,7 +73,6 @@ struct cpu_mask_set {
 struct hfi1_affinity {
 	struct cpu_mask_set def_intr;
 	struct cpu_mask_set rcv_intr;
-	struct cpu_mask_set proc;
 	struct cpumask real_cpu_mask;
 	/* spin lock to protect affinity struct */
 	spinlock_t lock;
@@ -99,9 +98,9 @@ void hfi1_put_irq_affinity(struct hfi1_devdata *, struct hfi1_msix_entry *);
  * Determine a CPU affinity for a user process, if the process does not
  * have an affinity set yet.
  */
-int hfi1_get_proc_affinity(struct hfi1_devdata *, int);
+int hfi1_get_proc_affinity(int);
 /* Release a CPU used by a user process. */
-void hfi1_put_proc_affinity(struct hfi1_devdata *, int);
+void hfi1_put_proc_affinity(int);
 
 struct hfi1_affinity_node {
 	int node;
@@ -115,6 +114,9 @@ struct hfi1_affinity_node_list {
 	struct list_head list;
 	struct cpumask real_cpu_mask;
 	struct cpu_mask_set proc;
+	int num_core_siblings;
+	int num_online_nodes;
+	int num_online_cpus;
 	/* protect affinity node list */
 	spinlock_t lock;
 };
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 2f097d9..d7c07bc 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -715,7 +715,7 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	hfi1_user_sdma_free_queues(fdata);
 
 	/* release the cpu */
-	hfi1_put_proc_affinity(dd, fdata->rec_cpu_num);
+	hfi1_put_proc_affinity(fdata->rec_cpu_num);
 
 	/*
 	 * Clear any left over, unhandled events so the next process that
@@ -815,9 +815,10 @@ static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo)
 		ret = find_shared_ctxt(fp, uinfo);
 		if (ret < 0)
 			goto done_unlock;
-		if (ret)
-			fd->rec_cpu_num = hfi1_get_proc_affinity(
-				fd->uctxt->dd, fd->uctxt->numa_id);
+		if (ret) {
+			fd->rec_cpu_num =
+				hfi1_get_proc_affinity(fd->uctxt->numa_id);
+		}
 	}
 
 	/*
@@ -929,7 +930,11 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 	if (ctxt == dd->num_rcv_contexts)
 		return -EBUSY;
 
-	fd->rec_cpu_num = hfi1_get_proc_affinity(dd, -1);
+	/*
+	 * If we don't have a NUMA node requested, preference is towards
+	 * device NUMA node.
+	 */
+	fd->rec_cpu_num = hfi1_get_proc_affinity(dd->node);
 	if (fd->rec_cpu_num != -1)
 		numa = cpu_to_node(fd->rec_cpu_num);
 	else

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
