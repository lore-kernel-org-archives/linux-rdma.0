From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 22/54] staging/rdma/hfi1: Consolidate CPU/IRQ affinity
 support
Date: Wed, 03 Feb 2016 14:33:40 -0800
Message-ID: <20160203223336.5923.13211.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch unifies the affinity support for CPU and IRQ allocations into
a single code base. The goal is to allow the driver to make intelligent
placement decision based on an overall view of processes and IRQs across
as much of the driver as possible.

Pulling all the scattered affinity code into a single code base lays the
ground work for accomplishing the above goal.  For example, previous
implementations made user process placement decision solely based on
other user processes.  This algorithm is limited as it did not take into
account IRQ placement and could result in overloading certain CPUs.

A single code base also provides a much easier way to maintain and debug
any performance issues related to affinity.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/Makefile   |    3 
 drivers/staging/rdma/hfi1/affinity.c |  433 ++++++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/affinity.h |   94 +++++++
 drivers/staging/rdma/hfi1/chip.c     |  115 +--------
 drivers/staging/rdma/hfi1/file_ops.c |   27 ++
 drivers/staging/rdma/hfi1/hfi.h      |    8 -
 drivers/staging/rdma/hfi1/init.c     |   11 -
 7 files changed, 578 insertions(+), 113 deletions(-)
 create mode 100644 drivers/staging/rdma/hfi1/affinity.c
 create mode 100644 drivers/staging/rdma/hfi1/affinity.h

diff --git a/drivers/staging/rdma/hfi1/Makefile b/drivers/staging/rdma/hfi1/Makefile
index 9b3f7e9..6681b74 100644
--- a/drivers/staging/rdma/hfi1/Makefile
+++ b/drivers/staging/rdma/hfi1/Makefile
@@ -7,7 +7,8 @@
 #
 obj-$(CONFIG_INFINIBAND_HFI1) += hfi1.o
 
-hfi1-y := chip.o device.o diag.o driver.o efivar.o eprom.o file_ops.o firmware.o \
+hfi1-y := affinity.o chip.o device.o diag.o driver.o efivar.o \
+	eprom.o file_ops.o firmware.o \
 	init.o intr.o mad.o pcie.o pio.o pio_copy.o platform.o \
 	qp.o qsfp.o rc.o ruc.o sdma.o sysfs.o trace.o twsi.o \
 	uc.o ud.o user_exp_rcv.o user_pages.o user_sdma.o verbs.o
