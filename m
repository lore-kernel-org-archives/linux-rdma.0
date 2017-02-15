From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 2/7] IB/core: Add support for idr types
Date: Wed, 15 Feb 2017 11:06:46 -0700
Message-ID: <20170215180646.GB19162@obsidianresearch.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
 <1485952745-58476-3-git-send-email-matanb@mellanox.com>
 <20170210195604.GB4335@obsidianresearch.com>
 <CAAKD3BBFiayiM_=7bo2y52hL=7uMDk8nsz+7jY_+qoPdo05P9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BBFiayiM_=7bo2y52hL=7uMDk8nsz+7jY_+qoPdo05P9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 15, 2017 at 03:43:31PM +0200, Matan Barak wrote:
> On Fri, Feb 10, 2017 at 9:56 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Wed, Feb 01, 2017 at 02:39:00PM +0200, Matan Barak wrote:
> >
> >> +static int uverbs_lock_object(struct ib_uobject *uobj, bool write)
> >> +{
> >> +     if (!write)
> >> +             return down_read_trylock(&uobj->currently_used) == 1 ? 0 :
> >> +                     -EBUSY;
> >> +
> >> +     /* lock is either WRITE or DESTROY - should be exclusive */
> >> +     return down_write_trylock(&uobj->currently_used) == 1 ? 0 : -EBUSY;
> >
> > Is currently_used ever used as an actual blocking rwsem? Looks like
> > no to me right now, is that the long term plan?
> >
> 
> Yeah, it's never used for blocking and that's the long term plan.
> 
> > It actually seems to be important that this not be blocking, so it
> > might be better to code this a simple atomic.
> >
> 
> Actually, in the first version it was coded as an atomic and we decided
> to change it to rwsem after some comments. Anyway, no problem
> changing it back to the original version (see
> http://www.spinics.net/lists/linux-rdma/msg38346.html).

Yes, in general I don't like seeing open coded locks, but in this case
the non-block is actually an important property so it may be clearer,
but the atomic is a messy construct as well.

Maybe a comment on currently_used that the rwsem may never be used
blocking is enough?

> > This sort of approach starts to become very dangerous when you
> > contemplate having 'release' be a function in a module. Is that the
> > case?
> >
> 
> Well, I expect these core meta-types (e.g. idr, fd) to be declared in ib_uverbs
> or ib_core.

So that is two modules and it starts to become tricky..

> >> +     init_rwsem(&uobj->currently_used);
> >> +     uobj->context     = context;
> >> +     uobj->type        = type;
> >
> > .. and can you please not add the bogus whitespace in new commits
> > please? That is really not the typical kernel style and makes
> > everything hard to maintain and read.
> 
> Which bogus whitespace?

The stuff before the = to 'line up' the rhs of the assignment.

> >> +static void uverbs_idr_remove_uobj(struct ib_uobject *uobj)
> >> +{
> >> +     spin_lock(&uobj->context->ufile->idr_lock);
> >> +     idr_remove(&uobj->context->ufile->idr, uobj->id);
> >> +     spin_unlock(&uobj->context->ufile->idr_lock);
> >> +}
> >
> > Add a clarifying comment
> >
> > /* The caller must uverbs_uobject_put() uobj */
> 
> It could actually call kfree directly if the object is guaranteed not
> to be used, but
> this is a micro optimization that we probably shouldn't really care about.
> I prefer to put needs_rcu on the type and not on each uobject.

If skipping the kfree_rcu is important the needs_rcu should be
per-object, otherwise per type is probably fine.


> > Hum. This RCU is a bit exciting.. So this relies on the write lock
> > being held whenever uverbs_idr_remove is called. Can you add a
> > LOCKDEP style of of assertion to uverbs_idr_remove to prove that?
> 
> if we remove the lock and use atomics instead, there's nothing to do
> lockdep on, right?

Well, lockdep-like, if it is an atomic then do an atomic test
protected by CONFIG_LOCKDEP or some other such approach

> >> +     init_uobj(uobj, ucontext, type);
> >> +     ret = idr_add_uobj(uobj);
> >> +     if (ret) {
> >> +             kfree(uobj);
> >
> > This should be a uverbs_uobject_put()
> >
> 
> It'll just postpone this to rcu, but I guess this doesn't really matter.

Idiomatically, once the kref is inited then all frees must go through
kref_put.

> >> +static void _put_uobj_ref(struct kref *ref)
> >> +{
> >> +     kfree(container_of(ref, struct ib_uobject, ref));
> >> +}
> >> +
> >> +static void alloc_abort_idr_uobject(struct ib_uobject *uobj)
> >> +{
> >> +     uverbs_idr_remove_uobj(uobj);
> >> +     /*
> >> +      * we don't need kfree_rcu here, as the uobject wasn't exposed to any
> >> +      * other verb.
> >> +      */
> >> +     kref_put(&uobj->ref, _put_uobj_ref);
> >> +}
> >
> > Once needs_rcu is added then this ugly stuff goes away. Set needs_rcu
> > only when the uboject has been added to the IDR.
> 
> We could do that but needs_rcu is actually a type feature.

Either way this stuff goes away.

> >> +{
> >> +     uverbs_idr_remove_uobj(uobj);
> >> +     mutex_lock(&uobj->context->lock);
> >> +     list_del(&uobj->list);
> >> +     mutex_unlock(&uobj->context->lock);
> >> +     uverbs_uobject_put(uobj);
> >> +}
> >
> > And this flow is weird, hot_unplug calls an idr_type op, but this does
> > not? Why?
> >
> 
> In hot unplug or context removal, we need to cleanup the object. In regular
> destruction, the handler should take care of destructing the actual
> object.

So, I think this is a mistake. There is nothing special the handler
does compared to the hot unplug case and it makes no sense to have two
places to duplicate the call out to the driver unplug code. Having
three copies when the ioctl stuff comes along is even worse..

Having them be different is just going to create bugs down the road...

I don't mind the asymmetry because our entire model assumes complex
creation and consistent/trivial destruction.

It is not unlike the device_allocate/device_destroy/device_put sort of
flow where the allocate step has many variations but the destroy is
always uniform.

> destroy it), it lets the handler decide what to do if the
> destruction failed or if the destruction succeeded but copy_to_user
> failed.  Scenarios like this won't be supported as well:

This is why I added the return code to (*destroy) - exactly so the one
place that cares can return the error code, and all the other places
that can't be allowed to fail can have common recovery handling in the
core code.

Too many of our destroy calls toward the driver can can fail, we need
this to be handled in one place, not sprinkled throughout the code.

> >> +      * [hot_unplug]: Used when the context is destroyed (process
> >> +      *               termination, reset flow).
> >
> > I don't think we need a dedicated entry point. I think you should add
> > an enum argument to remove:
> >
> > enum rdma_remove_reason {
> >  RDMA_REMOVE_DESTROY, // Userspace requested uobject deletion
> >  RDMA_REMOVE_CLOSE,   // Context deletion. Call cannot fail.
> >  RDMA_REMOVE_DRIVER_REMOVE, // Driver is being hot-unplugged. Call cannot fail.
> > };
> >
> 
> The last two differs vastly from the first one. The first one only
> deletes the uobject, assumes

No, that isn't my proposal. The idea is that all three do the same
thing excep that:
 - RDMA_REMOVE_DESTROY the driver can return an error code if it
   wishes, the code is returned to userspace
 - RDMA_REMOVE_CLOSE the driver cannot return an error code and must
   force-destroy the object
 - RDMA_REMOVE_DRIVER_REMOVE the driver cannot return an error code,
   must force-destroy the object, and must leave behind any stuff
   to let userspace keep working (eg a zero page mmap, or whatever)

All flows will call the driver destroy function.

The approach is that the one or two call sites that use
RDMA_REMOVE_CLOSE/RDMA_REMOVE_DRIVER_REMOVE would also include the
WARN_ON to prove the driver is working as expected and then leave
whatever dangling ref around in some kind of controlled way.

> None of these calls could fail.

But that isn't really true :)

> > And probably add some commentary what objects support a detached
> > state. Any object that cannot be detached can only exist in the IDR
> > and cannot have a kref taken. Perhaps we should enforce that directly
> > for clarity.
> >
> 
> Actually, I don't see why we can't support detached IDR objects....
> As long as you don't execute commands on this IDR (for example, removing
> it from the objects list), you could use the memory as long as you want
> after you called uverbs_uobject_get (until you call uverbs_uobject_put).

The question about 'detached' revolves around what the users of the
object do. Eg if the users blindly do

ib_foo_action(uboj->driver_obj)

after the driver is disconnected then they will crash. Those objects
do not support 'detatch'

You are right in general the the IDR framework is OK and doesn't
care. But I think the current state of affairs is that only some call
sites, probably the FD related ones, are actually safe for this usage.

This becomes a bit more important down the road if people want to do
things outside the ucontext - eg enumerate all of the QPs in a
process - then we need clear rules for how that continues to work.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
