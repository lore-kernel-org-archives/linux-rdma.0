From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 18/54] staging/rdma/hfi1: Add support for enabling/disabling
 PCIe ASPM
Date: Wed, 03 Feb 2016 14:33:06 -0800
Message-ID: <20160203223302.5923.92377.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

hfi1 HW has a high PCIe ASPM L1 exit latency and also advertises an
acceptable latency less than actual ASPM latencies. Additional
mechanisms than those provided by BIOS/OS are therefore required to
enable/disable ASPM for hfi1 to provide acceptable power/performance
trade offs. This patch adds this support.

By means of a module parameter ASPM can be either (a) always enabled
(power save mode) (b) always disabled (performance mode) (c)
enabled/disabled dynamically. The dynamic mode implements two
heuristics to alleviate possible problems with high ASPM L1 exit
latency. ASPM is normally enabled but is disabled if (a) there are any
active user space PSM contexts, or (b) for verbs, ASPM is disabled as
interrupt activity for a context starts to increase.

A few more points about the verbs implementation. In order to reduce
lock/cache contention between multiple verbs contexts, some processing
is done at the context layer before contending for device layer
locks. ASPM is disabled when two interrupts for a context happen
within 1 millisec. A timer is scheduled which will re-enable ASPM
after 1 second should the interrupt activity cease. Normally, every
interrupt, or interrupt-pair should push the timer out
further. However, since this might increase the processing load per
interrupt, pushing the timer out is postponed for half a second. If
after half a second we get two interrupts within 1 millisec the timer
is pushed out by another second.

Finally, the kernel ASPM API is not used in this patch. This is
because this patch does several non-standard things as SW workarounds
for HW issues. As mentioned above, it enables ASPM even when advertised
actual latencies are greater than acceptable latencies. Also, whereas
the kernel API only allows drivers to disable ASPM from driver probe,
this patch enables/disables ASPM directly from interrupt context. Due
to these reasons the kernel ASPM API was not used.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/aspm.h           |  297 ++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/chip.c           |    4 
 drivers/staging/rdma/hfi1/chip_registers.h |    3 
 drivers/staging/rdma/hfi1/file_ops.c       |   11 +
 drivers/staging/rdma/hfi1/hfi.h            |   24 ++
 drivers/staging/rdma/hfi1/init.c           |    7 +
 drivers/staging/rdma/hfi1/pcie.c           |   16 +-
 7 files changed, 355 insertions(+), 7 deletions(-)
 create mode 100644 drivers/staging/rdma/hfi1/aspm.h

