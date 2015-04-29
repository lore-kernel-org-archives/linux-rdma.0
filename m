From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 for-next 02/33] IB/core: Add kref to IB devices
Date: Wed, 29 Apr 2015 12:16:30 +0300
Message-ID: <5540A16E.3050603@mellanox.com>
References: <1427318422-12004-1-git-send-email-somnath.kotur@emulex.com>
 <9f65de5e-ed5f-48d2-bff2-03ffbe4f4876@CMEXHTCAS2.ad.emulex.com>
 <CAJ3xEMhBNt-VNNds37sXnJi3nP9ZTMd6mC3s+qZWh0XsO1n_Nw@mail.gmail.com>
 <553DF294.4070507@mellanox.com>
 <CAJ3xEMjzgS_uR1VaeGzW+jcfG2oiVo4=fCctX6o4OVbKRX2n0Q@mail.gmail.com>
 <553F931F.6000302@mellanox.com> <20150428174312.GB5497@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150428174312.GB5497-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 4/28/2015 8:43 PM, Jason Gunthorpe wrote:
> On Tue, Apr 28, 2015 at 05:03:11PM +0300, Matan Barak wrote:
>
>> The cleanup of roce_gid_cache is done in a different context, so we
>> need to make sure the device is still alive while doing so.
>
> This explanation doesn't look right to me. I don't see anything like
> that under roce_gid_cache_cleanup_one ?
>
> Although, there must be a call to the driver's modify_gid to free
> context before freeing, and I don't see that obviously happening..
>

Of course there is:
roce_gid_cache_client_cleanup_one -> 
roce_gid_cache_client_cleanup_one_work -> *work* -> 
roce_gid_cache_client_cleanup_work_handler -> roce_gid_cache_cleanup_one 
-> free_roce_gid_cache -> write_gid -> modify_gid

> However, all the other async work launched doesn't look safe at all.
>

I think it's safe - roce_gid_cache_client_cleanup_one deactivates the 
cache (no new events are handled on the cache). Ongoing events are 
flushed in roce_gid_cache_client_cleanup_one_work 
(flush_workqueue(roce_gid_mgmt_wq)). When roce_gid_cache_cleanup_one is 
called - no work will be done or is currently in process on this cache.

> So, did you mean that the device must still be alive while all the
> other work is running? And the point of this scheme is to guarentee
> all the work is flushed? (at least I hope it is, otherwise there are
> bigger problems here)
>

It's not safe to free the client's context in ib_unregister_device while 
the client isn't done. The obvious solution is to wait in client->remove 
(like you suggested) until the client has finished cleaning up things. 
This doesn't fit our case - since client->remove is called under 
device_lock, but it's possible (for example) that 
roce_rescan_device_work_handler is currently running and waits to grab 
this exact mutex - DEAD LOCK.
Freeing thing asynchronously is a possible solution - we don't lock all 
IB devices but just our device. Moreover, it's also more future proof as 
other clients might want to run other things concurrently.

> It is just fundamentally wrong to return from ib_client.remove while
> async work is still outstanding, the client is expected to deal with
> this internally and synchronously.
>
> You don't need IB core help to do this.
>

netdev is taking a similar approach - please take a look at 
netdev_wait_allrefs

> Or: This should have been fixed after Haggai brought it up...
>
> Jason
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
