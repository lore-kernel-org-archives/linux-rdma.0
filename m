From: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4 v2] staging: ipath: ipath_driver: Use setup_timer
Date: Sun, 25 Oct 2015 15:47:30 +0530
Message-ID: <1445768253-16107-1-git-send-email-falakreyaz@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use the timer API function setup_timer instead of init_timer, removing
the structure field assignments.
The simplified semantic patch used is :-
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
v2 changes:
	-> Change the subject line to a be more specific
	-> Add details about coccinelle in the commit log

mfrw

 drivers/staging/rdma/ipath/ipath_driver.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/ipath/ipath_driver.c b/drivers/staging/rdma/ipath/ipath_driver.c
index 46d9898..577704a 100644
--- a/drivers/staging/rdma/ipath/ipath_driver.c
+++ b/drivers/staging/rdma/ipath/ipath_driver.c
@@ -2307,10 +2307,9 @@ void ipath_set_led_override(struct ipath_devdata *dd, unsigned int val)
 	 */
 	if (atomic_inc_return(&dd->ipath_led_override_timer_active) == 1) {
 		/* Need to start timer */
-		init_timer(&dd->ipath_led_override_timer);
-		dd->ipath_led_override_timer.function =
-						 ipath_run_led_override;
-		dd->ipath_led_override_timer.data = (unsigned long) dd;
+		setup_timer(&dd->ipath_led_override_timer,
+				ipath_run_led_override, (unsigned long)dd);
+
 		dd->ipath_led_override_timer.expires = jiffies + 1;
 		add_timer(&dd->ipath_led_override_timer);
 	} else
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
