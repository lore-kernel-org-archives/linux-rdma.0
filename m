From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: sense remote hardware address change by rdma-cm applications
Date: Mon, 19 Jul 2010 18:14:36 -0600
Message-ID: <20100720001436.GH7920@obsidianresearch.com>
References: <AANLkTimmWiNqHJIqSEKbY-X6mSx6zA19p__JDYPEmp8b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimmWiNqHJIqSEKbY-X6mSx6zA19p__JDYPEmp8b-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <mshefty-+/W+9+QloQG75v1z/vFq2g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 20, 2010 at 12:42:06AM +0300, Or Gerlitz wrote:
> Today, the kernel neighbouring maintainance state-machine / engine
> doesn't come into play for neighbours created on behalf of rdma-cm
> consumers. This is b/c the send path is offloaded away from the
> network-stack to the app QP, and as such the neighbour created
> follwing the ARP request / reply initiated by rdma_resolve_address is
> quickly getting aged and deleted, am I correct in that?

It is a bit wider problem than just ND entries, changes in routing can
also alter the L2 address, so that needs to be tracked as well. 

Bit of a rat hole unfortunately, this is back to original criticisms
from netdev of this whole seperated stack idea - it isn't integrated,
so where do you draw the line? What gets left out?

Today, it is pretty clear that only the CM portion integrates at all
with netdev and after that things are separate.

So.. I think to tackle this you need to start looking at how the
dst_entry structure works in netdev and apply the same idea to RDMA-CM
and reflect the changes in AH back to the QP owner.

Basically, holding the ND and route structure should work identically
to TCP, not be different and half baked. If you recall Sean recently
put through a big patch set fixing this kind of divergance in the
route lookup area.. Doing anything different from TCP should be well
and completely justified.

Is this an iwarp problem too? Not sure how L3->L2 translation works
there.

> This behaviour makes rdma-cm RC apps to sense remote hardware address
> change based only on the RC QP timeout, where UD  apps have no way
> other then implementing some sort of keep-alive / probing mechanism to
> make sure their AH is valid,  so how about

Not sure what you do about UD.. Maybe RDMA-CM learns to do UC where
the only action is to register notification monitors for L2 addressing
changes in the kernel?

Ugly in user-space though.. Can this be hidden with Sean's recent work
on simplified progamming models?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
