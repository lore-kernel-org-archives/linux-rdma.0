From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 50/50] IB/core: Add opa driver to kbuild
Date: Thu, 30 Jul 2015 15:22:08 -0400
Message-ID: <20150730192208.25256.22110.stgit@phlsvslse11.ph.intel.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150730191631.25256.95511.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/Kconfig     |    1 +
 drivers/infiniband/hw/Makefile |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index da4c697..f84eecd 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -56,6 +56,7 @@ config INFINIBAND_ADDR_TRANS
 
 source "drivers/infiniband/hw/mthca/Kconfig"
 source "drivers/infiniband/hw/qib/Kconfig"
+source "drivers/infiniband/hw/hfi1/Kconfig"
 source "drivers/infiniband/hw/ehca/Kconfig"
 source "drivers/infiniband/hw/cxgb3/Kconfig"
 source "drivers/infiniband/hw/cxgb4/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index 1bdb999..52f3788 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_INFINIBAND_MTHCA)		+= mthca/
 obj-$(CONFIG_INFINIBAND_QIB)		+= qib/
+obj-$(CONFIG_INFINIBAND_HFI1)		+= hfi1/
 obj-$(CONFIG_INFINIBAND_EHCA)		+= ehca/
 obj-$(CONFIG_INFINIBAND_CXGB3)		+= cxgb3/
 obj-$(CONFIG_INFINIBAND_CXGB4)		+= cxgb4/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
