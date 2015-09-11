From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Fri, 11 Sep 2015 12:39:31 -0600
Message-ID: <20150911183931.GB546@obsidianresearch.com>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 10, 2015 at 09:21:05PM -0400, Doug Ledford wrote:
> During the recent rework of the mcast handling in ipoib, the join
> task for regular and send-only joins were merged.  In the old code,
> the comments indicated that the ipoib driver didn't send enough
> information to auto-create IB multicast groups when the join was a
> send-only join.  The reality is that the comments said we didn't, but
> we actually did.  Since we merged the two join tasks, we now follow
> the comments and don't auto-create IB multicast groups for an ipoib
> send-only multicast join.  This has been reported to cause problems
> in certain environments that rely on this behavior.  Specifically,
> if you have an IB <-> Ethernet gateway then there is a fundamental
> mismatch between the methodologies used on the two fabrics.  On
> Ethernet, an app need not subscribe to a multicast group, merely
> listen.

This should probably be clarified. On all IP networks IGMP/MLD is used
to advertise listeners.

A IB/Eth gateway is a router, and IP routers are expected to process
IGMP - so the gateway certainly can (and maybe must) be copying
groups declared with IGMP from the eth side into listeners on IB MGIDs

We may also be making a mistake in IPoIB - if the send side MGID join
fails, the send should probably go to the broadcast, and the join
retried from time to time. This would at least let the gateway
optimize a bit more by only creating groups in active use.

That would emulate the ethernet philosophy of degrade to broadcast.

TBH, fixing broken gateway devices by sending to broadcast appeals to
me more than making a module option..

> on the IB side of the gateway.  There are instances of installations
> with 100's (maybe 1000's) of multicast groups where static creation
> of all the groups is not practical that rely upon the send-only

With my last patch the SM now has enough information to auto-create
the wonky send-only join attempts, if wanted to. It just needs to fill
in tclass, so it certainly is possible to address this long term
without a kernel patch.

> joins creating the IB multicast group in order to function, so to
> preserve these existing installations, add a module option to the
> ipoib module to restore the previous behavior.

.. but an option to restore behavior of an older kernel version makes
sense - did we really have a kernel that completely converted a
send-only join to full join&create?

> +		 * An additional problem is that if we auto-create the IB
> +		 * mcast group in response to a send-only action, then we
> +		 * will be the creating entity, but we will not have any
> +		 * mechanism by which we will track when we should leave
> +		 * the group ourselves.  We will occasionally leave and
> +		 * re-join the group when these events occur:

I would drop the langauge of creating-entity, that isn't something
from the IBA.

The uncontrolled lifetime of the join is not related to creating or
not.

> +		 * 2) a regular mcast join/leave happens and we run
> +		 *    ipoib_mcast_restart_task

Really? All send only mgids are discarded at that point? Ugly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
