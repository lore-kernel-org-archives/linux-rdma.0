From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 20/37] IB/mlx4: Switch from dma_device to dev.parent
Date: Fri, 20 Jan 2017 13:04:20 -0800
Message-ID: <20170120210437.26389-21-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Prepare for removal of ib_device.dma_device.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    | 2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h | 2 +-
 drivers/infiniband/hw/mlx4/mr.c      | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 7031a8dd4d14..369d254bafeb 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2625,7 +2625,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.phys_port_cnt     = mlx4_is_bonded(dev) ?
 						1 : ibdev->num_ports;
 	ibdev->ib_dev.num_comp_vectors	= dev->caps.num_comp_vectors;
-	ibdev->ib_dev.dma_device	= &dev->persist->pdev->dev;
+	ibdev->ib_dev.dev.parent	= &dev->persist->pdev->dev;
 	ibdev->ib_dev.get_netdev	= mlx4_ib_get_netdev;
 	ibdev->ib_dev.add_gid		= mlx4_ib_add_gid;
 	ibdev->ib_dev.del_gid		= mlx4_ib_del_gid;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 7f3d976d81ed..64fed44b43a6 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -55,7 +55,7 @@
 #define pr_fmt(fmt)	"<" MLX4_IB_DRV_NAME "> %s: " fmt, __func__
 
 #define mlx4_ib_warn(ibdev, format, arg...) \
-	dev_warn((ibdev)->dma_device, MLX4_IB_DRV_NAME ": " format, ## arg)
+	dev_warn((ibdev)->dev.parent, MLX4_IB_DRV_NAME ": " format, ## arg)
 
 enum {
 	MLX4_IB_SQ_MIN_WQE_SHIFT = 6,
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 5d73989d9771..433bcdbdd680 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -292,10 +292,10 @@ mlx4_alloc_priv_pages(struct ib_device *device,
 	if (!mr->pages)
 		return -ENOMEM;
 
-	mr->page_map = dma_map_single(device->dma_device, mr->pages,
+	mr->page_map = dma_map_single(device->dev.parent, mr->pages,
 				      mr->page_map_size, DMA_TO_DEVICE);
 
-	if (dma_mapping_error(device->dma_device, mr->page_map)) {
+	if (dma_mapping_error(device->dev.parent, mr->page_map)) {
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -313,7 +313,7 @@ mlx4_free_priv_pages(struct mlx4_ib_mr *mr)
 	if (mr->pages) {
 		struct ib_device *device = mr->ibmr.device;
 
-		dma_unmap_single(device->dma_device, mr->page_map,
+		dma_unmap_single(device->dev.parent, mr->page_map,
 				 mr->page_map_size, DMA_TO_DEVICE);
 		free_page((unsigned long)mr->pages);
 		mr->pages = NULL;
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
