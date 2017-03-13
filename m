From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH rfc 06/10] IB/cq: Don't force IB_POLL_DIRECT poll context
 for ib_process_cq_direct
Date: Mon, 13 Mar 2017 10:24:40 +0200
Message-ID: <f4ade02b-9d17-20ae-f910-47c718f2a5bd@grimberg.me>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
 <1489065402-14757-7-git-send-email-sagi@grimberg.me>
 <1489077040.2597.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1489077040.2597.3.camel@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


>> polling the completion queue directly does not interfere
>> with the existing polling logic, hence drop the requirement.
>>
>> This can be used for polling mode ULPs.
>>
>> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
>> ---
>>  drivers/infiniband/core/cq.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
>> index 21d1a38af489..7f6ae0ecb0c5 100644
>> --- a/drivers/infiniband/core/cq.c
>> +++ b/drivers/infiniband/core/cq.c
>> @@ -64,8 +64,6 @@ static int __ib_process_cq(struct ib_cq *cq, int budget)
>>   */
>>  int ib_process_cq_direct(struct ib_cq *cq, int budget)
>>  {
>> -	WARN_ON_ONCE(cq->poll_ctx != IB_POLL_DIRECT);
>> -
>>  	return __ib_process_cq(cq, budget);
>>  }
>>  EXPORT_SYMBOL(ib_process_cq_direct);
>
> Using ib_process_cq_direct() for queues that have another type than
> IB_POLL_DIRECT may trigger concurrent CQ processing.

Correct.

> Before this patch
> the completions from each CQ were processed sequentially. That's a big
> change so I think this should be mentioned clearly in the header above
> ib_process_cq_direct().

Note that I now see that the cq lock is not sufficient for mutual
exclusion here because we're referencing cq->wc array outside of it.

There are three options I see here:
1. we'll need to allocate a different wc array for polling mode,
perhaps a smaller one?
2. Export __ib_process_cq (in some form) with an option to pass in a wc
array.
3. Simply not support non-selective polling but it seems like a shame...

Any thoughts?
