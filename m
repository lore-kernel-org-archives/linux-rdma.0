From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 3/5] IB/mlx5: Add support for hca_core_clock and timestamp_mask
Date: Tue, 15 Dec 2015 20:30:11 +0200
Message-ID: <1450204213-5630-4-git-send-email-matanb@mellanox.com>
References: <1450204213-5630-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450204213-5630-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reporting the hca_core_clock (in kHZ) and the timestamp_mask in
query_device extended verb. timestamp_mask is used by users in order
to know what is the valid range of the raw timestamps, while
hca_core_clock reports the clock frequency that is used for
timestamps.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 ++
 include/linux/mlx5/mlx5_ifc.h     | 9 ++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 7e97cb5..c707c43 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -293,6 +293,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 					   props->max_mcast_grp;
 	props->max_map_per_fmr = INT_MAX; /* no limit in ConnectIB */
+	props->hca_core_clock = MLX5_CAP_GEN(mdev, device_frequency_khz);
+	props->timestamp_mask = 0x7FFFFFFFFFFFFFFFULL;
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (MLX5_CAP_GEN(mdev, pg))
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1565324..1a74114 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -794,15 +794,18 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_63[0x8];
 	u8         log_uar_page_sz[0x10];
 
-	u8         reserved_64[0x100];
+	u8	   reserved_64[0x20];
+	u8	   device_frequency_mhz[0x20];
+	u8	   device_frequency_khz[0x20];
+	u8         reserved_65[0xa0];
 
-	u8         reserved_65[0x1f];
+	u8         reserved_66[0x1f];
 	u8         cqe_zip[0x1];
 
 	u8         cqe_zip_timeout[0x10];
 	u8         cqe_zip_max_num[0x10];
 
-	u8         reserved_66[0x220];
+	u8         reserved_67[0x220];
 };
 
 enum {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
