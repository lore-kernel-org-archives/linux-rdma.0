From: Sunny Kumar <sunny.kumar.roy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/1] staging: rdma: hfi1 : Prefer using the BIT macro
Date: Thu,  5 Nov 2015 17:28:03 +0530
Message-ID: <1446724683-30092-1-git-send-email-sunnyk@cdac.in>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sunny Kumar <sunnyk-If5XQcfNmg0@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch replaces bit shifting on 1 with the BIT(x) macro

Signed-off-by: Sunny Kumar <sunnyk-If5XQcfNmg0@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_sdma.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 36c838d..95a6d99 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -146,8 +146,8 @@ MODULE_PARM_DESC(sdma_comp_size, "Size of User SDMA completion ring. Default: 12
 #define KDETH_OM_MAX_SIZE  (1 << ((KDETH_OM_LARGE / KDETH_OM_SMALL) + 1))
 
 /* Last packet in the request */
-#define TXREQ_FLAGS_REQ_LAST_PKT   (1 << 0)
-#define TXREQ_FLAGS_IOVEC_LAST_PKT (1 << 0)
+#define TXREQ_FLAGS_REQ_LAST_PKT   BIT(1 << 0)
+#define TXREQ_FLAGS_IOVEC_LAST_PKT BIT(1 << 0)
 
 #define SDMA_REQ_IN_USE     0
 #define SDMA_REQ_FOR_THREAD 1
@@ -156,9 +156,9 @@ MODULE_PARM_DESC(sdma_comp_size, "Size of User SDMA completion ring. Default: 12
 #define SDMA_REQ_HAS_ERROR  4
 #define SDMA_REQ_DONE_ERROR 5
 
-#define SDMA_PKT_Q_INACTIVE (1 << 0)
-#define SDMA_PKT_Q_ACTIVE   (1 << 1)
-#define SDMA_PKT_Q_DEFERRED (1 << 2)
+#define SDMA_PKT_Q_INACTIVE BIT(1 << 0)
+#define SDMA_PKT_Q_ACTIVE   BIT(1 << 1)
+#define SDMA_PKT_Q_DEFERRED BIT(1 << 2)
 
 /*
  * Maximum retry attempts to submit a TX request
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
