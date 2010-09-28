From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: how new GIDs are notified to IB stack in OFED 1.5.1?
Date: Tue, 28 Sep 2010 08:20:48 +0200
Message-ID: <20100928062048.GE26734@mtldesk30>
References: <709363.14225.qm@web30107.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <709363.14225.qm-980OHh/sYqevuULXzWHTWIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 27, 2010 at 10:59:59AM -0700, Parav Pandit wrote:
> Hi,
> 
> So as we know GIDs are based on IPv6 addresses, and GID table entries are updated on the fly when new IPv6 addresses are assigned to eth and vlan based eth interfaces.

The OFED stack supporting IBoE has always supported updating the GID
table caches through generating a LID_CHANGE event. That event is
caught by the ib core (cahche.c) causing it to update its caches.
Recently (OFED-1.5.2) I added a GID_CHANGE event to do just the same.
You can see ibv_asyncwatch for a usage example.

Here's the patch I used to add support at the core level:

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 6888356..660bff5 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -302,7 +302,8 @@ static void ib_cache_event(struct ib_event_handler *handler,
 	    event->event == IB_EVENT_LID_CHANGE  ||
 	    event->event == IB_EVENT_PKEY_CHANGE ||
 	    event->event == IB_EVENT_SM_CHANGE   ||
-	    event->event == IB_EVENT_CLIENT_REREGISTER) {
+	    event->event == IB_EVENT_CLIENT_REREGISTER ||
+	    event->event == IB_EVENT_GID_CHANGE) {
 		work = kmalloc(sizeof *work, GFP_ATOMIC);
 		if (work) {
 			INIT_WORK(&work->work, ib_cache_task);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 597878c..f5b054a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -351,7 +351,8 @@ enum ib_event_type {
 	IB_EVENT_SRQ_ERR,
 	IB_EVENT_SRQ_LIMIT_REACHED,
 	IB_EVENT_QP_LAST_WQE_REACHED,
-	IB_EVENT_CLIENT_REREGISTER
+	IB_EVENT_CLIENT_REREGISTER,
+	IB_EVENT_GID_CHANGE,
 };
 
 enum ib_event_flags {
> 
> How does IB stack will get to know about new GIDs which are added into the table?
> So that query_gid() can be called with right index?
> 
> Regards,
> Parav Pandit
> 
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
