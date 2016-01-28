From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-4.5-rc1 4/5] IB/mlx5: Use MLX5_GET to get end_padding_mode
Date: Thu, 28 Jan 2016 13:04:14 +0200
Message-ID: <1453979055-25285-5-git-send-email-matanb@mellanox.com>
References: <1453979055-25285-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453979055-25285-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

MLX5_GET64 was used on end_padding_mode, which is a 2-bit field.
This is wrong as the calculated offset is incorrect. Using MLX5_GET
instead of MLX5_GET64 to fix that.

Fixes: 0fb2ed66a14c ('IB/mlx5: Add create and destroy functionality
                     for Raw Packet QP')
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 40bbe96..9116bc3 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1036,7 +1036,7 @@ static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 	wq = MLX5_ADDR_OF(rqc, rqc, wq);
 	MLX5_SET(wq, wq, wq_type, MLX5_WQ_TYPE_CYCLIC);
 	MLX5_SET(wq, wq, end_padding_mode,
-		 MLX5_GET64(qpc, qpc, end_padding_mode));
+		 MLX5_GET(qpc, qpc, end_padding_mode));
 	MLX5_SET(wq, wq, page_offset, MLX5_GET(qpc, qpc, page_offset));
 	MLX5_SET(wq, wq, pd, MLX5_GET(qpc, qpc, pd));
 	MLX5_SET64(wq, wq, dbr_addr, MLX5_GET64(qpc, qpc, dbr_addr));
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
