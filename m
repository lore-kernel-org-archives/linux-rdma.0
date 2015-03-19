From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 3/4] iw_cxgb4: use BAR2 GTS register for T5 kernel mode CQs
Date: Thu, 19 Mar 2015 22:13:29 +0530
Message-ID: <1426783410-5128-4-git-send-email-hariprasad@chelsio.com>
References: <1426783410-5128-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426783410-5128-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For T5, we must not use the kdb/kgts registers, in order avoid db drops
under extreme loads.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c |   15 +++++++++++----
 drivers/infiniband/hw/cxgb4/t4.h |    7 ++++---
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index aed2b6b..646caf9 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -156,12 +156,19 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 		goto err4;
 
 	cq->gen = 1;
-	cq->gts = rdev->lldi.gts_reg;
 	cq->rdev = rdev;
 	if (user) {
-		cq->ugts = (u64)pci_resource_start(rdev->lldi.pdev, 2) +
-					(cq->cqid << rdev->cqshift);
-		cq->ugts &= PAGE_MASK;
+		u32 off = (cq->cqid << rdev->cqshift) & PAGE_MASK;
+
+		cq->ugts = (u64)rdev->bar2_pa + off;
+	} else if (is_t4(rdev->lldi.adapter_type)) {
+		cq->gts = rdev->lldi.gts_reg;
+		cq->qid_mask = -1U;
+	} else {
+		u32 off = ((cq->cqid << rdev->cqshift) & PAGE_MASK) + 12;
+
+		cq->gts = rdev->bar2_kva + off;
+		cq->qid_mask = rdev->qpmask;
 	}
 	return 0;
 err4:
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index c04e513..97f90e4 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -539,6 +539,7 @@ struct t4_cq {
 	size_t memsize;
 	__be64 bits_type_ts;
 	u32 cqid;
+	u32 qid_mask;
 	int vector;
 	u16 size; /* including status page */
 	u16 cidx;
@@ -563,12 +564,12 @@ static inline int t4_arm_cq(struct t4_cq *cq, int se)
 	set_bit(CQ_ARMED, &cq->flags);
 	while (cq->cidx_inc > CIDXINC_MASK) {
 		val = SEINTARM(0) | CIDXINC(CIDXINC_MASK) | TIMERREG(7) |
-		      INGRESSQID(cq->cqid);
+		      INGRESSQID(cq->cqid & cq->qid_mask);
 		writel(val, cq->gts);
 		cq->cidx_inc -= CIDXINC_MASK;
 	}
 	val = SEINTARM(se) | CIDXINC(cq->cidx_inc) | TIMERREG(6) |
-	      INGRESSQID(cq->cqid);
+	      INGRESSQID(cq->cqid & cq->qid_mask);
 	writel(val, cq->gts);
 	cq->cidx_inc = 0;
 	return 0;
@@ -601,7 +602,7 @@ static inline void t4_hwcq_consume(struct t4_cq *cq)
 		u32 val;
 
 		val = SEINTARM(0) | CIDXINC(cq->cidx_inc) | TIMERREG(7) |
-		      INGRESSQID(cq->cqid);
+		      INGRESSQID(cq->cqid & cq->qid_mask);
 		writel(val, cq->gts);
 		cq->cidx_inc = 0;
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
