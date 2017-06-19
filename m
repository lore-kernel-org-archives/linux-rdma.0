From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/4] Add support of NOIO allocations to IPoIB
Date: Mon, 19 Jun 2017 16:35:14 +0300
Message-ID: <20170619133514.GM17846@mtr-leonro.local>
References: <20170523113816.32657-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oiL9LJXJsdjS5rzq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170523113816.32657-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--oiL9LJXJsdjS5rzq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 23, 2017 at 02:38:12PM +0300, Leon Romanovsky wrote:
> Hi Doug,
>
> These patches adds native support to NOIO allocations during
> create QP for IPoIB.
>
> In contrast to the commit 09b93088d750 ("IB: Add a QP creation flag
> to use GFP_NOIO allocations"), which added specific QP create flag,
> this series uses standard memalloc_noio_* calls to mark GFP_NOIO
> for all allocations paths below.
>
> This change allows to all drivers benefit from this facitlity
> and not only mlx4 and qib. As a nice outcome, there is a lot
> simplification in the mlx4 and qib drivers by removing need to
> carry GFP flags.
>
> Thanks
>
> Cc: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
> Cc: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>a


Hi Doug,

This series  creates simple (context) merge conflict between your's tree
and net-next. The easiest and more convenient wayt to avoid is to base
this series on commit 4931c6ef04b4 ("net/mlx4_en: Optimized single ring ste=
ering")
=66rom Dave's net-next.

Thanks

>
> Changelog from v0:
>  * Forgot to add hfi1
>
> Leon Romanovsky (4):
>   IB/IPoIB: Convert IPoIB to memalloc_noio_* calls
>   IB/{rdmavt, qib, hfi1}: Remove gfp flags argument
>   {net, IB}/mlx4: Remove gfp flags argument
>   IB/core: Remove NOIO QP create flag
>
>  drivers/infiniband/hw/hfi1/qp.c                    |  7 ++--
>  drivers/infiniband/hw/hfi1/qp.h                    |  3 +-
>  drivers/infiniband/hw/mlx4/cq.c                    |  6 +--
>  drivers/infiniband/hw/mlx4/mlx4_ib.h               |  1 -
>  drivers/infiniband/hw/mlx4/qp.c                    | 40 ++++++++--------=
--
>  drivers/infiniband/hw/mlx4/srq.c                   |  8 ++--
>  drivers/infiniband/hw/qib/qib_qp.c                 | 15 ++++---
>  drivers/infiniband/hw/qib/qib_verbs.h              |  4 +-
>  drivers/infiniband/sw/rdmavt/qp.c                  | 48 ++++++----------=
------
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c            | 16 ++++----
>  drivers/net/ethernet/mellanox/mlx4/alloc.c         | 29 +++++++------
>  drivers/net/ethernet/mellanox/mlx4/cq.c            |  4 +-
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c         |  6 +--
>  drivers/net/ethernet/mellanox/mlx4/en_tx.c         |  2 +-
>  drivers/net/ethernet/mellanox/mlx4/icm.c           |  7 ++--
>  drivers/net/ethernet/mellanox/mlx4/icm.h           |  3 +-
>  drivers/net/ethernet/mellanox/mlx4/mlx4.h          |  4 +-
>  drivers/net/ethernet/mellanox/mlx4/mr.c            | 17 ++++----
>  drivers/net/ethernet/mellanox/mlx4/qp.c            | 20 ++++-----
>  .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  4 +-
>  drivers/net/ethernet/mellanox/mlx4/srq.c           |  4 +-
>  include/linux/mlx4/device.h                        | 10 ++---
>  include/rdma/ib_verbs.h                            |  2 +-
>  include/rdma/rdma_vt.h                             |  5 +--
>  24 files changed, 112 insertions(+), 153 deletions(-)
>
> --
> 2.12.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--oiL9LJXJsdjS5rzq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllH0xEACgkQ5GN7iDZy
WKdrbxAAyCp+Q2WVqEXT4vy7feRniFvOHOtjNXmhaYDFpfhMsHqLic8EKzO3cEZV
DLh3Pz5zvhF7FQQkVxdZY2XlelP4uCxCI2OL61s+kDVuhwWuaZDoLmORQEahmoeJ
MO3yAC/LkRddI5PMnUjrh/iWXlaC4pKRE6kMWPgCNWBxRBNpvdqQfGPlFwYgaSCX
qAFP91M0pDsF4WoxsNq/xu/iJ6TRu5TxRnu08dPx2bjR9JNSkhYpZo/Gbu+V2kgA
SxpyE7+wgjVYqC6/x1F+ExFup6X2xpB5s8L51DwmJjN1GzB9AmhDfZsHGMnTFgQR
NZ6A+TmssDK/SJa87vpTkrP4BO+6lINQzUkm0Vn6+ug7W/ckxl+riTDHAqsVDUa3
XgZbTux37LGFYA5+ExLTLUCvdCm1792qxs0Tb5aUYu+poCX9+Yi/dE3rFUapjFst
kv0CkjbZcwqlD+M3Uw9C3cjK27EKvqBJfS/nIhH2Tbs6UCWcDXiMLIt8n4+ap9OK
qziS544AbcKy2e5eGpjLxCjx2dvWq2Pq2jUqkuOOqWot+eDVL1mWRuVBd7omz2tT
mjkCg/P5TXouZY9fwad/Z7Nvi/HQKu8ABxMBdcH5elZBjbxvEIqvtyiK6NFS/VME
rDPHAHabOgW7uuebJD06J0WHoUVv78kGkY9RxhY8JvAERtVOzwM=
=07vJ
-----END PGP SIGNATURE-----

--oiL9LJXJsdjS5rzq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
