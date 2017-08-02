From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core build environment enabling out-of-core providers
Date: Wed, 2 Aug 2017 10:09:00 -0600
Message-ID: <20170802160900.GB21208@obsidianresearch.com>
References: <007601d30b96$f2408170$d6c18450$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <007601d30b96$f2408170$d6c18450$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 02, 2017 at 08:55:06AM -0500, Steve Wise wrote:

> Currently there is no way to build an out-of-rdma-core provider on a
> system installed with rdma-core.  It would be useful to have
> rdma-core install the needed headers and libs (ie the ccan stuff) as
> part of its install.  This would be similar to previous releases of
> libibverbs that included the headers needed for providers to build.
> I would like to implement this for rdma-core, but wanted feedback on
> this approach.  Maybe an rdma-core-devel type package?  I guess I'm
> thinking this would be analogous to building out-of-kernel modules,
> which is available for kernel developers.

I don't think that really works. eg the util/mmio.h relies on
stdatomic.h to work, which means it relies on the cmake shim to
provide stdatomic.h on old systems. Other private headers may be similar
in their integration with cmake/etc.

You can't really publish those headers sanely, and part of the point
here was specifically to allow using things like statomic.h properly
without having to be concerned about how to install the shim into a
public header.

In my view, the best approach, which I have suggested before, is to
build the out-of-tree stuff 'in-tree' and discard everything except
the single provider library you are building for. For instance, a rpm
spec file that produces as contents a single provider shlib.

This seems like the least amount of work for everyone, and it doesn't
really matter, I think, that the 'source' for the 'provider' carries
lots of unbuilt stuff.

Perhaps the best way to accomplish that is to add a sample rpm spec
file to Documentation/ or something that shows how to do that. If you
want to take a first stab at it I can give you some help.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
