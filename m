From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 10/15] net/mlx5: Relocate vport macros to the vport header file
Date: Tue, 12 Feb 2019 22:55:41 -0800
Message-ID: <20190213065546.3013-11-saeedm@mellanox.com>
References: <20190213065546.3013-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213065546.3013-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Bodong Wang <bodong@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

These are two macros in the driver general header which deal with the
number of total vports and if a vport is vport manager. Such macros
are vport entities, better to place them at the vport header file.

This patch doesn't change any functionality.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c      | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 1 +
 include/linux/mlx5/driver.h                       | 6 ------
 include/linux/mlx5/vport.h                        | 7 +++++++
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 5c02f9291799..bb6e5b5d9681 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -34,6 +34,7 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/vport.h>
 #include <linux/mlx5/eq.h>
 #include <linux/mlx5/cmd.h>
 #ifdef CONFIG_RFS_ACCEL
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 79f122b45def..b6a7bc8f667c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -32,6 +32,7 @@
 
 #include <linux/mutex.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/vport.h>
 #include <linux/mlx5/eswitch.h>
 
 #include "mlx5_core.h"
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 46e0aa52a58a..c5454f985e1d 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1097,12 +1097,6 @@ static inline u16 mlx5_core_max_vfs(struct mlx5_core_dev *dev)
 		return pci_sriov_get_totalvfs(dev->pdev);
 }
 
-#define MLX5_TOTAL_VPORTS(mdev) (1 + mlx5_core_max_vfs(mdev))
-#define MLX5_VPORT_MANAGER(mdev) \
-	(MLX5_CAP_GEN(mdev, vport_group_manager) && \
-	 (MLX5_CAP_GEN(mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) && \
-	 mlx5_core_is_pf(mdev))
-
 static inline int mlx5_get_gid_table_len(u16 param)
 {
 	if (param > 4) {
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 2e2928eacd97..28f47e868fbc 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -36,6 +36,13 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/device.h>
 
+#define MLX5_TOTAL_VPORTS(mdev)	(1 + mlx5_core_max_vfs(mdev))
+
+#define MLX5_VPORT_MANAGER(mdev)					\
+	(MLX5_CAP_GEN(mdev, vport_group_manager) &&			\
+	 (MLX5_CAP_GEN(mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&	\
+	 mlx5_core_is_pf(mdev))
+
 enum {
 	MLX5_CAP_INLINE_MODE_L2,
 	MLX5_CAP_INLINE_MODE_VPORT_CONTEXT,
-- 
2.20.1
