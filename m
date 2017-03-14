From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed
 during stress test on reset_controller
Date: Tue, 14 Mar 2017 18:52:03 +0200
Message-ID: <0a825b18-df06-9a6d-38c9-402f4ee121f7@mellanox.com>
References: <2013049462.31187009.1488542111040.JavaMail.zimbra@redhat.com>
 <95e045a8-ace0-6a9a-b9a9-555cb2670572@grimberg.me>
 <d21c5571-78fd-7882-b4cc-c24f76f6ff47@redhat.com>
 <20170310165214.GC14379@mtr-leonro.local>
 <56e8ccd3-8116-89a1-2f65-eb61a91c5f84@mellanox.com>
 <860db62d-ae93-d94c-e5fb-88e7b643f737@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <860db62d-ae93-d94c-e5fb-88e7b643f737-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 3/14/2017 3:35 PM, Yi Zhang wrote:
>
>
> On 03/13/2017 02:16 AM, Max Gurtovoy wrote:
>>
>>
>> On 3/10/2017 6:52 PM, Leon Romanovsky wrote:
>>> On Thu, Mar 09, 2017 at 12:20:14PM +0800, Yi Zhang wrote:
>>>>
>>>>> I'm using CX5-LX device and have not seen any issues with it.
>>>>>
>>>>> Would it be possible to retest with kmemleak?
>>>>>
>>>> Here is the device I used.
>>>>
>>>> Network controller: Mellanox Technologies MT27500 Family [ConnectX-3]
>>>>
>>>> The issue always can be reproduced with about 1000 time.
>>>>
>>>> Another thing is I found one strange phenomenon from the log:
>>>>
>>>> before the OOM occurred, most of the log are  about "adding queue", and
>>>> after the OOM occurred, most of the log are about "nvmet_rdma: freeing
>>>> queue".
>>>>
>>>> seems the release work: "schedule_work(&queue->release_work);" not
>>>> executed
>>>> timely, not sure whether the OOM is caused by this reason.
>>>
>>> Sagi,
>>> The release function is placed in global workqueue. I'm not familiar
>>> with NVMe design and I don't know all the details, but maybe the
>>> proper way will
>>> be to create special workqueue with MEM_RECLAIM flag to ensure the
>>> progress?
>>>
>>
>> Hi,
>>
>> I was able to repro it in my lab with ConnectX3. added a dedicated
>> workqueue with high priority but the bug still happens.
>> if I add a "sleep 1" after echo 1
>> >/sys/block/nvme0n1/device/reset_controller the test pass. So there is
>> no leak IMO, but the allocation process is much faster than the
>> destruction of the resources.
>> In the initiator we don't wait for RDMA_CM_EVENT_DISCONNECTED event
>> after we call rdma_disconnect, and we try to connect immediatly again.
>> maybe we need to slow down the storm of connect requests from the
>> initiator somehow to let the target time to settle up.
>>
>> Max.
>>
>>
> Hi Sagi
> Let's use this mail loop to track the OOM issue. :)
>
> Thanks
> Yi

Hi Yi,
I can't repro the OOM issue with 4.11-rc2 (don't know why actually).
which kernel are you using ?

Max.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
