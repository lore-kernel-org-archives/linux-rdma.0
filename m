From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 1 Feb 2012 15:32:26 -0800
Message-ID: <CAG4TOxMbDxYYyLRFJqvpDQk99f5cA7M=AA37W9R=yL5tBeshdQ@mail.gmail.com>
References: <20120201.152213.433850213028883896.davem@davemloft.net>
 <CAG4TOxPrAhac1y-TzA=x47sm88JfQdkrpWW4Em_mBD=KbyRo+g@mail.gmail.com>
 <20120201.161333.2203265702893105548.davem@davemloft.net> <CAG4TOxMHG04_REzB9faBcjgUS43845qG5CgDYCUfLDYC6sEjmw@mail.gmail.com>
 <20120201222638.GA24483@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120201222638.GA24483-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 1, 2012 at 2:26 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> I thought a big reason the IPoIB stuff was setup this way was to fit
> in with older kernels (eg we cannot change the neigh structures)?

No, IPoIB tries to be as "native" as possible.  The problem as I see
it is that IPoIB does standard ARP/ND, but then it has an extra step
(path record lookup) to turn that neighbour into an address handle we
can use to actually send a packet.  And the networking stack doesn't
really have a good place to add that extra step -- we can override the
neighbour discovery / ARP layer, but we can't tack on another step.

> Would making the allocation of the neigh structure returned by
> dst_lookup_neigh() large enough to hold the ARP/ND HW addr and also
> the IB path record solve these problems? At least for UD?

I don't think so, because we don't always have a neighbour when
we get a packet to send (eg unicast ARP), and we need a place to
queue up packets while we do the path lookup (the ipoib_neigh.queue
list does that now).  So we definitely need paths/AHs separate from
neighs for the first part and we need more than just data in the neigh
for the second part.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
