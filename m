From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 3/5] nvme-rdma: Make sure to shutdown the controller if
	we can
Date: Mon, 1 Aug 2016 17:48:40 +0200
Message-ID: <20160801154840.GB22771@lst.de>
References: <1469822242-3477-1-git-send-email-sagi@grimberg.me> <1469822242-3477-4-git-send-email-sagi@grimberg.me> <20160801110446.GD16141@lst.de> <63b33585-3fd2-a497-94a1-34dc9484da99@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <63b33585-3fd2-a497-94a1-34dc9484da99-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 01, 2016 at 02:17:37PM +0300, Sagi Grimberg wrote:
>>> -	if (ctrl->ctrl.state == NVME_CTRL_LIVE)
>>> +	if (test_bit(NVME_RDMA_Q_CONNECTED, &ctrl->queues[0].flags))
>>>  		nvme_shutdown_ctrl(&ctrl->ctrl);
>>>
>>>  	blk_mq_stop_hw_queues(ctrl->ctrl.admin_q);
>>
>> Maybe the right way to handle this is to unconditionally call
>> nvme_shutdown_ctrl and make sure we return an early error
>> on the register write?
>
> As I wrote on patch 2/5 reply, I'd like to avoid depending on
> queue_rq to fail early peeking at the ctrl state. This dependency
> can grow in the future and I think we should at least try not to
> go there...

I don't want ->queue_rq to peek at controller state.  What I had
in mind was copying the PCIe behavior of failing early in the
timeout handler if we are in the reset handler, which will
mean blk_execute_rq will return ASAP with an error.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
