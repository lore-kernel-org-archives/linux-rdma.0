From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Fix a wrapping test (make it less strict)
Date: Mon, 23 Oct 2017 13:57:43 -0400
Message-ID: <36cdf5bf-a28c-e853-523d-8cf0fa748a56@intel.com>
References: <20171013105559.tqzh6jhcnvmqhdwy@mwanda>
 <1508771116.3325.0.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508771116.3325.0.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/23/2017 11:05 AM, Doug Ledford wrote:
> On Fri, 2017-10-13 at 13:56 +0300, Dan Carpenter wrote:
>> The "2 * UINT_MAX" overflows so the test is essentially doing this:
>>
>> 	if ((u64)(ts - cce->timestamp) > UINT_MAX - 1) {
>>
>> I've changed it to a 64bit type.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> Not tested.
>>
>> diff --git a/drivers/infiniband/hw/hfi1/mad.c
>> b/drivers/infiniband/hw/hfi1/mad.c
>> index f4c0ffc040cc..3aeea8afd44f 100644
>> --- a/drivers/infiniband/hw/hfi1/mad.c
>> +++ b/drivers/infiniband/hw/hfi1/mad.c
>> @@ -3781,7 +3781,7 @@ static int __subn_get_opa_hfi1_cong_log(struct
>> opa_smp *smp, u32 am,
>>   		 * required to wrap the counter are supposed to
>>   		 * be zeroed (CA10-49 IBTA, release 1.2.1, V1).
>>   		 */
>> -		if ((u64)(ts - cce->timestamp) > (2 * UINT_MAX))
>> +		if ((u64)(ts - cce->timestamp) > (2ULL * UINT_MAX))
>>   			continue;
>>   		memcpy(cong_log->events[i].local_qp_cn_entry, &cce-
>>> lqpn, 3);
>>   		memcpy(cong_log-
>>> events[i].remote_qp_number_cn_entry,
> 
> Denny, I'm looking for feedback from you on this patch.  This fixes a
> bug, my only concern is that the code used to work with the bug, could
> this make the code not work?
> 

Mike and I have been looking at this. The code seems to work as it is 
but fails with Dan's patch. We are still looking at it, but I'd advise 
against pulling just yet. It's not something for 4.14.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
