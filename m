From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Wed, 26 Jun 2019 14:45:38 -0600
Message-ID: <8a0a08c3-a537-bff6-0852-a5f337a70688@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
 <20190624072752.GA3954@lst.de>
 <558a27ba-e7c9-9d94-cad0-377b8ee374a6@deltatee.com>
 <20190625072008.GB30350@lst.de>
 <f0f002bf-2b94-cd18-d18f-5d0b08311495@deltatee.com>
 <20190625170115.GA9746@lst.de>
 <41235a05-8ed1-e69a-e7cd-48cae7d8a676@deltatee.com>
 <20190626065708.GB24531@lst.de>
 <c15d5997-9ba4-f7db-0e7a-a69e75df316c@deltatee.com>
 <20190626202107.GA5850@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190626202107.GA5850@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org



On 2019-06-26 2:21 p.m., Jason Gunthorpe wrote:
> On Wed, Jun 26, 2019 at 12:31:08PM -0600, Logan Gunthorpe wrote:
>>> we have a hole behind len where we could store flag.  Preferably
>>> optionally based on a P2P or other magic memory types config
>>> option so that 32-bit systems with 32-bit phys_addr_t actually
>>> benefit from the smaller and better packing structure.
>>
>> That seems sensible. The one thing that's unclear though is how to get
>> the PCI Bus address when appropriate. Can we pass that in instead of the
>> phys_addr with an appropriate flag? Or will we need to pass the actual
>> physical address and then, at the map step, the driver has to some how
>> lookup the PCI device to figure out the bus offset?
> 
> I agree with CH, if we go down this path it is a layering violation
> for the thing injecting bio's into the block stack to know what struct
> device they egress&dma map on just to be able to do the dma_map up
> front.

Not sure I agree with this statement. The p2pdma code already *must*
know and access the pci_dev of the dma device ahead of when it submits
the IO to know if it's valid to allocate and use P2P memory at all. This
is why the submitting driver has a lot of the information needed to map
this memory that the mapping driver does not.

> So we must be able to go from this new phys_addr_t&flags to some BAR
> information during dma_map.

> For instance we could use a small hash table of the upper phys addr
> bits, or an interval tree, to do the lookup.

Yes, if we're going to take a hard stance on this. But using an interval
tree (or similar) is a lot more work for the CPU to figure out these
mappings that may not be strictly necessary if we could just pass better
information down from the submitting driver to the mapping driver.

> The bar info would give the exporting struct device and any other info
> we need to make the iommu mapping.

Well, the IOMMU mapping is the normal thing the mapping driver will
always do. We'd really just need the submitting driver to, when
appropriate, inform the mapping driver that this is a pci bus address
and not to call dma_map_xxx(). Then, for special mappings for the CMB
like Christoph is talking about, it's simply a matter of doing a range
compare on the PCI Bus address and converting the bus address to a BAR
and offset.

Logan
