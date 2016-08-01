From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 4/5] nvme-rdma: Remove duplicate call to
 nvme_remove_namespaces
Date: Mon, 1 Aug 2016 14:21:17 +0300
Message-ID: <f196255e-b179-e3e3-8439-baebd1c62211@grimberg.me>
References: <1469822242-3477-1-git-send-email-sagi@grimberg.me>
 <1469822242-3477-5-git-send-email-sagi@grimberg.me>
 <20160801110604.GE16141@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160801110604.GE16141-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> -	nvme_remove_namespaces(&ctrl->ctrl);
>> -	nvme_rdma_shutdown_ctrl(ctrl);
>>  	nvme_uninit_ctrl(&ctrl->ctrl);
>> +	nvme_rdma_shutdown_ctrl(ctrl);
>
> How safe is the reordering here?  The description should explain why
> it's fine.

The reordering is safe because we do want everything in uninit_ctrl
(flush aen,scan and ns-remove) to happen before we shutdown the rdma
stuff. I'll add to the change log.

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
