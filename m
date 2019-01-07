From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v4 1/2] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Mon, 07 Jan 2019 07:10:32 -0800 (PST)
Message-ID: <20190107.071032.1121771113620094413.davem@davemloft.net>
References: <20190103172324.21748-1-swarren@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190103172324.21748-1-swarren@wwwdotorg.org>
Sender: netdev-owner@vger.kernel.org
To: swarren@wwwdotorg.org
Cc: tariqt@mellanox.com, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dledford@redhat.com, jgg@mellanox.com, hch@lst.de, swarren@nvidia.com
List-Id: linux-rdma@vger.kernel.org

From: Stephen Warren <swarren@wwwdotorg.org>
Date: Thu,  3 Jan 2019 10:23:23 -0700

> From: Stephen Warren <swarren@nvidia.com>
> 
> This patch solves a crash at the time of mlx4 driver unload or system
> shutdown. The crash occurs because dma_alloc_coherent() returns one
> value in mlx4_alloc_icm_coherent(), but a different value is passed to
> dma_free_coherent() in mlx4_free_icm_coherent(). In turn this is because
> when allocated, that pointer is passed to sg_set_buf() to record it,
> then when freed it is re-calculated by calling
> lowmem_page_address(sg_page()) which returns a different value. Solve
> this by recording the value that dma_alloc_coherent() returns, and
> passing this to dma_free_coherent().
> 
> This patch is roughly equivalent to commit 378efe798ecf ("RDMA/hns: Get
> rid of page operation after dma_alloc_coherent").
> 
> Based-on-code-from: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Applied.
