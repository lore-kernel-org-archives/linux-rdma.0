From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v2 13/17] RDMA/core: Get sum value of all
 counters when perform a sysfs stat read
Date: Wed, 29 May 2019 12:41:58 -0300
Message-ID: <20190529154158.GA8567@ziepe.ca>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-14-leon@kernel.org>
 <20190522171042.GA15023@ziepe.ca>
 <20190529111544.GV4633@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190529111544.GV4633@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 29, 2019 at 02:15:44PM +0300, Leon Romanovsky wrote:
> On Wed, May 22, 2019 at 02:10:42PM -0300, Jason Gunthorpe wrote:
> > On Mon, Apr 29, 2019 at 11:34:49AM +0300, Leon Romanovsky wrote:
> > > From: Mark Zhang <markz@mellanox.com>
> > >
> > > Since a QP can only be bound to one counter, then if it is bound to a
> > > separate counter, for backward compatibility purpose, the statistic
> > > value must be:
> > > * stat of default counter
> > > + stat of all running allocated counters
> > > + stat of all deallocated counters (history stats)
> > >
> > > Signed-off-by: Mark Zhang <markz@mellanox.com>
> > > Reviewed-by: Majd Dibbiny <majd@mellanox.com>
> > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > >  drivers/infiniband/core/counters.c | 99 +++++++++++++++++++++++++++++-
> > >  drivers/infiniband/core/device.c   |  8 ++-
> > >  drivers/infiniband/core/sysfs.c    | 10 ++-
> > >  include/rdma/rdma_counter.h        |  5 +-
> > >  4 files changed, 113 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
> > > index 36cd9eca1e46..f598b1cdb241 100644
> > > +++ b/drivers/infiniband/core/counters.c
> > > @@ -146,6 +146,20 @@ static int __rdma_counter_bind_qp(struct rdma_counter *counter,
> > >  	return ret;
> > >  }
> > >
> > > +static void counter_history_stat_update(const struct rdma_counter *counter)
> > > +{
> > > +	struct ib_device *dev = counter->device;
> > > +	struct rdma_port_counter *port_counter;
> > > +	int i;
> > > +
> > > +	port_counter = &dev->port_data[counter->port].port_counter;
> > > +	if (!port_counter->hstats)
> > > +		return;
> > > +
> > > +	for (i = 0; i < counter->stats->num_counters; i++)
> > > +		port_counter->hstats->value[i] += counter->stats->value[i];
> > > +}
> > > +
> > >  static int __rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
> > >  {
> > >  	struct rdma_counter *counter = qp->counter;
> > > @@ -285,8 +299,10 @@ int rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
> > >  		return ret;
> > >
> > >  	rdma_restrack_put(&counter->res);
> > > -	if (atomic_dec_and_test(&counter->usecnt))
> > > +	if (atomic_dec_and_test(&counter->usecnt)) {
> > > +		counter_history_stat_update(counter);
> > >  		rdma_counter_dealloc(counter);
> > > +	}
> > >
> > >  	return 0;
> > >  }
> > > @@ -307,21 +323,98 @@ int rdma_counter_query_stats(struct rdma_counter *counter)
> > >  	return ret;
> > >  }
> > >
> > > -void rdma_counter_init(struct ib_device *dev)
> > > +static u64 get_running_counters_hwstat_sum(struct ib_device *dev,
> > > +					   u8 port, u32 index)
> > > +{
> > > +	struct rdma_restrack_entry *res;
> > > +	struct rdma_restrack_root *rt;
> > > +	struct rdma_counter *counter;
> > > +	unsigned long id = 0;
> > > +	u64 sum = 0;
> > > +
> > > +	rt = &dev->res[RDMA_RESTRACK_COUNTER];
> > > +	xa_lock(&rt->xa);
> > > +	xa_for_each(&rt->xa, id, res) {
> > > +		if (!rdma_restrack_get(res))
> > > +			continue;
> >
> > Why do we need to get refcounts if we are holding the xa_lock?
> 
> Don't we need to protect an entry itself from disappearing?

xa_lock prevents xa_erase and xa_erase should be done before any
parallel kfree.

Jason
