From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/amso1100: Do not build amso1100 without infiniband
	subsystem
Date: Tue, 04 Aug 2015 13:06:33 -0500
Message-ID: <20150804180632.30555.59059.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Moving the amso1100 driver to staging now requires a guard on the
INFINIBAND subsytem in order to prevent the driver from being built
without infiniband enabled. This will lead to a broken build.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/staging/amso1100/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/amso1100/Kconfig b/drivers/staging/amso1100/Kconfig
index e6ce5f2..809cb14 100644
--- a/drivers/staging/amso1100/Kconfig
+++ b/drivers/staging/amso1100/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_AMSO1100
 	tristate "Ammasso 1100 HCA support"
-	depends on PCI && INET
+	depends on PCI && INET && INFINIBAND
 	---help---
 	  This is a low-level driver for the Ammasso 1100 host
 	  channel adapter (HCA).

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
