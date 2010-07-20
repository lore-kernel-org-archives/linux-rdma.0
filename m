From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: sense remote hardware address change by rdma-cm applications
Date: Tue, 20 Jul 2010 11:22:04 -0600
Message-ID: <20100720172204.GI7920@obsidianresearch.com>
References: <AANLkTimmWiNqHJIqSEKbY-X6mSx6zA19p__JDYPEmp8b@mail.gmail.com> <20100720001436.GH7920@obsidianresearch.com> <4C454F80.1060808@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C454F80.1060808-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <mshefty-+/W+9+QloQG75v1z/vFq2g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 20, 2010 at 10:25:52AM +0300, Or Gerlitz wrote:

> > So.. I think to tackle this you need to start looking at how the
> > dst_entry structure works in netdev and apply the same idea to RDMA-CM
> > and reflect the changes in AH back to the QP owner.
> 
> I can take a look (pointer would be very much appreciated...) still,
> the dst entry is used for every netdev xmit where here the xmit is
> offloaded, so I don't see what could be really used from the dst
> code, but I might be wrong. The rdma app uses the neighbour once,
> upon address resolving, and I was trying to see if we can ref the
> neighbour so the neigh sub-system probes would keep going even
> though the neighbour is not directly used.

It has been a while since I looked through this .. but, IIRC, the
general idea was that the socket held onto a cached dst and then at
each send it would use that dst to generate the L2 headers. Somehow
the dst would become invalidated when the routing cache was flushed
out.

So, basically, if you can add to RDMA-CM a way to get, hold and re-get
the dst you have solved the first problem, - how do know the current
routing information, and hold onto it, keep it in caches, etc.

The second problem, is how do you get notified that the dst may have
been changed? sockets seem to basically just poll every packet, so you
might need to use some netdev notifications, maybe also a timer?

I'd see a flow like this:
 - in the current route lookup code stash the dst
 - add a function to freshen the dst
 - hook events that might indicate the dst is invalid
 - on event trigger freshen the dst, regenerate the L2 address info
   and compare it to what is already in use
 - If different, send an event to user space.

stashing the dst lets you get back to the L2 information by using the
routing cache, and by holding onto a neighbor reference (in the dst)

Also, while doing this you are going to need to do something to have
the kernel send ND probes to keep the ND entry fresh when the
connection is open. Not sure, but I think this also has something to
do with the DST.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
