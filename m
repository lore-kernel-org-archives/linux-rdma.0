From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 6/7] IB/core: Declare all common IB types
Date: Thu, 12 Jan 2017 08:48:41 +0200
Message-ID: <CAAKD3BDf6oQfFZ--_GEkAGU=78B1rqELxouwzXEm8gr+fa=Ckg@mail.gmail.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
 <1484132033-3346-7-git-send-email-matanb@mellanox.com> <20170112001955.GF31682@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170112001955.GF31682-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 12, 2017 at 2:19 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Jan 11, 2017 at 12:53:52PM +0200, Matan Barak wrote:
>
>> diff --git a/drivers/infiniband/core/uverbs_ioctl_cmd.c b/drivers/infiniband/core/uverbs_ioctl_cmd.c
>> new file mode 100644
>
> This is not really an appropriate file name for this point in the
> series...
>
>> +DECLARE_UVERBS_TYPE(uverbs_type_comp_channel,
>> +                 &UVERBS_TYPE_ALLOC_FD(0, sizeof(struct ib_uobject) + sizeof(struct ib_uverbs_event_file),
>> +                                       uverbs_free_event_file,
>> +                                       &uverbs_event_fops,
>> +                                       "[infinibandevent]",
>> O_RDONLY));
>
> Really hate these macros.
>
> const struct ib_uobject_type uverbs_type_comp_channel = {
>        .size = sizeof(struct ib_uverbs_event_file,
>        .destroy = uverbs_destroy_event_file, // destroy = release device resources!!
>        .fd = {
>           .fops = &uverbs_event_fops,
>           .name = "[infinibandevent]"
>        },
> };
>
> If you can't do it without macros something else is wrong.
>
>> +DECLARE_UVERBS_TYPES(uverbs_common_types,
>> +                  ADD_UVERBS_TYPE(UVERBS_TYPE_PD, uverbs_type_pd),
>> +                  ADD_UVERBS_TYPE(UVERBS_TYPE_MR, uverbs_type_mr),
>> +                  ADD_UVERBS_TYPE(UVERBS_TYPE_COMP_CHANNEL, uverbs_type_comp_channel),
>> +                  ADD_UVERBS_TYPE(UVERBS_TYPE_CQ, uverbs_type_cq),
>> +                  ADD_UVERBS_TYPE(UVERBS_TYPE_QP, uverbs_type_qp),
>> +                  ADD_UVERBS_TYPE(UVERBS_TYPE_AH, uverbs_type_ah),
>> +                  ADD_UVERBS_TYPE(UVERBS_TYPE_MW, uverbs_type_mw),
>> +                  ADD_UVERBS_TYPE(UVERBS_TYPE_SRQ, uverbs_type_srq),
>> +                  ADD_UVERBS_TYPE(UVERBS_TYPE_FLOW, uverbs_type_flow),
>> +                  ADD_UVERBS_TYPE(UVERBS_TYPE_WQ, uverbs_type_wq),
>> +                  ADD_UVERBS_TYPE(UVERBS_TYPE_RWQ_IND_TBL,
>> +                                  uverbs_type_rwq_ind_table),
>> +                  ADD_UVERBS_TYPE(UVERBS_TYPE_XRCD, uverbs_type_xrcd),
>> +);
>> +EXPORT_SYMBOL(uverbs_common_types);
>
> No purpose at this point in the series.
>
> I didn't look carefully at patch 7 due to to convoluted it is, split
> it please..
>
> Everything else looks broadly reasonable to me and is a good overall
> improvement I think.

Thanks for the review Jason :)
I'll read it thoroughly and answer/ask for clarifications early next week.

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
