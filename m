From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 3/5] nvme-rdma: Make sure to shutdown the controller if we
 can
Date: Tue, 2 Aug 2016 09:19:56 +0300
Message-ID: <cf6b0293-aba9-1a6f-28f2-3754b2eec4af@grimberg.me>
References: <1469822242-3477-1-git-send-email-sagi@grimberg.me>
 <1469822242-3477-4-git-send-email-sagi@grimberg.me>
 <20160801110446.GD16141@lst.de>
 <63b33585-3fd2-a497-94a1-34dc9484da99@grimberg.me>
 <20160801154840.GB22771@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160801154840.GB22771-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>>> -	if (ctrl->ctrl.state == NVME_CTRL_LIVE)
>>>> +	if (test_bit(NVME_RDMA_Q_CONNECTED, &ctrl->queues[0].flags))
>>>>  		nvme_shutdown_ctrl(&ctrl->ctrl);
>>>>
>>>>  	blk_mq_stop_hw_queues(ctrl->ctrl.admin_q);
>>>
>>> Maybe the right way to handle this is to unconditionally call
>>> nvme_shutdown_ctrl and make sure we return an early error
>>> on the register write?
>>
>> As I wrote on patch 2/5 reply, I'd like to avoid depending on
>> queue_rq to fail early peeking at the ctrl state. This dependency
>> can grow in the future and I think we should at least try not to
>> go there...
>
> I don't want ->queue_rq to peek at controller state.  What I had
> in mind was copying the PCIe behavior of failing early in the
> timeout handler if we are in the reset handler, which will
> mean blk_execute_rq will return ASAP with an error.

Do we want the unnecessary ADMIN_TIMEOUT for sending a shutdown
on a queue we know is not connected? I'm worried it will have scale
issues...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
