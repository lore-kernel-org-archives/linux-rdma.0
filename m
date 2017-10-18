From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-next 2/2] IB/mlx5: Add scatter end padding support
Date: Wed, 18 Oct 2017 10:37:32 +0000
Message-ID: <BN3PR07MB25787107C19B694BB0BA39B4F84D0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <20171017151857.11934-1-leon@kernel.org>
 <20171017151857.11934-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171017151857.11934-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon, Noa,

> @@ -1781,6 +1783,19 @@ static int create_qp_common(struct mlx5_ib_dev *de=
v, struct ib_pd *pd,
>  		qp->flags |=3D MLX5_IB_QP_LSO;
>  	}
>=20
> +	if (init_attr->create_flags & IB_QP_CREATE_SCATTER_END_PADDING) {
> +		if (!MLX5_CAP_GEN(dev->mdev, end_pad)) {
> +			mlx5_ib_dbg(dev, "scatter end padding is not supported\n");
> +			err =3D -EOPNOTSUPP;
> +			goto err;
> +		} else if (init_attr->qp_type !=3D IB_QPT_RAW_PACKET) {
> +			MLX5_SET(qpc, qpc, end_padding_mode,
> +				 MLX5_WQ_END_PAD_MODE_ALIGN);
> +		} else {
> +			qp->flags |=3D MLX5_IB_QP_SCATTER_END_PADDING;
> +		}
> +	}
> +

What's the feature associated with MLX5_WQ_END_PAD_MODE_ALIGN?
It seems it was there before this patch series and bears a similar name.

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
