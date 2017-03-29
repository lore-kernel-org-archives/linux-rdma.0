From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 for-next 6/7] IB/core: Add support for fd objects
Date: Wed, 29 Mar 2017 21:29:57 +0300
Message-ID: <CAAKD3BCxObSa4NMC1_U6GeAox4yJ1KNX9o+XO+OFA4W7OTH89Q@mail.gmail.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
 <1489939145-125246-7-git-send-email-matanb@mellanox.com> <20170329145507.GC2586@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170329145507.GC2586-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 29, 2017 at 5:55 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sun, Mar 19, 2017 at 05:59:04PM +0200, Matan Barak wrote:
>
>> +static void alloc_abort_fd_uobject(struct ib_uobject *uobj)
>> +{
>> +     struct ib_uobject_file *uobj_file =
>> +             container_of(uobj, struct ib_uobject_file, uobj);
>> +     struct file *filp = uobj->object;
>> +     int id = uobj_file->uobj.id;
>> +
>> +     /* Unsuccessful NEW */
>> +     fput(filp);
>> +     put_unused_fd(id);
>> +}
>> +
>> +static int __must_check remove_commit_fd_uobject(struct ib_uobject *uobj,
>> +                                              enum rdma_remove_reason why)
>> +{
>> +     const struct uverbs_obj_fd_type *fd_type =
>> +             container_of(uobj->type, struct uverbs_obj_fd_type, type);
>> +     struct ib_uobject_file *uobj_file =
>> +             container_of(uobj, struct ib_uobject_file, uobj);
>> +     int ret = fd_type->context_closed(uobj_file, why);
>> +
>> +     if (why == RDMA_REMOVE_DESTROY && ret)
>> +             return ret;
>> +
>> +     if (why == RDMA_REMOVE_DURING_CLEANUP) {
>> +             alloc_abort_fd_uobject(uobj);
>
> Doesn't this call put_unused_fd on a fd that has actually been
> installed? That isn't OK...
>

Nope, this is only called when we need to commit an object but we are for some
reason in the cleanup process. If that happened, we have an initialized object.
We can't add it to the list, as it's currently locked by the cleanup process.
We can't just free it as it might allocated some hardware resources.
So we need to
destroy it with some unique specific reason. As stated, this is called
straight from
the commit uobject path. In that condition we didn't install the fd yet so that
should be ok.

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
