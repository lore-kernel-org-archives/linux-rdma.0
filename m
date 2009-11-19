From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 53/53] IB/qib: Hooks for adding the QIB driver into the
	framework
Date: Thu, 19 Nov 2009 15:41:35 -0800
Message-ID: <20091119234135.30356.84829.stgit@chromite.mv.qlogic.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091119233655.30356.57433.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/Kconfig  |    1 +
 drivers/infiniband/Makefile |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index dd0db67..c80f973 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -42,6 +42,7 @@ config INFINIBAND_ADDR_TRANS
 
 source "drivers/infiniband/hw/mthca/Kconfig"
 source "drivers/infiniband/hw/ipath/Kconfig"
+source "drivers/infiniband/hw/qib/Kconfig"
 source "drivers/infiniband/hw/ehca/Kconfig"
 source "drivers/infiniband/hw/amso1100/Kconfig"
 source "drivers/infiniband/hw/cxgb3/Kconfig"
diff --git a/drivers/infiniband/Makefile b/drivers/infiniband/Makefile
index ed35e44..27b66b1 100644
--- a/drivers/infiniband/Makefile
+++ b/drivers/infiniband/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_INFINIBAND)		+= core/
 obj-$(CONFIG_INFINIBAND_MTHCA)		+= hw/mthca/
 obj-$(CONFIG_INFINIBAND_IPATH)		+= hw/ipath/
+obj-$(CONFIG_INFINIBAND_QIB)		+= hw/qib/
 obj-$(CONFIG_INFINIBAND_EHCA)		+= hw/ehca/
 obj-$(CONFIG_INFINIBAND_AMSO1100)	+= hw/amso1100/
 obj-$(CONFIG_INFINIBAND_CXGB3)		+= hw/cxgb3/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
