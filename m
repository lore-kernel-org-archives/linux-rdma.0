From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 0/9] SELinux support for Infiniband RDMA
Date: Tue, 24 Jan 2017 16:45:35 -0500
Message-ID: <1485294335.43764.94.camel@redhat.com>
References: <1479910651-43246-1-git-send-email-danielj@mellanox.com>
         <a56c4be8-f908-4774-dd1c-c6bbab5c1b03@tycho.nsa.gov>
         <DB6PR0501MB2422DCC01A577CDA280C2C82C49B0@DB6PR0501MB2422.eurprd05.prod.outlook.com>
         <CAHC9VhTdntem1hK0arEo4p1MWPH5sjzDN0yG_=1S7ui=C4i8Yg@mail.gmail.com>
         <1485294015.43764.91.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-mltQBZa7of2e1d0j+ajU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485294015.43764.91.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-mltQBZa7of2e1d0j+ajU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-01-24 at 16:40 -0500, Doug Ledford wrote:
> On Tue, 2016-12-13 at 17:17 -0500, Paul Moore wrote:
> >=20
> > On Tue, Dec 13, 2016 at 11:25 AM, Daniel Jurgens <danielj@mellanox.
> > co
> > m> wrote:
> > >=20
> > >=20
> > > On 12/13/2016 9:01 AM, Stephen Smalley wrote:
> > > >=20
> > > >=20
> > > > For the LSM/SELinux bits,
> > > > Acked-by: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
> > > >=20
> > > > Note that there will be a merge conflict on classmap.h due to
> > > > commits in
> > > > the selinux next branch, but that should be easy to resolve.
> > > >=20
> > > > We'll need the patches for the selinux userspace and refpolicy.
> > >=20
> > > Thanks Stephen, I need to rebase the user space and do some patch
> > > breakup.=C2=A0=C2=A0I'll start on that soon.
> >=20
> > Sorry, I haven't had a chance to look at v6, but considering all
> > our
> > discussions on the previous versions I don't expect any issues from
> > me.=C2=A0=C2=A0I was hoping for some more generic hooks/controls, but t=
hat
> > doesn't look to be possible given the nature of RDMA.=C2=A0=C2=A0I also=
 want
> > to
> > mention again the need for tests; we've talked about this in the
> > past
> > and while it isn't possible to run the tests without IB hardware, I
> > would like to see us merge tests into the selinux-testsuite so that
> > those who do have the required h/w available could run the tests.
> >=20
> > Assuming we can sort out the SELinux userspace and and tests by the
> > end of January, I see no reason why this couldn't go in for v4.11.
>=20
> Daniel, can you work with people on the userspace and tests? =C2=A0I'll
> pull
> this into a branch (I assume by Paul's and Stephen's comments that
> they
> expect it to go through my tree) ready to go, but hold actually
> submitting it in the merge window until I've heard more from you all
> that userspace is ready.

Although it would also be helpful if you could rebase on a current tree
(preferably my k.o/for-4.11 branch).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-mltQBZa7of2e1d0j+ajU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8r/AAoJELgmozMOVy/dw2IQAJhAk2SJVRze630PcYWxS6jJ
dEdTlpDvHhGu/yG1TDCeGfb2H4vY8RJqn+KEKlTj/RaLH2u/R6E2GWy7S38Lz1pB
Hbgd2XH8E21S/BYIQDrLy+DeOLoeDyn3id32XkR2wPmTxiyLqjesieBVt4OgULgF
zuACIDQdeH5nVVrslXwmnKOPeIN1YlmVGzXV0vee7Wcy5fXKNrq+39XAxLRHHpEo
QUoZeX7yQ204sEOgasoafS4oUmNiKkXdpJ8Dl44IXFibQr6Cs2Q8+DJQSCnt7FwP
AIRatR9etCL1RpkRegQCK9FauNJiSQTPb4+VPe60BjXqh9ESQrIMkgvHl2Ui2Ta5
wpTNm9b54eNabqtn5UVou3F78ovuLk+xOTRQf5Bkkn4PuDynucBe416c5UJJ8mhw
KBU2XxJvae1gXKZVhkKKcmnctRwhs3vHfcrkBKH1dxIl2xJ7BAUOfroX4umRsesR
EKKfZKLy8qlB3kp2auAhPtYM5kU9oT/E/3FuqjNgeSaKyOW+tRkXfdqRiLvLgDpq
W9moaNKJ2EnVmemeuD0VpJc1t5A3S86O2EjKZk2wfc2+h7r72DvA9mQZUFzbWkI+
IMk4hBldX45OHuJE7rq8nx3vgffjezbvm+FfvuwT7cnBc5FKb0CLFvC5HPkNvYRT
9xJhUYwDdGl+p+Xyo2WY
=uGIk
-----END PGP SIGNATURE-----

--=-mltQBZa7of2e1d0j+ajU--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
