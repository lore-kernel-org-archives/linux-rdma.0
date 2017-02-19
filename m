From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 07/29] IB/mlx4: Split a condition check in
 handle_slaves_guid_change()
Date: Sun, 19 Feb 2017 17:09:03 +0000
Message-ID: <F29B73FA-2686-4244-8A93-84DFEEB7FDA2@mellanox.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>,<951c0746-b88e-8ee7-78e8-5be2a53a2e43@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <951c0746-b88e-8ee7-78e8-5be2a53a2e43-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 18, 2017, at 10:55 PM, SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5ug@public.gmane.org=
e.net> wrote:
>=20
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Fri, 17 Feb 2017 21:41:25 +0100
>=20
> The kfree() function was called in up to two cases by the
> handle_slaves_guid_change() function during error handling even if
> the passed variable contained a null pointer.
>=20
> * Split a condition check for memory allocation failures.
>=20
> * Adjust jump targets according to the Linux coding style convention.
>=20
> * Delete an initialisation for these variables at the beginning
>  which became unnecessary with this refactoring.
>=20
> Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> ---
> drivers/infiniband/hw/mlx4/mad.c | 14 +++++++++-----
> 1 file changed, 9 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx=
4/mad.c
> index cf33efce69d2..75b6522b3a8f 100644
> --- a/drivers/infiniband/hw/mlx4/mad.c
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -1128,17 +1128,20 @@ static void propagate_pkey_ev(struct mlx4_ib_dev =
*dev, int port_num,
> static void handle_slaves_guid_change(struct mlx4_ib_dev *dev, u8 port_nu=
m,
>                      u32 guid_tbl_blk_num, u32 change_bitmap)
> {
> -    struct ib_smp *in_mad  =3D NULL;
> -    struct ib_smp *out_mad  =3D NULL;
> +    struct ib_smp *in_mad;
> +    struct ib_smp *out_mad;
>    u16 i;
>=20
>    if (!mlx4_is_mfunc(dev->dev) || !mlx4_is_master(dev->dev))
>        return;
>=20
>    in_mad  =3D kmalloc(sizeof *in_mad, GFP_KERNEL);
> +    if (!in_mad)
> +        return;
> +
>    out_mad =3D kmalloc(sizeof *out_mad, GFP_KERNEL);
> -    if (!in_mad || !out_mad)
> -        goto out;
> +    if (!out_mad)
> +        goto free_in_mad;
>=20
>    guid_tbl_blk_num  *=3D 4;
>=20
> @@ -1171,8 +1174,9 @@ static void handle_slaves_guid_change(struct mlx4_i=
b_dev *dev, u8 port_num,
>    }
>=20
> out:
> -    kfree(in_mad);
>    kfree(out_mad);
> +free_in_mad:
> +    kfree(in_mad);
> }
>=20
> void handle_port_mgmt_change_event(struct work_struct *work)
> --=20
> 2.11.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thanks,
Reviewed-by: Majd Dibbiny
<majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
