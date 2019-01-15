From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Tue, 15 Jan 2019 21:58:01 +0100
Message-ID: <20190115205801.GA15432@lst.de>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca> <20190114094856.GB29604@lst.de> <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com> <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com> <20190115152029.GB2325@lst.de> <41d0616e95fb48942404fb54d82249f5700affb1.camel@vmware.com> <20190115183133.GA12350@lst.de> <c82076aa-a6ee-5ba2-a8d8-935fdbb7d5ca@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c82076aa-a6ee-5ba2-a8d8-935fdbb7d5ca@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Koenig, Christian" <Christian.Koenig@amd.com>
Cc: "hch@lst.de" <hch@lst.de>, Thomas Hellstrom <thellstrom@vmware.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yong.zhi@intel.com" <yong.zhi@intel.com>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 15, 2019 at 07:13:11PM +0000, Koenig, Christian wrote:
> Thomas is correct that the interface you propose here doesn't work at 
> all for GPUs.
> 
> The kernel driver is not informed of flush/sync, but rather just setups 
> coherent mappings between system memory and devices.
> 
> In other words you have an array of struct pages and need to map that to 
> a specific device and so create dma_addresses for the mappings.

If you want a coherent mapping you need to use dma_alloc_coherent
and dma_mmap_coherent and you are done, that is not the problem.
That actually is one of the vmgfx modes, so I don't understand what
problem we are trying to solve if you don't actually want a non-coherent
mapping.  Although last time I had that discussion with Daniel Vetter
I was under the impressions that GPUs really wanted non-coherent
mappings.

But if you want a coherent mapping you can't go to a struct page,
because on many systems you can't just map arbitrary memory as
uncachable.  It might either come from very special limited pools,
or might need other magic applied to it so that it is not visible
in the normal direct mapping, or at least not access through it.
