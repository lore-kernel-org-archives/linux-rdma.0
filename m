From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Fri, 11 Sep 2015 14:38:20 -0600
Message-ID: <20150911203820.GA19161@obsidianresearch.com>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
 <20150911183931.GB546@obsidianresearch.com>
 <55F3350D.6090002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55F3350D.6090002-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 11, 2015 at 04:09:49PM -0400, Doug Ledford wrote:
> On 09/11/2015 02:39 PM, Jason Gunthorpe wrote:
> > On Thu, Sep 10, 2015 at 09:21:05PM -0400, Doug Ledford wrote:
> >> During the recent rework of the mcast handling in ipoib, the join
> >> task for regular and send-only joins were merged.  In the old code,
> >> the comments indicated that the ipoib driver didn't send enough
> >> information to auto-create IB multicast groups when the join was a
> >> send-only join.  The reality is that the comments said we didn't, but
> >> we actually did.  Since we merged the two join tasks, we now follow
> >> the comments and don't auto-create IB multicast groups for an ipoib
> >> send-only multicast join.  This has been reported to cause problems
> >> in certain environments that rely on this behavior.  Specifically,
> >> if you have an IB <-> Ethernet gateway then there is a fundamental
> >> mismatch between the methodologies used on the two fabrics.  On
> >> Ethernet, an app need not subscribe to a multicast group, merely
> >> listen.
> > 
> > This should probably be clarified. On all IP networks IGMP/MLD is used
> > to advertise listeners.
> > 
> > A IB/Eth gateway is a router, and IP routers are expected to process
> > IGMP - so the gateway certainly can (and maybe must) be copying
> > groups declared with IGMP from the eth side into listeners on IB MGIDs
> 
> Obviously, the gateway in question currently is not doing this.

Sure, my remark was the clarify the commit comment so people don't think
this is OK/expected behavior from a gateway.

> We could drop the queue backlog entirely and just send to broadcast
> when the multicast group is unsubscribed.

I'm pretty sure that would upset the people who care about this
stuff.. Steady state operation has to eventually move to the optimal
MLID.

> Well, we've already established that the gateway device might be well be
> broken.  That makes one wonder if this will work or if it might be
> broken too.

If it isn't subscribed to the broadcast MLID, it is violating MUST
statements in the RFC...

> and so this has been happening since forever in OFED (the above is from
> 1.5.4.1).

But has this has been dropped from the new 3.x series that track
upstream exactly?

> our list we add.  Because the sendonly groups are not tracked at the net
> core level, our only option is to move them all to the remove list and
> when we get another sendonly packet, rejoin.  Unless we want them to
> stay around forever.  But since they aren't real send-only joins, they
> are full joins where we simply ignore the incoming data, leaving them
> around seems a bad idea.

It doesn't make any sense to work like that. As is, the send-only
side looks pretty messed up to me.

It really needs to act like ND, and yah, that is a big change.

Just to be clear, I'm not entirely opposed to an OFED compatability
module option, but lets understand how this is broken, what the fix is
we want to see for mainline and why the OFED 'solution' is not
acceptable for mainline.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
