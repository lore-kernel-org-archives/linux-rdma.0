From: Wenwen Wang <wang6495@umn.edu>
Subject: [PATCH] iw_cxgb4: fix a missing-check bug
Date: Sat, 20 Oct 2018 16:59:00 -0500
Message-ID: <1540072741-18856-1-git-send-email-wang6495@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "open list:CXGB4 IWARP RNIC DRIVER
        IW_CXGB4" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

In c4iw_flush_hw_cq, the next CQE is acquired through t4_next_hw_cqe(). In
t4_next_hw_cqe(), the CQE, i.e., 'cq->queue[cq->cidx]', is checked to see
whether it is valid through t4_valid_cqe(). If it is valid, the address of
the CQE is then saved to 'hw_cqe'. Later on, the CQE is copied to the local
memory in create_read_req_cqe(). The problem here is that the CQE is
actually in a DMA region allocated by dma_alloc_coherent() in create_cq().
Given that the device also has the permission to access the DMA region, a
malicious device controlled by an attacker can modify the CQE in the DMA
region after the check in t4_next_hw_cqe() but before the copy in
create_read_req_cqe(). By doing so, the attacker can supply invalid CQE,
which can cause undefined behavior of the kernel and introduce potential
security risks.

This patch avoids the above issue by saving the CQE to a local variable if
it is verified to be a valid CQE in t4_next_hw_cqe(). Also, the local
variable will be used for the copy in create_read_req_ceq().

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
---
 drivers/infiniband/hw/cxgb4/cq.c | 8 +++++---
 drivers/infiniband/hw/cxgb4/t4.h | 4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 6d30427..09918ca 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -335,13 +335,15 @@ static void advance_oldest_read(struct t4_wq *wq)
  */
 void c4iw_flush_hw_cq(struct c4iw_cq *chp, struct c4iw_qp *flush_qhp)
 {
-	struct t4_cqe *hw_cqe, *swcqe, read_cqe;
+	struct t4_cqe hw_cqe_obj;
+	struct t4_cqe *hw_cqe = &hw_cqe_obj;
+	struct t4_cqe *swcqe, read_cqe;
 	struct c4iw_qp *qhp;
 	struct t4_swsqe *swsqe;
 	int ret;
 
 	pr_debug("cqid 0x%x\n", chp->cq.cqid);
-	ret = t4_next_hw_cqe(&chp->cq, &hw_cqe);
+	ret = t4_next_hw_cqe(&chp->cq, hw_cqe);
 
 	/*
 	 * This logic is similar to poll_cq(), but not quite the same
@@ -414,7 +416,7 @@ void c4iw_flush_hw_cq(struct c4iw_cq *chp, struct c4iw_qp *flush_qhp)
 		}
 next_cqe:
 		t4_hwcq_consume(&chp->cq);
-		ret = t4_next_hw_cqe(&chp->cq, &hw_cqe);
+		ret = t4_next_hw_cqe(&chp->cq, hw_cqe);
 		if (qhp && flush_qhp != qhp)
 			spin_unlock(&qhp->lock);
 	}
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index e42021f..9a9eea5 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -791,7 +791,7 @@ static inline int t4_cq_notempty(struct t4_cq *cq)
 	return cq->sw_in_use || t4_valid_cqe(cq, &cq->queue[cq->cidx]);
 }
 
-static inline int t4_next_hw_cqe(struct t4_cq *cq, struct t4_cqe **cqe)
+static inline int t4_next_hw_cqe(struct t4_cq *cq, struct t4_cqe *cqe)
 {
 	int ret;
 	u16 prev_cidx;
@@ -809,7 +809,7 @@ static inline int t4_next_hw_cqe(struct t4_cq *cq, struct t4_cqe **cqe)
 
 		/* Ensure CQE is flushed to memory */
 		rmb();
-		*cqe = &cq->queue[cq->cidx];
+		*cqe = cq->queue[cq->cidx];
 		ret = 0;
 	} else
 		ret = -ENODATA;
-- 
2.7.4
