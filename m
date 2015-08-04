From: dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] RDMA/ipath: Do not build ipath driver without infiniband subsystem
Date: Tue,  4 Aug 2015 12:17:01 -0400
Message-ID: <1438705021-20337-1-git-send-email-dennis.dalessandro@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Moving the ipath driver to staging now requires a guard on the INFINIBAND
subsytem in order to prevent the driver from being built without infiniband
enabled. This will lead to a broken build.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/ipath/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ipath/Kconfig b/drivers/staging/ipath/Kconfig
index 041ce06..12dcd40 100644
--- a/drivers/staging/ipath/Kconfig
+++ b/drivers/staging/ipath/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_IPATH
 	tristate "QLogic HTX HCA support"
-	depends on 64BIT && NET && HT_IRQ
+	depends on 64BIT && NET && HT_IRQ && INFINIBAND
 	---help---
 	This is a driver for the deprecated QLogic Hyper-Transport
 	IB host channel adapter (model QHT7140),
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
