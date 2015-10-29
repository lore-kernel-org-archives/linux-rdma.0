From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/1] IB/sa: Put netlink request into the request list
 before sending
Date: Thu, 29 Oct 2015 11:38:41 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB1857215E@CRSMSX101.amr.corp.intel.com>
References: <1446039867-27883-1-git-send-email-kaike.wan@intel.com>
 <20151028164636.GB14310@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151028164636.GB14310-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Wednesday, October 28, 2015 12:47 PM
> 
> >  	ret = ib_nl_send_msg(query);
> > +	spin_lock_irqsave(&ib_nl_request_lock, flags);
> 
> Looks like query could be kfree'd before ib_nl_send_msg returns, eg by
> send_handler?

It's possible only when the request  is successfully sent and a response is received before ib_nl_send_msg returns.  Therefore, we should not touch the request and query if the sending is successfully. However, if the sending fails, we could remove the request from the list.
 
> 
> 
> >  	if (ret <= 0) {
> >  		ret = -EIO;
> > -		goto request_out;
> > +		/* Remove the request */
> > +		list_del(&query->list);
> 
> This one is probably OK iff nl_send_msg cannot call send_handler if it returns
> error, which looks true.

Correct.

> 
> >  	} else {
> >  		ret = 0;
> > +		/* Start the timeout if this is the only request */
> > +		if (ib_nl_request_list.next == &query->list)
> 
> This one looks sketchy. Maybe move this to the first locking block? A extra
> timer on send error is not important enough to worry about..

You are correct. We should move it into the first block.


Kaike
> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
