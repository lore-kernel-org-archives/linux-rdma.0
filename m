From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] nvmet-rdma: Invoke fatal error on error completion
Date: Fri, 24 Jun 2016 00:11:01 -0700
Message-ID: <20160624071101.GC4252@infradead.org>
References: <1466701290-10356-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466701290-10356-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 23, 2016 at 08:01:30PM +0300, Sagi Grimberg wrote:
> In case we got an error completion the rdma queue pair
> is in error state, teardown the entire controller. Note
> that in recv or read error completion we might not have
> a controller yet, so check for the controller exsistence.
> 
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

This looks fine minus a few minor codingstyle nitpicks that I'd be
happy to fix up:

> +static void nvmet_rdma_error_comp(struct nvmet_rdma_queue *queue)
> +{
> +	if (queue->nvme_sq.ctrl)
> +		nvmet_ctrl_fatal_error(queue->nvme_sq.ctrl);
> +	else
> +		/*
> +		 * we didn't setup the controller yet in case
> +		 * of admin connect error, just disconnect and
> +		 * cleanup the queue
> +		 */
> +		nvmet_rdma_queue_disconnect(queue);
> +}

With such a long comment I'd prefer to have curly braces just to make
the else visually more obvious
> +
> +	if (unlikely(wc->status != IB_WC_SUCCESS &&
> +		wc->status != IB_WC_WR_FLUSH_ERR)) {

Indenting the second line of a condition by a single tab is always wrong,
either indent it with two tabs, or so that it aligns with first line.
The second is probably nicer here:

	if (unlikely(wc->status != IB_WC_SUCCESS &&
		     wc->status != IB_WC_WR_FLUSH_ERR)) {

Given how many !success not !flush_err conditionals we have in various
drivers I wonder if we should have a helper in the RDMA core, though.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
