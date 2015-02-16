From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/mlx5: Enable the ODP capability query verb
Date: Mon, 16 Feb 2015 22:09:14 +0100
Message-ID: <1424120954.32606.25.camel@opteya.com>
References: <1423394932-2965-1-git-send-email-haggaie@mellanox.com>
	 <1423394932-2965-4-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423394932-2965-4-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le dimanche 08 f=C3=A9vrier 2015 =C3=A0 13:28 +0200, Haggai Eran a =C3=A9=
crit :
> Re-enable the on-demand paging capability query through the
> extended query device verb.
>=20

I would find useful to have a link to the initial commit in this one,
so that the thing makes more sense:

commit 8cdd312cfed7 ("IB/mlx5: Implement the ODP capability query
verb").

> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/main.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/h=
w/mlx5/main.c
> index 03bf81211a54..8a87404e9c76 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -1331,6 +1331,8 @@ static void *mlx5_ib_add(struct mlx5_core_dev *=
mdev)
>  		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)		|
>  		(1ull << IB_USER_VERBS_CMD_CREATE_XSRQ)		|
>  		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
> +	dev->ib_dev.uverbs_ex_cmd_mask =3D
> +		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE);
> =20
>  	dev->ib_dev.query_device	=3D mlx5_ib_query_device;
>  	dev->ib_dev.query_port		=3D mlx5_ib_query_port;

Reviewed-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
