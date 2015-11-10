From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 2/3] svcrdma: Use device rdma_read_access_flags
Date: Tue, 10 Nov 2015 16:55:51 -0700
Message-ID: <20151110235551.GA12795@obsidianresearch.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-3-git-send-email-sagig@mellanox.com>
 <20151110114145.GA2810@infradead.org>
 <5641D920.5000409@mellanox.com>
 <20151110120432.GA8230@infradead.org>
 <20151110182546.GI12667@obsidianresearch.com>
 <56425AFB.30202@talpey.com>
 <20151110211716.GA21631@obsidianresearch.com>
 <564261EF.4000008@talpey.com>
 <54CF0111-E9C4-4196-BF92-7E134A6A329A@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54CF0111-E9C4-4196-BF92-7E134A6A329A-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 06:01:01PM -0500, Chuck Lever wrote:
> The current mechanism of statically choosing either FRMR or
> local DMA depending on the device is probably not adequate.
> Maybe we could post all the Read WRs via a single chain? Or
> stick with FRMR when the amount of data to read is significant.

Yes, those are the right ways to go..

IMHO, the break point for when it makes sense to switch from a RDMA
READ chain to a MR is going to be a RDMA core tunable. The performance
curve won't have much to do with the ULP.

But certainly, if a requests fits in the SG list then it should just
use the local dma lkey directly, and consider allocating an
appropriate S/G list size when creating the QP.

The special thing about iwarp becomes simply defeating the use of the
local dma lkey for RDMA READ.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
