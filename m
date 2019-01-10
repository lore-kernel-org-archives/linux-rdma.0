From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Thu, 10 Jan 2019 16:42:18 -0700
Message-ID: <20190110234218.GM6890@ziepe.ca>
References: <20190104223531.GA1705@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190104223531.GA1705@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Cc: Shiraz Saleem <shiraz.saleem@intel.com>, Imre Deak <imre.deak@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, linux-media@vger.kernel.org, Yong Zhi <yong.zhi@intel.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Bingbu Cao <bingbu.cao@intel.com>, Tian Shu Qiu <tian.shu.qiu@intel.com>, Jian Xu Zheng <jian.xu.zheng@intel.com>, Sinclair Yeh <syeh@vmware.com>, Thomas Hellstrom <thellstrom@vmware.com>, dri-devel@lists.freedesktop.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 04, 2019 at 03:35:31PM -0700, Jason Gunthorpe wrote:
> Commit 2db76d7c3c6d ("lib/scatterlist: sg_page_iter: support sg lists w/o
> backing pages") introduced the sg_page_iter_dma_address() function without
> providing a way to use it in the general case. If the sg_dma_len is not
> equal to the dma_length callers cannot safely use the
> for_each_sg_page/sg_page_iter_dma_address combination.
> 
> Resolve this API mistake by providing a DMA specific iterator,
> for_each_sg_dma_page(), that uses the right length so
> sg_page_iter_dma_address() works as expected with all sglists. A new
> iterator type is introduced to provide compile-time safety against wrongly
> mixing accessors and iterators.
> 
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.h        | 26 ++++++++++--
>  drivers/gpu/drm/vmwgfx/vmwgfx_mob.c        | 26 +++++++-----
>  drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c | 42 +++++++++++++------
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c   |  4 +-
>  include/linux/scatterlist.h                | 49 ++++++++++++++++++----
>  lib/scatterlist.c                          | 26 ++++++++++++
>  6 files changed, 134 insertions(+), 39 deletions(-)
> 
> I'd like to run this patch through the RDMA tree as we have another
> series in the works that wants to use the for_each_sg_dma_page() API.
> 
> The changes to vmwgfx make me nervous, it would be great if someone
> could test and ack them?
> 
> Changes since the RFC:
> - Rework vmwgfx too [CH]
> - Use a distinct type for the DMA page iterator [CH]
> - Do not have a #ifdef [CH]

ChristophH: Will you ack?

Are you still OK with the vmwgfx reworking, or should we go back to
the original version that didn't have the type safety so this driver
can be left broken?

Thanks,
Jason
