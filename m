From: Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: generic NVMe over Fabrics library support V2
Date: Wed, 15 Jun 2016 15:54:01 -0400
Message-ID: <20160615195401.GA7637@localhost.localdomain>
References: <1465829128-22993-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1465829128-22993-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 13, 2016 at 04:45:20PM +0200, Christoph Hellwig wrote:
> This patch set adds the necessary infrastructure for the NVMe over
> Fabrics functionality and the NVMe over Fabrics library itself.
> 
> First we add some needed parameters to NVMe request allocation such as flags
> (for reserved commands - connect and keep-alive), also support tag
> allocation of a given queue ID (for connect to be executed per-queue)
> and allow request to be queued at the head of the request queue (so
> reconnects can pass in flight I/O).
> 
> Second, we add support for additional sysfs attributes that are needed
> or useful for the Fabrics driver.
> 
> Third we add the NVMe over Fabrics related header definitions and the
> Fabrics library itself which is transport independent and handles
> Fabrics specific commands and variables.
> 
> Last, we add support for periodic keep-alive mechanism which is mandatory
> for Fabrics.
> 
> Changes from V1:
>  - don't directly free host->opts on connect failure (Sagi)
>  - blk_mq_alloc_request_hctx improvements (Ming and me)
>  - keep alive should not use blk_mq_alloc_request_hctx (me)

I only had the one comment, and Sagi says you guys already considered
it but was more complicated than it was worth. Looking at the patches
that follow, I tend to agree.

The rest looks great, and passes all the sanity tests I can run. This
time with correct email spelling:

Reviewed-by: Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
