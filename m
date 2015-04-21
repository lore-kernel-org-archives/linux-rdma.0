From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCHv2 for-4.1 3/4] iw_cxgb4: use BAR2 GTS register for T5 kernel mode CQs
Date: Wed, 22 Apr 2015 01:45:00 +0530
Message-ID: <1429647301-6832-4-git-send-email-hariprasad@chelsio.com>
References: <1429647301-6832-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429647301-6832-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For T5, we must not use the kdb/kgts registers, in order avoid db drops
under extreme loads.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c | 15 +++++++++++----
 drivers/infiniband/hw/cxgb4/t4.h |  7 ++++---
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 3ca00fa..be66d5d 100644
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
index 871cdca..7f2a6c2 100644
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
 	while (cq->cidx_inc > CIDXINC_M) {
 		val = SEINTARM_V(0) | CIDXINC_V(CIDXINC_M) | TIMERREG_V(7) |
-		      INGRESSQID_V(cq->cqid);
+		      INGRESSQID_V(cq->cqid & cq->qid_mask);
 		writel(val, cq->gts);
 		cq->cidx_inc -= CIDXINC_M;
 	}
 	val = SEINTARM_V(se) | CIDXINC_V(cq->cidx_inc) | TIMERREG_V(6) |
-	      INGRESSQID_V(cq->cqid);
+	      INGRESSQID_V(cq->cqid & cq->qid_mask);
 	writel(val, cq->gts);
 	cq->cidx_inc = 0;
 	return 0;
@@ -601,7 +602,7 @@ static inline void t4_hwcq_consume(struct t4_cq *cq)
 		u32 val;
 
 		val = SEINTARM_V(0) | CIDXINC_V(cq->cidx_inc) | TIMERREG_V(7) |
-		      INGRESSQID_V(cq->cqid);
+		      INGRESSQID_V(cq->cqid & cq->qid_mask);
 		writel(val, cq->gts);
 		cq->cidx_inc = 0;
 	}
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
