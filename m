From: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] staging: rdma: hfi1: Use setup_timer
Date: Sat, 24 Oct 2015 07:58:05 +0530
Message-ID: <1445653685-3137-1-git-send-email-falakreyaz@gmail.com>
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
 drivers/staging/rdma/hfi1/chip.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 46ebc38..c403957 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -2215,9 +2215,7 @@ static void update_rcverr_timer(unsigned long opaque)
 
 static int init_rcverr(struct hfi1_devdata *dd)
 {
-	init_timer(&dd->rcverr_timer);
-	dd->rcverr_timer.function = update_rcverr_timer;
-	dd->rcverr_timer.data = (unsigned long) dd;
+	setup_timer(&dd->rcverr_timer, update_rcverr_timer, (unsigned long)dd);
 	/* Assume the hardware counter has been reset */
 	dd->rcv_ovfl_cnt = 0;
 	return mod_timer(&dd->rcverr_timer, jiffies + HZ * RCVERR_CHECK_TIME);
@@ -8156,9 +8154,8 @@ static int init_cntrs(struct hfi1_devdata *dd)
 	struct hfi1_pportdata *ppd;
 
 	/* set up the stats timer; the add_timer is done at the end */
-	init_timer(&dd->synth_stats_timer);
-	dd->synth_stats_timer.function = update_synth_timer;
-	dd->synth_stats_timer.data = (unsigned long) dd;
+	setup_timer(&dd->synth_stats_timer, update_synth_timer,
+		    (unsigned long)dd);
 
 	/***********************/
 	/* per device counters */
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
