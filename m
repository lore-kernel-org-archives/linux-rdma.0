From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V1 2/3] IB/core: RoCE GID management separate
 cleanup and release
Date: Tue, 4 Aug 2015 15:09:39 +0300
Message-ID: <CAAKD3BBESq61-UJJvqm=ni5vrtu8yuNJvC57mWwCpehQSd1k4A@mail.gmail.com>
References: <1438607342-11964-1-git-send-email-matanb@mellanox.com>
	<1438607342-11964-3-git-send-email-matanb@mellanox.com>
	<20150804031038.GA27627@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150804031038.GA27627-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 4, 2015 at 6:10 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Aug 03, 2015 at 04:09:01PM +0300, Matan Barak wrote:
>
>> The release function is called after the device was put.
>> Although vendor drivers aren't expected to use IB cache in their
>> removal process, we postpone freeing the cache in order to avoid
>> possible use-after-free errors.
>
> It isn't so much that they are not expected, it is that they may not
> have a choice. A driver cannot tear down things like tasklets and work
> queues until after removal finishes, and any of those async things
> could call into the core. That is why a driver audit would be so hard..
>

Correct, I'll change this comment to:
    The release function is called after the device was put.
    This is in order to avoid use-after-free errors if the vendor
    driver's teardown code uses IB cache.


>> @@ -902,9 +925,7 @@ int ib_cache_setup_one(struct ib_device *device)
>>                                         (rdma_end_port(device) -
>>                                          rdma_start_port(device) + 1),
>>                                         GFP_KERNEL);
>> -     err = gid_table_setup_one(device);
>> -
>> -     if (!device->cache.pkey_cache || !device->cache.gid_cache ||
>> +     if (!device->cache.pkey_cache ||
>>           !device->cache.lmc_cache) {
>>               printk(KERN_WARNING "Couldn't allocate cache "
>>                      "for %s\n", device->name);
>> @@ -912,6 +933,10 @@ int ib_cache_setup_one(struct ib_device *device)
>>               goto err;
>>       }
>>
>> +     err = gid_table_setup_one(device);
>> +     if (err)
>> +             goto err;
>> +
>>       for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p) {
>>               device->cache.pkey_cache[p] = NULL;
>>               ib_cache_update(device, p + rdma_start_port(device));
>> @@ -929,29 +954,46 @@ err_cache:
>>       for (p = 0; p <= rdma_end_port(device) - rdma_start_port(device); ++p)
>>               kfree(device->cache.pkey_cache[p]);
>>
>> +     gid_table_cleanup_one(device);
>> +     gid_table_release_one(device);
>>  err:
>>       kfree(device->cache.pkey_cache);
>> -     gid_table_cleanup_one(device);
>>       kfree(device->cache.lmc_cache);
>
> This still seems to double kfree on error..
>
> Pick a scheme and use it consistently, either rely on release to be
> called on error via kref-put, or kfree and null, for all the kfress in
> release_one.
>

I'll switch to kref-put cleanup. That means:
gid_table_setup_one - should only call cleanup and not release in error-flow
ib_cache_setup_one - shouldn't free any allocated memory/release the GID cache
          but just cleanup the GID cache.
ib_cache_release_one - should check if the pkey_cache is NULL before freeing it.


>> +     ib_cache_cleanup_one(device);
>>       ib_device_unregister_sysfs(device);
>
> I didn't check closely, but I suspect the above order should be
> swapped, and the matching swap in register. sysfs can legitimately
> call into core code, but vice-versa shouldn't happen...
>

I didn't understand this comment. The cleanup code calls del_gid which tells the
vendor to delete this GID (and dev_put the ndevs). The kref-put (which
is called when
the device is unregistered) frees the memory. If we switch the order,
we would have
use-after-free scenario.

> Jason

Thanks for looking at this patch.

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
