From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 2/7] IB/core: Add support for custom types
Date: Tue, 17 Jan 2017 12:01:17 -0700
Message-ID: <20170117190117.GB27528@obsidianresearch.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
 <1484132033-3346-3-git-send-email-matanb@mellanox.com>
 <20170111232811.GB31682@obsidianresearch.com>
 <CAAKD3BBkzoLuY3TF=bDK3U=rnLzK0uWmDL2tgsUwmBoGTXAqrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BBkzoLuY3TF=bDK3U=rnLzK0uWmDL2tgsUwmBoGTXAqrw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 17, 2017 at 07:23:47PM +0200, Matan Barak wrote:
> On Thu, Jan 12, 2017 at 1:28 AM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Wed, Jan 11, 2017 at 12:53:48PM +0200, Matan Barak wrote:
> >
> >> +static struct ib_uobject *get_uobj_rcu(int id, struct ib_ucontext *context)
> >> +{
> >> +     struct ib_uobject *uobj;
> >> +
> >> +     RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
> >> +                      "uverbs: get_uobj_rcu wasn't called in a rcu_read_lock()!");
> >> +     /* object won't be released as we're protected in rcu */
> >> +     uobj = idr_find(&context->device->idr, id);
> >
> > So.. I think you need another patch in your series to rework the idr
> > globally to use rcu. Waiting till patch 7 seems too late
> 
> I'm not sure I followed here.
> The idr mechanism uses RCU as of the current code for fetching ids.

Hmm, Not sure what I was thinking, but yes.. this is the same as
__idr_get_uobj, so why does it exist?

> The major purpose of this series is to be a parliamentary step to
> the ABI, which as you recall, uses a macro based language to declare
> types.

Yes, but that seem controversial, let us get this part done without
that.
 
> What do you mean by "per-fd locking domains"?

Put the IDR into the ucontext and a per-ucontext rcu + spinlock for it..

> > And probably another patch to replace live with NULL.
> 
> The whole implementation here is replaced, so if we have a patch
> that replaces live with NULL in the current implementation and then
> later on in the series we re-work the API, we actually delete lines
> we've added at the same series.

The kernel philsophy is to try an avoid these 'flag day' kinds of
approaches. You are adding new code that does not work with the old
code which makes it incredibly hard to review, and then just swithing
everything over.

At the same time many fundamental designs are being altered.

You might have a point if the two approaches could exist
concurrently, but that is not the case in these patches.

> Saying that, testing that it's really bi-sectable could be a
> nightmare, so I'm not really sure it's worth here.


> >> +     /*
> >> +      * When we destroy an object, we first just lock it for WRITE and
> >> +      * actually DESTROY it in the finalize stage. So, the problematic
> >> +      * scenario is when we just stared the finalize stage of the
> >> +      * destruction (nothing was executed yet). Now, the other thread
> >> +      * fetched the object for READ access, but it didn't lock it yet.
> >> +      * The DESTROY thread continues and starts destroying the object.
> >> +      * When the other thread continue - without the RCU, it would
> >> +      * access freed memory. However, the rcu_read_lock delays the free
> >> +      * until the rcu_read_lock of the READ operation quits. Since the
> >> +      * write lock of the object is still taken by the DESTROY flow, the
> >> +      * READ operation will get -EBUSY and it'll just bail out.
> >> +      */
> >> +     kfree_rcu(uobj, rcu);
> >
> > Zoiks. But yes, ok, it makes sense. Good comment.

Actually, why is this replacing release_uobj? Why is it now
called put_uobj? Why is something that doesn't use a kref called put?
Why is a kfree being called outside a kref release function?

Seems wrong...

> > Is there a reason we have get_uobj_rcu() at all ? Just inline it.
> 
> It's later used for uverbs_is_live.

Huh. That bit of code in ib_uverbs_qp_event_handler seems super
sketchy. Looks like the qp there comes from the open_list? Seems to me
that the open_list needs to be cleaned up before the object is removed
from the idr, eliminating the need for the uverbs_is_live at all.

> >> +                                                   struct ib_ucontext *ucontext,
> >> +                                                   enum uverbs_idr_access access,
> >> +                                                   uint32_t idr)
> >
> > u32 for the kernel please, check all patches
> 
> Right, actually idr should be an int :)

Our UAPI is u32 for sane 64/32 bit compat, the IDR has to be limited
to min(U32_MAX-1,INT_MAX). (may as well reserve U32_MAX for error)

> It's a preliminary step for the next series which actually introduces the ABI.
> If you recall, the metadata for each attribute contains how to access it.
> I'll take a look into changing the enums and switch-cases to function
> pointers and examine if it also fits the new model well enough.
> Saying that, we only have two types (idr and fds) and we don't expect
> to add much later

But this makes no sense here, handle the switch from the enum in the
code that works with those future macro structures.

