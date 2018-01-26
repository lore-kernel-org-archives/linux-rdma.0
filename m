From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/rxe: Change RDMA_RXE kconfig to use select
Date: Fri, 26 Jan 2018 14:18:33 -0700
Message-ID: <20180126211833.GA26670@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

NET_UDP_TUNNEL is not user selectable, so it should be used as a select
in kconfig.

CRYPTO_CRC32 is a required library for RDMA_RXE so it should active
automatically, as most other CRYPTO_ users do.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Make configuring work better

diff --git a/drivers/infiniband/sw/rxe/Kconfig b/drivers/infiniband/sw/rxe/Kconfig
index 320bffc980d87d..bad4a576d7cf13 100644
--- a/drivers/infiniband/sw/rxe/Kconfig
+++ b/drivers/infiniband/sw/rxe/Kconfig
@@ -1,8 +1,8 @@
 config RDMA_RXE
 	tristate "Software RDMA over Ethernet (RoCE) driver"
 	depends on INET && PCI && INFINIBAND
-	depends on NET_UDP_TUNNEL
-	depends on CRYPTO_CRC32
+	select NET_UDP_TUNNEL
+	select CRYPTO_CRC32
 	select DMA_VIRT_OPS
 	---help---
 	This driver implements the InfiniBand RDMA transport over
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
