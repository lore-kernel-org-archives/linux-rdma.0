From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
Date: Tue, 15 Jan 2019 16:20:29 +0100
Message-ID: <20190115152029.GB2325@lst.de>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca> <20190114094856.GB29604@lst.de> <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com> <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: christian.koenig@amd.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>, "hch@lst.de" <hch@lst.de>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "syeh@vmware.com" <syeh@vmware.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "yong.zhi@intel.com" <yong.zhi@intel.com>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 15, 2019 at 03:24:55PM +0100, Christian König wrote:
> Yeah, indeed. Bounce buffers are an absolute no-go for GPUs.
>
> If the DMA API finds that a piece of memory is not directly accessible by 
> the GPU we need to return an error and not try to use bounce buffers behind 
> the surface.
>
> That is something which always annoyed me with the DMA API, which is 
> otherwise rather cleanly defined.

That is exactly what I want to fix with my series to make
DMA_ATTR_NON_CONSISTENT more useful and always available:

https://lists.linuxfoundation.org/pipermail/iommu/2018-December/031985.html

With that you allocate the memory using dma_alloc_attrs with
DMA_ATTR_NON_CONSISTENT, and use dma_sync_single_* to transfer
ownership to the cpu and back to the device, with a gurantee that
there won't be any bouncing.  So far the interest by the parties that
requested the feature has been rather lacklustre, though.
