From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/28] IB/hfi1: Modify the default number of kernel receive
 conexts
Date: Mon, 25 Jul 2016 13:38:50 -0700
Message-ID: <20160725203849.4800.74212.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently, the default number of kernel receive contexts is set to the
number of NUMA nodes on the system plus one for control context. However,
the systems that have a single socket and/or have NUMA disabled in the BIOS
will have only one receive context by default. This patch would ensure that
by default there will be at least two kernel receive contexts plus one for
control context regardless of the number of NUMA nodes on the system. The
user can override the default number of kernel receive contexts with the
krcvqs module parameter.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 40d485b..e5f49ef 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -122,6 +122,7 @@ struct flag_table {
 #define SEC_SC_HALTED		0x4	/* per-context only */
 #define SEC_SPC_FREEZE		0x8	/* per-HFI only */
 
+#define DEFAULT_KRCVQS		  2
 #define MIN_KERNEL_KCTXTS         2
 #define FIRST_KERNEL_KCTXT        1
 /* sizes for both the QP and RSM map tables */
@@ -12773,7 +12774,6 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 
 	/*
 	 * Kernel receive contexts:
-	 * - min of 2 or 1 context/numa (excluding control context)
 	 * - Context 0 - control context (VL15/multicast/error)
 	 * - Context 1 - first kernel context
 	 * - Context 2 - second kernel context
@@ -12787,9 +12787,7 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 		 */
 		num_kernel_contexts = n_krcvqs + 1;
 	else
-		num_kernel_contexts = num_online_nodes() + 1;
-	num_kernel_contexts =
-		max_t(int, MIN_KERNEL_KCTXTS, num_kernel_contexts);
+		num_kernel_contexts = DEFAULT_KRCVQS + 1;
 	/*
 	 * Every kernel receive context needs an ACK send context.
 	 * one send context is allocated for each VL{0-7} and VL15

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
