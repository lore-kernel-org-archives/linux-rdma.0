From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Fri, 11 Sep 2015 12:21:15 -0600
Message-ID: <20150911182115.GA546@obsidianresearch.com>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
 <alpine.DEB.2.11.1509110920540.16357@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1509110920540.16357-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 11, 2015 at 09:40:25AM -0500, Christoph Lameter wrote:
> On Thu, 10 Sep 2015, Doug Ledford wrote:
> 
> > +		 * 1) ifdown/ifup
> > +		 * 2) a regular mcast join/leave happens and we run
> > +		 *    ipoib_mcast_restart_task
> > +		 * 3) a REREGISTER event comes in from the SM
> > +		 * 4) any other event that might cause a mcast flush
> 
> Could we have a timeout and leave the multicast group on process
> exit?

At a minimum, when the socket that did the send closes the send-only
could be de-refed..

But really send-only in IB is very similar to neighbour discovery, and
should work the same, with a timer, etc. In my mind it would be ideal
to even add them to the ND table, if the core would support that..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
