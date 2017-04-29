From: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] IB/i40iw: use setup_timer
Date: Sat, 29 Apr 2017 09:37:28 +0800
Message-ID: <d2a4d5220abf014f8e5629a7217eaa71262199fd.1493188028.git.geliangtang@gmail.com>
References: <9DD61F30A802C4429A01CA4200E302A730314A7F@fmsmsx116.amr.corp.intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A730314A7F-5FK+k9557ZBZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
 - use setup_timer() in i40iw_terminate_start_timer().
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c    |  5 ++---
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 10 ++++------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 95a0586..f3bc01b 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -3184,9 +3184,8 @@ void i40iw_setup_cm_core(struct i40iw_device *iwdev)
 	INIT_LIST_HEAD(&cm_core->connected_nodes);
 	INIT_LIST_HEAD(&cm_core->listen_nodes);
 
-	init_timer(&cm_core->tcp_timer);
-	cm_core->tcp_timer.function = i40iw_cm_timer_tick;
-	cm_core->tcp_timer.data = (unsigned long)cm_core;
+	setup_timer(&cm_core->tcp_timer, i40iw_cm_timer_tick,
+		    (unsigned long)cm_core);
 
 	spin_lock_init(&cm_core->ht_lock);
 	spin_lock_init(&cm_core->listen_list_lock);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index 70c3e9e..409a378 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -844,10 +844,9 @@ void i40iw_terminate_start_timer(struct i40iw_sc_qp *qp)
 
 	iwqp = (struct i40iw_qp *)qp->back_qp;
 	i40iw_add_ref(&iwqp->ibqp);
-	init_timer(&iwqp->terminate_timer);
-	iwqp->terminate_timer.function = i40iw_terminate_timeout;
+	setup_timer(&iwqp->terminate_timer, i40iw_terminate_timeout,
+		    (unsigned long)iwqp);
 	iwqp->terminate_timer.expires = jiffies + HZ;
-	iwqp->terminate_timer.data = (unsigned long)iwqp;
 	add_timer(&iwqp->terminate_timer);
 }
 
@@ -1436,9 +1435,8 @@ void i40iw_hw_stats_start_timer(struct i40iw_sc_vsi *vsi)
 {
 	struct i40iw_vsi_pestat *devstat = vsi->pestat;
 
-	init_timer(&devstat->stats_timer);
-	devstat->stats_timer.function = i40iw_hw_stats_timeout;
-	devstat->stats_timer.data = (unsigned long)vsi;
+	setup_timer(&devstat->stats_timer, i40iw_hw_stats_timeout,
+		    (unsigned long)vsi);
 	mod_timer(&devstat->stats_timer,
 		  jiffies + msecs_to_jiffies(STATS_TIMER_DELAY));
 }
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
