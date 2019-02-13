From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 07/15] net/mlx5: Add host params change event
Date: Tue, 12 Feb 2019 22:55:38 -0800
Message-ID: <20190213065546.3013-8-saeedm@mellanox.com>
References: <20190213065546.3013-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213065546.3013-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Bodong Wang <bodong@mellanox.com>, Eli Cohen <eli@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

In Embedded CPU (EC) configurations, the EC driver needs to know when
the number of virtual functions change on the corresponding PF at the
host side. This is required so the EC driver can create or destroy
representor net devices that represent the VFs ports.

Whenever a change in the number of VFs occurs, firmware will generate an
event towards the EC which will trigger a work to complete the rest of
the handling. The specifics of the handling will be introduced in a
downstream patch.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c     | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/events.c | 2 ++
 include/linux/mlx5/device.h                      | 2 ++
 include/linux/mlx5/driver.h                      | 5 +++++
 4 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 7092457705a2..5c02f9291799 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -530,6 +530,9 @@ static u64 gather_async_events_mask(struct mlx5_core_dev *dev)
 	if (MLX5_CAP_GEN(dev, max_num_of_monitor_counters))
 		async_event_mask |= (1ull << MLX5_EVENT_TYPE_MONITOR_COUNTER);
 
+	if (mlx5_core_is_ecpf_esw_manager(dev))
+		async_event_mask |= (1ull << MLX5_EVENT_TYPE_HOST_PARAMS_CHANGE);
+
 	return async_event_mask;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index fbc42b7252a9..4f7f776d6332 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -103,6 +103,8 @@ static const char *eqe_type_str(u8 type)
 		return "MLX5_EVENT_TYPE_STALL_EVENT";
 	case MLX5_EVENT_TYPE_CMD:
 		return "MLX5_EVENT_TYPE_CMD";
+	case MLX5_EVENT_TYPE_HOST_PARAMS_CHANGE:
+		return "MLX5_EVENT_TYPE_HOST_PARAMS_CHANGE";
 	case MLX5_EVENT_TYPE_PAGE_REQUEST:
 		return "MLX5_EVENT_TYPE_PAGE_REQUEST";
 	case MLX5_EVENT_TYPE_PAGE_FAULT:
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index f2070350f60a..f93a5598b942 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -342,6 +342,8 @@ enum mlx5_event {
 	MLX5_EVENT_TYPE_PAGE_FAULT	   = 0xc,
 	MLX5_EVENT_TYPE_NIC_VPORT_CHANGE   = 0xd,
 
+	MLX5_EVENT_TYPE_HOST_PARAMS_CHANGE = 0xe,
+
 	MLX5_EVENT_TYPE_DCT_DRAINED        = 0x1c,
 
 	MLX5_EVENT_TYPE_FPGA_ERROR         = 0x20,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index cce4e8293384..151563a12fc2 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1083,6 +1083,11 @@ static inline bool mlx5_core_is_ecpf(struct mlx5_core_dev *dev)
 	return dev->caps.embedded_cpu;
 }
 
+static inline bool mlx5_core_is_ecpf_esw_manager(struct mlx5_core_dev *dev)
+{
+	return dev->caps.embedded_cpu && MLX5_CAP_GEN(dev, eswitch_manager);
+}
+
 #define MLX5_TOTAL_VPORTS(mdev) (1 + pci_sriov_get_totalvfs((mdev)->pdev))
 #define MLX5_VPORT_MANAGER(mdev) \
 	(MLX5_CAP_GEN(mdev, vport_group_manager) && \
-- 
2.20.1
