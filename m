From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Kconfig: add temporary PCI dependency
Date: Tue, 18 Aug 2015 10:15:42 -0400
Message-ID: <20150818141542.4127.90517.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The move from infiniband to staging requires a temporary
PCI dependency to fix 0-day build issues.  The
drivers/infiniband/hw/Kconfig gratuitously added it for all drivers.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/hfi1/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/hfi1/Kconfig b/drivers/staging/hfi1/Kconfig
index 78bc89e..8a079ba 100644
--- a/drivers/staging/hfi1/Kconfig
+++ b/drivers/staging/hfi1/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_HFI1
 	tristate "Intel OPA Gen1 support"
-	depends on X86_64 && INFINIBAND
+	depends on X86_64 && INFINIBAND && PCI
 	default m
 	---help---
 	This is a low-level driver for Intel OPA Gen1 adapter.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
