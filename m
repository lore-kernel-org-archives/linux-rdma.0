From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: identify the race condition in this code and win the respect
 of linux-rdma developers!
Date: Fri, 16 Sep 2011 09:59:55 -0600
Message-ID: <20110916155955.GA18548@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E5B2B1@ORSMSX101.amr.corp.intel.com>
 <20110916005008.GC6020@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237316E5B320@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E5B320-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 16, 2011 at 02:51:04PM +0000, Hefty, Sean wrote:
> > > Case 1:
> > > 	ret = ibv_poll_cq(id->recv_cq, 1, wc);
> > > 	ret = ibv_req_notify_cq(id->recv_cq, 0);
> > >
> > > 	while (!(ret = ibv_poll_cq(id->recv_cq, 1, wc))) {
> > > 		ret = ibv_get_cq_event(id->recv_cq_channel, &cq, &context);
> > > 		ibv_ack_cq_events(id->recv_cq, 1);
> > > 	}
> > 
> > If ibv_get_cq_event returns here, because the CQ notify triggers but
> > poll_cq goes not return a WC then you go back into get_cq_event
> > without requesting notification.
> 
> I understand this, but I still don't quite see how the situation fully occurs.
> 
> > I'm pretty sure ibv_req_notify_cq does nothing if there is already a
> > notification pending.
> 
> This last statement might be it, but I couldn't see that in the
> code.  I was under the assumption that once an event occurred, the
> CQ would be 'un-armed'.  ibv_req_notify_cq() would rearm it.  In the
> above code then, ibv_get_cq_event() would pull the old event, but
> then a new one should eventually show up with a corresponding
> completion.  The flow would be:

As I see it the problem flow would be this:

poll
ibv_req_notify_cq
// HCA Write CQ Entry
// Trigger EVENT
poll -> return CQ

poll
ibv_req_notify_cq // does nothing, event is already triggered
poll
ibv_get_cq_event // returns immediately due to prior Trigger event
poll
ibv_get_cq_event // blocks because the CQ was never rearmed.

Which would happen easily and frequently without having to invoke any
spooky infrequent racing.

poll and cq_events are totally independent, I belive the implementation
of CQ events is like:

enum {DISABLED,ARMED,TRIGGERED} flag;

And the only sane, race free implementation of req_notify must thus be

if (flag == DISABLED) flag = ARMED

And for CQ entry add:
if (flag == ARMED) flag = TRIGGERED

And for get_cq_event:

if (flag == TRIGGERED) {flag = DISABLED; return;}

What you are imagining is that ibv_req_notify_cq does this:

if (flag == ARMED || flag == TRIGGERED) flag = ARMED

which is not a good choice because it will destroy a triggered state
and that creates all sorts of bad race conditions, again because of
the independence of poll and cq_event.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
