From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 8/9] IB/core: Add RoCE IP based addressing extensions
 for =?UTF-8?Q?rdma=5Fucm?=
Date: Wed, 11 Sep 2013 11:52:25 +0200
Message-ID: <26c47667e463e65dd79caaa4bddc437b@meuh.org>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com>
 <1378824099-22150-9-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378824099-22150-9-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le 10.09.2013 16:41, Or Gerlitz a =C3=A9crit=C2=A0:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Add rdma_ucm support for RoCE (IBoE) IP based addressing extensions
> towards librdmacm
>=20
> Extend INIT_QP_ATTR and QUERY_ROUTE ucma commands.
>=20
> INIT_QP_ATTR_EX uses struct ib_uverbs_qp_attr_ex
>=20
> QUERY_ROUTE_EX uses struct rdma_ucm_query_route_resp_ex which in turn
> uses ib_user_path_rec_ex
>=20
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/ucma.c   |  175=20
> ++++++++++++++++++++++++++++++++++++-
>  include/uapi/rdma/rdma_user_cm.h |   29 ++++++-
>  2 files changed, 198 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/ucma.c=20
> b/drivers/infiniband/core/ucma.c
> index 7e7da86..4d59e88 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
>=20
> +static ssize_t ucma_init_qp_attr_ex(struct ucma_file *file,
> +				    const char __user *inbuf,
> +				    int in_len, int out_len)
> +{
> +	struct rdma_ucm_init_qp_attr_ex cmd;
> +	struct ib_uverbs_qp_attr_ex resp;
> +	struct ucma_context *ctx;
> +	struct ib_qp_attr qp_attr;
> +	int ret;
> +
> +	if (out_len < sizeof(resp))
> +		return -ENOSPC;
> +
> +	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
> +		return -EFAULT;
> +
> +	if (copy_from_user(&resp, (void __user *)(unsigned long)cmd.respons=
e,
> +			   sizeof(resp)))
> +		return -EFAULT;
> +


Reading from the response buffer ? I haven't seen that before in IB/cor=
e=20
before.

It's seems to me that no other part of user verbs/RDMA API is using the=
=20
output buffer as an input buffer.

> +	ctx =3D ucma_get_ctx(file, cmd.id);
> +	if (IS_ERR(ctx))
> +		return PTR_ERR(ctx);
> +
> +	resp.comp_mask =3D cmd.comp_mask;
> +	resp.qp_attr_mask =3D 0;
> +	memset(&qp_attr, 0, sizeof(qp_attr));
> +	qp_attr.qp_state =3D cmd.qp_state;
> +	ret =3D rdma_init_qp_attr(ctx->cm_id, &qp_attr, &resp.qp_attr_mask)=
;
> +	if (ret)
> +		goto out;
> +
> +	ib_copy_qp_attr_to_user_ex(&resp, &qp_attr);
> +	if (copy_to_user((void __user *)(unsigned long)cmd.response,
> +			 &resp, sizeof(resp)))
> +		ret =3D -EFAULT;
> +
> +out:
> +	ucma_put_ctx(ctx);
> +	return ret;
> +}
> +

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
