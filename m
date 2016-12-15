From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cxgb4: set correct FetchBurstMax for QPs
Date: Thu, 15 Dec 2016 08:09:35 -0800
Message-ID: <20161215210330.81B67E08C3@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The current QP FetchBurstMax value is 256B, which
is incorrect since a WR can exceed that value.  The
result being a partial WR fetched by hardware, and
a fatal "bad WR" error posted by the SGE.

So bump the FetchBurstMax to 512B.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index b7ac97b..cda5542 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -321,7 +321,8 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 		FW_RI_RES_WR_DCAEN_V(0) |
 		FW_RI_RES_WR_DCACPU_V(0) |
 		FW_RI_RES_WR_FBMIN_V(2) |
-		FW_RI_RES_WR_FBMAX_V(2) |
+		(t4_sq_onchip(&wq->sq) ? FW_RI_RES_WR_FBMAX_V(2) :
+					 FW_RI_RES_WR_FBMAX_V(3)) |
 		FW_RI_RES_WR_CIDXFTHRESHO_V(0) |
 		FW_RI_RES_WR_CIDXFTHRESH_V(0) |
 		FW_RI_RES_WR_EQSIZE_V(eqsize));
@@ -345,7 +346,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 		FW_RI_RES_WR_DCAEN_V(0) |
 		FW_RI_RES_WR_DCACPU_V(0) |
 		FW_RI_RES_WR_FBMIN_V(2) |
-		FW_RI_RES_WR_FBMAX_V(2) |
+		FW_RI_RES_WR_FBMAX_V(3) |
 		FW_RI_RES_WR_CIDXFTHRESHO_V(0) |
 		FW_RI_RES_WR_CIDXFTHRESH_V(0) |
 		FW_RI_RES_WR_EQSIZE_V(eqsize));
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
