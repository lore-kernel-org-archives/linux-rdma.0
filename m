From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] lib/scatterlist: Provide a DMA page iterator
Date: Mon, 11 Feb 2019 15:26:54 -0700
Message-ID: <20190211222654.GA15746@ziepe.ca>
References: <20190207222647.GA30974@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190207222647.GA30974@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Stone <daniel@fooishbar.org>, "hch@lst.de" <hch@lst.de>, "Koenig, Christian" <Christian.Koenig@amd.com>, Thomas Hellstrom <thellstrom@vmware.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yong.zhi@intel.com" <yong.zhi@intel.com>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 07, 2019 at 10:26:52PM +0000, Jason Gunthorpe wrote:
> Commit 2db76d7c3c6d ("lib/scatterlist: sg_page_iter: support sg lists w/o
> backing pages") introduced the sg_page_iter_dma_address() function without
> providing a way to use it in the general case. If the sg_dma_len() is not
> equal to the sg length callers cannot safely use the
> for_each_sg_page/sg_page_iter_dma_address combination.
> 
> Resolve this API mistake by providing a DMA specific iterator,
> for_each_sg_dma_page(), that uses the right length so
> sg_page_iter_dma_address() works as expected with all sglists.
> 
> A new iterator type is introduced to provide compile-time safety against
> wrongly mixing accessors and iterators.
> 
> Acked-by: Christoph Hellwig <hch@lst.de> (for scatterlist)
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> Acked-by: Thomas Hellstrom <thellstrom@vmware.com>
> ---
>  .clang-format                              |  1 +
>  drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c |  8 +++-
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c   |  4 +-
>  include/linux/scatterlist.h                | 49 ++++++++++++++++++----
>  lib/scatterlist.c                          | 26 ++++++++++++
>  5 files changed, 76 insertions(+), 12 deletions(-)

Applied to rdma.git's for-next, thanks everyone.

Jason
