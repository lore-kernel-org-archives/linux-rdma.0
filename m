From: Vaishali Thakkar <vthakkar1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] IB/ipatch: Use setup_timer and mod_timer
Date: Wed, 4 Mar 2015 13:26:14 +0530
Message-ID: <20150304075614.GA7854@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use timer API functions setup_timer and mod_timer instead
of structure assignments as they are standard way to set
the timer and to update the expire field of an active timer
respectively.

This is done using Coccinelle and semantic patch used for
this is as follows:

// <smpl>
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
// </smpl>

Signed-off-by: Vaishali Thakkar <vthakkar1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
	- Add useful comments which were removed in
	  v1

 drivers/infiniband/hw/ipath/ipath_driver.c    | 9 +++------
 drivers/infiniband/hw/ipath/ipath_init_chip.c | 8 +++-----
 drivers/infiniband/hw/ipath/ipath_verbs.c     | 7 ++-----
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index bd0caed..7c5968a 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -2300,12 +2300,9 @@ void ipath_set_led_override(struct ipath_devdata *dd, unsigned int val)
 	 */
 	if (atomic_inc_return(&dd->ipath_led_override_timer_active) == 1) {
 		/* Need to start timer */
-		init_timer(&dd->ipath_led_override_timer);
-		dd->ipath_led_override_timer.function =
-						 ipath_run_led_override;
-		dd->ipath_led_override_timer.data = (unsigned long) dd;
-		dd->ipath_led_override_timer.expires = jiffies + 1;
-		add_timer(&dd->ipath_led_override_timer);
+		setup_timer(&dd->ipath_led_override_timer,
+			     ipath_run_led_override, (unsigned long)dd);
+		mod_timer(&dd->ipath_led_override_timer, jiffies + 1);
 	} else
 		atomic_dec(&dd->ipath_led_override_timer_active);
 }
diff --git a/drivers/infiniband/hw/ipath/ipath_init_chip.c b/drivers/infiniband/hw/ipath/ipath_init_chip.c
index be2a60e..f59ca1b 100644
--- a/drivers/infiniband/hw/ipath/ipath_init_chip.c
+++ b/drivers/infiniband/hw/ipath/ipath_init_chip.c
@@ -950,13 +950,11 @@ int ipath_init_chip(struct ipath_devdata *dd, int reinit)
 		 * set up stats retrieval timer, even if we had errors
 		 * in last portion of setup
 		 */
-		init_timer(&dd->ipath_stats_timer);
-		dd->ipath_stats_timer.function = ipath_get_faststats;
-		dd->ipath_stats_timer.data = (unsigned long) dd;
+		setup_timer(&dd->ipath_stats_timer, ipath_get_faststats,
+			    (unsigned long)dd);
 		/* every 5 seconds; */
-		dd->ipath_stats_timer.expires = jiffies + 5 * HZ;
+		mod_timer(&dd->ipath_stats_timer, jiffies + 5 * HZ);
 		/* takes ~16 seconds to overflow at full IB 4x bandwdith */
-		add_timer(&dd->ipath_stats_timer);
 		dd->ipath_stats_timer_active = 1;
 	}
 
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 44ea939..41929ea 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1952,11 +1952,8 @@ static int enable_timer(struct ipath_devdata *dd)
 				 dd->ipath_gpio_mask);
 	}
 
-	init_timer(&dd->verbs_timer);
-	dd->verbs_timer.function = __verbs_timer;
-	dd->verbs_timer.data = (unsigned long)dd;
-	dd->verbs_timer.expires = jiffies + 1;
-	add_timer(&dd->verbs_timer);
+	setup_timer(&dd->verbs_timer, __verbs_timer, (unsigned long)dd);
+	mod_timer(&dd->verbs_timer, jiffies + 1);
 
 	return 0;
 }
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
