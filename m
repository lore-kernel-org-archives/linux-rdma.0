From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 13/14] IB/mlx5: Abort driver cleanup if teardown hca fails
Date: Tue, 14 Jan 2014 17:45:22 +0200
Message-ID: <1389714323-20130-14-git-send-email-eli@mellanox.com>
References: <1389714323-20130-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389714323-20130-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Do not continue with cleanup flow. If this ever happens we can check which
resources remained open.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 40a9f5e..a064f06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -460,7 +460,10 @@ disable_msix:
 
 err_stop_poll:
 	mlx5_stop_health_poll(dev);
-	mlx5_cmd_teardown_hca(dev);
+	if (mlx5_cmd_teardown_hca(dev)) {
+		dev_err(&dev->pdev->dev, "tear_down_hca failed, skip cleanup\n");
+		return err;
+	}
 
 err_pagealloc_stop:
 	mlx5_pagealloc_stop(dev);
@@ -503,7 +506,10 @@ void mlx5_dev_cleanup(struct mlx5_core_dev *dev)
 	mlx5_eq_cleanup(dev);
 	mlx5_disable_msix(dev);
 	mlx5_stop_health_poll(dev);
-	mlx5_cmd_teardown_hca(dev);
+	if (mlx5_cmd_teardown_hca(dev)) {
+		dev_err(&dev->pdev->dev, "tear_down_hca failed, skip cleanup\n");
+		return;
+	}
 	mlx5_pagealloc_stop(dev);
 	mlx5_reclaim_startup_pages(dev);
 	mlx5_core_disable_hca(dev);
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
