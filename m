From: weiyj_lk-9Onoh4P/yGk@public.gmane.org
Subject: [PATCH -next] RDMA/cxgb4: Fix sparse non static symbol warning
Date: Mon, 28 Jul 2014 21:18:33 +0800
Message-ID: <1406553513-29849-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Fixes the following sparse warnings:

drivers/infiniband/hw/cxgb4/device.c:63:5: warning:
 symbol 'c4iw_wr_log_size_order' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
