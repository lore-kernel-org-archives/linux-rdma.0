From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDS: IB: NULL dereference on error in rds_ib_alloc_frmr()
Date: Wed, 14 Jun 2017 16:03:40 +0300
Message-ID: <20170614130340.ge7dfgttnk4lgnmx@mwanda>
References: <20170614103924.GK29394@elgon.mountain>
 <20170614125423.GA3329@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170614125423.GA3329@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Avinash Repaka <avinash.repaka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 14, 2017 at 03:54:24PM +0300, Yuval Shaia wrote:
> On Wed, Jun 14, 2017 at 01:39:24PM +0300, Dan Carpenter wrote:
> > We accidentally return ERR_PTR(0) if ib_alloc_mr() fails.  The caller
> > is expecting error pointers so it results in a NULL dereference.
> > 
> > Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registration mode")
> > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > 
> > diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
> > index 48332a6ed738..74a66cc162ed 100644
> > --- a/net/rds/ib_frmr.c
> > +++ b/net/rds/ib_frmr.c
> > @@ -38,7 +38,7 @@ static struct rds_ib_mr *rds_ib_alloc_frmr(struct rds_ib_device *rds_ibdev,
> >  	struct rds_ib_mr_pool *pool;
> >  	struct rds_ib_mr *ibmr = NULL;
> >  	struct rds_ib_frmr *frmr;
> > -	int err = 0;
> > +	int err;
> 
> Can we trust it'll be zero?

We don't ever want it to be zero.  This way, hopefully, GCC will catch
it if we introduce any new bugs where we forget to set it to negative.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
