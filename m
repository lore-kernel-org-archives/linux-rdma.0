From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next] IB/rxe: Trivial coding style fix
Date: Tue,  5 Jul 2016 19:09:59 +0300
Message-ID: <1467734999-21389-1-git-send-email-monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A line was unnecessarily broken and with bad indentation.
Also, unnecessary braces were removed.

Fixes: 99c483da1a82 ('IB/rxe: QP request handling')
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/rxe/rxe_req.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/rxe/rxe_req.c b/drivers/infiniband/hw/rxe/rxe_req.c
index e945967..f78efa6 100644
--- a/drivers/infiniband/hw/rxe/rxe_req.c
+++ b/drivers/infiniband/hw/rxe/rxe_req.c
@@ -547,10 +547,8 @@ static void update_state(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 	qp->req.opcode = pkt->opcode;
 
 
-	if (pkt->mask & RXE_END_MASK) {
-		qp->req.wqe_index = next_index(qp->sq.queue,
-									   qp->req.wqe_index);
-	}
+	if (pkt->mask & RXE_END_MASK)
+		qp->req.wqe_index = next_index(qp->sq.queue, qp->req.wqe_index);
 
 	qp->need_req_skb = 0;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
