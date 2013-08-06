From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 6/8] RDMA/cxgb4: Always do GTS write if cidx_inc == CIDXINC_MASK.
Date: Tue,  6 Aug 2013 21:04:38 +0530
Message-ID: <1375803280-7916-7-git-send-email-vipul@chelsio.com>
References: <1375803280-7916-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375803280-7916-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

When polling, we do a GTS update if the accumulated cidx_inc == the CQ
depth / 16.  However, if the CQ is large enough, Cq depth / 16 exceeds the size
of the field in the GTS word. So we also need to update if cidx_inc hits
CIDXINC_MASK to avoid overflowing the field.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/t4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 3a6a289..1272dfe 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -531,7 +531,7 @@ static inline void t4_swcq_consume(struct t4_cq *cq)
 static inline void t4_hwcq_consume(struct t4_cq *cq)
 {
 	cq->bits_type_ts = cq->queue[cq->cidx].bits_type_ts;
-	if (++cq->cidx_inc == (cq->size >> 4)) {
+	if (++cq->cidx_inc == (cq->size >> 4) || cq->cidx_inc == CIDXINC_MASK) {
 		u32 val;
 
 		val = SEINTARM(0) | CIDXINC(cq->cidx_inc) | TIMERREG(7) |
-- 
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
