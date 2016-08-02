From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0253/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 18:53:33 +0800
Message-ID: <20160802105333.30605-1-baolex.ni@intel.com>
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
 drivers/infiniband/hw/cxgb3/iwch_cm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 3e8431b..f38dc0a 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -65,41 +65,41 @@ static char *states[] = {
 };
 
 int peer2peer = 0;
-module_param(peer2peer, int, 0644);
+module_param(peer2peer, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(peer2peer, "Support peer2peer ULPs (default=0)");
 
 static int ep_timeout_secs = 60;
-module_param(ep_timeout_secs, int, 0644);
+module_param(ep_timeout_secs, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(ep_timeout_secs, "CM Endpoint operation timeout "
 				   "in seconds (default=60)");
 
 static int mpa_rev = 1;
-module_param(mpa_rev, int, 0644);
+module_param(mpa_rev, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(mpa_rev, "MPA Revision, 0 supports amso1100, "
 		 "1 is spec compliant. (default=1)");
 
 static int markers_enabled = 0;
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
 MODULE_PARM_DESC(rcv_win, "TCP receive window in bytes (default=256)");
 
 static int snd_win = 32 * 1024;
-module_param(snd_win, int, 0644);
+module_param(snd_win, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(snd_win, "TCP send window in bytes (default=32KB)");
 
 static unsigned int nocong = 0;
-module_param(nocong, uint, 0644);
+module_param(nocong, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(nocong, "Turn off congestion control (default=0)");
 
 static unsigned int cong_flavor = 1;
-module_param(cong_flavor, uint, 0644);
+module_param(cong_flavor, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cong_flavor, "TCP Congestion control flavor (default=1)");
 
 static struct workqueue_struct *workq;
-- 
2.9.2
