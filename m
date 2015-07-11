From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 04/12] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Sat, 11 Jul 2015 03:34:28 -0700
Message-ID: <20150711103428.GD14741@infradead.org>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net>
 <20150709204218.26247.67243.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150709204218.26247.67243.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 09, 2015 at 04:42:18PM -0400, Chuck Lever wrote:
> All HCA providers have an ib_get_dma_mr() verb. Thus
> rpcrdma_ia_open() will either grab the device's local_dma_key if one
> is available, or it will call ib_get_dma_mr() which is a 100%
> guaranteed fallback. There is never any need to use the
> ib_reg_phys_mr() code path in rpcrdma_register_internal(), so it can
> be removed.

Can you also send a follow-on to remove ib_reg_phys_mr entirely from
all core (= non-staging) code?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
