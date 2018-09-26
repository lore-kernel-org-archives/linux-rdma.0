From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] RDMA: fix dependencies for rdma_user_mmap_io
Date: Wed, 26 Sep 2018 21:36:52 +0200
Message-ID: <20180926193706.2447532-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@mellanox.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Shaobo Xu <xushaobo2@huawei.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The mlx4 driver produces a link error when it is configured
as built-in while CONFIG_INFINIBAND_USER_ACCESS is set to =m:

drivers/infiniband/hw/mlx4/main.o: In function `mlx4_ib_mmap':
main.c:(.text+0x1af4): undefined reference to `rdma_user_mmap_io'

The same function is called from mlx5, which already has a
dependency to ensure we can call it, and from hns, which
appears to suffer from the same problem.

This adds the same dependency that mlx5 uses to the other two.

Fixes: 6745d356ab39 ("RDMA/hns: Use rdma_user_mmap_io")
Fixes: c282da4109e4 ("RDMA/mlx4: Use rdma_user_mmap_io")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/infiniband/hw/hns/Kconfig  | 1 +
 drivers/infiniband/hw/mlx4/Kconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/hns/Kconfig b/drivers/infiniband/hw/hns/Kconfig
index fddb5fdf92de..21c2100b2ea9 100644
--- a/drivers/infiniband/hw/hns/Kconfig
+++ b/drivers/infiniband/hw/hns/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_HNS
 	tristate "HNS RoCE Driver"
 	depends on NET_VENDOR_HISILICON
+	depends on INFINIBAND_USER_ACCESS || !INFINIBAND_USER_ACCESS
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
 	---help---
 	  This is a RoCE/RDMA driver for the Hisilicon RoCE engine. The engine
diff --git a/drivers/infiniband/hw/mlx4/Kconfig b/drivers/infiniband/hw/mlx4/Kconfig
index db4aa13ebae0..d1de3285fd88 100644
--- a/drivers/infiniband/hw/mlx4/Kconfig
+++ b/drivers/infiniband/hw/mlx4/Kconfig
@@ -1,6 +1,7 @@
 config MLX4_INFINIBAND
 	tristate "Mellanox ConnectX HCA support"
 	depends on NETDEVICES && ETHERNET && PCI && INET
+	depends on INFINIBAND_USER_ACCESS || !INFINIBAND_USER_ACCESS
 	depends on MAY_USE_DEVLINK
 	select NET_VENDOR_MELLANOX
 	select MLX4_CORE
-- 
2.18.0
