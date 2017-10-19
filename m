From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/2] IB/mlx5: Add scatter end padding support
Date: Thu, 19 Oct 2017 13:15:07 +0300
Message-ID: <70f59192-fcd8-95b9-72f0-edda9ac6c287@mellanox.com>
References: <20171017151857.11934-1-leon@kernel.org>
 <20171017151857.11934-3-leon@kernel.org>
 <BN3PR07MB25787107C19B694BB0BA39B4F84D0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <7d53f1e2-239b-0415-5b28-875f1710c11a@mellanox.com>
 <BN3PR07MB2578139CB1C38C5228B395F6F8420@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR07MB2578139CB1C38C5228B395F6F8420-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ram,

On 10/19/2017 10:56 AM, Amrani, Ram wrote:

>>> What's the feature associated with MLX5_WQ_END_PAD_MODE_ALIGN?
>>> It seems it was there before this patch series and bears a similar name.
>> Right, this series exposes this already existing feature to the user.
> I'm under the impression that they are somewhat different (per QP type??) from this code:
>
> +	if (init_attr->create_flags & IB_QP_CREATE_SCATTER_END_PADDING) {
> +		if (!MLX5_CAP_GEN(dev->mdev, end_pad)) {
> +			mlx5_ib_dbg(dev, "scatter end padding is not supported\n");
> +			err = -EOPNOTSUPP;
> +			goto err;
> +		} else if (init_attr->qp_type != IB_QPT_RAW_PACKET) {
> +			MLX5_SET(qpc, qpc, end_padding_mode,
> +				 MLX5_WQ_END_PAD_MODE_ALIGN);
> +		} else {
> +			qp->flags |= MLX5_IB_QP_SCATTER_END_PADDING;
> +		}
> +	}
> +
>
> But if indeed they are the same then please consider using the same names to increase readability.

Raw Packet QP is implemented by a WQ, so its flow is different from that of
other QP types.
Eventually, its receive WQ context's field will be set to MLX5_WQ_END_PAD_MODE_ALIGN
as well.

> Thanks,
> Ram
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
