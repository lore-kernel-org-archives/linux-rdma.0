From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Tue, 18 Dec 2018 11:43:08 -0700
Message-ID: <20181218184308.GD21992@ziepe.ca>
References: <20181214233254.5860-1-swarren@wwwdotorg.org>
 <20181218163202.GJ21949@mellanox.com>
 <498653b9-5006-2153-fa53-3bc217626303@wwwdotorg.org>
 <20181218171246.GC21992@ziepe.ca>
 <66cea824-19f4-1ca2-b6be-550ba1c0636b@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <66cea824-19f4-1ca2-b6be-550ba1c0636b@wwwdotorg.org>
Sender: netdev-owner@vger.kernel.org
To: Stephen Warren <swarren@wwwdotorg.org>, Christoph Hellwig <hch@lst.de>
Cc: Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 18, 2018 at 10:45:21AM -0700, Stephen Warren wrote:

> There are two allocation paths; one using dma_alloc_coherent and one using
> alloc_pages. (The hns driver only has the dma_alloc_coherent path.) These
> both store allocations into an sg list which is stored in a table, and that
> table is searched by a single function mlx4_table_find() irrespective of
> which allocation path was used, so if one of the allocation paths is updated
> to store the CPU virtual address differently, then both paths need to be
> updated so they match, so that the single table search path can continue to
> have a single implementation.

So the problem here is that on some arches

 sg_set_buf(sg, dma_coherent_buf, size)
 p = sg_virt(sg);
 assert(p == dma_coherent_buf);

Doesn't work or crashes? Is this how sgl should work?

But if you accept this and don't do the sg_set_buf then the
scatterlist is substantially broken, many of the APIs related to it
will not work as expected at all.

So, I don't think drivers should create such a broken scatterlist or
arches should not have this problem (ie the mathematical
transformation to struct page * and back to virtual address should
work in the coherent space even if there are no backing struct pages
allocated)?

What do you think CH?

Jason
