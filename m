From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 11/14] net/mlx5: Add explicit bar address field
Date: Fri, 29 Mar 2019 15:38:01 -0700
Message-ID: <20190329223804.8954-12-saeedm@mellanox.com>
References: <20190329223804.8954-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190329223804.8954-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeed@mellanox.com, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Huy Nguyen <huyn@mellanox.com>, Vu Pham <vuhuong@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

Add bar_addr field to store bar-0 address to avoid calling
pci_resource_start with hard-coded bar-0 as parameter.
Also note that different mlx5 device types will have bar_addr
on different bars.

This patch does not change any functionality.

Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cmd.c               | 4 ++--
 drivers/infiniband/hw/mlx5/main.c              | 8 ++++----
 drivers/infiniband/hw/mlx5/mr.c                | 3 +--
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/uar.c  | 2 +-
 include/linux/mlx5/driver.h                    | 1 +
 6 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index 6bcc63aaa50b..be95ac5aeb30 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -148,7 +148,7 @@ int mlx5_cmd_alloc_memic(struct mlx5_memic *memic, phys_addr_t *addr,
 			return ret;
 		}
 
-		*addr = pci_resource_start(dev->pdev, 0) +
+		*addr = dev->bar_addr +
 			MLX5_GET64(alloc_memic_out, out, memic_start_addr);
 
 		return 0;
@@ -167,7 +167,7 @@ int mlx5_cmd_dealloc_memic(struct mlx5_memic *memic, u64 addr, u64 length)
 	u64 start_page_idx;
 	int err;
 
-	addr -= pci_resource_start(dev->pdev, 0);
+	addr -= dev->bar_addr;
 	start_page_idx = (addr - hw_start_addr) >> PAGE_SHIFT;
 
 	MLX5_SET(dealloc_memic_in, in, opcode, MLX5_CMD_OP_DEALLOC_MEMIC);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 531ff20b32ad..0845e95d2d11 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2009,7 +2009,7 @@ static phys_addr_t uar_index2pfn(struct mlx5_ib_dev *dev,
 
 	fw_uars_per_page = MLX5_CAP_GEN(dev->mdev, uar_4k) ? MLX5_UARS_IN_PAGE : 1;
 
-	return (pci_resource_start(dev->mdev->pdev, 0) >> PAGE_SHIFT) + uar_idx / fw_uars_per_page;
+	return (dev->mdev->bar_addr >> PAGE_SHIFT) + uar_idx / fw_uars_per_page;
 }
 
 static int get_command(unsigned long offset)
@@ -2199,7 +2199,7 @@ static int dm_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	    page_idx + npages)
 		return -EINVAL;
 
-	pfn = ((pci_resource_start(dev->mdev->pdev, 0) +
+	pfn = ((dev->mdev->bar_addr +
 	      MLX5_CAP64_DEV_MEM(dev->mdev, memic_bar_start_addr)) >>
 	      PAGE_SHIFT) +
 	      page_idx;
@@ -2283,7 +2283,7 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
 		goto err_free;
 
 	start_offset = memic_addr & ~PAGE_MASK;
-	page_idx = (memic_addr - pci_resource_start(memic->dev->pdev, 0) -
+	page_idx = (memic_addr - memic->dev->bar_addr -
 		    MLX5_CAP64_DEV_MEM(memic->dev, memic_bar_start_addr)) >>
 		    PAGE_SHIFT;
 
@@ -2326,7 +2326,7 @@ int mlx5_ib_dealloc_dm(struct ib_dm *ibdm)
 	if (ret)
 		return ret;
 
-	page_idx = (dm->dev_addr - pci_resource_start(memic->dev->pdev, 0) -
+	page_idx = (dm->dev_addr - memic->dev->bar_addr -
 		    MLX5_CAP64_DEV_MEM(memic->dev, memic_bar_start_addr)) >>
 		    PAGE_SHIFT;
 	bitmap_clear(to_mucontext(ibdm->uobject->context)->dm_pages,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index c85f00255884..ca921fd40499 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1194,8 +1194,7 @@ static struct ib_mr *mlx5_ib_get_memic_mr(struct ib_pd *pd, u64 memic_addr,
 	MLX5_SET64(mkc, mkc, len, length);
 	MLX5_SET(mkc, mkc, pd, to_mpd(pd)->pdn);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
-	MLX5_SET64(mkc, mkc, start_addr,
-		   memic_addr - pci_resource_start(dev->mdev->pdev, 0));
+	MLX5_SET64(mkc, mkc, start_addr, memic_addr - dev->mdev->bar_addr);
 
 	err = mlx5_core_create_mkey(mdev, &mr->mmkey, in, inlen);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index cbb5e76d9351..b200a29d1420 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -746,6 +746,7 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct pci_dev *pdev,
 
 	pci_set_drvdata(dev->pdev, dev);
 
+	dev->bar_addr = pci_resource_start(pdev, 0);
 	priv->numa_node = dev_to_node(&dev->pdev->dev);
 
 	err = mlx5_pci_enable_device(dev);
@@ -773,7 +774,7 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct pci_dev *pdev,
 	    pci_enable_atomic_ops_to_root(pdev, PCI_EXP_DEVCAP2_ATOMIC_COMP128))
 		mlx5_core_dbg(dev, "Enabling pci atomics failed\n");
 
-	dev->iseg_base = pci_resource_start(dev->pdev, 0);
+	dev->iseg_base = dev->bar_addr;
 	dev->iseg = ioremap(dev->iseg_base, sizeof(*dev->iseg));
 	if (!dev->iseg) {
 		err = -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/uar.c b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
index 94464723ff77..0d006224d7b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/uar.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
@@ -79,7 +79,7 @@ static u64 uar2pfn(struct mlx5_core_dev *mdev, u32 index)
 	else
 		system_page_index = index;
 
-	return (pci_resource_start(mdev->pdev, 0) >> PAGE_SHIFT) + system_page_index;
+	return (mdev->bar_addr >> PAGE_SHIFT) + system_page_index;
 }
 
 static void up_rel_func(struct kref *kref)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 302d65dfa17c..a74326a0178f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -660,6 +660,7 @@ struct mlx5_core_dev {
 	u64			sys_image_guid;
 	phys_addr_t		iseg_base;
 	struct mlx5_init_seg __iomem *iseg;
+	phys_addr_t             bar_addr;
 	enum mlx5_device_state	state;
 	/* sync interface state */
 	struct mutex		intf_state_mutex;
-- 
2.20.1
