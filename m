From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 8/8] mlx5: Mellanox Connect-IB driver part 8/8
Date: Sun, 16 Jun 2013 15:02:29 +0300
Message-ID: <1371384149-24558-9-git-send-email-eli@dev.mellanox.co.il>
References: <1371384149-24558-1-git-send-email-eli@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1371384149-24558-1-git-send-email-eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support for Mellanox Connect-IB driver. This patch presents the changes to
makefiles and Kconfigs to allow actually building this driver.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 MAINTAINERS                                      | 22 ++++++++++++++++++++++
 drivers/infiniband/Kconfig                       |  1 +
 drivers/infiniband/Makefile                      |  1 +
 drivers/infiniband/hw/mlx5/Kconfig               | 10 ++++++++++
 drivers/infiniband/hw/mlx5/Makefile              |  4 ++++
 drivers/net/ethernet/mellanox/Kconfig            |  1 +
 drivers/net/ethernet/mellanox/Makefile           |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig  | 18 ++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/Makefile |  6 ++++++
 9 files changed, 64 insertions(+)
 create mode 100644 drivers/infiniband/hw/mlx5/Kconfig
 create mode 100644 drivers/infiniband/hw/mlx5/Makefile
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/Kconfig
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index fd3a495..ee5add9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5349,6 +5349,28 @@ W:	http://linuxtv.org
 S:	Odd Fixes
 F:	drivers/media/radio/radio-miropcm20*
 
+Mellanox MLX5 core VPI driver
+M:	Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+L:	netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+W:	http://www.mellanox.com
+Q:	http://patchwork.ozlabs.org/project/netdev/list/
+Q:	http://patchwork.kernel.org/project/linux-rdma/list/
+T:	git://openfabrics.org/~eli/connect-ib.git
+S:	Supported
+F:	drivers/net/ethernet/mellanox/mlx5/core/
+F:	include/linux/mlx5/
+
+Mellanox MLX5 IB driver
+M:      Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+L:      linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+W:      http://www.mellanox.com
+Q:      http://patchwork.kernel.org/project/linux-rdma/list/
+T:      git://openfabrics.org/~eli/connect-ib.git
+S:      Supported
+F:      include/linux/mlx5/
+F:      drivers/infiniband/hw/mlx5/
+
 MODULE SUPPORT
 M:	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
 S:	Maintained
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index c85b56c..5ceda71 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -50,6 +50,7 @@ source "drivers/infiniband/hw/amso1100/Kconfig"
 source "drivers/infiniband/hw/cxgb3/Kconfig"
 source "drivers/infiniband/hw/cxgb4/Kconfig"
 source "drivers/infiniband/hw/mlx4/Kconfig"
+source "drivers/infiniband/hw/mlx5/Kconfig"
 source "drivers/infiniband/hw/nes/Kconfig"
 source "drivers/infiniband/hw/ocrdma/Kconfig"
 
diff --git a/drivers/infiniband/Makefile b/drivers/infiniband/Makefile
index b126fef..1fe6988 100644
--- a/drivers/infiniband/Makefile
+++ b/drivers/infiniband/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_INFINIBAND_AMSO1100)	+= hw/amso1100/
 obj-$(CONFIG_INFINIBAND_CXGB3)		+= hw/cxgb3/
 obj-$(CONFIG_INFINIBAND_CXGB4)		+= hw/cxgb4/
 obj-$(CONFIG_MLX4_INFINIBAND)		+= hw/mlx4/
+obj-$(CONFIG_MLX5_INFINIBAND)		+= hw/mlx5/
 obj-$(CONFIG_INFINIBAND_NES)		+= hw/nes/
 obj-$(CONFIG_INFINIBAND_OCRDMA)		+= hw/ocrdma/
 obj-$(CONFIG_INFINIBAND_IPOIB)		+= ulp/ipoib/
diff --git a/drivers/infiniband/hw/mlx5/Kconfig b/drivers/infiniband/hw/mlx5/Kconfig
new file mode 100644
index 0000000..8e6aebf
--- /dev/null
+++ b/drivers/infiniband/hw/mlx5/Kconfig
@@ -0,0 +1,10 @@
+config MLX5_INFINIBAND
+	tristate "Mellanox Connect-IB HCA support"
+	depends on NETDEVICES && ETHERNET && PCI && X86
+	select NET_VENDOR_MELLANOX
+	select MLX5_CORE
+	---help---
+	  This driver provides low-level InfiniBand support for
+	  Mellanox Connect-IB PCI Express host channel adapters (HCAs).
+	  This is required to use InfiniBand protocols such as
+	  IP-over-IB or SRP with these devices.
diff --git a/drivers/infiniband/hw/mlx5/Makefile b/drivers/infiniband/hw/mlx5/Makefile
new file mode 100644
index 0000000..0f492da
--- /dev/null
+++ b/drivers/infiniband/hw/mlx5/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_MLX5_INFINIBAND)	+= mlx5_ib.o
+ccflags-y += -Wall -Werror -DDEBUG
+
+mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o
diff --git a/drivers/net/ethernet/mellanox/Kconfig b/drivers/net/ethernet/mellanox/Kconfig
index bcdbc14..8cf7563 100644
--- a/drivers/net/ethernet/mellanox/Kconfig
+++ b/drivers/net/ethernet/mellanox/Kconfig
@@ -19,5 +19,6 @@ config NET_VENDOR_MELLANOX
 if NET_VENDOR_MELLANOX
 
 source "drivers/net/ethernet/mellanox/mlx4/Kconfig"
+source "drivers/net/ethernet/mellanox/mlx5/core/Kconfig"
 
 endif # NET_VENDOR_MELLANOX
diff --git a/drivers/net/ethernet/mellanox/Makefile b/drivers/net/ethernet/mellanox/Makefile
index 37afb96..38fe32ef 100644
--- a/drivers/net/ethernet/mellanox/Makefile
+++ b/drivers/net/ethernet/mellanox/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_MLX4_CORE) += mlx4/
+obj-$(CONFIG_MLX5_CORE) += mlx5/core/
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
new file mode 100644
index 0000000..2196282
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -0,0 +1,18 @@
+#
+# Mellanox driver configuration
+#
+
+config MLX5_CORE
+	tristate
+	depends on PCI && X86
+	default n
+
+config MLX5_DEBUG
+	bool "Verbose debugging output" if (MLX5_CORE && EXPERT)
+	depends on MLX5_CORE
+	default y
+	---help---
+	  This option causes debugging code to be compiled into the
+	  mlx5_core driver.  The output can be turned on via the
+	  debug_mask module parameter (which can also be set after
+	  the driver is loaded through sysfs).
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
new file mode 100644
index 0000000..7687819
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -0,0 +1,6 @@
+obj-$(CONFIG_MLX5_CORE)		+= mlx5_core.o
+ccflags-y += -Wall -Werror -DDEBUG
+
+mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
+		health.o mcg.o cq.o srq.o alloc.o qp.o port.o mr.o pd.o   \
+		mad.o
-- 
1.8.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
