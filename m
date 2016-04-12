From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 16/21] IB/hfi1: Change default number of user contexts
Date: Tue, 12 Apr 2016 11:30:08 -0700
Message-ID: <20160412182939.27207.33834.stgit@scvm10.sc.intel.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412174746.24485.92280.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change the default number of user contexts to the number of real
(non-HT) cpu cores in order to reduce the division of hfi1 hardware
contexts in the case of high core counts with hyper-threading enabled.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/affinity.c |   93 +++++++++++++++++-----------------
 drivers/staging/rdma/hfi1/affinity.h |   19 +++++++
 drivers/staging/rdma/hfi1/chip.c     |   26 +++++++---
 3 files changed, 84 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/affinity.c b/drivers/staging/rdma/hfi1/affinity.c
index 2cb8ca7..6e7050a 100644
--- a/drivers/staging/rdma/hfi1/affinity.c
+++ b/drivers/staging/rdma/hfi1/affinity.c
@@ -53,20 +53,6 @@
 #include "sdma.h"
 #include "trace.h"
 
-struct cpu_mask_set {
-	struct cpumask mask;
-	struct cpumask used;
-	uint gen;
-};
-
-struct hfi1_affinity {
-	struct cpu_mask_set def_intr;
-	struct cpu_mask_set rcv_intr;
-	struct cpu_mask_set proc;
-	/* spin lock to protect affinity struct */
-	spinlock_t lock;
-};
-
 /* Name of IRQ types, indexed by enum irq_type */
 static const char * const irq_type_names[] = {
 	"SDMA",
@@ -82,6 +68,48 @@ static inline void init_cpu_mask_set(struct cpu_mask_set *set)
 	set->gen = 0;
 }
 
+/* Initialize non-HT cpu cores mask */
+int init_real_cpu_mask(struct hfi1_devdata *dd)
+{
+	struct hfi1_affinity *info;
+	int possible, curr_cpu, i, ht;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	cpumask_clear(&info->real_cpu_mask);
+
+	/* Start with cpu online mask as the real cpu mask */
+	cpumask_copy(&info->real_cpu_mask, cpu_online_mask);
+
+	/*
+	 * Remove HT cores from the real cpu mask.  Do this in two steps below.
+	 */
+	possible = cpumask_weight(&info->real_cpu_mask);
+	ht = cpumask_weight(topology_sibling_cpumask(
+					cpumask_first(&info->real_cpu_mask)));
+	/*
+	 * Step 1.  Skip over the first N HT siblings and use them as the
+	 * "real" cores.  Assumes that HT cores are not enumerated in
+	 * succession (except in the single core case).
+	 */
+	curr_cpu = cpumask_first(&info->real_cpu_mask);
+	for (i = 0; i < possible / ht; i++)
+		curr_cpu = cpumask_next(curr_cpu, &info->real_cpu_mask);
+	/*
+	 * Step 2.  Remove the remaining HT siblings.  Use cpumask_next() to
+	 * skip any gaps.
+	 */
+	for (; i < possible; i++) {
+		cpumask_clear_cpu(curr_cpu, &info->real_cpu_mask);
+		curr_cpu = cpumask_next(curr_cpu, &info->real_cpu_mask);
+	}
+
+	dd->affinity = info;
+	return 0;
+}
+
 /*
  * Interrupt affinity.
  *
@@ -93,20 +121,17 @@ static inline void init_cpu_mask_set(struct cpu_mask_set *set)
  * to the node relative 1 as necessary.
  *
  */
