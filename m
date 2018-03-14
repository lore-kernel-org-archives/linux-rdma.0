From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch 1/1] drivers/infiniband/core/verbs.c: fix build with
 gcc-4.4.4
Date: Wed, 14 Mar 2018 18:15:25 -0400
Message-ID: <1521065725.18703.127.camel@redhat.com>
References: <20180313215157.GL3mSm-p6%akpm@linux-foundation.org>
         <1521060060.18703.111.camel@redhat.com>
         <20180314140817.8d1b8854af509981ff6562bd@linux-foundation.org>
         <1521061939.18703.126.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-X8GJwRJvDy/tNaxtBQmH"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1521061939.18703.126.camel@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bart.vanassche@wdc.com, jgg@mellanox.com, linux-rdma@vger.kernel.org, sagi@grimberg.me, stable@vger.kernel.org, swise@opengridcomputing.com
List-Id: linux-rdma@vger.kernel.org


--=-X8GJwRJvDy/tNaxtBQmH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-03-14 at 17:12 -0400, Doug Ledford wrote:
> On Wed, 2018-03-14 at 14:08 -0700, Andrew Morton wrote:
> > On Wed, 14 Mar 2018 16:41:00 -0400 Doug Ledford <dledford@redhat.com> w=
rote:
> >=20
> > > On Tue, 2018-03-13 at 14:51 -0700, akpm@linux-foundation.org wrote:
> > > > From: Andrew Morton <akpm@linux-foundation.org>
> > > > Subject: drivers/infiniband/core/verbs.c: fix build with gcc-4.4.4
> > > >=20
> > > > gcc-4.4.4 has issues with initialization of anonymous unions.
> > >=20
> > > That compiler was released in April of 2010, almost a full 8 years ag=
o.=20
> > > What still uses it, and do we seriously care?
> >=20
> > Documentation/Changes still says gcc-3.2.  A few people are using the
> > older versions.  There's talk going around about requiring something
> > more recent but nothing has happened yet.
>=20
> OK, count this as a grumble about the outdated compiler requirement :-/.=
=20
> The code this patches looks nice and clean, this patch uglies it up.
>=20

If it wasn't obvious BTW, this and the other patch you sent have been
applied to for-next area, begrudgingly ;-)

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-X8GJwRJvDy/tNaxtBQmH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlqpnv0ACgkQuCajMw5X
L905rQ/+NiGzvyfW0/uSCbaJPE1mgNE5eEQ/RiTmFX2xde85sCYYcjMyIOhkeUdI
GAQFJhCYBAuOBEGc8Ozbv78eoy41UG5Zbloge+6f2SECycD/E5X1T5TOe73MLIHE
YO/ROi8aAAiZl42IEIFztbZv0CXyTAN9DSbblsKwmQ7k3w+7PHdGg6p2VziyU9Fu
3zYKrAIMBxMify7tbzzkyqoKPOwTy/EdTp1FTZfNLMeeG5kOy6w0IKuj9sKhVM+S
O7SK/BidsWmT8uIbBa1/dLocCs5WIrZHQlWECxIhHWDruv8J6zA0dzrkbbQILYYw
ShjmWghKA+2KDT7O9RNJ7rOXpunQUkxlYBAGkBgP30ujGqH4OsVxac1hHcuuyGfA
jC/bqCArVsqz6LW9mIFL35i6KSY0zCFc31VqVHi/96qcdTcQQlxNIt6ChxW3VyRh
80FScMb53b61VnTGrtA/ON/SPvJZeiRhLk+F7EKcnxl6hhd/3a9WTVe1II/mxiQq
cwaZ+AmhRNjxL/2upDCTghoGt/oRZXc7zxQApyTOevTywp9DICQHUptBh4vD5M0l
2oeFay7e6jZZcE9PdinFXgzHFxTvEX9kDlTvgobKo+3BYTrZ8w5ECSCcduSWZOtq
IGM3TCaoOVTLm5jJvg1GuqPOfmefDUXIiZyjELm4/ruJyAvcy4w=
=hnQF
-----END PGP SIGNATURE-----

--=-X8GJwRJvDy/tNaxtBQmH--
