From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: RDMA/cxgb4: Support on-chip SQs
Date: Thu, 31 Jan 2013 00:45:55 +0300
Message-ID: <20130130214555.GA4989@mwanda>
References: <20130130210006.GA22134@elgon.mountain>
 <51099270.5070406@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51099270.5070406-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 30, 2013 at 03:36:48PM -0600, Steve Wise wrote:
> I wonder, then, what the correct service is to get the cpu physical
> address from a kernel virtual address returned from
> dma_alloc_coherent()?  I think this is correct as-is, since I think
> dma_alloc_coherent() falls under the "directly mapped" addresses in
> the virt_to_phys() prototype comment.
> 

Here is another relevant comment I should have included.

commit ae6a5d37725853325a2b3460165fbc5613ce2916
Author: Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Date:   Tue Nov 20 12:17:51 2012 +0000

    ASoC: kirkwood-dma: fix use of virt_to_phys()

    This is part of a patch found in Rabeeh Khoury's git tree for the
    cubox.

    You can not use virt_to_phys() on the address returned from
    dma_alloc_coherent(); it may not be part of the kernel direct-mapped
    memory.  Fix this to use the DMA address instead.

    Signed-off-by: Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
    Signed-off-by: Mark Brown <broonie-yzvPICuk2AATkU/dhu1WVueM+bqZidxxQQ4Iyu8u01E@public.gmane.org>

I don't know the details though, and I certainly don't know how
someone would fix this.  ;)

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
