From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] nvmet-rdma: Don't use the inline buffer in order to avoid
 allocation for small reads
Date: Wed, 3 Aug 2016 13:37:00 +0300
Message-ID: <6b40dd46-a334-09b6-f359-b7a0f2ee0d9d@grimberg.me>
References: <1470040599-7294-1-git-send-email-sagi@grimberg.me>
 <20160802125042.GB13235@lst.de>
 <157675f0-0576-1cc9-1f99-c0944185e3c5@grimberg.me>
 <20160802161526.GA14964@obsidianresearch.com> <20160803094941.GA11821@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160803094941.GA11821-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> that is currently being sent (its a rare race condition, but
>>> theoretically possible). The reason is that we repost the inline data
>>> buffer for receive before we post the send request. We used to have
>>
>> ?? The same buffer is posted at the same time for send and recv? That
>> is never OK, SRQ or not.
>
> We will never POST it for a SEND, but it would be used as the target
> of RDMA READ / WRITE operations.

Jason's comment still holds.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
