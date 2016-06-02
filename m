From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH] IB/core: Fix bit curruption in ib_device_cap_flags
 structure
Date: Thu, 2 Jun 2016 19:41:10 +0300
Message-ID: <575061A6.1060302@mellanox.com>
References: <1464859685-18666-1-git-send-email-maxg@mellanox.com>
 <20160602162426.GC26699@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160602162426.GC26699@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: matanb@mellanox.com, leon@leon.nu, sagi@grimberg.me, linux-rdma@vger.kernel.org, stable@vger.kernel.org, robert@leblancnet.us
List-Id: linux-rdma@vger.kernel.org



On 6/2/2016 7:24 PM, Greg KH wrote:
> On Thu, Jun 02, 2016 at 12:28:05PM +0300, Max Gurtovoy wrote:
>> ib_device_cap_flags 64-bit expansion caused caps overlapping
>> and made consumers read wrong device capabilities. For example
>> IB_DEVICE_SG_GAPS_REG was falsely read by the iser driver causing
>> it to use a non-existing capability. This happened because signed
>> int becomes sign extended when converted it to u64. Fix this by
>> casting IB_DEVICE_ON_DEMAND_PAGING enumeration to ULL.
>>
>> Fixes: fb532d6a79b9 ('IB/{core, ulp} Support above 32 possible device capability flags')
>> Reported-by: Robert LeBlanc <robert@leblancnet.us>
>> Cc: Stable <stable@vger.kernel.org> #[v4.6+]
>> Acked-by: Sagi Grimberg <sagi@grimberg.me>
>> Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
>> Signed-off-by: Matan Barak <matanb@mellanox.com>
>> ---
>>   include/rdma/ib_verbs.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index 432bed5..c97357b 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -217,7 +217,7 @@ enum ib_device_cap_flags {
>>   	IB_DEVICE_CROSS_CHANNEL		= (1 << 27),
>>   	IB_DEVICE_MANAGED_FLOW_STEERING		= (1 << 29),
>>   	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
>> -	IB_DEVICE_ON_DEMAND_PAGING		= (1 << 31),
>> +	IB_DEVICE_ON_DEMAND_PAGING		= (1ULL << 31),
>>   	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
>>   	IB_DEVICE_VIRTUAL_FUNCTION		= ((u64)1 << 33),
>>   	IB_DEVICE_RAW_SCATTER_FCS		= ((u64)1 << 34),
>
> Why not just use the BIT() and BIT_ULL() macros instead of "open coding"
> these?

Good idea. do you think it will be a good idea to set all the elements 
in this ib_device_cap_flags enum to BIT_ULL() in this patch ? to have 1 
style instead of many ?

>
> thanks,
>
> greg k-h
>
