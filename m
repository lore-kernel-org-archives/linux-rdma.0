From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Tue, 17 Jul 2018 13:05:03 +0300
Message-ID: <7655e77d-8db5-ffcb-3ccf-f2e67d0b0390@mellanox.com>
References: <20180716083012.15410-1-leon@kernel.org>
 <0cf29652-9034-6283-ef36-95de4588980f@grimberg.me>
 <20180716103046.GJ3152@mtr-leonro.mtl.com>
 <1cb63259-9fb6-59b0-3a34-0659973228ea@mellanox.com>
 <d8f375d7-8a1f-39f5-5fd6-0bdc781f1465@grimberg.me>
 <40d49fe1-c548-31ec-7daa-b19056215d69@mellanox.com>
 <243215dc-2b06-9c99-a0cb-8a45e0257077@opengridcomputing.com>
 <3f827784-3089-2375-9feb-b3c1701d7471@mellanox.com>
 <20180717085831.GB3152@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180717085831.GB3152@mtr-leonro.mtl.com>
Content-Language: he
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Steve Wise <swise@opengridcomputing.com>, Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



On 7/17/2018 11:58 AM, Leon Romanovsky wrote:
> On Tue, Jul 17, 2018 at 11:46:40AM +0300, Max Gurtovoy wrote:
>>
>>
>> On 7/16/2018 8:08 PM, Steve Wise wrote:
>>> Hey Max:
>>>
>>>
>>
>> Hey,
>>
>>> On 7/16/2018 11:46 AM, Max Gurtovoy wrote:
>>>>
>>>>
>>>> On 7/16/2018 5:59 PM, Sagi Grimberg wrote:
>>>>>
>>>>>> Hi,
>>>>>> I've tested this patch and seems problematic at this moment.
>>>>>
>>>>> Problematic how? what are you seeing?
>>>>
>>>> Connection failures and same error Steve saw:
>>>>
>>>> [Mon Jul 16 16:19:11 2018] nvme nvme0: Connect command failed, error
>>>> wo/DNR bit: -16402
>>>> [Mon Jul 16 16:19:11 2018] nvme nvme0: failed to connect queue: 2 ret=-18
>>>>
>>>>
>>>>>
>>>>>> maybe this is because of the bug that Steve mentioned in the NVMe
>>>>>> mailing list. Sagi mentioned that we should fix it in the NVMe/RDMA
>>>>>> initiator and I'll run his suggestion as well.
>>>>>
>>>>> Is your device irq affinity linear?
>>>>
>>>> When it's linear and the balancer is stopped the patch works.
>>>>
>>>>>
>>>>>> BTW, when I run the blk_mq_map_queues it works for every irq affinity.
>>>>>
>>>>> But its probably not aligned to the device vector affinity.
>>>>
>>>> but I guess it's better in some cases.
>>>>
>>>> I've checked the situation before Leon's patch and set all the vetcors
>>>> to CPU 0. In this case (I think that this was the initial report by
>>>> Steve), we use the affinity_hint (Israel's and Saeed's patches were we
>>>> use dev->priv.irq_info[vector].mask) and it worked fine.
>>>>
>>>> Steve,
>>>> Can you share your configuration (kernel, HCA, affinity map, connect
>>>> command, lscpu) ?
>>>> I want to repro it in my lab.
>>>>
>>>
>>> - linux-4.18-rc1 + the nvme/nvmet inline_data_size patches + patches to
>>> enable ib_get_vector_affinity() in cxgb4 + sagi's patch + leon's mlx5
>>> patch so I can change the affinity via procfs.
>>
>> ohh, now I understand that you where complaining regarding the affinity
>> change reflection to mlx5_ib_get_vector_affinity and not regarding the
>> failures on connecting while the affinity overlaps (that is working good
>> before Leon's patch).
>> So this is a known issue since we used a static hint that never changes
>> from dev->priv.irq_info[vector].mask.
>>
>> IMO we must fulfil the user wish to connect to N queues and not reduce it
>> because of affinity overlaps. So in order to push Leon's patch we must
>> also fix the blk_mq_rdma_map_queues to do a best effort mapping according
>> the affinity and map the rest in naive way (in that way we will *always*
>> map all the queues).
> 
> Max,
> 
> I have no clue what is needed to do int blq_mq*, but my patch only gave
> to users ability reconfigure their affinity mask after driver is loaded.

Yes I know, but since the only user of this API is the blk-mq-rdma and 
the nvme_rdma driver that can't establish connection with your patch - I 
suggest to wait with pushing it and fix the mapping of 
blk_mq_rdma_map_queues

> 
> Thanks
> 
>>
>> -Max.
>>
