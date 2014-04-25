From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] iw_cxgb4: Update Kconfig to include Chelsio T5 adapter.
Date: Sat, 26 Apr 2014 00:51:18 +0530
Message-ID: <1398453678-13108-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, dm-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/Kconfig b/drivers/infiniband/hw/cxgb4/Kconfig
index d4e8983..23f38cf 100644
--- a/drivers/infiniband/hw/cxgb4/Kconfig
+++ b/drivers/infiniband/hw/cxgb4/Kconfig
@@ -1,10 +1,10 @@
 config INFINIBAND_CXGB4
-	tristate "Chelsio T4 RDMA Driver"
+	tristate "Chelsio T4/T5 RDMA Driver"
 	depends on CHELSIO_T4 && INET && (IPV6 || IPV6=n)
 	select GENERIC_ALLOCATOR
 	---help---
-	  This is an iWARP/RDMA driver for the Chelsio T4 1GbE and
-	  10GbE adapters.
+	  This is an iWARP/RDMA driver for the Chelsio T4 and T5
+	  1GbE, 10GbE adapters and T5 40GbE adapter.
 
 	  For general information about Chelsio and our products, visit
 	  our website at <http://www.chelsio.com>.
-- 
1.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
