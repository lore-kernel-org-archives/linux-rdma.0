From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Sun, 28 Jan 2018 14:03:50 -0700
Message-ID: <20180128210350.GJ23869@ziepe.ca>
References: <20180128091725.13103-1-leon@kernel.org>
 <20180128091725.13103-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180128091725.13103-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 28, 2018 at 11:17:20AM +0200, Leon Romanovsky wrote:
> +int __must_check rdma_restrack_get(struct rdma_restrack_entry *res)
> +{
> +	return kref_get_unless_zero(&res->kref);
> +}
> +EXPORT_SYMBOL(rdma_restrack_get);
> +
> +static void restrack_release(struct kref *kref)
> +{
> +	struct rdma_restrack_entry *res;
> +
> +	res = container_of(kref, struct rdma_restrack_entry, kref);
> +	complete(&res->comp);
> +}
> +
> +int rdma_restrack_put(struct rdma_restrack_entry *res)
> +{
> +	return kref_put(&res->kref, restrack_release);
> +}
> +EXPORT_SYMBOL(rdma_restrack_put);
> +
> +void rdma_restrack_del(struct rdma_restrack_entry *res)
> +{
> +	struct ib_device *dev;
> +
> +	if (!res->valid)
> +		return;
> +
> +	dev = res_to_dev(res);
> +	if (!dev)
> +		return;
> +
> +	down_read(&dev->res.rwsem);
> +	rdma_restrack_put(res);
> +	up_read(&dev->res.rwsem);

I can't see why this lock is necessary, the underlying kref is already
atomic.

This locking seems fine, can't see any problem with it.

But I still hate the readability of the kref-as-not-a-kref approach.

Now that you've written it out, it is clear this is actually open
coding a rw_semaphore??

I think lockdep will be okay with this due to the trylock?

It saves a bit of memory compared to a kref + completion, and has
better clarity:

static inline int __must_check rdma_restrack_get(struct rdma_restrack_entry *res)
{
	return down_read_trylock(&res->rwsem);
}

static inline int rdma_restrack_put(struct rdma_restrack_entry *res)
{
	return up_read(&res->rwsem);
}

void rdma_restrack_del(struct rdma_restrack_entry *res)
{
        down_write(res->rwsem);
	down_write(&dev->res.rwsem);
	hash_del(&res->node);
        [..]
}

No change to the read side.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
