From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/9] IB/ipoib: Add warning message when
 changing the MTU in UD over the max range
Date: Thu, 12 Jan 2017 13:16:22 -0700
Message-ID: <20170112201622.GA14584@obsidianresearch.com>
References: <20161228124728.26619-1-leon@kernel.org>
 <20161228124728.26619-2-leon@kernel.org>
 <1484246776.123135.19.camel@redhat.com>
 <20170112193508.GO20392@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170112193508.GO20392-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 12, 2017 at 09:35:08PM +0200, Leon Romanovsky wrote:

> > > In datagram mode, the IB UD (Unreliable Datagram) transport is used
> > > so the MTU of the interface is equal to the IB L2 MTU minus the
> > > IPoIB encapsulation header. Any request to change the MTU value
> > > above the maximum range will change the MTU to the max allowed, but
> > > will not show any warning message. An ipoib_warn is issued in such
> > > cases, letting the user know that even though the value is legal,
> > > it can't be currently applied.

How does RC mode work then?

> Second, I have a different view from you on the issue. User configured
> some value, which is not correct for IPoIB. In ideal world (without legacy),
> we were supposed to return error to him with proper message, but in our
> case (legacy applications) we can't (we tried and it broke some legacy
> ifcongfig, if I remember well). So it leaves us with one available
> option is to warn user about improper value.

This is a legitimate configuration though, the user could have a mixed
MTU fabric and rely on path MTU discovery, so sets the MTU to the
largest.

AFAIK the way to handle such configurations is with a multicast route that
has a reduced mtu.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
