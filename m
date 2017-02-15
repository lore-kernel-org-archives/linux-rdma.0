From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 for-next 3/7] IB/core: Add idr based standard types
Date: Wed, 15 Feb 2017 15:44:22 +0200
Message-ID: <CAAKD3BDyg04Y0c9Pn1YbxZyxR8PpRFYbpF8UokFcgi7CdUcj3A@mail.gmail.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
 <1485952745-58476-4-git-send-email-matanb@mellanox.com> <20170210200849.GC4335@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170210200849.GC4335-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 10, 2017 at 10:08 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Feb 01, 2017 at 02:39:01PM +0200, Matan Barak wrote:
>
>> +void uverbs_free_qp(struct ib_uobject *uobject)
>
> This should be static...
>

Yeah

> Based on the last email I expect this to be
>
> static int uverbs_destroy_qp(struct ib_uobject *uobject, enum rdma_remove_reason why)
>

Since we don't care about the reason here and it's called from the
destroy callback,
we could leave the deceleration as is.

>> +{
>> +     struct ib_qp *qp = uobject->object;
>> +     struct ib_uqp_object *uqp =
>> +             container_of(uobject, struct ib_uqp_object, uevent.uobject);
>> +
>> +     if (qp == qp->real_qp)
>> +             ib_uverbs_detach_umcast(qp, uqp);
>> +     ib_destroy_qp(qp);
>
> This silently eats the error code from ib_destroy_qp, not OK. See
> discussion in prior email. Lots of cases of this.
>

I can add a WARN_ON, but this is essentially the same as ib_destroy_qp
fails when a context is destroyed (either because of hot unplug or process
termination). You won't get here because of regular destroy handler.
This is the current behavior as well.

>> +const struct uverbs_obj_idr_type uverbs_type_attrs_cq =
>> +     UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_ucq_object), 0,
>> +                              uverbs_free_cq);
>>
>
> It would be more readable if the struct decl was near the functions in
> blocks.
>

But then it can't be used by the hardware drivers to declare new types.

> Still don't like these macros. The open coded version would look like this:
>
> const struct uverbs_obj_idr_type uverbs_type_attrs_cq = {
>       .type = {
>             .obj_size = sizeof(struct ib_ucq_object),
>             .ops = &uverbs_idr_ops,
>       },
>       .destroy = uverbs_destroy_cq,
> };
>
> Whichs is more understandable and typical of the kernel style. If we
> wish to add a new callback function for instance we don't need a new
> macro or big churn.
>
> You could do this I guess:
>
> const struct uverbs_obj_idr_type uverbs_type_attrs_cq = {
>       .type = UVERBS_IDR_TYPE(cq, 0),
>       .destroy = uverbs_destroy_cq,
> };
>

Yeah, seems reasonable - a good trade off.

>> +extern const struct uverbs_obj_type_ops uverbs_idr_ops;
>> +
>> +#define UVERBS_BUILD_BUG_ON(cond) (sizeof(char[1 - 2 * !!(cond)]) -  \
>> +                                sizeof(char))
>
> This probably doesn't add value, but you could make this a WARN_ON in
> alloc_uobj().
>

Why should we calculate this on runtime if we could know this in compile time?

> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
