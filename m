From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v4 2/2] net/mlx4: replace pci_{,un}map_sg with
 dma_{,un}map_sg
Date: Mon, 07 Jan 2019 07:10:38 -0800 (PST)
Message-ID: <20190107.071038.907963709382764858.davem@davemloft.net>
References: <20190103172324.21748-1-swarren@wwwdotorg.org>
        <20190103172324.21748-2-swarren@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190103172324.21748-2-swarren@wwwdotorg.org>
Sender: netdev-owner@vger.kernel.org
To: swarren@wwwdotorg.org
Cc: tariqt@mellanox.com, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, dledford@redhat.com, jgg@mellanox.com, hch@lst.de, swarren@nvidia.com
List-Id: linux-rdma@vger.kernel.org

From: Stephen Warren <swarren@wwwdotorg.org>
Date: Thu,  3 Jan 2019 10:23:24 -0700

> From: Stephen Warren <swarren@nvidia.com>
> 
> pci_{,un}map_sg are deprecated and replaced by dma_{,un}map_sg. This is
> especially relevant since the rest of the driver uses the DMA API. Fix
> the driver to use the replacement APIs.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Applied.
