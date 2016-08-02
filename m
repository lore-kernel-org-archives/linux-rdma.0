From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: [IPoIB] Missing join mcast events causing full machine lockup
Date: Tue, 2 Aug 2016 23:18:57 +0300
Message-ID: <CAJFSNy6USnLqcBiPEOcFOG8MrGq8gXwvakG48jHHi_-YgVaQ3g@mail.gmail.com>
References: <57907A37.3000902@kyup.com> <1470165672.18081.37.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470165672.18081.37.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 2, 2016 at 10:21 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 2016-07-21 at 10:31 +0300, Nikolay Borisov wrote:
>> Hello,
>>
>> With running the risk of sounding like a broken record, I came
>> across
>> another case where ipoib can cause the machine to go haywire due to
>> missed join requests. This is on 4.4.14 kernel. Here is what I
>> believe
>> happens:
>
> [ snip long traces ]
>
>> This makes me wonder if using timeouts is actually better than
>> blindly relying on completing the join.
>
> Blindly relying on the join completions is not what we do.  We are very
> careful to make sure we always have the right locking so that we never
> leave a join request in the BUSY state without running the completion
> at some time.  If you are seeing us do that, then it means we have a
> bug in our locking or state processing.  The answer then is to find
> that bug and not to paper over it with a timeout.  Can you find some
> way to reproduce this with a 4.7 kernel?

Unfortunately my environment is constrained to 4.4 kernel. I will, however,
try and check if I can get a couple of IB-enabled nodes on 4.7 and see
if something
shows up. And while I don't have a 100% reproducer for it I see those
symptoms rather regularly
on production nodes. I'm able and happy to extract any runtime state
that might be useful in debugging this i.e I can obtain crashdumps and
reverse the state of the ipoib stacks. I've seen this issue on 3.12 and on 4.4.
Some of my previous emails also show this manifesting in hangs in cm_destroy_id
as well. So clearly there is a problem there but it proves very elusive.

>
>>  So Doug, what would
>> you say about the following as a proposed fix (not tested):
>>
>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> index 87799de90a1d..f6f15d36b02d 100644
>> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> @@ -947,7 +947,7 @@ void ipoib_mcast_restart_task(struct work_struct
>> *work)
>>          */
>>         list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
>>                 if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
>> -                       wait_for_completion(&mcast->done);
>> +                       wait_for_completion_timeout(&mcast->done, 30
>> * HZ);
>>
>>         list_for_each_entry_safe(mcast, tmcast, &remove_list, list) {
>>                 ipoib_mcast_leave(mcast->dev, mcast);
>>
>> Given the loop afterwards which uses ipoib_mcast_(leave_free) that
>> should work?
>> Looking at the code in ipoib_mcast_leave it seems we are going to
>> trigger a warning,
>> which is preferable to putting the machine to a grinding halt?
>>
>> Does the proposed patch break things horribly ?
>
> It violates the intent of the join processing.  And if we have the
> problem you are seeing, we really need to know if it's broken in IPoIB
> or deeper down in the core portion of the stack.  Breaking out and
> continuing might be OK, but if we do, we are likely going to either
> leak something or have a use-after-free or something like that, so I
> would have to spend some time thinking about how things might go wrong
> and whether or not it's better to stop the machine when this happens,
> or continue and hope we don't corrupt memory somehow.
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
