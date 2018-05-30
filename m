From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] iw_cxgb4: add INFINIBAND_ADDR_TRANS dependency
Date: Wed, 30 May 2018 23:58:18 +0200
Message-ID: <20180530215826.1343234-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Arnd Bergmann <arnd@arndb.de>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The newly added fill_res_ep_entry function fails to link if
CONFIG_INFINIBAND_ADDR_TRANS is not set:

drivers/infiniband/hw/cxgb4/restrack.o: In function `fill_res_ep_entry':
restrack.c:(.text+0x3cc): undefined reference to `rdma_res_to_id'
restrack.c:(.text+0x3d0): undefined reference to `rdma_iw_cm_id'

This adds a Kconfig dependency for the driver.

Fixes: 116aeb887371 ("iw_cxgb4: provide detailed provider-specific CM_ID information")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/infiniband/hw/cxgb4/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/Kconfig b/drivers/infiniband/hw/cxgb4/Kconfig
index 0a671a61fc92..e0522a5d5a06 100644
--- a/drivers/infiniband/hw/cxgb4/Kconfig
+++ b/drivers/infiniband/hw/cxgb4/Kconfig
@@ -1,6 +1,7 @@
 config INFINIBAND_CXGB4
 	tristate "Chelsio T4/T5 RDMA Driver"
 	depends on CHELSIO_T4 && INET
+	depends on INFINIBAND_ADDR_TRANS
 	select CHELSIO_LIB
 	select GENERIC_ALLOCATOR
 	---help---
-- 
2.9.0
