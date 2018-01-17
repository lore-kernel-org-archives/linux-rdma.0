From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: krping problem on 4.15-rc4
Date: Wed, 17 Jan 2018 16:03:33 -0500
Message-ID: <1516223013.3403.285.camel@redhat.com>
References: <CAN-5tyH1HO7yzzQLyb5z5Pq=OrHnKzmCrR2MffLguqsEA-mwWg@mail.gmail.com>
         <00ff01d38a4f$1a979eb0$4fc6dc10$@opengridcomputing.com>
         <CAN-5tyEwdSOiAk04xjfazxBqwkkTiCjr2dVcCoYLQJw8f37U=w@mail.gmail.com>
         <017d01d38b14$cbe95670$63bc0350$@opengridcomputing.com>
         <CAN-5tyGq=hmXY9HZYXpfaytOUV=gb0fri69gj69WKbbYtW3nTQ@mail.gmail.com>
         <006d01d38c02$793de8c0$6bb9ba40$@opengridcomputing.com>
         <CAN-5tyG9ZsaKZs3ayfFfuy7o25DrXR2yWmwUvLdNutJ1SbEg1w@mail.gmail.com>
         <CAN-5tyFSYWaTPVdq=99Yr9XwnULyf4tw06roZys=rtR0F3x03g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-1VqenFrSFmSzOIG4yzl3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN-5tyFSYWaTPVdq=99Yr9XwnULyf4tw06roZys=rtR0F3x03g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-1VqenFrSFmSzOIG4yzl3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-16 at 16:14 -0500, Olga Kornievskaia wrote:
> On Tue, Jan 16, 2018 at 2:50 PM, Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org> wrote=
:
> > On Fri, Jan 12, 2018 at 7:07 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+v7I7tHvgBF7@public.gmane.org=
m> wrote:
> > > > > Ok.  The memory probably doesn't matter.  Maybe run krping client=
 and
> > > >=20
> > > > server on the same host (to use hw-loopback), and see if it works o=
n both,
> > > > one, or neither systems when they are both the client and server.
> > > >=20
> > > > Loopback on the original "server" machine produces the same failure=
.
> > > > Jan 12 17:05:40 localhost kernel: mlx5_0:dump_cqe:277:(pid 0): dump=
 error
> > > > cqe
> > > > Jan 12 17:05:40 localhost kernel: 00000000 00000000 00000000 000000=
00
> > > > Jan 12 17:05:40 localhost kernel: 00000000 00000000 00000000 000000=
00
> > > > Jan 12 17:05:40 localhost kernel: 00000000 00000000 00000000 000000=
00
> > > > Jan 12 17:05:40 localhost kernel: 00000000 93003204 1000017c 0005e1=
d2
> > > > Jan 12 17:05:40 localhost kernel: krping: cq completion failed with
> > > > wr_id 0 status 4 opcode 0 vender_err 32
> > >=20
> > > Can someone from Mellanox comment more on the above CQE error?  What =
exactly is it tell us?
> > >=20
> > > >=20
> > > > What does this means?
> > >=20
> > > Not sure.  But it does seem to be tied to that specific machine.  Que=
stion:  Is an IOMMU enabled on that system?
> >=20
> > IOMMU (Inter's VT-d) is enabled in BIOS (on both machines).
> >=20
> > >  Perhaps that is exposing a dma mapping problem with krping?
>=20
> I have replaces the CX-5 card with another one and I no longer see the
> krping problem.  I think it speaks that it's a card issue...

Check the firmware on the bad card.  Lots of issues disappear if you
have older firmware and update to the latest.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-1VqenFrSFmSzOIG4yzl3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpfuiUACgkQuCajMw5X
L90oUw/+PAE6rOwj5xHd54h96By/dvP275tmwb5QgsiKZhZURlYKYrf3dJlBgbER
bAD1RQyMuc2AOCbsVnkRpqXXVEGymzQIQYA6zlH+s7BVHKA/DhOPEil6MJD9hIut
V9q6CELm4vP+mV8fSvCMt7TGfMEDIkOgEIlPHmtl8qnKn71vDb8l29tP/DWMilSZ
CCdKXVIToDgEiZEQxxFRxtakjGhoSMtUHBHXfuiZFRen+G/fpXS3QWdoeb1fBXls
Rfri1ggksOW/gkw4HPZntxcZ00L6xH+UfhQcbwxnD6csO9dHRkFJ8X3QD37qZMla
GMEbYBD31JVEmpig+iafdTJIuCQ6QbaDO5Kr1ywds9RX5S9kZ4zGY4N/pimF0q2F
SLkapUHGTBIaZsoDfdP1KmbAs0UieIy8/SVrbb8+IdAzS9Lxwss7nOH7jtL/UUJ1
UOenZnMXLbET0CAysKSpzkSLP1eJBSQLmgrapJWiSvIpVX1HCXTPDHt/5WBHRdbn
64mnNqfcBbFsEQ0wMnBfiK7y2V+MnPaVVWnGE1C54DWVNJ6JiPAitb/wE65Ae4Fg
3mHPeaydBwp62sKktgm9qF1FnziMXTS+kduPXXOP3m+Z58k2x1m96q7VpoxDuTBc
Efa2m6QQG9ZHWQjpEZXJgb9Rl9pe5nz97wW+ekkHJKmAvvCNWJA=
=8W6l
-----END PGP SIGNATURE-----

--=-1VqenFrSFmSzOIG4yzl3--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
