From: Majd Dibbiny <majd@mellanox.com>
Subject: Re: [PATCH 03/29] IB/mlx4: Improve another size determination in
 mlx4_ib_alloc_demux_ctx()
Date: Sun, 19 Feb 2017 17:06:20 +0000
Message-ID: <99B0B31E-996E-45B9-8DBA-FE4390E5F36C@mellanox.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>,<73833337-ea01-edcb-d9a7-85ac8a03c0c7@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <73833337-ea01-edcb-d9a7-85ac8a03c0c7@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 18, 2017, at 10:50 PM, SF Markus Elfring <elfring@users.sourceforg=
e.net> wrote:
>=20
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 17 Feb 2017 20:15:02 +0100
>=20
> Replace the specification of a data type by a pointer dereference
> as the parameter for the operator "sizeof" to make the corresponding size
> determination a bit safer according to the Linux coding style convention.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
> drivers/infiniband/hw/mlx4/mad.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx=
4/mad.c
> index 858da8746d49..284634d36b1c 100644
> --- a/drivers/infiniband/hw/mlx4/mad.c
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -2150,7 +2150,7 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_d=
ev *dev,
>    int i;
>=20
>    ctx->tun =3D kcalloc(dev->dev->caps.sqp_demux,
> -               sizeof (struct mlx4_ib_demux_pv_ctx *), GFP_KERNEL);
> +               sizeof(*ctx->tun), GFP_KERNEL);
>    if (!ctx->tun)
>        return -ENOMEM;
>=20
> --=20
> 2.11.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thanks,
Reviewed-by: Majd Dibbiny
<majd@mellanox.com>=
