From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] staging/rdma: Kconfig change STAGING_RDMA to be tristate.
Date: Thu, 24 Sep 2015 14:43:45 -0400
Message-ID: <1443120225-22163-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

STAGING_RDMA was failing to build when INFINIBAND was set to 'm' and
STAGING_RDMA was set to 'y'.

Making this a tristate properly inherits the 'm' from the INFINIBAND setting.

Reviewed-by: Dalessandro, Dennis <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: John, Jubin <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/Kconfig b/drivers/staging/rdma/Kconfig
index d7f6235..ba87650 100644
--- a/drivers/staging/rdma/Kconfig
+++ b/drivers/staging/rdma/Kconfig
@@ -1,5 +1,5 @@
 menuconfig STAGING_RDMA
-        bool "RDMA staging drivers"
+        tristate "RDMA staging drivers"
 	depends on INFINIBAND
 	depends on PCI || BROKEN
 	depends on HAS_IOMEM
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
