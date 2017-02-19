From: Majd Dibbiny <majd@mellanox.com>
Subject: Re: [PATCH 20/29] IB/mlx4: Delete an error message for a failed
 memory allocation in mlx4_ib_add()
Date: Sun, 19 Feb 2017 19:48:40 +0000
Message-ID: <32536396-F7DC-4BE8-A932-7B8C4051BC71@mellanox.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>,<f3ede4d2-d4db-7589-afce-0c487376b099@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f3ede4d2-d4db-7589-afce-0c487376b099@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Wolfram Sang <wsa@the-dreams.de>
List-Id: linux-rdma@vger.kernel.org


> On Feb 18, 2017, at 11:10 PM, SF Markus Elfring <elfring@users.sourceforg=
e.net> wrote:
>=20
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 18 Feb 2017 16:15:20 +0100
>=20
> Omit an extra message for a memory allocation failure in this function.
>=20
> Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-R=
efactor_Strings-WSang_0.pdf
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
> drivers/infiniband/hw/mlx4/main.c | 5 +----
> 1 file changed, 1 insertion(+), 4 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/ml=
x4/main.c
> index 21b88d5ceda4..33b46c463ffa 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -2623,11 +2623,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
>        return NULL;
>=20
>    ibdev =3D (struct mlx4_ib_dev *) ib_alloc_device(sizeof(*ibdev));
> -    if (!ibdev) {
> -        dev_err(&dev->persist->pdev->dev,
> -            "Device struct alloc failed\n");
> +    if (!ibdev)
>        return NULL;
> -    }
Not a big fan of this change.
9 out of the 15 drivers have this print in case of a failure..
>=20
>    iboe =3D &ibdev->iboe;
>=20
> --=20
> 2.11.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
