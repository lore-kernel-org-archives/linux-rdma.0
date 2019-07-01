From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v4 06/17] RDMA/counter: Add "auto"
 configuration mode support
Date: Mon, 1 Jul 2019 11:42:13 +0300
Message-ID: <20190701084213.GJ4727@mtr-leonro.mtl.com>
References: <20190618172625.13432-1-leon@kernel.org>
 <20190618172625.13432-7-leon@kernel.org>
 <20190630004048.GB7173@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190630004048.GB7173@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 30, 2019 at 12:40:54AM +0000, Jason Gunthorpe wrote:
> On Tue, Jun 18, 2019 at 08:26:14PM +0300, Leon Romanovsky wrote:
>
> > +static void __rdma_counter_dealloc(struct rdma_counter *counter)
> > +{
> > +	mutex_lock(&counter->lock);
> > +	counter->device->ops.counter_dealloc(counter);
> > +	mutex_unlock(&counter->lock);
> > +}
>
> Does this lock do anything? The kref is 0 at this point, so no other
> thread can have a pointer to this lock.

Yes, it is leftover from atomic_read implementation.

>
> > +
> > +static void rdma_counter_dealloc(struct rdma_counter *counter)
> > +{
> > +	if (!counter)
> > +		return;
>
> Counter is never NULL.

Ohh, right, I'll clean some code near rdma_counter_dealloc/__rdma_counter_dealloc.

Thanks

>
> Jason
