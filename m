From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/opa_vnic: Add debugfs interface
Date: Fri, 29 Sep 2017 08:49:59 +0300
Message-ID: <20170929054959.GJ2297@mtr-leonro.local>
References: <20170926140714.18110.74689.stgit@scvm10.sc.intel.com>
 <20170926174946.GA1218@mtr-leonro.local>
 <20170926175524.GA2297@mtr-leonro.local>
 <20170926181214.GA41364@knc-06.sc.intel.com>
 <1506525977.33755.3.camel@redhat.com>
 <20170928184727.GA33282@knc-06.sc.intel.com>
 <20170928185753.GG2297@mtr-leonro.local>
 <20170928190502.GA33289@knc-06.sc.intel.com>
 <20170928193740.GH2297@mtr-leonro.local>
 <20170928200258.GA27343@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Q3iZjccpNGsIEgQL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170928200258.GA27343-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Q3iZjccpNGsIEgQL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 28, 2017 at 02:02:58PM -0600, Jason Gunthorpe wrote:
> On Thu, Sep 28, 2017 at 10:37:40PM +0300, Leon Romanovsky wrote:
>
> > > We find it useful on an ongoing basis, more like some standard NICs
> > > providing debugfs interface to read/write from/to some of its registers.
> >
> > Usually if such interface is spotted during submission, it will be requested
> > to drop it. Ask Salil, who lately upstreamed new ETH driver and was asked
> > to remove it.
>
> To be fair Salil's was dropped more or less for security reasons..
>
> I think debugfs to dump truely internal state that is not intended to
> be API stable is reasonable.

Yes, it can be ripped in any point of life, despite the screaming.

>
> Promise you will not be tooling on top of this, or use it as an
> interface in your manager or something crazy like that. You must be
> happy in all cases if your distro chooses to disable debugfs.

Honestly, I don't know if we can trust to Intel's promises.

Among other promises, they wrote that OmniPath Ethernet Management part
will be open sourced too. It seems like it wasn't at the end.
My google searches with words "ethernet manager omni-path" revealed nothing.

>
> The problem I have with reviewing all the vnic patches is that I don't
> have a spec for vnic or anything, and I don't really know what the
> data being dumped is..

My problem with those patches that they don't show whole picture and the
more important you have no way to see it, if you want it.
Right now, it is legal code-sharing and not truly open-source which I would like to see.

> eg I would have been much happier if ipoib
> dump'd its debugfs stuff through netlink connected to neighbor objects
> - I don't know if this is something similar...
>
> As Leon says, you should really think carefully if this needs to be
> something that admins are going to be told to look at when vnic isn't
> working properly, as the ipoib debufs is. In that case netlink is a
> stable API and more suitable.
>
> Jason

--Q3iZjccpNGsIEgQL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnN3wcACgkQ5GN7iDZy
WKfZVQ/+JjyCeGCR2VdhBcAveaLvhuHz6GVpW9i+quoh5udIjDFxjOVSsjVjqG1r
g0exzsFqbOG3Sw1LgMToc70NtBOXm67+VqS4AiPosRiBrwzX5dvUG9/bC/fvuHEi
2IT3cbdtMYYyrQmoxHFPEk5FYBxagKxNU5Hd/b4swB6lTv76bZh9hWXs3gHn4YLa
xVScMuyW3VizsonGTsJ0esqCNCoQjQnQng6DN/V5m+CwaI+hoigkSDSmZ1W0W1kq
EgRW4BjGWvYIuvFCgOLRuDnr/Un/mVR7toCYPKFokybj5+ajteysBkj6cUy2XQ08
Q1M2Jmr7KiYYBPrN0Qw/W4k3pqhKjPwKtypuQuehh6DKLtaH+LwCHZnKY9E0pSTW
DzwP6xyUBvdpTMC6Mlr4OJl7LAa/oGW1+3reLxVhCO0+eMhBB+7tFoeYsTXqpLRB
ALq909EK1LUnIHmnZoV0123E4x9V4IJ11pzN7iAjC9CW5vLp9YXbTCo8K1nys4if
1ok3pdJLc/e43w6z8jPfOJxDfsjBl+ubdYj9PzecgLYQKdQYODPGFhg44zBdQwi0
O7nx1aLUPIx3Qshk4PzzEonqqrrEiuGQfCBEt+f0NGvDJFuQF4Rf3suD6LPq6jG9
pOhl/kToyZMXrBg2WQhAORUUTNx6NuSFx/2JsRR+cIMDh5Im6SU=
=MAjO
-----END PGP SIGNATURE-----

--Q3iZjccpNGsIEgQL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
