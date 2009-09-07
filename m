From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [NEW PATCH] IB/mad: Fix possible lock-lock-timer deadlock
Date: Mon, 07 Sep 2009 08:37:26 -0700
Message-ID: <adaws4an4uh.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A new interface was added to the core workqueue API to make handling
cancel_delayed_work() deadlocks easier, so a simpler fix for bug 13757
as below becomes possible.  Bart, it would be great if you could retest
this, since it is what I am planning on sending upstream for 2.6.31.
(This patch depends on 4e49627b, "workqueues: introduce
__cancel_delayed_work()", which was merged for 2.6.31-rc9; alternatively
my for-next branch is now rebased on top of -rc9 and has this patch plus
everything else queued for 2.6.32).

Thanks,
  Roland


Lockdep reported a possible deadlock with cm_id_priv->lock,
mad_agent_priv->lock and mad_agent_priv->timed_work.timer; this
happens because the mad module does

	cancel_delayed_work(&mad_agent_priv->timed_work);

while holding mad_agent_priv->lock.  cancel_delayed_work() internally
does del_timer_sync(&mad_agent_priv->timed_work.timer).

This can turn into a deadlock because mad_agent_priv->lock is taken
inside cm_id_priv->lock, so we can get the following set of contexts
that deadlock each other:

 A: holding cm_id_priv->lock, waiting for mad_agent_priv->lock
 B: holding mad_agent_priv->lock, waiting for del_timer_sync()
 C: interrupt during mad_agent_priv->timed_work.timer that takes
    cm_id_priv->lock

Fix this by using the new __cancel_delayed_work() interface (which
internally does del_timer() instead of del_timer_sync()) in all the
places where we are holding a lock.

Addresses: http://bugzilla.kernel.org/show_bug.cgi?id=13757
Reported-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index de922a0..bc30c00 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1974,7 +1974,7 @@ static void adjust_timeout(struct ib_mad_agent_private *mad_agent_priv)
 	unsigned long delay;
 
 	if (list_empty(&mad_agent_priv->wait_list)) {
-		cancel_delayed_work(&mad_agent_priv->timed_work);
+		__cancel_delayed_work(&mad_agent_priv->timed_work);
 	} else {
 		mad_send_wr = list_entry(mad_agent_priv->wait_list.next,
 					 struct ib_mad_send_wr_private,
@@ -1983,7 +1983,7 @@ static void adjust_timeout(struct ib_mad_agent_private *mad_agent_priv)
 		if (time_after(mad_agent_priv->timeout,
 			       mad_send_wr->timeout)) {
 			mad_agent_priv->timeout = mad_send_wr->timeout;
-			cancel_delayed_work(&mad_agent_priv->timed_work);
+			__cancel_delayed_work(&mad_agent_priv->timed_work);
 			delay = mad_send_wr->timeout - jiffies;
 			if ((long)delay <= 0)
 				delay = 1;
@@ -2023,7 +2023,7 @@ static void wait_for_response(struct ib_mad_send_wr_private *mad_send_wr)
 
 	/* Reschedule a work item if we have a shorter timeout */
 	if (mad_agent_priv->wait_list.next == &mad_send_wr->agent_list) {
-		cancel_delayed_work(&mad_agent_priv->timed_work);
+		__cancel_delayed_work(&mad_agent_priv->timed_work);
 		queue_delayed_work(mad_agent_priv->qp_info->port_priv->wq,
 				   &mad_agent_priv->timed_work, delay);
 	}
-- 
1.6.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