diff --git a/drivers/staging/rdma/hfi1/affinity.c b/drivers/staging/rdma/hfi1/affinity.c
new file mode 100644
index 0000000..59b2972
--- /dev/null
+++ b/drivers/staging/rdma/hfi1/affinity.c
@@ -0,0 +1,433 @@
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+#include <linux/topology.h>
+#include <linux/cpumask.h>
+#include <linux/module.h>
+
+#include "hfi.h"
+#include "affinity.h"
+#include "sdma.h"
+#include "trace.h"
+
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
+	/* spin lock to protect affinity struct */
+	spinlock_t lock;
+};
+
+/* Name of IRQ types, indexed by enum irq_type */
+static const char * const irq_type_names[] = {
+	"SDMA",
+	"RCVCTXT",
+	"GENERAL",
+	"OTHER",
+};
+
+static inline void init_cpu_mask_set(struct cpu_mask_set *set)
+{
+	cpumask_clear(&set->mask);
+	cpumask_clear(&set->used);
+	set->gen = 0;
+}
+
+/*
+ * Interrupt affinity.
+ *
+ * non-rcv avail gets a default mask that
+ * starts as possible cpus with threads reset
+ * and each rcv avail reset.
+ *
+ * rcv avail gets node relative 1 wrapping back
+ * to the node relative 1 as necessary.
+ *
+ */
+int hfi1_dev_affinity_init(struct hfi1_devdata *dd)
+{
+	int node = pcibus_to_node(dd->pcidev->bus);
+	struct hfi1_affinity *info;
+	const struct cpumask *local_mask;
+	int curr_cpu, possible, i, ht;
+
+	if (node < 0)
+		node = numa_node_id();
+	dd->node = node;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+	spin_lock_init(&info->lock);
+
+	init_cpu_mask_set(&info->def_intr);
+	init_cpu_mask_set(&info->rcv_intr);
+	init_cpu_mask_set(&info->proc);
+
+	local_mask = cpumask_of_node(dd->node);
+	if (cpumask_first(local_mask) >= nr_cpu_ids)
+		local_mask = topology_core_cpumask(0);
+	/* use local mask as default */
+	cpumask_copy(&info->def_intr.mask, local_mask);
+	/*
+	 * Remove HT cores from the default mask.  Do this in two steps below.
+	 */
+	possible = cpumask_weight(&info->def_intr.mask);
+	ht = cpumask_weight(topology_sibling_cpumask(
+					cpumask_first(&info->def_intr.mask)));
+	/*
+	 * Step 1.  Skip over the first N HT siblings and use them as the
+	 * "real" cores.  Assumes that HT cores are not enumerated in
+	 * succession (except in the single core case).
+	 */
+	curr_cpu = cpumask_first(&info->def_intr.mask);
+	for (i = 0; i < possible / ht; i++)
+		curr_cpu = cpumask_next(curr_cpu, &info->def_intr.mask);
+	/*
+	 * Step 2.  Remove the remaining HT siblings.  Use cpumask_next() to
+	 * skip any gaps.
+	 */
+	for (; i < possible; i++) {
+		cpumask_clear_cpu(curr_cpu, &info->def_intr.mask);
+		curr_cpu = cpumask_next(curr_cpu, &info->def_intr.mask);
+	}
+
+	/*  fill in the receive list */
+	possible = cpumask_weight(&info->def_intr.mask);
+	curr_cpu = cpumask_first(&info->def_intr.mask);
+	if (possible == 1) {
+		/*  only one CPU, everyone will use it */
+		cpumask_set_cpu(curr_cpu, &info->rcv_intr.mask);
+	} else {
+		/*
+		 * Retain the first CPU in the default list for the control
+		 * context.
+		 */
+		curr_cpu = cpumask_next(curr_cpu, &info->def_intr.mask);
+		/*
+		 * Remove the remaining kernel receive queues from
+		 * the default list and add them to the receive list.
+		 */
+		for (i = 0; i < dd->n_krcv_queues - 1; i++) {
+			cpumask_clear_cpu(curr_cpu, &info->def_intr.mask);
+			cpumask_set_cpu(curr_cpu, &info->rcv_intr.mask);
+			curr_cpu = cpumask_next(curr_cpu, &info->def_intr.mask);
+			if (curr_cpu >= nr_cpu_ids)
+				break;
+		}
+	}
+
+	cpumask_copy(&info->proc.mask, cpu_online_mask);
+	dd->affinity = info;
+	return 0;
+}
+
+void hfi1_dev_affinity_free(struct hfi1_devdata *dd)
+{
+	kfree(dd->affinity);
+}
+
+int hfi1_get_irq_affinity(struct hfi1_devdata *dd, struct hfi1_msix_entry *msix)
+{
+	int ret;
+	cpumask_var_t diff;
+	struct cpu_mask_set *set;
+	struct sdma_engine *sde = NULL;
+	struct hfi1_ctxtdata *rcd = NULL;
+	char extra[64];
+	int cpu = -1;
+
+	extra[0] = '\0';
+	cpumask_clear(&msix->mask);
+
+	ret = zalloc_cpumask_var(&diff, GFP_KERNEL);
+	if (!ret)
+		return -ENOMEM;
+
+	switch (msix->type) {
+	case IRQ_SDMA:
+		sde = (struct sdma_engine *)msix->arg;
+		scnprintf(extra, 64, "engine %u", sde->this_idx);
+		/* fall through */
+	case IRQ_GENERAL:
+		set = &dd->affinity->def_intr;
+		break;
+	case IRQ_RCVCTXT:
+		rcd = (struct hfi1_ctxtdata *)msix->arg;
+		if (rcd->ctxt == HFI1_CTRL_CTXT) {
+			set = &dd->affinity->def_intr;
+			cpu = cpumask_first(&set->mask);
+		} else {
+			set = &dd->affinity->rcv_intr;
+		}
+		scnprintf(extra, 64, "ctxt %u", rcd->ctxt);
+		break;
+	default:
+		dd_dev_err(dd, "Invalid IRQ type %d\n", msix->type);
+		return -EINVAL;
+	}
+
+	/*
+	 * The control receive context is placed on a particular CPU, which
+	 * is set above.  Skip accounting for it.  Everything else finds its
+	 * CPU here.
+	 */
+	if (cpu == -1) {
+		spin_lock(&dd->affinity->lock);
+		if (cpumask_equal(&set->mask, &set->used)) {
+			/*
+			 * We've used up all the CPUs, bump up the generation
+			 * and reset the 'used' map
+			 */
+			set->gen++;
+			cpumask_clear(&set->used);
+		}
+		cpumask_andnot(diff, &set->mask, &set->used);
+		cpu = cpumask_first(diff);
+		cpumask_set_cpu(cpu, &set->used);
+		spin_unlock(&dd->affinity->lock);
+	}
+
+	switch (msix->type) {
+	case IRQ_SDMA:
+		sde->cpu = cpu;
+		break;
+	case IRQ_GENERAL:
+	case IRQ_RCVCTXT:
+	case IRQ_OTHER:
+		break;
+	}
+
+	cpumask_set_cpu(cpu, &msix->mask);
+	dd_dev_info(dd, "IRQ vector: %u, type %s %s -> cpu: %d\n",
+		    msix->msix.vector, irq_type_names[msix->type],
+		    extra, cpu);
+	irq_set_affinity_hint(msix->msix.vector, &msix->mask);
+
+	free_cpumask_var(diff);
+	return 0;
+}
+
+void hfi1_put_irq_affinity(struct hfi1_devdata *dd,
+			   struct hfi1_msix_entry *msix)
+{
+	struct cpu_mask_set *set = NULL;
+	struct hfi1_ctxtdata *rcd;
+
+	switch (msix->type) {
+	case IRQ_SDMA:
+	case IRQ_GENERAL:
+		set = &dd->affinity->def_intr;
+		break;
+	case IRQ_RCVCTXT:
+		rcd = (struct hfi1_ctxtdata *)msix->arg;
+		/* only do accounting for non control contexts */
+		if (rcd->ctxt != HFI1_CTRL_CTXT)
+			set = &dd->affinity->rcv_intr;
+		break;
+	default:
+		return;
+	}
+
+	if (set) {
+		spin_lock(&dd->affinity->lock);
+		cpumask_andnot(&set->used, &set->used, &msix->mask);
+		if (cpumask_empty(&set->used) && set->gen) {
+			set->gen--;
+			cpumask_copy(&set->used, &set->mask);
+		}
+		spin_unlock(&dd->affinity->lock);
+	}
+
+	irq_set_affinity_hint(msix->msix.vector, NULL);
+	cpumask_clear(&msix->mask);
+}
+
+int hfi1_get_proc_affinity(struct hfi1_devdata *dd, int node)
+{
+	int cpu = -1, ret;
+	cpumask_var_t diff, mask, intrs;
+	const struct cpumask *node_mask,
+		*proc_mask = tsk_cpus_allowed(current);
+	struct cpu_mask_set *set = &dd->affinity->proc;
+	char buf[1024];
+
+	/*
+	 * check whether process/context affinity has already
+	 * been set
+	 */
+	if (cpumask_weight(proc_mask) == 1) {
+		scnprintf(buf, 1024, "%*pbl", cpumask_pr_args(proc_mask));
+		hfi1_cdbg(PROC, "PID %u %s affinity set to CPU %s",
+			  current->pid, current->comm, buf);
+		/*
+		 * Mark the pre-set CPU as used. This is atomic so we don't
+		 * need the lock
+		 */
+		cpu = cpumask_first(proc_mask);
+		cpumask_set_cpu(cpu, &set->used);
+		goto done;
+	} else if (cpumask_weight(proc_mask) < cpumask_weight(&set->mask)) {
+		scnprintf(buf, 1024, "%*pbl", cpumask_pr_args(proc_mask));
+		hfi1_cdbg(PROC, "PID %u %s affinity set to CPU set(s) %s",
+			  current->pid, current->comm, buf);
+		goto done;
+	}
+
+	/*
+	 * The process does not have a preset CPU affinity so find one to
+	 * recommend. We prefer CPUs on the same NUMA as the device.
+	 */
+
+	ret = zalloc_cpumask_var(&diff, GFP_KERNEL);
+	if (!ret)
+		goto done;
+	ret = zalloc_cpumask_var(&mask, GFP_KERNEL);
+	if (!ret)
+		goto free_diff;
+	ret = zalloc_cpumask_var(&intrs, GFP_KERNEL);
+	if (!ret)
+		goto free_mask;
+
+	spin_lock(&dd->affinity->lock);
+	/*
+	 * If we've used all available CPUs, clear the mask and start
+	 * overloading.
+	 */
+	if (cpumask_equal(&set->mask, &set->used)) {
+		set->gen++;
+		cpumask_clear(&set->used);
+	}
+
+	/* CPUs used by interrupt handlers */
+	cpumask_copy(intrs, (dd->affinity->def_intr.gen ?
+			     &dd->affinity->def_intr.mask :
+			     &dd->affinity->def_intr.used));
+	cpumask_or(intrs, intrs, (dd->affinity->rcv_intr.gen ?
+				  &dd->affinity->rcv_intr.mask :
+				  &dd->affinity->rcv_intr.used));
+	scnprintf(buf, 1024, "%*pbl", cpumask_pr_args(intrs));
+	hfi1_cdbg(PROC, "CPUs used by interrupts: %s", buf);
+
+	/*
+	 * If we don't have a NUMA node requested, preference is towards
+	 * device NUMA node
+	 */
+	if (node == -1)
+		node = dd->node;
+	node_mask = cpumask_of_node(node);
+	scnprintf(buf, 1024, "%*pbl", cpumask_pr_args(node_mask));
+	hfi1_cdbg(PROC, "device on NUMA %u, CPUs %s", node, buf);
+
+	/* diff will hold all unused cpus */
+	cpumask_andnot(diff, &set->mask, &set->used);
+	scnprintf(buf, 1024, "%*pbl", cpumask_pr_args(diff));
+	hfi1_cdbg(PROC, "unused CPUs (all) %s", buf);
+
+	/* get cpumask of available CPUs on preferred NUMA */
+	cpumask_and(mask, diff, node_mask);
+	scnprintf(buf, 1024, "%*pbl", cpumask_pr_args(mask));
+	hfi1_cdbg(PROC, "available cpus on NUMA %s", buf);
+
+	/*
+	 * At first, we don't want to place processes on the same
+	 * CPUs as interrupt handlers.
+	 */
+	cpumask_andnot(diff, mask, intrs);
+	if (!cpumask_empty(diff))
+		cpumask_copy(mask, diff);
+
+	/*
+	 * if we don't have a cpu on the preferred NUMA, get
+	 * the list of the remaining available CPUs
+	 */
+	if (cpumask_empty(mask)) {
+		cpumask_andnot(diff, &set->mask, &set->used);
+		cpumask_andnot(mask, diff, node_mask);
+	}
+	scnprintf(buf, 1024, "%*pbl", cpumask_pr_args(mask));
+	hfi1_cdbg(PROC, "possible CPUs for process %s", buf);
+
+	cpu = cpumask_first(mask);
+	if (cpu >= nr_cpu_ids) /* empty */
+		cpu = -1;
+	else
+		cpumask_set_cpu(cpu, &set->used);
+	spin_unlock(&dd->affinity->lock);
+
+	free_cpumask_var(intrs);
+free_mask:
+	free_cpumask_var(mask);
+free_diff:
+	free_cpumask_var(diff);
+done:
+	return cpu;
+}
+
+void hfi1_put_proc_affinity(struct hfi1_devdata *dd, int cpu)
+{
+	struct cpu_mask_set *set = &dd->affinity->proc;
+
+	if (cpu < 0)
+		return;
+	spin_lock(&dd->affinity->lock);
+	cpumask_clear_cpu(cpu, &set->used);
+	if (cpumask_empty(&set->used) && set->gen) {
+		set->gen--;
+		cpumask_copy(&set->used, &set->mask);
+	}
+	spin_unlock(&dd->affinity->lock);
+}
+
diff --git a/drivers/staging/rdma/hfi1/affinity.h b/drivers/staging/rdma/hfi1/affinity.h
new file mode 100644
index 0000000..2bdac96
--- /dev/null
+++ b/drivers/staging/rdma/hfi1/affinity.h
@@ -0,0 +1,94 @@
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+#ifndef _HFI1_AFFINITY_H
+#define _HFI1_AFFINITY_H
+
+#include "hfi.h"
+
+enum irq_type {
+	IRQ_SDMA,
+	IRQ_RCVCTXT,
+	IRQ_GENERAL,
+	IRQ_OTHER
+};
+
+/* Can be used for both memory and cpu */
+enum affinity_flags {
+	AFF_AUTO,
+	AFF_NUMA_LOCAL,
+	AFF_DEV_LOCAL,
+	AFF_IRQ_LOCAL
+};
+
+struct hfi1_msix_entry;
+
+/* Initialize driver affinity data */
+int hfi1_dev_affinity_init(struct hfi1_devdata *);
+/* Free driver affinity data */
+void hfi1_dev_affinity_free(struct hfi1_devdata *);
+/*
+ * Set IRQ affinity to a CPU. The function will determine the
+ * CPU and set the affinity to it.
+ */
+int hfi1_get_irq_affinity(struct hfi1_devdata *, struct hfi1_msix_entry *);
+/*
+ * Remove the IRQ's CPU affinity. This function also updates
+ * any internal CPU tracking data
+ */
+void hfi1_put_irq_affinity(struct hfi1_devdata *, struct hfi1_msix_entry *);
+/*
+ * Determine a CPU affinity for a user process, if the process does not
+ * have an affinity set yet.
+ */
+int hfi1_get_proc_affinity(struct hfi1_devdata *, int);
+/* Release a CPU used by a user process. */
+void hfi1_put_proc_affinity(struct hfi1_devdata *, int);
+
+#endif /* _HFI1_AFFINITY_H */
diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 3577042..6045c91 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -12349,9 +12349,8 @@ static void clean_up_interrupts(struct hfi1_devdata *dd)
 
 		for (i = 0; i < dd->num_msix_entries; i++, me++) {
 			if (me->arg == NULL) /* => no irq, no affinity */
-				break;
-			irq_set_affinity_hint(dd->msix_entries[i].msix.vector,
-					NULL);
+				continue;
+			hfi1_put_irq_affinity(dd, &dd->msix_entries[i]);
 			free_irq(me->msix.vector, me->arg);
 		}
 	} else {
@@ -12372,8 +12371,6 @@ static void clean_up_interrupts(struct hfi1_devdata *dd)
 	}
 
 	/* clean structures */
