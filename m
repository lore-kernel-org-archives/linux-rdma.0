From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB: Move PCI dependency from root KConfig to HW's
 KConfigs
Date: Mon, 26 Jun 2017 14:57:16 +0300
Message-ID: <20170626115716.GD1248@mtr-leonro.local>
References: <20170626085313.6052-1-yuval.shaia@oracle.com>
 <20170626100231.GC1248@mtr-leonro.local>
 <20170626103850.GA6506@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/EQiL+SffV/fXkvV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170626103850.GA6506@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--/EQiL+SffV/fXkvV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 26, 2017 at 01:38:52PM +0300, Yuval Shaia wrote:
> On Mon, Jun 26, 2017 at 01:02:31PM +0300, Leon Romanovsky wrote:
> > On Mon, Jun 26, 2017 at 11:53:13AM +0300, Yuval Shaia wrote:
> > > No reason to have dependency on PCI for the entire infiniband stack so
> > > move it to KConfig of only the drivers that actually using PCI.
> > >
> > > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  drivers/infiniband/Kconfig           | 1 -
> > >  drivers/infiniband/hw/cxgb3/Kconfig  | 1 +
> > >  drivers/infiniband/hw/cxgb4/Kconfig  | 1 +
> > >  drivers/infiniband/hw/hfi1/Kconfig   | 1 +
> > >  drivers/infiniband/hw/i40iw/Kconfig  | 1 +
> > >  drivers/infiniband/hw/qedr/Kconfig   | 1 +
> > >  drivers/infiniband/hw/qib/Kconfig    | 1 +
> > >  drivers/infiniband/sw/rdmavt/Kconfig | 1 +
> >
> > Why do you need PCI for rdmavt?
>
> Saw calls such as get_pci_dev so just suspect, but you are right, i don't
> see why SW device needs PCI.
>
> >
> > >  drivers/infiniband/ulp/ipoib/Kconfig | 1 +
> > >  9 files changed, 8 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
> > > index 234fe01..568088a 100644
> > > --- a/drivers/infiniband/Kconfig
> > > +++ b/drivers/infiniband/Kconfig
> > > @@ -1,6 +1,5 @@
> > >  menuconfig INFINIBAND
> > >  	tristate "InfiniBand support"
> > > -	depends on PCI || BROKEN
> >
> > By the way, do you know why are we dependent on BROKEN?
>
> No, assume that it is like if PCI is not defined the "break" configuration
> or something like that.
> Will be happy if you can shad some light on that.

I don't know too, it was set more than 10 years ago. I doubt if it is
relevant nowadays.

Thanks

>
> >
> > Thanks
>
>

--/EQiL+SffV/fXkvV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllQ9pwACgkQ5GN7iDZy
WKddlBAAh2jPGKRtPsIfGgoHLFDrZ2JeOmnKnIOv4LMDjtsYI0seG51hc+NSS9Uf
59O3b+UVM2LiqOF6ma15Hqe4TSvGsQBpZRgu4ZYBHm9UZnuURDIUe7Dch5w3asOF
zUsjuEKXenffo4i4500R+LXtSSUx8zZsRhTnGZDJxvylkvRDnHyu9yzPZ33CBXFj
VW+Zrx1sJfaasiTN7MixzUtDG1a9V6OMeKHlz07ywnQXlSNo/oNHkVNadjGLSof6
tZDtk6SlEGuJP3IiwK17CUklvZwgeB2TDtclVXMVo6ViQZEpJqjxuMkJCYQVYY9Z
I/lkMuxz9vowIN51z/+lNnc6XIQJ3kawt6MDxSY2lh79NFKHZxM0RrgBRDwMXKBZ
8s1CcmT/vVEVAC0KRh6HXzo0X3HxdQopHOFiqiz5N+z2eVcnWBVTYxogAqCWW1Rj
Adp2u3Lox2OUd6svnTe1opPV8k7IDchiYFjQI/EQfVJwIDV+SnOoQAYixCWWmMXj
xlyHJNKQB/Hj/dCyd6RN81Dy0SeB1Ha518OXaNwBKPtqDI1f8p+meZetowcArqTt
mynRnWUykhkOxMlhOMJLd1n5souEbDlA0XOyWDBiZH4U6YaZn/BalTWEiTUZ4TA0
vVAYIf0ltkfSQG7lK7YA+6Ls6vCld6w2ohE4FT6ZMWTB/QyPMfU=
=OM4I
-----END PGP SIGNATURE-----

--/EQiL+SffV/fXkvV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
