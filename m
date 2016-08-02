From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0264/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:54:37 +0800
Message-ID: <20160802105437.31343-1-baolex.ni@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, bp@alien8.de
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com, hch@infradead.org, matanb@mellanox.com, markb@mellanox.com, jgunthorpe@obsidianresearch.com, dean.luick@intel.com
List-Id: linux-rdma@vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/infiniband/hw/mthca/mthca_main.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index ded76c1..71b7773 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -54,7 +54,7 @@ MODULE_VERSION(DRV_VERSION);
 #ifdef CONFIG_INFINIBAND_MTHCA_DEBUG
 
 int mthca_debug_level = 0;
-module_param_named(debug_level, mthca_debug_level, int, 0644);
+module_param_named(debug_level, mthca_debug_level, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0");
 
 #endif /* CONFIG_INFINIBAND_MTHCA_DEBUG */
@@ -62,7 +62,7 @@ MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0");
 #ifdef CONFIG_PCI_MSI
 
 static int msi_x = 1;
-module_param(msi_x, int, 0444);
+module_param(msi_x, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(msi_x, "attempt to use MSI-X if nonzero");
 
 #else /* CONFIG_PCI_MSI */
@@ -72,7 +72,7 @@ MODULE_PARM_DESC(msi_x, "attempt to use MSI-X if nonzero");
 #endif /* CONFIG_PCI_MSI */
 
 static int tune_pci = 0;
-module_param(tune_pci, int, 0444);
+module_param(tune_pci, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(tune_pci, "increase PCI burst from the default set by BIOS if nonzero");
 
 DEFINE_MUTEX(mthca_device_mutex);
@@ -99,35 +99,35 @@ static struct mthca_profile hca_profile = {
 	.uarc_size          = MTHCA_DEFAULT_NUM_UARC_SIZE,     /* Arbel only */
 };
 
-module_param_named(num_qp, hca_profile.num_qp, int, 0444);
+module_param_named(num_qp, hca_profile.num_qp, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(num_qp, "maximum number of QPs per HCA");
 
-module_param_named(rdb_per_qp, hca_profile.rdb_per_qp, int, 0444);
+module_param_named(rdb_per_qp, hca_profile.rdb_per_qp, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(rdb_per_qp, "number of RDB buffers per QP");
 
-module_param_named(num_cq, hca_profile.num_cq, int, 0444);
+module_param_named(num_cq, hca_profile.num_cq, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(num_cq, "maximum number of CQs per HCA");
 
-module_param_named(num_mcg, hca_profile.num_mcg, int, 0444);
+module_param_named(num_mcg, hca_profile.num_mcg, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(num_mcg, "maximum number of multicast groups per HCA");
 
-module_param_named(num_mpt, hca_profile.num_mpt, int, 0444);
+module_param_named(num_mpt, hca_profile.num_mpt, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(num_mpt,
 		"maximum number of memory protection table entries per HCA");
 
-module_param_named(num_mtt, hca_profile.num_mtt, int, 0444);
+module_param_named(num_mtt, hca_profile.num_mtt, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(num_mtt,
 		 "maximum number of memory translation table segments per HCA");
 
-module_param_named(num_udav, hca_profile.num_udav, int, 0444);
+module_param_named(num_udav, hca_profile.num_udav, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(num_udav, "maximum number of UD address vectors per HCA");
 
-module_param_named(fmr_reserved_mtts, hca_profile.fmr_reserved_mtts, int, 0444);
+module_param_named(fmr_reserved_mtts, hca_profile.fmr_reserved_mtts, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(fmr_reserved_mtts,
 		 "number of memory translation table segments reserved for FMR");
 
 static int log_mtts_per_seg = ilog2(MTHCA_MTT_SEG_SIZE / 8);
-module_param_named(log_mtts_per_seg, log_mtts_per_seg, int, 0444);
+module_param_named(log_mtts_per_seg, log_mtts_per_seg, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(log_mtts_per_seg, "Log2 number of MTT entries per segment (1-5)");
 
 static char mthca_version[] =
-- 
2.9.2
