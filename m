From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 for-next 4/7] IB/core: Change idr objects to use the
 new schema
Date: Wed, 15 Feb 2017 15:45:00 +0200
Message-ID: <CAAKD3BAUZpf5pr4G3Uv=ikD3WGgOgmbcz2WnrPm3FCJiSFCVJg@mail.gmail.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
 <1485952745-58476-5-git-send-email-matanb@mellanox.com> <20170210203048.GD4335@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170210203048.GD4335-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 10, 2017 at 10:30 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Feb 01, 2017 at 02:39:02PM +0200, Matan Barak wrote:
>
>> +#define idr_get_xxxx(_type, _write, _handle, _context) ({            \
>> +     const struct uverbs_obj_idr_type * const type =                 \
>> +                     &uverbs_type_attrs_##_type;                     \
>> +     struct ib_uobject *uobj = type->type.ops->lookup_get(&type->type, \
>> +                                     _context, _handle, _write);     \
>> +                                                                     \
>> +     IS_ERR(uobj) ? NULL : uobj->object; })
>
> I think you should follow the usual convention and have a full
> suite of accessor helpers in a header. This header could even be in
> patch #2
>

I prefer to put it in this patch, but I'll introduce them in
uverbs_std_types.h as you suggested.

> static struct ib_uobject *__uobj_get(const struct uverbs_obj_type *type, bool write, struct ib_ucontext *ucontext, int id)
> {
>   [..]
> }
> #define uobj_get_read(_type,...) ((struct ib_##_type *)_uobj_get(&uverbs_type_attrs_##_type, false, __VA_ARGS__))
> #define uobj_get_write(_type,...) ((struct ib_##_type *)_uobj_get(&uverbs_type_attrs_##_type, false, __VA_ARGS__))
>
> static inline void uobj_put_write(struct ib_uobject *uobj)
> {
>     uobj->type->ops->lookup_put(uobj, true);
> }
>
> static inline void uobj_put_read(struct ib_uobject *uobj)
> {
>     uobj->type->ops->lookup_put(uobj, false);
> }
>
> static inline struct ib_uobject *__uobj_alloc(const struct uverbs_obj_type *type,struct ib_ucontext *ucontext)
> {
>    return type->alloc_begin(type, ucontext);
> }
>
> #define uobj_alloc_begin(_type, ...) ((struct ib_##_type *)_uobj_alloc(&uverbs_type_attrs_##_type, __VA_ARGS__))
>
> and so on
>

I'll add something similar.

>>  static struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
>>  {
>> -     return idr_read_obj(pd_handle, context, 0);
>> +     return idr_get_xxxx(pd, false, pd_handle, context);
>>  }
>
> And you can just totally drop all of these inlines and use
>
>   uobj_get_read(pd, pd_handle, context);
>
> At the call site.
>

Sure

>>  static struct ib_xrcd *idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
>>                                    struct ib_uobject **uobj)
>>  {
>> -     *uobj = idr_read_uobj(xrcd_handle, context, 0);
>> -     return *uobj ? (*uobj)->object : NULL;
>> +     *uobj = uverbs_type_attrs_xrcd.type.ops->lookup_get(&uverbs_type_attrs_xrcd.type,
>> +                                                     context, xrcd_handle,
>> +                                                     false);
>> +     return IS_ERR(*uobj) ? NULL : (*uobj)->object;
>
> Why didn't this use idr_get_xxx ? Why is it so weird?
>

This was the original code as well and I wanted to refactor as closely as I can.
However, this might be a good time to cleanup this as well.

>>
>> @@ -621,9 +439,11 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
>>       if (copy_from_user(&cmd, buf, sizeof cmd))
>>               return -EFAULT;
>>
>> -     uobj = idr_write_uobj(cmd.pd_handle, file->ucontext);
>> -     if (!uobj)
>> -             return -EINVAL;
>> +     uobj = uverbs_type_attrs_pd.type.ops->lookup_get(&uverbs_type_attrs_pd.type,
>> +                                                  file->ucontext,
>> +                                                  cmd.pd_handle, true);
>> +     if (IS_ERR(uobj))
>> +             return PTR_ERR(uobj);
>>       pd = uobj->object;
>>
>>       if (atomic_read(&pd->usecnt)) {
>> @@ -636,21 +456,12 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
>>       if (ret)
>>               goto err_put;
>>
>> -     uobj->live = 0;
>> -     put_uobj_write(uobj);
>> -
>> -     idr_remove_uobj(uobj);
>> -
>> -     mutex_lock(&file->mutex);
>> -     list_del(&uobj->list);
>> -     mutex_unlock(&file->mutex);
>> -
>> -     put_uobj(uobj);
>> +     uobj->type->ops->destroy_commit(uobj);
>
> And here I think you should move the pd->device_dealloc_pd into
> destroy_commit by having it call what you called hot_plug, and turn
> this simply into:
>
>         return uobj_remove_or_put(uobj, RDMA_REMOVE_DESTROY);
>
> static inline int uobj_remove_or_put(struct ib_uobject *uobj, enum rdma_remove_reason why)
> {
>     int rc = uobj->type->ops->remove(uobj, why);
>     if (!rc)
>         uverbs_uobject_put(uobj);
>
>     /* If we are using a forced destruction mode then the driver is
>         not permitted to fail. */
>     WARN_ON(!rc && why != RDMA_REMOVE_DESTROY);
>     return rc;
> }
>
> And generally use this pattern for all the destroy verbs.
>

I prefer to keep this separation. In handlers code, the handler is
responsible to destroy
the actual object and to just call remove_commit or lookup_put (via
the accessor functions of course).
There's a clear separation here between the uobjects management and
the objects themselves.
It's also more symmetrical - the user created this pd and [s]he shall
destroy it.

> I didn't study this patch closely since it will change a lot, but I
> think this:
>
>  4 files changed, 260 insertions(+), 788 deletions(-)
>
> Pretty much confirms this is the right overall approach.
>
> Jason

Thanks for the review.

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
