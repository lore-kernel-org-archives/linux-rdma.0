From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/5] IB/hfi1: Add irq affinity notification handler
Date: Sun, 25 Sep 2016 07:44:37 -0700
Message-ID: <20160925144435.12088.42999.stgit@scvm10.sc.intel.com>
References: <20160925144248.12088.71489.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925144248.12088.71489.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds an irq affinity notification handler.
When a user changes interrupt affinity settings for an sdma engine,
the driver needs to make changes to its internal sde structures and
also update the affinity_hint.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/affinity.c |  112 ++++++++++++++++++++++++++++++---
 drivers/infiniband/hw/hfi1/hfi.h      |    1 
 2 files changed, 103 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index 17c805a..a26a9a0 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -47,6 +47,7 @@
 #include <linux/topology.h>
 #include <linux/cpumask.h>
 #include <linux/module.h>
+#include <linux/interrupt.h>
 
 #include "hfi.h"
 #include "affinity.h"
@@ -309,6 +310,101 @@ int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
 }
 
 /*
+ * Function updates the irq affinity hint for msix after it has been changed
+ * by the user using the /proc/irq interface. This function only accepts
+ * one cpu in the mask.
+ */
+static void hfi1_update_sdma_affinity(struct hfi1_msix_entry *msix, int cpu)
+{
+	struct sdma_engine *sde = msix->arg;
+	struct hfi1_devdata *dd = sde->dd;
+	struct hfi1_affinity_node *entry;
+	struct cpu_mask_set *set;
+	int i, old_cpu;
+
+	if (cpu > num_online_cpus() || cpu == sde->cpu)
+		return;
+
+	mutex_lock(&node_affinity.lock);
+	entry = node_affinity_lookup(dd->node);
+	if (!entry)
+		goto unlock;
+
+	old_cpu = sde->cpu;
+	sde->cpu = cpu;
+	cpumask_clear(&msix->mask);
+	cpumask_set_cpu(cpu, &msix->mask);
+	dd_dev_dbg(dd, "IRQ vector: %u, type %s engine %u -> cpu: %d\n",
+		   msix->msix.vector, irq_type_names[msix->type],
+		   sde->this_idx, cpu);
+	irq_set_affinity_hint(msix->msix.vector, &msix->mask);
+
+	/*
+	 * Set the new cpu in the hfi1_affinity_node and clean
+	 * the old cpu if it is not used by any other IRQ
+	 */
+	set = &entry->def_intr;
+	cpumask_set_cpu(cpu, &set->mask);
+	cpumask_set_cpu(cpu, &set->used);
+	for (i = 0; i < dd->num_msix_entries; i++) {
+		struct hfi1_msix_entry *other_msix;
+
+		other_msix = &dd->msix_entries[i];
+		if (other_msix->type != IRQ_SDMA || other_msix == msix)
+			continue;
+
+		if (cpumask_test_cpu(old_cpu, &other_msix->mask))
+			goto unlock;
+	}
+	cpumask_clear_cpu(old_cpu, &set->mask);
+	cpumask_clear_cpu(old_cpu, &set->used);
+unlock:
+	mutex_unlock(&node_affinity.lock);
+}
+
+static void hfi1_irq_notifier_notify(struct irq_affinity_notify *notify,
+				     const cpumask_t *mask)
+{
+	int cpu = cpumask_first(mask);
+	struct hfi1_msix_entry *msix = container_of(notify,
+						    struct hfi1_msix_entry,
+						    notify);
+
+	/* Only one CPU configuration supported currently */
+	hfi1_update_sdma_affinity(msix, cpu);
+}
+
+static void hfi1_irq_notifier_release(struct kref *ref)
+{
+	/*
+	 * This is required by affinity notifier. We don't have anything to
+	 * free here.
+	 */
+}
+
+static void hfi1_setup_sdma_notifier(struct hfi1_msix_entry *msix)
+{
+	struct irq_affinity_notify *notify = &msix->notify;
+
+	notify->irq = msix->msix.vector;
+	notify->notify = hfi1_irq_notifier_notify;
+	notify->release = hfi1_irq_notifier_release;
+
+	if (irq_set_affinity_notifier(notify->irq, notify))
+		pr_err("Failed to register sdma irq affinity notifier for irq %d\n",
+		       notify->irq);
+}
+
+static void hfi1_cleanup_sdma_notifier(struct hfi1_msix_entry *msix)
+{
+	struct irq_affinity_notify *notify = &msix->notify;
+
+	if (irq_set_affinity_notifier(notify->irq, NULL))
+		pr_err("Failed to cleanup sdma irq affinity notifier for irq %d\n",
+		       notify->irq);
+}
+
+/*
  * Function sets the irq affinity for msix.
  * It *must* be called with node_affinity.lock held.
  */
@@ -374,22 +470,17 @@ static int get_irq_affinity(struct hfi1_devdata *dd,
 		cpumask_set_cpu(cpu, &set->used);
 	}
 
-	switch (msix->type) {
-	case IRQ_SDMA:
-		sde->cpu = cpu;
-		break;
-	case IRQ_GENERAL:
-	case IRQ_RCVCTXT:
-	case IRQ_OTHER:
-		break;
-	}
-
 	cpumask_set_cpu(cpu, &msix->mask);
 	dd_dev_info(dd, "IRQ vector: %u, type %s %s -> cpu: %d\n",
 		    msix->msix.vector, irq_type_names[msix->type],
 		    extra, cpu);
 	irq_set_affinity_hint(msix->msix.vector, &msix->mask);
 
+	if (msix->type == IRQ_SDMA) {
+		sde->cpu = cpu;
+		hfi1_setup_sdma_notifier(msix);
+	}
+
 	free_cpumask_var(diff);
 	return 0;
 }
@@ -417,6 +508,7 @@ void hfi1_put_irq_affinity(struct hfi1_devdata *dd,
 	switch (msix->type) {
 	case IRQ_SDMA:
 		set = &entry->def_intr;
+		hfi1_cleanup_sdma_notifier(msix);
 		break;
 	case IRQ_GENERAL:
 		/* Don't do accounting for general contexts */
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 59f69fa..7eef11b 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -531,6 +531,7 @@ struct hfi1_msix_entry {
 	void *arg;
 	char name[MAX_NAME_SIZE];
 	cpumask_t mask;
+	struct irq_affinity_notify notify;
 };
 
 /* per-SL CCA information */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
