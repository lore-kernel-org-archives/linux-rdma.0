From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 1/6] IB/mlx5: Clear umr resources after ib_unregister_device
Date: Sun, 14 Sep 2014 16:47:50 +0300
Message-ID: <1410702475-28826-2-git-send-email-eli@mellanox.com>
References: <1410702475-28826-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410702475-28826-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some ULPs may make use of resources created in create_umr_res so make sure to
call destroy_umrc_res after returning from ib_unregister_device which makes
sure all ULPs have closed their resources.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d8907b20522a..ecd3aebc46fe 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1414,8 +1414,8 @@ err_dealloc:
 static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 {
 	struct mlx5_ib_dev *dev = context;
-	destroy_umrc_res(dev);
 	ib_unregister_device(&dev->ib_dev);
+	destroy_umrc_res(dev);
 	destroy_dev_resources(&dev->devr);
 	free_comp_eqs(dev);
 	ib_dealloc_device(&dev->ib_dev);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
