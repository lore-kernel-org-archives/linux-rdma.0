From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH] nvmet-rdma: Fix missing dma sync to nvme data
        structures
Date: Fri, 13 Jan 2017 08:44:20 +0100
Message-ID: <20170113074420.GA25814@lst.de>
References: <1484261109-3316-1-git-send-email-parav@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484261109-3316-1-git-send-email-parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 12, 2017 at 04:45:09PM -0600, Parav Pandit wrote:
> This patch performs dma sync operations on nvme_commmand,
> inline page(s) and nvme_completion.
> 
> nvme_command and write cmd inline data is synced
> (a) on receiving of the recv queue completion for cpu access.
> (b) before posting recv wqe back to rdma adapter for device access.
> 
> nvme_completion is synced
> (a) on receiving send completion for nvme_completion for cpu access.
> (b) before posting send wqe to rdma adapter for device access.
> 
> Pushing this patch through linux-rdma tree as its more relavant with
> Bart's changes for dma_map_ops of[1].
> 
> [1] https://patchwork.kernel.org/patch/9514085/

This seems like a fix for 4.10-rc as the old code is buggy on
not DMA coherent architectures, so I suspect it should go in without
being based on Barts cleanup.

Btw, what architecture did you test this with?  One of the not coherent
ARM SOCs?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
