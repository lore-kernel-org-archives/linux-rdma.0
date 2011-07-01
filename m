From: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Subject: [patch 44/44] Kconfig
Date: Fri, 01 Jul 2011 08:19:05 -0500
Message-ID: <20110701132202.824114065@systemfabricworks.com>
References: <20110701131821.928693424@systemfabricworks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=patch44
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Kconfig file

Signed-off-by: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>

---
 drivers/infiniband/Kconfig        |    1 +
 drivers/infiniband/Makefile       |    1 +
 drivers/infiniband/hw/rxe/Kconfig |   26 ++++++++++++++++++++++++++
 3 files changed, 28 insertions(+)
Index: infiniband/drivers/infiniband/hw/rxe/Kconfig
===================================================================
--- /dev/null
+++ infiniband/drivers/infiniband/hw/rxe/Kconfig
@@ -0,0 +1,26 @@
+config INFINIBAND_RXE
+	tristate "Software RDMA driver"
+	depends on 64BIT && NET
+	---help---
+	This is a driver for a software implementation of IBTA
+	RDMA transport.
+
+	There are three kernel modules:
+
+	ib_rxe		- device independant transport driver.
+	ib_rxe_net	- connects transport to the netdev stack
+			  and runs on Ethernet devices. Follows the
+			  RoCE protocol i.e. GRH and no LRH.
+	ib_rxe_sample	- sample module that connects the transport
+			  to itself as a loopback and follows the
+			  InfiniBand protocol i.e. uses LRH. This
+			  could be used as a start for other experimantal
+			  software implementations of InfiniBand.
+
+	Normal use is to load ib_rxe and ib_rxe_net after loading ib_core.
+	There is a script rxe_cfg that automates the configuration of rxe.
+
+	This driver supports kernel and user space ULPs. For user space
+	verbs applications you must install librxe with libibverbs.
+
+	If you don't know what to use this for, you don't need it.
Index: infiniband/drivers/infiniband/Kconfig
===================================================================
--- infiniband.orig/drivers/infiniband/Kconfig
+++ infiniband/drivers/infiniband/Kconfig
@@ -51,6 +51,7 @@ source "drivers/infiniband/hw/cxgb3/Kcon
 source "drivers/infiniband/hw/cxgb4/Kconfig"
 source "drivers/infiniband/hw/mlx4/Kconfig"
 source "drivers/infiniband/hw/nes/Kconfig"
+source "drivers/infiniband/hw/rxe/Kconfig"
 
 source "drivers/infiniband/ulp/ipoib/Kconfig"
 
Index: infiniband/drivers/infiniband/Makefile
===================================================================
--- infiniband.orig/drivers/infiniband/Makefile
+++ infiniband/drivers/infiniband/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_INFINIBAND_CXGB3)		+= hw/cx
 obj-$(CONFIG_INFINIBAND_CXGB4)		+= hw/cxgb4/
 obj-$(CONFIG_MLX4_INFINIBAND)		+= hw/mlx4/
 obj-$(CONFIG_INFINIBAND_NES)		+= hw/nes/
+obj-$(CONFIG_INFINIBAND_RXE)		+= hw/rxe/
 obj-$(CONFIG_INFINIBAND_IPOIB)		+= ulp/ipoib/
 obj-$(CONFIG_INFINIBAND_SRP)		+= ulp/srp/
 obj-$(CONFIG_INFINIBAND_ISER)		+= ulp/iser/

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
