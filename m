From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 4/6] IB/mlx5: Handle type IB_QPT_DRIVER when
 creating a QP
Date: Wed, 27 Dec 2017 15:02:27 -0700
Message-ID: <20171227220227.GL31310@mellanox.com>
References: <20171227171540.1646-1-leon@kernel.org>
 <20171227171540.1646-5-leon@kernel.org>
 <CAJ3xEMiExjjVUOYQsdMiHLNOjB+MOkz4c1TT9AT_inkfGfMuKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiExjjVUOYQsdMiHLNOjB+MOkz4c1TT9AT_inkfGfMuKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 27, 2017 at 11:16:09PM +0200, Or Gerlitz wrote:
> On Wed, Dec 27, 2017 at 7:15 PM, Leon wrote:
> > From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> > +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > @@ -202,6 +202,8 @@ struct mlx5_ib_flow_db {
> >   * creates the actual hardware QP.
> >   */
> >  #define MLX5_IB_QPT_HW_GSI     IB_QPT_RESERVED2
> > +#define MLX5_IB_QPT_DCI                IB_QPT_RESERVED3
> > +#define MLX5_IB_QPT_DCT                IB_QPT_RESERVED4
> 
> When we added the reserved QPTs we made an explicit statement at the
> verbs header file that this is a "range for qp types internal to the
> low level driver"
> 
> In the down stream patches you are actually assuming user-space
> knows that for mlx5 DCI/DCT equals IB_QPT_RESERVED3/4 which
> violates this statement.

IB_QPT_RESERVED should NOT leak to the user driver ever, for some
reason a flag is used. I thought we agreed to an enum during the
original RFC?

> Maybe you need
> 
> IB_QPT_VENDOR1
> IB_QPT_VENDOR2
> ...
> IB_QPT_VENDOR10

No, no. The driver specific QP type is carried only within the driver
specific udata and is never part of the common API.

> you added these two flags in the ABI file, but you never use them in downstream
> 
> MLX5_QP_FLAG_TYPE_DCT
> MLX5_QP_FLAG_TYPE_DCI
> 
> patches, something must be wrong here even according to your design

Hm? they are used here:

+       if (ucmd->flags & MLX5_QP_FLAG_TYPE_DCI)
+               init_attr->qp_type = MLX5_IB_QPT_DCI;
+       else
+               init_attr->qp_type = MLX5_IB_QPT_DCT;

Which is a bad ABI design, check flags explicitly never use else.

Not sure how much I like this - why try so hard to keep the udata
unchanged? I would have added a 'u32 mlx_qp_type' and a variable
length struct I think..

Or use the new kabi :|

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
