From: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] staging: rdma: hfi1: Use setup_timer
Date: Sat, 24 Oct 2015 07:59:25 +0530
Message-ID: <1445653765-3236-1-git-send-email-falakreyaz@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use the timer API function setup_timer instead of init_timer, removing
the structure field assignments.

<smpl>

@timer@
expression e1,e2,e3,fn_ptr;
@@
-init_timer(&e1);
+setup_timer(&e1, fn_ptr, e2);
... when != fn_ptr = e3
-e1.function = fn_ptr;
-e1.data = e2;

</smpl>

Signed-off-by: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/sdma.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 63ab721..16d93ff 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -1094,10 +1094,8 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 
 		sde->progress_check_head = 0;
 
-		init_timer(&sde->err_progress_check_timer);
-		sde->err_progress_check_timer.function =
-						sdma_err_progress_check;
-		sde->err_progress_check_timer.data = (unsigned long)sde;
+		setup_timer(&sde->err_progress_check_timer,
+			    sdma_err_progress_check, (unsigned long)sde);
 
 		sde->descq = dma_zalloc_coherent(
 			&dd->pcidev->dev,
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
