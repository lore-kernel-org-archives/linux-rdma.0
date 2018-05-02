From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-rc v2 1/6] IB/hfi1: Fix handling of FECN marked
 multicast packet
Date: Tue, 01 May 2018 22:24:52 -0400
Message-ID: <1525227892.11756.131.camel@redhat.com>
References: <20180501123317.24520.8848.stgit@scvm10.sc.intel.com>
         <20180501123532.24520.80857.stgit@scvm10.sc.intel.com>
         <20180501180531.GB17027@ziepe.ca>
         <32E1700B9017364D9B60AED9960492BC6281B784@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ZI4UfKIuVxdU0PvtDlyc"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC6281B784@fmsmsx120.amr.corp.intel.com>
Sender: stable-owner@vger.kernel.org
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Hiatt, Don" <don.hiatt@intel.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "Ruhl, Michael J" <michael.j.ruhl@intel.com>
List-Id: linux-rdma@vger.kernel.org


--=-ZI4UfKIuVxdU0PvtDlyc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-05-01 at 21:58 +0000, Marciniszyn, Mike wrote:
> > Subject: Re: [PATCH for-rc v2 1/6] IB/hfi1: Fix handling of FECN marked
> > multicast packet
> >=20
> > On Tue, May 01, 2018 at 05:35:36AM -0700, Dennis Dalessandro wrote:
> > > @@ -719,7 +719,7 @@ void return_cnp(struct hfi1_ibport *ibp, struct
> >=20
> > rvt_qp *qp, u32 remote_qpn,
> > >=20
> > >  	lrh0 |=3D (sc5 & 0xf) << 12 | sl << 4;
> > >=20
> > > -	bth0 =3D pkey | (IB_OPCODE_CNP << 24);
> > > +	bth0 =3D (u32)pkey | (IB_OPCODE_CNP << 24);
>=20
> I'm verifying the fix w/o the cast...
>=20
> But I see Doug pulled the fix?

It's in my wip branch, so until I merge it into the official for-rc
branch, I can still fix up minor things like this.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-ZI4UfKIuVxdU0PvtDlyc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrpIXQACgkQuCajMw5X
L90QMRAAtoxNtGHTZuRD298ZSlOriVKZKcHhPMrdTgbH6X53F+wdnuLzs6Xso2+7
Y/1F7XjjfuQ0PaRhf71ShowIduYByapGj+cKk4SrYnE0ylW5id3CDQsOx3+vwnjh
NKvQbfTQB02/vvlYHXMWVZrWefROHZ6qZZZRBe9NpbhIf3KCdoJbYKUohoYSlBjV
Yox0/q3X15AUKAkOKDe/ej5dcmGn2EhXyUxaOcTUwufTyGNG0PFWGhU+pOUJ+Gua
lX7OBsqeTVTzqgWO6w9sMmva9EDEfTMtMNIs4zHxhchZbPO1U+ASK0lJc9BjFNkH
awHUrBCZouFOdrSXizi3ct3nL00YhxRqxG+TvtavHNlpQIaINpe/u4tokakjRAAb
bZu0kE/e2QY6MLEQgc258v4EG0sUqG5ATwjVsQEPw8boPrs7pfrf8biT5u9NGC0Q
cj+Aw3P4xwhUYeZfOqEpP8Hx81tFrkU50r6pv9BcgEWfqH2UJapuGQhG43/lZH9q
ysqNvxc98ENV4gCxIlQcFEz7mMhs11GJjETofTrITwnzPRz/T4iDwoeDRWRb+FbL
Wpf3+toBVYN/kLe9RiOURzxKzfYHnKOtLGiDRyxKcv/haplQ9elsR3DCbV0Bvo8t
zRQWuyn7uonD4Kg4Iau08uz+J2I+43tad7I/PTYGZTEyKve0gNQ=
=mGT9
-----END PGP SIGNATURE-----

--=-ZI4UfKIuVxdU0PvtDlyc--
