From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/rxe: Avoid scheduling tasklet for userspace QP
Date: Wed, 28 Sep 2016 20:24:12 +0000
Message-ID: <1475094252-18304-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch avoids scheduing tasklet for WQE and protocol processing
for user space QP. It performs the task in calling process context.

To improve code readability kernel spacific post_send handling moved to
post_send_kernel() function.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 38 +++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 4552be9..a5af691 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -801,26 +801,15 @@ err1:
 	return err;
 }
 
-static int rxe_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
-			 struct ib_send_wr **bad_wr)
+static int rxe_post_send_kernel(struct rxe_qp *qp, struct ib_send_wr *wr,
+				struct ib_send_wr **bad_wr)
 {
 	int err = 0;
-	struct rxe_qp *qp = to_rqp(ibqp);
 	unsigned int mask;
 	unsigned int length = 0;
 	int i;
 	int must_sched;
 
-	if (unlikely(!qp->valid)) {
-		*bad_wr = wr;
-		return -EINVAL;
-	}
-
-	if (unlikely(qp->req.state < QP_STATE_READY)) {
-		*bad_wr = wr;
-		return -EINVAL;
-	}
-
 	while (wr) {
 		mask = wr_opcode_mask(wr->opcode, qp);
 		if (unlikely(!mask)) {
@@ -861,6 +850,29 @@ static int rxe_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	return err;
 }
 
+static int rxe_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
+			 struct ib_send_wr **bad_wr)
+{
+	struct rxe_qp *qp = to_rqp(ibqp);
+
+	if (unlikely(!qp->valid)) {
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+
+	if (unlikely(qp->req.state < QP_STATE_READY)) {
+		*bad_wr = wr;
+		return -EINVAL;
+	}
+
+	if (qp->is_user) {
+		/* Utilize process context to do protocol processing */
+		rxe_run_task(&qp->req.task, 0);
+		return 0;
+	} else
+		return rxe_post_send_kernel(qp, wr, bad_wr);
+}
+
 static int rxe_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 			 struct ib_recv_wr **bad_wr)
 {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
