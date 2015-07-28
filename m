From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 00/10] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Tue, 28 Jul 2015 16:10:50 -0600
Message-ID: <20150728221050.GA1279@obsidianresearch.com>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <mp85i7$6hc$1@ger.gmane.org>
 <20150728182356.GA1712@obsidianresearch.com>
 <mp8qgu$nt0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <mp8qgu$nt0$1@ger.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 28, 2015 at 04:58:29PM -0400, J.L. Burr wrote:

> Is there some way now (in upstream kernels) to create a MR with an 
> arbitrary (and large) physical address range?  That would be great!  I 
> didn't see a way to do that when I started on this journey (about 4 
> years ago).

The FRWR API can do this, but it depends on each card if it can manage
the page list table or not.

You'd need to check page_size_cap and max_map_per_fmr for your card to
see.

Basically use an array of the largest page size your adaptor will
support.

Eg mlx5 supports any page size above 4k, so you can do any PCI BAR
with a single FRWR page table entry.

mlx4 seems to top out at 2G pages (which may just be the driver being
silly) so you'd need 64k page entries, no idea if it can do that or
not..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
