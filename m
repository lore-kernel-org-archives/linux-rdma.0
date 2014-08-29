From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cxgb4: make c4iw_wr_log_size_order static
Date: Fri, 29 Aug 2014 11:19:29 -0500
Message-ID: <20140829161929.23930.85782.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This fixes an sparse warning.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/device.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index f25df52..72f1f05 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -60,7 +60,7 @@ int c4iw_wr_log = 0;
 module_param(c4iw_wr_log, int, 0444);
 MODULE_PARM_DESC(c4iw_wr_log, "Enables logging of work request timing data.");
 
-int c4iw_wr_log_size_order = 12;
+static int c4iw_wr_log_size_order = 12;
 module_param(c4iw_wr_log_size_order, int, 0444);
 MODULE_PARM_DESC(c4iw_wr_log_size_order,
 		 "Number of entries (log2) in the work request timing log.");

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
