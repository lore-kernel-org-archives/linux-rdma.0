From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RFC] Vendor-specific QPs
Date: Thu, 2 Nov 2017 14:01:58 -0600
Message-ID: <20171102200158.GU18874@ziepe.ca>
References: <VI1PR05MB12784029D1DE2689A8194A58B9590@VI1PR05MB1278.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR05MB12784029D1DE2689A8194A58B9590-79XLn2atqDMOK6E67s+DINqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 30, 2017 at 03:23:24PM +0000, Alex Margolin wrote:

> We propose using the "reserved" range of QP types to serve the
> vendor-specific implementation, both within the Verbs API (API patch
> below) and the IB subsystem (ib_core). The solution requires minor
> changes to IB core, namely removing some restrictions that apply to
> standard QPs at creation, but most of the flow (and the one for
> modify and destroy) remains identical.

> The changes to support such QPs will remain in the vendor-specific
> area of the API, i.e. Mellanox "Direct Verbs" portion, and the
> change in ib_core is to use specific IB_QPT_RESERVED* definitions to
> cut through some of the required checks (but still using most of the
> logic, where applicable). No change to libibverbs is required.

Don't like the idea of a generic RESERVED.

Add a type called IB_QPT_DIRECT_VERBS and put any other information
(eg MLX5_IB_QPT_REG_UMR/DC_INI/DC_TGT etc) you need inside the driver
data.

> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -193,6 +193,8 @@ struct mlx5_ib_flow_db {
> #define MLX5_IB_SEND_UMR_UPDATE_PD_ACCESS       IB_SEND_RESERVED_END
> 
> #define MLX5_IB_QPT_REG_UMR    IB_QPT_RESERVED1
> +#define MLX5_IB_QPT_DC_INI     IB_QPT_RESERVED3
> +#define MLX5_IB_QPT_DC_TGT     IB_QPT_RESERVED4

> +enum mlx5dv_qp_type {
> +    MLX5DV_QPT_DC_SEND = IB_QPT_RESERVED3,
> +    MLX5DV_QPT_DC_RECV = IB_QPT_RESERVED4
> +};

It really bothers me every time I see someone introduce a constant
shared between kernel and userspace and then chooses to use
different names. Leon was just complaining about this.

> + #define MLX5DV_DC_CAP_FULL_HANDSHAKE  (1 << 0) #define 
> + MLX5DV_DC_CAP_MAX_RESPONDERS  (1 << 1) #define 
> + MLX5DV_DC_CAP_CNAK_REVERSE_SL (1 << 2)

?? again.. why send patches in a RFC if they are full
of garbage?

> +struct mlx5dv_qp_init_attr {
> +    uint32_t comp_mask;
> +    union {
> +        struct {
> +            enum mlx5dv_qp_handshake_mode mode;
> +            uint8_t  reverse_cnak_sl;
> +        } dc_send;
> +        struct {
> +            enum mlx5dv_qp_handshake_mode mode;
> +            uint64_t dc_key;
> +            uint32_t min_responders;
> +            uint32_t max_responders;
> +        } dc_recv;
> +    };
> +};

A comp_mask and a union? That is pretty wonky.

> +struct mlx5dv_send_wr {
> +    uint32_t comp_mask;
> +    union {
> +        struct {
> +            struct ibv_ah  *ah;
> +            uint32_t    remote_qpn;
> +            uint32_t    remote_qkey;
> +            uint64_t    remote_dc_key;
> +            uint8_t     reverse_data_sl;
> +        } dc_send;
> +    };
> +};

> +struct mlx5dv_send_wr {
> +    struct mlx5dv_send_wr *next;
> +    struct mlx5dv_vendor_send_wr *mlx_wr;
> +    struct ibv_send_wr ibv_wr;
> +};

Two structs with the same name? Not sure what this is trying to
explain. This is why people typically won't review RFCs I guess.

> +int mlx5dv_post_send(struct ibv_qp *qp,
> +                     struct mlx5dv_send_wr *mlx5_wr,
> +                     struct mlx5dv_send_wr **bad_wr);

We've talked about this in the past, I think you should have a
differentiated post send and forget the above two confusing structs.

  mlx5dv_post_dc_send(..)
  mlx5dv_post_dc_recv(..)

This will perform better than trying to create a multiplexed thing -
see the long discussion that reached that conclusion for the CQ side.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
