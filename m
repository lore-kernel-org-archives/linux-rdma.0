From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 2/7] IB/core: Add support for custom types
Date: Tue, 17 Jan 2017 19:23:47 +0200
Message-ID: <CAAKD3BBkzoLuY3TF=bDK3U=rnLzK0uWmDL2tgsUwmBoGTXAqrw@mail.gmail.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
 <1484132033-3346-3-git-send-email-matanb@mellanox.com> <20170111232811.GB31682@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170111232811.GB31682-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 12, 2017 at 1:28 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Jan 11, 2017 at 12:53:48PM +0200, Matan Barak wrote:
>
>> +static struct ib_uobject *get_uobj_rcu(int id, struct ib_ucontext *context)
>> +{
>> +     struct ib_uobject *uobj;
>> +
>> +     RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
>> +                      "uverbs: get_uobj_rcu wasn't called in a rcu_read_lock()!");
>> +     /* object won't be released as we're protected in rcu */
>> +     uobj = idr_find(&context->device->idr, id);
>
> So.. I think you need another patch in your series to rework the idr
> globally to use rcu. Waiting till patch 7 seems too late
>

I'm not sure I followed here.
The idr mechanism uses RCU as of the current code for fetching ids.

> I'd particularly like to see this series without patch 5..
>

The major purpose of this series is to be a parliamentary step to the
ABI, which as you recall,
uses a macro based language to declare types. I can simplify it in
this series to directly initialize the
types, but that means the next series will modify these lines to the
macros language.

> Reworking this to RCU seems like a good idea. Even better would be to
> have per-fd locking domains ;)
>

What do you mean by "per-fd locking domains"?

>> +     /*
>> +      * We start with allocating an idr pointing to NULL. This represents an
>> +      * object which isn't initialized yet. We'll replace it later on with
>> +      * the real object once we commit.
>> +      */
>> +     ret = idr_alloc(&uobj->context->device->idr, NULL, 0, 0, GFP_NOWAIT);
>> +     if (ret >= 0)
>> +             uobj->id = ret;
>
> And probably another patch to replace live with NULL.
>

The whole implementation here is replaced, so if we have a patch that replaces
live with NULL in the current implementation and then later on in the
series we re-work
the API, we actually delete lines we've added at the same series.
Since we replace here the whole
idr/fd objects management, I think it's better to review the
locking/lifetime as an infrastructure
rather than bunch of changes in the usage of the current infrastructure.

> These are both big changes, it would be better to see them with their
> full context, not as stubs like this. Patch 7 has the code for this
> but it is all intermingled with so much other stuff..
>

Although putting an infrastructure and then using it in later patches
is common practice in
the kernel, I can look into embedding the required changes in the
infrastructure changes.
Saying that, testing that it's really bi-sectable could be a
nightmare, so I'm not really sure it's worth here.

