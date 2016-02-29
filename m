From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 09/10] IB/mlx5: Eliminate GSI RX QP's send buffers
Date: Mon, 29 Feb 2016 15:45:11 +0200
Message-ID: <1456753512-17688-10-git-send-email-haggaie@mellanox.com>
References: <1456753512-17688-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456753512-17688-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Now that the transmission of GSI MADs is done with the special transmission
QPs, eliminate the send buffers in the GSI receive QP.

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/gsi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
index 938f6ddca4b3..53e03c8ede79 100644
--- a/drivers/infiniband/hw/mlx5/gsi.c
+++ b/drivers/infiniband/hw/mlx5/gsi.c
@@ -187,6 +187,11 @@ struct ib_qp *mlx5_ib_gsi_create_qp(struct ib_pd *pd,
 
 	hw_init_attr.qp_type = MLX5_IB_QPT_HW_GSI;
 	hw_init_attr.send_cq = gsi->cq;
+	if (num_qps) {
+		hw_init_attr.cap.max_send_wr = 0;
+		hw_init_attr.cap.max_send_sge = 0;
+		hw_init_attr.cap.max_inline_data = 0;
+	}
 	gsi->rx_qp = ib_create_qp(pd, &hw_init_attr);
 	if (IS_ERR(gsi->rx_qp)) {
 		mlx5_ib_warn(dev, "unable to create hardware GSI QP. error %ld\n",
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
