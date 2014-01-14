From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 07/14] IB/mlx5: Make sure doorbell record is
 visible before doorbell
Date: Tue, 14 Jan 2014 17:36:33 +0100
Message-ID: <1389717393.1585.66.camel@localhost.localdomain>
References: <1389714323-20130-1-git-send-email-eli@mellanox.com>
	 <1389714323-20130-8-git-send-email-eli@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389714323-20130-8-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le mardi 14 janvier 2014 =C3=A0 17:45 +0200, Eli Cohen a =C3=A9crit :
> Put a wmb() to make sure the doorbell record is visible to the HCA be=
fore we
> hit doorbell.
>=20
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/qp.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/=
mlx5/qp.c
> index a056c24..87b7fb1 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -2251,6 +2251,10 @@ out:
> =20
>  		qp->db.db[MLX5_SND_DBR] =3D cpu_to_be32(qp->sq.cur_post);
> =20
> +		/* Make sure doorbell record is visible to the HCA before
> +		 * we hit doorbell */
> +		wmb();
> +

In linux-next, as of next-20140114, I'm seeing the write memory barrier
before "qp->db.db[MLX5_SND_DBR] =3D cpu_to_be32(qp->sq.cur_post);"
It was introduced by commit e126ba97dba9e:

out:
        if (likely(nreq)) {
                qp->sq.head +=3D nreq;

                /* Make sure that descriptors are written before
                 * updating doorbell record and ringing the doorbell
                 */
                wmb();

                qp->db.db[MLX5_SND_DBR] =3D cpu_to_be32(qp->sq.cur_post=
);

                if (bf->need_lock)
                        spin_lock(&bf->lock);

So this add a second wmb().
Is it really necessary ?

>  		if (bf->need_lock)
>  			spin_lock(&bf->lock);
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
