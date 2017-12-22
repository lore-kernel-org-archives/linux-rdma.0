From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 3/3] IB/hfi1: Change slid arg in
 ingress_pkey_table_fail to 32bit
Date: Fri, 22 Dec 2017 09:28:11 -0800
Message-ID: <d26eee16-9a17-c629-e012-dd760ab7ecb9@intel.com>
References: <20171222164036.29731.43475.stgit@scvm10.sc.intel.com>
 <20171222164557.29731.16649.stgit@scvm10.sc.intel.com>
 <20171222165600.GE30884@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222165600.GE30884-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Jason,


On 12/22/2017 8:56 AM, Jason Gunthorpe wrote:
> On Fri, Dec 22, 2017 at 08:46:00AM -0800, Dennis Dalessandro wrote:
>> From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> Change the slid arg to ingress_pkey_table_fail() to a full
>> 32Bits and do not convert to 16Bits in caller. This is so we
>> can keep everything 32bit in the kernel and only change to
>> 16bit at the uapi boundary.
>>
>> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>   drivers/infiniband/hw/hfi1/hfi.h |    2 +-
>>   drivers/infiniband/hw/hfi1/mad.c |    6 +-----
>>   2 files changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
>> index 869c2bf..dc5b133 100644
>> +++ b/drivers/infiniband/hw/hfi1/hfi.h
>> @@ -1627,7 +1627,7 @@ static int ingress_pkey_table_search(struct hfi1_pportdata *ppd, u16 pkey)
>>    * the 'error info' for this failure.
>>    */
>>   static void ingress_pkey_table_fail(struct hfi1_pportdata *ppd, u16 pkey,
>> -				    u16 slid)
>> +				    u32 slid)
>>   {
>>   	struct hfi1_devdata *dd = ppd->dd;
>>   
>> diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
>> index cf8dba3..34547a4 100644
>> +++ b/drivers/infiniband/hw/hfi1/mad.c
>> @@ -4348,11 +4348,7 @@ static int opa_local_smp_check(struct hfi1_ibport *ibp,
>>   	 */
>>   	if (pkey == LIM_MGMT_P_KEY || pkey == FULL_MGMT_P_KEY)
>>   		return 0;
>> -	/*
>> -	 * On OPA devices it is okay to lose the upper 16 bits of LID as this
>> -	 * information is obtained elsewhere. Mask off the upper 16 bits.
>> -	 */
>> -	ingress_pkey_table_fail(ppd, pkey, ib_lid_cpu16(0xFFFF & in_wc->slid));
>> +	ingress_pkey_table_fail(ppd, pkey, in_wc->slid);
>>   	return 1;
>>   }
> I'm confused by this patch.
>
> It seems to totally revert the -stable patch
> 4988be5813ff2afdc0d8bfa315ef34a577d3efbf, with the exception that
> ingress_pkey_table_fail now accepts a u32.
>
> Is this saying the correct version of
> 4988be5813ff2afdc0d8bfa315ef34a577d3efbf was to just change that one
> type??
>
> Jason

Yes, the correct version was to just change the type. When I made the 
original fix I didn't notice that was the easy/proper way of doing it 
until your comments. Our original implementation had the masking off and 
I've been just carrying it along without much thought until you 
commented. Thanks again!

don

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
