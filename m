From: Majd Dibbiny <majd@mellanox.com>
Subject: Re: [PATCH 06/29] IB/mlx4: Delete three unnecessary return statements
Date: Sun, 19 Feb 2017 17:06:22 +0000
Message-ID: <85584EE0-57D5-4229-8FD1-0DBF6E296F7D@mellanox.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>,<7edfe4d6-156d-23c9-acef-a6606680a5eb@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7edfe4d6-156d-23c9-acef-a6606680a5eb@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 18, 2017, at 10:54 PM, SF Markus Elfring <elfring@users.sourceforg=
e.net> wrote:
>=20
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 17 Feb 2017 21:34:27 +0100
>=20
> The script "checkpatch.pl" pointed information out like the following.
>=20
> WARNING: void function return statements are not generally useful
>=20
> Thus remove such a statement in the affected functions.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
> drivers/infiniband/hw/mlx4/mad.c | 3 ---
> 1 file changed, 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx=
4/mad.c
> index d8c27e3ed69a..cf33efce69d2 100644
> --- a/drivers/infiniband/hw/mlx4/mad.c
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -1173,7 +1173,6 @@ static void handle_slaves_guid_change(struct mlx4_i=
b_dev *dev, u8 port_num,
> out:
>    kfree(in_mad);
>    kfree(out_mad);
> -    return;
> }
>=20
> void handle_port_mgmt_change_event(struct work_struct *work)
> @@ -2140,7 +2139,6 @@ void mlx4_ib_tunnels_update_work(struct work_struct=
 *work)
>    mlx4_ib_tunnels_update(dmxw->dev, dmxw->slave, (int) dmxw->port,
>                   dmxw->do_init);
>    kfree(dmxw);
> -    return;
> }
>=20
> static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
> @@ -2268,7 +2266,6 @@ static void mlx4_ib_master_tunnels(struct mlx4_ib_d=
ev *dev, int do_init)
>    /* initialize or tear down tunnel QPs for the master */
>    for (i =3D 0; i < dev->dev->caps.num_ports; i++)
>        mlx4_ib_tunnels_update(dev, mlx4_master_func_num(dev->dev), i + 1,=
 do_init);
> -    return;
> }
>=20
> int mlx4_ib_init_sriov(struct mlx4_ib_dev *dev)
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