-	for (i = 0; i < dd->num_msix_entries; i++)
-		free_cpumask_var(dd->msix_entries[i].mask);
 	kfree(dd->msix_entries);
 	dd->msix_entries = NULL;
 	dd->num_msix_entries = 0;
@@ -12438,16 +12435,10 @@ static int request_intx_irq(struct hfi1_devdata *dd)
 
 static int request_msix_irqs(struct hfi1_devdata *dd)
 {
-	const struct cpumask *local_mask;
-	cpumask_var_t def, rcv;
-	bool def_ret, rcv_ret;
 	int first_general, last_general;
 	int first_sdma, last_sdma;
 	int first_rx, last_rx;
-	int first_cpu, curr_cpu;
-	int rcv_cpu, sdma_cpu;
-	int i, ret = 0, possible;
-	int ht;
+	int i, ret = 0;
 
 	/* calculate the ranges we are going to use */
 	first_general = 0;
@@ -12456,52 +12447,6 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 	last_rx = first_rx + dd->n_krcv_queues;
 
 	/*
-	 * Interrupt affinity.
-	 *
-	 * non-rcv avail gets a default mask that
-	 * starts as possible cpus with threads reset
-	 * and each rcv avail reset.
-	 *
-	 * rcv avail gets node relative 1 wrapping back
-	 * to the node relative 1 as necessary.
-	 *
-	 */
-	local_mask = cpumask_of_pcibus(dd->pcidev->bus);
-	/* if first cpu is invalid, use NUMA 0 */
-	if (cpumask_first(local_mask) >= nr_cpu_ids)
-		local_mask = topology_core_cpumask(0);
-
-	def_ret = zalloc_cpumask_var(&def, GFP_KERNEL);
-	rcv_ret = zalloc_cpumask_var(&rcv, GFP_KERNEL);
-	if (!def_ret || !rcv_ret)
-		goto bail;
-	/* use local mask as default */
-	cpumask_copy(def, local_mask);
-	possible = cpumask_weight(def);
-	/* disarm threads from default */
-	ht = cpumask_weight(
-			topology_sibling_cpumask(cpumask_first(local_mask)));
-	for (i = possible/ht; i < possible; i++)
-		cpumask_clear_cpu(i, def);
-	/* def now has full cores on chosen node*/
-	first_cpu = cpumask_first(def);
-	if (nr_cpu_ids >= first_cpu)
-		first_cpu++;
-	curr_cpu = first_cpu;
-
-	/*  One context is reserved as control context */
-	for (i = first_cpu; i < dd->n_krcv_queues + first_cpu - 1; i++) {
-		cpumask_clear_cpu(curr_cpu, def);
-		cpumask_set_cpu(curr_cpu, rcv);
-		curr_cpu = cpumask_next(curr_cpu, def);
-		if (curr_cpu >= nr_cpu_ids)
-			break;
-	}
-	/* def mask has non-rcv, rcv has recv mask */
-	rcv_cpu = cpumask_first(rcv);
-	sdma_cpu = cpumask_first(def);
-
-	/*
 	 * Sanity check - the code expects all SDMA chip source
 	 * interrupts to be in the same CSR, starting at bit 0.  Verify
 	 * that this is true by checking the bit location of the start.
@@ -12526,6 +12471,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 			snprintf(me->name, sizeof(me->name),
 				 DRIVER_NAME "_%d", dd->unit);
 			err_info = "general";
+			me->type = IRQ_GENERAL;
 		} else if (first_sdma <= i && i < last_sdma) {
 			idx = i - first_sdma;
 			sde = &dd->per_sdma[idx];
@@ -12535,6 +12481,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 				 DRIVER_NAME "_%d sdma%d", dd->unit, idx);
 			err_info = "sdma";
 			remap_sdma_interrupts(dd, idx, i);
+			me->type = IRQ_SDMA;
 		} else if (first_rx <= i && i < last_rx) {
 			idx = i - first_rx;
 			rcd = dd->rcd[idx];
@@ -12555,6 +12502,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 				 DRIVER_NAME "_%d kctxt%d", dd->unit, idx);
 			err_info = "receive context";
 			remap_intr(dd, IS_RCVAVAIL_START + idx, i);
+			me->type = IRQ_RCVCTXT;
 		} else {
 			/* not in our expected range - complain, then
 			   ignore it */
@@ -12582,52 +12530,13 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 		 */
 		me->arg = arg;
 
-		if (!zalloc_cpumask_var(
-			&dd->msix_entries[i].mask,
-			GFP_KERNEL))
-			goto bail;
-		if (handler == sdma_interrupt) {
-			dd_dev_info(dd, "sdma engine %d cpu %d\n",
-				sde->this_idx, sdma_cpu);
-			sde->cpu = sdma_cpu;
-			cpumask_set_cpu(sdma_cpu, dd->msix_entries[i].mask);
-			sdma_cpu = cpumask_next(sdma_cpu, def);
-			if (sdma_cpu >= nr_cpu_ids)
-				sdma_cpu = cpumask_first(def);
-		} else if (handler == receive_context_interrupt) {
-			dd_dev_info(dd, "rcv ctxt %d cpu %d\n", rcd->ctxt,
-				    (rcd->ctxt == HFI1_CTRL_CTXT) ?
-					    cpumask_first(def) : rcv_cpu);
-			if (rcd->ctxt == HFI1_CTRL_CTXT) {
-				/* map to first default */
-				cpumask_set_cpu(cpumask_first(def),
-						dd->msix_entries[i].mask);
-			} else {
-				cpumask_set_cpu(rcv_cpu,
-						dd->msix_entries[i].mask);
-				rcv_cpu = cpumask_next(rcv_cpu, rcv);
-				if (rcv_cpu >= nr_cpu_ids)
-					rcv_cpu = cpumask_first(rcv);
-			}
-		} else {
-			/* otherwise first def */
-			dd_dev_info(dd, "%s cpu %d\n",
-				err_info, cpumask_first(def));
-			cpumask_set_cpu(
-				cpumask_first(def), dd->msix_entries[i].mask);
-		}
-		irq_set_affinity_hint(
-			dd->msix_entries[i].msix.vector,
-			dd->msix_entries[i].mask);
+		ret = hfi1_get_irq_affinity(dd, me);
+		if (ret)
+			dd_dev_err(dd,
+				   "unable to pin IRQ %d\n", ret);
 	}
 
