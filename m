From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next 08/10] IB/mlx5: Call PAGE_FAULT_RESUME command
 asynchronously
Date: Sat, 10 Nov 2018 17:47:25 +0200
Message-ID: <20181110154725.GB3695@mtr-leonro.mtl.com>
References: <20181108191017.21891-1-leon@kernel.org>
 <20181108191017.21891-9-leon@kernel.org>
 <20181108194857.GF5548@mellanox.com>
 <20181109162622.GX3695@mtr-leonro.mtl.com>
 <20181109165953.GC22987@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sWvRP97dwRHm9fX+"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181109165953.GC22987@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--sWvRP97dwRHm9fX+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 09, 2018 at 09:59:53AM -0700, Jason Gunthorpe wrote:
> On Fri, Nov 09, 2018 at 06:26:22PM +0200, Leon Romanovsky wrote:
> > On Thu, Nov 08, 2018 at 07:49:03PM +0000, Jason Gunthorpe wrote:
> > > On Thu, Nov 08, 2018 at 09:10:15PM +0200, Leon Romanovsky wrote:
> > > > From: Moni Shoua <monis@mellanox.com>
> > > >
> > > > Telling the HCA that page fault handling is done and QP can resume
> > > > its flow is done in the context of the page fault handler. This blocks
> > > > the handling of the next work in queue without a need.
> > > > Call the PAGE_FAULT_RESUME command in an asynchronous manner and free
> > > > the workqueue to pick the next work item for handling. All tasks that
> > > > were executed after PAGE_FAULT_RESUME need to be done now
> > > > in the callback of the asynchronous command mechanism.
> > > >
> > > > Signed-off-by: Moni Shoua <monis@mellanox.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > > >  drivers/infiniband/hw/mlx5/odp.c | 110 +++++++++++++++++++++++++------
> > > >  include/linux/mlx5/driver.h      |   3 +
> > > >  2 files changed, 94 insertions(+), 19 deletions(-)
> > > >
> > > > diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
> > > > index abce55b8b9ba..0c4f469cdd5b 100644
> > > > +++ b/drivers/infiniband/hw/mlx5/odp.c
> > > > @@ -298,20 +298,78 @@ void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
> > > >  	return;
> > > >  }
> > > >
> > > > +struct pfault_resume_cb_ctx {
> > > > +	struct mlx5_ib_dev *dev;
> > > > +	struct mlx5_core_rsc_common *res;
> > > > +	struct mlx5_pagefault *pfault;
> > > > +};
> > > > +
> > > > +static void page_fault_resume_callback(int status, void *context)
> > > > +{
> > > > +	struct pfault_resume_cb_ctx *ctx = context;
> > > > +	struct mlx5_pagefault *pfault = ctx->pfault;
> > > > +
> > > > +	if (status)
> > > > +		mlx5_ib_err(ctx->dev, "Resolve the page fault failed with status %d\n",
> > > > +			    status);
> > > > +
> > > > +	if (ctx->res)
> > > > +		mlx5_core_res_put(ctx->res);
> > > > +	kfree(pfault);
> > > > +	kfree(ctx);
> > > > +}
> > > > +
> > > >  static void mlx5_ib_page_fault_resume(struct mlx5_ib_dev *dev,
> > > > +				      struct mlx5_core_rsc_common *res,
> > > >  				      struct mlx5_pagefault *pfault,
> > > > -				      int error)
> > > > +				      int error,
> > > > +				      bool async)
> > > >  {
> > > > +	int ret = 0;
> > > > +	u32 *out = pfault->out_pf_resume;
> > > > +	u32 *in = pfault->in_pf_resume;
> > > > +	u32 token = pfault->token;
> > > >  	int wq_num = pfault->event_subtype == MLX5_PFAULT_SUBTYPE_WQE ?
> > > > -		     pfault->wqe.wq_num : pfault->token;
> > > > -	int ret = mlx5_core_page_fault_resume(dev->mdev,
> > > > -					      pfault->token,
> > > > -					      wq_num,
> > > > -					      pfault->type,
> > > > -					      error);
> > > > -	if (ret)
> > > > -		mlx5_ib_err(dev, "Failed to resolve the page fault on WQ 0x%x\n",
> > > > -			    wq_num);
> > > > +		pfault->wqe.wq_num : pfault->token;
> > > > +	u8 type = pfault->type;
> > > > +	struct pfault_resume_cb_ctx *ctx = NULL;
> > > > +
> > > > +	if (async)
> > > > +		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
> > >
> > > Why not allocate this ctx ast part of the mlx5_pagefault and avoid
> > > this allocation failure strategy?
> >
> > It is another way to implement it, both of them are correct.
>
> .. I think it is alot better to move this allocation, it gets rid of
> this ugly duplicated code
>
> > Can I assume that we can progress with patches except patch #2?
>
> Lets drop this one too..

Sure, thanks

>
> Jason

--sWvRP97dwRHm9fX+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb5v2NAAoJEORje4g2clinDjYP/1N+uF8rJ1oeZojK5QLZtwx/
3+dip6eeUA8So6rnPUlBUwlQj//7HiZwnbOw7voWWrs06k5ZvDjcrLfFbOc8+FjI
/yizgiH37Odc9v9m6GvBW2rZ8UnD4L+lXV97St/5uUa13nB5CNnZPfFwPbhvnG8C
A8C/ehi6iW7y0gW+bsA0VrzqG+uwCWhMfDYmcRiidUFq4mSGLreLJnHDOcXc1CXM
xbPW+kNSUAhoNJhHSZwWVIqGWY9pxMxmWZ3JHn5PuZKB/wA4/+TcFxqgOb/pmDNw
VYZZXSWwKn3BXDxNlp9oeEaJ34krn1WGCe3RMAHxA9DNE/lFjz6rI6bwv5XWm4s1
dhcyH1kbK1eJ3Wwpluyimk32IVwz6t2iuVk1GnyPGZg1asnhbIPgL0Mdc4cUB4VV
YEZ4i+Pj4rHhnS8RYC4o3dvzqDibhyAe5D7o4eSx/YjwklpBIWlD0glnF5cGRb6F
NtIUC31De2rgKD7tZrHoQo7LEUqmHBFwELrmr2vvKd91StxxkvhFz6aKi/+66VQ+
WCZuGuTH85qK1aZTA0Ydx0s4D9V+vzDWI8m1E4RKl+Zosvj7C1BaFUqUMde6CYPC
EhnnsLDMMydjrMsLutcnj4vGFq7Lg0lJM2ICCkAEELtpaKloIVIsU+WIMlO70gk3
qWlrRznEbCQaKCy1MAkV
=p8B3
-----END PGP SIGNATURE-----

--sWvRP97dwRHm9fX+--
