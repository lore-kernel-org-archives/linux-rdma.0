From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mlx5: Expose correct page_size_cap in device attributes
Date: Thu, 23 Jul 2015 17:41:38 -0400
Message-ID: <55B15F92.6070604@redhat.com>
References: <1437478812-9650-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VRl5pTdBHh1XSavDlEhd3cIM7vC9HbMWO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437478812-9650-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VRl5pTdBHh1XSavDlEhd3cIM7vC9HbMWO
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/21/2015 07:40 AM, Sagi Grimberg wrote:
> Should be all the page sizes that are supported by the
> device.
>=20
> Reported-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/=
mlx5/main.c
> index 725f857..a90ef7a 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -212,6 +212,7 @@ static int mlx5_ib_query_device(struct ib_device *i=
bdev,
>  	int err =3D -ENOMEM;
>  	int max_rq_sg;
>  	int max_sq_sg;
> +	u64 min_page_size =3D 1ull << MLX5_CAP_GEN(mdev, log_pg_sz);
> =20
>  	if (uhw->inlen || uhw->outlen)
>  		return -EINVAL;
> @@ -264,7 +265,7 @@ static int mlx5_ib_query_device(struct ib_device *i=
bdev,
>  	props->hw_ver		   =3D mdev->pdev->revision;
> =20
>  	props->max_mr_size	   =3D ~0ull;
> -	props->page_size_cap	   =3D 1ull << MLX5_CAP_GEN(mdev, log_pg_sz);
> +	props->page_size_cap	   =3D ~(min_page_size - 1);
>  	props->max_qp		   =3D 1 << MLX5_CAP_GEN(mdev, log_max_qp);
>  	props->max_qp_wr	   =3D 1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
>  	max_rq_sg =3D  MLX5_CAP_GEN(mdev, max_wqe_sz_rq) /
>=20

I assume this prevents the driver from working at all on certain arches
(like ppc with 64k page size)?  It looks obviously correct enough that
I've picked it up for 4.2-rc.  Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--VRl5pTdBHh1XSavDlEhd3cIM7vC9HbMWO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVsV+SAAoJELgmozMOVy/dUhkQAIjow55IVHUUiMvrmE3czXAX
bZjucVRZjhm7tHIwkNqGZiCctMNXHO53LLxSewHVYP0RSQM+xwuA25bftynszg0e
mF6BmINuwEhzaReJ8ZQD0XRT46zb7QYuOKQimjNOx8pXrWHoENXJKA5Up6LXoCOI
Y3ESGi0qEZKPoGAVurLeajhXH1Wbj4cGVO8PAwhqi9eY0g08KDqosnjIbvkF/BkX
l+iyniTAE5QlVsetZl+IQ/0JVO+C+XT5PMp7OgFoDuz6HlvuXp35vT14Dv1Pbr30
P24Cr5pWs4C/k2q6Ji5CFJZxCPnZnJDRJX7lF1X4MbVK5U8zmex/W/C7J8g5BFbM
e+uNonLg111hkxqYeuvBQWsq0xx+lEXaPlxFUFN8Wt0gPLkGQF2qOCJcXye3ZrQV
lpS8u89igju9KnM1W2Dg2SsBQrg8D5vTgfWeymUHQ4o3JOOdllPYwAKWPfTDCSWO
ncUz6U9R+mkesDT/j+uCSEJ+1vikjP/CXVaSdmsqaG0By0ZtQYbVt5r91kj0jZsM
m/sB3AWomm6uF4y5q72TU1PFOw50jl/nUPnLX08Swy2cw1mMXaMdGfd6MSoLLyaG
wgr55yHVNZCpJjY27A8JnEFf84RwMdtY+gRfNZSq9wBWlwcs/KI+4tPiPk8AGq/1
bn3ozj3wxUYnNIq9pfbC
=NvV9
-----END PGP SIGNATURE-----

--VRl5pTdBHh1XSavDlEhd3cIM7vC9HbMWO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
