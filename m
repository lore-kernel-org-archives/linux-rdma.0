From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH WIP 37/43] xprtrdma: Port to new memory registration API
Date: Wed, 22 Jul 2015 09:59:26 -0700
Message-ID: <20150722165926.GD6443@infradead.org>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-38-git-send-email-sagig@mellanox.com>
 <795F4F28-D92F-46A1-8DA3-2B1B19A17AA3@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <795F4F28-D92F-46A1-8DA3-2B1B19A17AA3-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 22, 2015 at 11:03:49AM -0400, Chuck Lever wrote:
> I like this (and the matching ib_dma_unmap_sg). But why wouldn?t
> this function be called ib_dma_map_sg() ? The name ib_map_mr_sg()
> had me thinking for a moment that this API actually posted the
> FASTREG WR, but I see that it doesn?t.

We already have a ib_dma_map_sg, which is a wrapper around dma_map_sg
that allows ehc ipath amd qib to do naughty things instead of the
regular dma mapping.

But it seems maybe the dma_map_sg calls or the magic for those other
drivers should be folded into Sagi's new API as those HCA apparently
don't need physical addresses and thus the S/G list.

God knows what's they're doing with a list of virtual addresses, but
removing the struct scatterlist abuse there would be highly welcome.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
