From: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: Use setup_timer and mod_timer
Date: Sun, 24 Sep 2017 17:21:07 +0530
Message-ID: <1506253867-5132-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use setup_timer and mod_timer API instead of structure assignments.

This is done using Coccinelle and semantic patch used
for this as follows:

@@
expression x,y,z,a,b;
@@

-init_timer (&x);
+setup_timer (&x, y, z);
+mod_timer (&a, b);
-x.function = y;
-x.data = z;
-x.expires = b;
-add_timer(&a);

Signed-off-by: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_driver.c |  8 +++-----
 drivers/infiniband/hw/qib/qib_mad.c    | 10 ++++------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 719906a..2314e8a 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -735,11 +735,9 @@ void qib_set_led_override(struct qib_pportdata *ppd, unsigned int val)
 	 */
 	if (atomic_inc_return(&ppd->led_override_timer_active) == 1) {
 		/* Need to start timer */
-		init_timer(&ppd->led_override_timer);
-		ppd->led_override_timer.function = qib_run_led_override;
-		ppd->led_override_timer.data = (unsigned long) ppd;
-		ppd->led_override_timer.expires = jiffies + 1;
-		add_timer(&ppd->led_override_timer);
+		setup_timer(&ppd->led_override_timer, qib_run_led_override,
+			    (unsigned long)ppd);
+		mod_timer(&ppd->led_override_timer, jiffies + 1);
 	} else {
 		if (ppd->led_override_vals[0] || ppd->led_override_vals[1])
 			mod_timer(&ppd->led_override_timer, jiffies + 1);
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 82d9da9..1237952 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -2478,12 +2478,10 @@ void qib_notify_create_mad_agent(struct rvt_dev_info *rdi, int port_idx)
 
 	/* Initialize xmit_wait structure */
 	dd->pport[port_idx].cong_stats.counter = 0;
-	init_timer(&dd->pport[port_idx].cong_stats.timer);
-	dd->pport[port_idx].cong_stats.timer.function = xmit_wait_timer_func;
-	dd->pport[port_idx].cong_stats.timer.data =
-		(unsigned long)(&dd->pport[port_idx]);
-	dd->pport[port_idx].cong_stats.timer.expires = 0;
-	add_timer(&dd->pport[port_idx].cong_stats.timer);
+	setup_timer(&dd->pport[port_idx].cong_stats.timer,
+		    xmit_wait_timer_func,
+		    (unsigned long)(&dd->pport[port_idx]));
+	mod_timer(&dd->pport[port_idx].cong_stats.timer, 0);
 }
 
 void qib_notify_free_mad_agent(struct rvt_dev_info *rdi, int port_idx)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
