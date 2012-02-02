From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 1 Feb 2012 17:42:58 -0800
Message-ID: <CAG4TOxPnST6u1CHeS0MieTUtL-nTOTgiVp0vBciO4yVDt5dz+Q@mail.gmail.com>
References: <20120201.152213.433850213028883896.davem@davemloft.net>
 <CAG4TOxPrAhac1y-TzA=x47sm88JfQdkrpWW4Em_mBD=KbyRo+g@mail.gmail.com>
 <20120201.161333.2203265702893105548.davem@davemloft.net> <CAG4TOxMHG04_REzB9faBcjgUS43845qG5CgDYCUfLDYC6sEjmw@mail.gmail.com>
 <20120201222638.GA24483@obsidianresearch.com> <CAG4TOxMbDxYYyLRFJqvpDQk99f5cA7M=AA37W9R=yL5tBeshdQ@mail.gmail.com>
 <20120202010253.GB25606@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120202010253.GB25606-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 1, 2012 at 5:02 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> I guess I'm missing something. I thought the stack didn't have
> a unicast hwaddr separate from a neighbour structure? Isn't that where
> it is stored? Unicast arp does have a destination IP address and a
> destination hwaddr...

Look at unicast_arp_send() and related code in ipoib_main.c...
Basically we have to handle the case where we have no neighbour
struct when we're sending a unicast ARP.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
