From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 03/10] net/mlx5: Add support for plugged-disabled cable status in PME
Date: Sun,  9 Dec 2018 19:04:35 -0800
Message-ID: <20181210030442.7543-4-saeedm@mellanox.com>
References: <20181210030442.7543-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210030442.7543-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Mikhael Goikhman <migo@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Mikhael Goikhman <migo@mellanox.com>

Support a new hardware module status in port module events:
- module_status=0x4 (Cable plugged, but disabled)

Signed-off-by: Mikhael Goikhman <migo@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/events.c   | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index ba9249bcfcba..900fdd235ba0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -166,6 +166,8 @@ static const char *mlx5_pme_status_to_string(enum port_module_event_status_type
 		return "Cable unplugged";
 	case MLX5_MODULE_STATUS_ERROR:
 		return "Cable error";
+	case MLX5_MODULE_STATUS_DISABLED:
+		return "Cable disabled";
 	default:
 		return "Unknown status";
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index 979970f8fa0f..397a2847867a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -51,6 +51,7 @@ enum port_module_event_status_type {
 	MLX5_MODULE_STATUS_PLUGGED   = 0x1,
 	MLX5_MODULE_STATUS_UNPLUGGED = 0x2,
 	MLX5_MODULE_STATUS_ERROR     = 0x3,
+	MLX5_MODULE_STATUS_DISABLED  = 0x4,
 	MLX5_MODULE_STATUS_NUM,
 };
 
-- 
2.19.2
