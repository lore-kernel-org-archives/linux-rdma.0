From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0265/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:54:41 +0800
Message-ID: <20160802105441.31409-1-baolex.ni@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: faisal.latif@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, bp@alien8.de
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
 drivers/infiniband/hw/nes/nes.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 35cbb17..c3792a6 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -70,28 +70,28 @@ int interrupt_mod_interval = 0;
 
 /* Interoperability */
 int mpa_version = 1;
-module_param(mpa_version, int, 0644);
+module_param(mpa_version, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(mpa_version, "MPA version to be used int MPA Req/Resp (0 or 1)");
 
 /* Interoperability */
 int disable_mpa_crc = 0;
-module_param(disable_mpa_crc, int, 0644);
+module_param(disable_mpa_crc, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(disable_mpa_crc, "Disable checking of MPA CRC");
 
 unsigned int nes_drv_opt = NES_DRV_OPT_DISABLE_INT_MOD | NES_DRV_OPT_ENABLE_PAU;
-module_param(nes_drv_opt, int, 0644);
+module_param(nes_drv_opt, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(nes_drv_opt, "Driver option parameters");
 
 unsigned int nes_debug_level = 0;
-module_param_named(debug_level, nes_debug_level, uint, 0644);
+module_param_named(debug_level, nes_debug_level, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(debug_level, "Enable debug output level");
 
 unsigned int wqm_quanta = 0x10000;
-module_param(wqm_quanta, int, 0644);
+module_param(wqm_quanta, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(wqm_quanta, "WQM quanta");
 
 static bool limit_maxrdreqsz;
-module_param(limit_maxrdreqsz, bool, 0644);
+module_param(limit_maxrdreqsz, bool, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(limit_maxrdreqsz, "Limit max read request size to 256 Bytes");
 
 LIST_HEAD(nes_adapter_list);
-- 
2.9.2
