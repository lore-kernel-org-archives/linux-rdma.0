From: "Henry, Michael N" <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 5/9] IB/core, rdmavt, hfi1: Send OPA cap_mask3 in
 trap
Date: Tue, 30 May 2017 11:32:22 -0700
Message-ID: <2fc7a7d6-9ba3-2365-45e3-946f56827dd9@intel.com>
References: <20170526123257.8158.23943.stgit@scvm10.sc.intel.com>
 <20170526123536.8158.237.stgit@scvm10.sc.intel.com>
 <20170529161407.GB17751@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170529161407.GB17751-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/29/2017 9:14 AM, Leon Romanovsky wrote:
> On Fri, May 26, 2017 at 05:35:37AM -0700, Dennis Dalessandro wrote:
>> From: Michael N. Henry <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> Provide the ability for IB clients to modify the OPA specific
>> capability mask and include this mask in the subsequent trap data.
>>
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index 785e927..6c4f6da 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -576,7 +576,8 @@ struct ib_device_modify {
>>   enum ib_port_modify_flags {
>>   	IB_PORT_SHUTDOWN		= 1,
>>   	IB_PORT_INIT_TYPE		= (1<<2),
>> -	IB_PORT_RESET_QKEY_CNTR		= (1<<3)
>> +	IB_PORT_RESET_QKEY_CNTR		= (1<<3),
>> +	IB_PORT_OPA_MASK_CHG		= (1<<4)
> How will this flag be set?
>
This flag can be set as the port_modify_mask when calling ib_modify_port(..)

Thanks,

-Mike

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
