From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Sun, 21 Jan 2018 13:40:13 -0700
Message-ID: <20180121204013.GB14372@ziepe.ca>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180112163247.GB15974@ziepe.ca>
 <1515775567.131759.42.camel@gmail.com>
 <a40e44f4-106b-1075-8f92-f7741508372c@oracle.com>
 <af562737-4a3e-0429-1fd6-fc25c3e3f867@mellanox.com>
 <fea0aa1c-b68e-9485-3826-2dfad7824911@oracle.com>
 <53b1ac4d-a294-eb98-149e-65d7954243da@oracle.com>
 <1516376999.3606.39.camel@gmail.com>
 <dfc02a48-7d2a-56da-dc4e-d90a9fcc559c@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dfc02a48-7d2a-56da-dc4e-d90a9fcc559c@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, "jianchao.wang" <jianchao.w.wang@oracle.com>, junxiao.bi@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

> Hmm, this is actually consistent with the example below [1].
> 
> AIU from the example, it seems that the dma_wmb/dma_rmb barriers are good
> for synchronizing cpu/device accesses to the "Streaming DMA mapped" buffers
> (the descriptors, went through the dma_map_page() API), but not for the
> doorbell (a coherent memory, typically allocated via dma_alloc_coherent)
> that requires using the stronger wmb() barrier.

If x86 truely requires a wmb() (aka SFENCE) here then the userspace
RDMA stuff is broken too, and that has been tested to death at this
point..

I looked into this at one point and I thought I concluded that x86 did
not require a SFENCE between a posted PCI write and writes to system
memory to guarnetee order with-respect-to the PCI device?

Well, so long as non-temporal stores and other specialty accesses are
not being used.. Is there a chance a fancy sse optimized memcpy or
memset, crypto or something is being involved here?

However, Documentation/memory-barriers.txt does seem pretty clear that
the kernel definition of wmb() makes it required here, even if it
might be overkill for x86?

Jason
