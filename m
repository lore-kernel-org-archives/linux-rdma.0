From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: garbage collect old memory registration code
Date: Mon, 23 Nov 2015 10:58:44 -0700
Message-ID: <20151123175844.GA32085@obsidianresearch.com>
References: <1447610762-3781-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447610762-3781-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 15, 2015 at 07:05:53PM +0100, Christoph Hellwig wrote:
> This series removes huge chunks of code related to old memory
> registration methods that we don't use anymore.
> 
> This expects my "IB: merge struct ib_device_attr into struct ib_device"
> patch to be already applied.
> 
> Also available as a git tree:
> 
> 	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-mr-cleanups
> 	git://git.infradead.org/users/hch/rdma.git rdma-mr-cleanups

Only looked carefully at the core changes here, but they look good to
me. Thanks for doing this.

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
(for core bits)

Driver changes look pretty much trivial too me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
