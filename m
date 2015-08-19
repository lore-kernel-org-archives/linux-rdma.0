From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V2 4/4] IB/core: RoCE GID management separate
 cleanup and release
Date: Wed, 19 Aug 2015 16:16:40 +0300
Message-ID: <CAAKD3BBmGGECyHOJscXHhYLpDaJZ_tTJSTSoHiXJNjf4zbyiCQ@mail.gmail.com>
References: <1438881240-22790-1-git-send-email-matanb@mellanox.com>
	<1438881240-22790-5-git-send-email-matanb@mellanox.com>
	<55CF495C.6010708@redhat.com>
	<55D04785.9070007@mellanox.com>
	<55D0B925.8000504@redhat.com>
	<55D0BEE3.3040000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55D0BEE3.3040000-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 16, 2015 at 7:48 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 08/16/2015 12:24 PM, Doug Ledford wrote:
>> On 08/16/2015 04:19 AM, Matan Barak wrote:
>>>
>>>
>>> On 8/15/2015 5:14 PM, Doug Ledford wrote:
>>>> On 08/06/2015 01:14 PM, Matan Barak wrote:
>>>>> Separate the cleanup and release IB cache functions.
>>>>> The cleanup function delete all GIDs and unregister the event channel,
>>>>> while the release function frees all memory. The cleanup function is
>>>>> called after all clients were removed (in the device un-registration
>>>>> process).
>>>>>
>>>>> The release function is called after the device was put.
>>>>> This is in order to avoid use-after-free errors if ther vendor
>>>>> driver's teardown code uses IB cache.
>>>>>
>>>>> Squash-into: 'IB/core: Add RoCE GID table management'
>>>>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>
>>>> I had originally used the v1 of this patch instead of v2.  In order to
>>>> make sure I didn't miss anything, I hand compared the final results of
>>>> the v1 patch to what this patch would have created if I had used it.  I
>>>> found a few things worth nothing, comments inline below.
>>>>
>>>>> @@ -903,20 +924,28 @@ int ib_cache_setup_one(struct ib_device *device)
>>>>>                         (rdma_end_port(device) -
>>>>>                          rdma_start_port(device) + 1),
>>>>>                         GFP_KERNEL);
>>>>> -    err = gid_table_setup_one(device);
>>>>> -
>>>>> -    if (!device->cache.pkey_cache || !device->cache.gid_cache ||
>>>>> +    if (!device->cache.pkey_cache ||
>>>>>           !device->cache.lmc_cache) {
>>>>>           printk(KERN_WARNING "Couldn't allocate cache "
>>>>>                  "for %s\n", device->name);
>>>>> -        err = -ENOMEM;
>>>>> -        goto err;
>>>>> +        /* pkey_cache is freed here because we later access it's
>>>>> +         * elements.
>>>>> +         */
>>>>> +        kfree(device->cache.pkey_cache);
>>>>> +        device->cache.pkey_cache = NULL;
>>>>> +        return -ENOMEM;
>>>>
>>>> This function is unnecessarily convoluted IMO.  A simple change to using
>>>> kzalloc() for the pkey_cache alloc eliminates part of the issue.  As a
>>>> result, I fixed this function up to be different than either patch.
>>>> Please look over my results and make sure you agree with my changes.
>>>>
>>>>>       }
>>>>>
>>>>> -    for (p = 0; p <= rdma_end_port(device) -
>>>>> rdma_start_port(device); ++p) {
>>>>> +    for (p = 0; p <= rdma_end_port(device) -
>>>>> rdma_start_port(device); ++p)
>>>>>           device->cache.pkey_cache[p] = NULL;
>>>>
>>>> For instance this goes away entirely by using kzalloc().
>>>>
>>>> The rest looked ok.  I have to fixup the ordering changes between sysfs
>>>> and cache to make the v1 patch match the v2 patch.
>>>>
>>>>
>>>
>>> Thanks for the squashing and re-ordering these patches.
>>> I think you're missing if (device->cache.pkey_cache) over the for pkey
>>> free loop in ib_cache_release_one.
>>
>> I think you're right, but I think that particular issue exists in both
>> versions of the code (mine and yours).  In particular, a failure during
>> ib_register_device should result in a call to ib_dealloc_device which
>> will result in a call to ib_cache_release_one, which will happen whether
>> ib_cache_setup_one returns an error or not.  So, ib_cache_release_one
>> must check pkey_cache before releasing the ports because it can't assume
>> the original setup succeeded.
>>
>>> Otherwise, the allocation of
>>> device->cache.pkey_cache might has failed and you dereference an invalid
>>> address device->cache.pkey_cache[p].
>>>
>>> In addition, ib_device_release calls ib_cache_release_one with device
>>> instead of dev (which has the wrong type).
>>> ib_register_device calls ib_cache_clean_one that I can't really find :)
>>
>> Both of these turned up in compile tests.  I've since resolved them.
>> Hand merge issues ;-)
>>
>
> I've pushed what I think is a fixed version to github.  Please feel free
> to review.
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
>

I think that after applying Dan Carpenter's "[patch] IB/core: missing
curly braces in ib_find_gid()" it's fine :-)
Thanks.

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
