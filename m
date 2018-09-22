From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH rdma-next 0/4] mlx5 vport loopback
Date: Fri, 21 Sep 2018 21:38:38 -0400
Message-ID: <62a9cd903ee9d27dbc109160add3138bfd5e9941.camel@redhat.com>
References: <20180917103049.18235-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-seCMpo2WBGYb8Lf8dODi"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917103049.18235-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-seCMpo2WBGYb8Lf8dODi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-09-17 at 13:30 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>=20
> Hi,
>=20
> This is short series from Mark which extends handling of loopback
> traffic. Originally mlx5 IB dynamically enabled/disabled both unicast
> and multicast based on number of users. However RAW ethernet QPs need
> more granular access.
>=20
> Thanks
>=20
> Mark Bloch (4):
>   net/mlx5: Rename incorrect naming in IFC file
>   RDMA/mlx5: Refactor transport domain bookkeeping logic
>   RDMA/mlx5: Allow creating RAW ethernet QP with loopback support
>   RDMA/mlx5: Enable vport loopback when user context or QP mandate
>=20
>  drivers/infiniband/hw/mlx5/main.c                  | 61 ++++++++++----
>  drivers/infiniband/hw/mlx5/mlx5_ib.h               | 16 +++-
>  drivers/infiniband/hw/mlx5/qp.c                    | 96 ++++++++++++++++=
+-----
>  .../net/ethernet/mellanox/mlx5/core/en_common.c    |  2 +-
>  include/linux/mlx5/mlx5_ifc.h                      |  4 +-
>  include/uapi/rdma/mlx5-abi.h                       |  2 +
>  6 files changed, 138 insertions(+), 43 deletions(-)
>=20
> --
> 2.14.4
>=20

Thanks, first patch pulled from mlx5-next, remainder of series applied.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-seCMpo2WBGYb8Lf8dODi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlulnR4ACgkQuCajMw5X
L90vcg/+JOE0Heb+2l7ZWDaJlEGFxG2uNn2U6ijCO/x2h5OlndnGHTcG+d+h5km6
fDA9GFNhWeRaM2U+iQyknNqhdU/u3Q1r2sMJilsTkLPx8vuoWxr5mcz50orViNKl
c86j2lVqdzC9O3BMH243WArV4y1orYCkJDcalDUWhQxAxOLNNqQZYfn194dQDO6c
dN+E7FH1cbotRUB4L/cAL88iBQZgdStgjcr/l+LnOzqtaIgaAz0zDg9RJEpFIYPS
DS329z3+kH40lyP0UfhyR4x9axZvpiRBli8ZPAoxc6LzeYbfmV/b6VkgXPcuGyak
xq+F0/3Ot2vJIDzUTK5Xy/v6glU77UD+BlMUNYl9Ag8KdNLVI532E3HO/sRbWeWq
21n8g8TzEbTMYm7ZHqP/T6GKsXYY9198nFAAQto6G8AWQ6edPN1V37zxX5nQN1ik
AbSuA1l1GdDvRGvlw/iJGjDyU2fyNspRnFO/bHGLxr9XL2Yk4jR4snfqcmM2FRFc
s0B3tqyoATpMxkrhY88LYrah1f1bUB6l6XuWX4jYwmFQ5mGA1iHGzRflZQFO95iu
FbtkSTHU87H+XjK2x1xuigkimyNl4F5ZJjLCmjmQgzBnbidQDIV2l4ryKyHDTcxL
MzWr3dnS+z07uBxRKx49yERKBABtGLq2dbhJgMfbqYw43Q3HBpk=
=lMkl
-----END PGP SIGNATURE-----

--=-seCMpo2WBGYb8Lf8dODi--
