From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Tue, 18 Dec 2018 19:50:12 +0100
Message-ID: <20181218185012.GB16052@lst.de>
References: <20181214233254.5860-1-swarren@wwwdotorg.org> <20181218163202.GJ21949@mellanox.com> <498653b9-5006-2153-fa53-3bc217626303@wwwdotorg.org> <20181218171246.GC21992@ziepe.ca> <66cea824-19f4-1ca2-b6be-550ba1c0636b@wwwdotorg.org> <20181218184308.GD21992@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181218184308.GD21992@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Christoph Hellwig <hch@lst.de>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 18, 2018 at 11:43:08AM -0700, Jason Gunthorpe wrote:
> So the problem here is that on some arches
> 
>  sg_set_buf(sg, dma_coherent_buf, size)
>  p = sg_virt(sg);
>  assert(p == dma_coherent_buf);

dma allocations purely return a virtual address, you must never
call virt_to_page or virt_to_phys on them, which sg_set_buf
will do.  On many architectures this will give your the wrong
result as the coherent DMA address is a vmap or ioremap address.
