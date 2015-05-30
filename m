From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] rds: re-entry of rds_ib_xmit/rds_iw_xmit
Date: Sat, 30 May 2015 11:24:11 -0400
Message-ID: <1432999451.114391.157.camel@redhat.com>
References: <1432185100-5613-1-git-send-email-wen.gang.wang@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-HpcRP26jr7XQYDiEAwVm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432185100-5613-1-git-send-email-wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-HpcRP26jr7XQYDiEAwVm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-21 at 13:11 +0800, Wengang Wang wrote:
> The BUG_ON at line 452/453 is triggered in function rds_send_xmit.
>=20
>  441                         while (ret) {
>  442                                 tmp =3D min_t(int, ret, sg->length -
>  443                                                       conn->c_xmit_d=
ata_off);
>  444                                 conn->c_xmit_data_off +=3D tmp;
>  445                                 ret -=3D tmp;
>  446                                 if (conn->c_xmit_data_off =3D=3D sg-=
>length) {
>  447                                         conn->c_xmit_data_off =3D 0;
>  448                                         sg++;
>  449                                         conn->c_xmit_sg++;
>  450                                         if (ret !=3D 0 && conn->c_xm=
it_sg =3D=3D rm->data.op_nents)
>  451                                                 printk(KERN_ERR "con=
n %p rm %p sg %p ret %d\n", conn, rm, sg, ret);
>  452                                         BUG_ON(ret !=3D 0 &&
>  453                                                conn->c_xmit_sg =3D=
=3D rm->data.op_nents);
>  454                                 }
>  455                         }
>=20
> it is complaining the total sent length is bigger that we want to send.
>=20
> rds_ib_xmit() is wrong for the second entry for the same rds_message retu=
rning
> wrong value.
>=20
> the sg and off passed by rds_send_xmit to rds_ib_xmit is based on
> scatterlist.offset/length, but the rds_ib_xmit action is based on
> scatterlist.dma_address/dma_length. in case dma_length is larger than len=
gth
> there is problem. for the 2nd and later entries of rds_ib_xmit for same
> rds_message, at least one of the following two is wrong:
>=20
> 1) the scatterlist to start with,  the choosen one can far beyond the cor=
rect
>    one.
> 2) the offset to start with within the scatterlist.
>=20
> fix:
> add op_dmasg and op_dmaoff to rm_data_op structure indicating the scatter=
list
> and offset within the it to start with for rds_ib_xmit respectively. op_d=
masg
> and op_dmaoff are initialized to zero when doing dma mapping for the firs=
t see
> of the message and are changed when filling send slots.
>=20
> the same applies to rds_iw_xmit too.
>=20
> Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  net/rds/ib_send.c | 17 +++++++++++------
>  net/rds/iw_send.c | 18 +++++++++++-------
>  net/rds/rds.h     |  2 ++
>  3 files changed, 24 insertions(+), 13 deletions(-)
>=20
> diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
> index bd3825d..1df6c84 100644
> --- a/net/rds/ib_send.c
> +++ b/net/rds/ib_send.c
> @@ -605,6 +605,8 @@ int rds_ib_xmit(struct rds_connection *conn, struct r=
ds_message *rm,
>  		}
> =20
>  		rds_message_addref(rm);
> +		rm->data.op_dmasg =3D 0;
> +		rm->data.op_dmaoff =3D 0;
>  		ic->i_data_op =3D &rm->data;
> =20
>  		/* Finalize the header */
> @@ -658,7 +660,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct r=
ds_message *rm,
>  	send =3D &ic->i_sends[pos];
>  	first =3D send;
>  	prev =3D NULL;
> -	scat =3D &ic->i_data_op->op_sg[sg];
> +	scat =3D &ic->i_data_op->op_sg[rm->data.op_dmasg];
>  	i =3D 0;
>  	do {
>  		unsigned int len =3D 0;
> @@ -680,17 +682,20 @@ int rds_ib_xmit(struct rds_connection *conn, struct=
 rds_message *rm,
>  		/* Set up the data, if present */
>  		if (i < work_alloc
>  		    && scat !=3D &rm->data.op_sg[rm->data.op_count]) {
> -			len =3D min(RDS_FRAG_SIZE, ib_sg_dma_len(dev, scat) - off);
> +			len =3D min(RDS_FRAG_SIZE,
> +				ib_sg_dma_len(dev, scat) - rm->data.op_dmaoff);
>  			send->s_wr.num_sge =3D 2;
> =20
> -			send->s_sge[1].addr =3D ib_sg_dma_address(dev, scat) + off;
> +			send->s_sge[1].addr =3D ib_sg_dma_address(dev, scat);
> +			send->s_sge[1].addr +=3D rm->data.op_dmaoff;
>  			send->s_sge[1].length =3D len;
> =20
>  			bytes_sent +=3D len;
> -			off +=3D len;
> -			if (off =3D=3D ib_sg_dma_len(dev, scat)) {
> +			rm->data.op_dmaoff +=3D len;
> +			if (rm->data.op_dmaoff =3D=3D ib_sg_dma_len(dev, scat)) {
>  				scat++;
> -				off =3D 0;
> +				rm->data.op_dmasg++;
> +				rm->data.op_dmaoff =3D 0;
>  			}
>  		}
> =20
> diff --git a/net/rds/iw_send.c b/net/rds/iw_send.c
> index 1383478..334fe98 100644
> --- a/net/rds/iw_send.c
> +++ b/net/rds/iw_send.c
> @@ -581,6 +581,8 @@ int rds_iw_xmit(struct rds_connection *conn, struct r=
ds_message *rm,
>  		ic->i_unsignaled_wrs =3D rds_iw_sysctl_max_unsig_wrs;
>  		ic->i_unsignaled_bytes =3D rds_iw_sysctl_max_unsig_bytes;
>  		rds_message_addref(rm);
> +		rm->data.op_dmasg =3D 0;
> +		rm->data.op_dmaoff =3D 0;
>  		ic->i_rm =3D rm;
> =20
>  		/* Finalize the header */
> @@ -622,7 +624,7 @@ int rds_iw_xmit(struct rds_connection *conn, struct r=
ds_message *rm,
>  	send =3D &ic->i_sends[pos];
>  	first =3D send;
>  	prev =3D NULL;
> -	scat =3D &rm->data.op_sg[sg];
> +	scat =3D &rm->data.op_sg[rm->data.op_dmasg];
>  	sent =3D 0;
>  	i =3D 0;
> =20
> @@ -656,10 +658,11 @@ int rds_iw_xmit(struct rds_connection *conn, struct=
 rds_message *rm,
> =20
>  		send =3D &ic->i_sends[pos];
> =20
> -		len =3D min(RDS_FRAG_SIZE, ib_sg_dma_len(dev, scat) - off);
> +		len =3D min(RDS_FRAG_SIZE,
> +			  ib_sg_dma_len(dev, scat) - rm->data.op_dmaoff);
>  		rds_iw_xmit_populate_wr(ic, send, pos,
> -				ib_sg_dma_address(dev, scat) + off, len,
> -				send_flags);
> +			ib_sg_dma_address(dev, scat) + rm->data.op_dmaoff, len,
> +			send_flags);
> =20
>  		/*
>  		 * We want to delay signaling completions just enough to get
> @@ -687,10 +690,11 @@ int rds_iw_xmit(struct rds_connection *conn, struct=
 rds_message *rm,
>  			 &send->s_wr, send->s_wr.num_sge, send->s_wr.next);
> =20
>  		sent +=3D len;
> -		off +=3D len;
> -		if (off =3D=3D ib_sg_dma_len(dev, scat)) {
> +		rm->data.op_dmaoff +=3D len;
> +		if (rm->data.op_dmaoff =3D=3D ib_sg_dma_len(dev, scat)) {
>  			scat++;
> -			off =3D 0;
> +			rm->data.op_dmaoff =3D 0;
> +			rm->data.op_dmasg++;
>  		}
> =20
>  add_header:
> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index 0d41155..d2c6009 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h
> @@ -363,6 +363,8 @@ struct rds_message {
>  			unsigned int		op_active:1;
>  			unsigned int		op_nents;
>  			unsigned int		op_count;
> +			unsigned int		op_dmasg;
> +			unsigned int		op_dmaoff;
>  			struct scatterlist	*op_sg;
>  		} data;
>  	};

This patch looks sane to me.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-HpcRP26jr7XQYDiEAwVm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVadYbAAoJELgmozMOVy/dMhkP/ioD7m04x723ggaH+hThWXPy
TKvu8LMWcFZioS0SzQhZogPz+GkZW2qKG2IWpROtsZiAm0TmBX0Msd0lec2kTS81
2HaYeIzdRnNzmut9qA3HvnoS8/Z+v+/H4PnGBN+KKsQoPqRpFP7Y8yzfybWr/eLw
WYCcnSOVCH3BWwSpj1WoQUX40XGixBquEyYOa6bLDVO6yBYq9501AOfD/jEB1ltC
+mOjwf9LkJJ2FC/eL4NNBe5HODWf1AnY4DyOxEVm5aovAfa2OM8/qP8SpO3D0X4N
fHlWqP2oeCmvoszX7qBSgCS8sn6WB+G8zQThknMRur87sZ31q4dpMXog88pL3Kyp
7gSE9RyWg81unie5u8b53jvQsu5iJULxlcljk8VZX//1WXOP8xwSZ4ksrvtlKL4h
X0ppB3SSf+yiH3BiedVyaQ433ig0ip8fSIwKhINy1yekkUX5zxwDBmqe5xopi4iB
OuQIKXFhmWcpC7aPg8t4pN97uNgsNx/cuQRTZpeBatp9Vbvpyxdkfwx+PA5MOQ4G
yQa6Nh5APhnv8juNRgb6Z7iABX0bvV9kx0w6+e4rg4ERxWbC/W815GYm1hEt8nf2
uhM7D+rw4GUq0B/mEU3rjMu4KPuO5LwFMCU8MpPjILRYs6P1cMZUh1qycRu3sRnZ
WR+vKTXEY3iH9YxbdeDx
=sIMf
-----END PGP SIGNATURE-----

--=-HpcRP26jr7XQYDiEAwVm--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
