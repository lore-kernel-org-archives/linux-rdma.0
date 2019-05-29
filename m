From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v2 11/17] RDMA/netlink: Implement counter
 dumpit calback
Date: Wed, 29 May 2019 14:31:07 +0300
Message-ID: <20190529113107.GX4633@mtr-leonro.mtl.com>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-12-leon@kernel.org>
 <20190522172137.GD15023@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190522172137.GD15023@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 22, 2019 at 02:21:37PM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 29, 2019 at 11:34:47AM +0300, Leon Romanovsky wrote:
> > From: Mark Zhang <markz@mellanox.com>
> >
> > This patch adds the ability to return all available counters
> > together with their properties and hwstats.
> >
> > Signed-off-by: Mark Zhang <markz@mellanox.com>
> > Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >  drivers/infiniband/core/counters.c |  28 +++++
> >  drivers/infiniband/core/device.c   |   2 +
> >  drivers/infiniband/core/nldev.c    | 173 +++++++++++++++++++++++++++++
> >  include/rdma/ib_verbs.h            |  10 ++
> >  include/rdma/rdma_counter.h        |   3 +
> >  include/uapi/rdma/rdma_netlink.h   |  10 +-
> >  6 files changed, 225 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
> > index 665e0d43c21b..36cd9eca1e46 100644
> > +++ b/drivers/infiniband/core/counters.c
> > @@ -62,6 +62,9 @@ static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,
> >  {
> >  	struct rdma_counter *counter;
> >
> > +	if (!dev->ops.counter_alloc_stats)
> > +		return NULL;
> > +
>
> Seems weird to add this now, why was it Ok to have counters prior to
> this patch?

Prior to this patch, "sysfs" counters and "netlink" counters were
independent from user perspective.

Thanks

>
> Jason
