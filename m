From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v3 01/10] iw_cxgb4: Makefile and Kconfig files and changes.
Date: Fri, 16 Apr 2010 13:29:30 -0500
Message-ID: <20100416182930.22495.976.stgit@build.ogc.int>
References: <20100416182924.22495.59421.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100416182924.22495.59421.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/Kconfig           |    1 +
 drivers/infiniband/Makefile          |    1 +
 drivers/infiniband/hw/cxgb4/Kconfig  |   19 +++++++++++++++++++
 drivers/infiniband/hw/cxgb4/Makefile |    5 +++++
 4 files changed, 26 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/cxgb4/Kconfig
 create mode 100644 drivers/infiniband/hw/cxgb4/Makefile

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 975adce..330d2a4 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -46,6 +46,7 @@ source "drivers/infiniband/hw/ipath/Kconfig"
 source "drivers/infiniband/hw/ehca/Kconfig"
 source "drivers/infiniband/hw/amso1100/Kconfig"
 source "drivers/infiniband/hw/cxgb3/Kconfig"
+source "drivers/infiniband/hw/cxgb4/Kconfig"
 source "drivers/infiniband/hw/mlx4/Kconfig"
 source "drivers/infiniband/hw/nes/Kconfig"
 
diff --git a/drivers/infiniband/Makefile b/drivers/infiniband/Makefile
index ed35e44..0c4e589 100644
--- a/drivers/infiniband/Makefile
+++ b/drivers/infiniband/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_INFINIBAND_IPATH)		+= hw/ipath/
 obj-$(CONFIG_INFINIBAND_EHCA)		+= hw/ehca/
 obj-$(CONFIG_INFINIBAND_AMSO1100)	+= hw/amso1100/
 obj-$(CONFIG_INFINIBAND_CXGB3)		+= hw/cxgb3/
+obj-$(CONFIG_INFINIBAND_CXGB4)		+= hw/cxgb4/
 obj-$(CONFIG_MLX4_INFINIBAND)		+= hw/mlx4/
 obj-$(CONFIG_INFINIBAND_NES)		+= hw/nes/
 obj-$(CONFIG_INFINIBAND_IPOIB)		+= ulp/ipoib/
diff --git a/drivers/infiniband/hw/cxgb4/Kconfig b/drivers/infiniband/hw/cxgb4/Kconfig
new file mode 100644
index 0000000..0f285af
--- /dev/null
+++ b/drivers/infiniband/hw/cxgb4/Kconfig
@@ -0,0 +1,19 @@
+config INFINIBAND_CXGB4
+	tristate "Chelsio T4 RDMA Driver"
+	depends on CHELSIO_T4 && INET
+	select GENERIC_ALLOCATOR
+	---help---
+	  This is an iWARP/RDMA driver for the Chelsio T4 1GbE and
+	  10GbE adapters.
+
+	  For general information about Chelsio and our products, visit
+	  our website at <http://www.chelsio.com>.
+
+	  For customer support, please visit our customer support page at
+	  <http://www.chelsio.com/support.htm>.
+
+	  Please send feedback to <linux-bugs-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called iw_cxgb4.
+
diff --git a/drivers/infiniband/hw/cxgb4/Makefile b/drivers/infiniband/hw/cxgb4/Makefile
new file mode 100644
index 0000000..e31a499
--- /dev/null
+++ b/drivers/infiniband/hw/cxgb4/Makefile
@@ -0,0 +1,5 @@
+EXTRA_CFLAGS += -Idrivers/net/cxgb4
+
+obj-$(CONFIG_INFINIBAND_CXGB4) += iw_cxgb4.o
+
+iw_cxgb4-y :=  device.o cm.o provider.o mem.o cq.o qp.o resource.o ev.o

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
