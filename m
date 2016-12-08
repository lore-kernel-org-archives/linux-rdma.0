From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 20/23] IB/hfi1: Avoid credit return allocation for cpu-less
 NUMA nodes
Date: Wed, 07 Dec 2016 19:34:19 -0800
Message-ID: <20161208033417.21135.27290.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Do not allocate credit return base and DMA memory for
NUMA nodes without CPUs.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/affinity.c |    3 ++-
 drivers/infiniband/hw/hfi1/affinity.h |    1 +
 drivers/infiniband/hw/hfi1/pio.c      |   20 +++-----------------
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index 67ea85a..7a3d906 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -125,6 +125,7 @@ int node_affinity_init(void)
 				cpumask_weight(topology_sibling_cpumask(
 					cpumask_first(&node_affinity.proc.mask)
 					));
+	node_affinity.num_possible_nodes = num_possible_nodes();
 	node_affinity.num_online_nodes = num_online_nodes();
 	node_affinity.num_online_cpus = num_online_cpus();
 
@@ -135,7 +136,7 @@ int node_affinity_init(void)
 	 */
 	init_real_cpu_mask();
 
-	hfi1_per_node_cntr = kcalloc(num_possible_nodes(),
+	hfi1_per_node_cntr = kcalloc(node_affinity.num_possible_nodes,
 				     sizeof(*hfi1_per_node_cntr), GFP_KERNEL);
 	if (!hfi1_per_node_cntr)
 		return -ENOMEM;
diff --git a/drivers/infiniband/hw/hfi1/affinity.h b/drivers/infiniband/hw/hfi1/affinity.h
index 28eac98..e78c7aa 100644
--- a/drivers/infiniband/hw/hfi1/affinity.h
+++ b/drivers/infiniband/hw/hfi1/affinity.h
@@ -107,6 +107,7 @@ struct hfi1_affinity_node_list {
 	struct cpumask real_cpu_mask;
 	struct cpu_mask_set proc;
 	int num_core_siblings;
+	int num_possible_nodes;
 	int num_online_nodes;
 	int num_online_cpus;
 	struct mutex lock; /* protects affinity nodes */
diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index efe1064..501a7e9 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -2029,21 +2029,10 @@ int init_pervl_scs(struct hfi1_devdata *dd)
 int init_credit_return(struct hfi1_devdata *dd)
 {
 	int ret;
-	int num_numa;
 	int i;
 
-	num_numa = num_online_nodes();
-	/* enforce the expectation that the numas are compact */
-	for (i = 0; i < num_numa; i++) {
-		if (!node_online(i)) {
-			dd_dev_err(dd, "NUMA nodes are not compact\n");
-			ret = -EINVAL;
-			goto done;
-		}
-	}
-
 	dd->cr_base = kcalloc(
-		num_numa,
+		node_affinity.num_possible_nodes,
 		sizeof(struct credit_return_base),
 		GFP_KERNEL);
 	if (!dd->cr_base) {
@@ -2051,7 +2040,7 @@ int init_credit_return(struct hfi1_devdata *dd)
 		ret = -ENOMEM;
 		goto done;
 	}
-	for (i = 0; i < num_numa; i++) {
+	for_each_node_with_cpus(i) {
 		int bytes = TXE_NUM_CONTEXTS * sizeof(struct credit_return);
 
 		set_dev_node(&dd->pcidev->dev, i);
@@ -2078,14 +2067,11 @@ int init_credit_return(struct hfi1_devdata *dd)
 
 void free_credit_return(struct hfi1_devdata *dd)
 {
-	int num_numa;
 	int i;
 
 	if (!dd->cr_base)
 		return;
-
-	num_numa = num_online_nodes();
-	for (i = 0; i < num_numa; i++) {
+	for (i = 0; i < node_affinity.num_possible_nodes; i++) {
 		if (dd->cr_base[i].va) {
 			dma_free_coherent(&dd->pcidev->dev,
 					  TXE_NUM_CONTEXTS *

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
