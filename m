From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next 08/10] IB/mlx5: Call PAGE_FAULT_RESUME command
 asynchronously
Date: Fri, 9 Nov 2018 18:26:22 +0200
Message-ID: <20181109162622.GX3695@mtr-leonro.mtl.com>
References: <20181108191017.21891-1-leon@kernel.org>
 <20181108191017.21891-9-leon@kernel.org>
 <20181108194857.GF5548@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Qo8f1a4rgWw9S/zY"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181108194857.GF5548@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--Qo8f1a4rgWw9S/zY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 08, 2018 at 07:49:03PM +0000, Jason Gunthorpe wrote:
> On Thu, Nov 08, 2018 at 09:10:15PM +0200, Leon Romanovsky wrote:
> > From: Moni Shoua <monis@mellanox.com>
> >
> > Telling the HCA that page fault handling is done and QP can resume
> > its flow is done in the context of the page fault handler. This blocks
> > the handling of the next work in queue without a need.
> > Call the PAGE_FAULT_RESUME command in an asynchronous manner and free
> > the workqueue to pick the next work item for handling. All tasks that
> > were executed after PAGE_FAULT_RESUME need to be done now
> > in the callback of the asynchronous command mechanism.
> >
> > Signed-off-by: Moni Shoua <monis@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >  drivers/infiniband/hw/mlx5/odp.c | 110 +++++++++++++++++++++++++------
> >  include/linux/mlx5/driver.h      |   3 +
> >  2 files changed, 94 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
> > index abce55b8b9ba..0c4f469cdd5b 100644
> > +++ b/drivers/infiniband/hw/mlx5/odp.c
> > @@ -298,20 +298,78 @@ void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
> >  	return;
> >  }
> >
> > +struct pfault_resume_cb_ctx {
> > +	struct mlx5_ib_dev *dev;
> > +	struct mlx5_core_rsc_common *res;
> > +	struct mlx5_pagefault *pfault;
> > +};
> > +
> > +static void page_fault_resume_callback(int status, void *context)
> > +{
> > +	struct pfault_resume_cb_ctx *ctx = context;
> > +	struct mlx5_pagefault *pfault = ctx->pfault;
> > +
> > +	if (status)
> > +		mlx5_ib_err(ctx->dev, "Resolve the page fault failed with status %d\n",
> > +			    status);
> > +
> > +	if (ctx->res)
> > +		mlx5_core_res_put(ctx->res);
> > +	kfree(pfault);
> > +	kfree(ctx);
> > +}
> > +
> >  static void mlx5_ib_page_fault_resume(struct mlx5_ib_dev *dev,
> > +				      struct mlx5_core_rsc_common *res,
> >  				      struct mlx5_pagefault *pfault,
> > -				      int error)
> > +				      int error,
> > +				      bool async)
> >  {
> > +	int ret = 0;
> > +	u32 *out = pfault->out_pf_resume;
> > +	u32 *in = pfault->in_pf_resume;
> > +	u32 token = pfault->token;
> >  	int wq_num = pfault->event_subtype == MLX5_PFAULT_SUBTYPE_WQE ?
> > -		     pfault->wqe.wq_num : pfault->token;
> > -	int ret = mlx5_core_page_fault_resume(dev->mdev,
> > -					      pfault->token,
> > -					      wq_num,
> > -					      pfault->type,
> > -					      error);
> > -	if (ret)
> > -		mlx5_ib_err(dev, "Failed to resolve the page fault on WQ 0x%x\n",
> > -			    wq_num);
> > +		pfault->wqe.wq_num : pfault->token;
> > +	u8 type = pfault->type;
> > +	struct pfault_resume_cb_ctx *ctx = NULL;
> > +
> > +	if (async)
> > +		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
>
> Why not allocate this ctx ast part of the mlx5_pagefault and avoid
> this allocation failure strategy?

It is another way to implement it, both of them are correct.

Can I assume that we can progress with patches except patch #2?

Thanks

>
> Jason

--Qo8f1a4rgWw9S/zY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb5bUuAAoJEORje4g2clinenwQANKU3oCzBdXfn0+Qa3cu4HE5
Q1JYwg13wpN9G/v6HTlHdXj2nnb52TLbjRTqpuPfpMbgHECxvvhRIfKE7fFWPdml
zCKF2hJa1rM1T6bpDH8fOiHLFpEmqbzg6tP57kXGMR7H5nAePOliNbEMkXddnyje
X8tRUCszgVeef7j8qTyDZwIhleQ1eeOUjSLpXYRurBvJHoJ67euGaQ1OgDCJjsvF
y7HKCQW4Quiqnm4kQr8D0eQ11qbJ6JN9LXHtlagzAurXTqCFis8tfV8gPnw1YiQ8
NUQIZ5pG97z/rmdW0XEJnhHBauM/lN1hN0xAPkIqvlwc6waJmUnd/MET5yjFE6ir
ijg8cqAER/ClHkg9zxtgfzmj0c4JDHZG0GMI8lTmZBx+pautheZxf7CcQpDnytX/
10qTE5pYwf+/fhlfBx4shZdjHDRr01EF62+oJUDm/1AGg5i3RIyIxNt/rsjoZ9fT
+zUtSLmv/i78TfJxpfPpK9LvMTwjkykibCqp97/Vtr7Sue/Y3x7JIaO8FV365O3B
AOPzgFV6yvS5KRWsv32f4xJrkTIPZEOauj3SdipkpjwQ+YQA6vb+DbQqUloX77Uv
rpOosNbAgjJ0x3445vQmb3jn8JVxGCcV5DEs2oUrJ872yU6//M5ZuLTt9iacsO9s
bdWwrV+mmIPvIthn4s9E
=nL6H
-----END PGP SIGNATURE-----

--Qo8f1a4rgWw9S/zY--
