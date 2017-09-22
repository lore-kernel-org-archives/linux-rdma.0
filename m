From: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/8] infiniband: qib: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:57:14 +0530
Message-ID: <1506076036-16496-7-git-send-email-allen.lkml@gmail.com>
References: <1506076036-16496-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506076036-16496-1-git-send-email-allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_driver.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 719906a..6dfcc4f 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -735,9 +735,8 @@ void qib_set_led_override(struct qib_pportdata *ppd, unsigned int val)
 	 */
 	if (atomic_inc_return(&ppd->led_override_timer_active) == 1) {
 		/* Need to start timer */
-		init_timer(&ppd->led_override_timer);
-		ppd->led_override_timer.function = qib_run_led_override;
-		ppd->led_override_timer.data = (unsigned long) ppd;
+		setup_timer(&ppd->led_override_timer, qib_run_led_override,
+			    (unsigned long)ppd);
 		ppd->led_override_timer.expires = jiffies + 1;
 		add_timer(&ppd->led_override_timer);
 	} else {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
