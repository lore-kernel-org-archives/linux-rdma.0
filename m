From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 0/9] SELinux support for Infiniband RDMA
Date: Wed, 25 Jan 2017 12:25:21 -0500
Message-ID: <1485365121.2432.6.camel@redhat.com>
References: <1479910651-43246-1-git-send-email-danielj@mellanox.com>
         <a56c4be8-f908-4774-dd1c-c6bbab5c1b03@tycho.nsa.gov>
         <DB6PR0501MB2422DCC01A577CDA280C2C82C49B0@DB6PR0501MB2422.eurprd05.prod.outlook.com>
         <CAHC9VhTdntem1hK0arEo4p1MWPH5sjzDN0yG_=1S7ui=C4i8Yg@mail.gmail.com>
         <1485294015.43764.91.camel@redhat.com>
         <CAHC9VhTfuftm1oyiBOa4Fx4L-12eX8MCySiS1H98yroCuuoieA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-LaaFg6qRxGiJvLNGvjrx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHC9VhTfuftm1oyiBOa4Fx4L-12eX8MCySiS1H98yroCuuoieA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org" <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, "eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org" <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-LaaFg6qRxGiJvLNGvjrx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-25 at 02:58 -0500, Paul Moore wrote:
> On Tue, Jan 24, 2017 at 4:40 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> >=20
> > On Tue, 2016-12-13 at 17:17 -0500, Paul Moore wrote:
> > >=20
> > > On Tue, Dec 13, 2016 at 11:25 AM, Daniel Jurgens <danielj@mellano
> > > x.co
> > > m> wrote:
> > > >=20
> > > >=20
> > > > On 12/13/2016 9:01 AM, Stephen Smalley wrote:
> > > > >=20
> > > > >=20
> > > > > For the LSM/SELinux bits,
> > > > > Acked-by: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
> > > > >=20
> > > > > Note that there will be a merge conflict on classmap.h due to
> > > > > commits in
> > > > > the selinux next branch, but that should be easy to resolve.
> > > > >=20
> > > > > We'll need the patches for the selinux userspace and
> > > > > refpolicy.
> > > >=20
> > > > Thanks Stephen, I need to rebase the user space and do some
> > > > patch
> > > > breakup.=C2=A0=C2=A0I'll start on that soon.
> > >=20
> > > Sorry, I haven't had a chance to look at v6, but considering all
> > > our
> > > discussions on the previous versions I don't expect any issues
> > > from
> > > me.=C2=A0=C2=A0I was hoping for some more generic hooks/controls, but=
 that
> > > doesn't look to be possible given the nature of RDMA.=C2=A0=C2=A0I al=
so
> > > want to
> > > mention again the need for tests; we've talked about this in the
> > > past
> > > and while it isn't possible to run the tests without IB hardware,
> > > I
> > > would like to see us merge tests into the selinux-testsuite so
> > > that
> > > those who do have the required h/w available could run the tests.
> > >=20
> > > Assuming we can sort out the SELinux userspace and and tests by
> > > the
> > > end of January, I see no reason why this couldn't go in for
> > > v4.11.
> >=20
> > Daniel, can you work with people on the userspace and tests?=C2=A0=C2=
=A0I'll
> > pull
> > this into a branch (I assume by Paul's and Stephen's comments that
> > they
> > expect it to go through my tree) ready to go, but hold actually
> > submitting it in the merge window until I've heard more from you
> > all
> > that userspace is ready.
>=20
> I don't have a problem pulling this in via the SELinux tree, assuming
> you are okay with that Doug.=C2=A0=C2=A0I'm just waiting to see tests for=
 the
> selinux-testsuite first.

When I tried to apply the patchset, the conflicts started on the very
first file of the very first patch. =C2=A0It can go through your tree, but =
I
suspect there will be lots of conflicts that way as this upcoming
release has been touching the cache area of the IB stack and so does
this code. =C2=A0There might be significant SELinux conflicts too, I don't
know, but we know there are IB ones so far.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-LaaFg6qRxGiJvLNGvjrx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYiN+BAAoJELgmozMOVy/dujIP/R3papP8Hdh3HJO5bZbnAqbC
9rVpup6UWpUE1slPX16VnkG/JQiVkaDFDfHncS637N32MOrWF/C1NIJcldJsTR08
NbrL1ePB/mDABu9UFlgaiTJTzhPYMm9YcUt6AvagzaNWTnL0bbo3JULsb6u4rP4N
C7rkMFpJebPHJbS7dyPRx1TpfwzTxqyLkhR94Ee/A6wQbz7ztTWtIeR9OCXpNgZP
4+tKtRU+zyf2TwidMmKLHj90j4ULej8GTLmFNz8O9rqBDnK4RtbxT/QsBIVDvZ5z
pQUrGwjGKT6gupnnjA+MS01z49YatXh0pBS8OoF38JoHPoG81xfmRh3NIf4CCdK9
KnK02fg93YcQaS54i4pjjraroGVrI8tvjy3Z58bHU3lz75DEkkyFZk3RgY0mJVCK
0ALvt9DsCT8KPTXCA2JmAsc6n5HIlDxuaAMEj930lrBTL9x2lqAK3bvhWvZkgsx9
/wQ2yfMxcF+tD7427UEPrPTNIh/PFPs017cO6SCdpY+D2WKVjVv3sNZMR23FLslR
lHkXLcQUmysDcwAFPaA6D0BdtvsqkZGzEZN3S6Ta23KVRCk1Ms9/+uQrj2liOR5Q
MmooxgltXHpgQJb+gmVYJsG4UR3zBz3CxoPzcTimNjm84faHFpIRrZxTJG/5dDuz
n2yUkK6k5T6DwRi4Nk5J
=rO85
-----END PGP SIGNATURE-----

--=-LaaFg6qRxGiJvLNGvjrx--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
