From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: identify the race condition in this code and win the respect
 of linux-rdma developers!
Date: Thu, 15 Sep 2011 18:50:08 -0600
Message-ID: <20110916005008.GC6020@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E5B2B1@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E5B2B1-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 15, 2011 at 11:58:34PM +0000, Hefty, Sean wrote:
> I have a ping-pong test application that loops doing: send, wait for
> send completion, wait for receive completion.  The test occasionally
> hangs in the following code at ibv_get_cq_event() (error handling
> removed):

> Case 1:
> 	ret = ibv_poll_cq(id->recv_cq, 1, wc);
> 	ret = ibv_req_notify_cq(id->recv_cq, 0);
> 
> 	while (!(ret = ibv_poll_cq(id->recv_cq, 1, wc))) {
> 		ret = ibv_get_cq_event(id->recv_cq_channel, &cq, &context);
> 		ibv_ack_cq_events(id->recv_cq, 1);
> 	}

If ibv_get_cq_event returns here, because the CQ notify triggers but
poll_cq goes not return a WC then you go back into get_cq_event
without requesting notification.

I'm pretty sure ibv_req_notify_cq does nothing if there is already a
notification pending.

> Case 3:
> 	ret = ibv_poll_cq(id->recv_cq, 1, wc);
> 	while (1)
> 		ret = ibv_req_notify_cq(id->recv_cq, 0);
> 
> 		ret = ibv_poll_cq(id->recv_cq, 1, wc);
> 		if (ret)
> 			break;
> 		ret = ibv_get_cq_event(id->recv_cq_channel, &cq, &context);
> 		ibv_ack_cq_events(id->recv_cq, 1);
> 	}

Where as this, is correct. The sequence must always be
ibv_req_notify_cq, ibv_poll_cq, ibv_get_cq_event

Case 2 will also fail, but it will be statistically less likely since
you are looking for a WC being added between the poll_cq and
req_notify_cq. While case 1 only requires a run through the loop with
a pending notification but no WC entries.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
