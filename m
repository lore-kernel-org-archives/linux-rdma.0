From: David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Tue, 18 Dec 2018 10:51:34 -0800 (PST)
Message-ID: <20181218.105134.1658119814567562312.davem@davemloft.net>
References: <66cea824-19f4-1ca2-b6be-550ba1c0636b@wwwdotorg.org>
        <20181218184308.GD21992@ziepe.ca>
        <20181218185012.GB16052@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181218185012.GB16052@lst.de>
Sender: netdev-owner@vger.kernel.org
To: hch@lst.de
Cc: jgg@ziepe.ca, swarren@wwwdotorg.org, tariqt@mellanox.com, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Tue, 18 Dec 2018 19:50:12 +0100

> On Tue, Dec 18, 2018 at 11:43:08AM -0700, Jason Gunthorpe wrote:
>> So the problem here is that on some arches
>> 
>>  sg_set_buf(sg, dma_coherent_buf, size)
>>  p = sg_virt(sg);
>>  assert(p == dma_coherent_buf);
> 
> dma allocations purely return a virtual address, you must never
> call virt_to_page or virt_to_phys on them, which sg_set_buf
> will do.  On many architectures this will give your the wrong
> result as the coherent DMA address is a vmap or ioremap address.

Correct.

And I don't think it makes sense to create fake pages for these
remapped areas to resolve to.
