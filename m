From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 05/11] RDMA/cxgb4: Fix overflow bug in cq arm.
Date: Thu, 20 May 2010 16:57:49 -0500
Message-ID: <20100520215748.32394.1063.stgit@build.ogc.int>
References: <20100520215727.32394.90669.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100520215727.32394.90669.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

- wrap cq->cqidx_inc based on cq size.
- optimize t4_arm_cq logic.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/t4.h |   31 ++++++++++++-------------------
 1 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 712bc56..333abd3 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -449,25 +449,17 @@ struct t4_cq {
 static inline int t4_arm_cq(struct t4_cq *cq, int se)
 {
 	u32 val;
-	u16 inc;
-
-	do {
-		/*
-		 * inc must be less the both the max update value -and-
-		 * the size of the CQ.
-		 */
-		inc = cq->cidx_inc <= CIDXINC_MASK ? cq->cidx_inc :
-						     CIDXINC_MASK;
-		inc = inc <= (cq->size - 1) ? inc : (cq->size - 1);
-		if (inc == cq->cidx_inc)
-			val = SEINTARM(se) | CIDXINC(inc) | TIMERREG(6) |
-			      INGRESSQID(cq->cqid);
-		else
-			val = SEINTARM(0) | CIDXINC(inc) | TIMERREG(7) |
-			      INGRESSQID(cq->cqid);
-		cq->cidx_inc -= inc;
+
+	while (cq->cidx_inc > CIDXINC_MASK) {
+		val = SEINTARM(0) | CIDXINC(CIDXINC_MASK) | TIMERREG(7) |
+		      INGRESSQID(cq->cqid);
 		writel(val, cq->gts);
-	} while (cq->cidx_inc);
+		cq->cidx_inc -= CIDXINC_MASK;
+	}
+	val = SEINTARM(se) | CIDXINC(cq->cidx_inc) | TIMERREG(6) |
+	      INGRESSQID(cq->cqid);
+	writel(val, cq->gts);
+	cq->cidx_inc = 0;
 	return 0;
 }
 
@@ -488,7 +480,8 @@ static inline void t4_swcq_consume(struct t4_cq *cq)
 static inline void t4_hwcq_consume(struct t4_cq *cq)
 {
 	cq->bits_type_ts = cq->queue[cq->cidx].bits_type_ts;
-	cq->cidx_inc++;
+	if (++cq->cidx_inc == cq->size)
+		cq->cidx_inc = 0;
 	if (++cq->cidx == cq->size) {
 		cq->cidx = 0;
 		cq->gen ^= 1;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
