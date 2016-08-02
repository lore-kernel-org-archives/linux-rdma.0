From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] nvmet-rdma: Don't use the inline buffer in order to avoid
 allocation for small reads
Date: Tue, 2 Aug 2016 16:38:58 +0300
Message-ID: <157675f0-0576-1cc9-1f99-c0944185e3c5@grimberg.me>
References: <1470040599-7294-1-git-send-email-sagi@grimberg.me>
 <20160802125042.GB13235@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160802125042.GB13235-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> Under extreme conditions this might cause data corruptions. By doing that
>> we we repost the buffer and then post this buffer for the device to send.
>> If we happen to use shared receive queues the device might write to the
>> buffer before it sends it (there is no ordering between send and recv
>> queues). Without SRQs we probably won't get that if the host doesn't
>> mis-behave and send more than we allowed it, but relying on that is not
>> really a good idea.
>
> Pitty - it seems so wasteful not being able to use these buffers for
> anything that isn't an inline write.

Totally agree, I'm open to smart ideas on this...

> I fully agree on the SRQ case, but I think we should offer it for the non-SRP case.

As I wrote, even in the non-srq case, if the host is sending a single
write over the negotiated queue size, the data can land in the buffer
that is currently being sent (its a rare race condition, but
theoretically possible). The reason is that we repost the inline data
buffer for receive before we post the send request. We used to have
it the other way around (which eliminates the issue) but we then saw
some latency bubbles due to the HW sending rnr-naks to the host in
the lack of a receive buffer (in iWARP the problem was even worse
because there is no flow-control).

Do you think it's OK to risk data corruption if the host is
misbehaving?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
