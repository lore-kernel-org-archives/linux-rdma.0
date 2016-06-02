From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH] IB/core: Fix bit curruption in ib_device_cap_flags
 structure
Date: Thu, 2 Jun 2016 14:56:52 +0300
Message-ID: <57501F04.4010001@grimberg.me>
References: <1464859685-18666-1-git-send-email-maxg@mellanox.com>
 <20160602113353.GA18494@infradead.org> <57501D0C.9020607@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <57501D0C.9020607@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@infradead.org>
Cc: matanb@mellanox.com, leon@leon.nu, linux-rdma@vger.kernel.org, stable@vger.kernel.org, robert@leblancnet.us
List-Id: linux-rdma@vger.kernel.org


>>>       IB_DEVICE_CROSS_CHANNEL        = (1 << 27),
>>>       IB_DEVICE_MANAGED_FLOW_STEERING        = (1 << 29),
>>>       IB_DEVICE_SIGNATURE_HANDOVER        = (1 << 30),
>>> -    IB_DEVICE_ON_DEMAND_PAGING        = (1 << 31),
>>> +    IB_DEVICE_ON_DEMAND_PAGING        = (1ULL << 31),
>>>       IB_DEVICE_SG_GAPS_REG            = (1ULL << 32),
>>>       IB_DEVICE_VIRTUAL_FUNCTION        = ((u64)1 << 33),
>>>       IB_DEVICE_RAW_SCATTER_FCS        = ((u64)1 << 34),
>>
>> So now we've got three different styles to define the constants.
>
> My next patch will align casting of IB_DEVICE_VIRTUAL_FUNCTION and
> IB_DEVICE_RAW_SCATTER_FCS to ULL.
>
>>
>> I'd really prefer to move all of them over to the 1ULL << offset style.
>
> me too :)

Sounds good to me too...

Max, give it a day or two before resending (trying to save you the
multi-respin overhead).

Also, please next time when you submit a patch make sure to document
the patch version and what was changed from the last version.

Cheers,
Sagi.
