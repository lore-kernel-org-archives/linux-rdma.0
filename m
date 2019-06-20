From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH 04/28] block: Never bounce dma-direct bios
Date: Thu, 20 Jun 2019 14:23:47 -0300
Message-ID: <20190620172347.GE19891@ziepe.ca>
References: <20190620161240.22738-1-logang@deltatee.com>
 <20190620161240.22738-5-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190620161240.22738-5-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 20, 2019 at 10:12:16AM -0600, Logan Gunthorpe wrote:
> It is expected the creator of the dma-direct bio will ensure the
> target device can access the DMA address it's creating bios for.
> It's also not possible to bounce a dma-direct bio seeing the block
> layer doesn't have any way to access the underlying data behind
> the DMA address.
> 
> Thus, never bounce dma-direct bios.

I wonder how feasible it would be to implement a 'dma vec' copy
from/to? 

That is about the only operation you could safely do on P2P BAR
memory. 

I wonder if a copy implementation could somehow query the iommu layer
to get a kmap of the memory pointed at by the dma address so we don't
need to carry struct page around?

Jason
