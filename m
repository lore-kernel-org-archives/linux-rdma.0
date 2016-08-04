From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH] nvmet-rdma: Don't use the inline buffer in order to
	avoid allocation for small reads
Date: Thu, 4 Aug 2016 13:49:38 +0200
Message-ID: <20160804114938.GA32487@lst.de>
References: <1470040599-7294-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470040599-7294-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 01, 2016 at 11:36:39AM +0300, Sagi Grimberg wrote:
> Under extreme conditions this might cause data corruptions. By doing that
> we we repost the buffer and then post this buffer for the device to send.
> If we happen to use shared receive queues the device might write to the
> buffer before it sends it (there is no ordering between send and recv
> queues). Without SRQs we probably won't get that if the host doesn't
> mis-behave and send more than we allowed it, but relying on that is not
> really a good idea.

Allright, after the discussion:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
