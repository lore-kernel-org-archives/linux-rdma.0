From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] IB/hfi1: Make n_krcvqs be an unsigned long integer
Date: Wed, 31 Aug 2016 07:24:40 -0700
Message-ID: <20160831142438.27232.99467.stgit@scvm10.sc.intel.com>
References: <20160831141841.27232.61621.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160831141841.27232.61621.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The global variable n_krcvqs stores the sum of the number of kernel
receive queues of VLs 0-7 which the user can pass to the driver through
the module parameter array krcvqs which is of type unsigned integer. If
the user passes large value(s) into krcvqs parameter array, it can cause
an arithmetic overflow while calculating n_krcvqs which is also of type
unsigned int. The overflow results in an incorrect value of n_krcvqs
which can lead to kernel crash while loading the driver.

Fix by changing the data type of n_krcvqs to unsigned long. This patch
also changes the data type of other variables that get their values from
n_krcvqs.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    6 +++---
 drivers/infiniband/hw/hfi1/hfi.h  |    2 +-
 drivers/infiniband/hw/hfi1/init.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index ec3635a..cc38004 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -12935,7 +12935,7 @@ fail:
  */
 static int set_up_context_variables(struct hfi1_devdata *dd)
 {
-	int num_kernel_contexts;
+	unsigned long num_kernel_contexts;
 	int total_contexts;
 	int ret;
 	unsigned ngroups;
@@ -12964,9 +12964,9 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	 */
 	if (num_kernel_contexts > (dd->chip_send_contexts - num_vls - 1)) {
 		dd_dev_err(dd,
-			   "Reducing # kernel rcv contexts to: %d, from %d\n",
+			   "Reducing # kernel rcv contexts to: %d, from %lu\n",
 			   (int)(dd->chip_send_contexts - num_vls - 1),
-			   (int)num_kernel_contexts);
+			   num_kernel_contexts);
 		num_kernel_contexts = dd->chip_send_contexts - num_vls - 1;
 	}
 	/*
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 28b9128..325ec21 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1806,7 +1806,7 @@ extern unsigned int hfi1_max_mtu;
 extern unsigned int hfi1_cu;
 extern unsigned int user_credit_return_threshold;
 extern int num_user_contexts;
-extern unsigned n_krcvqs;
+extern unsigned long n_krcvqs;
 extern uint krcvqs[];
 extern int krcvqsset;
 extern uint kdeth_qp;
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 000dc07..384b43d 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -94,7 +94,7 @@ module_param_array(krcvqs, uint, &krcvqsset, S_IRUGO);
 MODULE_PARM_DESC(krcvqs, "Array of the number of non-control kernel receive queues by VL");
 
 /* computed based on above array */
-unsigned n_krcvqs;
+unsigned long n_krcvqs;
 
 static unsigned hfi1_rcvarr_split = 25;
 module_param_named(rcvarr_split, hfi1_rcvarr_split, uint, S_IRUGO);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
