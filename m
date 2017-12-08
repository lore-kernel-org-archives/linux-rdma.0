From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 net-next 4/8] net: hns3: Add HNS3 VF driver to kernel build framework
Date: Fri, 8 Dec 2017 21:16:58 +0000
Message-ID: <20171208211702.20104-5-salil.mehta@huawei.com>
References: <20171208211702.20104-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171208211702.20104-1-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch introduces the new Makefiles and updates existing
Makefiles required to build the HNS3 Virtual Function driver.
This also updates the Kconfig for introduction of new menuconfig
entries related to VF driver.

Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: lipeng <lipeng321-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/net/ethernet/hisilicon/Kconfig             | 28 +++++++++++++++-------
 drivers/net/ethernet/hisilicon/hns3/Makefile       |  1 +
 .../net/ethernet/hisilicon/hns3/hns3vf/Makefile    |  8 +++++++
 3 files changed, 28 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile

diff --git a/drivers/net/ethernet/hisilicon/Kconfig b/drivers/net/ethernet/hisilicon/Kconfig
index 30000b6..8bcf470 100644
--- a/drivers/net/ethernet/hisilicon/Kconfig
+++ b/drivers/net/ethernet/hisilicon/Kconfig
@@ -94,15 +94,6 @@ config HNS3_HCLGE
 	  compatibility layer. The engine would be used in Hisilicon hip08 family of
 	  SoCs and further upcoming SoCs.
 
-config HNS3_ENET
-	tristate "Hisilicon HNS3 Ethernet Device Support"
-	depends on 64BIT && PCI
-	depends on HNS3 && HNS3_HCLGE
-	---help---
-	  This selects the Ethernet Driver for Hisilicon Network Subsystem 3 for hip08
-	  family of SoCs. This module depends upon HNAE3 driver to access the HNAE3
-	  devices and their associated operations.
-
 config HNS3_DCB
 	bool "Hisilicon HNS3 Data Center Bridge Support"
 	default n
@@ -112,4 +103,23 @@ config HNS3_DCB
 
 	  If unsure, say N.
 
+config HNS3_HCLGEVF
+    tristate "Hisilicon HNS3VF Acceleration Engine & Compatibility Layer Support"
+    depends on PCI_MSI
+    depends on HNS3
+	depends on HNS3_HCLGE
+    ---help---
+	  This selects the HNS3 VF drivers network acceleration engine & its hardware
+	  compatibility layer. The engine would be used in Hisilicon hip08 family of
+	  SoCs and further upcoming SoCs.
+
+config HNS3_ENET
+	tristate "Hisilicon HNS3 Ethernet Device Support"
+	depends on 64BIT && PCI
+	depends on HNS3
+	---help---
+	  This selects the Ethernet Driver for Hisilicon Network Subsystem 3 for hip08
+	  family of SoCs. This module depends upon HNAE3 driver to access the HNAE3
+	  devices and their associated operations.
+
 endif # NET_VENDOR_HISILICON
diff --git a/drivers/net/ethernet/hisilicon/hns3/Makefile b/drivers/net/ethernet/hisilicon/hns3/Makefile
index a9349e1..244664b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/Makefile
@@ -3,5 +3,6 @@
 #
 
 obj-$(CONFIG_HNS3) += hns3pf/
+obj-$(CONFIG_HNS3) += hns3vf/
 
 obj-$(CONFIG_HNS3) += hnae3.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile b/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile
new file mode 100644
index 0000000..a513d00
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for the HISILICON network device drivers.
+#
+
+ccflags-y := -Idrivers/net/ethernet/hisilicon/hns3
+
+obj-$(CONFIG_HNS3_HCLGEVF) += hclgevf.o
+hclgevf-objs = hclgevf_main.o hclgevf_cmd.o hclgevf_mbx.o
\ No newline at end of file
-- 
2.7.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
