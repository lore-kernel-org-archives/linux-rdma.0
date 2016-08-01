From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/5] nvme-rdma: Free the I/O tags when we delete the
	controller
Date: Mon, 1 Aug 2016 17:47:17 +0200
Message-ID: <20160801154717.GA22771@lst.de>
References: <1469822242-3477-1-git-send-email-sagi@grimberg.me> <1469822242-3477-3-git-send-email-sagi@grimberg.me> <20160801110308.GC16141@lst.de> <c2c194b0-d0a1-11af-cae9-a4ce8ea8fdde@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c2c194b0-d0a1-11af-cae9-a4ce8ea8fdde-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 01, 2016 at 02:15:59PM +0300, Sagi Grimberg wrote:
>> or in a second step we should probably always call shutdown_ctrl
>> but skip the actual shutdown if the ctrl state doesn't require it.
>
> What do you mean "if the ctrl state doesn't require it"?
> Up until today we managed to avoid checking the ctrl state
> in queue_rq and I'd like to keep it that way. I'd be much
> happier if we don't depend on queue_rq to fail early under
> some assumptions, it might be a slippery slope...

In this case I actually thought about checking the state in
the new __nvme_rdma_remove_ctrl.  If called from
nvme_rdma_del_ctrl_work the state will be NVME_CTRL_DELETING,
so we can check that to see if we want to do a controlled
shutdown using nvme_rdma_shutdown_ctrl instead of having
to overwrite ->remove_work.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
