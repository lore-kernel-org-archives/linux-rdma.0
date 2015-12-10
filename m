From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/6] IB/mlx5: Exposed CQE version to user-space
Date: Thu, 10 Dec 2015 21:54:29 +0200
Message-ID: <1449777273-9219-3-git-send-email-majd@mellanox.com>
References: <1449777273-9219-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449777273-9219-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Report the CQE version to the user-space via the response of
alloc_ucontext command.

Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c              | 4 +++-
 drivers/infiniband/hw/mlx5/user.h              | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 ----
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index bdd60a6..1b503e0 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -633,6 +633,8 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	resp.max_send_wqebb = 1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz);
 	resp.max_recv_wr = 1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz);
 	resp.max_srq_recv_wr = 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
+	resp.cqe_version = MLX5_CAP_GEN(dev->mdev, cqe_version);
+	resp.reserved = 0;
 
 	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
@@ -684,7 +686,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	resp.tot_uuars = req.total_num_uuars;
 	resp.num_ports = MLX5_CAP_GEN(dev->mdev, num_ports);
 	err = ib_copy_to_udata(udata, &resp,
-			       sizeof(resp) - sizeof(resp.reserved));
+			       min(sizeof(resp), udata->outlen));
 	if (err)
 		goto out_uars;
 
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index 9a78578..4d70505 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -80,7 +80,8 @@ struct mlx5_ib_alloc_ucontext_resp {
 	__u32	max_recv_wr;
 	__u32	max_srq_recv_wr;
 	__u16	num_ports;
-	__u16	reserved;
+	__u8	cqe_version;
+	__u8	reserved;
 };
 
 struct mlx5_ib_alloc_pd_resp {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 03aabdd..f9380b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -601,7 +601,6 @@ clean:
 	return err;
 }
 
-#ifdef CONFIG_MLX5_CORE_EN
 static int mlx5_core_set_issi(struct mlx5_core_dev *dev)
 {
 	u32 query_in[MLX5_ST_SZ_DW(query_issi_in)];
@@ -654,7 +653,6 @@ static int mlx5_core_set_issi(struct mlx5_core_dev *dev)
 
 	return -ENOTSUPP;
 }
-#endif
 
 static int map_bf_area(struct mlx5_core_dev *dev)
 {
@@ -738,13 +736,11 @@ static int mlx5_dev_init(struct mlx5_core_dev *dev, struct pci_dev *pdev)
 		goto err_pagealloc_cleanup;
 	}
 
-#ifdef CONFIG_MLX5_CORE_EN
 	err = mlx5_core_set_issi(dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to set issi\n");
 		goto err_disable_hca;
 	}
-#endif
 
 	err = mlx5_satisfy_startup_pages(dev, 1);
 	if (err) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
