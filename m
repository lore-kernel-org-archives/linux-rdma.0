From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Tue, 7 Jul 2015 18:07:49 +0300
Message-ID: <559BEB45.9020706@mellanox.com>
References: <20150705231831.12029.80307.stgit@build2.ogc.int>
 <20150705232158.12029.25472.stgit@build2.ogc.int>
 <559A2991.3040304@mellanox.com>
 <001e01d0b8bf$9785ff70$c691fe50$@opengridcomputing.com>
 <559BE365.4070007@mellanox.com>
 <003201d0b8c3$b7e29e00$27a7da00$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <003201d0b8c3$b7e29e00$27a7da00$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/07/2015 17:46, Steve Wise wrote:
> 
> 
>> -----Original Message-----
>> From: Haggai Eran [mailto:haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
>> Sent: Tuesday, July 07, 2015 9:34 AM
>> To: Steve Wise; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
>> Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; target-
>> devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org; bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
>> Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
>>
>> On 07/07/2015 17:17, Steve Wise wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Haggai Eran
>>>> Sent: Monday, July 06, 2015 2:09 AM
>>>> To: Steve Wise; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
>>>> Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; target-
>>>> devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org; bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
>>>> Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
>>>>
>>>> On 06/07/2015 02:22, Steve Wise wrote:
>>>>> +int rdma_device_access_flags(struct ib_pd *pd, int roles, int attrs)
>>>>> +{
>>>>> +	int access_flags = attrs;
>>>>> +
>>>>> +	if (roles & RDMA_MRR_RECV)
>>>>> +		access_flags |= IB_ACCESS_LOCAL_WRITE;
>>>>> +
>>>>> +	if (roles & RDMA_MRR_WRITE_DEST)
>>>>> +		access_flags |= IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
>>>>> +
>>>>> +	if (roles & RDMA_MRR_READ_DEST) {
>>>>> +		access_flags |= IB_ACCESS_LOCAL_WRITE;
>>>>> +		if (rdma_protocol_iwarp(pd->device,
>>>>> +					rdma_start_port(pd->device)))
>>>>> +			access_flags |= IB_ACCESS_REMOTE_WRITE;
>>>>> +	}
>>>>> +
>>>>> +	if (roles & RDMA_MRR_READ_SOURCE)
>>>>> +		access_flags |= IB_ACCESS_REMOTE_READ;
>>>>> +
>>>>> +	if (roles & RDMA_MRR_ATOMIC_DEST)
>>>>> +		access_flags |= IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_ATOMIC;
>>>>
>>>> I think you need LOCAL_WRITE for ATOMIC_SOURCE in order to receive the
>>>> results of the atomic operation.
>>>>
>>>
>>> Where/how are the results returned?  In a recv completion?  If so, then that MR would need RDMA_MRR_RECV, not
>> RDMA_MRR_ATOMIC_SOURCE.
>>
>> They are returned in the scatter list provided in ib_send_wr.sg_list,
>> similarly to how RDMA read results are returned.
> 
> Ah.  Hmm.  I was confused about how the atomic operations worked.  
> 
> Is this correct:
> 
> ib_send_wr.wr.atomic.remote_addr : the peer's address that will be the target of the atomic operation.
> ib_send_wr.wr.atomic.compare_add/compare_add_mask: the data to be used in the atomic compare-and-add on the target address
Yes, in compare and swap, this is the value to compare the original
remote data with. In fetch and add, this would be the value to add.

> ib_send_wr.wr.atomic.swap/swap_mask: the data to be used in an atomic swap on the target address.
This is used in compare and swap as the data to write if the comparison
succeeds.

> ib_send_wr.sg_list: results from the swap or compare/add.
> 
> Is the above correct? 
Pretty much. See above.

> 
> Maybe the two role names should be RDMA_MRR_ATOMIC_TARGET and RDMA_MRR_ATOMIC_RESULT?
Sounds good.

Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
