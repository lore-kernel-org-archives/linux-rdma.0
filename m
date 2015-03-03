From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/9] IB/ipoib: factor out ah flushing
Date: Tue, 03 Mar 2015 11:59:05 +0200
Message-ID: <54F585E9.7070704@dev.mellanox.co.il>
References: <cover.1424562072.git.dledford@redhat.com>		 <b06eb720c2f654f5ecdb72c66f4e89149d1c24ec.1424562072.git.dledford@redhat.com>		 <54EF1F67.4000001@dev.mellanox.co.il>	 <1424968046.2543.18.camel@redhat.com> <54F2B61C.9080308@dev.mellanox.co.il> <1425308967.2354.19.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425308967.2354.19.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/2/2015 5:09 PM, Doug Ledford wrote:
> On Sun, 2015-03-01 at 08:47 +0200, Erez Shitrit wrote:
>> On 2/26/2015 6:27 PM, Doug Ledford wrote:
>>>>> @@ -1037,6 +1038,7 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
>>>>>     	if (level == IPOIB_FLUSH_LIGHT) {
>>>>>     		ipoib_mark_paths_invalid(dev);
>>>>>     		ipoib_mcast_dev_flush(dev);
>>>>> +		ipoib_flush_ah(dev, 0);
>>>> Why do you need to call the flush function here?
>>> To remove all of the ah's that were reduced to a 0 refcount by the
>>> previous two functions prior to restarting operations.  When we remove
>>> an ah, it calls ib_destroy_ah which calls all the way down into the low
>>> level driver.  This was to make sure that old, stale data was removed
>>> all the way down to the card level before we started new queries for
>>> paths and ahs.
>> Yes. but it is not needed.
> That depends on the card.  For the modern cards (mlx4, mlx5, qib), it
> isn't needed but doesn't hurt either.  For older cards (in particular,
> mthca), the driver actually frees up card resources at the time of the
> call.

Can you please elaborate more here, I took a look in the mthca and 
didn't see that.
anyway, what i don't understand is why you need to do that now, the ah 
is already in the dead_ah_list so, in at the most 1 sec will be cleared 
and if the driver goes down your other hunk fixed that.

>> The bug happened when the driver was removed (via modprobe -r etc.), and
>> there were ah's in the dead_ah list, that was fixed by you in the
>> function ipoib_ib_dev_cleanup, the call that you added here is not
>> relevant to the bug (and IMHO is not needed at all)
> I never said that this hunk was part of the original bug I saw before.
>
>> So, the the task of cleaning the dead_ah is already there, no need to
>> recall it, it will be called anyway 1 sec at the most from now.
>>
>> You can try that, take of that call, no harm or memory leak will happened.
> I have no doubt that it will get freed later.  As I said, I never
> considered this particular hunk part of that original bug.  But, as I
> point out above, there is no harm in it for any hardware, and depending
> on hardware it can help to make sure there isn't a shortage of
> resources.  Given that fact, I see no reason to remove it.
>
>>>> I can't see the reason to use the flush not from the stop_ah, meaning
>>>> without setting the IPOIB_STOP_REAPER, the flush can send twice the same
>>>> work.
>>> No, it can't.  The ah flush routine does not search through ahs to find
>>> ones to flush.  When you delete neighbors and mcasts, they release their
>>> references to ahs.  When the refcount goes to 0, the put routine puts
>>> the ah on the to-be-deleted ah list.  All the flush does is take that
>>> list and delete the items.  If you run the flush twice, the first run
>>> deletes all the items on the to-be-deleted list, the second run sees an
>>> empty list and does nothing.
>>>
>>> As for using flush versus stop: the flush function cancels any delayed
>>> ah_flush work so that it isn't racing with the normally scheduled
>> when you call cancel_delayed_work to work that can schedule itself, it
>> is not help, the work can be at the middle of the run and re-schedule
>> itself...
> If it is in the middle of a run and reschedules itself, then it will
> schedule itself at precisely the same time we would have anyway, and we
> will get flushed properly, so the net result of this particular race is
> that we end up doing exactly what we wanted to do anyway.
>
>>> ah_flush, then flushes the workqueue to make sure anything that might
>>> result in an ah getting freed is done, then flushes, then schedules a
>>> new delayed flush_ah work 1 second later.  So, it does exactly what a
>>> flush should do: it removes what there is currently to remove, and in
>>> the case of a periodically scheduled garbage collection, schedules a new
>>> periodic flush at the maximum interval.
>>>
>>> It is not appropriate to call stop_ah at this point because it will
>>> cancel the delayed work, flush the ahs, then never reschedule the
>>> garbage collection.  If we called stop here, we would have to call start
>>> later.  But that's not really necessary as the flush cancels the
>>> scheduled work and reschedules it for a second later.
>>>
>>>>>     	}
>>>>>     
>>>>>     	if (level >= IPOIB_FLUSH_NORMAL)
>>>>> @@ -1100,6 +1102,14 @@ void ipoib_ib_dev_cleanup(struct net_device *dev)
>>>>>     	ipoib_mcast_stop_thread(dev, 1);
>>>>>     	ipoib_mcast_dev_flush(dev);
>>>>>     
>>>>> +	/*
>>>>> +	 * All of our ah references aren't free until after
>>>>> +	 * ipoib_mcast_dev_flush(), ipoib_flush_paths, and
>>>>> +	 * the neighbor garbage collection is stopped and reaped.
>>>>> +	 * That should all be done now, so make a final ah flush.
>>>>> +	 */
>>>>> +	ipoib_stop_ah(dev, 1);
>>>>> +
>>>>>     	ipoib_transport_dev_cleanup(dev);
>>>>>     }
>>>>>     
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