> I could split them to two different functions here. There are some
> benefits of the current way.  You could of rdma_core as managing a
> big repository of objects of all types and you could get any object
> using the tuple (type,id). If we go to the function pointers model,
> you'll probably just go to type->lookup function.

The different types seem to have significant differences (eg with
locking) so I'm not sure that single model even makes sense.

> in the DSL to specify how to use the object. Therefore, I think enum
> makes sense.  If we transform this into function pointers, the new
> ABI (next series) will probably use a wrapper function to execute
> the correct function pointer.

Seems OK to me

> >> +static void uverbs_uobject_add(struct ib_uobject *uobject)
> >> +{
> >> +     mutex_lock(&uobject->context->uobjects_lock->lock);
> >> +     list_add(&uobject->list, &uobject->context->uobjects);
> >> +     mutex_unlock(&uobject->context->uobjects_lock->lock);
> >> +}
> >> +
> >> +static void uverbs_uobject_remove(struct ib_uobject *uobject)
> >> +{
> >> +     /*
> >> +      * Calling remove requires exclusive access, so it's not possible
> >> +      * another thread will use our object since the function is called
> >> +      * with exclusive access.
> >> +      */
> >> +     uverbs_idr_remove_uobj(uobject);
> >> +     mutex_lock(&uobject->context->uobjects_lock->lock);
> >> +     list_del(&uobject->list);
> >> +     mutex_unlock(&uobject->context->uobjects_lock->lock);
> >> +     put_uobj(uobject);
> >
> > What does this put pair with? Usually a put like this would pair with
> > a get inside the _add function. So this deserves a comment at least.
> > If it is pairing with a get the caller performed then it should not be
> > here.
> 
> They're a pair in a sense they're both used in the finalize stage of
> the IDR object creation. Both object creation and object destruction
> are split into two parts.  Object creation is mainly done in the
> "get" stage while object destruction is mostly done in the
> "finalize" stage.

I think this goes back to my earlier comment about put_uobj not making
much sense - for something named put there needs to be a paired get
and that get isn't clear.

> Why? If you write a destroy_qp handler, it makes sense that the QP_HANDLE
> will have ACCESS_DESTROY behavior.

Sure but it really isn't much of an ACCESS ..

> >>  #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> >>       struct rb_root      umem_tree;
> >> @@ -1373,8 +1379,11 @@ struct ib_uobject {
> >>       int                     id;             /* index into kernel idr */
> >
> > Shouldn't this be u32?
> 
> idr_alloc actually returns an int. Actually, we need to change all ids
> to be int and allocate
> an idr with S32_MAX as end.

The uapi is u32, see above...

> >>       struct kref             ref;
> >>       struct rw_semaphore     mutex;          /* protects .live */
> >> +     struct rw_semaphore     usecnt;         /* protects exclusive access */
> >
> > usecnt isn't really a cnt, better name?
> 
> I could rename it to currently_used. What do you think?

Maybe call it destroy_lock? reading_lock?

> We could use function pointers instead of enum. I'll start refactor
> the code to use this approach.
> If it turns out to make more sense, I'll use this in V2:
> 
> struct uverbs_obj_type_ops {
>         /*
>          * Get an ib_uobject that corresponds to the given id from ucontext,
>          * These functions could create or destroy objects if required.
>          * The action will be finalized only when commit or abort fops are
>          * called.
>          */
>         struct ib_uobject *(*alloc_begin)(const struct uverbs_obj_type *type,
>                                           struct ib_ucontext *ucontext);
>         struct ib_uobject *(*lookup_get)(const struct uverbs_obj_type *type,
>                                          struct ib_ucontext *ucontext, int id,
>                                          bool write);
>         void (*alloc_commit)(struct ib_uobject *uobj);
>         void (*alloc_abort)(struct ib_uobject *uobj);
>         void (*lookup_put)(struct ib_uobject *uobj, bool write);
>         void (*destroy_commit)(struct ib_uobject *uobj);
>         void (*hot_unplug)(struct ib_uobject *uobj);
> };
> 
> struct uverbs_obj_type {
>         const struct uverbs_obj_type_ops * const ops;
>         unsigned int destroy_order;
> };
> 
> struct uverbs_obj_idr_type {
>         struct uverbs_obj_type  type;
>         size_t                  obj_size;
>         void (*hot_unplug)(struct ib_uobject *uobj);
> };
>
> struct uverbs_obj_fd_type {
>         struct uverbs_obj_type  type;
>         size_t                  obj_size;
>         void (*hot_unplug)(struct ib_uobject *uobj);
>         const struct file_operations    *fops;
>         const char                      *name;
>         int                             flags;
> };

I'd probably just use a union or unused struct members, so much
simpler than all these structs. Like you say we probably only have two
kinds, no reason to be fancy.

> Probably ops will be the same for all IDR/FD types (use the same
> pointer)

Then why have it?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
