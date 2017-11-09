From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 3/3] nvme-rdma: wait for local invalidation before
        completing a request
Date: Thu, 9 Nov 2017 10:39:45 +0100
Message-ID: <20171109093945.GB17515@lst.de>
References: <20171108100616.26605-1-sagi@grimberg.me> <20171108100616.26605-4-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171108100616.26605-4-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 08, 2017 at 12:06:16PM +0200, Sagi Grimberg wrote:
> We must not complete a request before the host memory region is
> invalidated. Luckily we have send with invalidate protocol support
> so we usually don't need to execute it, but in case the target
> did not invalidate a memory region for us, we must wait for
> the invalidation to complete before unmapping host memory and
> completing the I/O.

Looks good, but a change to atomic bitops would require a respin
here as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
