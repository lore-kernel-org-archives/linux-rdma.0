From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0256/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:53:52 +0800
Message-ID: <20160802105352.30808-1-baolex.ni@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: swise@chelsio.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, airlied@linux.ie, kgene@kernel.org, k.kozlowski@samsung.com, dougthompson@xmission.com, bp@alien8.de
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
 drivers/infiniband/hw/cxgb4/mem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 55d0651..73fccdc 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -39,7 +39,7 @@
 #include "iw_cxgb4.h"
 
 int use_dsgl = 0;
-module_param(use_dsgl, int, 0644);
+module_param(use_dsgl, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(use_dsgl, "Use DSGL for PBL/FastReg (default=0)");
 
 #define T4_ULPTX_MIN_IO 32
@@ -48,7 +48,7 @@ MODULE_PARM_DESC(use_dsgl, "Use DSGL for PBL/FastReg (default=0)");
 #define C4IW_INLINE_THRESHOLD 128
 
 static int inline_threshold = C4IW_INLINE_THRESHOLD;
-module_param(inline_threshold, int, 0644);
+module_param(inline_threshold, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(inline_threshold, "inline vs dsgl threshold (default=128)");
 
 static int mr_exceeds_hw_limits(struct c4iw_dev *dev, u64 length)
-- 
2.9.2
