From: Majd Dibbiny <majd@mellanox.com>
Subject: Re: [PATCH 15/29] IB/mlx4: Delete an unnecessary return statement in
 do_slave_init()
Date: Sun, 19 Feb 2017 17:36:47 +0000
Message-ID: <3AE7A897-1158-44EB-8B64-F5B762BF9505@mellanox.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
 <50e213dd-b3b0-5028-a463-b9fbdf6e25cf@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <50e213dd-b3b0-5028-a463-b9fbdf6e25cf@users.sourceforge.net>
Content-Language: en-US
Content-ID: <7CE8205C6948FC468148BDF325F08129@Mellanox365.onmicrosoft.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 18, 2017, at 11:04 PM, SF Markus Elfring <elfring@users.sourceforg=
e.net> wrote:
>=20
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 18 Feb 2017 15:16:54 +0100
>=20
> The script "checkpatch.pl" pointed information out like the following.
>=20
> WARNING: void function return statements are not generally useful
>=20
> Thus remove such a statement here.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
> drivers/infiniband/hw/mlx4/main.c | 1 -
> 1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/ml=
x4/main.c
> index 89bbb61d62f5..b2b472977a39 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -3131,7 +3131,6 @@ static void do_slave_init(struct mlx4_ib_dev *ibdev=
, int slave, int do_init)
>    }
> out:
>    kfree(dm);
> -    return;
> }
>=20
> static void mlx4_ib_handle_catas_error(struct mlx4_ib_dev *ibdev)
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
