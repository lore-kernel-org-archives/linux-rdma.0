From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/20] IB/hfi1: Remove hyper-thread siblings by walking CPU
 mask
Date: Sun, 09 Apr 2017 10:15:38 -0700
Message-ID: <20170409171537.10579.68545.stgit@scvm10.sc.intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409171329.10579.92775.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The driver expects that hyper-thread siblings are
allocated in blocks. This might not be a safe assumption.
Walk through the "real_cpu_mask" picking up CPUs and
removing its siblings instead of relying on the sibling
CPUs being contiguous in the CPU mask.

Reviewed-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/affinity.c |   52 +++++++++++++++------------------
 drivers/infiniband/hw/hfi1/affinity.h |    4 +--
 2 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index e2cd2cd..3679959 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015-2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -78,37 +78,32 @@ static inline void init_cpu_mask_set(struct cpu_mask_set *set)
 }
 
 /* Initialize non-HT cpu cores mask */
-void init_real_cpu_mask(void)
+static int init_real_cpu_mask(void)
 {
-	int possible, curr_cpu, i, ht;
+	int curr_cpu, ret;
+	cpumask_var_t sibling_mask;
+	struct cpumask *real_cpu_mask = &node_affinity.real_cpu_mask;
 
-	cpumask_clear(&node_affinity.real_cpu_mask);
+	ret = zalloc_cpumask_var(&sibling_mask, GFP_KERNEL);
+	if (!ret)
+		return -ENOMEM;
 
-	/* Start with cpu online mask as the real cpu mask */
-	cpumask_copy(&node_affinity.real_cpu_mask, cpu_online_mask);
+	cpumask_clear(real_cpu_mask);
 
-	/*
-	 * Remove HT cores from the real cpu mask.  Do this in two steps below.
-	 */
-	possible = cpumask_weight(&node_affinity.real_cpu_mask);
-	ht = cpumask_weight(topology_sibling_cpumask(
-				cpumask_first(&node_affinity.real_cpu_mask)));
-	/*
-	 * Step 1.  Skip over the first N HT siblings and use them as the
-	 * "real" cores.  Assumes that HT cores are not enumerated in
-	 * succession (except in the single core case).
-	 */
-	curr_cpu = cpumask_first(&node_affinity.real_cpu_mask);
-	for (i = 0; i < possible / ht; i++)
-		curr_cpu = cpumask_next(curr_cpu, &node_affinity.real_cpu_mask);
-	/*
-	 * Step 2.  Remove the remaining HT siblings.  Use cpumask_next() to
-	 * skip any gaps.
-	 */
-	for (; i < possible; i++) {
-		cpumask_clear_cpu(curr_cpu, &node_affinity.real_cpu_mask);
-		curr_cpu = cpumask_next(curr_cpu, &node_affinity.real_cpu_mask);
+	/* Start with cpu online mask as the real cpu mask */
+	cpumask_copy(real_cpu_mask, cpu_online_mask);
+
+	/* Remove HT cores from the real cpu mask */
+	curr_cpu = cpumask_first(real_cpu_mask);
+	while (curr_cpu < nr_cpu_ids) {
+		cpumask_copy(sibling_mask, topology_sibling_cpumask(curr_cpu));
+		cpumask_clear_cpu(curr_cpu, sibling_mask);
+		cpumask_andnot(real_cpu_mask, real_cpu_mask, sibling_mask);
+		curr_cpu = cpumask_next(curr_cpu, real_cpu_mask);
 	}
+
+	free_cpumask_var(sibling_mask);
+	return 0;
 }
 
 int node_affinity_init(void)
@@ -134,7 +129,8 @@ int node_affinity_init(void)
 	 * initialized early. It is needed to calculate the number of user
 	 * contexts in set_up_context_variables().
 	 */
-	init_real_cpu_mask();
+	if (init_real_cpu_mask())
+		return -ENOMEM;
 
 	hfi1_per_node_cntr = kcalloc(node_affinity.num_possible_nodes,
 				     sizeof(*hfi1_per_node_cntr), GFP_KERNEL);
diff --git a/drivers/infiniband/hw/hfi1/affinity.h b/drivers/infiniband/hw/hfi1/affinity.h
index e78c7aa..096866e 100644
--- a/drivers/infiniband/hw/hfi1/affinity.h
+++ b/drivers/infiniband/hw/hfi1/affinity.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015-2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -72,8 +72,6 @@ struct cpu_mask_set {
 
 struct hfi1_msix_entry;
 
-/* Initialize non-HT cpu cores mask */
-void init_real_cpu_mask(void);
 /* Initialize driver affinity data */
 int hfi1_dev_affinity_init(struct hfi1_devdata *);
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
