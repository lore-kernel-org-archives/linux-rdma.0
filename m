From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 2/7] IB/core: Add support for custom types
Date: Wed, 11 Jan 2017 16:28:11 -0700
Message-ID: <20170111232811.GB31682@obsidianresearch.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
 <1484132033-3346-3-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484132033-3346-3-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 11, 2017 at 12:53:48PM +0200, Matan Barak wrote:

> +static struct ib_uobject *get_uobj_rcu(int id, struct ib_ucontext *context)
> +{
> +	struct ib_uobject *uobj;
> +
> +	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
> +			 "uverbs: get_uobj_rcu wasn't called in a rcu_read_lock()!");
> +	/* object won't be released as we're protected in rcu */
> +	uobj = idr_find(&context->device->idr, id);

So.. I think you need another patch in your series to rework the idr
globally to use rcu. Waiting till patch 7 seems too late

I'd particularly like to see this series without patch 5..

Reworking this to RCU seems like a good idea. Even better would be to
have per-fd locking domains ;)

> +	/*
> +	 * We start with allocating an idr pointing to NULL. This represents an
> +	 * object which isn't initialized yet. We'll replace it later on with
> +	 * the real object once we commit.
> +	 */
> +	ret = idr_alloc(&uobj->context->device->idr, NULL, 0, 0, GFP_NOWAIT);
> +	if (ret >= 0)
> +		uobj->id = ret;

And probably another patch to replace live with NULL.

These are both big changes, it would be better to see them with their
full context, not as stubs like this. Patch 7 has the code for this
but it is all intermingled with so much other stuff..

> +	/*
> +	 * When we destroy an object, we first just lock it for WRITE and
> +	 * actually DESTROY it in the finalize stage. So, the problematic
> +	 * scenario is when we just stared the finalize stage of the
> +	 * destruction (nothing was executed yet). Now, the other thread
> +	 * fetched the object for READ access, but it didn't lock it yet.
> +	 * The DESTROY thread continues and starts destroying the object.
> +	 * When the other thread continue - without the RCU, it would
> +	 * access freed memory. However, the rcu_read_lock delays the free
> +	 * until the rcu_read_lock of the READ operation quits. Since the
> +	 * write lock of the object is still taken by the DESTROY flow, the
> +	 * READ operation will get -EBUSY and it'll just bail out.
> +	 */
> +	kfree_rcu(uobj, rcu);

Zoiks. But yes, ok, it makes sense. Good comment.

