From: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH] IB/hfi1: use TASK_COMM_LEN in hfi1_ctxtdata
Date: Thu,  8 Oct 2015 22:04:26 -0700
Message-ID: <d18008076bca0bf3f06ebd8c76bc71c0e2019517.1444394307.git.geliangtang@163.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use comm[TASK_COMM_LEN] instead of comm[16].

Signed-off-by: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
---
 drivers/staging/rdma/hfi1/hfi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 8ca171b..a35213e 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -262,7 +262,7 @@ struct hfi1_ctxtdata {
 	pid_t pid;
 	pid_t subpid[HFI1_MAX_SHARED_CTXTS];
 	/* same size as task_struct .comm[], command that opened context */
-	char comm[16];
+	char comm[TASK_COMM_LEN];
 	/* so file ops can get at unit */
 	struct hfi1_devdata *dd;
 	/* so functions that need physical port can get it easily */
-- 
1.9.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
