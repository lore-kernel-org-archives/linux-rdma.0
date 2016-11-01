From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] qedr: Fix possible memory leak in qedr_create_qp()
Date: Tue, 1 Nov 2016 10:38:01 +0000
Message-ID: <SN1PR07MB22078B3EAB760045CC568D8AF8A10@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1477672427-31575-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477672427-31575-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 'qp' is malloced in qedr_create_qp() and should be freed before leaving f=
rom the
> error handling cases, otherwise it will cause memory leak.
>=20
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/qedr/verbs.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/qedr/verbs.c
> b/drivers/infiniband/hw/qedr/verbs.c
> index a615142..b60f145 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -1477,6 +1477,7 @@ struct ib_qp *qedr_create_qp(struct ib_pd *ibpd,
>  	struct qedr_ucontext *ctx =3D NULL;
>  	struct qedr_create_qp_ureq ureq;
>  	struct qedr_qp *qp;
> +	struct ib_qp *ibqp;
>  	int rc =3D 0;
>=20
>  	DP_DEBUG(dev, QEDR_MSG_QP, "create qp: called from %s, pd=3D%p\n",
> @@ -1486,13 +1487,13 @@ struct ib_qp *qedr_create_qp(struct ib_pd *ibpd,
>  	if (rc)
>  		return ERR_PTR(rc);
>=20
> +	if (attrs->srq)
> +		return ERR_PTR(-EINVAL);
> +
>  	qp =3D kzalloc(sizeof(*qp), GFP_KERNEL);
>  	if (!qp)
>  		return ERR_PTR(-ENOMEM);
>=20
> -	if (attrs->srq)
> -		return ERR_PTR(-EINVAL);
> -
>  	DP_DEBUG(dev, QEDR_MSG_QP,
>  		 "create qp: sq_cq=3D%p, sq_icid=3D%d, rq_cq=3D%p, rq_icid=3D%d\n",
>  		 get_qedr_cq(attrs->send_cq),
> @@ -1508,7 +1509,10 @@ struct ib_qp *qedr_create_qp(struct ib_pd *ibpd,
>  			       "create qp: unexpected udata when creating GSI
> QP\n");
>  			goto err0;
>  		}
> -		return qedr_create_gsi_qp(dev, attrs, qp);
> +		ibqp =3D qedr_create_gsi_qp(dev, attrs, qp);
> +		if (IS_ERR(ibqp))
> +			kfree(qp);
> +		return ibqp;
>  	}
>=20
>  	memset(&in_params, 0, sizeof(in_params));

Thanks again

Acked-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
