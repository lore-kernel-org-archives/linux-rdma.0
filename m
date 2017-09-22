From: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/8] infiniband: qib: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:57:16 +0530
Message-ID: <1506076036-16496-9-git-send-email-allen.lkml@gmail.com>
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
 drivers/infiniband/hw/qib/qib_mad.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 82d9da9..f3d4511 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -2478,10 +2478,9 @@ void qib_notify_create_mad_agent(struct rvt_dev_info *rdi, int port_idx)
 
 	/* Initialize xmit_wait structure */
 	dd->pport[port_idx].cong_stats.counter = 0;
-	init_timer(&dd->pport[port_idx].cong_stats.timer);
-	dd->pport[port_idx].cong_stats.timer.function = xmit_wait_timer_func;
-	dd->pport[port_idx].cong_stats.timer.data =
-		(unsigned long)(&dd->pport[port_idx]);
+	setup_timer(&dd->pport[port_idx].cong_stats.timer,
+		    xmit_wait_timer_func,
+		    (unsigned long)(&dd->pport[port_idx]));
 	dd->pport[port_idx].cong_stats.timer.expires = 0;
 	add_timer(&dd->pport[port_idx].cong_stats.timer);
 }
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
