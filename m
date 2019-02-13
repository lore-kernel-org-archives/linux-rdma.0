From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 08/15] net/mlx5: Provide an alternative VF upper bound for ECPF
Date: Tue, 12 Feb 2019 22:55:39 -0800
Message-ID: <20190213065546.3013-9-saeedm@mellanox.com>
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

ECPF doesn't support SR-IOV, but an ECPF E-Switch manager shall know
the max VFs supported by its peer host PF in order to control those
VF vports.

The current driver implementation uses the total vfs quantity as
provided by the pci sub-system for an upper bound of the VF vports
the e-switch code needs to deal with. This obviously can't work as
is on ECPF e-switch manager. For now, we use a hard coded value of
128 on such systems.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/driver.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 151563a12fc2..46e0aa52a58a 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1088,7 +1088,16 @@ static inline bool mlx5_core_is_ecpf_esw_manager(struct mlx5_core_dev *dev)
 	return dev->caps.embedded_cpu && MLX5_CAP_GEN(dev, eswitch_manager);
 }
 
-#define MLX5_TOTAL_VPORTS(mdev) (1 + pci_sriov_get_totalvfs((mdev)->pdev))
+#define MLX5_HOST_PF_MAX_VFS	(127u)
+static inline u16 mlx5_core_max_vfs(struct mlx5_core_dev *dev)
+{
+	if (mlx5_core_is_ecpf_esw_manager(dev))
+		return MLX5_HOST_PF_MAX_VFS;
+	else
+		return pci_sriov_get_totalvfs(dev->pdev);
+}
+
+#define MLX5_TOTAL_VPORTS(mdev) (1 + mlx5_core_max_vfs(mdev))
 #define MLX5_VPORT_MANAGER(mdev) \
 	(MLX5_CAP_GEN(mdev, vport_group_manager) && \
 	 (MLX5_CAP_GEN(mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) && \
-- 
2.20.1