-out:
-	free_cpumask_var(def);
-	free_cpumask_var(rcv);
 	return ret;
-bail:
-	ret = -ENOMEM;
-	goto  out;
 }
 
 /*
@@ -14238,6 +14147,10 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	/* set up KDETH QP prefix in both RX and TX CSRs */
 	init_kdeth_qp(dd);
 
+	ret = hfi1_dev_affinity_init(dd);
+	if (ret)
+		goto bail_cleanup;
+
 	/* send contexts must be set up before receive contexts */
 	ret = init_send_contexts(dd);
 	if (ret)
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 084581a..c9172a0 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -749,6 +749,9 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	/* drain user sdma queue */
 	hfi1_user_sdma_free_queues(fdata);
 
+	/* release the cpu */
+	hfi1_put_proc_affinity(dd, fdata->rec_cpu_num);
+
 	/*
 	 * Clear any left over, unhandled events so the next process that
 	 * gets this context doesn't get confused.
@@ -842,8 +845,16 @@ static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo)
 
 	mutex_lock(&hfi1_mutex);
 	/* First, lets check if we need to setup a shared context? */
-	if (uinfo->subctxt_cnt)
+	if (uinfo->subctxt_cnt) {
+		struct hfi1_filedata *fd = fp->private_data;
+
 		ret = find_shared_ctxt(fp, uinfo);
+		if (ret < 0)
+			goto done_unlock;
+		if (ret)
+			fd->rec_cpu_num = hfi1_get_proc_affinity(
+				fd->uctxt->dd, fd->uctxt->numa_id);
+	}
 
 	/*
 	 * We execute the following block if we couldn't find a
@@ -853,6 +864,7 @@ static int assign_ctxt(struct file *fp, struct hfi1_user_info *uinfo)
 		i_minor = iminor(file_inode(fp)) - HFI1_USER_MINOR_BASE;
 		ret = get_user_context(fp, uinfo, i_minor - 1, alg);
 	}
+done_unlock:
 	mutex_unlock(&hfi1_mutex);
 done:
 	return ret;
@@ -978,7 +990,7 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt;
 	unsigned ctxt;
-	int ret;
+	int ret, numa;
 
 	if (dd->flags & HFI1_FROZEN) {
 		/*
@@ -998,12 +1010,21 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 	if (ctxt == dd->num_rcv_contexts)
 		return -EBUSY;
 
-	uctxt = hfi1_create_ctxtdata(dd->pport, ctxt);
+	fd->rec_cpu_num = hfi1_get_proc_affinity(dd, -1);
+	if (fd->rec_cpu_num != -1)
+		numa = cpu_to_node(fd->rec_cpu_num);
+	else
+		numa = numa_node_id();
+	uctxt = hfi1_create_ctxtdata(dd->pport, ctxt, numa);
 	if (!uctxt) {
 		dd_dev_err(dd,
 			   "Unable to allocate ctxtdata memory, failing open\n");
 		return -ENOMEM;
 	}
+	hfi1_cdbg(PROC, "[%u:%u] pid %u assigned to CPU %d (NUMA %u)",
+		  uctxt->ctxt, fd->subctxt, current->pid, fd->rec_cpu_num,
+		  uctxt->numa_id);
+
 	/*
 	 * Allocate and enable a PIO send context.
 	 */
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 897046c..571e7b1 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -75,6 +75,7 @@
 #include "mad.h"
 #include "qsfp.h"
 #include "platform.h"
