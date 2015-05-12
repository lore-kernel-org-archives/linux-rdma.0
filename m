From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/5] IB/core: Formalize the creation of immutable per
 port data within the ib_device object
Date: Tue, 12 May 2015 16:17:55 -0600
Message-ID: <20150512221755.GA9162@obsidianresearch.com>
References: <1431395218-27693-1-git-send-email-ira.weiny@intel.com>
 <1431395218-27693-3-git-send-email-ira.weiny@intel.com>
 <20150512192109.GC3503@obsidianresearch.com>
 <20150512210225.GA7341@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150512210225.GA7341-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 12, 2015 at 05:02:25PM -0400, ira.weiny wrote:

> > some values don't fill anything, leaving garbage? So, is the array
> > size wrong, or what is going on here?
> 
> The port_immutable array is indexed based on the port number.  So on an HCA 0
> is invalid.  On a switch 1 is invalid.

Again, use start_port/end_port

kzalloc(sizeof(..)*(end_port(xx) + 1));
for (i = start_port(xx); i < end_port(xx); ++i)

Then it is not so tortured..

> > Lets just have the core swap in this generic function if it detects
> > the port_immutable function pointer is null. Then this patch doesn't
> > have to update drivers.
> 
> Ignoring based on other comment.

Maybe think about if there is 0 gid/pkey_tbl_len then do the
query_port automatically in the core code, that would purge alot of
boiler plate in the drivers.

Moving the tbl_len's out of query_port is a future clean up.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
