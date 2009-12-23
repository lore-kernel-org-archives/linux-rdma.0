From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/mlx4: fix post_recv wq overflow check
Date: Wed, 23 Dec 2009 17:28:12 +0200 (IST)
Message-ID: <Pine.LNX.4.64.0912231727040.19295@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

the post recv flow should check wq overflow using the recv and not the send cq

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 989555c..2a97c96 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1752,7 +1752,7 @@ int mlx4_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 	ind = qp->rq.head & (qp->rq.wqe_cnt - 1);

 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
-		if (mlx4_wq_overflow(&qp->rq, nreq, qp->ibqp.send_cq)) {
+		if (mlx4_wq_overflow(&qp->rq, nreq, qp->ibqp.recv_cq)) {
 			err = -ENOMEM;
 			*bad_wr = wr;
 			goto out;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
