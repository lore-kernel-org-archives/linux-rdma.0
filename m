From: <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 8/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Wed, 21 Mar 2012 04:09:13 +0530
Message-ID: <3ccb272a-6692-4e1d-952e-2de5bca6ebe9@exht1.ad.emulex.com>
References: <1332283154-16369-1-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-2-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-3-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-4-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-5-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-6-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-7-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-8-git-send-email-parav.pandit@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332283154-16369-8-git-send-email-parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

- build files for building ocrdma driver

Signed-off-by: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/Kconfig  |    8 ++++++++
 drivers/infiniband/hw/ocrdma/Makefile |    5 +++++
 2 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/ocrdma/Kconfig
 create mode 100644 drivers/infiniband/hw/ocrdma/Makefile

diff --git a/drivers/infiniband/hw/ocrdma/Kconfig b/drivers/infiniband/hw/ocrdma/Kconfig
new file mode 100644
index 0000000..cf99342
--- /dev/null
+++ b/drivers/infiniband/hw/ocrdma/Kconfig
@@ -0,0 +1,8 @@
+config INFINIBAND_OCRDMA
+	tristate "Emulex One Connect HCA support"
+	depends on ETHERNET && NETDEVICES && PCI
+	select NET_VENDOR_EMULEX
+	select BE2NET
+	---help---
+	  This driver provides low-level InfiniBand over Ethernet
+	  support for Emulex One Connect host channel adapters (HCAs).
diff --git a/drivers/infiniband/hw/ocrdma/Makefile b/drivers/infiniband/hw/ocrdma/Makefile
new file mode 100644
index 0000000..06a5bed
--- /dev/null
+++ b/drivers/infiniband/hw/ocrdma/Makefile
@@ -0,0 +1,5 @@
+ccflags-y := -Idrivers/net/ethernet/emulex/benet
+
+obj-$(CONFIG_INFINIBAND_OCRDMA)	+= ocrdma.o
+
+ocrdma-y :=	ocrdma_main.o ocrdma_verbs.o ocrdma_hw.o ocrdma_ah.o
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
