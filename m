From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/2] mlx4 RSS fixes for 4.15
Date: Fri, 10 Nov 2017 13:05:43 -0500
Message-ID: <1510337143.3735.6.camel@redhat.com>
References: <20171025193935.1075-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-sE603UV8ox4H3kxBEdU8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171025193935.1075-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-sE603UV8ox4H3kxBEdU8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-10-25 at 22:39 +0300, Leon Romanovsky wrote:
> Hi Doug,
>=20
> There are two mlx4 RSS fixes for v4.15
>=20
> Thanks
>=20
> The patches are available in the git repository at:
>   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-n=
ext-2017-10-25
>=20
> 	Thanks
> ---------------------------------------
>=20
> Guy Levi (2):
>   IB/mlx4: Add report for RSS capabilities by vendor channel
>   IB/mlx4: Fix RSS's QPC attributes assignments
>=20
>  drivers/infiniband/hw/mlx4/main.c    | 17 +++++++++++++++++
>  drivers/infiniband/hw/mlx4/mlx4_ib.h | 16 +++++++++++-----
>  drivers/infiniband/hw/mlx4/qp.c      | 16 +++++++++-------
>  3 files changed, 37 insertions(+), 12 deletions(-)
>=20
> --
> 2.14.2
>=20

Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-sE603UV8ox4H3kxBEdU8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloF6ncACgkQuCajMw5X
L913BhAAumISYPGCr3ChJ6uO2HVOZqZQvJrpHApG+Ne+OZ0U77+EY+VsrhxrpbPh
Sp5Vr/79dqBKKVTl3v+fwy7yAVSQS4zFpcWaUaDI+0SEEImxD+rZMjoSWdG3gA6D
QNfjFXB3Z3h6dcNbbqyBQdTWa455WLo2aFB3iCMoCbB1KezYcyx0cgfV2Uc7r54W
Q2mF4iTVLIxdi6RZYxQUScTR6cCC+SLRUory5NEAsL9IQ3MW27bGlaGiG1UP9BOv
I5oZTghkIKC0DquTXBDfiZ9tlTtQE1YMEs4aZlPyN7X1qKVDR2G25JDoRcuYprRp
/HoV5XYFhpcetGKObqyj8ngV+m3QQZfY6McRPK1+h9VkLdoIHUwCjBkTjm5SNwE4
v7r1nKYjvztppCtPMUtAgUIfRUh9dOwAWdYD7eSIJNrC/PFM7tP2kYtYEWaxL8zO
2rtbTwhAZvcRF2KwjXnu7wiLfVl3AN06IayASjnsPvrwLW6/ZJS88/1ZgvLclw5N
X8/z4EZ0I6SIEOiPNUNd34BOENNe38sjqgk8I2zyEDOX1oCFO1H54kk/Mtq9iIvW
rA5xkY57zKc/z3aPjCazo9rgyxzQ4MoPlKifd9DObF20T30mE38F5ol73z4u1dxu
BraOtUg6vjBIxOhkMc2wA1i8bq8AGrMTGNXA6aWOP/ccVgs+LP0=
=UM6m
-----END PGP SIGNATURE-----

--=-sE603UV8ox4H3kxBEdU8--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
