From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Fix binary compatibility with libmlx5
Date: Wed, 29 Jan 2014 21:48:43 +0100
Message-ID: <1391028523.23180.63.camel@localhost.localdomain>
References: <1391005649-17932-1-git-send-email-eli@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391005649-17932-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mercredi 29 janvier 2014 =C3=A0 16:27 +0200, Eli Cohen a =C3=A9crit =
:
> Commit c1be523 "Fix micro UAR allocator" broke binary compatibility b=
etween
        ^^^^^^^

12 digits identifier are the norm for kernel. Please update your git
configuration:

 git config --global core.abbrev 12

See http://lwn.net/Articles/571980/
    http://blog.cuviper.com/2013/11/10/how-short-can-git-abbreviate/

> libmlx5 and mlx5_ib since it defines a different value to the number =
of micro
> UARs per page, leading to wrong calculation in libmlx5. This patch de=
fines
> struct mlx5_ib_alloc_ucontext_req_v2 as an extension to struct
> mlx5_ib_alloc_ucontext_req.  The extended size is determined in
> mlx5_ib_alloc_ucontext() and in case of old library we use uuarn 0 wh=
ich works
> fine. For new libraries we use the more sophisticated allocation algo=
rithm.
>=20
> Fixes: c1be523 ('Fix micro UAR allocator')
        ^^^^^^^
Likewise

> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>=20
> Hi Roland,=20
>=20
> This fixes a regression introduced during the 3.14 merge window, and =
must
> be applied for 3.14, thanks
>=20
> Eli
>=20
>  drivers/infiniband/hw/mlx5/main.c | 19 +++++++++++++++++--
>  drivers/infiniband/hw/mlx5/qp.c   | 11 +++++++++--
>  drivers/infiniband/hw/mlx5/user.h |  7 +++++++
>  include/linux/mlx5/driver.h       |  1 +
>  4 files changed, 34 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/h=
w/mlx5/main.c
> index 9660d09..e24d912 100644
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
> +	reqlen =3D udata->inlen - sizeof(struct ib_uverbs_get_context);

I'm not sure how this could work without subtracting sizeof(struct
ib_uverbs_cmd_hdr).

As I explained in "Re: [PATCHv4 for-3.13 00/10] create_flow/destroy_flo=
w
fixes for v3.13" [1] ib_uverbs_write() does not decrement input length:
it gives hdr.in_words * 4 to the uverbs function, here=20
ib_uverbs_get_context(). Then, the function built struct ib_udata=20
without taking care of the extra bytes count in in_len:

    struct ib_uverbs_get_context cmd;
    ...
    INIT_UDATA(&udata, buf + sizeof cmd,
               (unsigned long) cmd.response + sizeof resp,
               in_len - sizeof cmd, out_len - sizeof resp);

Driver mthca does some handling which look like to what's proposed in
your patch, but takes care of subtracting the header size from the inpu=
t
length, see mthca_reg_user_mr()[2].

[1]
<http://marc.info/?i=3D1387493822.11925.217.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org=
>

[2]
<http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/dr=
ivers/infiniband/hw/mthca/mthca_provider.c?id=3D0e47c969c65e213421450c3=
1043353ebe3c67e0c#n988>

> +	if (reqlen =3D=3D sizeof(struct mlx5_ib_alloc_ucontext_req))
> +		ver =3D 0;
> +	else if (reqlen =3D=3D sizeof(struct mlx5_ib_alloc_ucontext_req_v2)=
)
> +		ver =3D 2;
> +	else
> +		return ERR_PTR(-EINVAL);
> +

Doing so introduce a subtle regression: there was no check on the lengt=
h
before, so it was legal to pass a input buffer far larger than needed,
aka. trailing garbage.=20

With such new test in place, it's no more allowed, and this is a
regression. It's not a big issue, but a little departure from current
behavor.

BTW, this is the correct way to handle the request, every other uverbs
functions should behave like this, eg. being strict on its accepted
input.

> +	err =3D ib_copy_from_udata(&req, udata, reqlen);
>  	if (err)
>  		return ERR_PTR(err);
> =20
> +	if (req.flags || req.reserved)
> +		return ERR_PTR(-EINVAL);
> +

Just like this :)

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
> index 492dc33..300475c 100644
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

In the commit message, you specified that uuarn is set to 0 when v1 is
used. But here it's set to -ENOMEM.

> +		else
> +			uuarn =3D alloc_med_class_uuar(uuari);
>  		break;
> =20
>  	case MLX5_IB_LATENCY_CLASS_HIGH:
> -		uuarn =3D alloc_high_class_uuar(uuari);
> +		if (uuari->ver < 2)
> +			uuarn =3D -ENOMEM;

Likewise.

> +		else
> +			uuarn =3D alloc_high_class_uuar(uuari);
>  		break;
> =20
>  	case MLX5_IB_LATENCY_CLASS_FAST_PATH:
> @@ -559,6 +565,7 @@ static int create_user_qp(struct mlx5_ib_dev *dev=
, struct ib_pd *pd,
>  		}
>  	}
> =20
> +

Remove this white space.

>  	uar_index =3D uuarn_to_uar_index(&context->uuari, uuarn);
>  	mlx5_ib_dbg(dev, "uuarn 0x%x, uar_index 0x%x\n", uuarn, uar_index);
> =20
> diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/h=
w/mlx5/user.h
> index 32a2a5d..0f4f8e4 100644
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
> index 554548c..32cb18c 100644
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

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
