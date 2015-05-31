From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 7/9] IB/mlx4: Add mmap call to map the hardware clock
Date: Sun, 31 May 2015 15:14:15 +0300
Message-ID: <1433074457-26437-8-git-send-email-ogerlitz@mellanox.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433074457-26437-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to read the HCA's cycle counter efficiently in
user space, we need to map the HCA's register.
This is done through mmap call.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c         |   18 +++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx4/main.c |   19 +++++++++++++++++++
 include/linux/mlx4/device.h               |    9 +++++++++
 3 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 914beae..3992349 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -716,8 +716,24 @@ static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 				       dev->dev->caps.num_uars,
 				       PAGE_SIZE, vma->vm_page_prot))
 			return -EAGAIN;
-	} else
+	} else if (vma->vm_pgoff == 3) {
+		struct mlx4_clock_params params;
+		int ret = mlx4_get_internal_clock_params(dev->dev, &params);
+
+		if (ret)
+			return ret;
+
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+		if (io_remap_pfn_range(vma, vma->vm_start,
+				       (pci_resource_start(dev->dev->persist->pdev,
+							   params.bar) +
+					params.offset)
+				       >> PAGE_SHIFT,
+				       PAGE_SIZE, vma->vm_page_prot))
+			return -EAGAIN;
+	} else {
 		return -EINVAL;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index ced5eca..70de39c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1674,6 +1674,25 @@ static int map_internal_clock(struct mlx4_dev *dev)
 	return 0;
 }
 
+int mlx4_get_internal_clock_params(struct mlx4_dev *dev,
+				   struct mlx4_clock_params *params)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	if (mlx4_is_slave(dev))
+		return -ENOTSUPP;
+
+	if (!params)
+		return -EINVAL;
+
+	params->bar = priv->fw.clock_bar;
+	params->offset = priv->fw.clock_offset;
+	params->size = MLX4_CLOCK_SIZE;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx4_get_internal_clock_params);
+
 static void unmap_internal_clock(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 83e80ab..f94984f 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -829,6 +829,12 @@ struct mlx4_dev {
 	struct mlx4_vf_dev     *dev_vfs;
 };
 
+struct mlx4_clock_params {
+	u64 offset;
+	u8 bar;
+	u8 size;
+};
+
 struct mlx4_eqe {
 	u8			reserved1;
 	u8			type;
@@ -1485,4 +1491,7 @@ int mlx4_ACCESS_PTYS_REG(struct mlx4_dev *dev,
 			 enum mlx4_access_reg_method method,
 			 struct mlx4_ptys_reg *ptys_reg);
 
+int mlx4_get_internal_clock_params(struct mlx4_dev *dev,
+				   struct mlx4_clock_params *params);
+
 #endif /* MLX4_DEVICE_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