-int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
+void hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 {
 	int node = pcibus_to_node(dd->pcidev->bus);
-	struct hfi1_affinity *info;
+	struct hfi1_affinity *info = dd->affinity;
 	const struct cpumask *local_mask;
-	int curr_cpu, possible, i, ht;
+	int curr_cpu, possible, i;
 
 	if (node < 0)
 		node = numa_node_id();
 	dd->node = node;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
 	spin_lock_init(&info->lock);
 
 	init_cpu_mask_set(&info->def_intr);
@@ -116,30 +141,8 @@ int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 	local_mask = cpumask_of_node(dd->node);
 	if (cpumask_first(local_mask) >= nr_cpu_ids)
 		local_mask = topology_core_cpumask(0);
-	/* use local mask as default */
-	cpumask_copy(&info->def_intr.mask, local_mask);
-	/*
-	 * Remove HT cores from the default mask.  Do this in two steps below.
-	 */
-	possible = cpumask_weight(&info->def_intr.mask);
-	ht = cpumask_weight(topology_sibling_cpumask(
-					cpumask_first(&info->def_intr.mask)));
-	/*
-	 * Step 1.  Skip over the first N HT siblings and use them as the
-	 * "real" cores.  Assumes that HT cores are not enumerated in
-	 * succession (except in the single core case).
-	 */
-	curr_cpu = cpumask_first(&info->def_intr.mask);
-	for (i = 0; i < possible / ht; i++)
-		curr_cpu = cpumask_next(curr_cpu, &info->def_intr.mask);
-	/*
-	 * Step 2.  Remove the remaining HT siblings.  Use cpumask_next() to
-	 * skip any gaps.
-	 */
-	for (; i < possible; i++) {
-		cpumask_clear_cpu(curr_cpu, &info->def_intr.mask);
-		curr_cpu = cpumask_next(curr_cpu, &info->def_intr.mask);
-	}
+	/* Use the "real" cpu mask of this node as the default */
+	cpumask_and(&info->def_intr.mask, &info->real_cpu_mask, local_mask);
 
 	/*  fill in the receive list */
 	possible = cpumask_weight(&info->def_intr.mask);
@@ -167,8 +170,6 @@ int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 	}
 
 	cpumask_copy(&info->proc.mask, cpu_online_mask);
-	dd->affinity = info;
-	return 0;
 }
 
 void hfi1_dev_affinity_free(struct hfi1_devdata *dd)
diff --git a/drivers/staging/rdma/hfi1/affinity.h b/drivers/staging/rdma/hfi1/affinity.h
index b287e49..20f52fe 100644
--- a/drivers/staging/rdma/hfi1/affinity.h
+++ b/drivers/staging/rdma/hfi1/affinity.h
@@ -64,10 +64,27 @@ enum affinity_flags {
 	AFF_IRQ_LOCAL
 };
 
+struct cpu_mask_set {
+	struct cpumask mask;
+	struct cpumask used;
+	uint gen;
+};
+
+struct hfi1_affinity {
+	struct cpu_mask_set def_intr;
+	struct cpu_mask_set rcv_intr;
+	struct cpu_mask_set proc;
+	struct cpumask real_cpu_mask;
+	/* spin lock to protect affinity struct */
+	spinlock_t lock;
+};
+
 struct hfi1_msix_entry;
 
+/* Initialize non-HT cpu cores mask */
+int init_real_cpu_mask(struct hfi1_devdata *);
 /* Initialize driver affinity data */
-int hfi1_dev_affinity_init(struct hfi1_devdata *);
+void hfi1_dev_affinity_init(struct hfi1_devdata *);
 /* Free driver affinity data */
 void hfi1_dev_affinity_free(struct hfi1_devdata *);
 /*
diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 38c0e97..1984454 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -12656,12 +12656,13 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 		num_kernel_contexts = dd->chip_send_contexts - num_vls - 1;
 	}
 	/*
-	 * User contexts: (to be fixed later)
-	 *	- default to 1 user context per CPU if num_user_contexts is
-	 *	  negative
+	 * User contexts:
+	 *	- default to 1 user context per real (non-HT) CPU core if
+	 *	  num_user_contexts is negative
 	 */
 	if (num_user_contexts < 0)
-		num_user_contexts = num_online_cpus();
+		num_user_contexts =
+			cpumask_weight(&dd->affinity->real_cpu_mask);
 
 	total_contexts = num_kernel_contexts + num_user_contexts;
 
@@ -14089,6 +14090,19 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 		 (dd->revision >> CCE_REVISION_SW_SHIFT)
 		    & CCE_REVISION_SW_MASK);
 
+	/*
+	 * The real cpu mask is part of the affinity struct but has to be
+	 * initialized earlier than the rest of the affinity struct because it
+	 * is needed to calculate the number of user contexts in
+	 * set_up_context_variables(). However, hfi1_dev_affinity_init(),
+	 * which initializes the rest of the affinity struct members,
+	 * depends on set_up_context_variables() for the number of kernel
+	 * contexts, so it cannot be called before set_up_context_variables().
+	 */
+	ret = init_real_cpu_mask(dd);
+	if (ret)
+		goto bail_cleanup;
+
 	ret = set_up_context_variables(dd);
 	if (ret)
 		goto bail_cleanup;
@@ -14102,9 +14116,7 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	/* set up KDETH QP prefix in both RX and TX CSRs */
 	init_kdeth_qp(dd);
 
-	ret = hfi1_dev_affinity_init(dd);
-	if (ret)
-		goto bail_cleanup;
+	hfi1_dev_affinity_init(dd);
 
 	/* send contexts must be set up before receive contexts */
 	ret = init_send_contexts(dd);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
