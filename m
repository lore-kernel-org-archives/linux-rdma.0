From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 for-next 2/7] IB/core: Add support for idr types
Date: Wed, 29 Mar 2017 09:10:28 -0600
Message-ID: <20170329151028.GD2586@obsidianresearch.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
 <1489939145-125246-3-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489939145-125246-3-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 19, 2017 at 05:59:00PM +0200, Matan Barak wrote:

> +static int uverbs_try_lock_object(struct ib_uobject *uobj, bool write)
> +{
> +	/*
> +	 * When a read is required, we use a positive counter. Each read
> +	 * request checks that the value != -1 and increment it. Write
> +	 * requires an exclusive access, thus we check that the counter is
> +	 * zero (nobody claimed this object) and we set it to -1.
> +	 * Releasing a read lock is done by simply decreasing the counter.
> +	 * As for writes, since only a single write is permitted, setting
> +	 * it to zero is enough for releasing it.
> +	 */
> +	if (!write)
> +		return __atomic_add_unless(&uobj->usecnt, 1, -1) == -1 ?
> +			-EBUSY : 0;
> +
> +	/* lock is either WRITE or DESTROY - should be exclusive */
> +	return atomic_cmpxchg(&uobj->usecnt, 0, -1) == 0 ? 0 : -EBUSY;

I wonder if a WARN_ON should be here, is it ever not an error to try
to write lock twice?

> +static struct ib_uobject *alloc_uobj(struct ib_ucontext *context,
> +				     const struct uverbs_obj_type *type)
> +{
> +	struct ib_uobject *uobj = kmalloc(type->obj_size, GFP_KERNEL);

Do you think this should be kzalloc?

> +/* Returns the ib_uobject or an error. The caller should check for IS_ERR. */
> +static struct ib_uobject *lookup_get_idr_uobject(const struct uverbs_obj_type *type,
> +						 struct ib_ucontext *ucontext,
> +						 int id, bool write)
> +{
> +	struct ib_uobject *uobj;
> +
> +	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
> +			 "ib_uverbs: lookup_get_idr_uobject is called without proper synchronization");
> +	/* object won't be released as we're protected in rcu */
> +	uobj = idr_find(&ucontext->ufile->idr, id);
> +	if (!uobj)
> +		return ERR_PTR(-ENOENT);
> +

A function called lookup_get should also do the get. I think this
would look iodmatically better like:

	rcu_read_lock();
	uobj = idr_find(&ucontext->ufile->idr, id);
	if (uobj)
		uverbs_uobject_get(uobj);
	rcu_read_unlock();

And drop the overlap from rdma_lookup_get_uobject

> +	if (uobj->type != type)
> +		return ERR_PTR(-EINVAL);
> +

This should probably be done in rdma_lookup_get_uobject?

> +/*
> + * Objects type classes which support a detach state (object is still alive but
> + * it's not attached to any context need to make sure:
> + * (a) If function pointers are used in any modules, module_get was called on
> + *     this module.
> + * (b) detach isn't called concurrently with context_cleanup
> + */

Little confused about this comment on module_get.. Our typical
strategy has been to forbid many kinds of cross-module calls during
detatchment. eg by setting function pointers to null. That is a robust
approach, I would not like to see more module_gets  ..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
