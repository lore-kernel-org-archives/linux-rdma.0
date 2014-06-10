From: PJ Waskiewicz <pj.waskiewicz-PrFOU5CTvK1l57MIdRCFDg@public.gmane.org>
Subject: Re: FW: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
Date: Mon, 9 Jun 2014 17:08:09 -0700
Message-ID: <CAEmgqz2HtEJ1ho0rS4xR7ud6YgFfeAvR8uD8MgPjVhw=E9PFEg@mail.gmail.com>
References: <20140326220718.GA8784@TENIKOLO-MOBL1>
	<CAJZOPZ+E0sX6-_tT2DrbLvRvrHWvEcO5KtMGwZqhuoQeTqrrMg@mail.gmail.com>
	<20140609165105.GB1816@obsidianresearch.com>
	<004501cf840e$6cf0c240$46d246c0$@opengridcomputing.com>
	<20140609184207.GA534@obsidianresearch.com>
	<2ABFA3E36CBB794685BFBA191CC1964952C605CB@FMSMSX105.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2ABFA3E36CBB794685BFBA191CC1964952C605CB-AtyAts71sc9qS6EAlXoojrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org
Cc: "Sharp, Robert O" <robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Monday, June 09, 2014 1:42 PM
> To: Steve Wise
> Cc: 'Or Gerlitz'; Nikolova, Tatyana E; 'Roland Dreier'; Lacombe, John S; Hefty, Sean; 'linux-rdma'
> Subject: Re: [PATCH 0/3] RDMA/core: iWARP Port Mapper Overview
>
> On Mon, Jun 09, 2014 at 01:12:50PM -0500, Steve Wise wrote:
>
> > > > 1. kernel rdma driver tells a user space daemon they want to
> > > > reserve
> > > > (claim) the combination of IP address X and TCP port Y for the
> > > > sake of RDMA connections
> > > >
> > > > 2. user space daemon opens a socket and binds to X:Y
> > > >
> > > > Specifically, down the road, more use cases, not only the current
> > > > iWARP case may pop up.
> > >
> > > This really seems horrible, using user space to circumvent the
> > > kernel stack because kernel maintainers don't want this kind of
> > > integration is not going to make people very happy.
> > >
> > > IIRC the patch set that tried to do this directly in the kernel was
> > > NAK'd, adding a userspace round trip doesn't really change anything.
>
> > The patch set you refer to tried to _unify_ the port space and was
> > rejected.  The only other alternative is to pick ephemeral ports and
> > maintain a mapping for RDMA services.
>
> I thought both approaches were tried in kernel and NAK'd by netdev?
> This looks very similar to the 2010 patchset, except the dummy socket allocation is living in userspace in this version.

This was something I presented and discussed at NetConf 2011 with
David and other netdev core folks:
http://vger.kernel.org/netconf2011.html.  The main issue David had
with the original approach was the socket was being consumed by
something else inside the kernel.  It circumvented the TCP socket
allocation/reservation code, which was frowned upon.

The compromise we came up with is the approach in this patchset.  As
long as the socket is claimed via userspace, David had no problem with
the approach.

> Again, from here, this looks like another patch to do an end-run around netdev's NAK by hiding the offending stuff in userspace. That is no good either...

See above.

> > > The message from netdev has, IMHO, always been pretty clear -
> > > offload can live in it's own little side world but cannot appear to
> > > the user to be integrated to the main stack (because it isn't).
> >
> > That is what this design does...
>
> Not really, it is still sharing an IP used by the main stack, otherwise you wouldn't have this problem in the first place.

The reason we didn't back down from having separate IP's is because
there are customers using iWARP that want the traffic converged, using
a single IP.  This approach is the best way we came up with as a
group, it just took a bit of time to get headcount onto it and
developed/tested.

Cheers,
-PJ
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