diff --git a/drivers/staging/rdma/hfi1/aspm.h b/drivers/staging/rdma/hfi1/aspm.h
new file mode 100644
index 0000000..67fce1d
--- /dev/null
+++ b/drivers/staging/rdma/hfi1/aspm.h
@@ -0,0 +1,297 @@
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
+#ifndef _ASPM_H
+#define _ASPM_H
+
+#include "hfi.h"
+
+extern uint aspm_mode;
+
+enum aspm_mode {
+	ASPM_MODE_DISABLED = 0,	/* ASPM always disabled, performance mode */
+	ASPM_MODE_ENABLED = 1,	/* ASPM always enabled, power saving mode */
+	ASPM_MODE_DYNAMIC = 2,	/* ASPM enabled/disabled dynamically */
+};
+
+/* Time after which the timer interrupt will re-enable ASPM */
+#define ASPM_TIMER_MS 1000
+/* Time for which interrupts are ignored after a timer has been scheduled */
+#define ASPM_RESCHED_TIMER_MS (ASPM_TIMER_MS / 2)
+/* Two interrupts within this time trigger ASPM disable */
+#define ASPM_TRIGGER_MS 1
+#define ASPM_TRIGGER_NS (ASPM_TRIGGER_MS * 1000 * 1000ull)
+#define ASPM_L1_SUPPORTED(reg) \
+	(((reg & PCI_EXP_LNKCAP_ASPMS) >> 10) & 0x2)
+
+static inline bool aspm_hw_l1_supported(struct hfi1_devdata *dd)
+{
+	struct pci_dev *parent = dd->pcidev->bus->self;
+	u32 up, dn;
+
+	pcie_capability_read_dword(dd->pcidev, PCI_EXP_LNKCAP, &dn);
+	dn = ASPM_L1_SUPPORTED(dn);
+
+	pcie_capability_read_dword(parent, PCI_EXP_LNKCAP, &up);
+	up = ASPM_L1_SUPPORTED(up);
+
+	/* ASPM works on A-step but is reported as not supported */
+	return (!!dn || is_ax(dd)) && !!up;
+}
+
+/* Set L1 entrance latency for slower entry to L1 */
+static inline void aspm_hw_set_l1_ent_latency(struct hfi1_devdata *dd)
+{
+	u32 l1_ent_lat = 0x4u;
+	u32 reg32;
+
+	pci_read_config_dword(dd->pcidev, PCIE_CFG_REG_PL3, &reg32);
+	reg32 &= ~PCIE_CFG_REG_PL3_L1_ENT_LATENCY_SMASK;
+	reg32 |= l1_ent_lat << PCIE_CFG_REG_PL3_L1_ENT_LATENCY_SHIFT;
+	pci_write_config_dword(dd->pcidev, PCIE_CFG_REG_PL3, reg32);
+}
+
+static inline void aspm_hw_enable_l1(struct hfi1_devdata *dd)
+{
+	struct pci_dev *parent = dd->pcidev->bus->self;
+
+	/* Enable ASPM L1 first in upstream component and then downstream */
+	pcie_capability_clear_and_set_word(parent, PCI_EXP_LNKCTL,
+					   PCI_EXP_LNKCTL_ASPMC,
+					   PCI_EXP_LNKCTL_ASPM_L1);
+	pcie_capability_clear_and_set_word(dd->pcidev, PCI_EXP_LNKCTL,
+					   PCI_EXP_LNKCTL_ASPMC,
+					   PCI_EXP_LNKCTL_ASPM_L1);
+}
+
+static inline void aspm_hw_disable_l1(struct hfi1_devdata *dd)
+{
+	struct pci_dev *parent = dd->pcidev->bus->self;
+
+	/* Disable ASPM L1 first in downstream component and then upstream */
+	pcie_capability_clear_and_set_word(dd->pcidev, PCI_EXP_LNKCTL,
+					   PCI_EXP_LNKCTL_ASPMC, 0x0);
+	pcie_capability_clear_and_set_word(parent, PCI_EXP_LNKCTL,
+					   PCI_EXP_LNKCTL_ASPMC, 0x0);
+}
+
+static inline void aspm_enable(struct hfi1_devdata *dd)
+{
+	if (dd->aspm_enabled || aspm_mode == ASPM_MODE_DISABLED ||
+	    !dd->aspm_supported)
+		return;
+
+	aspm_hw_enable_l1(dd);
+	dd->aspm_enabled = true;
+}
+
+static inline void aspm_disable(struct hfi1_devdata *dd)
+{
+	if (!dd->aspm_enabled || aspm_mode == ASPM_MODE_ENABLED)
+		return;
+
+	aspm_hw_disable_l1(dd);
+	dd->aspm_enabled = false;
+}
+
+static inline void aspm_disable_inc(struct hfi1_devdata *dd)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dd->aspm_lock, flags);
+	aspm_disable(dd);
+	atomic_inc(&dd->aspm_disabled_cnt);
+	spin_unlock_irqrestore(&dd->aspm_lock, flags);
+}
+
+static inline void aspm_enable_dec(struct hfi1_devdata *dd)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dd->aspm_lock, flags);
+	if (atomic_dec_and_test(&dd->aspm_disabled_cnt))
+		aspm_enable(dd);
+	spin_unlock_irqrestore(&dd->aspm_lock, flags);
+}
+
+/* ASPM processing for each receive context interrupt */
+static inline void aspm_ctx_disable(struct hfi1_ctxtdata *rcd)
+{
+	bool restart_timer;
+	bool close_interrupts;
+	unsigned long flags;
+	ktime_t now, prev;
+
+	/* Quickest exit for minimum impact */
+	if (!rcd->aspm_intr_supported)
+		return;
+
+	spin_lock_irqsave(&rcd->aspm_lock, flags);
+	/* PSM contexts are open */
+	if (!rcd->aspm_intr_enable)
+		goto unlock;
+
+	prev = rcd->aspm_ts_last_intr;
+	now = ktime_get();
+	rcd->aspm_ts_last_intr = now;
+
+	/* An interrupt pair close together in time */
+	close_interrupts = ktime_to_ns(ktime_sub(now, prev)) < ASPM_TRIGGER_NS;
+
+	/* Don't push out our timer till this much time has elapsed */
+	restart_timer = ktime_to_ns(ktime_sub(now, rcd->aspm_ts_timer_sched)) >
+				    ASPM_RESCHED_TIMER_MS * NSEC_PER_MSEC;
+	restart_timer = restart_timer && close_interrupts;
+
+	/* Disable ASPM and schedule timer */
+	if (rcd->aspm_enabled && close_interrupts) {
+		aspm_disable_inc(rcd->dd);
+		rcd->aspm_enabled = false;
+		restart_timer = true;
+	}
+
+	if (restart_timer) {
+		mod_timer(&rcd->aspm_timer,
+			  jiffies + msecs_to_jiffies(ASPM_TIMER_MS));
+		rcd->aspm_ts_timer_sched = now;
+	}
+unlock:
+	spin_unlock_irqrestore(&rcd->aspm_lock, flags);
+}
+
+/* Timer function for re-enabling ASPM in the absence of interrupt activity */
+static inline void aspm_ctx_timer_function(unsigned long data)
+{
+	struct hfi1_ctxtdata *rcd = (struct hfi1_ctxtdata *)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rcd->aspm_lock, flags);
+	aspm_enable_dec(rcd->dd);
+	rcd->aspm_enabled = true;
+	spin_unlock_irqrestore(&rcd->aspm_lock, flags);
+}
+
+/* Disable interrupt processing for verbs contexts when PSM contexts are open */
+static inline void aspm_disable_all(struct hfi1_devdata *dd)
+{
+	struct hfi1_ctxtdata *rcd;
+	unsigned long flags;
+	unsigned i;
+
+	for (i = 0; i < dd->first_user_ctxt; i++) {
+		rcd = dd->rcd[i];
+		del_timer_sync(&rcd->aspm_timer);
+		spin_lock_irqsave(&rcd->aspm_lock, flags);
+		rcd->aspm_intr_enable = false;
+		spin_unlock_irqrestore(&rcd->aspm_lock, flags);
+	}
+
+	aspm_disable(dd);
+	atomic_set(&dd->aspm_disabled_cnt, 0);
+}
+
+/* Re-enable interrupt processing for verbs contexts */
+static inline void aspm_enable_all(struct hfi1_devdata *dd)
+{
+	struct hfi1_ctxtdata *rcd;
+	unsigned long flags;
+	unsigned i;
+
+	aspm_enable(dd);
+
+	if (aspm_mode != ASPM_MODE_DYNAMIC)
+		return;
+
+	for (i = 0; i < dd->first_user_ctxt; i++) {
+		rcd = dd->rcd[i];
+		spin_lock_irqsave(&rcd->aspm_lock, flags);
+		rcd->aspm_intr_enable = true;
+		rcd->aspm_enabled = true;
+		spin_unlock_irqrestore(&rcd->aspm_lock, flags);
+	}
+}
+
+static inline void aspm_ctx_init(struct hfi1_ctxtdata *rcd)
+{
+	spin_lock_init(&rcd->aspm_lock);
+	setup_timer(&rcd->aspm_timer, aspm_ctx_timer_function,
+		    (unsigned long)rcd);
+	rcd->aspm_intr_supported = rcd->dd->aspm_supported &&
+		aspm_mode == ASPM_MODE_DYNAMIC &&
+		rcd->ctxt < rcd->dd->first_user_ctxt;
+}
+
+static inline void aspm_init(struct hfi1_devdata *dd)
+{
+	unsigned i;
+
+	spin_lock_init(&dd->aspm_lock);
+	dd->aspm_supported = aspm_hw_l1_supported(dd);
+
+	for (i = 0; i < dd->first_user_ctxt; i++)
+		aspm_ctx_init(dd->rcd[i]);
+
+	/* Start with ASPM disabled */
+	aspm_hw_set_l1_ent_latency(dd);
+	dd->aspm_enabled = false;
+	aspm_hw_disable_l1(dd);
+
+	/* Now turn on ASPM if configured */
+	aspm_enable_all(dd);
+}
+
+static inline void aspm_exit(struct hfi1_devdata *dd)
+{
+	aspm_disable_all(dd);
+
+	/* Turn on ASPM on exit to conserve power */
+	aspm_enable(dd);
+}
+
+#endif /* _ASPM_H */
diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index d10ba67..3577042 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -65,6 +65,7 @@
 #include "eprom.h"
 #include "efivar.h"
 #include "platform.h"
