From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Fixes and package improvement to Travis CI
Date: Tue, 14 Nov 2017 20:30:02 +0200
Message-ID: <20171114183002.GD18825@mtr-leonro.local>
References: <20171113060806.27354-1-leon@kernel.org>
 <65be5c4f-0127-78c7-db0c-f54c22884902@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OneyYHbITFC5y/NU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <65be5c4f-0127-78c7-db0c-f54c22884902-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--OneyYHbITFC5y/NU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 13, 2017 at 10:55:15AM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 13/11/2017 =E0 07:08, Leon Romanovsky a =E9crit=A0:
> > Hi,
> >
> > This patchset comes from Alaa, who fixed two issues discovered during
> > his work to enable checks of distribution packages in Travis CI.
> > These fixes allowed us to add Ubuntu Artful to the list of checked
> > distributions.
> >
> > PR can be found at:
> > https://github.com/linux-rdma/rdma-core/pull/248
> >
> > Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> > Cc: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
> > Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
> >
> > Thanks
> >
> > Alaa Hleihel (3):
> >   Fix compilation warnings when NDEBUG is set
> >   util/mmio.c: Fix compilation errors when __SSE__ is not set on 32 bit
> >   travis: Test Debian packaging under artful container
> >
> >  .travis.yml                 |  6 ------
> >  buildlib/cbuild             |  7 +++++++
> >  buildlib/package-build-test |  2 +-
> >  buildlib/travis-build       | 16 +---------------
> >  libibverbs/neigh.c          |  2 +-
> >  librdmacm/rsocket.c         |  4 ++--
> >  util/mmio.c                 |  4 ++--
> >  7 files changed, 14 insertions(+), 27 deletions(-)
> >
> > --
> > 2.15.0
> >
>
> For the series:
> Reviewed-by: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>

I took first patch, everything else is dropped.

Thanks

--OneyYHbITFC5y/NU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloLNioACgkQ5GN7iDZy
WKe8wBAArbMmZl0k02RWdloIXNwcQMAqlGnHVoDmboJ8Yf0OiR0oQBZgE7Ru1DWk
gcozW0mmsY5lVYF8kLUjWh/gloYDegjoVJa2G54oAvwvAnTUKvTW2ywHm9bK28D3
gnbLLyWfKtvu2i6get2xIBXvOvrGO7YYHgB6+tFdZSJ3JGow6eaGzPcb9CR1XBM/
OBfP64h9m4hftUvj89BKekeE6rMwn938TY3EIiWrhufxjyCRsY/CI+k8CwGeD9gl
ZINPKtKcH92cQpBgM47ggSwo9NiL/MAxlTjQNS2/To9j5euslJObcg29NPgH9/4H
E4ax55IMwf9KJmOwHIW7Yv7t7rjdd/dvLsiPR6KXqPJdripCdvUJuekAcx/OzILW
6ZJovkF5wQKZEvfmwhvOTNyJ9TGAHz/+51nDuG9a+HwlZJJ4OY07ubQhLIAdOiW2
MdguzfBE4zyaApr4HrUkBheoxjLuXDwnhIBKAtFpEU531hcm4xLwR6GDsNts9ews
PrDM1lap2YFbUIkSh8F/rdNjQC/X0//GM/H7s+L1ylfvcxuzpJ79cZj3ZihVQRaC
JAkwE7NNsC6sC9gmOGbcjayBWaLWEJ7db3uFzULVjHnjn8Y+a17MU1RXM0K7/nkF
E/QGYNvmhs+S4LkVv9VZ3ip3JX+P9CF+XdKK9oDx4qejVqICc+g=
=JAZe
-----END PGP SIGNATURE-----

--OneyYHbITFC5y/NU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
