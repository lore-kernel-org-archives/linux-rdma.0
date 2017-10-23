From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 3/7] IB/hfi1: Validate PKEY for incoming GSI MAD
 packets
Date: Mon, 23 Oct 2017 14:55:38 -0400
Message-ID: <d09970ea-2531-4d8e-0b4f-85533ff8487a@intel.com>
References: <20171023125327.21191.31462.stgit@scvm10.sc.intel.com>
 <20171023130558.21191.30808.stgit@scvm10.sc.intel.com>
 <20171023183848.GC16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023183848.GC16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/23/2017 2:38 PM, Leon Romanovsky wrote:
> > diff --git a/drivers/infiniband/hw/hfi1/mad.c 
b/drivers/infiniband/hw/hfi1/mad.c
>> index 07b80fa..dfe6224 100644
>> --- a/drivers/infiniband/hw/hfi1/mad.c
>> +++ b/drivers/infiniband/hw/hfi1/mad.c
>> @@ -98,6 +98,16 @@ static inline void clear_opa_smp_data(struct opa_smp *smp)
>>   	memset(data, 0, size);
>>   }
>>
>> +static inline u16 hfi1_lookup_pkey_value(struct hfi1_ibport *ibp, int pkey_idx)
> 
> Please, no "inline-function" in *.c files as it is written in CodingStyle.

Sure about that?

As a rule of thumb I agree we should not put inlines in C files though. 
However as you can see from the context, this file already has static 
inlines so I wasn't too bothered by it.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
