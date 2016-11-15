From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [patch] qedr: Unlock on error in qedr_post_send()
Date: Tue, 15 Nov 2016 10:28:46 +0000
Message-ID: <DM3PR07MB220156E77D0C7992E1D88678F8BF0@DM3PR07MB2201.namprd07.prod.outlook.com>
References: <20161115095059.GB15424@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161115095059.GB15424@mwanda>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> If "wr" is NULL then we return without unlocking.  I added an unlock
> label and changed the direct returns to gotos.
>=20
> Fixes: afa0e13be754 ("qedr: Add support for data path")
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> diff --git a/drivers/infiniband/hw/qedr/verbs.c
> b/drivers/infiniband/hw/qedr/verbs.c
> index a615142..01d05b0 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -2973,17 +2973,18 @@ int qedr_post_send(struct ib_qp *ibqp, struct
> ib_send_wr *wr,
>=20
>  	if ((qp->state =3D=3D QED_ROCE_QP_STATE_RESET) ||
>  	    (qp->state =3D=3D QED_ROCE_QP_STATE_ERR)) {
> -		spin_unlock_irqrestore(&qp->q_lock, flags);
>  		*bad_wr =3D wr;
>  		DP_DEBUG(dev, QEDR_MSG_CQ,
>  			 "QP in wrong state! QP icid=3D0x%x state %d\n",
>  			 qp->icid, qp->state);
> -		return -EINVAL;
> +		rc =3D -EINVAL;
> +		goto unlock;
>  	}
>=20
>  	if (!wr) {
>  		DP_ERR(dev, "Got an empty post send.\n");
> -		return -EINVAL;
> +		rc =3D -EINVAL;
> +		goto unlock;
>  	}
>=20
>  	while (wr) {
> @@ -3012,6 +3013,7 @@ int qedr_post_send(struct ib_qp *ibqp, struct
> ib_send_wr *wr,
>  	/* Make sure write sticks */
>  	mmiowb();
>=20
> +unlock:
>  	spin_unlock_irqrestore(&qp->q_lock, flags);
>=20
>  	return rc;

Thanks for catching this. However this was already taken care of by Wei Yon=
gjun in a different manner.
See: https://patchwork.kernel.org/patch/9409053/=20

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
