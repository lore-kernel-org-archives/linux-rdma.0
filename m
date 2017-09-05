From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] IB: Move PCI dependency from root KConfig to HW's KConfigs
Date: Tue,  5 Sep 2017 17:46:25 +0300
Message-ID: <20170905144625.11768-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

No reason to have dependency on PCI for the entire infiniband stack so
move it to KConfig of only the drivers that actually using PCI.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
v0 -> v1:
	* As suggested by Thomas Bogendoerfer:
		* Remove unneeded header inclusion from ipoib
		* Remove PCI dependency from ipoib's Kconfig
v1 -> v2:
	* s/PCI || BROKEN/PCI
	* Fix also drivers/staging/lustre/lnet/Kconfig
---
 drivers/infiniband/Kconfig                | 1 -
 drivers/infiniband/hw/cxgb3/Kconfig       | 1 +
 drivers/infiniband/hw/cxgb4/Kconfig       | 1 +
 drivers/infiniband/hw/hfi1/Kconfig        | 1 +
 drivers/infiniband/hw/i40iw/Kconfig       | 1 +
 drivers/infiniband/hw/qedr/Kconfig        | 1 +
 drivers/infiniband/hw/qib/Kconfig         | 1 +
 drivers/infiniband/sw/rdmavt/Kconfig      | 1 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 -
 drivers/staging/lustre/lnet/Kconfig       | 2 +-
 10 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 234fe01904e7..568088a9298c 100644
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
index 2b6352b85485..97046365f1c7 100644
--- a/drivers/infiniband/hw/cxgb3/Kconfig
+++ b/drivers/infiniband/hw/cxgb3/Kconfig
@@ -1,5 +1,6 @@
 config INFINIBAND_CXGB3
 	tristate "Chelsio RDMA Driver"
+	depends on PCI
 	depends on CHELSIO_T3 && INET
 	select GENERIC_ALLOCATOR
 	---help---
diff --git a/drivers/infiniband/hw/cxgb4/Kconfig b/drivers/infiniband/hw/cxgb4/Kconfig
index afe8b28e0878..b771575b38c2 100644
--- a/drivers/infiniband/hw/cxgb4/Kconfig
+++ b/drivers/infiniband/hw/cxgb4/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_CXGB4
 	tristate "Chelsio T4/T5 RDMA Driver"
 	depends on CHELSIO_T4 && INET && (IPV6 || IPV6=n)
+	depends on PCI
 	select CHELSIO_LIB
 	select GENERIC_ALLOCATOR
 	---help---
diff --git a/drivers/infiniband/hw/hfi1/Kconfig b/drivers/infiniband/hw/hfi1/Kconfig
index f6ea0881765a..4f8fbffae36f 100644
--- a/drivers/infiniband/hw/hfi1/Kconfig
+++ b/drivers/infiniband/hw/hfi1/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_HFI1
 	tristate "Intel OPA Gen1 support"
 	depends on X86_64 && INFINIBAND_RDMAVT && I2C
+	depends on PCI
 	select MMU_NOTIFIER
 	select CRC32
 	select I2C_ALGOBIT
diff --git a/drivers/infiniband/hw/i40iw/Kconfig b/drivers/infiniband/hw/i40iw/Kconfig
index 6e7d27a14061..f6d20ba88c03 100644
--- a/drivers/infiniband/hw/i40iw/Kconfig
+++ b/drivers/infiniband/hw/i40iw/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_I40IW
 	tristate "Intel(R) Ethernet X722 iWARP Driver"
 	depends on INET && I40E
+	depends on PCI
 	select GENERIC_ALLOCATOR
 	---help---
 	Intel(R) Ethernet X722 iWARP Driver
diff --git a/drivers/infiniband/hw/qedr/Kconfig b/drivers/infiniband/hw/qedr/Kconfig
index 6c9f3923e838..3feec8dddf41 100644
--- a/drivers/infiniband/hw/qedr/Kconfig
+++ b/drivers/infiniband/hw/qedr/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_QEDR
 	tristate "QLogic RoCE driver"
 	depends on 64BIT && QEDE
+	depends on PCI
 	select QED_LL2
 	select QED_RDMA
 	---help---
diff --git a/drivers/infiniband/hw/qib/Kconfig b/drivers/infiniband/hw/qib/Kconfig
index e0fdb9201423..cb06314a2ae2 100644
--- a/drivers/infiniband/hw/qib/Kconfig
+++ b/drivers/infiniband/hw/qib/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_QIB
 	tristate "Intel PCIe HCA support"
 	depends on 64BIT && INFINIBAND_RDMAVT
+	depends on PCI
 	---help---
 	This is a low-level driver for Intel PCIe QLE InfiniBand host
 	channel adapters.  This driver does not support the Intel
diff --git a/drivers/infiniband/sw/rdmavt/Kconfig b/drivers/infiniband/sw/rdmavt/Kconfig
index fdd001ce13d8..2b5513da7e83 100644
--- a/drivers/infiniband/sw/rdmavt/Kconfig
+++ b/drivers/infiniband/sw/rdmavt/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_RDMAVT
 	tristate "RDMA verbs transport library"
 	depends on 64BIT
+	depends on PCI
 	select DMA_VIRT_OPS
 	---help---
 	This is a common software verbs provider for RDMA networks.
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 6c77df34869d..3fc3b7b20297 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -51,7 +51,6 @@
 #include <net/addrconf.h>
 #include <linux/inetdevice.h>
 #include <rdma/ib_cache.h>
-#include <linux/pci.h>
 
 #define DRV_VERSION "1.0.0"
 
diff --git a/drivers/staging/lustre/lnet/Kconfig b/drivers/staging/lustre/lnet/Kconfig
index 2b5930150cda..6bcb53d0c6f4 100644
--- a/drivers/staging/lustre/lnet/Kconfig
+++ b/drivers/staging/lustre/lnet/Kconfig
@@ -34,7 +34,7 @@ config LNET_SELFTEST
 
 config LNET_XPRT_IB
 	tristate "LNET infiniband support"
-	depends on LNET && INFINIBAND && INFINIBAND_ADDR_TRANS
+	depends on LNET && PCI && INFINIBAND && INFINIBAND_ADDR_TRANS
 	default LNET && INFINIBAND
 	help
 	  This option allows the LNET users to use infiniband as an
-- 
2.13.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
