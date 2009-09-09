From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH/RFC] IB/mad: Fix lock-lock-timer deadlock in RMPP code (was: [NEW PATCH] IB/mad: Fix possible lock-lock-timer deadlock)
Date: Wed, 09 Sep 2009 13:42:21 -0700
Message-ID: <adavdjrkfyq.fsf_-_@cisco.com>
References: <adaws4an4uh.fsf@cisco.com>
	<e2e108260909071327o7f521876s60d643b455e7c6ec@mail.gmail.com>
	<adaskeym5gu.fsf@cisco.com>
	<e2e108260909072325w2e0b4b1na0aa01a74f2341e4@mail.gmail.com>
	<adabpllmk7c.fsf@cisco.com>
	<e2e108260909081209t36bfef12m24ce000686ed116e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260909081209t36bfef12m24ce000686ed116e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Tue, 8 Sep 2009 21:09:42 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Holding agent->lock across cancel_delayed_work() (which does
del_timer_sync()) in ib_cancel_rmpp_recvs() leads to lockdep reports of
possible lock-timer deadlocks if a consumer ever does something that
connects agent->lock to a lock taken in IRQ context (cf
http://marc.info/?l=linux-rdma&m=125243699026045).

However, it seems this locking is not necessary here, since the locking
did not prevent the rmpp_list from having an item added immediately
after the lock is dropped -- so there must be sufficient synchronization
protecting the rmpp_list without the locking here.  Therefore, we can
fix the lockdep issue by simply deleting the locking.


Hal/Sean, does this look right to you?
---
 drivers/infiniband/core/mad_rmpp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 57a3c6f..865c109 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -85,12 +85,10 @@ void ib_cancel_rmpp_recvs(struct ib_mad_agent_private *agent)
 	struct mad_rmpp_recv *rmpp_recv, *temp_rmpp_recv;
 	unsigned long flags;
 
-	spin_lock_irqsave(&agent->lock, flags);
 	list_for_each_entry(rmpp_recv, &agent->rmpp_list, list) {
 		cancel_delayed_work(&rmpp_recv->timeout_work);
 		cancel_delayed_work(&rmpp_recv->cleanup_work);
 	}
-	spin_unlock_irqrestore(&agent->lock, flags);
 
 	flush_workqueue(agent->qp_info->port_priv->wq);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
