From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 14/14] IB/mlx5: Remove old field for create
 mkey mailbox
Date: Tue, 14 Jan 2014 17:37:17 +0100
Message-ID: <1389717437.1585.68.camel@localhost.localdomain>
References: <1389714323-20130-1-git-send-email-eli@mellanox.com>
	 <1389714323-20130-15-git-send-email-eli@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389714323-20130-15-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le mardi 14 janvier 2014 =C3=A0 17:45 +0200, Eli Cohen a =C3=A9crit :
> Align to firmware specification.
>=20

Is it subject to change between various firmware revision ?

If yes, it could of user interest to specify the base/current
version of the applicable firmware.

> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/linux/mlx5/device.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.=
h
> index 1d05909..817a6fa 100644
> --- a/include/linux/mlx5/device.h
> +++ b/include/linux/mlx5/device.h
> @@ -849,8 +849,8 @@ struct mlx5_create_mkey_mbox_in {
>  	struct mlx5_mkey_seg	seg;
>  	u8			rsvd1[16];
>  	__be32			xlat_oct_act_size;
> -	__be32			bsf_coto_act_size;
> -	u8			rsvd2[168];
> +	__be32			rsvd2;

=46or a reserved field, I think we don't care of it being be or le.

> +	u8			rsvd3[168];
>  	__be64			pas[0];
>  };
> =20

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
