From: Majd Dibbiny <majd@mellanox.com>
Subject: Re: [PATCH 09/29] IB/mlx4: Move an assignment out of a check in
 forward_trap()
Date: Sun, 19 Feb 2017 17:12:00 +0000
Message-ID: <08075D57-03AA-4768-8843-B4D745E1F567@mellanox.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>,<ac39ba0d-8738-2532-9eec-a82c76fc9ff4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ac39ba0d-8738-2532-9eec-a82c76fc9ff4@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 18, 2017, at 10:58 PM, SF Markus Elfring <elfring@users.sourceforg=
e.net> wrote:
>=20
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 17 Feb 2017 22:22:53 +0100
>=20
> The script "checkpatch.pl" pointed information out like the following.
>=20
> ERROR: do not use assignment in if condition
>=20
> Thus fix the affected source code place.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
> drivers/infiniband/hw/mlx4/mad.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx=
4/mad.c
> index 9518b7244269..860fec8b9601 100644
> --- a/drivers/infiniband/hw/mlx4/mad.c
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -401,7 +401,8 @@ static void forward_trap(struct mlx4_ib_dev *dev, u8 =
port_num, const struct ib_m
>         */
>        spin_lock_irqsave(&dev->sm_lock, flags);
>        memcpy(send_buf->mad, mad, sizeof *mad);
> -        if ((send_buf->ah =3D dev->sm_ah[port_num - 1]))
> +        send_buf->ah =3D dev->sm_ah[port_num - 1];
> +        if (send_buf->ah)
>            ret =3D ib_post_send_mad(send_buf, NULL);
>        else
>            ret =3D -EINVAL;
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
