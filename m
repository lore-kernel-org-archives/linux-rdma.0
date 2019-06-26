From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Wed, 26 Jun 2019 17:21:08 -0300
Message-ID: <20190626202107.GA5850@ziepe.ca>
References: <20190620161240.22738-1-logang@deltatee.com>
 <20190624072752.GA3954@lst.de>
 <558a27ba-e7c9-9d94-cad0-377b8ee374a6@deltatee.com>
 <20190625072008.GB30350@lst.de>
 <f0f002bf-2b94-cd18-d18f-5d0b08311495@deltatee.com>
 <20190625170115.GA9746@lst.de>
 <41235a05-8ed1-e69a-e7cd-48cae7d8a676@deltatee.com>
 <20190626065708.GB24531@lst.de>
 <c15d5997-9ba4-f7db-0e7a-a69e75df316c@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c15d5997-9ba4-f7db-0e7a-a69e75df316c@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 26, 2019 at 12:31:08PM -0600, Logan Gunthorpe wrote:
> > we have a hole behind len where we could store flag.  Preferably
> > optionally based on a P2P or other magic memory types config
> > option so that 32-bit systems with 32-bit phys_addr_t actually
> > benefit from the smaller and better packing structure.
> 
> That seems sensible. The one thing that's unclear though is how to get
> the PCI Bus address when appropriate. Can we pass that in instead of the
> phys_addr with an appropriate flag? Or will we need to pass the actual
> physical address and then, at the map step, the driver has to some how
> lookup the PCI device to figure out the bus offset?

I agree with CH, if we go down this path it is a layering violation
for the thing injecting bio's into the block stack to know what struct
device they egress&dma map on just to be able to do the dma_map up
front.

So we must be able to go from this new phys_addr_t&flags to some BAR
information during dma_map.

For instance we could use a small hash table of the upper phys addr
bits, or an interval tree, to do the lookup.

The bar info would give the exporting struct device and any other info
we need to make the iommu mapping.

This phys_addr_t seems like a good approach to me as it avoids the
struct page overheads and will lets us provide copy from/to bio
primitives that could work on BAR memory. I think we can surely use
this approach in RDMA as well.

Jason
