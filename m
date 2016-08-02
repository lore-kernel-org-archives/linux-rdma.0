From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0271/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:55:20 +0800
Message-ID: <20160802105520.31816-1-baolex.ni@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sagi@grimberg.me, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, bp@alien8.de
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com, jgunthorpe@obsidianresearch.com, erezsh@mellanox.com, matanb@mellanox.com, alex.estrin@intel.com
List-Id: linux-rdma@vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index a990c04..e2d11ac 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -39,7 +39,7 @@
 				 ISERT_MAX_CONN)
 
 static int isert_debug_level;
-module_param_named(debug_level, isert_debug_level, int, 0644);
+module_param_named(debug_level, isert_debug_level, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0 (default:0)");
 
 static DEFINE_MUTEX(device_list_mutex);
-- 
2.9.2
