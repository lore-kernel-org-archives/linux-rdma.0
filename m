From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] IB/hfi1: Reserve and collapse CPU cores for contexts
Date: Mon, 25 Jul 2016 07:54:48 -0700
Message-ID: <20160725145447.25671.27522.stgit@scvm10.sc.intel.com>
References: <20160701230133.20160.76302.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701230133.20160.76302.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Kernel receive queues oversubscribe CPU cores on multi-HFI systems.
To prevent this, the kernel receive queues are separated onto
different cores, and the SDMA engine interrupts are constrained to
a lesser number of cores.

hfi1s_on_numa_node*krcvqs is the number of CPU cores that are
reserved for kernel receive queues for all HFIs. Each HFI initializes
its kernel receive queues to one of the reserved CPU cores. If there
ends up being 0 CPU cores leftover for SDMA engines, use the same
CPU cores as receive contexts.

In addition, general and control contexts are assigned to their own
CPU core, however, both types of contexts tend to have low traffic.
To save CPU cores, collapse general and control contexts to one CPU
core for all HFI units. This change prevents SDMA engine interrupts
from wrapping around general contexts.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--

Changes since v1
----------------
Resolve conflict due to v2 of previous patch.
---
 drivers/infiniband/hw/hfi1/affinity.c |  101 +++++++++++++++++++++++++--------
 drivers/infiniband/hw/hfi1/affinity.h |    3 +
 drivers/infiniband/hw/hfi1/hfi.h      |    2 +
 drivers/infiniband/hw/hfi1/init.c     |    6 +-
 4 files changed, 84 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index 1647699..eb88927 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -66,6 +66,9 @@ static const char * const irq_type_names[] = {
 	"OTHER",
 };
 
+/* Per NUMA node count of HFI devices */
+static unsigned int *hfi1_per_node_cntr;
+
 static inline void init_cpu_mask_set(struct cpu_mask_set *set)
 {
 	cpumask_clear(&set->mask);
@@ -107,8 +110,12 @@ void init_real_cpu_mask(void)
 	}
 }
 
-void node_affinity_init(void)
+int node_affinity_init(void)
 {
+	int node;
+	struct pci_dev *dev = NULL;
+	const struct pci_device_id *ids = hfi1_pci_tbl;
+
 	cpumask_copy(&node_affinity.proc.mask, cpu_online_mask);
 	/*
 	 * The real cpu mask is part of the affinity struct but it has to be
@@ -116,6 +123,25 @@ void node_affinity_init(void)
 	 * contexts in set_up_context_variables().
 	 */
 	init_real_cpu_mask();
+
+	hfi1_per_node_cntr = kcalloc(num_possible_nodes(),
+				     sizeof(*hfi1_per_node_cntr), GFP_KERNEL);
+	if (!hfi1_per_node_cntr)
+		return -ENOMEM;
+
+	while (ids->vendor) {
+		dev = NULL;
+		while ((dev = pci_get_device(ids->vendor, ids->device, dev))) {
+			node = pcibus_to_node(dev->bus);
+			if (node < 0)
+				node = numa_node_id();
+
+			hfi1_per_node_cntr[node]++;
+		}
+		ids++;
+	}
+
+	return 0;
 }
 
 void node_affinity_destroy(void)
@@ -131,6 +157,7 @@ void node_affinity_destroy(void)
 		kfree(entry);
 	}
 	spin_unlock(&node_affinity.lock);
+	kfree(hfi1_per_node_cntr);
 }
 
 static struct hfi1_affinity_node *node_affinity_allocate(int node)
@@ -213,6 +240,7 @@ int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 		}
 		init_cpu_mask_set(&entry->def_intr);
 		init_cpu_mask_set(&entry->rcv_intr);
+		cpumask_clear(&entry->general_intr_mask);
 		/* Use the "real" cpu mask of this node as the default */
 		cpumask_and(&entry->def_intr.mask, &node_affinity.real_cpu_mask,
 			    local_mask);
