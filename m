From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 49/49] IB/core: Add opa driver to kbuild
Date: Mon, 15 Jun 2015 09:30:23 -0400
Message-ID: <20150615133023.29741.84079.stgit@phlsvslse11.ph.intel.com>
References: <20150615132434.29741.35258.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150615132434.29741.35258.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
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
index b899531..dd24c3d 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -57,6 +57,7 @@ config INFINIBAND_ADDR_TRANS
 source "drivers/infiniband/hw/mthca/Kconfig"
 source "drivers/infiniband/hw/ipath/Kconfig"
 source "drivers/infiniband/hw/qib/Kconfig"
+source "drivers/infiniband/hw/hfi1/Kconfig"
 source "drivers/infiniband/hw/ehca/Kconfig"
 source "drivers/infiniband/hw/amso1100/Kconfig"
 source "drivers/infiniband/hw/cxgb3/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index e900b03..f3f4d9d 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_INFINIBAND_MTHCA)		+= mthca/
 obj-$(CONFIG_INFINIBAND_IPATH)		+= ipath/
 obj-$(CONFIG_INFINIBAND_QIB)		+= qib/
+obj-$(CONFIG_INFINIBAND_HFI1)		+= hfi1/
 obj-$(CONFIG_INFINIBAND_EHCA)		+= ehca/
 obj-$(CONFIG_INFINIBAND_AMSO1100)	+= amso1100/
 obj-$(CONFIG_INFINIBAND_CXGB3)		+= cxgb3/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
