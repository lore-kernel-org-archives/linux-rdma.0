From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 6/7] IB/hfi1: Don't modify num_user_contexts module
 parameter
Date: Mon, 23 Oct 2017 06:06:24 -0700
Message-ID: <20171023130621.21191.31694.stgit@scvm10.sc.intel.com>
References: <20171023125327.21191.31462.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023125327.21191.31462.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The driver parameter num_user_contexts controls global behavior and
should not be modified by the driver.
This patch eliminates modification of num_user_contexts by using a
local variable to keep track of the value.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 32e35d5..4455886 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -13409,6 +13409,7 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	unsigned ngroups;
 	int qos_rmt_count;
 	int user_rmt_reduced;
+	u32 n_usr_ctxts;
 
 	/*
 	 * Kernel receive contexts:
@@ -13451,42 +13452,42 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	 *	  num_user_contexts is negative
 	 */
 	if (num_user_contexts < 0)
-		num_user_contexts =
-			cpumask_weight(&node_affinity.real_cpu_mask);
-
+		n_usr_ctxts = cpumask_weight(&node_affinity.real_cpu_mask);
+	else
+		n_usr_ctxts = num_user_contexts;
 	/*
 	 * Adjust the counts given a global max.
 	 */
-	if (total_contexts + num_user_contexts > dd->chip_rcv_contexts) {
+	if (total_contexts + n_usr_ctxts > dd->chip_rcv_contexts) {
 		dd_dev_err(dd,
-			   "Reducing # user receive contexts to: %d, from %d\n",
+			   "Reducing # user receive contexts to: %d, from %u\n",
 			   (int)(dd->chip_rcv_contexts - total_contexts),
-			   (int)num_user_contexts);
+			   n_usr_ctxts);
 		/* recalculate */
-		num_user_contexts = dd->chip_rcv_contexts - total_contexts;
+		n_usr_ctxts = dd->chip_rcv_contexts - total_contexts;
 	}
 
 	/* each user context requires an entry in the RMT */
 	qos_rmt_count = qos_rmt_entries(dd, NULL, NULL);
-	if (qos_rmt_count + num_user_contexts > NUM_MAP_ENTRIES) {
+	if (qos_rmt_count + n_usr_ctxts > NUM_MAP_ENTRIES) {
 		user_rmt_reduced = NUM_MAP_ENTRIES - qos_rmt_count;
 		dd_dev_err(dd,
-			   "RMT size is reducing the number of user receive contexts from %d to %d\n",
-			   (int)num_user_contexts,
+			   "RMT size is reducing the number of user receive contexts from %u to %d\n",
+			   n_usr_ctxts,
 			   user_rmt_reduced);
 		/* recalculate */
-		num_user_contexts = user_rmt_reduced;
+		n_usr_ctxts = user_rmt_reduced;
 	}
 
-	total_contexts += num_user_contexts;
+	total_contexts += n_usr_ctxts;
 
 	/* the first N are kernel contexts, the rest are user/vnic contexts */
 	dd->num_rcv_contexts = total_contexts;
 	dd->n_krcv_queues = num_kernel_contexts;
 	dd->first_dyn_alloc_ctxt = num_kernel_contexts;
 	dd->num_vnic_contexts = num_vnic_contexts;
-	dd->num_user_contexts = num_user_contexts;
-	dd->freectxts = num_user_contexts;
+	dd->num_user_contexts = n_usr_ctxts;
+	dd->freectxts = n_usr_ctxts;
 	dd_dev_info(dd,
 		    "rcv contexts: chip %d, used %d (kernel %d, vnic %u, user %u)\n",
 		    (int)dd->chip_rcv_contexts,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
