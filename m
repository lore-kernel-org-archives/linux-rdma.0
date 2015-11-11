From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH RFC 2/3] svcrdma: Use device rdma_read_access_flags
Date: Wed, 11 Nov 2015 00:07:27 -0800
Message-ID: <20151111080727.GC31508@infradead.org>
References: <1447152255-28231-3-git-send-email-sagig@mellanox.com>
 <20151110114145.GA2810@infradead.org>
 <5641D920.5000409@mellanox.com>
 <20151110120432.GA8230@infradead.org>
 <20151110182546.GI12667@obsidianresearch.com>
 <56425AFB.30202@talpey.com>
 <20151110211716.GA21631@obsidianresearch.com>
 <564261EF.4000008@talpey.com>
 <54CF0111-E9C4-4196-BF92-7E134A6A329A@oracle.com>
 <20151110235551.GA12795@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110235551.GA12795-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 04:55:51PM -0700, Jason Gunthorpe wrote:
> IMHO, the break point for when it makes sense to switch from a RDMA
> READ chain to a MR is going to be a RDMA core tunable. The performance
> curve won't have much to do with the ULP.

core/device, a lot of it depends on when we'd exceed the nr_sge limit
as well.  But yes, it needs to move out ot the ULP and into the core,
the ULP has no business here.

As said a few times before we need a core API that takes a struct
scatterlist and builds RDMA READ/WRITE requests from it in an efficient
way.  I have started talking to Sagi and preparing some build blocks
for it, but getting all corner cases right will take a while.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
