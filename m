From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH v3 18/18] infiniband: cxgb4: Eliminate duplicate barriers on weakly-ordered archs
Date: Fri, 16 Mar 2018 12:16:31 -0400
Message-ID: <1521216991-28706-19-git-send-email-okaya@codeaurora.org>
References: <1521216991-28706-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521216991-28706-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: netdev@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Code includes wmb() followed by writel(). writel() already has a barrier on
some architectures like arm64.

This ends up CPU observing two barriers back to back before executing the
register write.

Since code already has an explicit barrier call, changing writel() to
writel_relaxed().

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/infiniband/hw/cxgb4/t4.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 8369c7c..7a48c9e 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -477,15 +477,15 @@ static inline void t4_ring_sq_db(struct t4_wq *wq, u16 inc, union t4_wr *wqe)
 				 (u64 *)wqe);
 		} else {
 			pr_debug("DB wq->sq.pidx = %d\n", wq->sq.pidx);
-			writel(PIDX_T5_V(inc) | QID_V(wq->sq.bar2_qid),
-			       wq->sq.bar2_va + SGE_UDB_KDOORBELL);
+			writel_relaxed(PIDX_T5_V(inc) | QID_V(wq->sq.bar2_qid),
+				       wq->sq.bar2_va + SGE_UDB_KDOORBELL);
 		}
 
 		/* Flush user doorbell area writes. */
 		wmb();
 		return;
 	}
-	writel(QID_V(wq->sq.qid) | PIDX_V(inc), wq->db);
+	writel_relaxed(QID_V(wq->sq.qid) | PIDX_V(inc), wq->db);
 }
 
 static inline void t4_ring_rq_db(struct t4_wq *wq, u16 inc,
@@ -502,15 +502,15 @@ static inline void t4_ring_rq_db(struct t4_wq *wq, u16 inc,
 				 (void *)wqe);
 		} else {
 			pr_debug("DB wq->rq.pidx = %d\n", wq->rq.pidx);
-			writel(PIDX_T5_V(inc) | QID_V(wq->rq.bar2_qid),
-			       wq->rq.bar2_va + SGE_UDB_KDOORBELL);
+			writel_relaxed(PIDX_T5_V(inc) | QID_V(wq->rq.bar2_qid),
+				       wq->rq.bar2_va + SGE_UDB_KDOORBELL);
 		}
 
 		/* Flush user doorbell area writes. */
 		wmb();
 		return;
 	}
-	writel(QID_V(wq->rq.qid) | PIDX_V(inc), wq->db);
+	writel_relaxed(QID_V(wq->rq.qid) | PIDX_V(inc), wq->db);
 }
 
 static inline int t4_wq_in_error(struct t4_wq *wq)
-- 
2.7.4
