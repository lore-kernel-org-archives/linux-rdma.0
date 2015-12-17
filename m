From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 09/14] staging/rdma/hfi1: Convert lock to mutex
Date: Thu, 17 Dec 2015 02:00:19 -0500
Message-ID: <1450335624-12134-10-git-send-email-ira.weiny@intel.com>
References: <1450335624-12134-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450335624-12134-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The exp_lock lock does not need to be a spinlock as
all its uses are in process context and allowing the
process to sleep when the mutex is contended might
be benefitial.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c | 12 ++++++------
 drivers/staging/rdma/hfi1/hfi.h      |  2 +-
 drivers/staging/rdma/hfi1/init.c     |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 76fe60315bb4..b0348263b901 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -1611,14 +1611,14 @@ static int exp_tid_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 		 * reserved, we don't need the lock anymore since we
 		 * are guaranteed the groups.
 		 */
-		spin_lock(&uctxt->exp_lock);
+		mutex_lock(&uctxt->exp_lock);
 		if (uctxt->tidusemap[useidx] == -1ULL ||
 		    bitidx >= BITS_PER_LONG) {
 			/* no free groups in the set, use the next */
 			useidx = (useidx + 1) % uctxt->tidmapcnt;
 			idx++;
 			bitidx = 0;
-			spin_unlock(&uctxt->exp_lock);
+			mutex_unlock(&uctxt->exp_lock);
 			continue;
 		}
 		ngroups = ((npages - mapped) / dd->rcv_entries.group_size) +
@@ -1635,13 +1635,13 @@ static int exp_tid_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 			 * as 0 because we don't check the entire bitmap but
 			 * we start from bitidx.
 			 */
-			spin_unlock(&uctxt->exp_lock);
+			mutex_unlock(&uctxt->exp_lock);
 			continue;
 		}
 		bits_used = min(free, ngroups);
 		tidmap[useidx] |= ((1ULL << bits_used) - 1) << bitidx;
 		uctxt->tidusemap[useidx] |= tidmap[useidx];
-		spin_unlock(&uctxt->exp_lock);
+		mutex_unlock(&uctxt->exp_lock);
 
 		/*
 		 * At this point, we know where in the map we have free bits.
@@ -1677,10 +1677,10 @@ static int exp_tid_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 			 * Let go of the bits that we reserved since we are not
 			 * going to use them.
 			 */
-			spin_lock(&uctxt->exp_lock);
+			mutex_lock(&uctxt->exp_lock);
 			uctxt->tidusemap[useidx] &=
 				~(((1ULL << bits_used) - 1) << bitidx);
-			spin_unlock(&uctxt->exp_lock);
+			mutex_unlock(&uctxt->exp_lock);
 			goto done;
 		}
 		/*
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 996dd520cf41..8ae914aab9bf 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -258,7 +258,7 @@ struct hfi1_ctxtdata {
 	struct exp_tid_set tid_full_list;
 
 	/* lock protecting all Expected TID data */
-	spinlock_t exp_lock;
+	struct mutex exp_lock;
 	/* number of pio bufs for this ctxt (all procs, if shared) */
 	u32 piocnt;
 	/* first pio buffer for this ctxt */
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 98aaa0ebff51..503dc7a397a5 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -227,7 +227,7 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt)
 		rcd->numa_id = numa_node_id();
 		rcd->rcv_array_groups = dd->rcv_entries.ngroups;
 
-		spin_lock_init(&rcd->exp_lock);
+		mutex_init(&rcd->exp_lock);
 
 		/*
 		 * Calculate the context's RcvArray entry starting point.
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
