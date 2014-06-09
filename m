From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
Date: Mon, 9 Jun 2014 12:42:07 -0600
Message-ID: <20140609184207.GA534@obsidianresearch.com>
References: <20140326220718.GA8784@TENIKOLO-MOBL1>
 <CAJZOPZ+E0sX6-_tT2DrbLvRvrHWvEcO5KtMGwZqhuoQeTqrrMg@mail.gmail.com>
 <20140609165105.GB1816@obsidianresearch.com>
 <004501cf840e$6cf0c240$46d246c0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <004501cf840e$6cf0c240$46d246c0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "'Lacombe, John S'" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 09, 2014 at 01:12:50PM -0500, Steve Wise wrote:

> > > 1. kernel rdma driver tells a user space daemon they want to reserve
> > > (claim) the combination of IP address X and TCP port Y for the sake of
> > > RDMA connections
> > >
> > > 2. user space daemon opens a socket and binds to X:Y
> > >
> > > Specifically, down the road, more use cases, not only the current
> > > iWARP case may pop up.
> > 
> > This really seems horrible, using user space to circumvent the kernel
> > stack because kernel maintainers don't want this kind of integration
> > is not going to make people very happy.
> > 
> > IIRC the patch set that tried to do this directly in the kernel was
> > NAK'd, adding a userspace round trip doesn't really change anything.

> The patch set you refer to tried to _unify_ the port space and was
> rejected.  The only other alternative is to pick ephemeral ports and
> maintain a mapping for RDMA services.

I thought both approaches were tried in kernel and NAK'd by netdev?
This looks very similar to the 2010 patchset, except the dummy socket
allocation is living in userspace in this version.

Again, from here, this looks like another patch to do an end-run
around netdev's NAK by hiding the offending stuff in userspace. That
is no good either...

> > The message from netdev has, IMHO, always been pretty clear - offload
> > can live in it's own little side world but cannot appear to the user
> > to be integrated to the main stack (because it isn't).
> 
> That is what this design does...

Not really, it is still sharing an IP used by the main stack,
otherwise you wouldn't have this problem in the first place.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
