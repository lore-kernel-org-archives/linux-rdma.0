From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] infiniband: mlx5: fix build error when
 INFINIBAND_USER_ACCESS=m
Date: Mon, 16 Apr 2018 14:21:07 -0700
Message-ID: <81ea9f01-4624-38d7-2bfe-1dd7063fa3f0@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matan Barak <matanb@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors when INFINIBAND_USER_ACCESS=m and MLX5_INFINIBAND=y.
The build error occurs when the mlx5 driver code attempts to use
USER_ACCESS interfaces, which are built as a loadable module.

Fixes these build errors:

drivers/infiniband/hw/mlx5/main.o: In function `populate_specs_root':
../drivers/infiniband/hw/mlx5/main.c:4982: undefined reference to `uverbs_default_get_objects'
../drivers/infiniband/hw/mlx5/main.c:4994: undefined reference to `uverbs_alloc_spec_tree'
drivers/infiniband/hw/mlx5/main.o: In function `depopulate_specs_root':
../drivers/infiniband/hw/mlx5/main.c:5001: undefined reference to `uverbs_free_spec_tree'

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Matan Barak <matanb@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org
Cc: stable@vger.kernel.org # reported against 4.16
---
 drivers/infiniband/hw/mlx5/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- lnx-417-rc1.orig/drivers/infiniband/hw/mlx5/Kconfig
+++ lnx-417-rc1/drivers/infiniband/hw/mlx5/Kconfig
@@ -1,6 +1,7 @@
 config MLX5_INFINIBAND
 	tristate "Mellanox Connect-IB HCA support"
 	depends on NETDEVICES && ETHERNET && PCI && MLX5_CORE
+	select INFINIBAND_USER_ACCESS
 	---help---
 	  This driver provides low-level InfiniBand support for
 	  Mellanox Connect-IB PCI Express host channel adapters (HCAs).
