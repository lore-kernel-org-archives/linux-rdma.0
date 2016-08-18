From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 4/6] RDMA/core: Move HFI1 IOCTL declarations to
 common file
Date: Thu, 18 Aug 2016 09:23:48 +0300
Message-ID: <20160818062348.GA7047@leon.nu>
References: <1471355123-6227-1-git-send-email-leon@kernel.org>
 <1471355123-6227-5-git-send-email-leon@kernel.org>
 <20160817061630.GB27477@phlsvsds.ph.intel.com>
 <20160817065529.GG5489@leon.nu>
 <20160817181050.GC27477@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160817181050.GC27477-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 17, 2016 at 02:10:51PM -0400, ira.weiny wrote:
> On Wed, Aug 17, 2016 at 09:55:29AM +0300, Leon Romanovsky wrote:
> > On Wed, Aug 17, 2016 at 02:16:31AM -0400, ira.weiny wrote:
> > > On Tue, Aug 16, 2016 at 04:45:21PM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >=20
> > > > Move HFI1 IOCTL declarations to rdma_user_ioctl.h file.
> > >=20
> > > I have not tried with the patch but I'm 99% sure this will break the =
PSM2
> > > library build which includes hfi1_user.h.
> > >=20
> > > This is one of those things I have pondered in the past.  Most of the=
 rdma
> > > libraries don't actually use these definitions directly.  PSM2 does.
> >=20
> > I'm not so convinced about it.
> > "#include <rdma/rdma_user_ioctl.h>" was added to hfi1_user.h to share
> > all definitions. PSM2 library will see it.
>=20
> Ok I see it now.  Sorry it was late.
>=20
> >=20
> > >=20
> > > I'm not sure what other libraries do.
> > >=20
> > > In the final patch of this series you admit that the name changes in =
that patch
> > > will break userspace which uses the defines directly.  Can we, should=
 we, do
> > > that?
> >=20
> > I'm talking about __NUM() macros.
> >=20
> > Do you really use __NUM(ASSIGN_CTXT) in user application? Why did you do
> > it? You supposed to use HFI1_IOCTL_ASSIGN_CTXT instead.
>=20
> Your commit message says "... and MAD indexes were renamed.  It has the
> potential to break application which use these defines directly."
>=20
> I took that at face value.  I've taken a closer look ... I see now that n=
either
> the numbers nor the define names changed so ok, my mistake.

Sorry for inconvenience,
I'll update commit message, so it will better reflect reality.

Thanks


--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtVR0AAoJEORje4g2clin4p4P/0AllUQVjjpxNN+bCWUCbNbg
MkclMLu4Du9vtA3vhs2zoxb+m6i4gXZvpj4uBik7lgniEadnSpiSRH2P+9Xp+1hF
in9V668Z4c/LOdHGGumF36R1Bf2L4IPw+uc9V+VhtixOj6RAZsoiO9kZHah2Mf/g
B+1wUPDzM6CjZ9SeMbYCLxPUhByJc7hlJ1bGWqM7/PoEgojeW/EZFRBWzYqWTecO
uiyVbj4FjdEanpcdhzHfhlueCD+wApn46/qHF5If/TxGy8ooPglICs9pk/IbthqH
qoKS1eLFmrvO8IDHw82RAOcpSCJ7E4BZsX6rmWlY8KPeE9RMz+yQ8+T5mbx0klK8
rIPSMMPYCeQ5GOCMg2NA74PkS700Ry1aocI7K6QUWDLUZMnPYkhRZbEFUDmDlipV
2KTAOEWf7xddHgfsgzkWpE1YxTUyljlv2iCNWmAxTx+N3uCGMXnerEnHLbuBPujQ
C31mqg3RQODyq6CdgyzE6YYXPCSvlrV37RHrE+5Pavzdro6bEeFTthNzSbYuHZt5
WRRgEJPzZ4glhLG9VIM3SUal1kyJy6lRUyBYTj8+DNt6Oh2fZDv09nh0Hs6dlsfO
VcEpQjZgvzaM9nJTNOc7eFKE4U0ZZn8v6hfZtiS1WcMGAm1xbc6lKHo4I32oML4W
+Air8wefk3SboKE974Um
=259K
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
