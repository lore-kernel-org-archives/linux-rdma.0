From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RE-RESEND V2 for-next 4/5] IB/core: Make sure that the
 PSN does not overflow
Date: Mon, 16 Feb 2015 22:22:32 +0100
Message-ID: <1424121752.32606.32.camel@opteya.com>
References: <1423137232-24587-1-git-send-email-ogerlitz@mellanox.com>
	 <1423137232-24587-5-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423137232-24587-5-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 05 f=C3=A9vrier 2015 =C3=A0 13:53 +0200, Or Gerlitz a =C3=A9cr=
it :
> From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The rq/sq->psn is 24 bits as defined in the IB spec, therefore ULPs a=
nd User
> space applications shouldn't use the 8 most significant bits in the 3=
2 bits
> variables to avoid overflow in modify_qp.
>=20
> Fixed the PSN generation by the RDMA-CM to mask out the 8 most signif=
icant bits,
> also mask out these bits in uverbs for attributes provided by user-sp=
ace.
>=20
> Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c        |    1 +
>  drivers/infiniband/core/uverbs_cmd.c |    4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/=
cma.c
> index d570030..fab0ee5 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -512,6 +512,7 @@ struct rdma_cm_id *rdma_create_id(rdma_cm_event_h=
andler event_handler,
>  	INIT_LIST_HEAD(&id_priv->listen_list);
>  	INIT_LIST_HEAD(&id_priv->mc_list);
>  	get_random_bytes(&id_priv->seq_num, sizeof id_priv->seq_num);
> +	id_priv->seq_num &=3D 0xffffff;
> =20
>  	return &id_priv->id;
>  }
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniban=
d/core/uverbs_cmd.c
> index 532d8eb..ecb6430 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2053,8 +2053,8 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_fi=
le *file,
>  	attr->path_mtu 		  =3D cmd.path_mtu;
>  	attr->path_mig_state 	  =3D cmd.path_mig_state;
>  	attr->qkey 		  =3D cmd.qkey;
> -	attr->rq_psn 		  =3D cmd.rq_psn;
> -	attr->sq_psn 		  =3D cmd.sq_psn;
> +	attr->rq_psn              =3D cmd.rq_psn & 0xffffff;
> +	attr->sq_psn              =3D cmd.sq_psn & 0xffffff;
>  	attr->dest_qp_num 	  =3D cmd.dest_qp_num;
>  	attr->qp_access_flags 	  =3D cmd.qp_access_flags;
>  	attr->pkey_index 	  =3D cmd.pkey_index;

0xffffff could be made a #define

Question: userspace is allowed to ask for a PSN on 32bits, but it will=20
be silently truncated, is it going to puzzle applications ?

Anyway, it would have been better to return an error in
the first place ... not sure if we can do it now ...

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
