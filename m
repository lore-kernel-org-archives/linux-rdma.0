From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 2/7] IB/core: Add support for idr types
Date: Fri, 10 Feb 2017 12:56:04 -0700
Message-ID: <20170210195604.GB4335@obsidianresearch.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
 <1485952745-58476-3-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485952745-58476-3-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 01, 2017 at 02:39:00PM +0200, Matan Barak wrote:

> +static int uverbs_lock_object(struct ib_uobject *uobj, bool write)
> +{
> +	if (!write)
> +		return down_read_trylock(&uobj->currently_used) == 1 ? 0 :
> +			-EBUSY;
> +
> +	/* lock is either WRITE or DESTROY - should be exclusive */
> +	return down_write_trylock(&uobj->currently_used) == 1 ? 0 : -EBUSY;

Is currently_used ever used as an actual blocking rwsem? Looks like
no to me right now, is that the long term plan?

It actually seems to be important that this not be blocking, so it
might be better to code this a simple atomic.

And lets call it uverbs_try_lock_object() for clarity.

> +static void uverbs_uobject_put_ref(struct kref *ref)
> +{
> +	struct ib_uobject *uobj =
> +		container_of(ref, struct ib_uobject, ref);
> +
> +	uobj->type->ops->release(uobj);
> +}

This sort of approach starts to become very dangerous when you
contemplate having 'release' be a function in a module. Is that the
case?

But, broadly speaking, I expect to see kfree() in a release function,
and from what I can tell the only issue here is that the IDR sometimes
needs kfree_rcu.

So lets drop the function pointer and just add a 1 bit flag:

if (uobj->needs_rcu)
   kfree_rcu(uobj);
else
   kfree(uobj);

This is more clear, don't overdesign things at this point because it
becomes hard to see if down the road things are done wrong (eg putting
release in a different module)

> +static void init_uobj(struct ib_uobject *uobj, struct ib_ucontext *context,
> +		      const struct uverbs_obj_type *type)
> +{
> +	/*
> +	 * user_handle should be filled by the handler,
> +	 * The object is added to the list in the commit stage.
> +	 */
> +	init_rwsem(&uobj->currently_used);
> +	uobj->context     = context;
> +	uobj->type	  = type;

.. and can you please not add the bogus whitespace in new commits
please? That is really not the typical kernel style and makes
everything hard to maintain and read.

> +	kref_init(&uobj->ref);
> +}

Lets call this alloc_uobj, and just use kzalloc(type->obj_size) to do
it.

Due to the kref and the above comment about release it is not a good
idea to have a type specific allocation, we always want kalloc'd
memory here.

> +static void uverbs_idr_remove_uobj(struct ib_uobject *uobj)
> +{
> +	spin_lock(&uobj->context->ufile->idr_lock);
> +	idr_remove(&uobj->context->ufile->idr, uobj->id);
> +	spin_unlock(&uobj->context->ufile->idr_lock);
> +}

Add a clarifying comment

/* The caller must uverbs_uobject_put() uobj */

> +	rcu_read_lock();
> +	/* object won't be released as we're protected in rcu */
> +	uobj = idr_find(&ucontext->ufile->idr, id);

> +	if (!uobj) {
> +		uobj = ERR_PTR(-ENOENT);
> +		goto free;
> +	}
> +
> +	if (uobj->type != type) {
> +		uobj = ERR_PTR(-EINVAL);
> +		goto free;
> +	}
> +
> +	ret = uverbs_lock_object(uobj, write);

Hum. This RCU is a bit exciting.. So this relies on the write lock
being held whenever uverbs_idr_remove is called. Can you add a
LOCKDEP style of of assertion to uverbs_idr_remove to prove that?

> +static struct ib_uobject *alloc_begin_idr_uobject(const struct uverbs_obj_type *type,
> +						  struct ib_ucontext *ucontext)
> +{
> +	int ret;
> +	const struct uverbs_obj_idr_type *idr_type =
> +		container_of(type, struct uverbs_obj_idr_type, type);
> +	struct ib_uobject *uobj = kmalloc(idr_type->obj_size, GFP_KERNEL);

> +
> +	if (!uobj)
> +		return ERR_PTR(-ENOMEM);

This would be the thing to move to alloc_uobj. Ditto for fd.

> +	init_uobj(uobj, ucontext, type);
> +	ret = idr_add_uobj(uobj);
> +	if (ret) {
> +		kfree(uobj);

This should be a uverbs_uobject_put()

> +static void uverbs_uobject_add(struct ib_uobject *uobject)
> +{
> +	mutex_lock(&uobject->context->lock);
> +	list_add(&uobject->list, &uobject->context->uobjects);
> +	mutex_unlock(&uobject->context->lock);
> +}

I'd open code this into alloc_commit_idr_uobject. The only place the
list should be updated is directly after it has been placed in the
IDR, it is confusing to see it in a function as though it can be
called from someplace else

> +static void _put_uobj_ref(struct kref *ref)
> +{
> +	kfree(container_of(ref, struct ib_uobject, ref));
> +}
> +
> +static void alloc_abort_idr_uobject(struct ib_uobject *uobj)
> +{
> +	uverbs_idr_remove_uobj(uobj);
> +	/*
> +	 * we don't need kfree_rcu here, as the uobject wasn't exposed to any
> +	 * other verb.
> +	 */
> +	kref_put(&uobj->ref, _put_uobj_ref);
> +}

Once needs_rcu is added then this ugly stuff goes away. Set needs_rcu
only when the uboject has been added to the IDR.

> +static void destroy_commit_idr_uobject(struct ib_uobject *uobj)

This is a confusing name.. See below..

> +{
> +	uverbs_idr_remove_uobj(uobj);
> +	mutex_lock(&uobj->context->lock);
> +	list_del(&uobj->list);
> +	mutex_unlock(&uobj->context->lock);
> +	uverbs_uobject_put(uobj);
> +}

And this flow is weird, hot_unplug calls an idr_type op, but this does
not? Why?

> +void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed)
> +{
> +	unsigned int cur_order = 0;
> +
> +	while (!list_empty(&ucontext->uobjects)) {
> +		struct ib_uobject *obj, *next_obj;
> +		unsigned int next_order = UINT_MAX;
> +
> +		/*
> +		 * This shouldn't run while executing other commands on this
> +		 * context, thus no lock is required.
> +		 */
> +		list_for_each_entry_safe(obj, next_obj, &ucontext->uobjects,
> +					 list)
> +			if (obj->type->destroy_order == cur_order) {
> +				list_del(&obj->list);
> +				obj->type->ops->hot_unplug(obj, device_removed);

Let's add a safety:

   WARN_ON(uverbs_lock_object(obj, true));

It would be really nice to see a simpler 'built-in' scheme to
guarentee that WARN_ON never hits. I expect this is relying on the
external SRCU system to make it work out..

For instance since we now have lookup_get/lookup_put could we
ultimately move the SRCU into those functions?

Also, the call to hot_unplug has to be checked

> +	/* locking the uobjects_list */
> +	struct mutex		lock;

Prefer uobjects_lock for clarity

> @@ -1374,8 +1378,11 @@ struct ib_uobject {
>  	int			id;		/* index into kernel idr */

> +
> +struct uverbs_obj_type_ops {
> +	/*
> +	 * Get an ib_uobject that corresponds to the given id from ucontext,
> +	 * These functions could create or destroy objects if required.
> +	 * The action will be finalized only when commit, abort or put fops are
> +	 * called.
> +	 * The flow of the different actions is:
> +	 * [alloc]:	 Starts with alloc_begin. The handlers logic is than
> +	 *		 executed. If the handler is successful, alloc_commit
> +	 *		 is called and the object is inserted to the repository.
> +	 *		 Otherwise, alloc_abort is called and the object is
> +	 *		 destroyed.

Add:

 Once alloc_commit completes the object is visible to other threads
 and userspace.

> +	 * [lookup]:	 Starts with lookup_get which fetches and locks the
> +	 *		 object. After the handler finished using the object, it
> +	 *		 needs to call lookup_put to unlock it. The write flag
> +	 *		 indicates if the object is locked for exclusive access.
> +	 * [destroy]:	 Starts with lookup_get with write flag set. This locks
> +	 *		 the object for exclusive access. If the handler code
> +	 *		 completed successfully, destroy_commit is called and
> +	 *		 the ib_uobject is removed from the context's uobjects
> +	 *		 repository and put. Otherwise, lookup_put should be
> +	 *		 called.

Lets call this 'remove' please.

And add:

 Once remove succeeds new krefs to the object cannot be acquired by
 other threads or userspace and the hardware driver is removed from
 the object. Other krefs on the object may still exist.

> +	 * [hot_unplug]: Used when the context is destroyed (process
> +	 *		 termination, reset flow).

I don't think we need a dedicated entry point. I think you should add
an enum argument to remove:

enum rdma_remove_reason {
 RDMA_REMOVE_DESTROY, // Userspace requested uobject deletion
 RDMA_REMOVE_CLOSE,   // Context deletion. Call cannot fail.
 RDMA_REMOVE_DRIVER_REMOVE, // Driver is being hot-unplugged. Call cannot fail.
};

This gives the drivers a more information to the right thing to do.

> +	 * [release]:    Releases the memory of the ib_uobject. This is called
> +	 *		 when the last reference is put. We favored a callback
> +	 *		 here as this might require tricks like kfree_rcu.
> +	 *		 This shouldn't be called explicitly by the user as it's
> +	 *		 used by uverbs_uobject_put.

Delete as discussed


> +	void (*destroy_commit)(struct ib_uobject *uobj);

Use:
   /* Must be called with the write lock held. If successful uboj is
      invalid on return. On failure uobject is left completely unchanged */
   int __must_check (*remove)(struct ib_uobject *uobj,enum rdma_remove_reason why);

> +struct uverbs_obj_idr_type {
> +	/*
> +	 * In idr based objects, uverbs_obj_type_ops points to a generic
> +	 * idr operations. In order to specialize the underlying types (e.g. CQ,
> +	 * QPs, etc.), we add obj_size and hot_unplug specific callbacks here.
> +	 */
> +	struct uverbs_obj_type  type;
> +	size_t			obj_size;

Move to type, do not support no kalloc configurations

> +	/* The hot_unplug in ops initialized by idr, calls this callback */
> +	void (*hot_unplug)(struct ib_uobject *uobj);

Use:

/* Free driver resources from the uobject, make the driver uncallable,
   and move the uobject to the detached state. On failure the uboject
   is left completely unchanged. */
int __must_check (*destroy)(struct ib_uobject *uobj,enum rdma_remove_reason why);

And probably add some commentary what objects support a detached
state. Any object that cannot be detached can only exist in the IDR
and cannot have a kref taken. Perhaps we should enforce that directly
for clarity.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
