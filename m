From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v3 04/13] staging/rdma/hfi1: Add definitions needed for TID caching support
Date: Fri,  5 Feb 2016 11:57:49 -0500
Message-ID: <1454691478-15444-5-git-send-email-ira.weiny@intel.com>
References: <1454691478-15444-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454691478-15444-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In preparation for adding the TID caching support, there is a set
of headers, structures, and variables which will be needed. This
commit adds them to the hfi.h header file.

Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/hfi.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index ddb21f0fffe7..51ecf45ef70b 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -179,6 +179,11 @@ struct ctxt_eager_bufs {
 	} *rcvtids;
 };
 
+struct exp_tid_set {
+	struct list_head list;
+	u32 count;
+};
+
 struct hfi1_ctxtdata {
 	/* shadow the ctxt's RcvCtrl register */
 	u64 rcvctrl;
@@ -247,6 +252,11 @@ struct hfi1_ctxtdata {
 	struct page **tid_pg_list;
 	/* dma handles for exp tid pages */
 	dma_addr_t *physshadow;
+
+	struct exp_tid_set tid_group_list;
+	struct exp_tid_set tid_used_list;
+	struct exp_tid_set tid_full_list;
+
 	/* lock protecting all Expected TID data */
 	spinlock_t exp_lock;
 	/* number of pio bufs for this ctxt (all procs, if shared) */
@@ -1137,6 +1147,16 @@ struct hfi1_filedata {
 	struct hfi1_user_sdma_pkt_q *pq;
 	/* for cpu affinity; -1 if none */
 	int rec_cpu_num;
+	struct mmu_notifier mn;
+	struct rb_root tid_rb_root;
+	spinlock_t tid_lock; /* protect tid_[limit,used] counters */
+	u32 tid_limit;
+	u32 tid_used;
+	spinlock_t rb_lock; /* protect tid_rb_root RB tree */
+	u32 *invalid_tids;
+	u32 invalid_tid_idx;
+	spinlock_t invalid_lock; /* protect the invalid_tids array */
+	int (*mmu_rb_insert)(struct rb_root *, struct mmu_rb_node *);
 };
 
 extern struct list_head hfi1_dev_list;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
