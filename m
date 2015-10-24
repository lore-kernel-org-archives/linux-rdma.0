From: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] staging: rdma: ipath: Use setup_timer
Date: Sat, 24 Oct 2015 07:51:31 +0530
Message-ID: <1445653291-2943-1-git-send-email-falakreyaz@gmail.com>
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
 drivers/staging/rdma/ipath/ipath_init_chip.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rdma/ipath/ipath_init_chip.c b/drivers/staging/rdma/ipath/ipath_init_chip.c
index 4aea99c..a5eea19 100644
--- a/drivers/staging/rdma/ipath/ipath_init_chip.c
+++ b/drivers/staging/rdma/ipath/ipath_init_chip.c
@@ -950,9 +950,8 @@ int ipath_init_chip(struct ipath_devdata *dd, int reinit)
 		 * set up stats retrieval timer, even if we had errors
 		 * in last portion of setup
 		 */
-		init_timer(&dd->ipath_stats_timer);
-		dd->ipath_stats_timer.function = ipath_get_faststats;
-		dd->ipath_stats_timer.data = (unsigned long) dd;
+		setup_timer(&dd->ipath_stats_timer, ipath_get_faststats,
+				(unsigned long)dd);
 		/* every 5 seconds; */
 		dd->ipath_stats_timer.expires = jiffies + 5 * HZ;
 		/* takes ~16 seconds to overflow at full IB 4x bandwdith */
@@ -965,9 +964,8 @@ int ipath_init_chip(struct ipath_devdata *dd, int reinit)
 		ret = setup_sdma(dd);
 
 	/* Set up HoL state */
-	init_timer(&dd->ipath_hol_timer);
-	dd->ipath_hol_timer.function = ipath_hol_event;
-	dd->ipath_hol_timer.data = (unsigned long)dd;
+	setup_timer(&dd->ipath_hol_timer, ipath_hol_event, (unsigned long)dd);
+
 	dd->ipath_hol_state = IPATH_HOL_UP;
 
 done:
@@ -988,11 +986,9 @@ done:
 			 * to an alternate if necessary and possible
 			 */
 			if (!reinit) {
-				init_timer(&dd->ipath_intrchk_timer);
-				dd->ipath_intrchk_timer.function =
-					verify_interrupt;
-				dd->ipath_intrchk_timer.data =
-					(unsigned long) dd;
+				setup_timer(&dd->ipath_intrchk_timer,
+						verify_interrupt,
+						(unsigned long)dd);
 			}
 			dd->ipath_intrchk_timer.expires = jiffies + HZ/2;
 			add_timer(&dd->ipath_intrchk_timer);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
