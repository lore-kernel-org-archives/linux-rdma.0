From: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Subject: [patch v2 37/37] add Kconfig
Date: Sun, 24 Jul 2011 14:43:37 -0500
Message-ID: <20110724201229.966262587@systemfabricworks.com>
References: <20110724194300.421253331@systemfabricworks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=add-Kconfig.c
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Kconfig file

Signed-off-by: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>

---
 drivers/infiniband/Kconfig        |    1 +
 drivers/infiniband/Makefile       |    1 +
 drivers/infiniband/hw/rxe/Kconfig |   28 ++++++++++++++++++++++++++++
 3 files changed, 30 insertions(+)

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
Index: infiniband/drivers/infiniband/hw/rxe/Kconfig
===================================================================
--- /dev/null
+++ infiniband/drivers/infiniband/hw/rxe/Kconfig
@@ -0,0 +1,28 @@
+config INFINIBAND_RXE
+	tristate "Software RDMA over Ethernet (RoCE) driver"
+	depends on INET && PCI && INFINIBAND
+	---help---
+	This driver implements the InfiniBand RDMA transport over
+	the Linux network stack. It enables a system with a
+	standard Ethernet adapter to interoperate with a RoCE
+	adapter or with another system running the RXE driver.
+	Documentation on InfiniBand and RoCE can be downloaded at
+	www.infinibandta.org and www.openfabrics.org. (See also
+	siw which is a similar software driver for iWARP.)
+
+	The driver is split into two layers, one interfaces with the
+	Linux RDMA stack and implements a kernel or user space
+	verbs API. The user space verbs API requires a support
+	library named librxe which is loaded by the generic user
+	space verbs API, libibverbs. The other layer interfaces
+	with the Linux network stack at layer 3.
+
+	There are three kernel modules provided with RXE.
+
+	ib_rxe		- attaches to the Linux RDMA stack
+	ib_rxe_net	- attaches to the Linux network stack
+	ib_rxe_sample	- provides a simple sample network layer
+			  driver that provides a loopback interface.
+
+	Rxe_cfg provided with librxe is a configuration tool that
+	loads and unloads the ib_rxe and ib_rxe_net kernel modules


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