+#include "aspm.h"
 
 #define NUM_IB_PORTS 1
 
@@ -8069,6 +8070,7 @@ static irqreturn_t receive_context_interrupt(int irq, void *data)
 
 	trace_hfi1_receive_interrupt(dd, rcd->ctxt);
 	this_cpu_inc(*dd->int_counter);
+	aspm_ctx_disable(rcd);
 
 	/* receive interrupt remains blocked while processing packets */
 	disposition = rcd->do_interrupt(rcd, 0);
@@ -12792,6 +12794,7 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	dd->num_rcv_contexts = total_contexts;
 	dd->n_krcv_queues = num_kernel_contexts;
 	dd->first_user_ctxt = num_kernel_contexts;
+	dd->num_user_contexts = num_user_contexts;
 	dd->freectxts = num_user_contexts;
 	dd_dev_info(dd,
 		"rcv contexts: chip %d, used %d (kernel %d, user %d)\n",
@@ -13948,6 +13951,7 @@ done:
  */
 void hfi1_start_cleanup(struct hfi1_devdata *dd)
 {
+	aspm_exit(dd);
 	free_cntrs(dd);
 	free_rcverr(dd);
 	clean_up_interrupts(dd);
diff --git a/drivers/staging/rdma/hfi1/chip_registers.h b/drivers/staging/rdma/hfi1/chip_registers.h
index 3cd3352..23898eb 100644
--- a/drivers/staging/rdma/hfi1/chip_registers.h
+++ b/drivers/staging/rdma/hfi1/chip_registers.h
@@ -1281,6 +1281,9 @@
 #define SEND_STATIC_RATE_CONTROL_CSR_SRC_RELOAD_SHIFT 0
 #define SEND_STATIC_RATE_CONTROL_CSR_SRC_RELOAD_SMASK 0xFFFFull
 #define PCIE_CFG_REG_PL2 (PCIE + 0x000000000708)
+#define PCIE_CFG_REG_PL3 (PCIE + 0x00000000070C)
+#define PCIE_CFG_REG_PL3_L1_ENT_LATENCY_SHIFT 27
+#define PCIE_CFG_REG_PL3_L1_ENT_LATENCY_SMASK 0x38000000
 #define PCIE_CFG_REG_PL102 (PCIE + 0x000000000898)
 #define PCIE_CFG_REG_PL102_GEN3_EQ_POST_CURSOR_PSET_SHIFT 12
 #define PCIE_CFG_REG_PL102_GEN3_EQ_CURSOR_PSET_SHIFT 6
diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 5c694fa..084581a 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -60,6 +60,7 @@
 #include "user_sdma.h"
 #include "user_exp_rcv.h"
 #include "eprom.h"
+#include "aspm.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
@@ -798,7 +799,8 @@ static int hfi1_file_close(struct inode *inode, struct file *fp)
 	hfi1_clear_ctxt_pkey(dd, uctxt->ctxt);
 
 	hfi1_stats.sps_ctxts--;
-	dd->freectxts++;
+	if (++dd->freectxts == dd->num_user_contexts)
+		aspm_enable_all(dd);
 	mutex_unlock(&hfi1_mutex);
 	hfi1_free_ctxtdata(dd, uctxt);
 done:
@@ -1040,7 +1042,12 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 	INIT_LIST_HEAD(&uctxt->sdma_queues);
 	spin_lock_init(&uctxt->sdma_qlock);
 	hfi1_stats.sps_ctxts++;
-	dd->freectxts--;
+	/*
+	 * Disable ASPM when there are open user/PSM contexts to avoid
+	 * issues with ASPM L1 exit latency
+	 */
+	if (dd->freectxts-- == dd->num_user_contexts)
+		aspm_disable_all(dd);
 	fd->uctxt = uctxt;
 
 	return 0;
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index d19d6b7..cb2f90a 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -314,6 +314,21 @@ struct hfi1_ctxtdata {
 	struct list_head sdma_queues;
 	spinlock_t sdma_qlock;
 
+	/* Is ASPM interrupt supported for this context */
+	bool aspm_intr_supported;
+	/* ASPM state (enabled/disabled) for this context */
+	bool aspm_enabled;
+	/* Timer for re-enabling ASPM if interrupt activity quietens down */
+	struct timer_list aspm_timer;
+	/* Lock to serialize between intr, timer intr and user threads */
+	spinlock_t aspm_lock;
+	/* Is ASPM processing enabled for this context (in intr context) */
+	bool aspm_intr_enable;
+	/* Last interrupt timestamp */
+	ktime_t aspm_ts_last_intr;
+	/* Last timestamp at which we scheduled a timer for this context */
+	ktime_t aspm_ts_timer_sched;
+
 	/*
 	 * The interrupt handler for a particular receive context can vary
 	 * throughout it's lifetime. This is not a lock protected data member so
@@ -893,6 +908,8 @@ struct hfi1_devdata {
 	 * number of ctxts available for PSM open
 	 */
 	u32 freectxts;
+	/* total number of available user/PSM contexts */
+	u32 num_user_contexts;
 	/* base receive interrupt timeout, in CSR units */
 	u32 rcv_intr_timeout_csr;
 
@@ -1121,6 +1138,13 @@ struct hfi1_devdata {
 	/* receive context tail dummy address */
 	__le64 *rcvhdrtail_dummy_kvaddr;
 	dma_addr_t rcvhdrtail_dummy_physaddr;
+
+	bool aspm_supported;	/* Does HW support ASPM */
+	bool aspm_enabled;	/* ASPM state: enabled/disabled */
+	/* Serialize ASPM enable/disable between multiple verbs contexts */
+	spinlock_t aspm_lock;
+	/* Number of verbs contexts which have disabled ASPM */
+	atomic_t aspm_disabled_cnt;
 };
 
 /* 8051 firmware version helper */
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index fc3d40a..ba52ee3 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -66,6 +66,7 @@
 #include "sdma.h"
 #include "debugfs.h"
 #include "verbs.h"
+#include "aspm.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
@@ -190,6 +191,12 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 		}
 	}
 
+	/*
+	 * Initialize aspm, to be done after gen3 transition and setting up
+	 * contexts and before enabling interrupts
+	 */
+	aspm_init(dd);
+
 	return 0;
 nomem:
 	ret = -ENOMEM;
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index 3cdc804..76cf807 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -57,6 +57,7 @@
 
 #include "hfi.h"
 #include "chip_registers.h"
+#include "aspm.h"
 
 /* link speed vector for Gen3 speed - not in Linux headers */
 #define GEN1_SPEED_VECTOR 0x1
@@ -463,6 +464,10 @@ static int hfi1_pcie_caps;
 module_param_named(pcie_caps, hfi1_pcie_caps, int, S_IRUGO);
 MODULE_PARM_DESC(pcie_caps, "Max PCIe tuning: Payload (0..3), ReadReq (4..7)");
 
+uint aspm_mode = ASPM_MODE_DISABLED;
+module_param_named(aspm, aspm_mode, uint, S_IRUGO);
+MODULE_PARM_DESC(aspm, "PCIe ASPM: 0: disable, 1: enable, 2: dynamic");
+
 static void tune_pcie_caps(struct hfi1_devdata *dd)
 {
 	struct pci_dev *parent;
@@ -957,7 +962,7 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 	int do_retry, retry_count = 0;
 	uint default_pset;
 	u16 target_vector, target_speed;
-	u16 lnkctl, lnkctl2, vendor;
+	u16 lnkctl2, vendor;
 	u8 nsbr = 1;
 	u8 div;
 	const u8 (*eq)[3];
@@ -1147,11 +1152,12 @@ retry:
 	 */
 	write_xmt_margin(dd, __func__);
 
-	/* step 5e: disable active state power management (ASPM) */
+	/*
+	 * step 5e: disable active state power management (ASPM). It
+	 * will be enabled if required later
+	 */
 	dd_dev_info(dd, "%s: clearing ASPM\n", __func__);
-	pcie_capability_read_word(dd->pcidev, PCI_EXP_LNKCTL, &lnkctl);
-	lnkctl &= ~PCI_EXP_LNKCTL_ASPMC;
-	pcie_capability_write_word(dd->pcidev, PCI_EXP_LNKCTL, lnkctl);
+	aspm_hw_disable_l1(dd);
 
 	/*
 	 * step 5f: clear DirectSpeedChange

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
