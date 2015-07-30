From: dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] IB/ipath: Move ipath driver to staging.
Date: Thu, 30 Jul 2015 09:25:42 -0400
Message-ID: <1438262742-4182-1-git-send-email-dennis.dalessandro@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It is now time for the ipath driver to begin to be phased out of the kernel.
This patch moves the ipath driver from the Infiniband sub tree to the staging
area where it will remain until the code is removed from the kernel in a few
releases.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 MAINTAINERS                                                  | 2 +-
 drivers/infiniband/Kconfig                                   | 1 -
 drivers/infiniband/hw/Makefile                               | 1 -
 drivers/staging/Kconfig                                      | 2 ++
 drivers/staging/Makefile                                     | 1 +
 drivers/{infiniband/hw => staging}/ipath/Kconfig             | 4 +++-
 drivers/{infiniband/hw => staging}/ipath/Makefile            | 0
 drivers/staging/ipath/TODO                                   | 5 +++++
 drivers/{infiniband/hw => staging}/ipath/ipath_common.h      | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_cq.c          | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_debug.h       | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_diag.c        | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_dma.c         | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_driver.c      | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_eeprom.c      | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_file_ops.c    | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_fs.c          | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_iba6110.c     | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_init_chip.c   | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_intr.c        | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_kernel.h      | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_keys.c        | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_mad.c         | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_mmap.c        | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_mr.c          | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_qp.c          | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_rc.c          | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_registers.h   | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_ruc.c         | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_sdma.c        | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_srq.c         | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_stats.c       | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_sysfs.c       | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_uc.c          | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_ud.c          | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_user_pages.c  | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_user_sdma.c   | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_user_sdma.h   | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_verbs.c       | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_verbs.h       | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_verbs_mcast.c | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_wc_ppc64.c    | 0
 drivers/{infiniband/hw => staging}/ipath/ipath_wc_x86_64.c   | 0
 43 files changed, 12 insertions(+), 4 deletions(-)
 rename drivers/{infiniband/hw => staging}/ipath/Kconfig (81%)
 rename drivers/{infiniband/hw => staging}/ipath/Makefile (100%)
 create mode 100644 drivers/staging/ipath/TODO
 rename drivers/{infiniband/hw => staging}/ipath/ipath_common.h (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_cq.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_debug.h (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_diag.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_dma.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_driver.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_eeprom.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_file_ops.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_fs.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_iba6110.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_init_chip.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_intr.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_kernel.h (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_keys.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_mad.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_mmap.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_mr.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_qp.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_rc.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_registers.h (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_ruc.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_sdma.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_srq.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_stats.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_sysfs.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_uc.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_ud.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_user_pages.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_user_sdma.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_user_sdma.h (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_verbs.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_verbs.h (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_verbs_mcast.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_wc_ppc64.c (100%)
 rename drivers/{infiniband/hw => staging}/ipath/ipath_wc_x86_64.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8133cef..b76e8a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5512,7 +5512,7 @@ IPATH DRIVER
 M:	Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Maintained
-F:	drivers/infiniband/hw/ipath/
+F:	drivers/staging/ipath/
 
 IPMI SUBSYSTEM
 M:	Corey Minyard <minyard-HInyCGIudOg@public.gmane.org>
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index b899531..7d6034f 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -55,7 +55,6 @@ config INFINIBAND_ADDR_TRANS
 	default y
 
 source "drivers/infiniband/hw/mthca/Kconfig"
-source "drivers/infiniband/hw/ipath/Kconfig"
 source "drivers/infiniband/hw/qib/Kconfig"
 source "drivers/infiniband/hw/ehca/Kconfig"
 source "drivers/infiniband/hw/amso1100/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index e900b03..d1212c4 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -1,5 +1,4 @@
 obj-$(CONFIG_INFINIBAND_MTHCA)		+= mthca/
-obj-$(CONFIG_INFINIBAND_IPATH)		+= ipath/
 obj-$(CONFIG_INFINIBAND_QIB)		+= qib/
 obj-$(CONFIG_INFINIBAND_EHCA)		+= ehca/
 obj-$(CONFIG_INFINIBAND_AMSO1100)	+= amso1100/
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 7f6cae5..ad545a1 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -112,4 +112,6 @@ source "drivers/staging/fsl-mc/Kconfig"
 
 source "drivers/staging/wilc1000/Kconfig"
 
+source "drivers/staging/ipath/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 347f647..350c5ea 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -48,3 +48,4 @@ obj-$(CONFIG_COMMON_CLK_XLNX_CLKWZRD)	+= clocking-wizard/
 obj-$(CONFIG_FB_TFT)		+= fbtft/
 obj-$(CONFIG_FSL_MC_BUS)	+= fsl-mc/
 obj-$(CONFIG_WILC1000)		+= wilc1000/
+obj-$(CONFIG_INFINIBAND_IPATH)  += ipath/
diff --git a/drivers/infiniband/hw/ipath/Kconfig b/drivers/staging/ipath/Kconfig
similarity index 81%
rename from drivers/infiniband/hw/ipath/Kconfig
rename to drivers/staging/ipath/Kconfig
index 8fe54ff..041ce06 100644
--- a/drivers/infiniband/hw/ipath/Kconfig
+++ b/drivers/staging/ipath/Kconfig
@@ -2,7 +2,7 @@ config INFINIBAND_IPATH
 	tristate "QLogic HTX HCA support"
 	depends on 64BIT && NET && HT_IRQ
 	---help---
-	This is a driver for the obsolete QLogic Hyper-Transport
+	This is a driver for the deprecated QLogic Hyper-Transport
 	IB host channel adapter (model QHT7140),
 	including InfiniBand verbs support.  This driver allows these
 	devices to be used with both kernel upper level protocols such
@@ -12,3 +12,5 @@ config INFINIBAND_IPATH
 
 	If you have this hardware you will need to boot with PAT disabled
 	on your x86-64 systems, use the nopat kernel parameter.
+
+	Note that this driver will soon be removed entirely from the kernel.
diff --git a/drivers/infiniband/hw/ipath/Makefile b/drivers/staging/ipath/Makefile
similarity index 100%
rename from drivers/infiniband/hw/ipath/Makefile
rename to drivers/staging/ipath/Makefile
diff --git a/drivers/staging/ipath/TODO b/drivers/staging/ipath/TODO
new file mode 100644
index 0000000..cb00158
--- /dev/null
+++ b/drivers/staging/ipath/TODO
@@ -0,0 +1,5 @@
+The ipath driver has been moved to staging in preparation for its removal in a
+few releases. The driver will be deleted during the 4.6 merge window.
+
+Contact Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> and
+Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
diff --git a/drivers/infiniband/hw/ipath/ipath_common.h b/drivers/staging/ipath/ipath_common.h
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_common.h
rename to drivers/staging/ipath/ipath_common.h
diff --git a/drivers/infiniband/hw/ipath/ipath_cq.c b/drivers/staging/ipath/ipath_cq.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_cq.c
rename to drivers/staging/ipath/ipath_cq.c
diff --git a/drivers/infiniband/hw/ipath/ipath_debug.h b/drivers/staging/ipath/ipath_debug.h
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_debug.h
rename to drivers/staging/ipath/ipath_debug.h
diff --git a/drivers/infiniband/hw/ipath/ipath_diag.c b/drivers/staging/ipath/ipath_diag.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_diag.c
rename to drivers/staging/ipath/ipath_diag.c
diff --git a/drivers/infiniband/hw/ipath/ipath_dma.c b/drivers/staging/ipath/ipath_dma.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_dma.c
rename to drivers/staging/ipath/ipath_dma.c
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/staging/ipath/ipath_driver.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_driver.c
rename to drivers/staging/ipath/ipath_driver.c
diff --git a/drivers/infiniband/hw/ipath/ipath_eeprom.c b/drivers/staging/ipath/ipath_eeprom.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_eeprom.c
rename to drivers/staging/ipath/ipath_eeprom.c
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/staging/ipath/ipath_file_ops.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_file_ops.c
rename to drivers/staging/ipath/ipath_file_ops.c
diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/staging/ipath/ipath_fs.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_fs.c
rename to drivers/staging/ipath/ipath_fs.c
diff --git a/drivers/infiniband/hw/ipath/ipath_iba6110.c b/drivers/staging/ipath/ipath_iba6110.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_iba6110.c
rename to drivers/staging/ipath/ipath_iba6110.c
diff --git a/drivers/infiniband/hw/ipath/ipath_init_chip.c b/drivers/staging/ipath/ipath_init_chip.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_init_chip.c
rename to drivers/staging/ipath/ipath_init_chip.c
diff --git a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/staging/ipath/ipath_intr.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_intr.c
rename to drivers/staging/ipath/ipath_intr.c
diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/staging/ipath/ipath_kernel.h
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_kernel.h
rename to drivers/staging/ipath/ipath_kernel.h
diff --git a/drivers/infiniband/hw/ipath/ipath_keys.c b/drivers/staging/ipath/ipath_keys.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_keys.c
rename to drivers/staging/ipath/ipath_keys.c
diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/staging/ipath/ipath_mad.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_mad.c
rename to drivers/staging/ipath/ipath_mad.c
diff --git a/drivers/infiniband/hw/ipath/ipath_mmap.c b/drivers/staging/ipath/ipath_mmap.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_mmap.c
rename to drivers/staging/ipath/ipath_mmap.c
diff --git a/drivers/infiniband/hw/ipath/ipath_mr.c b/drivers/staging/ipath/ipath_mr.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_mr.c
rename to drivers/staging/ipath/ipath_mr.c
diff --git a/drivers/infiniband/hw/ipath/ipath_qp.c b/drivers/staging/ipath/ipath_qp.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_qp.c
rename to drivers/staging/ipath/ipath_qp.c
diff --git a/drivers/infiniband/hw/ipath/ipath_rc.c b/drivers/staging/ipath/ipath_rc.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_rc.c
rename to drivers/staging/ipath/ipath_rc.c
diff --git a/drivers/infiniband/hw/ipath/ipath_registers.h b/drivers/staging/ipath/ipath_registers.h
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_registers.h
rename to drivers/staging/ipath/ipath_registers.h
diff --git a/drivers/infiniband/hw/ipath/ipath_ruc.c b/drivers/staging/ipath/ipath_ruc.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_ruc.c
rename to drivers/staging/ipath/ipath_ruc.c
diff --git a/drivers/infiniband/hw/ipath/ipath_sdma.c b/drivers/staging/ipath/ipath_sdma.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_sdma.c
rename to drivers/staging/ipath/ipath_sdma.c
diff --git a/drivers/infiniband/hw/ipath/ipath_srq.c b/drivers/staging/ipath/ipath_srq.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_srq.c
rename to drivers/staging/ipath/ipath_srq.c
diff --git a/drivers/infiniband/hw/ipath/ipath_stats.c b/drivers/staging/ipath/ipath_stats.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_stats.c
rename to drivers/staging/ipath/ipath_stats.c
diff --git a/drivers/infiniband/hw/ipath/ipath_sysfs.c b/drivers/staging/ipath/ipath_sysfs.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_sysfs.c
rename to drivers/staging/ipath/ipath_sysfs.c
diff --git a/drivers/infiniband/hw/ipath/ipath_uc.c b/drivers/staging/ipath/ipath_uc.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_uc.c
rename to drivers/staging/ipath/ipath_uc.c
diff --git a/drivers/infiniband/hw/ipath/ipath_ud.c b/drivers/staging/ipath/ipath_ud.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_ud.c
rename to drivers/staging/ipath/ipath_ud.c
diff --git a/drivers/infiniband/hw/ipath/ipath_user_pages.c b/drivers/staging/ipath/ipath_user_pages.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_user_pages.c
rename to drivers/staging/ipath/ipath_user_pages.c
diff --git a/drivers/infiniband/hw/ipath/ipath_user_sdma.c b/drivers/staging/ipath/ipath_user_sdma.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_user_sdma.c
rename to drivers/staging/ipath/ipath_user_sdma.c
diff --git a/drivers/infiniband/hw/ipath/ipath_user_sdma.h b/drivers/staging/ipath/ipath_user_sdma.h
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_user_sdma.h
rename to drivers/staging/ipath/ipath_user_sdma.h
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/staging/ipath/ipath_verbs.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_verbs.c
rename to drivers/staging/ipath/ipath_verbs.c
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.h b/drivers/staging/ipath/ipath_verbs.h
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_verbs.h
rename to drivers/staging/ipath/ipath_verbs.h
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c b/drivers/staging/ipath/ipath_verbs_mcast.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
rename to drivers/staging/ipath/ipath_verbs_mcast.c
diff --git a/drivers/infiniband/hw/ipath/ipath_wc_ppc64.c b/drivers/staging/ipath/ipath_wc_ppc64.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_wc_ppc64.c
rename to drivers/staging/ipath/ipath_wc_ppc64.c
diff --git a/drivers/infiniband/hw/ipath/ipath_wc_x86_64.c b/drivers/staging/ipath/ipath_wc_x86_64.c
similarity index 100%
rename from drivers/infiniband/hw/ipath/ipath_wc_x86_64.c
rename to drivers/staging/ipath/ipath_wc_x86_64.c
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
