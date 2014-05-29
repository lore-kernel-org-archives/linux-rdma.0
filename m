From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/6] mlx4_core: Fix memory leaks under SRIOV in case of error flow
Date: Thu, 29 May 2014 16:30:59 +0300
Message-ID: <1401370264-4818-2-git-send-email-ogerlitz@mellanox.com>
References: <1401370264-4818-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401370264-4818-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Fix few memory leaks that happen if errors happen under SRIOV mode.


Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 7cf9dad..12a7ee2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1696,6 +1696,13 @@ unmap_bf:
 	unmap_internal_clock(dev);
 	unmap_bf_area(dev);
 
+	if (mlx4_is_slave(dev)) {
+		kfree(dev->caps.qp0_tunnel);
+		kfree(dev->caps.qp0_proxy);
+		kfree(dev->caps.qp1_tunnel);
+		kfree(dev->caps.qp1_proxy);
+	}
+
 err_close:
 	if (mlx4_is_slave(dev))
 		mlx4_slave_exit(dev);
@@ -2565,6 +2572,13 @@ err_master_mfunc:
 	if (mlx4_is_master(dev))
 		mlx4_multi_func_cleanup(dev);
 
+	if (mlx4_is_slave(dev)) {
+		kfree(dev->caps.qp0_tunnel);
+		kfree(dev->caps.qp0_proxy);
+		kfree(dev->caps.qp1_tunnel);
+		kfree(dev->caps.qp1_proxy);
+	}
+
 err_close:
 	if (dev->flags & MLX4_FLAG_MSI_X)
 		pci_disable_msix(pdev);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
