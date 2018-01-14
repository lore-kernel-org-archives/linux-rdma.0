From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/3] IB/core: postpone WR initialization during queue drain
Date: Sun, 14 Jan 2018 17:07:48 +0200
Message-ID: <1515942470-11461-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No need to initialize completion and WR in case we fail
during QP modification.

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index e36d27e..7868727 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2156,16 +2156,16 @@ static void __ib_drain_sq(struct ib_qp *qp)
 	struct ib_send_wr swr = {}, *bad_swr;
 	int ret;
 
-	swr.wr_cqe = &sdrain.cqe;
-	sdrain.cqe.done = ib_drain_qp_done;
-	init_completion(&sdrain.done);
-
 	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
 	if (ret) {
 		WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
 		return;
 	}
 
+	swr.wr_cqe = &sdrain.cqe;
+	sdrain.cqe.done = ib_drain_qp_done;
+	init_completion(&sdrain.done);
+
 	ret = ib_post_send(qp, &swr, &bad_swr);
 	if (ret) {
 		WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
@@ -2190,16 +2190,16 @@ static void __ib_drain_rq(struct ib_qp *qp)
 	struct ib_recv_wr rwr = {}, *bad_rwr;
 	int ret;
 
-	rwr.wr_cqe = &rdrain.cqe;
-	rdrain.cqe.done = ib_drain_qp_done;
-	init_completion(&rdrain.done);
-
 	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
 	if (ret) {
 		WARN_ONCE(ret, "failed to drain recv queue: %d\n", ret);
 		return;
 	}
 
+	rwr.wr_cqe = &rdrain.cqe;
+	rdrain.cqe.done = ib_drain_qp_done;
+	init_completion(&rdrain.done);
+
 	ret = ib_post_recv(qp, &rwr, &bad_rwr);
 	if (ret) {
 		WARN_ONCE(ret, "failed to drain recv queue: %d\n", ret);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
