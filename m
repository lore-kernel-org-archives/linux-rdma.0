From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/{cxgb3,cxgb4}: Remove unneeded config dependencies
Date: Wed,  6 Sep 2017 13:52:01 +0300
Message-ID: <20170906105201.8485-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

CHELSIO_T3 already depend on INET
CHELSIO_T4 already depend on (IPV6 || IPV6=n)

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/Kconfig | 2 +-
 drivers/infiniband/hw/cxgb4/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/Kconfig b/drivers/infiniband/hw/cxgb3/Kconfig
index 2b6352b85485..431be733fbbe 100644
--- a/drivers/infiniband/hw/cxgb3/Kconfig
+++ b/drivers/infiniband/hw/cxgb3/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_CXGB3
 	tristate "Chelsio RDMA Driver"
-	depends on CHELSIO_T3 && INET
+	depends on CHELSIO_T3
 	select GENERIC_ALLOCATOR
 	---help---
 	  This is an iWARP/RDMA driver for the Chelsio T3 1GbE and
diff --git a/drivers/infiniband/hw/cxgb4/Kconfig b/drivers/infiniband/hw/cxgb4/Kconfig
index afe8b28e0878..0a671a61fc92 100644
--- a/drivers/infiniband/hw/cxgb4/Kconfig
+++ b/drivers/infiniband/hw/cxgb4/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_CXGB4
 	tristate "Chelsio T4/T5 RDMA Driver"
-	depends on CHELSIO_T4 && INET && (IPV6 || IPV6=n)
+	depends on CHELSIO_T4 && INET
 	select CHELSIO_LIB
 	select GENERIC_ALLOCATOR
 	---help---
-- 
2.13.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
