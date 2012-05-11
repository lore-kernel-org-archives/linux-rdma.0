From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: [PATCH for-next 3/6] IB/mlx4: Fix parameter checking in
 create_cq
Date: Fri, 11 May 2012 09:10:08 +0200
Message-ID: <20120511091008.40d1dc3d@b012350-ux>
References: <1336681689-16668-1-git-send-email-ogerlitz@mellanox.com>
	<1336681689-16668-4-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336681689-16668-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hi,

On Thu, 10 May 2012 23:28:06 +0300
Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Round up the number of entries before checking against the device's
> capabilities and not after that.
>=20
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/cq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/=
mlx4/cq.c
> index f69ccd2..222a06c 100644
> --- a/drivers/infiniband/hw/mlx4/cq.c
> +++ b/drivers/infiniband/hw/mlx4/cq.c
> @@ -172,6 +172,7 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device =
*ibdev, int entries, int vector
>  	struct mlx4_uar *uar;
>  	int err;
> =20
> +	entries      =3D roundup_pow_of_two(entries + 1);
>  	if (entries < 1 || entries > dev->dev->caps.max_cqes)

  Is the first check still needed here then?


  S=C3=A9bastien.


>  		return ERR_PTR(-EINVAL);
> =20
> @@ -179,7 +180,6 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device =
*ibdev, int entries, int vector
>  	if (!cq)
>  		return ERR_PTR(-ENOMEM);
> =20
> -	entries      =3D roundup_pow_of_two(entries + 1);
>  	cq->ibcq.cqe =3D entries - 1;
>  	mutex_init(&cq->resize_mutex);
>  	spin_lock_init(&cq->lock);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
