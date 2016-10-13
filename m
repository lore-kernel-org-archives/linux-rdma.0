From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/10] Hardware tag matching support
Date: Thu, 13 Oct 2016 14:47:07 -0600
Message-ID: <20161013204707.GA8245@obsidianresearch.com>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
 <20161007145620.GV9282@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB093986@ORSMSX109.amr.corp.intel.com>
 <6259953b-27fe-77c9-ea90-af744f188671@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373AB095429@ORSMSX109.amr.corp.intel.com>
 <20161013170641.GA9094@infradead.org>
 <1828884A29C6694DAF28B7E6B8A82373AB095647@ORSMSX109.amr.corp.intel.com>
 <20161013195605.GA8077@obsidianresearch.com>
 <20161013200208.GA8998@infradead.org>
 <a3495685-69c7-26a7-ba97-9761848535a8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a3495685-69c7-26a7-ba97-9761848535a8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2016 at 04:30:10PM -0400, Doug Ledford wrote:
> On 10/13/2016 4:02 PM, Christoph Hellwig wrote:
> > On Thu, Oct 13, 2016 at 01:56:05PM -0600, Jason Gunthorpe wrote:
> >> A bigger objection I have is that much of this new stuff is not
> >> adaquately documented.
> >>
> >> Tag matching is a great example. It looks like this introduces many new
> >> headers into the on-wire protocol. Where are these headers documented?
> >> Where is the spec for the on-wire format? Where is the implementation
> >> for rxe?
> > 
> > Agreed on that part.  For pon the wire changes we need the hardware
> > standards organization to act.  IBTA for IB and RoCE and IETF for iWarp,
> > although not even having an active WG for iWarp there is a major problem
> > at the moment.
> > 
> 
> I think there are some fundamental questions here about what this is.
> As I understand it (and Mellanox can chime in if I'm wrong), tag
> matching already exists on the wire, it's just implemented above the
> level of the link layer transmissions.  This enables a hardware
> accelerator for something that is already done at an upper layer, so the
> implementation is mostly defined by the defacto existing use in upper
> layer applications, not by the IBTA.  I believe this could roughly be
> considered analogous to a network driver enabling a layer3 or layer4
> accelerator.  It's not a layer1 thing, so the IBTA is not appropriate to
> review it.

Maybe, but that doesn't change my original point. This is clearly not
defined well enough in the patches alone for any other vendor to
implement it.

If we can't even reach a basic threshold of understanding it is
pointless to expect other vendors to chime in on the design.

I'm starting to wonder if we should insist on an implementation of all
this new stuff in rxe before accepting. At least then we have code as
documentation ...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
