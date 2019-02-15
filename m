From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [RFC v1 18/19] RDMA/irdma: Add Kconfig and Makefile
Date: Fri, 15 Feb 2019 11:11:05 -0600
Message-ID: <20190215171107.6464-19-shiraz.saleem@intel.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190215171107.6464-1-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com, Shiraz Saleem <shiraz.saleem@intel.com>
List-Id: linux-rdma@vger.kernel.org

Add Kconfig and Makefile to build irdma driver

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/infiniband/Kconfig           |  1 +
 drivers/infiniband/hw/Makefile       |  1 +
 drivers/infiniband/hw/irdma/Kconfig  | 11 +++++++++++
 drivers/infiniband/hw/irdma/Makefile | 31 +++++++++++++++++++++++++++++++
 4 files changed, 44 insertions(+)
 create mode 100644 drivers/infiniband/hw/irdma/Kconfig
 create mode 100644 drivers/infiniband/hw/irdma/Makefile

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index a1fb840d..a841a07 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -95,6 +95,7 @@ source "drivers/infiniband/hw/qib/Kconfig"
 source "drivers/infiniband/hw/cxgb3/Kconfig"
 source "drivers/infiniband/hw/cxgb4/Kconfig"
 source "drivers/infiniband/hw/i40iw/Kconfig"
+source "drivers/infiniband/hw/irdma/Kconfig"
 source "drivers/infiniband/hw/mlx4/Kconfig"
 source "drivers/infiniband/hw/mlx5/Kconfig"
 source "drivers/infiniband/hw/nes/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index e4f31c1..bc79ef3 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_INFINIBAND_QIB)		+= qib/
 obj-$(CONFIG_INFINIBAND_CXGB3)		+= cxgb3/
 obj-$(CONFIG_INFINIBAND_CXGB4)		+= cxgb4/
 obj-$(CONFIG_INFINIBAND_I40IW)		+= i40iw/
+obj-$(CONFIG_INFINIBAND_IRDMA)		+= irdma/
 obj-$(CONFIG_MLX4_INFINIBAND)		+= mlx4/
 obj-$(CONFIG_MLX5_INFINIBAND)		+= mlx5/
 obj-$(CONFIG_INFINIBAND_NES)		+= nes/
diff --git a/drivers/infiniband/hw/irdma/Kconfig b/drivers/infiniband/hw/irdma/Kconfig
new file mode 100644
index 0000000..652f5f9
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/Kconfig
@@ -0,0 +1,11 @@
+config INFINIBAND_IRDMA
+       tristate "Intel(R) Ethernet Connection RDMA Driver"
+       depends on INET && (I40E || ICE)
+       depends on IPV6 || !IPV6
+       depends on PCI
+       select GENERIC_ALLOCATOR
+       ---help---
+       This is an Ethernet RDMA driver that supports E810 (iWARP/RoCE)
+       and X722 (iWARP) network devices.
+       To compile this driver as a module, choose M here. The module
+       will be called irdma.
diff --git a/drivers/infiniband/hw/irdma/Makefile b/drivers/infiniband/hw/irdma/Makefile
new file mode 100644
index 0000000..cfc8126
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/Makefile
@@ -0,0 +1,31 @@
+# SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+# Copyright (c) 2019, Intel Corporation.
+
+#
+# Makefile for the Intel(R) Ethernet Connection RDMA Linux Driver
+#
+
+ccflags-y := -I $(srctree)/drivers/net/ethernet/intel/i40e
+ccflags-y += -I $(srctree)/drivers/net/ethernet/intel/ice
+
+obj-$(CONFIG_INFINIBAND_IRDMA) += irdma.o
+
+irdma-objs := main.o      \
+             i40iw_if.o  \
+             i40iw_hw.o  \
+             irdma_if.o  \
+             hw.o        \
+             icrdma_hw.o \
+             cm.o        \
+             ctrl.o      \
+             hmc.o       \
+             pble.o      \
+             puda.o      \
+             uk.o        \
+             utils.o     \
+             verbs.o     \
+             uda.o       \
+             ws.o        \
+             trace.o     \
+
+CFLAGS_trace.o = -I$(src)
-- 
1.8.3.1