@@ -224,11 +252,15 @@ int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 		if (possible == 1) {
 			/* only one CPU, everyone will use it */
 			cpumask_set_cpu(curr_cpu, &entry->rcv_intr.mask);
+			cpumask_set_cpu(curr_cpu, &entry->general_intr_mask);
 		} else {
 			/*
-			 * Retain the first CPU in the default list for the
-			 * control context.
+			 * The general/control context will be the first CPU in
+			 * the default list, so it is removed from the default
+			 * list and added to the general interrupt list.
 			 */
+			cpumask_clear_cpu(curr_cpu, &entry->def_intr.mask);
+			cpumask_set_cpu(curr_cpu, &entry->general_intr_mask);
 			curr_cpu = cpumask_next(curr_cpu,
 						&entry->def_intr.mask);
 
@@ -236,7 +268,10 @@ int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 			 * Remove the remaining kernel receive queues from
 			 * the default list and add them to the receive list.
 			 */
-			for (i = 0; i < dd->n_krcv_queues - 1; i++) {
+			for (i = 0;
+			     i < (dd->n_krcv_queues - 1) *
+				  hfi1_per_node_cntr[dd->node];
+			     i++) {
 				cpumask_clear_cpu(curr_cpu,
 						  &entry->def_intr.mask);
 				cpumask_set_cpu(curr_cpu,
@@ -246,6 +281,15 @@ int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 				if (curr_cpu >= nr_cpu_ids)
 					break;
 			}
+
+			/*
+			 * If there ends up being 0 CPU cores leftover for SDMA
+			 * engines, use the same CPU cores as general/control
+			 * context.
+			 */
+			if (cpumask_weight(&entry->def_intr.mask) == 0)
+				cpumask_copy(&entry->def_intr.mask,
+					     &entry->general_intr_mask);
 		}
 
 		spin_lock(&node_affinity.lock);
@@ -261,7 +305,7 @@ int hfi1_get_irq_affinity(struct hfi1_devdata *dd, struct hfi1_msix_entry *msix)
 	int ret;
 	cpumask_var_t diff;
 	struct hfi1_affinity_node *entry;
-	struct cpu_mask_set *set;
+	struct cpu_mask_set *set = NULL;
 	struct sdma_engine *sde = NULL;
 	struct hfi1_ctxtdata *rcd = NULL;
 	char extra[64];
@@ -282,18 +326,17 @@ int hfi1_get_irq_affinity(struct hfi1_devdata *dd, struct hfi1_msix_entry *msix)
 	case IRQ_SDMA:
 		sde = (struct sdma_engine *)msix->arg;
 		scnprintf(extra, 64, "engine %u", sde->this_idx);
-		/* fall through */
-	case IRQ_GENERAL:
 		set = &entry->def_intr;
 		break;
+	case IRQ_GENERAL:
+		cpu = cpumask_first(&entry->general_intr_mask);
+		break;
 	case IRQ_RCVCTXT:
 		rcd = (struct hfi1_ctxtdata *)msix->arg;
-		if (rcd->ctxt == HFI1_CTRL_CTXT) {
-			set = &entry->def_intr;
-			cpu = cpumask_first(&set->mask);
-		} else {
+		if (rcd->ctxt == HFI1_CTRL_CTXT)
+			cpu = cpumask_first(&entry->general_intr_mask);
+		else
 			set = &entry->rcv_intr;
-		}
 		scnprintf(extra, 64, "ctxt %u", rcd->ctxt);
 		break;
 	default:
@@ -302,9 +345,9 @@ int hfi1_get_irq_affinity(struct hfi1_devdata *dd, struct hfi1_msix_entry *msix)
 	}
 
 	/*
-	 * The control receive context is placed on a particular CPU, which
-	 * is set above.  Skip accounting for it.  Everything else finds its
-	 * CPU here.
+	 * The general and control contexts are placed on a particular
+	 * CPU, which is set above. Skip accounting for it. Everything else
+	 * finds its CPU here.
 	 */
 	if (cpu == -1 && set) {
 		spin_lock(&node_affinity.lock);
@@ -355,12 +398,14 @@ void hfi1_put_irq_affinity(struct hfi1_devdata *dd,
 
 	switch (msix->type) {
 	case IRQ_SDMA:
-	case IRQ_GENERAL:
 		set = &entry->def_intr;
 		break;
+	case IRQ_GENERAL:
+		/* Don't accounting for general contexts */
+		break;
 	case IRQ_RCVCTXT:
 		rcd = (struct hfi1_ctxtdata *)msix->arg;
-		/* only do accounting for non control contexts */
+		/* Don't do accounting for control contexts */
 		if (rcd->ctxt != HFI1_CTRL_CTXT)
 			set = &entry->rcv_intr;
 		break;
@@ -438,14 +483,20 @@ int hfi1_get_proc_affinity(struct hfi1_devdata *dd, int node)
 		cpumask_clear(&set->used);
 	}
 
-	entry = node_affinity_lookup(dd->node);
-	/* CPUs used by interrupt handlers */
-	cpumask_copy(intrs, (entry->def_intr.gen ?
-			     &entry->def_intr.mask :
-			     &entry->def_intr.used));
-	cpumask_or(intrs, intrs, (entry->rcv_intr.gen ?
-				  &entry->rcv_intr.mask :
-				  &entry->rcv_intr.used));
+	/*
+	 * If NUMA node has CPUs used by interrupt handlers, include them in the
+	 * interrupt handler mask.
+	 */
+	entry = node_affinity_lookup(node);
+	if (entry) {
+		cpumask_copy(intrs, (entry->def_intr.gen ?
+				     &entry->def_intr.mask :
+				     &entry->def_intr.used));
+		cpumask_or(intrs, intrs, (entry->rcv_intr.gen ?
+					  &entry->rcv_intr.mask :
+					  &entry->rcv_intr.used));
+		cpumask_or(intrs, intrs, &entry->general_intr_mask);
+	}
 	hfi1_cdbg(PROC, "CPUs used by interrupts: %*pbl",
 		  cpumask_pr_args(intrs));
 
diff --git a/drivers/infiniband/hw/hfi1/affinity.h b/drivers/infiniband/hw/hfi1/affinity.h
index ad3e730..003860e 100644
--- a/drivers/infiniband/hw/hfi1/affinity.h
+++ b/drivers/infiniband/hw/hfi1/affinity.h
@@ -107,6 +107,7 @@ struct hfi1_affinity_node {
 	int node;
 	struct cpu_mask_set def_intr;
 	struct cpu_mask_set rcv_intr;
+	struct cpumask general_intr_mask;
 	struct list_head list;
 };
 
@@ -118,7 +119,7 @@ struct hfi1_affinity_node_list {
 	spinlock_t lock;
 };
 
-void node_affinity_init(void);
+int node_affinity_init(void);
 void node_affinity_destroy(void);
 extern struct hfi1_affinity_node_list node_affinity;
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 748e235..fd67e98 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1235,6 +1235,8 @@ int handle_receive_interrupt_nodma_rtail(struct hfi1_ctxtdata *, int);
 int handle_receive_interrupt_dma_rtail(struct hfi1_ctxtdata *, int);
 void set_all_slowpath(struct hfi1_devdata *dd);
 
+extern const struct pci_device_id hfi1_pci_tbl[];
+
 /* receive packet handler dispositions */
 #define RCV_PKT_OK      0x0 /* keep going */
 #define RCV_PKT_LIMIT   0x1 /* stop, hit limit, start thread */
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index b0c3e8a..1620d68 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1162,7 +1162,7 @@ static int init_one(struct pci_dev *, const struct pci_device_id *);
 #define DRIVER_LOAD_MSG "Intel " DRIVER_NAME " loaded: "
 #define PFX DRIVER_NAME ": "
 
-static const struct pci_device_id hfi1_pci_tbl[] = {
+const struct pci_device_id hfi1_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL0) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL1) },
 	{ 0, }
@@ -1198,7 +1198,9 @@ static int __init hfi1_mod_init(void)
 	if (ret)
 		goto bail;
 
-	node_affinity_init();
+	ret = node_affinity_init();
+	if (ret)
+		goto bail;
 
 	/* validate max MTU before any devices start */
 	if (!valid_opa_max_mtu(hfi1_max_mtu)) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
