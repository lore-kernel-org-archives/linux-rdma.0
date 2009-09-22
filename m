From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH/RFC] IB/mad: Fix lock-lock-timer deadlock in RMPP code
Date: Tue, 22 Sep 2009 11:27:25 -0700
Message-ID: <ada7hvq7s36.fsf@cisco.com>
References: <adaws4an4uh.fsf@cisco.com>
	<e2e108260909071327o7f521876s60d643b455e7c6ec@mail.gmail.com>
	<adaskeym5gu.fsf@cisco.com>
	<e2e108260909072325w2e0b4b1na0aa01a74f2341e4@mail.gmail.com>
	<adabpllmk7c.fsf@cisco.com>
	<e2e108260909081209t36bfef12m24ce000686ed116e@mail.gmail.com>
	<adavdjrkfyq.fsf_-_@cisco.com>
	<F658AB9802E54F9887A2753721FA7882@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F658AB9802E54F9887A2753721FA7882-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Wed, 9 Sep 2009 14:22:28 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > The locking is needed to protect against items being removed from rmpp_list in
 > recv_timeout_handler() and recv_cleanup_handler().  No new items should be added
 > to the rmpp_list when ib_cancel_rmpp_recvs() is running (or there's a separate
 > bug).

OK so how about something like this?  Just hold the lock to mark the
items on the list as being canceled, and then actually cancel the
delayed work without the lock.  I think this doesn't leave any races or
holes where the delayed work can mess up the cancel.

diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 57a3c6f..4e0f282 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -37,7 +37,8 @@
 enum rmpp_state {
 	RMPP_STATE_ACTIVE,
 	RMPP_STATE_TIMEOUT,
-	RMPP_STATE_COMPLETE
+	RMPP_STATE_COMPLETE,
+	RMPP_STATE_CANCELING
 };
 
 struct mad_rmpp_recv {
@@ -87,18 +88,22 @@ void ib_cancel_rmpp_recvs(struct ib_mad_agent_private *agent)
 
 	spin_lock_irqsave(&agent->lock, flags);
 	list_for_each_entry(rmpp_recv, &agent->rmpp_list, list) {
+		if (rmpp_recv->state != RMPP_STATE_COMPLETE)
+			ib_free_recv_mad(rmpp_recv->rmpp_wc);
+		rmpp_recv->state = RMPP_STATE_CANCELING;
+	}
+	spin_unlock_irqrestore(&agent->lock, flags);
+
+	list_for_each_entry(rmpp_recv, &agent->rmpp_list, list) {
 		cancel_delayed_work(&rmpp_recv->timeout_work);
 		cancel_delayed_work(&rmpp_recv->cleanup_work);
 	}
-	spin_unlock_irqrestore(&agent->lock, flags);
 
 	flush_workqueue(agent->qp_info->port_priv->wq);
 
 	list_for_each_entry_safe(rmpp_recv, temp_rmpp_recv,
 				 &agent->rmpp_list, list) {
 		list_del(&rmpp_recv->list);
-		if (rmpp_recv->state != RMPP_STATE_COMPLETE)
-			ib_free_recv_mad(rmpp_recv->rmpp_wc);
 		destroy_rmpp_recv(rmpp_recv);
 	}
 }
@@ -260,6 +265,10 @@ static void recv_cleanup_handler(struct work_struct *work)
 	unsigned long flags;
 
 	spin_lock_irqsave(&rmpp_recv->agent->lock, flags);
+	if (rmpp_recv->state == RMPP_STATE_CANCELING) {
+		spin_unlock_irqrestore(&rmpp_recv->agent->lock, flags);
+		return;
+	}
 	list_del(&rmpp_recv->list);
 	spin_unlock_irqrestore(&rmpp_recv->agent->lock, flags);
 	destroy_rmpp_recv(rmpp_recv);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
