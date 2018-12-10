From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 mlx5-next 2/9] net/mlx5: Add support for PCIe power slot exceeded error in PME
Date: Mon, 10 Dec 2018 13:15:10 -0800
Message-ID: <20181210211517.3686-3-saeedm@mellanox.com>
References: <20181210211517.3686-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210211517.3686-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Mikhael Goikhman <migo@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Mikhael Goikhman <migo@mellanox.com>

Support a new hardware error type in port module events:
- error_type=0xc (PCIe system power slot exceeded)

Signed-off-by: Mikhael Goikhman <migo@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/events.c   | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 587d93ec905f..ba9249bcfcba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -190,6 +190,8 @@ static const char *mlx5_pme_error_to_string(enum port_module_event_error_type er
 		return "High Temperature";
 	case MLX5_MODULE_EVENT_ERROR_BAD_CABLE:
 		return "Bad or shorted cable/module";
+	case MLX5_MODULE_EVENT_ERROR_PCIE_POWER_SLOT_EXCEEDED:
+		return "One or more network ports have been powered down due to insufficient/unadvertised power on the PCIe slot";
 	default:
 		return "Unknown error";
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index af19fa61e9ef..979970f8fa0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -63,6 +63,7 @@ enum  port_module_event_error_type {
 	MLX5_MODULE_EVENT_ERROR_UNKNOWN_IDENTIFIER       = 0x5,
 	MLX5_MODULE_EVENT_ERROR_HIGH_TEMPERATURE         = 0x6,
 	MLX5_MODULE_EVENT_ERROR_BAD_CABLE                = 0x7,
+	MLX5_MODULE_EVENT_ERROR_PCIE_POWER_SLOT_EXCEEDED = 0xc,
 	MLX5_MODULE_EVENT_ERROR_NUM,
 };
 
-- 
2.19.2
