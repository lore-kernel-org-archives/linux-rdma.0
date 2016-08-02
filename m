From: Baole Ni <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0267/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:54:54 +0800
Message-ID: <20160802105454.31543-1-baolex.ni@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mugunthanvnm-l0cyMroinI0@public.gmane.org, wei.lin.guay-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, felipe.balbi-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, chuansheng.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Baole Ni <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 951d9ab..8c74c58 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -43,7 +43,7 @@
 
 int ipoib_max_conn_qp = 128;
 
-module_param_named(max_nonsrq_conn_qp, ipoib_max_conn_qp, int, 0444);
+module_param_named(max_nonsrq_conn_qp, ipoib_max_conn_qp, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(max_nonsrq_conn_qp,
 		 "Max number of connected-mode QPs per interface "
 		 "(applied only if shared receive queue is not available)");
@@ -51,7 +51,7 @@ MODULE_PARM_DESC(max_nonsrq_conn_qp,
 #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG_DATA
 static int data_debug_level;
 
-module_param_named(cm_data_debug_level, data_debug_level, int, 0644);
+module_param_named(cm_data_debug_level, data_debug_level, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cm_data_debug_level,
 		 "Enable data path debug tracing for connected mode if > 0");
 #endif
-- 
2.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
