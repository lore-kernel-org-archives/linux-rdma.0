From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/mlx5: Fix binary compatibility with libmlx5
Date: Thu, 30 Jan 2014 13:16:42 +0100
Message-ID: <1391084202.5835.15.camel@localhost.localdomain>
References: <1391082588-29077-1-git-send-email-eli@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391082588-29077-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 30 janvier 2014 =C3=A0 13:49 +0200, Eli Cohen a =C3=A9crit :
> Commit c1be5232d21d "Fix micro UAR allocator" broke binary compatibil=
ity
> between libmlx5 and mlx5_ib since it defines a different value to the=
 number of
> micro UARs per page, leading to wrong calculation in libmlx5. This pa=
tch
> defines struct mlx5_ib_alloc_ucontext_req_v2 as an extension to struc=
t
> mlx5_ib_alloc_ucontext_req.  The extended size is determined in
> mlx5_ib_alloc_ucontext() and in case of old library we use uuarn 0 wh=
ich works
> fine -- this is acheived due to create_user_qp() falling back from hi=
gh to
> medium then to low class where low class will return 0. For new libra=
ries we
> use the more sophisticated allocation algorithm.
>=20
> Fixes: c1be5232d21d ('Fix micro UAR allocator')
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

> ---
> Changes from v1:
> Use 12 digit hash code as required
> Fix mlx5_ib_alloc_ucontext to subtract the size of struct ib_uverbs_c=
md_hdr)
> Improve change log documentation
> Remove whitesapce
>=20

Thanks.

>  drivers/infiniband/hw/mlx5/main.c | 19 +++++++++++++++++--
>  drivers/infiniband/hw/mlx5/qp.c   | 10 ++++++++--
>  drivers/infiniband/hw/mlx5/user.h |  7 +++++++
>  include/linux/mlx5/driver.h       |  1 +
>  4 files changed, 33 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/h=
w/mlx5/main.c
> index 9660d093f8cf..f4ef4a24d410 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -536,24 +536,38 @@ static struct ib_ucontext *mlx5_ib_alloc_uconte=
xt(struct ib_device *ibdev,
>  						  struct ib_udata *udata)
>  {
>  	struct mlx5_ib_dev *dev =3D to_mdev(ibdev);
> -	struct mlx5_ib_alloc_ucontext_req req;
> +	struct mlx5_ib_alloc_ucontext_req_v2 req;
>  	struct mlx5_ib_alloc_ucontext_resp resp;
>  	struct mlx5_ib_ucontext *context;
>  	struct mlx5_uuar_info *uuari;
>  	struct mlx5_uar *uars;
>  	int gross_uuars;
>  	int num_uars;
> +	int ver;
>  	int uuarn;
>  	int err;
>  	int i;
> +	int reqlen;
> =20
>  	if (!dev->ib_active)
>  		return ERR_PTR(-EAGAIN);
> =20
> -	err =3D ib_copy_from_udata(&req, udata, sizeof(req));
> +	memset(&req, 0, sizeof(req));
> +	reqlen =3D udata->inlen - sizeof(struct ib_uverbs_cmd_hdr);
> +	if (reqlen =3D=3D sizeof(struct mlx5_ib_alloc_ucontext_req))
> +		ver =3D 0;
> +	else if (reqlen =3D=3D sizeof(struct mlx5_ib_alloc_ucontext_req_v2)=
)
> +		ver =3D 2;
> +	else
> +		return ERR_PTR(-EINVAL);
> +
> +	err =3D ib_copy_from_udata(&req, udata, reqlen);
>  	if (err)
>  		return ERR_PTR(err);
> =20
> +	if (req.flags || req.reserved)
> +		return ERR_PTR(-EINVAL);
> +
>  	if (req.total_num_uuars > MLX5_MAX_UUARS)
>  		return ERR_PTR(-ENOMEM);
> =20
> @@ -626,6 +640,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext=
(struct ib_device *ibdev,
>  	if (err)
>  		goto out_uars;
> =20
> +	uuari->ver =3D ver;
>  	uuari->num_low_latency_uuars =3D req.num_low_latency_uuars;
>  	uuari->uars =3D uars;
>  	uuari->num_uars =3D num_uars;
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/=
mlx5/qp.c
> index 492dc330e907..091576a777e9 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -430,11 +430,17 @@ static int alloc_uuar(struct mlx5_uuar_info *uu=
ari,
>  		break;
> =20
>  	case MLX5_IB_LATENCY_CLASS_MEDIUM:
> -		uuarn =3D alloc_med_class_uuar(uuari);
> +		if (uuari->ver < 2)
> +			uuarn =3D -ENOMEM;
> +		else
> +			uuarn =3D alloc_med_class_uuar(uuari);
>  		break;
> =20
>  	case MLX5_IB_LATENCY_CLASS_HIGH:
> -		uuarn =3D alloc_high_class_uuar(uuari);
> +		if (uuari->ver < 2)
> +			uuarn =3D -ENOMEM;
> +		else
> +			uuarn =3D alloc_high_class_uuar(uuari);
>  		break;
> =20
>  	case MLX5_IB_LATENCY_CLASS_FAST_PATH:
> diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/h=
w/mlx5/user.h
> index 32a2a5dfc523..0f4f8e42a17f 100644
> --- a/drivers/infiniband/hw/mlx5/user.h
> +++ b/drivers/infiniband/hw/mlx5/user.h
> @@ -62,6 +62,13 @@ struct mlx5_ib_alloc_ucontext_req {
>  	__u32	num_low_latency_uuars;
>  };
> =20
> +struct mlx5_ib_alloc_ucontext_req_v2 {
> +	__u32	total_num_uuars;
> +	__u32	num_low_latency_uuars;
> +	__u32	flags;
> +	__u32	reserved;
> +};
> +
>  struct mlx5_ib_alloc_ucontext_resp {
>  	__u32	qp_tab_size;
>  	__u32	bf_reg_size;
> diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.=
h
> index 554548cd3dd4..32cb18c399c2 100644
> --- a/include/linux/mlx5/driver.h
> +++ b/include/linux/mlx5/driver.h
> @@ -227,6 +227,7 @@ struct mlx5_uuar_info {
>  	 * protect uuar allocation data structs
>  	 */
>  	struct mutex		lock;
> +	u32			ver;
>  };
> =20
>  struct mlx5_bf {

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
