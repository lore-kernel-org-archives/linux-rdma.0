From: Bill Pemberton <wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>
Subject: [PATCH 308/493] infiniband: remove use of __devinitdata
Date: Mon, 19 Nov 2012 13:24:17 -0500
Message-ID: <1353349642-3677-308-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

CONFIG_HOTPLUG is going away as an option so __devinitdata is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org 
---
 drivers/infiniband/hw/mthca/mthca_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index eee56ba..5ccae15 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -130,7 +130,7 @@ static int log_mtts_per_seg = ilog2(MTHCA_MTT_SEG_SIZE / 8);
 module_param_named(log_mtts_per_seg, log_mtts_per_seg, int, 0444);
 MODULE_PARM_DESC(log_mtts_per_seg, "Log2 number of MTT entries per segment (1-5)");
 
-static char mthca_version[] __devinitdata =
+static char mthca_version[] =
 	DRV_NAME ": Mellanox InfiniBand HCA driver v"
 	DRV_VERSION " (" DRV_RELDATE ")\n";
 
-- 
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
