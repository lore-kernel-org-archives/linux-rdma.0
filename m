From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 2/3] nvme-rdma: don't complete requests before a send
 work request has completed
Date: Thu, 9 Nov 2017 13:14:23 +0200
Message-ID: <0f368bc9-2e9f-4008-316c-46b85661a274@grimberg.me>
References: <20171108100616.26605-1-sagi@grimberg.me>
 <20171108100616.26605-3-sagi@grimberg.me> <20171109092110.GB16966@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171109092110.GB16966-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 11/09/2017 11:21 AM, Christoph Hellwig wrote:
>> +	}
>> +
>> +	spin_lock_irqsave(&req->lock, flags);
>> +	req->send_completed = true;
>> +	end = req->resp_completed;
>> +	spin_unlock_irqrestore(&req->lock, flags);
> 
> Wouldn't it be better to use atomic bitops (test_and_set_bit and co)
> for these flags instead of needing a irqsave lock?

Here it will be better, but in the next patch, where we need to check
also for MR invalidation atomically I don't know.

The logic is:
1. on RECV: complete if (send completed and MR invalidated)
2. on SEND: complete if (recv completed and MR invalidated)
3. on INV: complete if (recv completed and send completed)

We need the conditions to be atomic because the CQ can be processed
from two contexts (and trust me, it falls apart fast if we don't protect
it). Not sure I understand how I can achieve this with atomic bitops.

We could relax the spinlock to _bh I think as we are only racing with
irq-poll.

>>   	err = nvme_rdma_post_send(queue, sqe, req->sge, req->num_sge,
>> -			req->mr->need_inval ? &req->reg_wr.wr : NULL);
>> +			req->mr->need_inval ? &req->reg_wr.wr : NULL, true);
> 
> Looks like the unsignalled completions just removed in the last patch
> are coming back here.

That's because of the async event send, not sure why its here though,
I'll check.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
