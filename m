From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core build environment enabling out-of-core providers
Date: Thu, 3 Aug 2017 08:47:33 -0600
Message-ID: <20170803144733.GA13127@obsidianresearch.com>
References: <007601d30b96$f2408170$d6c18450$@opengridcomputing.com>
 <20170802160900.GB21208@obsidianresearch.com>
 <019001d30bc3$cc6648e0$6532daa0$@opengridcomputing.com>
 <44b511c6-45fa-d5aa-4d4c-e47d2edcf604@suse.de>
 <008401d30c5f$3c9e2560$b5da7020$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <008401d30c5f$3c9e2560$b5da7020$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Nicolas Morey-Chaisemartin' <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 03, 2017 at 08:48:50AM -0500, Steve Wise wrote:

> > I 'm not sure I see the issue here (or at least nothing easily
> > fixed).  If the standard spec produces an extra
> > rdma-core-provider-devel with those headers, it's just a matter of
> > rebuilding the out-of-tree provider against the right
> > distro/package.
> 
> After thinking about this more, I agree: If rdma-core is built into
> binary platform and distro-specific rpms, then these header files
> are definitely available to export as a -devel rpm for that same
> platform/distro.

The issue is where do you put headers like stdatomic.h, config.h, etc.

These headers will collide with normal headers in various cases..

It is designed to be built with a private include/ that relies on
#include_next to make everything work out, you cannot just dump the
headers in /usr/include.

If instead you do something like /usr/share/rdma-core/include then you
still have the problem of conflicting with common user header names
like config.h, and the problem of being matched exactly to the
compiler that cmake was using when it made the headers.

Overall it is a very fragile approach..

There are also minor issues like actually building and linking the
provider correctly, there were many issues there pre-rdma-core,
building it outside the existing cmake framework means someone else
has to actually understand how to do this properly :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
