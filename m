From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 4/6] IB/mlx5: Handle type IB_QPT_DRIVER when
 creating a QP
Date: Thu, 28 Dec 2017 08:17:57 +0200
Message-ID: <CAJ3xEMhoxazkdiO0wpCz-j30x-CAxBk+4sB8NYYugvts0T9s4Q@mail.gmail.com>
References: <20171227171540.1646-1-leon@kernel.org> <20171227171540.1646-5-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171227171540.1646-5-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 27, 2017 at 7:15 PM, Leon Romanovsky wrote:
> From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> The QP type IB_QPT_DRIVER doesn't describe the transport or the service that
> the QP provides but those are known only to the hardware driver.
> The extra data that tells more about the QP is in the driver
> channel.
> Take the real QP type from the driver channel and modify the QP initial
> attributes before continuing with create_qp(). Also, define the layout
> of the data structure that comes in the driver channel.
> Downstream patches from this series will add support for both DCI and
> DCT driver QPs.

> +static int validate_driver_qp(struct mlx5_ib_dev *dev,
> +                             struct ib_qp_init_attr *init_attr,
> +                             struct mlx5_ib_create_qp *ucmd,
> +                             struct ib_udata *udata)
> +{

[...]

> +       if (ucmd->flags & MLX5_QP_FLAG_TYPE_DCI)
> +               init_attr->qp_type = MLX5_IB_QPT_DCI;
> +       else
> +               init_attr->qp_type = MLX5_IB_QPT_DCT;
> +       return 0;
> +}

from maintenance/clarity standpoint, not sure if it is a good idea that
a validate_yyy function does assignment


> +
>  struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
> -                               struct ib_qp_init_attr *init_attr,
> +                               struct ib_qp_init_attr *verbs_init_attr,
>                                 struct ib_udata *udata)
>  {

[...]

> @@ -2153,6 +2195,16 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
>                 dev = to_mdev(to_mxrcd(init_attr->xrcd)->ibxrcd.device);
>         }
>
> +       if (init_attr->qp_type == IB_QPT_DRIVER) {
> +               struct mlx5_ib_create_qp ucmd;
> +
> +               init_attr = &mlx_init_attr;
> +               memcpy(init_attr, verbs_init_attr, sizeof(*verbs_init_attr));
> +               err = validate_driver_qp(dev, init_attr, &ucmd, udata);
> +               if (err)
> +                       return ERR_PTR(err);
> +       }
> +
>         switch (init_attr->qp_type) {
>         case IB_QPT_XRC_TGT:
>         case IB_QPT_XRC_INI:
> @@ -2214,6 +2266,9 @@ struct ib_qp *mlx5_ib_create_qp(struct ib_pd *pd,
>                 return ERR_PTR(-EINVAL);
>         }
>
> +       if (verbs_init_attr->qp_type == IB_QPT_DRIVER)
> +               qp->driver_qp_type = init_attr->qp_type;
> +
>         return &qp->ibqp;
>  }

so if the values passed by user space are legal and the FW supports
DC, no error is returned to user-space, right? this doesn't seem bisectable,
if only patches 1...4 are applied, create qp will succeed?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
