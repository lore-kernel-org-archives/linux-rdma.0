From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] mlx5: Fix incorrect wc pkey_index assignment for GSI
 messages
Date: Thu, 3 Sep 2015 15:18:57 -0400
Message-ID: <55E89D21.8060303@redhat.com>
References: <1441221784-21734-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vtp5XtUdklrhS5FfLwVE9pwqCaHELOG7o"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441221784-21734-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vtp5XtUdklrhS5FfLwVE9pwqCaHELOG7o
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/02/2015 03:23 PM, Sagi Grimberg wrote:
> Since patch series "Demux IB CM requests in the rdma_cm module" the
> P_Key index is taken from the work completion rather than the message
> itself.
>=20
> The HCA provides us with the message P_Key. In order to provide the
> P_Key index, we need to look it up. Given that this is relevant only
> for GSI messages (session establishments) which is less performance cri=
tical,
> micro-optimize against the GSI (is_qp1) branch.
>=20
> Fixes: 4c21b5bcef73 ("IB/cma: Add net_dev and private data checks to
> RDMA CM")
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied!

> ---
> Changes from v0:
> - Added Fixes tag
>=20
>  drivers/infiniband/hw/mlx5/cq.c      |   10 +++++++++-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |    5 +++++
>  drivers/infiniband/hw/mlx5/qp.c      |    5 -----
>  3 files changed, 14 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/ml=
x5/cq.c
> index 640c54e..3dfd287 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -33,6 +33,7 @@
>  #include <linux/kref.h>
>  #include <rdma/ib_umem.h>
>  #include <rdma/ib_user_verbs.h>
> +#include <rdma/ib_cache.h>
>  #include "mlx5_ib.h"
>  #include "user.h"
> =20
> @@ -227,7 +228,14 @@ static void handle_responder(struct ib_wc *wc, str=
uct mlx5_cqe64 *cqe,
>  	wc->dlid_path_bits =3D cqe->ml_path;
>  	g =3D (be32_to_cpu(cqe->flags_rqpn) >> 28) & 3;
>  	wc->wc_flags |=3D g ? IB_WC_GRH : 0;
> -	wc->pkey_index     =3D be32_to_cpu(cqe->imm_inval_pkey) & 0xffff;
> +	if (unlikely(is_qp1(qp->ibqp.qp_type))) {
> +		u16 pkey =3D be32_to_cpu(cqe->imm_inval_pkey) & 0xffff;
> +
> +		ib_find_cached_pkey(&dev->ib_dev, qp->port, pkey,
> +				    &wc->pkey_index);
> +	} else {
> +		wc->pkey_index =3D 0;
> +	}
>  }
> =20
>  static void dump_cqe(struct mlx5_ib_dev *dev, struct mlx5_err_cqe *cqe=
)
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/=
hw/mlx5/mlx5_ib.h
> index fc987fe..a4ef6a7 100644
> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -656,6 +656,11 @@ static inline u8 convert_access(int acc)
>  	       MLX5_PERM_LOCAL_READ;
>  }
> =20
> +static inline int is_qp1(enum ib_qp_type qp_type)
> +{
> +	return qp_type =3D=3D IB_QPT_GSI;
> +}
> +
>  #define MLX5_MAX_UMR_SHIFT 16
>  #define MLX5_MAX_UMR_PAGES (1 << MLX5_MAX_UMR_SHIFT)
> =20
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/ml=
x5/qp.c
> index 9380d2d..8c51ea3 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -76,11 +76,6 @@ static int is_qp0(enum ib_qp_type qp_type)
>  	return qp_type =3D=3D IB_QPT_SMI;
>  }
> =20
> -static int is_qp1(enum ib_qp_type qp_type)
> -{
> -	return qp_type =3D=3D IB_QPT_GSI;
> -}
> -
>  static int is_sqp(enum ib_qp_type qp_type)
>  {
>  	return is_qp0(qp_type) || is_qp1(qp_type);
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--vtp5XtUdklrhS5FfLwVE9pwqCaHELOG7o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6J0hAAoJELgmozMOVy/dSGIP/jRJyXuD90GkzGPCsHsKzQwW
8opuAAj4IkopnG79+nxgyh+SgPVOe6w03UyFXAEUZKg2GvVq/McK4o3U8slv3o4T
SL59VxYOC7pSY3xSx38voTNgQncoeaR1Z1clkOl4UPf64bKaPiDKFCic9SCK4jcM
nQUJ5BUpi08AqpKwa0lnLNZYFZnDNYcpz4GHJ/OC5B47cRS0eQG6iT2S7WsonIWG
p5X7/ut5jXGc1WVE9WbM2Y4DPTkl9aVeinOO0FWgR1rzS+6GHAtl282NUpZrmGkJ
pSjnYTnMipoeMdwZe9woswnXdcMz+HjWwZXa62CkeBu11Emf0hLP5d/byhNRRnHn
1tXNWeT9wk7YHTAnUL0QYexla/YvO94yNvhdSJJ7uempboPkUHUks6PFcJ/ULsOS
qI70Okb7MuNNVyzRkQz4/C/D0qY3+0l562ffTLhDxAYa+9bBuJ/BKjX6ejpO0xya
Qlst6Phpej/ThlTEjBpFlps/U6kclDoWx2J8jG6mpwB0IHWAtUp77hNKgFNFnm4b
YxjGpRYbtbE3PLncTe3b59MxgjzW1S7M5q/yeWm9WIQ3HEDkidRF7d5GfLbuO7uP
QhbF9ZP4XJJJejgQuI0JeObWFTz087lgk6z58gWwMOeLhNXdWtQ43xp8pBiH9IAt
TJEwY+0/7fsc/vkW/eMB
=OJW4
-----END PGP SIGNATURE-----

--vtp5XtUdklrhS5FfLwVE9pwqCaHELOG7o--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
