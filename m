From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH WIP 40/43] mlx5: Allocate private context for arbitrary
 scatterlist registration
Date: Thu, 23 Jul 2015 02:25:32 -0700
Message-ID: <20150723092532.GC32592@infradead.org>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-41-git-send-email-sagig@mellanox.com>
 <20150722173048.GF26909@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150722173048.GF26909-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 22, 2015 at 11:30:48AM -0600, Jason Gunthorpe wrote:
> On Wed, Jul 22, 2015 at 09:55:40AM +0300, Sagi Grimberg wrote:
> > +	size += max_t(int, MLX5_UMR_ALIGN - ARCH_KMALLOC_MINALIGN, 0);
> > +	mr->klms = kzalloc(size, GFP_KERNEL);
> > +	if (!mr->klms)
> > +		return -ENOMEM;
> > +
> > +	mr->pl_map = dma_map_single(device->dma_device, mr->klms,
> > +				    size, DMA_TO_DEVICE);
> 
> This is a misuse of the DMA API, you must call dma_map_single after
> the memory is set by the CPU, not before.
>
> The fast reg varient is using coherent allocations, which is OK..

It's fine as long as you dma_sync_*_for_{cpu,device} in the right
places, which is what a lot of drivers do for longer held allocations.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
