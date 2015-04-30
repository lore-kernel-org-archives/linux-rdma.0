From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 for-next 02/33] IB/core: Add kref to IB devices
Date: Thu, 30 Apr 2015 11:21:01 +0300
Message-ID: <5541E5ED.7000606@mellanox.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
 <9f65de5e-ed5f-48d2-bff2-03ffbe4f4876@CMEXHTCAS2.ad.emulex.com>
 <CAJ3xEMhBNt-VNNds37sXnJi3nP9ZTMd6mC3s+qZWh0XsO1n_Nw@mail.gmail.com>
 <553DF294.4070507@mellanox.com>
 <CAJ3xEMjzgS_uR1VaeGzW+jcfG2oiVo4=fCctX6o4OVbKRX2n0Q@mail.gmail.com>
 <553F931F.6000302@mellanox.com> <20150428174312.GB5497@obsidianresearch.com>
 <5540F8F4.5010906@dev.mellanox.co.il>
 <20150429164847.GA12781@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150429164847.GA12781-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 4/29/2015 7:48 PM, Jason Gunthorpe wrote:
>
>>> Although, there must be a call to the driver's modify_gid to free
>>> context before freeing, and I don't see that obviously happening..
>
>> Of course there is:
>> roce_gid_cache_client_cleanup_one ->
>> roce_gid_cache_client_cleanup_one_work -> *work* ->
>> roce_gid_cache_client_cleanup_work_handler ->
>> roce_gid_cache_cleanup_one -> free_roce_gid_cache -> write_gid ->
>> modify_gid
>
> Ah, this wasn't there in the earlier versions. Good.
>
>>> However, all the other async work launched doesn't look safe at all.
>
>> I think it's safe - roce_gid_cache_client_cleanup_one deactivates
>> the cache (no new events are handled on the cache). Ongoing events
>> are flushed in roce_gid_cache_client_cleanup_one_work
>
> Do you mean roce_gid_cache_client_cleanup_work_handler?
>

Yeah, the flush_workqueue is done in 
roce_gid_cache_client_cleanup_work_handler

>> It's not safe to free the client's context in ib_unregister_device
>> while the client isn't done. The obvious solution is to wait in
>> client->remove (like you suggested) until the client has finished
>> cleaning up things.
>
> This isn't just the obvious solution, it is the *expected* solution.
> In the kernel the add/remove style idiom always works like this.
>
>> This doesn't fit our case - since client->remove is called under
>> device_lock, but it's possible (for example) that
>> roce_rescan_device_work_handler is currently running and waits to
>> grab this exact mutex - DEAD LOCK.
>
> Uh, client->remove is most obviously called with
> drivers/infiniband/core/device.c:device_mutex held, is that what you
> mean? But that can't be right because only four functions hold that
> lock and none of them are obviously called from this patch?
>
> If these patches have a locking problem then breaking the add/remove
> idiom is not the way to solve it.
>
> Look, four people have asked about this patch, and I still have yet to
> see an accurate and convincing answer from you what is actually going
> on here. Please actually spend some time to properly research and
> describe why the remove callback can't be synchronous.
>

ib_unregister_device calls the remove function with device_mutex help. 
In addition, ib_enum_roce_ports_of_netdev does the same. Every 
interesting netdev/inet/inet6 event that's handled in roce_gid_mgmt 
triggers ib_enum_roce_ports_of_netdev by using the workqueue (for 
example, 
netdevice_event->*work*->netdevice_event_work_handler->ib_enum_roce_ports_of_netdev).

When a device is being unregistered, the remove function is called under 
device_mutex:
ib_unregister_device->roce_gid_cache_client_cleanup_one->*work*->roce_gid_cache_client_cleanup_work_handler->flush_workqueue

This flush_workqueue could wait for ib_enum_roce_ports_of_netdev. If we 
would have called it straight from the remove function, we're waiting 
for a work which waits for a mutex that will be unlocked only after the 
iteration over all remove functions is completed -> *DEADLOCK*

You could argue that flush_workqueue isn't needed, but that let's look 
at the following flow:

roce_gid_cache_client_setup_one->roce_rescan_device->*work (with the 
exact ib_dev)*->....
We need to make sure the ib_dev isn't free'd before this work is done.

There might be some ways around it - for example, introduce another 
workqueue for roce_rescan_device and flush this workqueue only. Every 
way has its advantages and disadvantages. I think it's problematic that 
device_mutex can't be held in a work as *most* client works are 
synchronized when the a device is being unregistered. It could affect 
future clients as well.

I'll be happy to explain/fix any issue you have regarding this code, but 
of course it needs to be concrete.

>>> It is just fundamentally wrong to return from ib_client.remove while
>>> async work is still outstanding, the client is expected to deal with
>>> this internally and synchronously.
>>>
>>> You don't need IB core help to do this.
>>
>> netdev is taking a similar approach - please take a look at
>> netdev_wait_allrefs
>
> No, it really isn't, from the attached drivers perspective after
> unregister_netdevice returns the driver is not allowed to operate the
> net device anymore. netdev_wait_allrefs is part of making
> unregister_netdevice synchronous.
>
> The same is true of our IB client attaches, after a client returns
> from remove it is not allowed to operate the IB device anymore.
>

ib_unregister_device is synchronous in the exact same manner - after it 
returns, no client operate on the IB device. 
wait_for_completion(&device->free) was added for this exact reason.

> That is a standard idiom, and we'd need a huge compelling reason to go
> away from that.

A device can be remove if and only if it's reference count is zero. 
That's the only point where we guarantee nobody uses it anymore. That's 
a standard idiom as well.

>
> Jason
>

I really appreciate the review and thanks for looking at this patch,
Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
