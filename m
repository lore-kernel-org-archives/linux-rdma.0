From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/ipoib: Remove the unnecessary error check
Date: Tue, 24 Jan 2017 16:22:51 -0500
Message-ID: <1485292971.43764.73.camel@redhat.com>
References: <1484799366-3463-1-git-send-email-yanjun.zhu@oracle.com>
         <20170119083507.GO32481@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-8Sn9TpptISBiOn5mCyJE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170119083507.GO32481-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-8Sn9TpptISBiOn5mCyJE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-01-19 at 10:35 +0200, Leon Romanovsky wrote:
> On Wed, Jan 18, 2017 at 11:16:06PM -0500, Zhu Yanjun wrote:
> >=20
> > The function ipoib_mcast_start_thread/ipoib_ib_dev_up always return
> > zero.
> > As such, in the function ipoib_open, err_stop will never be
> > reached.
> > So remove this err_stop and change the return type of the function
> > ipoib_mcast_start_thread/ipoib_ib_dev_up to void.
> >=20
> > Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0drivers/infiniband/ulp/ipoib/ipoib.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 4 ++--
> > =C2=A0drivers/infiniband/ulp/ipoib/ipoib_ib.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0| 6 +++---
> > =C2=A0drivers/infiniband/ulp/ipoib/ipoib_main.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0| 6 +-----
> > =C2=A0drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 4 +---
> > =C2=A04 files changed, 7 insertions(+), 13 deletions(-)
> >=20
>=20
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, added to -next.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-8Sn9TpptISBiOn5mCyJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8WrAAoJELgmozMOVy/dxtoQAJbWZcTnB3clzvGk0TsBL9c+
8yRSHEiqKiMuj7p6TLHxgKbpBgM6A9fPffLd4s812lbm+U9vYXNHnRZOYEFox3O3
12gsOqTz+Wdfe1bVkg0F42q3D3oVj1zFiXKR1FjcaFy9d/IwngN+4blYzw1KoYMV
nMdlCnmbR0gxUUbBGJCWpz5SgqyyHdARJChRrFqz3TfEw7KR20Zg//HRasVrzkTH
x20VeSHG5sh8KmU25NhuBFMXnuLDt5Uc/x3x8/Aun7sMng4TcRXM1XBvEzS2X2gy
R0liOTozb8rcxs2LJwPZG7g7VntafEKbrYrrbCqN0XJ9uVVgs9T6YJBUiAV0N5kT
YuAM7clPVOmWrRGgt+1cNCRTeUUvDg9x9V2WoHvRQbMar4jcQhH8uCLhfuLDzm0C
2LeZfdGpCYP7Tjzlwup2HJLJEd8SP/eFSGXMwu8SnCoD22ObJT6GteYzcdb9r4+/
b3femaNEm9aTh5oNkgBcid0JQfXEKOn4sFFyFFh5wHCahPjD5xvW3uEugzNxc/N4
Mv7AQgPu5fRYjUwD0DRQZ9H32f6sS7oau+Pn6MZSEP8LTfpazg04TWBq99IrpR6+
PbAww9k1+TnubHsQKCp/qj87HhMDqH2XFzANulUW5NTafYUZ+iiBO5Wp0d0m86X9
WT9NMS+sqKTQdyzP+6ie
=B+L0
-----END PGP SIGNATURE-----

--=-8Sn9TpptISBiOn5mCyJE--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