>> +     /*
>> +      * When we destroy an object, we first just lock it for WRITE and
>> +      * actually DESTROY it in the finalize stage. So, the problematic
>> +      * scenario is when we just stared the finalize stage of the
>> +      * destruction (nothing was executed yet). Now, the other thread
>> +      * fetched the object for READ access, but it didn't lock it yet.
>> +      * The DESTROY thread continues and starts destroying the object.
>> +      * When the other thread continue - without the RCU, it would
>> +      * access freed memory. However, the rcu_read_lock delays the free
>> +      * until the rcu_read_lock of the READ operation quits. Since the
>> +      * write lock of the object is still taken by the DESTROY flow, the
>> +      * READ operation will get -EBUSY and it'll just bail out.
>> +      */
>> +     kfree_rcu(uobj, rcu);
>
> Zoiks. But yes, ok, it makes sense. Good comment.
>
>> +/*
>> + * Returns the ib_uobject, NULL if the requested object isn't found or an error.
>> + * The caller should check for IS_ERR_OR_NULL.
>
> Some people really hate IS_ERR_OR_NULL.. Why would the caller handle
> NULL differently? Why not return -ENOENT?
>

Ok

>> + */
>> +static struct ib_uobject *get_uobject_from_context(struct ib_ucontext *ucontext,
>> +                                                const struct uverbs_type_alloc_action *type,
>> +                                                u32 idr,
>> +                                                enum uverbs_idr_access access)
>> +{
>> +     struct ib_uobject *uobj;
>> +     int ret;
>> +
>> +     rcu_read_lock();
>> +     uobj = get_uobj_rcu(idr, ucontext);
>
> Is there a reason we have get_uobj_rcu() at all ? Just inline it.
>

It's later used for uverbs_is_live.

>> +     if (!uobj)
>> +             goto free;
>> +
>> +     if (uobj->type != type) {
>> +             uobj = NULL;
>
> But this is an error, not no found.
>

Ok, I'll fix.

>> +static struct ib_uobject *uverbs_get_uobject_from_idr(const struct uverbs_type_alloc_action *type_alloc,
>> +                                                   struct ib_ucontext *ucontext,
>> +                                                   enum uverbs_idr_access access,
>> +                                                   uint32_t idr)
>
> u32 for the kernel please, check all patches
>

Right, actually idr should be an int :)

> Why do we need to have three confusingly named functions to implement
> one thing? Does it even make sense that add/get/destroy are all one
> function?
>

It's a preliminary step for the next series which actually introduces the ABI.
If you recall, the metadata for each attribute contains how to access it.
I'll take a look into changing the enums and switch-cases to function
pointers and examine if it also fits the new model well enough.
Saying that, we only have two types (idr and fds) and we don't expect
to add much later

> I'm not sure it makes any sense to overload
> uverbs_get_uobject_from_context for these two very different cases..
> They don't even have the same type in the uapi (int vs u32)
>

I could split them to two different functions here. There are some
benefits of the current way.
You could of rdma_core as managing a big repository of objects of all
types and you could get
any object using the tuple (type,id). If we go to the function
pointers model, you'll probably just go to
type->lookup function.

> I think you should just stick with uverbs_get_uobject_from_idr/_fd and
> skip the common getter one..
>

Ok

>> +{
>> +     struct ib_uobject *uobj;
>> +     int ret;
>> +
>> +     if (access == UVERBS_ACCESS_NEW) {
>> +             uobj = kmalloc(type_alloc->obj_size, GFP_KERNEL);
>> +             if (!uobj)
>> +                     return ERR_PTR(-ENOMEM);
>
> Does this really make sense as an access enum and not just a different
> function? This one one function is doing far too much I suspect.
>
> Use function pointers:
>
>  struct ub_uobject *obj = type_alloc->ops->allocate(type_alloc, ucontext);
>

For the same reason as seen above - the goal here is to use ACCESS_ identifiers
in the DSL to specify how to use the object. Therefore, I think enum
makes sense.
If we transform this into function pointers, the new ABI (next series)
will probably use a wrapper
function to execute the correct function pointer.

>> +static void uverbs_uobject_add(struct ib_uobject *uobject)
>> +{
>> +     mutex_lock(&uobject->context->uobjects_lock->lock);
>> +     list_add(&uobject->list, &uobject->context->uobjects);
>> +     mutex_unlock(&uobject->context->uobjects_lock->lock);
>> +}
>> +
>> +static void uverbs_uobject_remove(struct ib_uobject *uobject)
>> +{
>> +     /*
>> +      * Calling remove requires exclusive access, so it's not possible
>> +      * another thread will use our object since the function is called
>> +      * with exclusive access.
>> +      */
>> +     uverbs_idr_remove_uobj(uobject);
>> +     mutex_lock(&uobject->context->uobjects_lock->lock);
>> +     list_del(&uobject->list);
>> +     mutex_unlock(&uobject->context->uobjects_lock->lock);
>> +     put_uobj(uobject);
>
> What does this put pair with? Usually a put like this would pair with
> a get inside the _add function. So this deserves a comment at least.
> If it is pairing with a get the caller performed then it should not be
> here.
>

They're a pair in a sense they're both used in the finalize stage of the IDR
object creation. Both object creation and object destruction are split
into two parts.
Object creation is mainly done in the "get" stage while object
destruction is mostly
done in the "finalize" stage.

>> +static void uverbs_finalize_idr(struct ib_uobject *uobj,
>> +                             enum uverbs_idr_access access,
>> +                             bool commit)
>> +{
>> +     switch (access) {
>> +     case UVERBS_ACCESS_READ:
>> +             up_read(&uobj->usecnt);
>> +             break;
>> +     case UVERBS_ACCESS_NEW:
>> +             if (commit) {
>> +                     uverbs_uobject_add(uobj);
>> +                     spin_lock(&uobj->context->device->idr_lock);
>> +                     /*
>> +                      * We already allocated this IDR with a NULL object, so
>> +                      * this shouldn't fail.
>> +                      */
>> +                     WARN_ON(idr_replace(&uobj->context->device->idr,
>> +                                         uobj, uobj->id));
>> +                     spin_unlock(&uobj->context->device->idr_lock);
>> +             } else {
>> +                     uverbs_idr_remove_uobj(uobj);
>> +                     put_uobj(uobj);
>> +             }
>> +             break;
>> +     case UVERBS_ACCESS_WRITE:
>> +             up_write(&uobj->usecnt);
>> +             break;
>> +     case UVERBS_ACCESS_DESTROY:
>> +             if (commit)
>> +                     uverbs_uobject_remove(uobj);
>> +             else
>> +                     up_write(&uobj->usecnt);
>
> Again wondering if ACCESS_DESTROY makes any sense..
>

Why? If you write a destroy_qp handler, it makes sense that the QP_HANDLE
will have ACCESS_DESTROY behavior.

>> +             break;
>> +     }
>> +}
>> +
>> +void uverbs_finalize_object(struct ib_uobject *uobj,
>> +                         enum uverbs_idr_access access,
>> +                         bool commit)
>> +{
>> +     if (uobj->type->type == UVERBS_ATTR_TYPE_IDR)
>> +             uverbs_finalize_idr(uobj, access, commit);
>> +     else
>> +             WARN_ON(true);
>
> I think you should use ops like the rest of the kernel.
>
>   uobj->ops->finalize(uobj,access,commit);
>
> Get rid of these switch version.
>

Maybe we could a type->finalize pointer and populate that
automatically in type creation.
I first want to see how the function pointers model ends up.

>> +
>>  struct ib_ucontext {
>>       struct ib_device       *device;
>>       struct list_head        pd_list;
>> @@ -1346,6 +1348,10 @@ struct ib_ucontext {
>>       struct list_head        rwq_ind_tbl_list;
>>       int                     closing;
>>
>> +     /* lock for uobjects list */
>> +     struct ib_ucontext_lock *uobjects_lock;
>
> This is so weird. Why do we have a pointer to a struct mutex? This
> serves absolutely no function at this point in the series, just inline
> the mutex.
>

It's used in the next patch as a kref-ed lock. The purpose here is
that a FD object could outlive its context.
However, since you suggest to allow keeping a dummy ucontext alive,
I'll just add a kref and inline the lock.

>> +     struct list_head        uobjects;
>> +
>>       struct pid             *tgid;
>>  #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
>>       struct rb_root      umem_tree;
>> @@ -1373,8 +1379,11 @@ struct ib_uobject {
>>       int                     id;             /* index into kernel idr */
>
> Shouldn't this be u32?
>

idr_alloc actually returns an int. Actually, we need to change all ids
to be int and allocate
an idr with S32_MAX as end.

>>       struct kref             ref;
>>       struct rw_semaphore     mutex;          /* protects .live */
>> +     struct rw_semaphore     usecnt;         /* protects exclusive access */
>
> usecnt isn't really a cnt, better name?
>

I could rename it to currently_used. What do you think?

>> +     const struct uverbs_type_alloc_action *type;
>
> [..]
>
>> +struct uverbs_type_alloc_action;
>> +typedef void (*free_type)(const struct uverbs_type_alloc_action *uobject_type,
>> +                       struct ib_uobject *uobject);
>> +
>> +struct uverbs_type_alloc_action {
>> +     enum uverbs_attr_type           type;
>> +     int                             order;
>> +     size_t                          obj_size;
>> +     free_type                       free_fn;
>> +};
>
> Just make a sensible meta-class struct like other parts of the kernel:
>
> struct uverbs_obj_type {
>    unsigned int destroy_order;
>    size_t allocation_size;
>
>    struct ib_uobject (*alloc)(..);
>    void (*free)(..);
>    void (*lookup)(..);
> };
>

We could use function pointers instead of enum. I'll start refactor
the code to use this approach.
If it turns out to make more sense, I'll use this in V2:

struct uverbs_obj_type_ops {
        /*
         * Get an ib_uobject that corresponds to the given id from ucontext,
         * These functions could create or destroy objects if required.
         * The action will be finalized only when commit or abort fops are
         * called.
         */
        struct ib_uobject *(*alloc_begin)(const struct uverbs_obj_type *type,
                                          struct ib_ucontext *ucontext);
        struct ib_uobject *(*lookup_get)(const struct uverbs_obj_type *type,
                                         struct ib_ucontext *ucontext, int id,
                                         bool write);
        void (*alloc_commit)(struct ib_uobject *uobj);
        void (*alloc_abort)(struct ib_uobject *uobj);
        void (*lookup_put)(struct ib_uobject *uobj, bool write);
        void (*destroy_commit)(struct ib_uobject *uobj);
        void (*hot_unplug)(struct ib_uobject *uobj);
};

struct uverbs_obj_type {
        const struct uverbs_obj_type_ops * const ops;
        unsigned int destroy_order;
};

struct uverbs_obj_idr_type {
        struct uverbs_obj_type  type;
        size_t                  obj_size;
        void (*hot_unplug)(struct ib_uobject *uobj);
};

struct uverbs_obj_fd_type {
        struct uverbs_obj_type  type;
        size_t                  obj_size;
        void (*hot_unplug)(struct ib_uobject *uobj);
        const struct file_operations    *fops;
        const char                      *name;
        int                             flags;
};

Probably ops will be the same for all IDR/FD types (use the same
pointer) and the custom behavior
should be embedded in uverbs_obj_idr_type/uverbs_obj_fd_type.

> Jason

Thanks for reviewing.

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
