From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 8/8] net/mlx5: Fix tristate and description for MLX5 module
Date: Mon, 16 Jul 2018 18:35:37 -0700
Message-ID: <20180717013537.26411-9-saeedm@mellanox.com>
References: <20180717013537.26411-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180717013537.26411-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Eran Ben Elisha <eranbe@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Current description did not include new devices. Fix that by proving the
correct generic description.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/Kconfig              | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/main.c  | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/Kconfig b/drivers/infiniband/hw/mlx5/Kconfig
index fb4d77be019b..0440966bc6ec 100644
--- a/drivers/infiniband/hw/mlx5/Kconfig
+++ b/drivers/infiniband/hw/mlx5/Kconfig
@@ -1,5 +1,5 @@
 config MLX5_INFINIBAND
-	tristate "Mellanox Connect-IB HCA support"
+	tristate "Mellanox 5th generation network adapters (ConnectX series) support"
 	depends on NETDEVICES && ETHERNET && PCI && MLX5_CORE
 	depends on INFINIBAND_USER_ACCESS || INFINIBAND_USER_ACCESS=n
 	---help---
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 2545296a0c08..7a84dd07ced2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -3,7 +3,7 @@
 #
 
 config MLX5_CORE
-	tristate "Mellanox Technologies ConnectX-4 and Connect-IB core driver"
+	tristate "Mellanox 5th generation network adapters (ConnectX series) core driver"
 	depends on MAY_USE_DEVLINK
 	depends on PCI
 	imply PTP_1588_CLOCK
@@ -27,7 +27,7 @@ config MLX5_FPGA
           sandbox-specific client drivers.
 
 config MLX5_CORE_EN
-	bool "Mellanox Technologies ConnectX-4 Ethernet support"
+	bool "Mellanox 5th generation network adapters (ConnectX series) Ethernet support"
 	depends on NETDEVICES && ETHERNET && INET && PCI && MLX5_CORE
 	depends on IPV6=y || IPV6=n || MLX5_CORE=m
 	select PAGE_POOL
@@ -69,7 +69,7 @@ config MLX5_CORE_EN_DCB
 	  If unsure, set to Y
 
 config MLX5_CORE_IPOIB
-	bool "Mellanox Technologies ConnectX-4 IPoIB offloads support"
+	bool "Mellanox 5th generation network adapters (connectX series) IPoIB offloads support"
 	depends on MLX5_CORE_EN
 	default n
 	---help---
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 615005e63819..f9b950e1bd85 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -64,7 +64,7 @@
 #include "lib/clock.h"
 
 MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
-MODULE_DESCRIPTION("Mellanox Connect-IB, ConnectX-4 core driver");
+MODULE_DESCRIPTION("Mellanox 5th generation network adapters (ConnectX series) core driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(DRIVER_VERSION);
 
-- 
2.17.0
