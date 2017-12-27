From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 4/6] IB/mlx5: Handle type IB_QPT_DRIVER when
 creating a QP
Date: Wed, 27 Dec 2017 23:16:09 +0200
Message-ID: <CAJ3xEMiExjjVUOYQsdMiHLNOjB+MOkz4c1TT9AT_inkfGfMuKA@mail.gmail.com>
References: <20171227171540.1646-1-leon@kernel.org> <20171227171540.1646-5-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171227171540.1646-5-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 27, 2017 at 7:15 PM, Leon wrote:
> From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -202,6 +202,8 @@ struct mlx5_ib_flow_db {
>   * creates the actual hardware QP.
>   */
>  #define MLX5_IB_QPT_HW_GSI     IB_QPT_RESERVED2
> +#define MLX5_IB_QPT_DCI                IB_QPT_RESERVED3
> +#define MLX5_IB_QPT_DCT                IB_QPT_RESERVED4

When we added the reserved QPTs we made an explicit statement at the
verbs header file that this is a "range for qp types internal to the
low level driver"

In the down stream patches you are actually assuming user-space
knows that for mlx5 DCI/DCT equals IB_QPT_RESERVED3/4 which
violates this statement.

What you are looking for is more of vendor QPT

Maybe you need

IB_QPT_VENDOR1
IB_QPT_VENDOR2
...
IB_QPT_VENDOR10

and use the per driver ABI header to advertize to user space the
semantics, e.g in
the mlx5 ABI you put

IB_QPT_VENDOR1 = DCI
IB_QPT_VENDOR2 = DCT

you added these two flags in the ABI file, but you never use them in downstream

MLX5_QP_FLAG_TYPE_DCT
MLX5_QP_FLAG_TYPE_DCI

patches, something must be wrong here even according to your design
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
