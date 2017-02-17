From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] RDMA/bnxt_re: add DCB dependency
Date: Fri, 17 Feb 2017 15:40:21 +0100
Message-ID: <20170217144110.2237820-1-arnd@arndb.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When CONFIG_DCB is disabled, we get a link error:

drivers/infiniband/built-in.o: In function `bnxt_re_setup_qos':
trace.c:(.text+0x155774): undefined reference to `dcb_ieee_getapp_mask'
trace.c:(.text+0x155774): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `dcb_ieee_getapp_mask'
trace.c:(.text+0x155794): undefined reference to `dcb_ieee_getapp_mask'
trace.c:(.text+0x155794): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `dcb_ieee_getapp_mask'

Like the other drivers that use this function, a Kconfig dependency is
the correct fix.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/Kconfig b/drivers/infiniband/hw/bnxt_re/Kconfig
index cd0175e32584..19982a4a9bba 100644
--- a/drivers/infiniband/hw/bnxt_re/Kconfig
+++ b/drivers/infiniband/hw/bnxt_re/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_BNXT_RE
     tristate "Broadcom Netxtreme HCA support"
-    depends on ETHERNET && NETDEVICES && PCI && INET
+    depends on ETHERNET && NETDEVICES && PCI && INET && DCB
     select NET_VENDOR_BROADCOM
     select BNXT
     ---help---
-- 
2.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
