From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/hns: Avoid compile test under non 64bit environments
Date: Tue, 25 Jul 2017 17:29:06 +0300
Message-ID: <1500992946-77766-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The hns driver uses __raw_writeq which is only defined in 64BIT
environments. Trying to compile the driver in a 32BIT environment
results in errors. Only COMPILE_TEST when 64BIT is defined.

Fixes: 7d1b6a678e0b ("IB/hns: Support compile test for hns RoCE driver")
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Hi Lijun and Wei,

This is a small fix for the compile test patch I posted. The original
patch added the support to compile the hns RoCE driver in
architectures other than ARM64 to ease development. However,
__raw_writeq is used in your driver and it's only available in 64bit
environments. Therefore, I've added the required condition in the
Kconfig. Please note that compiling the code over 64bit architectures
that declare 64BIT but don't declare ARCH_DMA_ADDR_T_64BIT produces
compilation warnings. I'm not aware of such architectures though.

Regards,
Matan

 drivers/infiniband/hw/hns/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/Kconfig b/drivers/infiniband/hw/hns/Kconfig
index cbe6b51..61c93bb 100644
--- a/drivers/infiniband/hw/hns/Kconfig
+++ b/drivers/infiniband/hw/hns/Kconfig
@@ -1,7 +1,7 @@
 config INFINIBAND_HNS
 	tristate "HNS RoCE Driver"
 	depends on NET_VENDOR_HISILICON
-	depends on (ARM64 || COMPILE_TEST) && HNS && HNS_DSAF && HNS_ENET
+	depends on (ARM64 || (COMPILE_TEST && 64BIT)) && HNS && HNS_DSAF && HNS_ENET
 	---help---
 	  This is a RoCE/RDMA driver for the Hisilicon RoCE engine. The engine
 	  is used in Hisilicon Hi1610 and more further ICT SoC.
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
