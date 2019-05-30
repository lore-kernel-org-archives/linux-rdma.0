From: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] IB/mlx5: Limit to 64-bit builds
Date: Thu, 30 May 2019 04:35:44 -0700
Message-ID: <1559216144-2085-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>, Ariel Levkovich <lariel@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

32-bit builds fail with errors such as

ERROR: "__udivdi3" [drivers/infiniband/hw/mlx5/mlx5_ib.ko] undefined!

Fixes: 25c13324d03d ("IB/mlx5: Add steering SW ICM device memory type")
Cc: Ariel Levkovich <lariel@mellanox.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/infiniband/hw/mlx5/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/Kconfig b/drivers/infiniband/hw/mlx5/Kconfig
index ea248def4556..574b97da7a43 100644
--- a/drivers/infiniband/hw/mlx5/Kconfig
+++ b/drivers/infiniband/hw/mlx5/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config MLX5_INFINIBAND
 	tristate "Mellanox 5th generation network adapters (ConnectX series) support"
-	depends on NETDEVICES && ETHERNET && PCI && MLX5_CORE
+	depends on NETDEVICES && ETHERNET && PCI && MLX5_CORE && 64BIT
 	---help---
 	  This driver provides low-level InfiniBand support for
 	  Mellanox Connect-IB PCI Express host channel adapters (HCAs).
-- 
2.7.4
