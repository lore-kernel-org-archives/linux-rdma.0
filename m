From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 00/10] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Tue, 28 Jul 2015 12:23:56 -0600
Message-ID: <20150728182356.GA1712@obsidianresearch.com>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <mp85i7$6hc$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <mp85i7$6hc$1@ger.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 28, 2015 at 11:01:12AM -0400, J.L. Burr wrote:
 
> We use ib_get_dma_mr with IB_ACCESS_REMOTE_* flags in an embedded
> device environment (in a custom out-of-tree device driver).  Not to
> allow remote access to CPU memory but to allow remote access to PCIe
> device memory (the IB card makes peer accesses directly to other
> PCIe devices).

Why can't you create a proper MR that only exposes the PCI device's
BAR?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
