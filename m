From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: sense remote hardware address change by rdma-cm applications
Date: Tue, 20 Jul 2010 10:25:52 +0300
Message-ID: <4C454F80.1060808@Voltaire.com>
References: <AANLkTimmWiNqHJIqSEKbY-X6mSx6zA19p__JDYPEmp8b@mail.gmail.com> <20100720001436.GH7920@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100720001436.GH7920-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sean Hefty <mshefty-+/W+9+QloQG75v1z/vFq2g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> It is a bit wider problem than just ND entries, changes in routing can
> also alter the L2 address, so that needs to be tracked as well. 

sure, when we did the address change work, see commit dd5bdff "RDMA/cma: Add RDMA_CM_EVENT_ADDR_CHANGE event", the problem I wanted to solve was related to 
the local bonding. Over the review thread, remote address change related 
to bonding fail-over and routing changes were mentioned, and left to future work.


> this is back to original criticisms from netdev of this whole separated 
> stack idea - it isn't integrated, so where do you draw the line? What gets left out? 
> Today, it is pretty clear that only the CM portion integrates at all
> with netdev and after that things are separate.

the address change event was an attempt to make the CM part which integrates with netdev
go a step further and help the data path which is offloaded to be more consistent with netdev,
this email is about going another step.

> So.. I think to tackle this you need to start looking at how the
> dst_entry structure works in netdev and apply the same idea to RDMA-CM
> and reflect the changes in AH back to the QP owner.

I can take a look (pointer would be very much appreciated...) still, the dst entry is used
for every netdev xmit where here the xmit is offloaded, so I don't see what could be really used from the dst code, but I might be wrong. The rdma app uses the neighbour once, upon address resolving, and I was trying to see if we can ref the neighbour so the neigh sub-system probes would keep going even though the neighbour is not directly used.

> Is this an iwarp problem too? Not sure how L3->L2 translation works there.

I never managed to understand how address resolving really works with iwarp... 

Doing a bit of detective work... you can see that addr4_resolve says

>         /* If the device does ARP internally, return 'done' */
>         if (rt->idev->dev->flags & IFF_NOARP) {
>                 rdma_copy_addr(addr, rt->idev->dev, NULL);
>                 goto put;
>         }

and later cma_connect_iw places into the iwarp cm the src/dst IP addresses

>         sin = (struct sockaddr_in*) &id_priv->id.route.addr.src_addr;
>         cm_id->local_addr = *sin;
>         sin = (struct sockaddr_in*) &id_priv->id.route.addr.dst_addr;
>         cm_id->remote_addr = *sin;

so all the iwarp providers do ARP resolving in their TOE stack?! Steve, can you
clarify that?

 
> Not sure what you do about UD.. Maybe RDMA-CM learns to do UC where
> the only action is to register notification monitors for L2 addressing
> changes in the kernel?

The problem exists for all IB transports (even for RD, if it would have been implemented...), the only difference between the U and R onces is that for the R's, if the remote side vanished, eventually the IB HW would let you know on that in the form of CQ error.

> Can this be hidden with Sean's recent work on simplified progamming models?

not sure how Sean's work relates to this proposed change.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
