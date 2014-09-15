From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/uverbs: Add QP creation flags, allow
 blocking UD multicast loopback
Date: Mon, 15 Sep 2014 18:52:52 +0200
Message-ID: <1410799972.7830.25.camel@localhost.localdomain>
References: <1410700802-27848-1-git-send-email-ogerlitz@mellanox.com>
	 <1410700802-27848-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410700802-27848-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le dimanche 14 septembre 2014 =C3=A0 16:20 +0300, Or Gerlitz a =C3=A9cr=
it :
> Currently, there's no way for user-space applications to specify
> the IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK QP creation flags defined
> by commit 47ee1b9 "IB/core: Add support for multicast loopback blocki=
ng".
>=20

Commit identifier is too short, 12 digits is the norm.

> As a result, applications who send and recieve over the same QP to
> the same multicast group get all their packets bouncded back to them,
> which is terribly bad performance wise.
>=20
> To fix this long standing issue, add the ability to provide QP
> creation flags through uverbs.
>=20
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_cmd.c |   35 ++++++++++++++++++++++++=
++++++++-
>  include/uapi/rdma/ib_user_verbs.h    |    2 +-
>  2 files changed, 34 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniban=
d/core/uverbs_cmd.c
> index 0600c50..1ad489c 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -1579,6 +1579,31 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uverbs_=
file *file,
>  	return in_len;
>  }
> =20
> +enum ib_uverbs_qp_create_flags {
> +	IB_UVERBS_QP_CREATE_LSO	    =3D 0,
> +	IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK =3D 1,
> +	IB_UVERBS_SUPPORTED_FLAGS
> +};

IB_UVERBS_QP_CREATE_LSO and IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBAC=
K
should moved in include/uapi/rdma/ib_user_verbs.h.

If this is going to be flags, these values might be OR-ed together ?
Then the userspace values should be defined like the kernel ones
(see commit 47ee1b9f2e7b):

+enum ib_uverbs_qp_create_flags {
+	IB_UVERBS_QP_CREATE_LSO	    =3D                  1 << 0,
+	IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK =3D 1 << 1,
+}

IB_UVERBS_SUPPORTED_FLAGS must be kept in this module, but defined
as:

#define IB_UVERBS_QP_CREATE_FLAGS_ALL (IB_UVERBS_QP_CREATE_LSO | \
				       IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK)

> +
> +static int ib_uverbs_create_qp_trans(u8 u_flags)
> +{
> +	int i;
> +	int res;
> +	static const enum ib_qp_create_flags ib_uverbs_qp_create_flags[IB_U=
VERBS_SUPPORTED_FLAGS] =3D {
> +		[IB_UVERBS_QP_CREATE_LSO] =3D IB_QP_CREATE_IPOIB_UD_LSO,
> +		[IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK] =3D IB_QP_CREATE_BL=
OCK_MULTICAST_LOOPBACK,
> +	};
> +
> +	if (u_flags & ~((1 << IB_UVERBS_SUPPORTED_FLAGS) - 1))
> +		return -1;
> +

	if (u_flags & ~(u8)(IB_UVERBS_QP_CREATE_FLAGS_ALL))
	   return -1;

> +	for (i =3D 0; i < IB_UVERBS_SUPPORTED_FLAGS; i++)
> +		if (u_flags & (1 << i))
> +			res |=3D ib_uverbs_qp_create_flags[i];
> +
> +	return res;
> +}
> +

This function can be replaced by compile time assert:

BUILD_BUG_ON(IB_UVERBS_QP_CREATE_LSO !=3D IB_QP_CREATE_IPOIB_UD_LSO);
BUILD_BUG_ON(IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK !=3D
IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK);

This way the values can be used without conversion.

>  ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
>  			    const char __user *buf, int in_len,
>  			    int out_len)
> @@ -1595,7 +1620,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_fi=
le *file,
>  	struct ib_srq                  *srq =3D NULL;
>  	struct ib_qp                   *qp;
>  	struct ib_qp_init_attr          attr;
> -	int ret;
> +	int flags, ret;
> =20
>  	if (out_len < sizeof resp)
>  		return -ENOSPC;
> @@ -1664,7 +1689,13 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_f=
ile *file,
>  	attr.xrcd	   =3D xrcd;
>  	attr.sq_sig_type   =3D cmd.sq_sig_all ? IB_SIGNAL_ALL_WR : IB_SIGNA=
L_REQ_WR;
>  	attr.qp_type       =3D cmd.qp_type;
> -	attr.create_flags  =3D 0;
> +
> +	flags  =3D ib_uverbs_create_qp_trans(cmd.create_flags);
> +	if (flags < 0) {
> +		ret =3D -EINVAL;
> +		goto err_put;
> +	}
> +	attr.create_flags  =3D flags;
> =20
>  	attr.cap.max_send_wr     =3D cmd.max_send_wr;
>  	attr.cap.max_recv_wr     =3D cmd.max_recv_wr;
> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib=
_user_verbs.h
> index 26daf55..fac6975 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -470,7 +470,7 @@ struct ib_uverbs_create_qp {
>  	__u8  sq_sig_all;
>  	__u8  qp_type;
>  	__u8  is_srq;
> -	__u8  reserved;
> +	__u8  create_flags;
>  	__u64 driver_data[0];
>  };
> =20

I'm not really happy with the way "reserved" field is used by this
patch: as the field wasn't check for being set to 0, any value could be
given by userspace (imagine the structure lay on stack). Using it now
could be dangerous. It must be double checked.

http://blog.ffwll.ch/2013/11/botching-up-ioctls.html

"Check all unused fields and flags and all the padding for whether it's
0, and reject the ioctl if that's not the case. Otherwise your nice pla=
n
for future extensions is going right down the gutters since someone wil=
l
submit an ioctl struct with random stack garbage in the yet unused
parts. Which then bakes in the ABI that those fields can never be used
for anything else but garbage."

Regards.

--=20
Yann Droneaud
OPTEYA



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
