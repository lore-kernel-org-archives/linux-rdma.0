From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH mlx5-next 08/10] IB/mlx5: Call PAGE_FAULT_RESUME command
 asynchronously
Date: Fri, 9 Nov 2018 09:59:53 -0700
Message-ID: <20181109165953.GC22987@ziepe.ca>
References: <20181108191017.21891-1-leon@kernel.org>
 <20181108191017.21891-9-leon@kernel.org>
 <20181108194857.GF5548@mellanox.com>
 <20181109162622.GX3695@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181109162622.GX3695@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 09, 2018 at 06:26:22PM +0200, Leon Romanovsky wrote:
> On Thu, Nov 08, 2018 at 07:49:03PM +0000, Jason Gunthorpe wrote:
> > On Thu, Nov 08, 2018 at 09:10:15PM +0200, Leon Romanovsky wrote:
> > > From: Moni Shoua <monis@mellanox.com>
> > >
> > > Telling the HCA that page fault handling is done and QP can resume
> > > its flow is done in the context of the page fault handler. This blocks
> > > the handling of the next work in queue without a need.
> > > Call the PAGE_FAULT_RESUME command in an asynchronous manner and free
> > > the workqueue to pick the next work item for handling. All tasks that
> > > were executed after PAGE_FAULT_RESUME need to be done now
> > > in the callback of the asynchronous command mechanism.
> > >
> > > Signed-off-by: Moni Shoua <monis@mellanox.com>
> > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > >  drivers/infiniband/hw/mlx5/odp.c | 110 +++++++++++++++++++++++++------
> > >  include/linux/mlx5/driver.h      |   3 +
> > >  2 files changed, 94 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
> > > index abce55b8b9ba..0c4f469cdd5b 100644
> > > +++ b/drivers/infiniband/hw/mlx5/odp.c
> > > @@ -298,20 +298,78 @@ void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
> > >  	return;
> > >  }
> > >
> > > +struct pfault_resume_cb_ctx {
> > > +	struct mlx5_ib_dev *dev;
> > > +	struct mlx5_core_rsc_common *res;
> > > +	struct mlx5_pagefault *pfault;
> > > +};
> > > +
> > > +static void page_fault_resume_callback(int status, void *context)
> > > +{
> > > +	struct pfault_resume_cb_ctx *ctx = context;
> > > +	struct mlx5_pagefault *pfault = ctx->pfault;
> > > +
> > > +	if (status)
> > > +		mlx5_ib_err(ctx->dev, "Resolve the page fault failed with status %d\n",
> > > +			    status);
> > > +
> > > +	if (ctx->res)
> > > +		mlx5_core_res_put(ctx->res);
> > > +	kfree(pfault);
> > > +	kfree(ctx);
> > > +}
> > > +
> > >  static void mlx5_ib_page_fault_resume(struct mlx5_ib_dev *dev,
> > > +				      struct mlx5_core_rsc_common *res,
> > >  				      struct mlx5_pagefault *pfault,
> > > -				      int error)
> > > +				      int error,
> > > +				      bool async)
> > >  {
> > > +	int ret = 0;
> > > +	u32 *out = pfault->out_pf_resume;
> > > +	u32 *in = pfault->in_pf_resume;
> > > +	u32 token = pfault->token;
> > >  	int wq_num = pfault->event_subtype == MLX5_PFAULT_SUBTYPE_WQE ?
> > > -		     pfault->wqe.wq_num : pfault->token;
> > > -	int ret = mlx5_core_page_fault_resume(dev->mdev,
> > > -					      pfault->token,
> > > -					      wq_num,
> > > -					      pfault->type,
> > > -					      error);
> > > -	if (ret)
> > > -		mlx5_ib_err(dev, "Failed to resolve the page fault on WQ 0x%x\n",
> > > -			    wq_num);
> > > +		pfault->wqe.wq_num : pfault->token;
> > > +	u8 type = pfault->type;
> > > +	struct pfault_resume_cb_ctx *ctx = NULL;
> > > +
> > > +	if (async)
> > > +		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
> >
> > Why not allocate this ctx ast part of the mlx5_pagefault and avoid
> > this allocation failure strategy?
> 
> It is another way to implement it, both of them are correct.

.. I think it is alot better to move this allocation, it gets rid of
this ugly duplicated code

> Can I assume that we can progress with patches except patch #2?

Lets drop this one too..

Jason
