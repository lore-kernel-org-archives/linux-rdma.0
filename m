From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 3/9] IB/hfi1: Name function prototype parameters
 for affinity module
Date: Fri, 26 May 2017 05:35:25 -0700
Message-ID: <20170526123523.8158.33944.stgit@scvm10.sc.intel.com>
References: <20170526123257.8158.23943.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170526123257.8158.23943.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

To improve the readability of function prototypes, give the parameters
names in the affinity module.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/affinity.h |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.h b/drivers/infiniband/hw/hfi1/affinity.h
index e78c7aa..2a1e374 100644
--- a/drivers/infiniband/hw/hfi1/affinity.h
+++ b/drivers/infiniband/hw/hfi1/affinity.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -75,24 +75,26 @@ struct cpu_mask_set {
 /* Initialize non-HT cpu cores mask */
 void init_real_cpu_mask(void);
 /* Initialize driver affinity data */
-int hfi1_dev_affinity_init(struct hfi1_devdata *);
+int hfi1_dev_affinity_init(struct hfi1_devdata *dd);
 /*
  * Set IRQ affinity to a CPU. The function will determine the
  * CPU and set the affinity to it.
  */
-int hfi1_get_irq_affinity(struct hfi1_devdata *, struct hfi1_msix_entry *);
+int hfi1_get_irq_affinity(struct hfi1_devdata *dd,
+			  struct hfi1_msix_entry *msix);
 /*
  * Remove the IRQ's CPU affinity. This function also updates
  * any internal CPU tracking data
  */
-void hfi1_put_irq_affinity(struct hfi1_devdata *, struct hfi1_msix_entry *);
+void hfi1_put_irq_affinity(struct hfi1_devdata *dd,
+			   struct hfi1_msix_entry *msix);
 /*
  * Determine a CPU affinity for a user process, if the process does not
  * have an affinity set yet.
  */
-int hfi1_get_proc_affinity(int);
+int hfi1_get_proc_affinity(int node);
 /* Release a CPU used by a user process. */
-void hfi1_put_proc_affinity(int);
+void hfi1_put_proc_affinity(int cpu);
 
 struct hfi1_affinity_node {
 	int node;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
