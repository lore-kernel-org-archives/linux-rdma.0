From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/mlx4: prevent undefined shift in set_user_sq_size()
Date: Mon, 10 Jun 2019 17:08:58 +0300
Message-ID: <20190610140858.GA6369@mtr-leonro.mtl.com>
References: <20190608092231.GA28890@mwanda>
 <20190610132849.GD18468@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190610132849.GD18468@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 10, 2019 at 10:28:49AM -0300, Jason Gunthorpe wrote:
> On Sat, Jun 08, 2019 at 12:22:31PM +0300, Dan Carpenter wrote:
> > The ucmd->log_sq_bb_count is a u8 that comes from the user.  If it's
> > larger than the number of bits in an int then that's undefined behavior.
> > It turns out this doesn't really cause an issue at runtime but it's
> > still nice to clean it up.
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >  drivers/infiniband/hw/mlx4/qp.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> > index 5221c0794d1d..9f6eb23e8044 100644
> > --- a/drivers/infiniband/hw/mlx4/qp.c
> > +++ b/drivers/infiniband/hw/mlx4/qp.c
> > @@ -439,7 +439,8 @@ static int set_user_sq_size(struct mlx4_ib_dev *dev,
> >  			    struct mlx4_ib_create_qp *ucmd)
> >  {
> >  	/* Sanity check SQ size before proceeding */
> > -	if ((1 << ucmd->log_sq_bb_count) > dev->dev->caps.max_wqes	 ||
> > +	if (ucmd->log_sq_bb_count > 31					 ||
> > +	    (1 << ucmd->log_sq_bb_count) > dev->dev->caps.max_wqes	 ||
>
> Surely this should use check_shl_overflow() ?

Yes

>
> Jason
