From: Baole Ni <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0258/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:54:02 +0800
Message-ID: <20160802105402.30940-1-baolex.ni@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, airlied-cv59FeDIM0c@public.gmane.org, kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, dougthompson-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chuansheng.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Baole Ni <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index e8993e4..3b2d95d 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -35,27 +35,27 @@
 #include "iw_cxgb4.h"
 
 static int db_delay_usecs = 1;
-module_param(db_delay_usecs, int, 0644);
+module_param(db_delay_usecs, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(db_delay_usecs, "Usecs to delay awaiting db fifo to drain");
 
 static int ocqp_support = 1;
-module_param(ocqp_support, int, 0644);
+module_param(ocqp_support, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(ocqp_support, "Support on-chip SQs (default=1)");
 
 int db_fc_threshold = 1000;
-module_param(db_fc_threshold, int, 0644);
+module_param(db_fc_threshold, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(db_fc_threshold,
 		 "QP count/threshold that triggers"
 		 " automatic db flow control mode (default = 1000)");
 
 int db_coalescing_threshold;
-module_param(db_coalescing_threshold, int, 0644);
+module_param(db_coalescing_threshold, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(db_coalescing_threshold,
 		 "QP count/threshold that triggers"
 		 " disabling db coalescing (default = 0)");
 
 static int max_fr_immd = T4_MAX_FR_IMMD;
-module_param(max_fr_immd, int, 0644);
+module_param(max_fr_immd, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(max_fr_immd, "fastreg threshold for using DSGL instead of immedate");
 
 static int alloc_ird(struct c4iw_dev *dev, u32 ird)
-- 
2.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
