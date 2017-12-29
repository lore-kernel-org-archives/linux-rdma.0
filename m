From: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 for-next 1/2] RDMA/hns: Add detailed comments for mb()
 call
Date: Fri, 29 Dec 2017 18:19:59 +0800
Message-ID: <273ca54f-1b09-d80f-a542-e39b926d1ded@huawei.com>
References: <1514470683-6972-1-git-send-email-liuyixian@huawei.com>
 <1514470683-6972-2-git-send-email-liuyixian@huawei.com>
 <20171228155519.GT25436@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171228155519.GT25436-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/12/28 23:55, Jason Gunthorpe wrote:
> On Thu, Dec 28, 2017 at 10:18:02PM +0800, Yixian Liu wrote:
>> This patch adds more detailed comments when we call the
>> memory barrier function, such as rmb, wmb and mb. Three
>> mb() callers are deleted since they are unnecessary.
>>
>> v3:
>> 1. Subsitute rmb() with dma_rmb() according to Jason's comment,
>>    since using dma_rmb() is enough.
> 
> This is such a big improvement, thanks
> 
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
>> index 6100ace..47ef90b 100644
>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
>> @@ -3963,7 +3963,10 @@ static void set_eq_cons_index_v1(struct hns_roce_eq *eq, int req_not)
>>  {
>>  	roce_raw_write((eq->cons_index & HNS_ROCE_V1_CONS_IDX_M) |
>>  		      (req_not << eq->log_entries), eq->doorbell);
>> -	/* Memory barrier */
>> +
>> +	/* Make sure we update the consumer index of EQ before
>> +	 * accessing it later
>> +	 */
>>  	mb();
>>  }
> 
> This (and the other one below like it) is the only one that puzzles
> me..
> 
> What are you trying to accomplish here? It looks like cons_index is
> the tail pointer for a ring that the device DMA's into? And the
> dma_rmb seems properly placed, so no barrier should be needed for DMA
> when updating the tail pointer.
> 
> Is the barrier attempting to protect eq->cons_index in system memory?
> If yes, shouldn't it be an atomic and/or locked?
> 
> Jason
> 

You are right, here it write to the device register, so there is no need
to put a barrier there. I will eliminate them in patch v4.

Thanks.

> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
