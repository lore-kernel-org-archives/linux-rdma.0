From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 08/10] IB/hfi1: Initialize TID lists to avoid crash
 on cleanup
Date: Fri, 09 Jun 2017 16:00:12 -0700
Message-ID: <20170609230011.26710.48644.stgit@scvm10.sc.intel.com>
References: <20170609225424.26710.70167.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170609225424.26710.70167.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The expected receive lists (tid_xxx_list) are not initialized until
late in the receive context initialization.  If an error happens
before the initialization, a NULL pointer access will occur during
cleanup.

Initialized the lists sooner rather than later to avoid this Oops:

IP: unlock_exp_tids.isra.11+0x26/0xd0 [hfi1]
RIP: 0010:unlock_exp_tids.isra.11+0x26/0xd0 [hfi1]
Call Trace:
 hfi1_user_exp_rcv_free+0x79/0xb0 [hfi1]
 hfi1_file_close+0x87/0x360 [hfi1]
 __fput+0xe7/0x210
 ____fput+0xe/0x10

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/exp_rcv.c |    4 ----
 drivers/infiniband/hw/hfi1/init.c    |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/exp_rcv.c b/drivers/infiniband/hw/hfi1/exp_rcv.c
index 08d13ed..0af9167 100644
--- a/drivers/infiniband/hw/hfi1/exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/exp_rcv.c
@@ -69,10 +69,6 @@ int hfi1_alloc_ctxt_rcv_groups(struct hfi1_ctxtdata *rcd)
 	struct tid_group *grp;
 	int i;
 
-	hfi1_exp_tid_group_init(&rcd->tid_group_list);
-	hfi1_exp_tid_group_init(&rcd->tid_used_list);
-	hfi1_exp_tid_group_init(&rcd->tid_full_list);
-
 	tidbase = rcd->expected_base;
 	for (i = 0; i < rcd->expected_count /
 		     dd->rcv_entries.group_size; i++) {
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 4a11d4d..a00308c 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -67,6 +67,7 @@
 #include "aspm.h"
 #include "affinity.h"
 #include "vnic.h"
+#include "exp_rcv.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
@@ -221,6 +222,9 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
 		hfi1_cdbg(PROC, "setting up context %u\n", ctxt);
 
 		INIT_LIST_HEAD(&rcd->qp_wait_list);
+		hfi1_exp_tid_group_init(&rcd->tid_group_list);
+		hfi1_exp_tid_group_init(&rcd->tid_used_list);
+		hfi1_exp_tid_group_init(&rcd->tid_full_list);
 		rcd->ppd = ppd;
 		rcd->dd = dd;
 		__set_bit(0, rcd->in_use_ctxts);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
