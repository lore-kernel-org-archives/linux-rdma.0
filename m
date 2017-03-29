From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 for-next 2/7] IB/core: Add support for idr types
Date: Wed, 29 Mar 2017 22:23:19 +0300
Message-ID: <CAAKD3BD328+Ykq_LcMojTObew6A1UQ0qs_g5m_qaLYUww=NuDw@mail.gmail.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
 <1489939145-125246-3-git-send-email-matanb@mellanox.com> <20170329151028.GD2586@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170329151028.GD2586-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 29, 2017 at 6:10 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sun, Mar 19, 2017 at 05:59:00PM +0200, Matan Barak wrote:
>
>> +static int uverbs_try_lock_object(struct ib_uobject *uobj, bool write)
>> +{
>> +     /*
>> +      * When a read is required, we use a positive counter. Each read
>> +      * request checks that the value != -1 and increment it. Write
>> +      * requires an exclusive access, thus we check that the counter is
>> +      * zero (nobody claimed this object) and we set it to -1.
>> +      * Releasing a read lock is done by simply decreasing the counter.
>> +      * As for writes, since only a single write is permitted, setting
>> +      * it to zero is enough for releasing it.
>> +      */
>> +     if (!write)
>> +             return __atomic_add_unless(&uobj->usecnt, 1, -1) == -1 ?
>> +                     -EBUSY : 0;
>> +
>> +     /* lock is either WRITE or DESTROY - should be exclusive */
>> +     return atomic_cmpxchg(&uobj->usecnt, 0, -1) == 0 ? 0 : -EBUSY;
>
> I wonder if a WARN_ON should be here, is it ever not an error to try
> to write lock twice?
>

No, if two handlers are executed in the same time and they both want to lock the
same object for write, it could be a user space bug, but it's valid
and supported in the
kernel.

>> +static struct ib_uobject *alloc_uobj(struct ib_ucontext *context,
>> +                                  const struct uverbs_obj_type *type)
>> +{
>> +     struct ib_uobject *uobj = kmalloc(type->obj_size, GFP_KERNEL);
>
> Do you think this should be kzalloc?
>

That might be a good idea. Although we initialize all fields of the
uobject, this uobject
might be a base structure for a larger standard verbs uobjects
structure. We might not
want to trust our callers to initialize all their fields.

>> +/* Returns the ib_uobject or an error. The caller should check for IS_ERR. */
>> +static struct ib_uobject *lookup_get_idr_uobject(const struct uverbs_obj_type *type,
>> +                                              struct ib_ucontext *ucontext,
>> +                                              int id, bool write)
>> +{
>> +     struct ib_uobject *uobj;
>> +
>> +     RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
>> +                      "ib_uverbs: lookup_get_idr_uobject is called without proper synchronization");
>> +     /* object won't be released as we're protected in rcu */
>> +     uobj = idr_find(&ucontext->ufile->idr, id);
>> +     if (!uobj)
>> +             return ERR_PTR(-ENOENT);
>> +
>
> A function called lookup_get should also do the get. I think this
> would look iodmatically better like:
>
>         rcu_read_lock();
>         uobj = idr_find(&ucontext->ufile->idr, id);
>         if (uobj)
>                 uverbs_uobject_get(uobj);
>         rcu_read_unlock();
>
> And drop the overlap from rdma_lookup_get_uobject
>

Yeah, that could be a nice small refactor. However, it makes
the needs_rcu asymmetrical. We test this flag at release, but
we don't force that in the lookup_get. So, that's a trade-off between
these methods.

>> +     if (uobj->type != type)
>> +             return ERR_PTR(-EINVAL);
>> +
>
> This should probably be done in rdma_lookup_get_uobject?
>

But what happens if you fail? In the fd case, you have to fput the file.
That's why I preferred this model.

>> +/*
>> + * Objects type classes which support a detach state (object is still alive but
>> + * it's not attached to any context need to make sure:
>> + * (a) If function pointers are used in any modules, module_get was called on
>> + *     this module.
>> + * (b) detach isn't called concurrently with context_cleanup
>> + */
>
> Little confused about this comment on module_get.. Our typical
> strategy has been to forbid many kinds of cross-module calls during
> detatchment. eg by setting function pointers to null. That is a robust
> approach, I would not like to see more module_gets  ..
>

I agree. The only thing that we have to ensure is that the release and
free functions have
to be available when they're called. How the module actually does that
is something we could
decide when we cross that bridge.

> Jason
> --

Thanks for the valuable comments.

Matan

> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
