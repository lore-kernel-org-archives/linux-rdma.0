From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 01/10] net/mlx5: Export required core functions to support RSS
Date: Sun, 17 Apr 2016 17:27:08 +0300
Message-ID: <1460903237-16870-2-git-send-email-yishaih@mellanox.com>
References: <1460903237-16870-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460903237-16870-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In order to support RSS QPs, we need to create Ethernet based objects.
This is done by create_rq, destroy_rq, create_rqt and destroy_rqt
mlx5_core functions. We export these functions.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/transobj.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
index 03a5093..28274a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
@@ -85,6 +85,7 @@ int mlx5_core_create_rq(struct mlx5_core_dev *dev, u32 *in, int inlen, u32 *rqn)
 
 	return err;
 }
+EXPORT_SYMBOL(mlx5_core_create_rq);
 
 int mlx5_core_modify_rq(struct mlx5_core_dev *dev, u32 rqn, u32 *in, int inlen)
 {
@@ -110,6 +111,7 @@ void mlx5_core_destroy_rq(struct mlx5_core_dev *dev, u32 rqn)
 
 	mlx5_cmd_exec_check_status(dev, in, sizeof(in), out, sizeof(out));
 }
+EXPORT_SYMBOL(mlx5_core_destroy_rq);
 
 int mlx5_core_query_rq(struct mlx5_core_dev *dev, u32 rqn, u32 *out)
 {
@@ -430,6 +432,7 @@ int mlx5_core_create_rqt(struct mlx5_core_dev *dev, u32 *in, int inlen,
 
 	return err;
 }
+EXPORT_SYMBOL(mlx5_core_create_rqt);
 
 int mlx5_core_modify_rqt(struct mlx5_core_dev *dev, u32 rqtn, u32 *in,
 			 int inlen)
@@ -455,3 +458,4 @@ void mlx5_core_destroy_rqt(struct mlx5_core_dev *dev, u32 rqtn)
 
 	mlx5_cmd_exec_check_status(dev, in, sizeof(in), out, sizeof(out));
 }
+EXPORT_SYMBOL(mlx5_core_destroy_rqt);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
