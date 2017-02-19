From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 22/29] IB/mlx4: Use kmalloc_array() in alloc_proxy_bufs()
Date: Sun, 19 Feb 2017 19:53:18 +0000
Message-ID: <63C7B48F-BC28-4ADF-BF97-6E22B2F1D80D@mellanox.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>,<b7f36e89-a3c8-0842-d496-0dbb64fdd73f@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b7f36e89-a3c8-0842-d496-0dbb64fdd73f-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 18, 2017, at 11:12 PM, SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5ug@public.gmane.org=
e.net> wrote:
>=20
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Sat, 18 Feb 2017 16:56:52 +0100
>=20
> * A multiplication for the size determination of a memory allocation
>  indicated that an array data structure should be processed.
>  Thus use the corresponding function "kmalloc_array".
>=20
>  This issue was detected by using the Coccinelle software.
>=20
> * Replace the specification of a data structure by a pointer dereference
>  to make the corresponding size determination a bit safer according to
>  the Linux coding style convention.
>=20
> Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> ---
> drivers/infiniband/hw/mlx4/qp.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4=
/qp.c
> index 7d76f769233c..11fec4a8fae5 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -554,9 +554,9 @@ static int alloc_proxy_bufs(struct ib_device *dev, st=
ruct mlx4_ib_qp *qp)
> {
>    int i;
>=20
> -    qp->sqp_proxy_rcv =3D
> -        kmalloc(sizeof (struct mlx4_ib_buf) * qp->rq.wqe_cnt,
> -            GFP_KERNEL);
> +    qp->sqp_proxy_rcv =3D kmalloc_array(qp->rq.wqe_cnt,
> +                      sizeof(*qp->sqp_proxy_rcv),
> +                      GFP_KERNEL);
>    if (!qp->sqp_proxy_rcv)
>        return -ENOMEM;
>    for (i =3D 0; i < qp->rq.wqe_cnt; i++) {
> --=20
> 2.11.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thanks,
Reviewed-by: Majd Dibbiny
<majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
