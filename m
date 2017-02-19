From: Majd Dibbiny <majd@mellanox.com>
Subject: Re: [PATCH 04/29] IB/mlx4: Improve another size determination in
 alloc_pv_object()
Date: Sun, 19 Feb 2017 17:06:20 +0000
Message-ID: <FCDE55C9-9E64-440D-9D94-68CDCA707167@mellanox.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>,<398511b4-2e62-ee7e-69b7-f9a83922332b@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <398511b4-2e62-ee7e-69b7-f9a83922332b@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 18, 2017, at 10:52 PM, SF Markus Elfring <elfring@users.sourceforg=
e.net> wrote:
>=20
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 17 Feb 2017 20:20:43 +0100
>=20
> Replace the specification of a data structure by a pointer dereference
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
> index 284634d36b1c..ea4892b0f39e 100644
> --- a/drivers/infiniband/hw/mlx4/mad.c
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -1948,7 +1948,7 @@ static int alloc_pv_object(struct mlx4_ib_dev *dev,=
 int slave, int port,
>    struct mlx4_ib_demux_pv_ctx *ctx;
>=20
>    *ret_ctx =3D NULL;
> -    ctx =3D kzalloc(sizeof (struct mlx4_ib_demux_pv_ctx), GFP_KERNEL);
> +    ctx =3D kzalloc(sizeof(*ctx), GFP_KERNEL);
>    if (!ctx)
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
