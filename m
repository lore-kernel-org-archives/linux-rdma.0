From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2 4/4] IB/usnic: Cisco VIC - driver part 3/3
Date: Tue, 10 Sep 2013 03:39:35 +0000
Message-ID: <47A33601BBFF7E4B8F0D5D0C96F3022C013CF3AE@xmb-rcd-x09.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <59DFF029E1C6CF4CB134CA7E376DF847-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 MAINTAINERS                          |  5 +++++
 drivers/infiniband/Kconfig           |  1 +
 drivers/infiniband/Makefile          |  1 +
 drivers/infiniband/hw/usnic/Kconfig  | 11 +++++++++++
 drivers/infiniband/hw/usnic/Makefile | 15 +++++++++++++++
 5 files changed, 33 insertions(+)
 create mode 100644 drivers/infiniband/hw/usnic/Kconfig
 create mode 100644 drivers/infiniband/hw/usnic/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index defc053..ff41f0d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2077,6 +2077,11 @@ M:	Nishank Trivedi <nistrive-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
 S:	Supported
 F:	drivers/net/ethernet/cisco/enic/

+CISCO VIC LOW LATENCY NIC DRIVER
+M:      Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
+S:      Supported
+F:      drivers/infiniband/hw/usnic
+
 CIRRUS LOGIC EP93XX ETHERNET DRIVER
 M:	Hartley Sweeten <hsweeten-3FF4nKcrg1dE2c76skzGb0EOCMrvLtNR@public.gmane.org>
 L:	netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 5ceda71..10219ee9 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -53,6 +53,7 @@ source "drivers/infiniband/hw/mlx4/Kconfig"
 source "drivers/infiniband/hw/mlx5/Kconfig"
 source "drivers/infiniband/hw/nes/Kconfig"
 source "drivers/infiniband/hw/ocrdma/Kconfig"
+source "drivers/infiniband/hw/usnic/Kconfig"

 source "drivers/infiniband/ulp/ipoib/Kconfig"

diff --git a/drivers/infiniband/Makefile b/drivers/infiniband/Makefile
index 1fe6988..bf508b5 100644
--- a/drivers/infiniband/Makefile
+++ b/drivers/infiniband/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_MLX4_INFINIBAND)		+= hw/mlx4/
 obj-$(CONFIG_MLX5_INFINIBAND)		+= hw/mlx5/
 obj-$(CONFIG_INFINIBAND_NES)		+= hw/nes/
 obj-$(CONFIG_INFINIBAND_OCRDMA)		+= hw/ocrdma/
+obj-$(CONFIG_INFINIBAND_USNIC)		+= hw/usnic/
 obj-$(CONFIG_INFINIBAND_IPOIB)		+= ulp/ipoib/
 obj-$(CONFIG_INFINIBAND_SRP)		+= ulp/srp/
 obj-$(CONFIG_INFINIBAND_SRPT)		+= ulp/srpt/
diff --git a/drivers/infiniband/hw/usnic/Kconfig b/drivers/infiniband/hw/usnic/Kconfig
new file mode 100644
index 0000000..0f14b6d
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/Kconfig
@@ -0,0 +1,11 @@
+config INFINIBAND_USNIC
+	tristate "Verbs support for Cisco VIC"
+	depends on NETDEVICES && ETHERNET && PCI
+	select ENIC
+	select NET_VENDOR_CISCO
+	select PCI_IOV
+	select IOMMU_SUPPORT
+	select INFINIBAND_USER_ACCESS
+	---help---
+	  This is a low-level driver for Cisco's Virtual Interface
+	  Cards (VICs), including the VIC 1240 and 1280 cards.
diff --git a/drivers/infiniband/hw/usnic/Makefile b/drivers/infiniband/hw/usnic/Makefile
new file mode 100644
index 0000000..99fb2db
--- /dev/null
+++ b/drivers/infiniband/hw/usnic/Makefile
@@ -0,0 +1,15 @@
+ccflags-y := -Idrivers/net/ethernet/cisco/enic
+
+obj-$(CONFIG_INFINIBAND_USNIC)+= usnic_verbs.o
+
+usnic_verbs-y=\
+usnic_fwd.o \
+usnic_transport.o \
+usnic_uiom.o \
+usnic_uiom_interval_tree.o \
+usnic_vnic.o \
+usnic_ib_main.o \
+usnic_ib_qp_grp.o \
+usnic_ib_sysfs.o \
+usnic_ib_verbs.o \
+usnic_debugfs.o \
--
1.8.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
