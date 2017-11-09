From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 1/3] nvme-rdma: don't suppress send completions
Date: Thu, 9 Nov 2017 10:18:58 +0100
Message-ID: <20171109091858.GA16966@lst.de>
References: <20171108100616.26605-1-sagi@grimberg.me> <20171108100616.26605-2-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171108100616.26605-2-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 08, 2017 at 12:06:14PM +0200, Sagi Grimberg wrote:
> The entire completions suppress mechanism is currently
> broken because the HCA might retry a send operation
> (due to dropped ack) after the nvme transaction has completed.
> 
> In order to handle this, we signal all send completions (besides
> async event which is not racing anything).

Oh well, so much for all these unsignalled completion optimizations..

So in which cases do unsignalled completions work at all?  Seems like
we need to fix up a lot of other ULPs as well.

Looks fine:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

> -	 */
> -	if (nvme_rdma_queue_sig_limit(queue) || flush)
> -		wr.send_flags |= IB_SEND_SIGNALED;
> +	wr.send_flags = IB_SEND_SIGNALED;

But..  Is there any benefit in just setting IB_SIGNAL_ALL_WR on the QP?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
