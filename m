From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/9] IB/ipoib: Add warning message when
 changing the MTU in UD over the max range
Date: Fri, 13 Jan 2017 10:12:34 -0700
Message-ID: <20170113171234.GA30551@obsidianresearch.com>
References: <20161228124728.26619-1-leon@kernel.org>
 <20161228124728.26619-2-leon@kernel.org>
 <1484246776.123135.19.camel@redhat.com>
 <20170112193508.GO20392@mtr-leonro.local>
 <20170112201622.GA14584@obsidianresearch.com>
 <20170113150824.GQ20392@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170113150824.GQ20392-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 13, 2017 at 05:08:24PM +0200, Leon Romanovsky wrote:
> On Thu, Jan 12, 2017 at 01:16:22PM -0700, Jason Gunthorpe wrote:
> > On Thu, Jan 12, 2017 at 09:35:08PM +0200, Leon Romanovsky wrote:
> >
> > > > > In datagram mode, the IB UD (Unreliable Datagram) transport is used
> > > > > so the MTU of the interface is equal to the IB L2 MTU minus the
> > > > > IPoIB encapsulation header. Any request to change the MTU value
> > > > > above the maximum range will change the MTU to the max allowed, but
> > > > > will not show any warning message. An ipoib_warn is issued in such
> > > > > cases, letting the user know that even though the value is legal,
> > > > > it can't be currently applied.
> >
> > How does RC mode work then?
> 
> RC mode doesn't have limitation on MTU size and it allows messages
> larger than IB link-layer MTU.

This is about what happens if the multicast MTU < unicast MTU - which
is *exactly* the same case on RC and UD.

IPoIB cannot send a 64k multicast MTU on RC either.

> Maybe, I went too far by calling it error, but IMHO absence of indication to
> user of decreased MTU is not good either.

I don't see why we should 'solve' this for UD and ignore the same
problem in RC.

IMHO, the correct fix is to figure out how to limit multicast - there
is something called multicast path MTU discovery - so maybe we are
doing something wrong and breaking that (are we erroring too large
packets inside ipoib properly?), or it is not working in the kernel or
it isn't supported by the kernel ...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
