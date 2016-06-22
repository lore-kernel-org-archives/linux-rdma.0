From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 25/25] IB/mlx4: Workaround for mlx4_alloc_priv_pages()
 array allocator
Date: Wed, 22 Jun 2016 09:20:51 -0700
Message-ID: <20160622162051.GA23929@infradead.org>
References: <20160620155751.10809.22262.stgit@manet.1015granger.net>
 <20160620161200.10809.45762.stgit@manet.1015granger.net>
 <576A9AE6.4070500@grimberg.me>
 <A9F49204-8E84-4B58-BAA4-5B4B360FD22F@oracle.com>
 <20160622155003.GI9762@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160622155003.GI9762-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Wed, Jun 22, 2016 at 06:50:03PM +0300, Leon Romanovsky wrote:
> According to [1] dma_alloc_coherent doesn't allocate from pool, but
> calls to the __get_free_page().

Use the source luke!  dma_alloc_coherent implementations vary widely.
While some indeed use alloc_pages there are various complications,
especially on non-x86 architectures, or if the dma mask is not the full
64 bits allowed.

> "A DMA pool is an allocation mechanism for small, coherent DMA mappings.
> Mappings obtained from dma_alloc_coherent may have a minimum size of one
> page."

Just because it's not using the dma_pool_* API it could allocate from
various resource constrained pools.  A trivial example for that is
the swiotlb used for address limited devices if no hardware IOMMU
is available, but other architectures have even more complicated
implementations by default.  Take a look at
arch/arm/mm/dma-mapping.c:__dma_alloc() for fun.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