+#include "affinity.h"
 
 /* bumped 1 from s/w major version of TrueScale */
 #define HFI1_CHIP_VERS_MAJ 3U
@@ -529,10 +530,11 @@ static inline void incr_cntr32(u32 *cntr)
 
 #define MAX_NAME_SIZE 64
 struct hfi1_msix_entry {
+	enum irq_type type;
 	struct msix_entry msix;
 	void *arg;
 	char name[MAX_NAME_SIZE];
-	cpumask_var_t mask;
+	cpumask_t mask;
 };
 
 /* per-SL CCA information */
@@ -1144,6 +1146,8 @@ struct hfi1_devdata {
 	spinlock_t aspm_lock;
 	/* Number of verbs contexts which have disabled ASPM */
 	atomic_t aspm_disabled_cnt;
+
+	struct hfi1_affinity *affinity;
 };
 
 /* 8051 firmware version helper */
@@ -1197,7 +1201,7 @@ void handle_user_interrupt(struct hfi1_ctxtdata *rcd);
 int hfi1_create_rcvhdrq(struct hfi1_devdata *, struct hfi1_ctxtdata *);
 int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *);
 int hfi1_create_ctxts(struct hfi1_devdata *dd);
-struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *, u32);
+struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *, u32, int);
 void hfi1_init_pportdata(struct pci_dev *, struct hfi1_pportdata *,
 			 struct hfi1_devdata *, u8, u8);
 void hfi1_free_ctxtdata(struct hfi1_devdata *, struct hfi1_ctxtdata *);
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 17b876d..98b3fc1 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -144,7 +144,7 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 		struct hfi1_ctxtdata *rcd;
 
 		ppd = dd->pport + (i % dd->num_pports);
