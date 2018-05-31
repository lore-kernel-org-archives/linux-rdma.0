From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 0/2] Mellanox, mlx5 new device events
Date: Thu, 31 May 2018 14:08:40 -0400
Message-ID: <55f448f04bcd26c87ca97c53e700faddd4f43486.camel@redhat.com>
References: <20180530175950.9488-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-6TzZ2MqOMIDJCmO1t8ST"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180530175950.9488-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


--=-6TzZ2MqOMIDJCmO1t8ST
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-05-30 at 10:59 -0700, Saeed Mahameed wrote:
> Hi,=20
>=20
> The following series is for mlx5-next tree [1], it adds the support of tw=
o
> new device events, from Ilan Tayari:
>=20
> 1. High temperature warnings.
> 2. FPGA QP error event.
>=20
> In case of no objection this series will be applied to mlx5-next tree
> and will be sent later as a pull request to both rdma and net trees.
>=20
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/lo=
g/?h=3Dmlx5-next
>=20
> v1->v2:
>   - improve commit message of the FPGA QP error event patch.
>=20
> Thanks,
> Saeed.
>=20
> Ilan Tayari (2):
>   net/mlx5: Add temperature warning event to log
>   net/mlx5: Add FPGA QP error event
>=20
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c | 28 +++++++++++++++++++-
>  include/linux/mlx5/device.h                  |  8 ++++++
>  include/linux/mlx5/mlx5_ifc.h                |  3 ++-
>  include/linux/mlx5/mlx5_ifc_fpga.h           | 16 +++++++++++
>  4 files changed, 53 insertions(+), 2 deletions(-)
>=20

For the RDMA community, series ack:

Acked-by: Doug Ledford <dledford@redhat.com>

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-6TzZ2MqOMIDJCmO1t8ST
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlsQOigACgkQuCajMw5X
L92VvxAAk9IO0+un7DD9AWl114Z+OThsQUsgWPakGiEvbphAeRcjzgpa2wWfhExd
EQrsKxCsX///a4xGPZRhnUadAX8PaarqpyA4NtkKv1lyWGLEUlwnW5TVghcmnOeM
SSlwLD/03IFiYympT+LGQtwHZJHEUo37urTO07YzbfSujvjo7HzT5lofXfEFfG3T
b3YNPN9xbeMyX5tOeWyRIJ08FssnUOqv6UDrSwcP1vgdYXlIgK7LFrHJo37d5oa9
HHQBhTt/sEJxPM/qlG/4K/dkriVeIfcmuaqR0NQcidM0PG5vN546XeWrWjNatrEN
sHwUP8lk880Mbw+vkcNFR/IQEnm8XE1GadwwBdligaBEOi5XnouiGXTqDFFfhpIw
DU1MZyZu2j7sRiRfnLlxaZnipy3+1FXVonTFo5wgGF996ShZsLlGWMM6BJjKlhfX
hAYZyKMrmtGYJJKyaCB8EXe3FfKbwG7Mf5T92/aH8NnJ8bueD10i/y/6rgw3rQ3T
3Ts6p3+Q9W+ndHFbu/CGJ/UNysmTjvhWfxa6e/WP+W9HQ3wFsvSWyKpClITR2wTn
FxXGYKVpBFSH/3gLHrsjzXy3UINPYVgkZdeJnaOWoFZSk2mIstBvvux+uERWLGeQ
uhD9FCzhXG+TiMwJac0Iok1wy8nkinu8LjsFHEvbPqgH5ZM7nMI=
=eDjq
-----END PGP SIGNATURE-----

--=-6TzZ2MqOMIDJCmO1t8ST--
