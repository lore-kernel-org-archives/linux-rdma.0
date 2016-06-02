From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix bit curruption in ib_device_cap_flags
 structure
Date: Thu, 2 Jun 2016 14:48:28 +0300
Message-ID: <57501D0C.9020607@mellanox.com>
References: <1464859685-18666-1-git-send-email-maxg@mellanox.com>
 <20160602113353.GA18494@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160602113353.GA18494-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-2ukJVAZIZ/Y@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 6/2/2016 2:33 PM, Christoph Hellwig wrote:
>>   	IB_DEVICE_CROSS_CHANNEL		= (1 << 27),
>>   	IB_DEVICE_MANAGED_FLOW_STEERING		= (1 << 29),
>>   	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
>> -	IB_DEVICE_ON_DEMAND_PAGING		= (1 << 31),
>> +	IB_DEVICE_ON_DEMAND_PAGING		= (1ULL << 31),
>>   	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
>>   	IB_DEVICE_VIRTUAL_FUNCTION		= ((u64)1 << 33),
>>   	IB_DEVICE_RAW_SCATTER_FCS		= ((u64)1 << 34),
>
> So now we've got three different styles to define the constants.

My next patch will align casting of IB_DEVICE_VIRTUAL_FUNCTION and 
IB_DEVICE_RAW_SCATTER_FCS to ULL.

>
> I'd really prefer to move all of them over to the 1ULL << offset style.

me too :)

>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