-		rcd = hfi1_create_ctxtdata(ppd, i);
+		rcd = hfi1_create_ctxtdata(ppd, i, dd->node);
 		if (!rcd) {
 			dd_dev_err(dd,
 				"Unable to allocate kernel receive context, failing\n");
@@ -204,7 +204,8 @@ bail:
 /*
  * Common code for user and kernel context setup.
  */
-struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt)
+struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
+					   int numa)
 {
 	struct hfi1_devdata *dd = ppd->dd;
 	struct hfi1_ctxtdata *rcd;
@@ -227,7 +228,7 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt)
 		rcd->cnt = 1;
 		rcd->ctxt = ctxt;
 		dd->rcd[ctxt] = rcd;
-		rcd->numa_id = numa_node_id();
+		rcd->numa_id = numa;
 		rcd->rcv_array_groups = dd->rcv_entries.ngroups;
 
 		mutex_init(&rcd->exp_lock);
@@ -982,6 +983,7 @@ void hfi1_free_devdata(struct hfi1_devdata *dd)
 	rcu_barrier(); /* wait for rcu callbacks to complete */
 	free_percpu(dd->int_counter);
 	free_percpu(dd->rcv_limit);
+	hfi1_dev_affinity_free(dd);
 	ib_dealloc_device(&dd->verbs_dev.rdi.ibdev);
 }
 
@@ -1010,9 +1012,6 @@ struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra)
 	dd->pport = (struct hfi1_pportdata *)(dd + 1);
 
 	INIT_LIST_HEAD(&dd->list);
-	dd->node = dev_to_node(&pdev->dev);
-	if (dd->node < 0)
-		dd->node = 0;
 	idr_preload(GFP_KERNEL);
 	spin_lock_irqsave(&hfi1_devs_lock, flags);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
