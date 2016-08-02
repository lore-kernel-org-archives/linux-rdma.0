From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0268/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:55:01 +0800
Message-ID: <20160802105501.31614-1-baolex.ni@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, bp@alien8.de
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, leon@kernel.org, bart.vanassche@sandisk.com, markb@mellanox.com, mugunthanvnm@ti.com, hans.westgaard.ry@oracle.com, eli@mellanox.com, clsoto@linux.vnet.ibm.com, fw@strlen.de, bigeasy@linutronix.de, chuansheng.liu@intel.com, baolex.ni@intel.com
List-Id: linux-rdma@vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index dc6d241..0f25847 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -46,7 +46,7 @@
 #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG_DATA
 static int data_debug_level;
 
-module_param(data_debug_level, int, 0644);
+module_param(data_debug_level, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(data_debug_level,
 		 "Enable data path debug tracing if > 0");
 #endif
-- 
2.9.2
