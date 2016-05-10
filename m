From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Tue, 10 May 2016 20:52:00 +0300
Message-ID: <20160510175200.GB900@leon.nu>
References: <21d9307f-766e-9aaa-54d3-207a4a4d5d8c@mellanox.com>
 <20160505181423.GB5957@obsidianresearch.com>
 <alpine.DEB.2.20.1605052116570.1091@east.gentwo.org>
 <20160506225523.GA21309@obsidianresearch.com>
 <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org>
 <20160509163537.GA15479@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB04A390@ORSMSX109.amr.corp.intel.com>
 <20160509200507.GA23911@obsidianresearch.com>
 <20160510045801.GV29160@leon.nu>
 <20160510171819.GB2879@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160510171819.GB2879-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 10, 2016 at 11:18:19AM -0600, Jason Gunthorpe wrote:
> On Tue, May 10, 2016 at 07:58:01AM +0300, Leon Romanovsky wrote:
> > > The Collab Summit discussions ended with a general consensus that some
> > > things would go to the driver-specific channel, while hardware
> > > behavior related to the common uAPI would go through at least a
> > > multi-vendor sign off process - like IBTA.
> >=20
> > We did ALL and much more from the discussed for RSS patches and at the =
end,
> > we saw half a word from the maintainer about the future plans for its a=
cceptance.
>=20
> Where is the 'multi-vendor sign off' part of the process?

The steps are described at the following mail [1].

[1] http://marc.info/?l=3Dlinux-rdma&m=3D146218340000784&w=3D2

>=20
> Jason

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXMh+/AAoJEORje4g2clink2MP/0fW7MqF5SrciDBRetTyPkfz
bdE6KtgYnvOvqQkLdTYtrqWUl/7d3O51meZ3wNCCFmQYQ1FHnJ1uSR6FNv+R1doJ
kiVTVJs2aJrvkCq6Gn5h5Q/Xu18SYi85LHg9ggf0TZDu59L/8jHxNz/knlHhW0YH
zmAdgqnqyaeWttCAUcRRP6WWS24jD3MvMnjFKK7jL7UxQBrtyUuKs5pNawVZCNfe
SYRIw4Jz707xK+WMr2fac9itsV83Vgkbe7/YHHNMAI74alXgyyLa5Nq3GGzUp/9Z
dE8CYmOPCsgQuoUvsO2ehyKSc8OgWiu2KM0uAay2AWzKauJgUj0q1rp5Y3fxM88S
F8lIlF3YGdhuKx77jvom3rpAfUVYpgV+y22mGb8L0UCrshzs7QIrEvcpYxAd6oFC
97boPBVo3QYe5BJbFeKxRJtrJ1Sxv5OpYlJgN2DZ9K49nURNV5J7XpNdM7yHq1ZG
XcIubvGGRYwK7wkx2Ll/RVdLpvyk1ur4utXLZtdLrU54p3wfGDyAiWz+tboJ6X9n
/IH/d0igvpmjxNnpF+4wGMQTWDl5RJl7+X+6RqCmPGfL0rpFFcmu/eNgw+iDgcXR
dTkGvOqLHT1F4XksP3TEQMz04d9bMXR1hwUpr+bR30NjxFfF6dT1Z1k8vjkOLKUj
wFPysztYwJMd1nekLT0m
=2uXa
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
