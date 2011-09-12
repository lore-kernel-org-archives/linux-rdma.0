From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] An argument for allowing applications to manually send
 RMPP packets if desired
Date: Mon, 12 Sep 2011 11:23:35 -0600
Message-ID: <20110912172334.GC18574@obsidianresearch.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A5387E899@MNEXMB1.qlogic.org>
 <CAL1RGDUXM9-Ey1aF8xQo3X_L1PLrVyyLPYvqmy6Qeu5M2JnJPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDUXM9-Ey1aF8xQo3X_L1PLrVyyLPYvqmy6Qeu5M2JnJPA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 12, 2011 at 10:15:08AM -0700, Roland Dreier wrote:
> > But is this really needed? Consider that these 3,000 replies only
> > differ in their destination addresses - the actual data is
> > identical in all of them.  Moreover, the data returned for a query
> > like this changes only rarely in a production fabric - which means
> > that the response could be generated once and then and then
> > re-used to provide responses to multiple clients.
> >
> > To allow this, however, the SM must be allowed to explicitly
> > manage its own RMPP transmissions instead of sending each response
> > as a complete unit. If this is allowed, then the kernel no longer
> > needs to allocate large amounts of buffer space, and the SM can
> > build the results of certain queries in advance, updating them
> > only when the fabric changes, instead of recreating them each time
> > it receives an IB_MAD_METHOD_GET_TABLE.
> 
> It seems at least the SM side could be handled using writev() to
> splice together the data it wants to send.

How does that help avoid the kernel memory allocations?

I think having the option for RMPP in user space is a good idea, it
allows much more efficiency on the SM side..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
