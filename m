From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 09/16] IB/hfi1: Clean up pin_vector_pages()
 function
Date: Sun, 27 Aug 2017 22:00:21 -0700
Message-ID: <59A3A365.3060003@intel.com>
References: <20170822011657.32701.22207.stgit@scvm10.sc.intel.com>
 <20170822012702.32701.90032.stgit@scvm10.sc.intel.com>
 <20170822154659.GE1724@mtr-leonro.local> <599C7A74.9010301@intel.com>
 <20170823044900.GK1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170823044900.GK1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 08/22/2017 09:49 PM, Leon Romanovsky wrote:
> On Tue, Aug 22, 2017 at 11:39:48AM -0700, Harish Chegondi wrote:
>>
>>
>> On 08/22/2017 08:46 AM, Leon Romanovsky wrote:
>>> On Mon, Aug 21, 2017 at 06:27:03PM -0700, Dennis Dalessandro wrote:
>>>> From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>
>>>> Clean up pin_vector_pages() function by moving page pinning related code
>>>> to a separate function since it really stands on its own.
>>>>
>>>> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>> Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>> ---
>>>>  drivers/infiniband/hw/hfi1/user_sdma.c |   79 ++++++++++++++++++--------------
>>>>  1 files changed, 45 insertions(+), 34 deletions(-)
>>>>
>>>> diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
>>>> index d5a2572..6f26253 100644
>>>> --- a/drivers/infiniband/hw/hfi1/user_sdma.c
>>>> +++ b/drivers/infiniband/hw/hfi1/user_sdma.c
>>>> @@ -1124,11 +1124,53 @@ static u32 sdma_cache_evict(struct hfi1_user_sdma_pkt_q *pq, u32 npages)
>>>>  	return evict_data.cleared;
>>>>  }
>>>>
>>>> +static int pin_sdma_pages(struct user_sdma_request *req,
>>>> +			  struct user_sdma_iovec *iovec,
>>>> +			  struct sdma_mmu_node *node,
>>>> +			  int npages)
>>>> +{
>>>> +	int pinned, cleared;
>>>> +	struct page **pages;
>>>> +	struct hfi1_user_sdma_pkt_q *pq = req->pq;
>>>> +
>>>> +	pages = kcalloc(npages, sizeof(*pages), GFP_KERNEL);
>>>> +	if (!pages) {
>>>> +		SDMA_DBG(req, "Failed page array alloc");
>>>
>>> Please don't add prints after k[c|m|z]alloc failures, despite the fact
>>> that it was before.
>>>
>>> Thanks
>>
>> SDMA_DBG MACRO is a trace for development debugging. It's not a print.
>>
> 
> No problem, I'll rephrase it for you.
> 
> Please don't add prints, tracepoints, debug output and SDMA_DBG after k[c|m|z]alloc failures,
> despite the fact that it was before.
> 
> Tracepoints output will be less worry for you if your kcalloc starts to fail.
> 
> Is it clear enough now?
>>
> Thanks,
> 

Ok. I will remove the SDMA_DBG trace print. But I think removing the trace print has to be done in a separate patch. I will soon submit another patch that removes the trace print.

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
