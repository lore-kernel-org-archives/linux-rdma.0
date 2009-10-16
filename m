From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH]  link-local address fix for rdma_resolve_addr
Date: Fri, 16 Oct 2009 13:28:49 -0600
Message-ID: <20091016192849.GX5191@obsidianresearch.com>
References: <1255471781.14513.7.camel@wilder.ibm.com> <20091013231234.GK5191@obsidianresearch.com> <1255537437.14513.28.camel@wilder.ibm.com> <20091014170155.GL5191@obsidianresearch.com> <1255541405.5111.14.camel@wilder.ibm.com> <20091014174017.GM5191@obsidianresearch.com> <1255634841.5111.40.camel@wilder.ibm.com> <20091015213205.GV5191@obsidianresearch.com> <1255719280.14675.30.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1255719280.14675.30.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 16, 2009 at 11:54:39AM -0700, David J. Wilder wrote:

> There is the wrinkle in this plan.  If you pass ip6_route_output() your
> own link-local address (scoped or not) it returns a neighbor entry bound
> to the loop back device.

Well, that really is correct. The RDMA CM could try to do something
smart if lo is returned from the route lookup - ie choose the first
RDMA device bound to that IP or something.

There are other problems with the loop back case, like the Linux stack
doesn't generate neighbor entries for its own IP addresses.

The loopback case is far less important than the other policy routing
features anyhow..

> I will post a patch with our first solution and include the fix to
> addr_resolve_local(). 

May as well, a little bit of progress is better than none at all. 

Also note that I observed that the IPv6 code path never sets the
source address from the routing table if IN6_ADDR_ANY is used as
source, this is certainly wrong and could cause other problems down
the line, probably more so for iwarp than IB though..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
