From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] (IB, net)/mlx4: Add resource utilization
 support
Date: Wed, 21 Jun 2017 09:37:07 +0300
Message-ID: <20170621063707.GB1248@mtr-leonro.local>
References: <20170621062936.7894-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170621062936.7894-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moshe Shemesh <moshe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 21, 2017 at 09:29:36AM +0300, Leon Romanovsky wrote:
> From: Moshe Shemesh <moshe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Adding visibility of resource usage of QPs, CQs and counters used by
> virtual functions. This feature will be used to give the PF administrator
> more data while debugging VF status. Usage info was added to ALLOC_RES
> command, to notify the PF if the resource which is being reserved or
> allocated for the VF will be used by kernel driver or by user verbs.
>
> Updated reservation and allocation functions of QP, CQ and counter with
> additional usage parameter.
>
> Signed-off-by: Moshe Shemesh <moshe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/cq.c                |  2 ++
>  drivers/infiniband/hw/mlx4/main.c              |  6 ++++--
>  drivers/infiniband/hw/mlx4/qp.c                | 13 +++++++++----
>  drivers/net/ethernet/mellanox/mlx4/cq.c        |  7 ++++---
>  drivers/net/ethernet/mellanox/mlx4/en_cq.c     |  1 +
>  drivers/net/ethernet/mellanox/mlx4/en_netdev.c |  3 ++-
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c     |  6 ++++--
>  drivers/net/ethernet/mellanox/mlx4/en_tx.c     |  3 ++-
>  drivers/net/ethernet/mellanox/mlx4/main.c      |  7 ++++---
>  drivers/net/ethernet/mellanox/mlx4/qp.c        |  5 +++--
>  include/linux/mlx4/device.h                    | 12 ++++++++++--
>  11 files changed, 45 insertions(+), 20 deletions(-)

Hi Doug,

This patch is based on commit 4931c6ef04b4 ("net/mlx4_en: Optimized single =
ring steering")
=66rom Dave's net-next

Thanks

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllKFBMACgkQ5GN7iDZy
WKfg3w/+ILxIkdGq8mbBjUJMuABmOwhKSWk3QG/6maa/MQ4gler353yVdsNVL8cY
oD6SAlJJnEG+dLmwXagwXdjq728d2ZNA3oLIFq9rZcz+uqM+Ba+o86E4et/8ZV0V
9H38Uhe6J/Betu1O1mBkXE+PxqAEkB+vyjZ7s1bv/Z/D9lMeTmSmGNJpSnEhjQKo
/H43W7mF3hWWYg/2Hriq5dS5/+tsfmDqFBFEfbSsT7sGM8FFQKKHQC0/G4NMx9Ar
EnOfFEjGy8JCmdjQTu3OZgakDkiW58Yiz9YEpY3aD/itsFxry8FusgunR+hycr9Y
vu8Q696r8ymdw0int0fQsTldgJAHcc6HDZt2SjTupiV7WRSH3Yl+Bu1ERh3gc1fo
Q7ErCup7eOUuJw76+OTtmvLIPEMWcTw142I1TgMNSeQCpXsUucmlfWins1WvEb41
IcXn/ctYKn9htEdDQaUvQ5TqyyF2GT9VesFZLKT4TBlK6xi4JMZxm/E5pO7Vv1j0
m6csYFRfmqkdvkWSxcOvtmtviE10tGU0pwcNSgdtvgzYsEWvfExvKNgO6GxGZ4r2
3UpAyosrBLfPMv/PdsQ61Nr9WEM0WTvnI4zLSGnDZ1lIVOo1H5bvriZ269/3AVvs
UDghhM+sgnlqhcvB1zEt86W3xIEthEemVLR/VMq8zPianpS93hQ=
=YLLT
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
