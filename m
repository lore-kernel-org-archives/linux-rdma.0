From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/hfi1: Add Infiniband dependency to Kconfig
Date: Tue, 04 Aug 2015 12:16:52 -0400
Message-ID: <20150804161652.24483.80145.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The hfi1 driver depends on the infiniband core stack.
Building a kernel without the infiniband core but with the
hfi1 driver causes undefined reference errors to the ib_* functions.

Reported by 0-day build:
https://lists.01.org/pipermail/kbuild-all/2015-August/011216.html

This is a temporary patch and is only needed while the hfi1 driver is
in staging. Remove when moving driver back to drivers/infiniband.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/hfi1/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/hfi1/Kconfig b/drivers/staging/hfi1/Kconfig
index 87a385a..78bc89e 100644
--- a/drivers/staging/hfi1/Kconfig
+++ b/drivers/staging/hfi1/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_HFI1
 	tristate "Intel OPA Gen1 support"
-	depends on X86_64
+	depends on X86_64 && INFINIBAND
 	default m
 	---help---
 	This is a low-level driver for Intel OPA Gen1 adapter.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
