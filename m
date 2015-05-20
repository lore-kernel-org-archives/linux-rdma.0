From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 01/10] IB/core: Change provider's API of
 create_cq to be extendible
Date: Wed, 20 May 2015 19:41:17 +0300
Message-ID: <CAAKD3BAXBPgkFp=bmeDNoj6QbAXoHMGt_nv+LHCE09g5=nyPGQ@mail.gmail.com>
References: <1431869786-6308-1-git-send-email-ogerlitz@mellanox.com>
	<1431869786-6308-2-git-send-email-ogerlitz@mellanox.com>
	<20150519184535.GJ18675@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150519184535.GJ18675-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 19, 2015 at 9:45 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sun, May 17, 2015 at 04:36:17PM +0300, Or Gerlitz wrote:
>> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Add a new ib_cq_init_attr structure which contains the
>> previous cqe (minimum number of CQ entries) and comp_vector
>> (completion vector) in addition to a new flags field.
>> All vendors' create_cq callbacks are changed in order
>> to work with the new API.
>>
>> This commit does not change any functionality.
>
> This seems reasonable to me.
>
>> @@ -1341,6 +1341,7 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
>>       struct ib_uverbs_event_file    *ev_file = NULL;
>>       struct ib_cq                   *cq;
>>       int                             ret;
>> +     struct ib_cq_init_attr attr = {.cqe = 0};
>
> This doesn't seem necessary, it is unconditionally set below:
>

Almost :) It also zeros (default value) all other fields. I could
replace it with a memset if it's clearer.

>>       if (out_len < sizeof resp)
>>               return -ENOSPC;
>> @@ -1376,8 +1377,9 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
>>       INIT_LIST_HEAD(&obj->comp_list);
>>       INIT_LIST_HEAD(&obj->async_list);
>>
>> -     cq = file->device->ib_dev->create_cq(file->device->ib_dev, cmd.cqe,
>> -                                          cmd.comp_vector,
>> +     attr.cqe = cmd.cqe;
>> +     attr.comp_vector = cmd.comp_vector;
>> +     cq = file->device->ib_dev->create_cq(file->device->ib_dev, &attr,
>>                                            file->ucontext, &udata);
>
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -1013,8 +1013,9 @@ struct ib_cq *ib_create_cq(struct ib_device *device,
>>                          void *cq_context, int cqe, int comp_vector)
>>  {
>>       struct ib_cq *cq;
>> +     struct ib_cq_init_attr attr = {.cqe = cqe, .comp_vector = comp_vector};
>>
>> -     cq = device->create_cq(device, cqe, comp_vector, NULL, NULL);
>> +     cq = device->create_cq(device, &attr, NULL, NULL);
>
> Hum, I guess it makes sense to stop flowing ib_cq_init_attr at this
> point, for this patch, but it does seem a bit weird from an API design
> perspective.
>

I guess you suggest that ib_create_cq will take ib_cq_init_attr * instead of
separate parameters for cqe and comp_vector. Ok, I'll change that for next
patch set.

>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index 8d59479..ad0e2ea 100644
>> +++ b/include/rdma/ib_verbs.h
>> @@ -173,6 +173,12 @@ struct ib_odp_caps {
>>       } per_transport_caps;
>>  };
>>
>> +struct ib_cq_init_attr {
>> +     int cqe;
>
>  unsigned int cqe
>
> Can't be negative..
>

Correct, but that's the current API as well. I'll change that.

>> +     struct ib_cq *             (*create_cq)(struct ib_device *device,
>> +                                             struct ib_cq_init_attr *attr,
>
> const struct ib_cq_init_attr *attr,
>
> And related changes that will cause.
>

I'll change that, thanks!

Matan

> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
