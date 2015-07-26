From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 04/15] xprtrdma: Don't fall back to PHYSICAL memory
 registration
Date: Sun, 26 Jul 2015 09:50:31 -0700
Message-ID: <20150726165031.GB9273@infradead.org>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net>
 <20150720190302.10997.86410.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150720190302.10997.86410.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 20, 2015 at 03:03:02PM -0400, Chuck Lever wrote:
> PHYSICAL memory registration uses a single rkey for all of the
> client's memory, thus is insecure. It is still useful in some cases
> for testing.
> 
> Retain the ability to select PHYSICAL memory registration capability
> via /proc/sys/sunrpc/rdma_memreg_strategy, but don't fall back to it
> if the HCA does not support FRWR or FMR.
> 
> This means amso1100 no longer works out of the box with NFS/RDMA.
> When using amso1100 HCAs, set the memreg_strategy sysctl to 6 before
> performing NFS/RDMA mounts.

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
