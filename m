From: "Enrico Weigelt, metux IT consult" <info@metux.net>
Subject: [PATCH] drivers: infiniband: Kconfig: pedantic cleanups
Date: Wed,  6 Mar 2019 19:49:27 +0100
Message-ID: <1551898167-18310-1-git-send-email-info@metux.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 drivers/infiniband/hw/bnxt_re/Kconfig | 10 +++++-----
 drivers/infiniband/ulp/iser/Kconfig   |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/Kconfig b/drivers/infiniband/hw/bnxt_re/Kconfig
index 19982a4..05aa9fa 100644
--- a/drivers/infiniband/hw/bnxt_re/Kconfig
+++ b/drivers/infiniband/hw/bnxt_re/Kconfig
@@ -1,9 +1,9 @@
 config INFINIBAND_BNXT_RE
-    tristate "Broadcom Netxtreme HCA support"
-    depends on ETHERNET && NETDEVICES && PCI && INET && DCB
-    select NET_VENDOR_BROADCOM
-    select BNXT
-    ---help---
+	tristate "Broadcom Netxtreme HCA support"
+	depends on ETHERNET && NETDEVICES && PCI && INET && DCB
+	select NET_VENDOR_BROADCOM
+	select BNXT
+	---help---
 	  This driver supports Broadcom NetXtreme-E 10/25/40/50 gigabit
 	  RoCE HCAs.  To compile this driver as a module, choose M here:
 	  the module will be called bnxt_re.
diff --git a/drivers/infiniband/ulp/iser/Kconfig b/drivers/infiniband/ulp/iser/Kconfig
index d00af71..299268f 100644
--- a/drivers/infiniband/ulp/iser/Kconfig
+++ b/drivers/infiniband/ulp/iser/Kconfig
@@ -4,8 +4,8 @@ config INFINIBAND_ISER
 	select SCSI_ISCSI_ATTRS
 	---help---
 	  Support for the iSCSI Extensions for RDMA (iSER) Protocol
-          over InfiniBand. This allows you to access storage devices
-          that speak iSCSI over iSER over InfiniBand.
+	  over InfiniBand. This allows you to access storage devices
+	  that speak iSCSI over iSER over InfiniBand.
 
 	  The iSER protocol is defined by IETF.
 	  See <http://www.ietf.org/rfc/rfc5046.txt>
-- 
1.9.1
