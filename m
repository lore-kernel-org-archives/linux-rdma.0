From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v6 0/9] SELinux support for Infiniband RDMA
Date: Tue, 24 Jan 2017 16:40:15 -0500
Message-ID: <1485294015.43764.91.camel@redhat.com>
References: <1479910651-43246-1-git-send-email-danielj@mellanox.com>
         <a56c4be8-f908-4774-dd1c-c6bbab5c1b03@tycho.nsa.gov>
         <DB6PR0501MB2422DCC01A577CDA280C2C82C49B0@DB6PR0501MB2422.eurprd05.prod.outlook.com>
         <CAHC9VhTdntem1hK0arEo4p1MWPH5sjzDN0yG_=1S7ui=C4i8Yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-S4b62BVvuGHH0LK2GxN5"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAHC9VhTdntem1hK0arEo4p1MWPH5sjzDN0yG_=1S7ui=C4i8Yg@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>, Daniel Jurgens <danielj@mellanox.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "eparis@parisplace.org" <eparis@parisplace.org>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>
List-Id: linux-rdma@vger.kernel.org


--=-S4b62BVvuGHH0LK2GxN5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-12-13 at 17:17 -0500, Paul Moore wrote:
> On Tue, Dec 13, 2016 at 11:25 AM, Daniel Jurgens <danielj@mellanox.co
> m> wrote:
> >=20
> > On 12/13/2016 9:01 AM, Stephen Smalley wrote:
> > >=20
> > > For the LSM/SELinux bits,
> > > Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> > >=20
> > > Note that there will be a merge conflict on classmap.h due to
> > > commits in
> > > the selinux next branch, but that should be easy to resolve.
> > >=20
> > > We'll need the patches for the selinux userspace and refpolicy.
> >=20
> > Thanks Stephen, I need to rebase the user space and do some patch
> > breakup.=C2=A0=C2=A0I'll start on that soon.
>=20
> Sorry, I haven't had a chance to look at v6, but considering all our
> discussions on the previous versions I don't expect any issues from
> me.=C2=A0=C2=A0I was hoping for some more generic hooks/controls, but tha=
t
> doesn't look to be possible given the nature of RDMA.=C2=A0=C2=A0I also w=
ant to
> mention again the need for tests; we've talked about this in the past
> and while it isn't possible to run the tests without IB hardware, I
> would like to see us merge tests into the selinux-testsuite so that
> those who do have the required h/w available could run the tests.
>=20
> Assuming we can sort out the SELinux userspace and and tests by the
> end of January, I see no reason why this couldn't go in for v4.11.

Daniel, can you work with people on the userspace and tests? =C2=A0I'll pul=
l
this into a branch (I assume by Paul's and Stephen's comments that they
expect it to go through my tree) ready to go, but hold actually
submitting it in the merge window until I've heard more from you all
that userspace is ready.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-S4b62BVvuGHH0LK2GxN5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8m/AAoJELgmozMOVy/d9v8QAIlrtUfgYswbLMIPD9+oiLmJ
mZ5utEell/7D7UE8uVm0xbsucrN4F+JNAxfnGKm9vha7AJk40nbP9PKkPciReKaw
8aaABiUCNdxKleswsafNKp4+MGpSMklNIz0iUvz9Vq4p7bcrvzQF3+zzonoYoqjp
gt5opO3lf3uh9WA2kyJoOdQN1pHYVsg4E/VbcDz26HVR9nXL5iYSMzSNpOwb23MU
Yv9c4OfYFWwVlg9LP83T3Quc4Q5q6SBufKhJ6w/SxxvldIwGldY4IM0mCo9E2OMq
X5yb68Sk3R/45715tFoOJGhN65K88Kg+OtlMLM+XP2wyHZawL0nzsIrIpaJk1KLs
+Q/wa8a2Gu1eRnWLS7pA7Tm1myf2hUZh23hSBE/efoDb82z5OtZ5gJZgI/J4h2+W
BZhaaOJvMmQVD8cFIgn8tDKvwifNu2t3EW0evtu7+YxfpP896N0draszABN83XWp
akn00cCjnGW3Tu8IaSlA3xBVZ8DGgCEPX9VKEKdcGLn/zX6RquzRXo7gpDmI9KtL
6gCfpSFLBwlTn734Clb8lQzIS0DgoCq1PCrUvz49k8x+QZ1ILJS5M7hs07eOuo3N
xxrDdvGMK0Y3WeGuoXD/fHKFw1lFi1G7eEqJfL0sCZy0aAJ5Y6CaEG1sJZg46/vT
VjGSedPyjrCMsWI2byco
=Pznn
-----END PGP SIGNATURE-----

--=-S4b62BVvuGHH0LK2GxN5--

