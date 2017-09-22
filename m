From: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/8] infiniband: qib: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:57:09 +0530
Message-ID: <1506076036-16496-2-git-send-email-allen.lkml@gmail.com>
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
 drivers/infiniband/hw/qib/qib_sd7220.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_sd7220.c b/drivers/infiniband/hw/qib/qib_sd7220.c
index c72775f..525b516 100644
--- a/drivers/infiniband/hw/qib/qib_sd7220.c
+++ b/drivers/infiniband/hw/qib/qib_sd7220.c
@@ -1440,9 +1440,8 @@ void set_7220_relock_poll(struct qib_devdata *dd, int ibup)
 		/* If timer has not yet been started, do so. */
 		if (!cs->relock_timer_active) {
 			cs->relock_timer_active = 1;
-			init_timer(&cs->relock_timer);
-			cs->relock_timer.function = qib_run_relock;
-			cs->relock_timer.data = (unsigned long) dd;
+			setup_timer(&cs->relock_timer, qib_run_relock,
+				    (unsigned long)dd);
 			cs->relock_interval = timeout;
 			cs->relock_timer.expires = jiffies + timeout;
 			add_timer(&cs->relock_timer);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
