From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V3] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Thu, 3 Jan 2019 08:48:13 +0100
Message-ID: <20190103074813.GA24704@lst.de>
References: <20181219182031.8675-1-swarren@wwwdotorg.org> <20181220174318.GA21404@ziepe.ca> <b283e3ba-6e75-bf86-a29f-100200df9f77@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b283e3ba-6e75-bf86-a29f-100200df9f77@wwwdotorg.org>
Sender: netdev-owner@vger.kernel.org
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tariq Toukan <tariqt@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Stephen Warren <swarren@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

Btw, one other little request if you resend this: the mlx5 icm code
touched here oddly enough uses the deprecated pci_map_sg/pci_unmap_sg
instead of the preferred dma_map_sg/dma_unmap_sg despite otherwise
using the generic DMA API.  Can you throw in a little cleanup patch
for that into your series?
