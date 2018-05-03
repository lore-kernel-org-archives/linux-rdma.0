From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next] MAINTAINERS: Remove bouncing @mellanox.com addresses
Date: Thu,  3 May 2018 21:37:46 +0300
Message-ID: <20180503183746.7629-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Delete non-existent @mellanox.com addresses from MAINTAINERS file.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 MAINTAINERS | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0a1410d5a621..1b52c7e7fc7d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5391,7 +5391,6 @@ S:	Maintained
 F:	drivers/iommu/exynos-iommu.c

 EZchip NPS platform support
-M:	Elad Kanfi <eladkan@mellanox.com>
 M:	Vineet Gupta <vgupta@synopsys.com>
 S:	Supported
 F:	arch/arc/plat-eznps
@@ -9012,7 +9011,6 @@ Q:	http://patchwork.ozlabs.org/project/netdev/list/
 F:	drivers/net/ethernet/mellanox/mlx5/core/en_*

 MELLANOX ETHERNET INNOVA DRIVER
-M:	Ilan Tayari <ilant@mellanox.com>
 R:	Boris Pismenny <borisp@mellanox.com>
 L:	netdev@vger.kernel.org
 S:	Supported
@@ -9022,7 +9020,6 @@ F:	drivers/net/ethernet/mellanox/mlx5/core/fpga/*
 F:	include/linux/mlx5/mlx5_ifc_fpga.h

 MELLANOX ETHERNET INNOVA IPSEC DRIVER
-M:	Ilan Tayari <ilant@mellanox.com>
 R:	Boris Pismenny <borisp@mellanox.com>
 L:	netdev@vger.kernel.org
 S:	Supported
@@ -9078,7 +9075,6 @@ F:	include/uapi/rdma/mlx4-abi.h

 MELLANOX MLX5 core VPI driver
 M:	Saeed Mahameed <saeedm@mellanox.com>
-M:	Matan Barak <matanb@mellanox.com>
 M:	Leon Romanovsky <leonro@mellanox.com>
 L:	netdev@vger.kernel.org
 L:	linux-rdma@vger.kernel.org
@@ -9089,7 +9085,6 @@ F:	drivers/net/ethernet/mellanox/mlx5/core/
 F:	include/linux/mlx5/

 MELLANOX MLX5 IB driver
-M:	Matan Barak <matanb@mellanox.com>
 M:	Leon Romanovsky <leonro@mellanox.com>
 L:	linux-rdma@vger.kernel.org
 W:	http://www.mellanox.com
@@ -9821,7 +9816,6 @@ F:	net/netfilter/xt_CONNSECMARK.c
 F:	net/netfilter/xt_SECMARK.c

 NETWORKING [TLS]
-M:	Ilya Lesokhin <ilyal@mellanox.com>
 M:	Aviad Yehezkel <aviadye@mellanox.com>
 M:	Dave Watson <davejwatson@fb.com>
 L:	netdev@vger.kernel.org
