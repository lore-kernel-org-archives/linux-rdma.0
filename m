From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2] nvmet-rdma: Fix a possible uninitialized variable
        dereference
Date: Mon, 13 Mar 2017 20:56:50 +0100
Message-ID: <20170313195650.GA9648@lst.de>
References: <1489412381-28947-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489412381-28947-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 13, 2017 at 03:39:41PM +0200, Sagi Grimberg wrote:
> When handling a new recv command, we grab a new rsp resource and
> check for the queue state being live. In case the queue is not in
> live state, we simply restore the rsp back to the free list. However
> in this flow we didn't set rsp->queue yet, so we cannot dereference it.
> 
> Instead, make sure to initialize rsp->queue (and other rsp members)
> as soon as possible so we won't reference uninitialized variables.

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
