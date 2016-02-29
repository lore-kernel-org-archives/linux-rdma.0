From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 08/10] IB/mlx5: Pick the right GSI transmission QP for sending
Date: Mon, 29 Feb 2016 15:45:10 +0200
Message-ID: <1456753512-17688-9-git-send-email-haggaie@mellanox.com>
References: <1456753512-17688-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456753512-17688-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Pick the QP to use according to the wr.ud.pkey_index field in the work
request. If the QP doesn't exist, it means the P_Key is zero and the packet
would have been dropped, so just generate a completion and move on.

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/gsi.c | 48 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
index 8d040626abb2..938f6ddca4b3 100644
--- a/drivers/infiniband/hw/mlx5/gsi.c
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -443,10 +443,47 @@ static int mlx5_ib_add_outstanding_wr(struct mlx5_ib_gsi_qp *gsi,
 	return 0;
 }
 
+/* Call with gsi->lock locked */
+static int mlx5_ib_gsi_silent_drop(struct mlx5_ib_gsi_qp *gsi,
+				    struct ib_ud_wr *wr)
+{
+	struct ib_wc wc = {
+		{ .wr_id = wr->wr.wr_id },
+		.status = IB_WC_SUCCESS,
+		.opcode = IB_WC_SEND,
+		.qp = &gsi->ibqp,
+	};
+	int ret;
+
+	ret = mlx5_ib_add_outstanding_wr(gsi, wr, &wc);
+	if (ret)
+		return ret;
+
+	generate_completions(gsi);
+
+	return 0;
+}
+
+/* Call with gsi->lock locked */
+static struct ib_qp *get_tx_qp(struct mlx5_ib_gsi_qp *gsi, struct ib_ud_wr *wr)
+{
+	struct mlx5_ib_dev *dev = to_mdev(gsi->rx_qp->device);
+	int qp_index = wr->pkey_index;
+
+	if (!mlx5_ib_deth_sqpn_cap(dev))
+		return gsi->rx_qp;
+
+	if (qp_index >= gsi->num_qps)
+		return NULL;
+
+	return gsi->tx_qps[qp_index];
+}
+
 int mlx5_ib_gsi_post_send(struct ib_qp *qp, struct ib_send_wr *wr,
 			  struct ib_send_wr **bad_wr)
 {
 	struct mlx5_ib_gsi_qp *gsi = gsi_qp(qp);
+	struct ib_qp *tx_qp;
 	unsigned long flags;
 	int ret;
 
@@ -456,11 +493,20 @@ int mlx5_ib_gsi_post_send(struct ib_qp *qp, struct ib_send_wr *wr,
 		cur_wr.wr.next = NULL;
 
 		spin_lock_irqsave(&gsi->lock, flags);
+		tx_qp = get_tx_qp(gsi, &cur_wr);
+		if (!tx_qp) {
+			ret = mlx5_ib_gsi_silent_drop(gsi, &cur_wr);
+			if (ret)
+				goto err;
+			spin_unlock_irqrestore(&gsi->lock, flags);
+			continue;
+		}
+
 		ret = mlx5_ib_add_outstanding_wr(gsi, &cur_wr, NULL);
 		if (ret)
 			goto err;
 
-		ret = ib_post_send(gsi->rx_qp, &cur_wr.wr, bad_wr);
+		ret = ib_post_send(tx_qp, &cur_wr.wr, bad_wr);
 		if (ret) {
 			/* Undo the effect of adding the outstanding wr */
 			gsi->outstanding_pi = (gsi->outstanding_pi - 1) %
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
