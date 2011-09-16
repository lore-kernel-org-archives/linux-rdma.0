From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: identify the race condition in this code and win the respect of
 linux-rdma developers!
Date: Fri, 16 Sep 2011 14:51:04 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E5B320@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E5B2B1@ORSMSX101.amr.corp.intel.com>
 <20110916005008.GC6020@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110916005008.GC6020-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Case 1:
> > 	ret = ibv_poll_cq(id->recv_cq, 1, wc);
> > 	ret = ibv_req_notify_cq(id->recv_cq, 0);
> >
> > 	while (!(ret = ibv_poll_cq(id->recv_cq, 1, wc))) {
> > 		ret = ibv_get_cq_event(id->recv_cq_channel, &cq, &context);
> > 		ibv_ack_cq_events(id->recv_cq, 1);
> > 	}
> 
> If ibv_get_cq_event returns here, because the CQ notify triggers but
> poll_cq goes not return a WC then you go back into get_cq_event
> without requesting notification.

I understand this, but I still don't quite see how the situation fully occurs.

> I'm pretty sure ibv_req_notify_cq does nothing if there is already a
> notification pending.

This last statement might be it, but I couldn't see that in the code.  I was under the assumption that once an event occurred, the CQ would be 'un-armed'.  ibv_req_notify_cq() would rearm it.  In the above code then, ibv_get_cq_event() would pull the old event, but then a new one should eventually show up with a corresponding completion.  The flow would be:

poll
rearm
-- completion --
while (poll) -> returns cq entry, but leaves event, cq is not armed?

next test iteration

poll
rearm -> should arm cq
while (poll)
	get_event -> returns previous event
	-- loop back around waiting for new event --

this, of course, isn't happening.  Maybe there's a significant delay between the device writing the CQ entry and generating the event, such that the 2nd rearm doesn't do anything, as you suggest..

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
