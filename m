From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [bug report] RDMA/bnxt_re: Add SRQ support for Broadcom adapters
Date: Thu, 1 Feb 2018 09:04:19 +0530
Message-ID: <CANjDDBjJn0RnP5YD4yoQd6zNSNiy4vSoAD4N5nciJF0wQVjTOA@mail.gmail.com>
References: <20180130124546.GA9394@mwanda> <CANjDDBiiL1TtH5OZ9gYuiZquKu2=AV+u9nJDQ--qibOP5CXgYg@mail.gmail.com>
 <20180131063238.ch4mcl7c6ps7ykxe@mwanda> <20180131064829.GR2055@mtr-leonro.local>
 <1517414670.19117.16.camel@redhat.com> <1517432861.19117.42.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517432861.19117.42.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 1, 2018 at 2:37 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2018-01-31 at 11:04 -0500, Doug Ledford wrote:
>> On Wed, 2018-01-31 at 08:48 +0200, Leon Romanovsky wrote:
>> > On Wed, Jan 31, 2018 at 09:32:38AM +0300, Dan Carpenter wrote:
>> > > On Wed, Jan 31, 2018 at 11:16:55AM +0530, Devesh Sharma wrote:
>> > > > On Tue, Jan 30, 2018 at 6:15 PM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>> > > > > Hello Devesh Sharma,
>> > > > >
>> > > > > The patch 37cb11acf1f7: "RDMA/bnxt_re: Add SRQ support for Broadcom
>> > > > > adapters" from Jan 11, 2018, leads to the following static checker
>> > > > > warning:
>> > > > >
>> > > > >         drivers/infiniband/hw/bnxt_re/ib_verbs.c:1317 bnxt_re_destroy_srq()
>> > > > >         warn: 'srq->umem' isn't an ERR_PTR
>> > > > >
>> > > > > drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> > > > >   1313                  dev_err(rdev_to_dev(rdev), "Destroy HW SRQ failed!");
>> > > > >   1314                  return rc;
>> > > > >   1315          }
>> > > > >   1316
>> > > > >   1317          if (srq->umem && !IS_ERR(srq->umem))
>> > > > >                                   ^^^^^^^^^^^^^^^^
>> > > > > We never store error pointers to srq->umem.  It's pretty consistently
>> > > > > checked for error pointers though so maybe that's fine.  It causes a
>> > > > > static checker warning because error pointer confusion is a pretty
>> > > > > common source of bugs.  Anyway, feel free to ignore if you want...
>> > > >
>> > > > Thanks for reporting Dan,
>> > > >
>> > > > Is there a way out, I want to call ib_umem_release only if it was valid.
>> > > > I think if ib_umem_release checks for the validity of pointer then I
>> > > > can get rid of this?
>> > > > There are other places also in bnxt_re driver where such checks are present.
>> > >
>> > > Yeah.  Those places generate warnings as well, but I thought one was
>> > > enough.  It's fine if you want to ignore the warning, no one will be
>> > > upset.  :P
>> >
>> > Not really, we are trying to clean the subsystem from the warnings
>> > and driver authors who ignore such warnings simply and very effective
>> > sabotage it.
>> >
>> > Currently my checks print ~400 warnings for the drivers/infiniband/* +
>> > drivers/net/ethernet/mellanox/*
>> >
>> > So please don't increase this number, or fix the driver or fix the tool :)
>> >
>> > Thanks
>>
>> Looking at the code, the proper fix for this is:
>>
>> [dledford@haswell-e linus (k.o/wip/dl-for-next *)]$ git diff
>> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> index 9b8fa77b8831..ae9e9ff54826 100644
>> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> @@ -1314,7 +1314,7 @@ int bnxt_re_destroy_srq(struct ib_srq *ib_srq)
>>                 return rc;
>>         }
>>
>> -       if (srq->umem && !IS_ERR(srq->umem))
>> +       if (srq->umem)
>>                 ib_umem_release(srq->umem);
>>         kfree(srq);
>>         atomic_dec(&rdev->srq_count);
>> @@ -1430,11 +1430,8 @@ struct ib_srq *bnxt_re_create_srq(struct ib_pd
>> *ib_pd,
>>         return &srq->ib_srq;
>>
>>  fail:
>> -       if (udata && srq->umem && !IS_ERR(srq->umem)) {
>> +       if (srq->umem)
>>                 ib_umem_release(srq->umem);
>> -               srq->umem = NULL;
>> -       }
>> -
>>         kfree(srq);
>>  exit:
>>         return ERR_PTR(rc);
>> [dledford@haswell-e linus (k.o/wip/dl-for-next *)]$
>>
>
> This was committed in my tree for the next merge pull request.

Thanks Doug, I will review the driver code once and see if I can
supply the fix for rest of the occurrences.
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
