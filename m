From: Baole Ni <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0272/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:55:26 +0800
Message-ID: <20160802105526.31882-1-baolex.ni@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chuansheng.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Baole Ni <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 3322ed7..ac2cd92 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -73,34 +73,34 @@ static bool register_always = true;
 static bool never_register;
 static int topspin_workarounds = 1;
 
-module_param(srp_sg_tablesize, uint, 0444);
+module_param(srp_sg_tablesize, uint, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(srp_sg_tablesize, "Deprecated name for cmd_sg_entries");
 
-module_param(cmd_sg_entries, uint, 0444);
+module_param(cmd_sg_entries, uint, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cmd_sg_entries,
 		 "Default number of gather/scatter entries in the SRP command (default is 12, max 255)");
 
-module_param(indirect_sg_entries, uint, 0444);
+module_param(indirect_sg_entries, uint, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(indirect_sg_entries,
 		 "Default max number of gather/scatter entries (default is 12, max is " __stringify(SG_MAX_SEGMENTS) ")");
 
-module_param(allow_ext_sg, bool, 0444);
+module_param(allow_ext_sg, bool, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(allow_ext_sg,
 		  "Default behavior when there are more than cmd_sg_entries S/G entries after mapping; fails the request when false (default false)");
 
-module_param(topspin_workarounds, int, 0444);
+module_param(topspin_workarounds, int, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(topspin_workarounds,
 		 "Enable workarounds for Topspin/Cisco SRP target bugs if != 0");
 
-module_param(prefer_fr, bool, 0444);
+module_param(prefer_fr, bool, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(prefer_fr,
 "Whether to use fast registration if both FMR and fast registration are supported");
 
-module_param(register_always, bool, 0444);
+module_param(register_always, bool, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(register_always,
 		 "Use memory registration even for contiguous memory regions");
 
-module_param(never_register, bool, 0444);
+module_param(never_register, bool, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(never_register, "Never register memory");
 
 static const struct kernel_param_ops srp_tmo_ops;
@@ -130,7 +130,7 @@ MODULE_PARM_DESC(dev_loss_tmo,
 		 " this functionality is disabled.");
 
 static unsigned ch_count;
-module_param(ch_count, uint, 0444);
+module_param(ch_count, uint, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(ch_count,
 		 "Number of RDMA channels to use for communication with an SRP target. Using more than one channel improves performance if the HCA supports multiple completion vectors. The default value is the minimum of four times the number of online CPU sockets and the number of completion vectors supported by the HCA.");
 
-- 
2.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
