From: Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH for-rc] IB/rdmavt: Fix frwr memory registration
Date: Mon, 15 Apr 2019 16:55:37 -0400
Message-ID: <170c1b29-6237-fc20-a148-d80bb6c4120c@talpey.com>
References: <20190415183415.24136.56776.stgit@scvm10.sc.intel.com>
 <aae2112c-9896-8807-721d-c1182867a618@talpey.com>
 <DCBFDAA3074904408488FD0876284E633C587BA1@ORSMSX115.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <DCBFDAA3074904408488FD0876284E633C587BA1@ORSMSX115.amr.corp.intel.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "Collier, Josh D" <josh.d.collier@intel.com>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Ruhl, Michael J" <michael.j.ruhl@intel.com>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 4/15/2019 4:47 PM, Collier, Josh D wrote:
> 
>> -----Original Message-----
>> From: Tom Talpey [mailto:tom@talpey.com]
>> Sent: Monday, April 15, 2019 3:15 PM
>> To: Dalessandro, Dennis <dennis.dalessandro@intel.com>; jgg@ziepe.ca;
>> dledford@redhat.com
>> Cc: linux-rdma@vger.kernel.org; Ruhl, Michael J <michael.j.ruhl@intel.com>;
>> Marciniszyn, Mike <mike.marciniszyn@intel.com>; Collier, Josh D
>> <josh.d.collier@intel.com>; stable@vger.kernel.org
>> Subject: Re: [PATCH for-rc] IB/rdmavt: Fix frwr memory registration
>>
>> On 4/15/2019 2:34 PM, Dennis Dalessandro wrote:
>>> From: Josh Collier <josh.d.collier@intel.com>
>>>
>>> Current implementation was not properly handling frwr memory
>>> registrations. This was uncovered by:
>>>     commit 27f26cec761das
>>>     xprtrdma: Plant XID in on-the-wire RDMA offset (FRWR) in which
>>> xprtrdma, which is used for NFS over RDMA, started failing as it was
>>> the first ULP to modify the ib_mr iova resulting in the NFS server
>>> getting REMOTE ACCESS ERROR when attempting to perform RDMA Writes
>> to
>>> the client.
>>>
>>> The fix is to properly capture the true iova, offset, and length in
>>> the call to ib_map_mr_sg, and then update the iova when processing the
>>> IB_WR_REG_MEM on the send queue.
>>>
>>> Fixes: a41081aa5936 ("IB/rdmavt: Add support for ib_map_mr_sg")
>>> Cc: stable@vger.kernel.org
>>> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
>>> Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>>> Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
>>> Signed-off-by: Josh Collier <josh.d.collier@intel.com>
>>> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>>> ---
>>>    drivers/infiniband/sw/rdmavt/mr.c |   17 ++++++++++-------
>>>    1 files changed, 10 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/sw/rdmavt/mr.c
>>> b/drivers/infiniband/sw/rdmavt/mr.c
>>> index 7287950..0bb6e39 100644
>>> --- a/drivers/infiniband/sw/rdmavt/mr.c
>>> +++ b/drivers/infiniband/sw/rdmavt/mr.c
>>> @@ -608,11 +608,6 @@ static int rvt_set_page(struct ib_mr *ibmr, u64
>> addr)
>>>    	if (unlikely(mapped_segs == mr->mr.max_segs))
>>>    		return -ENOMEM;
>>>
>>> -	if (mr->mr.length == 0) {
>>> -		mr->mr.user_base = addr;
>>> -		mr->mr.iova = addr;
>>> -	}
>>> -
>>>    	m = mapped_segs / RVT_SEGSZ;
>>>    	n = mapped_segs % RVT_SEGSZ;
>>>    	mr->mr.map[m]->segs[n].vaddr = (void *)addr; @@ -630,17 +625,24
>> @@
>>> static int rvt_set_page(struct ib_mr *ibmr, u64 addr)
>>>     * @sg_nents: number of entries in sg
>>>     * @sg_offset: offset in bytes into sg
>>>     *
>>> + * Overwrite rvt_mr length with mr length calculated by ib_sg_to_pages.
>>> + *
>>>     * Return: number of sg elements mapped to the memory region
>>>     */
>>>    int rvt_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
>>>    		  int sg_nents, unsigned int *sg_offset)
>>>    {
>>>    	struct rvt_mr *mr = to_imr(ibmr);
>>> +	int ret;
>>>
>>>    	mr->mr.length = 0;
>>
>> The above mr.length assignment is no longer needed, since it is
>> unconditionally overwritten several lines below.
> 
> The mr.length is still temporarily used by our rvt_set_page function effectively
> as a page index and needs to continue to be initialized for that purpose.

Hmm, ok I guess. It seems quite odd to need to initialize it
to zero just to have it set by the callee to the proper value.

>>>    	mr->mr.page_shift = PAGE_SHIFT;
>>> -	return ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset,
>>> -			      rvt_set_page);
>>> +	ret = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, rvt_set_page);
>>> +	mr->mr.user_base = ibmr->iova;
>>> +	mr->mr.iova = ibmr->iova;
>>> +	mr->mr.offset = ibmr->iova - (u64)mr->mr.map[0]->segs[0].vaddr;
>>> +	mr->mr.length = (size_t)ibmr->length;
>>> +	return ret;
>>>    }
>>>
>>>    /**
>>> @@ -671,6 +673,7 @@ int rvt_fast_reg_mr(struct rvt_qp *qp, struct ib_mr
>> *ibmr, u32 key,
>>>    	ibmr->rkey = key;
>>>    	mr->mr.lkey = key;
>>>    	mr->mr.access_flags = access;
>>> +	mr->mr.iova = ibmr->iova;
>>
>> Isn't this a redundant assignment? If it isn't, then why is the
>> mr->mr.offset not being recalculated?
> 
> The ib_mr iova can be changed by the ULP to any value, but any value should
> index to the previously mapped MR's starting page and offset, hence those do
> not change, and we only update the iova.

Ah, got it. The ULP changes iova between the map and the fastreg,
so the mr captures the fastreg value. Agreed.

Tom.

> 
>>
>>>    	atomic_set(&mr->mr.lkey_invalid, 0);
>>>
>>>    	return 0;
>>>
>>>
>>>
