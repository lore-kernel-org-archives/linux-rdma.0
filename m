From: Baole Ni <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0254/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:53:41 +0800
Message-ID: <20160802105341.30676-1-baolex.ni@intel.com>
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
 drivers/infiniband/hw/cxgb4/cm.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index a3a6721..e2d150a 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -69,73 +69,73 @@ static char *states[] = {
 };
 
 static int nocong;
-module_param(nocong, int, 0644);
+module_param(nocong, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(nocong, "Turn of congestion control (default=0)");
 
 static int enable_ecn;
-module_param(enable_ecn, int, 0644);
+module_param(enable_ecn, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(enable_ecn, "Enable ECN (default=0/disabled)");
 
 static int dack_mode = 1;
-module_param(dack_mode, int, 0644);
+module_param(dack_mode, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(dack_mode, "Delayed ack mode (default=1)");
 
 uint c4iw_max_read_depth = 32;
-module_param(c4iw_max_read_depth, int, 0644);
+module_param(c4iw_max_read_depth, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(c4iw_max_read_depth,
 		 "Per-connection max ORD/IRD (default=32)");
 
 static int enable_tcp_timestamps;
-module_param(enable_tcp_timestamps, int, 0644);
+module_param(enable_tcp_timestamps, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(enable_tcp_timestamps, "Enable tcp timestamps (default=0)");
 
 static int enable_tcp_sack;
-module_param(enable_tcp_sack, int, 0644);
+module_param(enable_tcp_sack, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(enable_tcp_sack, "Enable tcp SACK (default=0)");
 
 static int enable_tcp_window_scaling = 1;
-module_param(enable_tcp_window_scaling, int, 0644);
+module_param(enable_tcp_window_scaling, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(enable_tcp_window_scaling,
 		 "Enable tcp window scaling (default=1)");
 
 int c4iw_debug;
-module_param(c4iw_debug, int, 0644);
+module_param(c4iw_debug, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(c4iw_debug, "Enable debug logging (default=0)");
 
 static int peer2peer = 1;
-module_param(peer2peer, int, 0644);
+module_param(peer2peer, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(peer2peer, "Support peer2peer ULPs (default=1)");
 
 static int p2p_type = FW_RI_INIT_P2PTYPE_READ_REQ;
-module_param(p2p_type, int, 0644);
+module_param(p2p_type, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(p2p_type, "RDMAP opcode to use for the RTR message: "
 			   "1=RDMA_READ 0=RDMA_WRITE (default 1)");
 
 static int ep_timeout_secs = 60;
-module_param(ep_timeout_secs, int, 0644);
+module_param(ep_timeout_secs, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(ep_timeout_secs, "CM Endpoint operation timeout "
 				   "in seconds (default=60)");
 
 static int mpa_rev = 2;
-module_param(mpa_rev, int, 0644);
+module_param(mpa_rev, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(mpa_rev, "MPA Revision, 0 supports amso1100, "
 		"1 is RFC5044 spec compliant, 2 is IETF MPA Peer Connect Draft"
 		" compliant (default=2)");
 
 static int markers_enabled;
-module_param(markers_enabled, int, 0644);
+module_param(markers_enabled, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(markers_enabled, "Enable MPA MARKERS (default(0)=disabled)");
 
 static int crc_enabled = 1;
-module_param(crc_enabled, int, 0644);
+module_param(crc_enabled, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(crc_enabled, "Enable MPA CRC (default(1)=enabled)");
 
 static int rcv_win = 256 * 1024;
-module_param(rcv_win, int, 0644);
+module_param(rcv_win, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(rcv_win, "TCP receive window in bytes (default=256KB)");
 
 static int snd_win = 128 * 1024;
-module_param(snd_win, int, 0644);
+module_param(snd_win, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(snd_win, "TCP send window in bytes (default=128KB)");
 
 static struct workqueue_struct *workq;
-- 
2.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
