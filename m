From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: fix sparse RCU warnings in qib_keys.c
Date: Fri, 6 Jul 2012 14:29:45 -0400
Message-ID: <20120706182944.20779.28432.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit e12deda1 ("IB/qib: RCU locking for MR validation") introduced
new sparse warnings in qib_keys.c.

This patch resolved those issues.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_keys.c  |    4 +++-
 drivers/infiniband/hw/qib/qib_verbs.h |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index 970165b..e9486c7 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -349,7 +349,9 @@ int qib_fast_reg_mr(struct qib_qp *qp, struct ib_send_wr *wr)
 	if (pd->user || rkey == 0)
 		goto bail;
 
-	mr = rkt->table[(rkey >> (32 - ib_qib_lkey_table_size))];
+	mr = rcu_dereference_protected(
+		rkt->table[(rkey >> (32 - ib_qib_lkey_table_size))],
+		lockdep_is_held(&rkt->lock));
 	if (unlikely(mr == NULL || qp->ibqp.pd != mr->pd))
 		goto bail;
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index cffeabb..319368e 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -650,7 +650,7 @@ struct qib_lkey_table {
 	u32 next;               /* next unused index (speeds search) */
 	u32 gen;                /* generation count */
 	u32 max;                /* size of the table */
-	struct qib_mregion **table;
+	struct qib_mregion __rcu **table;
 };
 
 struct qib_opcode_stats {
@@ -733,7 +733,7 @@ struct qib_ibdev {
 	struct list_head pending_mmaps;
 	spinlock_t mmap_offset_lock; /* protect mmap_offset */
 	u32 mmap_offset;
-	struct qib_mregion *dma_mr;
+	struct qib_mregion __rcu *dma_mr;
 
 	/* QP numbers are shared by all IB ports */
 	struct qib_qpn_table qpn_table;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
