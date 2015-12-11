From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] staging/rdma/hfi1: Change num_rcv_contexts to
 num_user_contexts and its meaning
Date: Fri, 11 Dec 2015 08:44:48 -0500
Message-ID: <20151211134448.27874.69204.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

num_rcv_contexts sets the number of user contexts, both receive and send.
Renaming it to num_user_contexts makes sense to reflect its true meaning.
When num_rcv_contexts is 0, the default behavior is the number of CPU
cores instead of 0 contexts. This commit changes the variable
num_rcv_contexts to num_user_contexts, and it also makes any negative
value for this variable default to the number of CPU cores, so if
num_user_contexts is set >= 0, the value will number of contexts.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |    9 +++------
 drivers/staging/rdma/hfi1/hfi.h  |    2 +-
 drivers/staging/rdma/hfi1/init.c |    6 +++---
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index dc69159..510e5f6 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -9197,7 +9197,6 @@ fail:
 static int set_up_context_variables(struct hfi1_devdata *dd)
 {
 	int num_kernel_contexts;
-	int num_user_contexts;
 	int total_contexts;
 	int ret;
 	unsigned ngroups;
@@ -9234,12 +9233,10 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	}
 	/*
 	 * User contexts: (to be fixed later)
-	 *	- set to num_rcv_contexts if non-zero
-	 *	- default to 1 user context per CPU
+	 *	- default to 1 user context per CPU if num_user_contexts is
+	 *	  negative
 	 */
-	if (num_rcv_contexts)
-		num_user_contexts = num_rcv_contexts;
-	else
+	if (num_user_contexts < 0)
 		num_user_contexts = num_online_cpus();
 
 	total_contexts = num_kernel_contexts + num_user_contexts;
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 54ed6b3..434a89b 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1629,7 +1629,7 @@ void update_sge(struct hfi1_sge_state *ss, u32 length);
 extern unsigned int hfi1_max_mtu;
 extern unsigned int hfi1_cu;
 extern unsigned int user_credit_return_threshold;
-extern uint num_rcv_contexts;
+extern int num_user_contexts;
 extern unsigned n_krcvqs;
 extern u8 krcvqs[];
 extern int krcvqsset;
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 1c8286f..a091b6c 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -82,10 +82,10 @@
  * Number of user receive contexts we are configured to use (to allow for more
  * pio buffers per ctxt, etc.)  Zero means use one user context per CPU.
  */
-uint num_rcv_contexts;
-module_param_named(num_rcv_contexts, num_rcv_contexts, uint, S_IRUGO);
+int num_user_contexts = -1;
+module_param_named(num_user_contexts, num_user_contexts, uint, S_IRUGO);
 MODULE_PARM_DESC(
-	num_rcv_contexts, "Set max number of user receive contexts to use");
+	num_user_contexts, "Set max number of user contexts to use");
 
 u8 krcvqs[RXE_NUM_DATA_VL];
 int krcvqsset;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
