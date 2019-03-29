From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 09/14] net/mlx5: Use dev->priv.name instead of dev_name
Date: Fri, 29 Mar 2019 15:37:59 -0700
Message-ID: <20190329223804.8954-10-saeedm@mellanox.com>
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

Use mlx5_core mdev private name in message instead of using pci dev_name
to provide a better report/debug of different mlx5 device types.

This patch does not change any functionality.

Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                 | 2 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer_tracepoint.h   | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/health.c              | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index be48c6440251..a15bceba58d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1347,7 +1347,7 @@ static void set_wqname(struct mlx5_core_dev *dev)
 	struct mlx5_cmd *cmd = &dev->cmd;
 
 	snprintf(cmd->wq_name, sizeof(cmd->wq_name), "mlx5_cmd_%s",
-		 dev_name(&dev->pdev->dev));
+		 dev->priv.name);
 }
 
 static void clean_debug_files(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer_tracepoint.h
index 83f90e9aff45..7b5901d42994 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer_tracepoint.h
@@ -47,7 +47,7 @@ TRACE_EVENT(mlx5_fw,
 	TP_ARGS(tracer, trace_timestamp, lost, event_id, msg),
 
 	TP_STRUCT__entry(
-		__string(dev_name, dev_name(&tracer->dev->pdev->dev))
+		__string(dev_name, tracer->dev->priv.name)
 		__field(u64, trace_timestamp)
 		__field(bool, lost)
 		__field(u8, event_id)
@@ -55,7 +55,7 @@ TRACE_EVENT(mlx5_fw,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev_name(&tracer->dev->pdev->dev));
+		__assign_str(dev_name, tracer->dev->priv.name);
 		__entry->trace_timestamp = trace_timestamp;
 		__entry->lost = lost;
 		__entry->event_id = event_id;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index b0e3f809e886..fa28975dfe7b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -377,7 +377,7 @@ int mlx5_health_init(struct mlx5_core_dev *dev)
 		return -ENOMEM;
 
 	strcpy(name, "mlx5_health");
-	strcat(name, dev_name(&dev->pdev->dev));
+	strcat(name, dev->priv.name);
 	health->wq = create_singlethread_workqueue(name);
 	kfree(name);
 	if (!health->wq)
-- 
2.20.1
