From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB: Move PCI dependency from root KConfig to HW's KConfigs
Date: Mon, 26 Jun 2017 11:53:13 +0300
Message-ID: <20170626085313.6052-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

No reason to have dependency on PCI for the entire infiniband stack so
move it to KConfig of only the drivers that actually using PCI.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/Kconfig           | 1 -
 drivers/infiniband/hw/cxgb3/Kconfig  | 1 +
 drivers/infiniband/hw/cxgb4/Kconfig  | 1 +
 drivers/infiniband/hw/hfi1/Kconfig   | 1 +
 drivers/infiniband/hw/i40iw/Kconfig  | 1 +
 drivers/infiniband/hw/qedr/Kconfig   | 1 +
 drivers/infiniband/hw/qib/Kconfig    | 1 +
 drivers/infiniband/sw/rdmavt/Kconfig | 1 +
 drivers/infiniband/ulp/ipoib/Kconfig | 1 +
 9 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 234fe01..568088a 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -1,6 +1,5 @@
 menuconfig INFINIBAND
 	tristate "InfiniBand support"
-	depends on PCI || BROKEN
 	depends on HAS_IOMEM
 	depends on NET
 	depends on INET
diff --git a/drivers/infiniband/hw/cxgb3/Kconfig b/drivers/infiniband/hw/cxgb3/Kconfig
index 2b6352b..bd32926 100644
--- a/drivers/infiniband/hw/cxgb3/Kconfig
+++ b/drivers/infiniband/hw/cxgb3/Kconfig
@@ -1,5 +1,6 @@
 config INFINIBAND_CXGB3
 	tristate "Chelsio RDMA Driver"
+	depends on PCI || BROKEN
 	depends on CHELSIO_T3 && INET
 	select GENERIC_ALLOCATOR
 	---help---
diff --git a/drivers/infiniband/hw/cxgb4/Kconfig b/drivers/infiniband/hw/cxgb4/Kconfig
index afe8b28..7910fdd 100644
--- a/drivers/infiniband/hw/cxgb4/Kconfig
+++ b/drivers/infiniband/hw/cxgb4/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_CXGB4
 	tristate "Chelsio T4/T5 RDMA Driver"
 	depends on CHELSIO_T4 && INET && (IPV6 || IPV6=n)
+	depends on PCI || BROKEN
 	select CHELSIO_LIB
 	select GENERIC_ALLOCATOR
 	---help---
diff --git a/drivers/infiniband/hw/hfi1/Kconfig b/drivers/infiniband/hw/hfi1/Kconfig
index f6ea088..5072d08 100644
--- a/drivers/infiniband/hw/hfi1/Kconfig
+++ b/drivers/infiniband/hw/hfi1/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_HFI1
 	tristate "Intel OPA Gen1 support"
 	depends on X86_64 && INFINIBAND_RDMAVT && I2C
+	depends on PCI || BROKEN
 	select MMU_NOTIFIER
 	select CRC32
 	select I2C_ALGOBIT
diff --git a/drivers/infiniband/hw/i40iw/Kconfig b/drivers/infiniband/hw/i40iw/Kconfig
index 6e7d27a..9cfef13 100644
--- a/drivers/infiniband/hw/i40iw/Kconfig
+++ b/drivers/infiniband/hw/i40iw/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_I40IW
 	tristate "Intel(R) Ethernet X722 iWARP Driver"
 	depends on INET && I40E
+	depends on PCI || BROKEN
 	select GENERIC_ALLOCATOR
 	---help---
 	Intel(R) Ethernet X722 iWARP Driver
diff --git a/drivers/infiniband/hw/qedr/Kconfig b/drivers/infiniband/hw/qedr/Kconfig
index 6c9f392..8db2966 100644
--- a/drivers/infiniband/hw/qedr/Kconfig
+++ b/drivers/infiniband/hw/qedr/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_QEDR
 	tristate "QLogic RoCE driver"
 	depends on 64BIT && QEDE
+	depends on PCI || BROKEN
 	select QED_LL2
 	select QED_RDMA
 	---help---
diff --git a/drivers/infiniband/hw/qib/Kconfig b/drivers/infiniband/hw/qib/Kconfig
index e0fdb92..522a6fc 100644
--- a/drivers/infiniband/hw/qib/Kconfig
+++ b/drivers/infiniband/hw/qib/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_QIB
 	tristate "Intel PCIe HCA support"
 	depends on 64BIT && INFINIBAND_RDMAVT
+	depends on PCI || BROKEN
 	---help---
 	This is a low-level driver for Intel PCIe QLE InfiniBand host
 	channel adapters.  This driver does not support the Intel
diff --git a/drivers/infiniband/sw/rdmavt/Kconfig b/drivers/infiniband/sw/rdmavt/Kconfig
index fdd001c..605bfb1 100644
--- a/drivers/infiniband/sw/rdmavt/Kconfig
+++ b/drivers/infiniband/sw/rdmavt/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_RDMAVT
 	tristate "RDMA verbs transport library"
 	depends on 64BIT
+	depends on PCI || BROKEN
 	select DMA_VIRT_OPS
 	---help---
 	This is a common software verbs provider for RDMA networks.
diff --git a/drivers/infiniband/ulp/ipoib/Kconfig b/drivers/infiniband/ulp/ipoib/Kconfig
index cda8eac..5aec880 100644
--- a/drivers/infiniband/ulp/ipoib/Kconfig
+++ b/drivers/infiniband/ulp/ipoib/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_IPOIB
 	tristate "IP-over-InfiniBand"
 	depends on NETDEVICES && INET && (IPV6 || IPV6=n)
+	depends on PCI || BROKEN
 	---help---
 	  Support for the IP-over-InfiniBand protocol (IPoIB). This
 	  transports IP packets over InfiniBand so you can use your IB
-- 
2.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
