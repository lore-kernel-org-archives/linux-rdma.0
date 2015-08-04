From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V1 2/3] IB/core: RoCE GID management separate
 cleanup and release
Date: Tue, 4 Aug 2015 21:55:03 +0300
Message-ID: <CAAKD3BDDKcyA0xitGpuMkKsr6=9onxFgdVXHE3n-zb=xjX4Uhg@mail.gmail.com>
References: <1438607342-11964-1-git-send-email-matanb@mellanox.com>
	<1438607342-11964-3-git-send-email-matanb@mellanox.com>
	<20150804031038.GA27627@obsidianresearch.com>
	<CAAKD3BBESq61-UJJvqm=ni5vrtu8yuNJvC57mWwCpehQSd1k4A@mail.gmail.com>
	<20150804164650.GA3858@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150804164650.GA3858-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 4, 2015 at 7:46 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Aug 04, 2015 at 03:09:39PM +0300, Matan Barak wrote:
>> Correct, I'll change this comment to:
>>     The release function is called after the device was put.
>>     This is in order to avoid use-after-free errors if the vendor
>>     driver's teardown code uses IB cache.
>
> .. the vendor driver uses IB cache from async contexts ..
>

right (or just from the unregister code path of the vendor driver) :)

>> >> +     ib_cache_cleanup_one(device);
>> >>       ib_device_unregister_sysfs(device);
>> >
>> > I didn't check closely, but I suspect the above order should be
>> > swapped, and the matching swap in register. sysfs can legitimately
>> > call into core code, but vice-versa shouldn't happen...
>> >
>>
>> I didn't understand this comment. The cleanup code calls del_gid
>> which tells the vendor to delete this GID (and dev_put the
>> ndevs). The kref-put (which is called when the device is
>> unregistered) frees the memory. If we switch the order, we would
>> have use-after-free scenario.
>
> I don't understand your comment either.
>
> What code path from ib_cache will go into ib_sysfs?
>

The device code goes to ib_sysfs and ib_cache. I was rethinking this
and I think it still might be a bit problematic.
The ib_register_device error flow could fail either in
ib_device_register_sysfs or ib_cache_setup_one.
If it fails in ib_device_register_sysfs, the device release function
isn't called and the device pointer isn't freed.
If ib_cache_setup_one fails, we call ib_device_unregister_sysfs and
the memory will be freed. So it seems like
ib_device_register_sysfs should be the last call in
ib_reigster_device. But in the ib_unregister_device path, I still
need to first call ib_cache_cleanup_once and then call
ib_device_unregister_sysfs (otherwise I'll have use-after-free).
What do you think?

> Jason

Thanks again for the helpful comments.

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
