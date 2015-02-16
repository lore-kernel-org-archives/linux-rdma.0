From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RE-RESEND V2 for-next 5/5] IB/core: Fix deadlock on
 uverbs modify_qp error flow
Date: Mon, 16 Feb 2015 22:17:03 +0100
Message-ID: <1424121423.32606.27.camel@opteya.com>
References: <1423137232-24587-1-git-send-email-ogerlitz@mellanox.com>
	 <1423137232-24587-6-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423137232-24587-6-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le jeudi 05 f=C3=A9vrier 2015 =C3=A0 13:53 +0200, Or Gerlitz a =C3=A9cr=
it :
> From: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The deadlock occurs on __uverbs_modify_qp, we take a lock (idr_read_q=
p)
> and in case of failure in ib_resolve_eth_l2_attrs we don't release
> it (put_qp_read). Fix that.
>=20
> Issue: 355606
 ^^^^^^^^^^^^^^
I'm not sure this is relevant

> Fixes: ed4c54e5b4ba ("IB/core: Resolve Ethernet L2 addresses when mod=
ifying QP")
> Signed-off-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_cmd.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniban=
d/core/uverbs_cmd.c
> index ecb6430..a602ce9 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2097,20 +2097,21 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_=
file *file,
>  	if (qp->real_qp =3D=3D qp) {
>  		ret =3D ib_resolve_eth_l2_attrs(qp, attr, &cmd.attr_mask);
>  		if (ret)
> -			goto out;
> +			goto release_qp;
>  		ret =3D qp->device->modify_qp(qp, attr,
>  			modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
>  	} else {
>  		ret =3D ib_modify_qp(qp, attr, modify_qp_mask(qp->qp_type, cmd.att=
r_mask));
>  	}
> =20
> -	put_qp_read(qp);
> -
>  	if (ret)
> -		goto out;
> +		goto release_qp;
> =20
>  	ret =3D in_len;
> =20
> +release_qp:
> +	put_qp_read(qp);
> +
>  out:
>  	kfree(attr);
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
