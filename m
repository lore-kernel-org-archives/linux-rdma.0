From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/ehca: Deprecate driver, move to staging, schedule deletion
Date: Fri, 11 Sep 2015 14:14:42 -0400
Message-ID: <9f746f7ff6fbdd64b0a0ac6fb72d263712676022.1441995282.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The ehca driver is only supported on IBM machines with a custom EBus.
As they have opted to build their newer machines using more industry
standard technology and haven't really been pushing EBus capable
machines for a while, this driver can now safely be moved to the
staging area and scheduled for eventual removal.  This plan was brought
to IBM's attention and received their sign-off.

Cc: alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Cc: hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
Cc: raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
Cc: stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/Kconfig                                          | 1 -
 drivers/infiniband/hw/Makefile                                      | 1 -
 drivers/staging/rdma/Kconfig                                        | 2 ++
 drivers/staging/rdma/Makefile                                       | 1 +
 drivers/{infiniband/hw => staging/rdma}/ehca/Kconfig                | 3 ++-
 drivers/{infiniband/hw => staging/rdma}/ehca/Makefile               | 0
 drivers/staging/rdma/ehca/TODO                                      | 4 ++++
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_av.c              | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_classes.h         | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_classes_pSeries.h | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_cq.c              | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_eq.c              | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_hca.c             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_irq.c             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_irq.h             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_iverbs.h          | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_main.c            | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_mcast.c           | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_mrmw.c            | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_mrmw.h            | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_pd.c              | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_qes.h             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_qp.c              | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_reqs.c            | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_sqp.c             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_tools.h           | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ehca_uverbs.c          | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/hcp_if.c               | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/hcp_if.h               | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/hcp_phyp.c             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/hcp_phyp.h             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/hipz_fns.h             | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/hipz_fns_core.h        | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/hipz_hw.h              | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ipz_pt_fn.c            | 0
 drivers/{infiniband/hw => staging/rdma}/ehca/ipz_pt_fn.h            | 0
 36 files changed, 9 insertions(+), 3 deletions(-)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/Kconfig (69%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/Makefile (100%)
 create mode 100644 drivers/staging/rdma/ehca/TODO
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_av.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_classes.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_classes_pSeries.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_cq.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_eq.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_hca.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_irq.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_irq.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_iverbs.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_main.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_mcast.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_mrmw.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_mrmw.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_pd.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_qes.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_qp.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_reqs.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_sqp.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_tools.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ehca_uverbs.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/hcp_if.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/hcp_if.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/hcp_phyp.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/hcp_phyp.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/hipz_fns.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/hipz_fns_core.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/hipz_hw.h (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ipz_pt_fn.c (100%)
 rename drivers/{infiniband/hw => staging/rdma}/ehca/ipz_pt_fn.h (100%)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index da4c6979fbb8..aa26f3c3416b 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -56,7 +56,6 @@ config INFINIBAND_ADDR_TRANS
 
 source "drivers/infiniband/hw/mthca/Kconfig"
 source "drivers/infiniband/hw/qib/Kconfig"
-source "drivers/infiniband/hw/ehca/Kconfig"
 source "drivers/infiniband/hw/cxgb3/Kconfig"
 source "drivers/infiniband/hw/cxgb4/Kconfig"
 source "drivers/infiniband/hw/mlx4/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index 1bdb9996d371..aded2a5cc2d5 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -1,6 +1,5 @@
 obj-$(CONFIG_INFINIBAND_MTHCA)		+= mthca/
 obj-$(CONFIG_INFINIBAND_QIB)		+= qib/
-obj-$(CONFIG_INFINIBAND_EHCA)		+= ehca/
 obj-$(CONFIG_INFINIBAND_CXGB3)		+= cxgb3/
 obj-$(CONFIG_INFINIBAND_CXGB4)		+= cxgb4/
 obj-$(CONFIG_MLX4_INFINIBAND)		+= mlx4/
diff --git a/drivers/staging/rdma/Kconfig b/drivers/staging/rdma/Kconfig
index cf5fe9bb87a1..d7f62359d743 100644
--- a/drivers/staging/rdma/Kconfig
+++ b/drivers/staging/rdma/Kconfig
@@ -24,6 +24,8 @@ if STAGING_RDMA
 
 source "drivers/staging/rdma/amso1100/Kconfig"
 
+source "drivers/staging/rdma/ehca/Kconfig"
+
 source "drivers/staging/rdma/hfi1/Kconfig"
 
 source "drivers/staging/rdma/ipath/Kconfig"
diff --git a/drivers/staging/rdma/Makefile b/drivers/staging/rdma/Makefile
index cbd915ac7f20..139d78ef2c24 100644
--- a/drivers/staging/rdma/Makefile
+++ b/drivers/staging/rdma/Makefile
@@ -1,4 +1,5 @@
 # Entries for RDMA_STAGING tree
 obj-$(CONFIG_INFINIBAND_AMSO1100)	+= amso1100/
+obj-$(CONFIG_INFINIBAND_EHCA)	+= ehca/
 obj-$(CONFIG_INFINIBAND_HFI1)	+= hfi1/
 obj-$(CONFIG_INFINIBAND_IPATH)	+= ipath/
diff --git a/drivers/infiniband/hw/ehca/Kconfig b/drivers/staging/rdma/ehca/Kconfig
similarity index 69%
rename from drivers/infiniband/hw/ehca/Kconfig
rename to drivers/staging/rdma/ehca/Kconfig
index 59f807d8d58e..3fadd2ad6426 100644
--- a/drivers/infiniband/hw/ehca/Kconfig
+++ b/drivers/staging/rdma/ehca/Kconfig
@@ -2,7 +2,8 @@ config INFINIBAND_EHCA
 	tristate "eHCA support"
 	depends on IBMEBUS
 	---help---
-	This driver supports the IBM pSeries eHCA InfiniBand adapter.
+	This driver supports the deprecated IBM pSeries eHCA InfiniBand
+	adapter.
 
 	To compile the driver as a module, choose M here. The module
 	will be called ib_ehca.
diff --git a/drivers/infiniband/hw/ehca/Makefile b/drivers/staging/rdma/ehca/Makefile
similarity index 100%
rename from drivers/infiniband/hw/ehca/Makefile
rename to drivers/staging/rdma/ehca/Makefile
diff --git a/drivers/staging/rdma/ehca/TODO b/drivers/staging/rdma/ehca/TODO
new file mode 100644
index 000000000000..199a4a600142
--- /dev/null
+++ b/drivers/staging/rdma/ehca/TODO
@@ -0,0 +1,4 @@
+9/2015
+
+The ehca driver has been deprecated and moved to drivers/staging/rdma.
+It will be removed in the 4.6 merge window.
diff --git a/drivers/infiniband/hw/ehca/ehca_av.c b/drivers/staging/rdma/ehca/ehca_av.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_av.c
rename to drivers/staging/rdma/ehca/ehca_av.c
diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/staging/rdma/ehca/ehca_classes.h
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_classes.h
rename to drivers/staging/rdma/ehca/ehca_classes.h
diff --git a/drivers/infiniband/hw/ehca/ehca_classes_pSeries.h b/drivers/staging/rdma/ehca/ehca_classes_pSeries.h
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_classes_pSeries.h
rename to drivers/staging/rdma/ehca/ehca_classes_pSeries.h
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/staging/rdma/ehca/ehca_cq.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_cq.c
rename to drivers/staging/rdma/ehca/ehca_cq.c
diff --git a/drivers/infiniband/hw/ehca/ehca_eq.c b/drivers/staging/rdma/ehca/ehca_eq.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_eq.c
rename to drivers/staging/rdma/ehca/ehca_eq.c
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/staging/rdma/ehca/ehca_hca.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_hca.c
rename to drivers/staging/rdma/ehca/ehca_hca.c
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/staging/rdma/ehca/ehca_irq.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_irq.c
rename to drivers/staging/rdma/ehca/ehca_irq.c
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.h b/drivers/staging/rdma/ehca/ehca_irq.h
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_irq.h
rename to drivers/staging/rdma/ehca/ehca_irq.h
diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/staging/rdma/ehca/ehca_iverbs.h
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_iverbs.h
rename to drivers/staging/rdma/ehca/ehca_iverbs.h
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/staging/rdma/ehca/ehca_main.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_main.c
rename to drivers/staging/rdma/ehca/ehca_main.c
diff --git a/drivers/infiniband/hw/ehca/ehca_mcast.c b/drivers/staging/rdma/ehca/ehca_mcast.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_mcast.c
rename to drivers/staging/rdma/ehca/ehca_mcast.c
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/staging/rdma/ehca/ehca_mrmw.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_mrmw.c
rename to drivers/staging/rdma/ehca/ehca_mrmw.c
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.h b/drivers/staging/rdma/ehca/ehca_mrmw.h
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_mrmw.h
rename to drivers/staging/rdma/ehca/ehca_mrmw.h
diff --git a/drivers/infiniband/hw/ehca/ehca_pd.c b/drivers/staging/rdma/ehca/ehca_pd.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_pd.c
rename to drivers/staging/rdma/ehca/ehca_pd.c
diff --git a/drivers/infiniband/hw/ehca/ehca_qes.h b/drivers/staging/rdma/ehca/ehca_qes.h
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_qes.h
rename to drivers/staging/rdma/ehca/ehca_qes.h
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/staging/rdma/ehca/ehca_qp.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_qp.c
rename to drivers/staging/rdma/ehca/ehca_qp.c
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/staging/rdma/ehca/ehca_reqs.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_reqs.c
rename to drivers/staging/rdma/ehca/ehca_reqs.c
diff --git a/drivers/infiniband/hw/ehca/ehca_sqp.c b/drivers/staging/rdma/ehca/ehca_sqp.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_sqp.c
rename to drivers/staging/rdma/ehca/ehca_sqp.c
diff --git a/drivers/infiniband/hw/ehca/ehca_tools.h b/drivers/staging/rdma/ehca/ehca_tools.h
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_tools.h
rename to drivers/staging/rdma/ehca/ehca_tools.h
diff --git a/drivers/infiniband/hw/ehca/ehca_uverbs.c b/drivers/staging/rdma/ehca/ehca_uverbs.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/ehca_uverbs.c
rename to drivers/staging/rdma/ehca/ehca_uverbs.c
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/staging/rdma/ehca/hcp_if.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/hcp_if.c
rename to drivers/staging/rdma/ehca/hcp_if.c
diff --git a/drivers/infiniband/hw/ehca/hcp_if.h b/drivers/staging/rdma/ehca/hcp_if.h
similarity index 100%
rename from drivers/infiniband/hw/ehca/hcp_if.h
rename to drivers/staging/rdma/ehca/hcp_if.h
diff --git a/drivers/infiniband/hw/ehca/hcp_phyp.c b/drivers/staging/rdma/ehca/hcp_phyp.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/hcp_phyp.c
rename to drivers/staging/rdma/ehca/hcp_phyp.c
diff --git a/drivers/infiniband/hw/ehca/hcp_phyp.h b/drivers/staging/rdma/ehca/hcp_phyp.h
similarity index 100%
rename from drivers/infiniband/hw/ehca/hcp_phyp.h
rename to drivers/staging/rdma/ehca/hcp_phyp.h
diff --git a/drivers/infiniband/hw/ehca/hipz_fns.h b/drivers/staging/rdma/ehca/hipz_fns.h
similarity index 100%
rename from drivers/infiniband/hw/ehca/hipz_fns.h
rename to drivers/staging/rdma/ehca/hipz_fns.h
diff --git a/drivers/infiniband/hw/ehca/hipz_fns_core.h b/drivers/staging/rdma/ehca/hipz_fns_core.h
similarity index 100%
rename from drivers/infiniband/hw/ehca/hipz_fns_core.h
rename to drivers/staging/rdma/ehca/hipz_fns_core.h
diff --git a/drivers/infiniband/hw/ehca/hipz_hw.h b/drivers/staging/rdma/ehca/hipz_hw.h
similarity index 100%
rename from drivers/infiniband/hw/ehca/hipz_hw.h
rename to drivers/staging/rdma/ehca/hipz_hw.h
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.c b/drivers/staging/rdma/ehca/ipz_pt_fn.c
similarity index 100%
rename from drivers/infiniband/hw/ehca/ipz_pt_fn.c
rename to drivers/staging/rdma/ehca/ipz_pt_fn.c
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.h b/drivers/staging/rdma/ehca/ipz_pt_fn.h
similarity index 100%
rename from drivers/infiniband/hw/ehca/ipz_pt_fn.h
rename to drivers/staging/rdma/ehca/ipz_pt_fn.h
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
