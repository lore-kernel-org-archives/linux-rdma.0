From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 6/7] RDMA/cxgb4: Avoid CQ arm overflows.
Date: Thu, 06 May 2010 18:06:47 -0500
Message-ID: <20100506230646.25362.35433.stgit@build.ogc.int>
References: <20100506230619.25362.97591.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506230619.25362.97591.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There are 2 limits that need to be taken into account when arming the CQ.
1) the GTS register limits the delta idx to <= 0xfff.
2) T4 HW limits it to < cq size.

Update t4_arm_cq() to account for these limits.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/t4.h |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index aeeb005..7f04dc5 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -449,11 +449,25 @@ struct t4_cq {
 static inline int t4_arm_cq(struct t4_cq *cq, int se)
 {
 	u32 val;
-
-	val = SEINTARM(se) | CIDXINC(cq->cidx_inc) | TIMERREG(6) |
-	      INGRESSQID(cq->cqid);
-	cq->cidx_inc = 0;
-	writel(val, cq->gts);
+	u16 inc;
+
+	do {
+		/*
+		 * inc must be less the both the max update value -and-
+		 * the size of the CQ.
+		 */
+		inc = cq->cidx_inc <= CIDXINC_MASK ? cq->cidx_inc :
+						     CIDXINC_MASK;
+		inc = inc <= (cq->size - 1) ? inc : (cq->size - 1);
+		if (inc == cq->cidx_inc)
+			val = SEINTARM(se) | CIDXINC(inc) | TIMERREG(6) |
+			      INGRESSQID(cq->cqid);
+		else
+			val = SEINTARM(0) | CIDXINC(inc) | TIMERREG(7) |
+			      INGRESSQID(cq->cqid);
+		cq->cidx_inc -= inc;
+		writel(val, cq->gts);
+	} while (cq->cidx_inc);
 	return 0;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