> +/*
> + * Returns the ib_uobject, NULL if the requested object isn't found or an error.
> + * The caller should check for IS_ERR_OR_NULL.

Some people really hate IS_ERR_OR_NULL.. Why would the caller handle
NULL differently? Why not return -ENOENT?

> + */
> +static struct ib_uobject *get_uobject_from_context(struct ib_ucontext *ucontext,
> +						   const struct uverbs_type_alloc_action *type,
> +						   u32 idr,
> +						   enum uverbs_idr_access access)
> +{
> +	struct ib_uobject *uobj;
> +	int ret;
> +
> +	rcu_read_lock();
> +	uobj = get_uobj_rcu(idr, ucontext);

Is there a reason we have get_uobj_rcu() at all ? Just inline it.

> +	if (!uobj)
> +		goto free;
> +
> +	if (uobj->type != type) {
> +		uobj = NULL;

But this is an error, not no found.

> +static struct ib_uobject *uverbs_get_uobject_from_idr(const struct uverbs_type_alloc_action *type_alloc,
> +						      struct ib_ucontext *ucontext,
> +						      enum uverbs_idr_access access,
> +						      uint32_t idr)

u32 for the kernel please, check all patches

Why do we need to have three confusingly named functions to implement
one thing? Does it even make sense that add/get/destroy are all one
function?

I'm not sure it makes any sense to overload
uverbs_get_uobject_from_context for these two very different cases..
They don't even have the same type in the uapi (int vs u32)

I think you should just stick with uverbs_get_uobject_from_idr/_fd and
skip the common getter one..

> +{
> +	struct ib_uobject *uobj;
> +	int ret;
> +
> +	if (access == UVERBS_ACCESS_NEW) {
> +		uobj = kmalloc(type_alloc->obj_size, GFP_KERNEL);
> +		if (!uobj)
> +			return ERR_PTR(-ENOMEM);

Does this really make sense as an access enum and not just a different
function? This one one function is doing far too much I suspect.

Use function pointers:

 struct ub_uobject *obj = type_alloc->ops->allocate(type_alloc, ucontext);

> +static void uverbs_uobject_add(struct ib_uobject *uobject)
> +{
> +	mutex_lock(&uobject->context->uobjects_lock->lock);
> +	list_add(&uobject->list, &uobject->context->uobjects);
> +	mutex_unlock(&uobject->context->uobjects_lock->lock);
> +}
> +
> +static void uverbs_uobject_remove(struct ib_uobject *uobject)
> +{
> +	/*
> +	 * Calling remove requires exclusive access, so it's not possible
> +	 * another thread will use our object since the function is called
> +	 * with exclusive access.
> +	 */
> +	uverbs_idr_remove_uobj(uobject);
> +	mutex_lock(&uobject->context->uobjects_lock->lock);
> +	list_del(&uobject->list);
> +	mutex_unlock(&uobject->context->uobjects_lock->lock);
> +	put_uobj(uobject);

What does this put pair with? Usually a put like this would pair with
a get inside the _add function. So this deserves a comment at least.
If it is pairing with a get the caller performed then it should not be
here.

> +static void uverbs_finalize_idr(struct ib_uobject *uobj,
> +				enum uverbs_idr_access access,
> +				bool commit)
> +{
> +	switch (access) {
> +	case UVERBS_ACCESS_READ:
> +		up_read(&uobj->usecnt);
> +		break;
> +	case UVERBS_ACCESS_NEW:
> +		if (commit) {
> +			uverbs_uobject_add(uobj);
> +			spin_lock(&uobj->context->device->idr_lock);
> +			/*
> +			 * We already allocated this IDR with a NULL object, so
> +			 * this shouldn't fail.
> +			 */
> +			WARN_ON(idr_replace(&uobj->context->device->idr,
> +					    uobj, uobj->id));
> +			spin_unlock(&uobj->context->device->idr_lock);
> +		} else {
> +			uverbs_idr_remove_uobj(uobj);
> +			put_uobj(uobj);
> +		}
> +		break;
> +	case UVERBS_ACCESS_WRITE:
> +		up_write(&uobj->usecnt);
> +		break;
> +	case UVERBS_ACCESS_DESTROY:
> +		if (commit)
> +			uverbs_uobject_remove(uobj);
> +		else
> +			up_write(&uobj->usecnt);

Again wondering if ACCESS_DESTROY makes any sense..

> +		break;
> +	}
> +}
> +
> +void uverbs_finalize_object(struct ib_uobject *uobj,
> +			    enum uverbs_idr_access access,
> +			    bool commit)
> +{
> +	if (uobj->type->type == UVERBS_ATTR_TYPE_IDR)
> +		uverbs_finalize_idr(uobj, access, commit);
> +	else
> +		WARN_ON(true);

I think you should use ops like the rest of the kernel.

  uobj->ops->finalize(uobj,access,commit);

Get rid of these switch version.

> +
>  struct ib_ucontext {
>  	struct ib_device       *device;
>  	struct list_head	pd_list;
> @@ -1346,6 +1348,10 @@ struct ib_ucontext {
>  	struct list_head	rwq_ind_tbl_list;
>  	int			closing;
>  
> +	/* lock for uobjects list */
> +	struct ib_ucontext_lock	*uobjects_lock;

This is so weird. Why do we have a pointer to a struct mutex? This
serves absolutely no function at this point in the series, just inline
the mutex.

> +	struct list_head	uobjects;
> +
>  	struct pid             *tgid;
>  #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
>  	struct rb_root      umem_tree;
> @@ -1373,8 +1379,11 @@ struct ib_uobject {
>  	int			id;		/* index into kernel idr */

Shouldn't this be u32?

>  	struct kref		ref;
>  	struct rw_semaphore	mutex;		/* protects .live */
> +	struct rw_semaphore	usecnt;		/* protects exclusive access */

usecnt isn't really a cnt, better name?

> +	const struct uverbs_type_alloc_action *type;

[..]

> +struct uverbs_type_alloc_action;
> +typedef void (*free_type)(const struct uverbs_type_alloc_action *uobject_type,
> +			  struct ib_uobject *uobject);
> +
> +struct uverbs_type_alloc_action {
> +	enum uverbs_attr_type		type;
> +	int				order;
> +	size_t				obj_size;
> +	free_type			free_fn;
> +};

Just make a sensible meta-class struct like other parts of the kernel:

struct uverbs_obj_type {
   unsigned int destroy_order;
   size_t allocation_size;

   struct ib_uobject (*alloc)(..);
   void (*free)(..);
   void (*lookup)(..);
};

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
