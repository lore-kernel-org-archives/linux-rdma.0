From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 18/20] IB/hfi1: Fix unbalanced braces around else
Date: Tue, 18 Apr 2017 11:15:42 -0400
Message-ID: <c4c11382-d311-f75b-36e2-598c4f5e8acc@intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
 <20170409171717.10579.36147.stgit@scvm10.sc.intel.com>
 <20170413060343.GC1343@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170413060343.GC1343-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/13/2017 02:03 AM, Leon Romanovsky wrote:
>> diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
>> index c0cfcd1..19fab90 100644
>> --- a/drivers/infiniband/hw/hfi1/chip.c
>> +++ b/drivers/infiniband/hw/hfi1/chip.c
>> @@ -8147,10 +8147,10 @@ static irqreturn_t sdma_interrupt(int irq, void *data)
>>
>>  		/* handle the interrupt(s) */
>>  		sdma_engine_interrupt(sde, status);
>> -	} else
>> +	} else {
>>  		dd_dev_err(dd, "SDMA engine %u interrupt, but no status bits set\n",
>>  			   sde->this_idx);
>
> Not relevant to this patch, but interesting to hear. Does such error
> print produce dmesg storm in case of error or this is one time failure?

I think it could possibly. We should probably look into making this rate 
limited. Thanks for noticing.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
