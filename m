From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/cxgb4: Disable DSGL use.
Date: Thu, 27 Mar 2014 12:03:47 -0500
Message-ID: <20140327170346.19874.17772.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Current hardware doesn't correctly support DSGL.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/mem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 0989871a..bad9268 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -37,9 +37,9 @@
 
 #include "iw_cxgb4.h"
 
-int use_dsgl = 1;
+int use_dsgl = 0;
 module_param(use_dsgl, int, 0644);
-MODULE_PARM_DESC(use_dsgl, "Use DSGL for PBL/FastReg (default=1)");
+MODULE_PARM_DESC(use_dsgl, "Use DSGL for PBL/FastReg (default=0)");
 
 #define T4_ULPTX_MIN_IO 32
 #define C4IW_MAX_INLINE_SIZE 96

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
