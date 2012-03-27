From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 9/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Tue, 27 Mar 2012 07:50:14 +0530
Message-ID: <28c69b23-cffe-4969-95f5-1d5affb64009@exht1.ad.emulex.com>
References: <1332814814-7643-1-git-send-email-parav.pandit@emulex.com>
 <1332814814-7643-2-git-send-email-parav.pandit@emulex.com>
 <1332814814-7643-3-git-send-email-parav.pandit@emulex.com>
 <1332814814-7643-4-git-send-email-parav.pandit@emulex.com>
 <1332814814-7643-5-git-send-email-parav.pandit@emulex.com>
 <1332814814-7643-6-git-send-email-parav.pandit@emulex.com>
 <1332814814-7643-7-git-send-email-parav.pandit@emulex.com>
 <1332814814-7643-8-git-send-email-parav.pandit@emulex.com>
 <1332814814-7643-9-git-send-email-parav.pandit@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332814814-7643-9-git-send-email-parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

- top level build files to build ocrdma driver.

Signed-off-by: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/Kconfig  |    1 +
 drivers/infiniband/Makefile |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index eb0add3..a0f29c1 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -51,6 +51,7 @@ source "drivers/infiniband/hw/cxgb3/Kconfig"
 source "drivers/infiniband/hw/cxgb4/Kconfig"
 source "drivers/infiniband/hw/mlx4/Kconfig"
 source "drivers/infiniband/hw/nes/Kconfig"
+source "drivers/infiniband/hw/ocrdma/Kconfig"
 
 source "drivers/infiniband/ulp/ipoib/Kconfig"
 
diff --git a/drivers/infiniband/Makefile b/drivers/infiniband/Makefile
index a3b2d8e..bf846a1 100644
--- a/drivers/infiniband/Makefile
+++ b/drivers/infiniband/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_INFINIBAND_CXGB3)		+= hw/cxgb3/
 obj-$(CONFIG_INFINIBAND_CXGB4)		+= hw/cxgb4/
 obj-$(CONFIG_MLX4_INFINIBAND)		+= hw/mlx4/
 obj-$(CONFIG_INFINIBAND_NES)		+= hw/nes/
+obj-$(CONFIG_INFINIBAND_OCRDMA)		+= hw/ocrdma/
 obj-$(CONFIG_INFINIBAND_IPOIB)		+= ulp/ipoib/
 obj-$(CONFIG_INFINIBAND_SRP)		+= ulp/srp/
 obj-$(CONFIG_INFINIBAND_SRPT)		+= ulp/srpt/
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
