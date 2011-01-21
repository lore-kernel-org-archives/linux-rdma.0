From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/2] RDMA/cxgb4: limit MAXBURST EQ context field to 256B.
Date: Fri, 21 Jan 2011 11:00:29 -0600
Message-ID: <20110121170028.23741.61673.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

MAXBURST cannot exceed 256B for on-chip queues. With a 512B MAXBURST,
we can lock up the chip.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/qp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 2080090..4f0be25 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -220,7 +220,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 		V_FW_RI_RES_WR_DCAEN(0) |
 		V_FW_RI_RES_WR_DCACPU(0) |
 		V_FW_RI_RES_WR_FBMIN(2) |
-		V_FW_RI_RES_WR_FBMAX(3) |
+		V_FW_RI_RES_WR_FBMAX(2) |
 		V_FW_RI_RES_WR_CIDXFTHRESHO(0) |
 		V_FW_RI_RES_WR_CIDXFTHRESH(0) |
 		V_FW_RI_RES_WR_EQSIZE(eqsize));
@@ -243,7 +243,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 		V_FW_RI_RES_WR_DCAEN(0) |
 		V_FW_RI_RES_WR_DCACPU(0) |
 		V_FW_RI_RES_WR_FBMIN(2) |
-		V_FW_RI_RES_WR_FBMAX(3) |
+		V_FW_RI_RES_WR_FBMAX(2) |
 		V_FW_RI_RES_WR_CIDXFTHRESHO(0) |
 		V_FW_RI_RES_WR_CIDXFTHRESH(0) |
 		V_FW_RI_RES_WR_EQSIZE(eqsize));

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
