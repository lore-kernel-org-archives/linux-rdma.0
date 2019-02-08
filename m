From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Subject: Re: [PATCH v2] lib/scatterlist: Provide a DMA page iterator
Date: Fri, 8 Feb 2019 05:31:55 +0100
Message-ID: <CANiq72=qfNHf5zd8c8VkmrhE8U5_kH6yg3z4JD1N5yEfL727tA@mail.gmail.com>
References: <20190207222647.GA30974@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190207222647.GA30974@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Daniel Stone <daniel@fooishbar.org>, "hch@lst.de" <hch@lst.de>, "Koenig, Christian" <Christian.Koenig@amd.com>, Thomas Hellstrom <thellstrom@vmware.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yong.zhi@intel.com" <yong.zhi@intel.com>, "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "bingbu.cao@intel.com" <bingbu.cao@intel.com>, "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>, "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>, "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 7, 2019 at 11:28 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
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
> ---
>  .clang-format                              |  1 +

Thanks for updating the .clang-format, Jason! :-)

Cheers,
Miguel
