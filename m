From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 1 Feb 2012 18:02:53 -0700
Message-ID: <20120202010253.GB25606@obsidianresearch.com>
References: <20120201.152213.433850213028883896.davem@davemloft.net>
 <CAG4TOxPrAhac1y-TzA=x47sm88JfQdkrpWW4Em_mBD=KbyRo+g@mail.gmail.com>
 <20120201.161333.2203265702893105548.davem@davemloft.net>
 <CAG4TOxMHG04_REzB9faBcjgUS43845qG5CgDYCUfLDYC6sEjmw@mail.gmail.com>
 <20120201222638.GA24483@obsidianresearch.com>
 <CAG4TOxMbDxYYyLRFJqvpDQk99f5cA7M=AA37W9R=yL5tBeshdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG4TOxMbDxYYyLRFJqvpDQk99f5cA7M=AA37W9R=yL5tBeshdQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 01, 2012 at 03:32:26PM -0800, Roland Dreier wrote:

> > Would making the allocation of the neigh structure returned by
> > dst_lookup_neigh() large enough to hold the ARP/ND HW addr and also
> > the IB path record solve these problems? At least for UD?
> 
> I don't think so, because we don't always have a neighbour when
> we get a packet to send (eg unicast ARP), and we need a place to
> queue up packets while we do the path lookup (the ipoib_neigh.queue
> list does that now).  So we definitely need paths/AHs separate from
> neighs for the first part and we need more than just data in the neigh
> for the second part.

I guess I'm missing something. I thought the stack didn't have
a unicast hwaddr separate from a neighbour structure? Isn't that where
it is stored? Unicast arp does have a destination IP address and a
destination hwaddr...

To elaborate a bit more what was idly in my head, if the new approach
is to always lookup the neighbor on demand, and that can include an
ARP to the network, then can't we piggyback on that same process to
issue a path record? With a 1:1 correspondence between unicast
neighbour, path record, and AH they can all be stored in the same
allocation, with the same lifetime. Thus you don't need the second
part, and maybe the first part becomes an inefficient special case?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
