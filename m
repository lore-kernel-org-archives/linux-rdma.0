From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 05/10] IB/mlx5: Fix returned values of query QP
Date: Sat,  4 Jun 2016 15:15:32 +0300
Message-ID: <1465042537-26129-6-git-send-email-leon@kernel.org>
References: <1465042537-26129-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042537-26129-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Some variables were not initialized properly: max_recv_wr,
max_recv_sge, max_send_wr, qp_context and max_inline_data.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB...')
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 5041176..43c1441 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -235,6 +235,8 @@ static int set_rq_size(struct mlx5_ib_dev *dev, struct ib_qp_cap *cap,
 		qp->rq.max_gs = 0;
 		qp->rq.wqe_cnt = 0;
 		qp->rq.wqe_shift = 0;
+		cap->max_recv_wr = 0;
+		cap->max_recv_sge = 0;
 	} else {
 		if (ucmd) {
 			qp->rq.wqe_cnt = ucmd->rq_wqe_count;
@@ -4079,17 +4081,19 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 	qp_attr->cap.max_recv_sge    = qp->rq.max_gs;
 
 	if (!ibqp->uobject) {
-		qp_attr->cap.max_send_wr  = qp->sq.wqe_cnt;
+		qp_attr->cap.max_send_wr  = qp->sq.max_post;
 		qp_attr->cap.max_send_sge = qp->sq.max_gs;
+		qp_init_attr->qp_context = ibqp->qp_context;
 	} else {
 		qp_attr->cap.max_send_wr  = 0;
 		qp_attr->cap.max_send_sge = 0;
 	}
 
-	/* We don't support inline sends for kernel QPs (yet), and we
-	 * don't know what userspace's value should be.
-	 */
-	qp_attr->cap.max_inline_data = 0;
+	qp_init_attr->qp_type = ibqp->qp_type;
+	qp_init_attr->recv_cq = ibqp->recv_cq;
+	qp_init_attr->send_cq = ibqp->send_cq;
+	qp_init_attr->srq = ibqp->srq;
+	qp_attr->cap.max_inline_data = qp->max_inline_data;
 
 	qp_init_attr->cap	     = qp_attr->cap;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
