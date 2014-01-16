From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next] IB/core: Add a dependency of ib_core in ib_addr
Date: Thu, 16 Jan 2014 17:16:47 +0200
Message-ID: <1389885408-21897-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

IP based addressing introduces the usage of
rdma_addr_find_dmac_by_grh within ib_core.
Since this function is declared in ib_addr, ib_addr
should be a part of the INFINIBAND modules, rather than
INFINIBAND_ADDR_TRANS.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Hi Roland,

This patch adds ib_addr and its dependencies to the INFINIBAND module.
Since ib_core uses ib_addr to resolve the MAC address, this introduces
a direct dependency of INFINIBAND in INET.

Regards,
Matan

 drivers/infiniband/Kconfig       |    5 +++--
 drivers/infiniband/core/Makefile |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 10219ee..7708939 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -3,6 +3,8 @@ menuconfig INFINIBAND
 	depends on PCI || BROKEN
 	depends on HAS_IOMEM
 	depends on NET
+	depends on INET
+	depends on m || IPV6 != m
 	---help---
 	  Core support for InfiniBand (IB).  Make sure to also select
 	  any protocols you wish to use as well as drivers for your
@@ -38,8 +40,7 @@ config INFINIBAND_USER_MEM
 
 config INFINIBAND_ADDR_TRANS
 	bool
-	depends on INET
-	depends on !(INFINIBAND = y && IPV6 = m)
+	depends on INFINIBAND
 	default y
 
 source "drivers/infiniband/hw/mthca/Kconfig"
diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index c8bbaef..3ab3865 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -1,8 +1,9 @@
-infiniband-$(CONFIG_INFINIBAND_ADDR_TRANS)	:= ib_addr.o rdma_cm.o
+infiniband-$(CONFIG_INFINIBAND_ADDR_TRANS)	:= rdma_cm.o
 user_access-$(CONFIG_INFINIBAND_ADDR_TRANS)	:= rdma_ucm.o
 
 obj-$(CONFIG_INFINIBAND) +=		ib_core.o ib_mad.o ib_sa.o \
-					ib_cm.o iw_cm.o $(infiniband-y)
+					ib_cm.o iw_cm.o ib_addr.o \
+					$(infiniband-y)
 obj-$(CONFIG_INFINIBAND_USER_MAD) +=	ib_umad.o
 obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 					$(user_access-y)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
