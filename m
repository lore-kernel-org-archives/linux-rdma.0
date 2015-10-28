From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/1] IB/sa: Put netlink request into the request list
 before sending
Date: Wed, 28 Oct 2015 18:11:23 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB185720A5@CRSMSX101.amr.corp.intel.com>
References: <1446039867-27883-1-git-send-email-kaike.wan@intel.com>
 <20151028153949.GA10890@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151028153949.GA10890-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Weiny, Ira
> Sent: Wednesday, October 28, 2015 11:40 AM
> 
> What about using the gfp_mask through this stack?

Can be done.

> 
> I think you need to split ib_nl_send_msg into "create message" and "send
> message".  Then don't add the message to the list unless it is ready to go.
> Then you can get rid of the code below which is removing it on error.

Even if you split it, you can't get rid of the code unless you hold the spinlock because the sending could fail.

> 
> > +	spin_lock_irqsave(&ib_nl_request_lock, flags);
> 
> Do we still need the spin lock?

Yes: to remove it from the list in case of failure or schedule the delayed work.
> 
> >  	if (ret <= 0) {
> >  		ret = -EIO;
> > -		goto request_out;
> > +		/* Remove the request */
> > +		list_del(&query->list);
> 
> Don't need to do this if we split ib_nl_send_msg.

See above.

Kaike
> 
> Ira
> 
> >  	} else {
> >  		ret = 0;
> > +		/* Start the timeout if this is the only request */
> > +		if (ib_nl_request_list.next == &query->list)
> > +			queue_delayed_work(ib_nl_wq, &ib_nl_timed_work,
> delay);
> >  	}
> > -
> > -	delay = msecs_to_jiffies(sa_local_svc_timeout_ms);
> > -	query->timeout = delay + jiffies;
> > -	list_add_tail(&query->list, &ib_nl_request_list);
> > -	/* Start the timeout if this is the only request */
> > -	if (ib_nl_request_list.next == &query->list)
> > -		queue_delayed_work(ib_nl_wq, &ib_nl_timed_work, delay);
> > -
> > -request_out:
> >  	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
> >
> >  	return ret;
> > --
> > 1.7.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
