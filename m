From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 for-next 7/7] IB/core: Change completion channel to use
 the reworked objects schema
Date: Wed, 29 Mar 2017 21:21:09 +0300
Message-ID: <CAAKD3BCaq2xndM_xtU7OY=wX2Mvw0y2+sqWBg-BSQPKYpfyEWg@mail.gmail.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
 <1489939145-125246-8-git-send-email-matanb@mellanox.com> <20170329145344.GB2586@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170329145344.GB2586-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 29, 2017 at 5:53 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sun, Mar 19, 2017 at 05:59:05PM +0200, Matan Barak wrote:
>> +static struct ib_uverbs_completion_event_file *
>> +ib_uverbs_lookup_comp_file(int fd, struct ib_ucontext *context)
>> +{
>> +     struct ib_uobject *uobj = uobj_get_read(uobj_get_type(comp_channel),
>> +                                             fd, context);
>> +     struct ib_uobject_file *uobj_file;
>> +
>> +     if (IS_ERR(uobj))
>> +             return (void *)uobj;
>> +
>> +     uobj_file = container_of(uobj, struct ib_uobject_file, uobj);
>> +
>> +     uverbs_uobject_get(&uobj_file->uobj);
>> +     uobj_put_read(uobj);
>
> That looks odd, isn't uobj == uobj_file->uobj ?
>

Yeah, they're essentially the same. The uverbs_uobject_get is intended
to increase the reference count
on the returned object. The uobj_put_read is paired with uobj_get_read
(first line of this function).
We could change them both to uobj.

>> +     kref_init(&ev_file->ref);
>> +     filp = anon_inode_getfile("[infinibandevent]", &uverbs_async_event_fops,
>>                                 ev_file, O_RDONLY);
>
> It seems weird this name occures twice:
>

Unfortunately, we have to keep the current names. The old code created
the async fd
and the completion channel fd and both are called the same.

>> +const struct uverbs_obj_fd_type uverbs_type_attrs_comp_channel = {
>> +     .type = UVERBS_TYPE_ALLOC_FD(sizeof(struct ib_uverbs_completion_event_file), 0),
>> +     .context_closed = uverbs_hot_unplug_completion_event_file,
>> +     .fops = &uverbs_event_fops,
>> +     .name = "[infinibandevent]",
>> +     .flags = O_RDONLY,
>> +};
>
> Jason

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
