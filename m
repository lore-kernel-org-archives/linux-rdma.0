From: Steve Wise <swise@chelsio.com>
Subject: Re: [PATCH RFC] iw_cxgb4: drop check - dead code
Date: Wed, 23 Jan 2019 12:43:15 -0600
Message-ID: <762bd516-b357-fb51-510e-ccce6215e281@chelsio.com>
References: <1547947633-10515-1-git-send-email-hofrat@osadl.org>
 <20190123183008.GA15698@ziepe.ca>
Reply-To: swise@chelsio.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190123183008.GA15698@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Nicholas Mc Guire <hofrat@osadl.org>
Cc: Doug Ledford <dledford@redhat.com>, Raju Rangoju <rajur@chelsio.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 1/23/2019 12:30 PM, Jason Gunthorpe wrote:
> On Sun, Jan 20, 2019 at 02:27:13AM +0100, Nicholas Mc Guire wrote:
>> The kmalloc is called with  | __GFP_NOFAIL  so there is no point in
>> checking the return value - it either returns valid storage or it would
>> hang/terminate there. But it is not possible to say if the use of
>> __GFP_NOFAIL is really needed and the check should be removed or
>> vice-versa (use of __GFP_NOFAIL should be only in exceptional
>> cases as I understand it and alloc_srq_queue() is called in quite
>> a few places)
>> In either way it would need fixing.
>>
>> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
>> Fixes: 6a0b6174d35a ("rdma/cxgb4: Add support for kernel mode SRQ's")
>> ---
> 
> Steve? It seems weird to have NOFAIL and then have an error unwind
> path, what is the deal here?
> 
>> diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
>> index 917ce5c..c2a12ba 100644
>> --- a/drivers/infiniband/hw/cxgb4/qp.c
>> +++ b/drivers/infiniband/hw/cxgb4/qp.c
>> @@ -2597,8 +2597,6 @@ static int alloc_srq_queue(struct c4iw_srq *srq, struct c4iw_dev_ucontext *uctx,
>>  	wr_len = sizeof(*res_wr) + sizeof(*res);
>>  
>>  	skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
>> -	if (!skb)
>> -		goto err_free_queue;
>>  	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
>>  
>>  	res_wr = (struct fw_ri_res_wr *)__skb_put(skb, wr_len);
>> -- 
>> 2.1.4
>>

The other queue allocations in qp.c don't use __GFP_NOFAIL.  So either
leave it and remove the error check as per this patch, or remove the
NOFAIL and leave the check.

I suggest you remove the __GFP_NOFAIL.


Steve.
