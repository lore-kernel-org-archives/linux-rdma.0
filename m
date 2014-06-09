From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
Date: Mon, 9 Jun 2014 13:12:50 -0500
Message-ID: <004501cf840e$6cf0c240$46d246c0$@opengridcomputing.com>
References: <20140326220718.GA8784@TENIKOLO-MOBL1> <CAJZOPZ+E0sX6-_tT2DrbLvRvrHWvEcO5KtMGwZqhuoQeTqrrMg@mail.gmail.com> <20140609165105.GB1816@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140609165105.GB1816-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "'Lacombe, John S'" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Monday, June 09, 2014 11:51 AM
> To: Or Gerlitz
> Cc: Tatyana Nikolova; Steve Wise; Roland Dreier; Lacombe, John S; Sean Hefty; linux-rdma
> Subject: Re: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
> 
> On Sun, Jun 08, 2014 at 10:34:30PM +0300, Or Gerlitz wrote:
> > What it does is the following:
> >
> > 1. kernel rdma driver tells a user space daemon they want to reserve
> > (claim) the combination of IP address X and TCP port Y for the sake of
> > RDMA connections
> >
> > 2. user space daemon opens a socket and binds to X:Y
> >
> > Specifically, down the road, more use cases, not only the current
> > iWARP case may pop up.
> 
> This really seems horrible, using user space to circumvent the kernel
> stack because kernel maintainers don't want this kind of integration
> is not going to make people very happy.
> 
> IIRC the patch set that tried to do this directly in the kernel was
> NAK'd, adding a userspace round trip doesn't really change anything.
> 

The patch set you refer to tried to _unify_ the port space and was rejected.  The only
other alternative is to pick ephemeral ports and maintain a mapping for RDMA services.

> The message from netdev has, IMHO, always been pretty clear - offload
> can live in it's own little side world but cannot appear to the user
> to be integrated to the main stack (because it isn't).

That is what this design does...

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
