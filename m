From: jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] staging/rdma/hfi1: Convert dd_dev_info() to hfi1_cdbg() in process startup
Date: Wed,  4 Nov 2015 23:14:57 -0500
Message-ID: <1446696897-25892-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Replacing dd_dev_info() for hfi1_cdbg() to avoid generating syslog
output for every context that is open by PSM.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c |   10 +++++-----
 drivers/staging/rdma/hfi1/init.c     |   31 ++++++++++++++++++-------------
 drivers/staging/rdma/hfi1/pio.c      |   19 ++++++++++---------
 3 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index aae9826..fba5889 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -687,9 +687,9 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	}
 
 	vma->vm_flags = flags;
-	dd_dev_info(dd,
-		    "%s: %u:%u type:%u io/vf:%d/%d, addr:0x%llx, len:%lu(%lu), flags:0x%lx\n",
-		    __func__, ctxt, subctxt, type, mapio, vmf, memaddr, memlen,
+	hfi1_cdbg(PROC,
+		  "%u:%u type:%u io/vf:%d/%d, addr:0x%llx, len:%lu(%lu), flags:0x%lx\n",
+		    ctxt, subctxt, type, mapio, vmf, memaddr, memlen,
 		    vma->vm_end - vma->vm_start, vma->vm_flags);
 	pfn = (unsigned long)(memaddr >> PAGE_SHIFT);
 	if (vmf) {
@@ -1011,8 +1011,8 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 	if (!uctxt->sc)
 		return -ENOMEM;
 
-	dbg("allocated send context %u(%u)\n", uctxt->sc->sw_index,
-		uctxt->sc->hw_context);
+	hfi1_cdbg(PROC, "allocated send context %u(%u)\n", uctxt->sc->sw_index,
+		  uctxt->sc->hw_context);
 	ret = sc_enable(uctxt->sc);
 	if (ret)
 		return ret;
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 47a1202..2e1efa7 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -60,6 +60,7 @@
 #include "hfi.h"
 #include "device.h"
 #include "common.h"
+#include "trace.h"
 #include "mad.h"
 #include "sdma.h"
 #include "debugfs.h"
@@ -208,7 +209,7 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt)
 	if (rcd) {
 		u32 rcvtids, max_entries;
 
-		dd_dev_info(dd, "%s: setting up context %u\n", __func__, ctxt);
+		hfi1_cdbg(PROC, "setting up context %u\n", ctxt);
 
 		INIT_LIST_HEAD(&rcd->qp_wait_list);
 		rcd->ppd = ppd;
@@ -279,8 +280,9 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt)
 				   rcd->ctxt);
 			rcd->egrbufs.count = MAX_EAGER_ENTRIES;
 		}
-		dd_dev_info(dd, "ctxt%u: max Eager buffer RcvArray entries: %u\n",
-			    rcd->ctxt, rcd->egrbufs.count);
+		hfi1_cdbg(PROC,
+			  "ctxt%u: max Eager buffer RcvArray entries: %u\n",
+			  rcd->ctxt, rcd->egrbufs.count);
 
 		/*
 		 * Allocate array that will hold the eager buffer accounting
@@ -308,8 +310,8 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt)
 		 */
 		if (rcd->egrbufs.size < hfi1_max_mtu) {
 			rcd->egrbufs.size = __roundup_pow_of_two(hfi1_max_mtu);
-			dd_dev_info(dd,
-				    "ctxt%u: eager bufs size too small. Adjusting to %zu\n",
+			hfi1_cdbg(PROC,
+				  "ctxt%u: eager bufs size too small. Adjusting to %zu\n",
 				    rcd->ctxt, rcd->egrbufs.size);
 		}
 		rcd->egrbufs.rcvtid_size = HFI1_MAX_EAGER_BUFFER_SIZE;
@@ -1660,9 +1662,11 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 	rcd->egrbufs.numbufs = idx;
 	rcd->egrbufs.size = alloced_bytes;
 
-	dd_dev_info(dd, "ctxt%u: Alloced %u rcv tid entries @ %uKB, total %zuKB\n",
-		rcd->ctxt, rcd->egrbufs.alloced, rcd->egrbufs.rcvtid_size,
-		rcd->egrbufs.size);
+	hfi1_cdbg(PROC,
+		  "ctxt%u: Alloced %u rcv tid entries @ %uKB, total %zuKB\n",
+		  rcd->ctxt, rcd->egrbufs.alloced, rcd->egrbufs.rcvtid_size,
+		  rcd->egrbufs.size);
+
 
 	/*
 	 * Set the contexts rcv array head update threshold to the closest
@@ -1683,13 +1687,14 @@ int hfi1_setup_eagerbufs(struct hfi1_ctxtdata *rcd)
 		rcd->expected_count = MAX_TID_PAIR_ENTRIES * 2;
 
 	rcd->expected_base = rcd->eager_base + egrtop;
-	dd_dev_info(dd, "ctxt%u: eager:%u, exp:%u, egrbase:%u, expbase:%u\n",
-		    rcd->ctxt, rcd->egrbufs.alloced, rcd->expected_count,
-		    rcd->eager_base, rcd->expected_base);
+	hfi1_cdbg(PROC, "ctxt%u: eager:%u, exp:%u, egrbase:%u, expbase:%u\n",
+		  rcd->ctxt, rcd->egrbufs.alloced, rcd->expected_count,
+		  rcd->eager_base, rcd->expected_base);
 
 	if (!hfi1_rcvbuf_validate(rcd->egrbufs.rcvtid_size, PT_EAGER, &order)) {
-		dd_dev_err(dd, "ctxt%u: current Eager buffer size is invalid %u\n",
-			   rcd->ctxt, rcd->egrbufs.rcvtid_size);
+		hfi1_cdbg(PROC,
+			  "ctxt%u: current Eager buffer size is invalid %u\n",
+			  rcd->ctxt, rcd->egrbufs.rcvtid_size);
 		ret = -EINVAL;
 		goto bail;
 	}
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index e5c32db..eab58c1 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -815,15 +815,16 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 		}
 	}
 
-	dd_dev_info(dd,
-		"Send context %u(%u) %s group %u credits %u credit_ctrl 0x%llx threshold %u\n",
-		sw_index,
-		hw_context,
-		sc_type_name(type),
-		sc->group,
-		sc->credits,
-		sc->credit_ctrl,
-		thresh);
+	hfi1_cdbg(PIO,
+		  "Send context %u(%u) %s group %u credits %u credit_ctrl 0x%llx threshold %u\n",
+		  sw_index,
+		  hw_context,
+		  sc_type_name(type),
+		  sc->group,
+		  sc->credits,
+		  sc->credit_ctrl,
+		  thresh);
+
 
 	return sc;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
