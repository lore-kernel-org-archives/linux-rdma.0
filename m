From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH rdma-next 0/7] Enrich DEVX support
Date: Tue, 04 Dec 2018 14:02:01 -0500
Message-ID: <95c8a200842de2a78af89ad2d5c051db0577fdfe.camel@redhat.com>
References: <20181126062838.5907-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-8sF7pnVrRmaksomMsDdt"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126062838.5907-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-8sF7pnVrRmaksomMsDdt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-11-26 at 08:28 +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>=20
> From Yishai,
> -----------------------------------
> This series enriches DEVX support in few aspects: it enables interoperabi=
lity
> between DEVX and verbs and improves mechanism for controlling privileged =
DEVX
> commands.
>=20
> The first patch updates mlx5 ifc file.
>=20
> Next 3 patches enable modifying and querying verbs objects via the DEVX
> interface.
>=20
> To achieve that the core layer introduced the 'UVERBS_IDR_ANY_OBJECT' typ=
e
> to match any IDR object. Once it's used by some driver's method, the
> infrastructure skips checking for the IDR type and it becomes the driver
> handler responsibility.
>=20
> The DEVX methods of modify and query were changed to get any object type =
via
> the 'UVERBS_IDR_ANY_OBJECT' mechanism. The type checking is done per obje=
ct as
> part of the driver code.
>=20
> The next 3 patches introduce more robust mechanism for controlling privil=
eged
> DEVX commands. The responsibility to block/allow per command was moved to=
 be
> done in the firmware based on the UID credentials that the driver reports=
 upon
> user context creation. This enables more granularity per command based on=
 the
> device security model and the user credentials.
>=20
> In addition, by introducing a valid range for 'general commands' we preve=
nt the
> need to touch the driver's code any time that a new future command will b=
e
> added.
>=20
> The last patch fixes the XRC verbs flow once a DEVX context is used. This=
 is
> needed as XRCD is some shared kernel resource and as such a kernel UID (=
=3D0)
> should be used in its related resources.
>=20
> Thanks
>=20
> Yishai Hadas (7):
>   net/mlx5: Update mlx5_ifc with DEVX UCTX capabilities bits
>   IB/core: Introduce UVERBS_IDR_ANY_OBJECT
>   IB/core: Enable getting an object type from a given uobject
>   IB/mlx5: Enable modify and query verbs objects via DEVX
>   IB/mlx5: Enforce DEVX privilege by firmware
>   IB/mlx5: Update the supported DEVX commands
>   IB/mlx5: Allow XRC usage via verbs in DEVX context
>=20
>  drivers/infiniband/core/rdma_core.c   |  27 +++--
>  drivers/infiniband/core/rdma_core.h   |  21 ++--
>  drivers/infiniband/core/uverbs_uapi.c |  10 +-
>  drivers/infiniband/hw/mlx5/devx.c     | 142 ++++++++++++++++++++++----
>  drivers/infiniband/hw/mlx5/main.c     |   4 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h  |   6 +-
>  drivers/infiniband/hw/mlx5/qp.c       |  12 +--
>  drivers/infiniband/hw/mlx5/srq.c      |   2 +-
>  include/linux/mlx5/mlx5_ifc.h         |  26 ++++-
>  include/rdma/uverbs_ioctl.h           |   6 ++
>  include/rdma/uverbs_std_types.h       |  12 +++
>  11 files changed, 215 insertions(+), 53 deletions(-)
>=20
> --
> 2.19.1
>=20

Hi Leon,

I've put this into my wip/dl-for-next branch.  Because it pulled in the
mlx5-next tree (which was significant because the patch we wanted was at
the tip and a whole slew of other patches were before it), the changeset
for this patch looks much bigger.  And it had the merge conflict you
mentioned.  You might want to double check my work before it gets moved
over to the official for-next branch.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-8sF7pnVrRmaksomMsDdt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlwGzykACgkQuCajMw5X
L9087A//Zey4NSRyK3Fh9APTVucwoiS7J7MNuWA78ecJldxShU9YYb6uhlBHu2U4
1k0/ScCr24ayEqb2bct5eIhJy00uTvN1MlPu5gT3DqRgJYbAyMJI260/jJDIBrd/
Cn36Jb843vTYYtBk+gFaufACbVddSw+aoFoIy1VtFwZXlU2QGp3wB7KfeChv0TdX
0dLtnDd+fKpWdWOJ6cgUkWz8sjCeta+hxn25cv3/0HqriqN74xtw81XJ8YXU0oej
5BF1s1Km6MBEsAggXRQAgBlPSxs1dR1smNiwFchgQCknSY7ljRUGCrOQOhOxE/6L
2DfDsQHRYPW0fsLdVLrCctuAvLL2VkhYvt4qEaU11JJc53aAwvNshA/8H3nzTt63
Lj+nTVMChWzEN/MjAo07s3dbAixD1zwklfbnTzrtPECOy//tmrXNCzfKIa3IYOOC
klLAnjLiP3belCiy2MWnHeNsynh0zOYfUjzCvjsY9Oa4HyazVPUBJUJvDbZNDuWg
beifWN2JpEEViM+vwMgZnu1sPB3e6HsOa78TzBf9eIQy4xe6ZedZhfrzAQQF7ebc
qb7QaaIKWcu0qDtENVQ85oL7x1Rz3jT9IhcU8S3+9N8Q7ojRZ0Q0YFDimsLm4rR/
0kgCyJ43yMBj6Ym6rt4bD6Xquytlj1R5z+fSoQXG75EL/NF9p10=
=IHyM
-----END PGP SIGNATURE-----

--=-8sF7pnVrRmaksomMsDdt--
