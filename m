From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] iw_cxgb4: Use proper enumerated type in c4iw_bar2_addrs
Date: Mon, 24 Sep 2018 12:29:03 -0700
Message-ID: <20180924192903.16796-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Clang warns when one enumerated type is implicitly converted to another.

drivers/infiniband/hw/cxgb4/qp.c:287:8: warning: implicit conversion
from enumeration type 'enum t4_bar2_qtype' to different enumeration type
'enum cxgb4_bar2_qtype' [-Wenum-conversion]
                                                 T4_BAR2_QTYPE_EGRESS,
                                                 ^~~~~~~~~~~~~~~~~~~~

c4iw_bar2_addrs expects a value from enum cxgb4_bar2_qtype so use the
corresponding values from that type so Clang is satisfied without
changing the meaning of the code.

T4_BAR2_QTYPE_EGRESS = CXGB4_BAR2_QTYPE_EGRESS = 0
T4_BAR2_QTYPE_INGRESS = CXGB4_BAR2_QTYPE_INGRESS = 1

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/infiniband/hw/cxgb4/cq.c | 2 +-
 drivers/infiniband/hw/cxgb4/qp.c | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 6d3042794094..1fd8798d91a7 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -161,7 +161,7 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 	cq->gts = rdev->lldi.gts_reg;
 	cq->rdev = rdev;
 
-	cq->bar2_va = c4iw_bar2_addrs(rdev, cq->cqid, T4_BAR2_QTYPE_INGRESS,
+	cq->bar2_va = c4iw_bar2_addrs(rdev, cq->cqid, CXGB4_BAR2_QTYPE_INGRESS,
 				      &cq->bar2_qid,
 				      user ? &cq->bar2_pa : NULL);
 	if (user && !cq->bar2_pa) {
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 347fe18b1a41..a9e3a11bea54 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -279,12 +279,13 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 
 	wq->db = rdev->lldi.db_reg;
 
-	wq->sq.bar2_va = c4iw_bar2_addrs(rdev, wq->sq.qid, T4_BAR2_QTYPE_EGRESS,
+	wq->sq.bar2_va = c4iw_bar2_addrs(rdev, wq->sq.qid,
+					 CXGB4_BAR2_QTYPE_EGRESS,
 					 &wq->sq.bar2_qid,
 					 user ? &wq->sq.bar2_pa : NULL);
 	if (need_rq)
 		wq->rq.bar2_va = c4iw_bar2_addrs(rdev, wq->rq.qid,
-						 T4_BAR2_QTYPE_EGRESS,
+						 CXGB4_BAR2_QTYPE_EGRESS,
 						 &wq->rq.bar2_qid,
 						 user ? &wq->rq.bar2_pa : NULL);
 
@@ -2572,7 +2573,7 @@ static int alloc_srq_queue(struct c4iw_srq *srq, struct c4iw_dev_ucontext *uctx,
 	memset(wq->queue, 0, wq->memsize);
 	pci_unmap_addr_set(wq, mapping, wq->dma_addr);
 
-	wq->bar2_va = c4iw_bar2_addrs(rdev, wq->qid, T4_BAR2_QTYPE_EGRESS,
+	wq->bar2_va = c4iw_bar2_addrs(rdev, wq->qid, CXGB4_BAR2_QTYPE_EGRESS,
 				      &wq->bar2_qid,
 			user ? &wq->bar2_pa : NULL);
 
-- 
2.19.0
