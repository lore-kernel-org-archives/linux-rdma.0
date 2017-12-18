From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH rdma-rc 1/3] iw_cxgb4: Only validate the MSN for successful
 completions
Date: Mon, 18 Dec 2017 13:10:00 -0800
Message-ID: <20171220191644.CB3F62BC88@smtp.opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the RECV CQE is in error, ignore the MSN check.  This was causing
recvs that were flushed into the sw cq to be completed with the wrong
status (BAD_MSN instead of FLUSHED).

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index b7bfc53..7ed8762 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -571,10 +571,10 @@ static int poll_cq(struct t4_wq *wq, struct t4_cq *cq, struct t4_cqe *cqe,
 			ret = -EAGAIN;
 			goto skip_cqe;
 		}
-		if (unlikely((CQE_WRID_MSN(hw_cqe) != (wq->rq.msn)))) {
+		if (unlikely(!CQE_STATUS(hw_cqe) &&
+			     CQE_WRID_MSN(hw_cqe) != wq->rq.msn)) {
 			t4_set_wq_in_error(wq);
-			hw_cqe->header |= htonl(CQE_STATUS_V(T4_ERR_MSN));
-			goto proc_cqe;
+			hw_cqe->header |= cpu_to_be32(CQE_STATUS_V(T4_ERR_MSN));
 		}
 		goto proc_cqe;
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
