From: Majd Dibbiny <majd@mellanox.com>
Subject: Re: [PATCH 05/29] IB/mlx4: Fix a typo in a comment line
Date: Sun, 19 Feb 2017 17:06:21 +0000
Message-ID: <6C24ABDC-BDDC-4F07-95EC-FAA831706C11@mellanox.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>,<b2be5d37-e334-5b97-7088-ee4a4c824824@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b2be5d37-e334-5b97-7088-ee4a4c824824@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 18, 2017, at 10:53 PM, SF Markus Elfring <elfring@users.sourceforg=
e.net> wrote:
>=20
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 17 Feb 2017 20:48:59 +0100
>=20
> Add a missing character in this description and adjust
> the comment formatting.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
> drivers/infiniband/hw/mlx4/mad.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx=
4/mad.c
> index ea4892b0f39e..d8c27e3ed69a 100644
> --- a/drivers/infiniband/hw/mlx4/mad.c
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -1559,8 +1559,10 @@ static void mlx4_ib_multiplex_mad(struct mlx4_ib_d=
emux_pv_ctx *ctx, struct ib_wc
>        }
>    }
>=20
> -    /* We are using standard ib_core services to send the mad, so genera=
te a
> -     * stadard address handle by decoding the tunnelled mlx4_ah fields *=
/
> +    /*
> +     * We are using standard ib_core services to send the mad, so genera=
te
> +     * a standard address handle by decoding the tunnelled mlx4_ah field=
s.
> +     */
>    memcpy(&ah.av, &tunnel->hdr.av, sizeof (struct mlx4_av));
>    ah.ibah.device =3D ctx->ib_dev;
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
