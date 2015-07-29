From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/amso1100: deprecate the amso1100 provider
Date: Wed, 29 Jul 2015 09:44:14 -0500
Message-ID: <20150729144646.C1FF1E0B55@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The HW hasn't been sold since 2005, and the SW has definite bit rot.
Its time to remove it.  So move it to staging for a few releases and
then remove it after that.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/Kconfig                         |    1 -
 drivers/infiniband/hw/Makefile                     |    1 -
 drivers/staging/Kconfig                            |    2 ++
 drivers/staging/Makefile                           |    1 +
 drivers/{infiniband/hw => staging}/amso1100/Kbuild |    0
 .../{infiniband/hw => staging}/amso1100/Kconfig    |    0
 drivers/staging/amso1100/TODO                      |    4 ++++
 drivers/{infiniband/hw => staging}/amso1100/c2.c   |    0
 drivers/{infiniband/hw => staging}/amso1100/c2.h   |    0
 .../{infiniband/hw => staging}/amso1100/c2_ae.c    |    0
 .../{infiniband/hw => staging}/amso1100/c2_ae.h    |    0
 .../{infiniband/hw => staging}/amso1100/c2_alloc.c |    0
 .../{infiniband/hw => staging}/amso1100/c2_cm.c    |    0
 .../{infiniband/hw => staging}/amso1100/c2_cq.c    |    0
 .../{infiniband/hw => staging}/amso1100/c2_intr.c  |    0
 .../{infiniband/hw => staging}/amso1100/c2_mm.c    |    0
 .../{infiniband/hw => staging}/amso1100/c2_mq.c    |    0
 .../{infiniband/hw => staging}/amso1100/c2_mq.h    |    0
 .../{infiniband/hw => staging}/amso1100/c2_pd.c    |    0
 .../hw => staging}/amso1100/c2_provider.c          |    0
 .../hw => staging}/amso1100/c2_provider.h          |    0
 .../{infiniband/hw => staging}/amso1100/c2_qp.c    |    0
 .../{infiniband/hw => staging}/amso1100/c2_rnic.c  |    0
 .../hw => staging}/amso1100/c2_status.h            |    0
 .../{infiniband/hw => staging}/amso1100/c2_user.h  |    0
 .../{infiniband/hw => staging}/amso1100/c2_vq.c    |    0
 .../{infiniband/hw => staging}/amso1100/c2_vq.h    |    0
 .../{infiniband/hw => staging}/amso1100/c2_wr.h    |    0
 28 files changed, 7 insertions(+), 2 deletions(-)
 rename drivers/{infiniband/hw => staging}/amso1100/Kbuild (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/Kconfig (100%)
 create mode 100644 drivers/staging/amso1100/TODO
 rename drivers/{infiniband/hw => staging}/amso1100/c2.c (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2.h (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_ae.c (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_ae.h (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_alloc.c (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_cm.c (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_cq.c (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_intr.c (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_mm.c (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_mq.c (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_mq.h (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_pd.c (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_provider.c (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_provider.h (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_qp.c (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_rnic.c (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_status.h (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_user.h (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_vq.c (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_vq.h (100%)
 rename drivers/{infiniband/hw => staging}/amso1100/c2_wr.h (100%)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index b899531..c3c184e 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -58,7 +58,6 @@ source "drivers/infiniband/hw/mthca/Kconfig"
 source "drivers/infiniband/hw/ipath/Kconfig"
 source "drivers/infiniband/hw/qib/Kconfig"
 source "drivers/infiniband/hw/ehca/Kconfig"
-source "drivers/infiniband/hw/amso1100/Kconfig"
 source "drivers/infiniband/hw/cxgb3/Kconfig"
 source "drivers/infiniband/hw/cxgb4/Kconfig"
 source "drivers/infiniband/hw/mlx4/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index e900b03..e179dfb 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -2,7 +2,6 @@ obj-$(CONFIG_INFINIBAND_MTHCA)		+= mthca/
 obj-$(CONFIG_INFINIBAND_IPATH)		+= ipath/
 obj-$(CONFIG_INFINIBAND_QIB)		+= qib/
 obj-$(CONFIG_INFINIBAND_EHCA)		+= ehca/
-obj-$(CONFIG_INFINIBAND_AMSO1100)	+= amso1100/
 obj-$(CONFIG_INFINIBAND_CXGB3)		+= cxgb3/
 obj-$(CONFIG_INFINIBAND_CXGB4)		+= cxgb4/
 obj-$(CONFIG_MLX4_INFINIBAND)		+= mlx4/
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 7f6cae5..cec20d2 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -112,4 +112,6 @@ source "drivers/staging/fsl-mc/Kconfig"
 
 source "drivers/staging/wilc1000/Kconfig"
 
+source "drivers/staging/amso1100/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 347f647..4ca8633 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -48,3 +48,4 @@ obj-$(CONFIG_COMMON_CLK_XLNX_CLKWZRD)	+= clocking-wizard/
 obj-$(CONFIG_FB_TFT)		+= fbtft/
 obj-$(CONFIG_FSL_MC_BUS)	+= fsl-mc/
 obj-$(CONFIG_WILC1000)		+= wilc1000/
+obj-$(CONFIG_INFINIBAND_AMSO1100) += amso1100/
diff --git a/drivers/infiniband/hw/amso1100/Kbuild b/drivers/staging/amso1100/Kbuild
similarity index 100%
rename from drivers/infiniband/hw/amso1100/Kbuild
rename to drivers/staging/amso1100/Kbuild
diff --git a/drivers/infiniband/hw/amso1100/Kconfig b/drivers/staging/amso1100/Kconfig
similarity index 100%
rename from drivers/infiniband/hw/amso1100/Kconfig
rename to drivers/staging/amso1100/Kconfig
diff --git a/drivers/staging/amso1100/TODO b/drivers/staging/amso1100/TODO
new file mode 100644
index 0000000..18b00a5
--- /dev/null
+++ b/drivers/staging/amso1100/TODO
@@ -0,0 +1,4 @@
+7/2015
+
+The amso1100 driver has been deprecated and moved to drivers/staging.
+It will be removed in the 4.6 merge window.
diff --git a/drivers/infiniband/hw/amso1100/c2.c b/drivers/staging/amso1100/c2.c
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2.c
rename to drivers/staging/amso1100/c2.c
diff --git a/drivers/infiniband/hw/amso1100/c2.h b/drivers/staging/amso1100/c2.h
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2.h
rename to drivers/staging/amso1100/c2.h
diff --git a/drivers/infiniband/hw/amso1100/c2_ae.c b/drivers/staging/amso1100/c2_ae.c
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_ae.c
rename to drivers/staging/amso1100/c2_ae.c
diff --git a/drivers/infiniband/hw/amso1100/c2_ae.h b/drivers/staging/amso1100/c2_ae.h
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_ae.h
rename to drivers/staging/amso1100/c2_ae.h
diff --git a/drivers/infiniband/hw/amso1100/c2_alloc.c b/drivers/staging/amso1100/c2_alloc.c
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_alloc.c
rename to drivers/staging/amso1100/c2_alloc.c
diff --git a/drivers/infiniband/hw/amso1100/c2_cm.c b/drivers/staging/amso1100/c2_cm.c
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_cm.c
rename to drivers/staging/amso1100/c2_cm.c
diff --git a/drivers/infiniband/hw/amso1100/c2_cq.c b/drivers/staging/amso1100/c2_cq.c
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_cq.c
rename to drivers/staging/amso1100/c2_cq.c
diff --git a/drivers/infiniband/hw/amso1100/c2_intr.c b/drivers/staging/amso1100/c2_intr.c
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_intr.c
rename to drivers/staging/amso1100/c2_intr.c
diff --git a/drivers/infiniband/hw/amso1100/c2_mm.c b/drivers/staging/amso1100/c2_mm.c
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_mm.c
rename to drivers/staging/amso1100/c2_mm.c
diff --git a/drivers/infiniband/hw/amso1100/c2_mq.c b/drivers/staging/amso1100/c2_mq.c
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_mq.c
rename to drivers/staging/amso1100/c2_mq.c
diff --git a/drivers/infiniband/hw/amso1100/c2_mq.h b/drivers/staging/amso1100/c2_mq.h
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_mq.h
rename to drivers/staging/amso1100/c2_mq.h
diff --git a/drivers/infiniband/hw/amso1100/c2_pd.c b/drivers/staging/amso1100/c2_pd.c
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_pd.c
rename to drivers/staging/amso1100/c2_pd.c
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/staging/amso1100/c2_provider.c
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_provider.c
rename to drivers/staging/amso1100/c2_provider.c
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.h b/drivers/staging/amso1100/c2_provider.h
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_provider.h
rename to drivers/staging/amso1100/c2_provider.h
diff --git a/drivers/infiniband/hw/amso1100/c2_qp.c b/drivers/staging/amso1100/c2_qp.c
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_qp.c
rename to drivers/staging/amso1100/c2_qp.c
diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c b/drivers/staging/amso1100/c2_rnic.c
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_rnic.c
rename to drivers/staging/amso1100/c2_rnic.c
diff --git a/drivers/infiniband/hw/amso1100/c2_status.h b/drivers/staging/amso1100/c2_status.h
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_status.h
rename to drivers/staging/amso1100/c2_status.h
diff --git a/drivers/infiniband/hw/amso1100/c2_user.h b/drivers/staging/amso1100/c2_user.h
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_user.h
rename to drivers/staging/amso1100/c2_user.h
diff --git a/drivers/infiniband/hw/amso1100/c2_vq.c b/drivers/staging/amso1100/c2_vq.c
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_vq.c
rename to drivers/staging/amso1100/c2_vq.c
diff --git a/drivers/infiniband/hw/amso1100/c2_vq.h b/drivers/staging/amso1100/c2_vq.h
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_vq.h
rename to drivers/staging/amso1100/c2_vq.h
diff --git a/drivers/infiniband/hw/amso1100/c2_wr.h b/drivers/staging/amso1100/c2_wr.h
similarity index 100%
rename from drivers/infiniband/hw/amso1100/c2_wr.h
rename to drivers/staging/amso1100/c2_wr.h
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
