From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Mon, 24 Jun 2019 10:46:41 -0300
Message-ID: <20190624134641.GA8268@ziepe.ca>
References: <20190620161240.22738-1-logang@deltatee.com>
 <CAPcyv4ijztOK1FUjLuFing7ps4LOHt=6z=eO=98HHWauHA+yog@mail.gmail.com>
 <20190620193353.GF19891@ziepe.ca>
 <20190624073126.GB3954@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190624073126.GB3954@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Logan Gunthorpe <logang@deltatee.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 24, 2019 at 09:31:26AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 20, 2019 at 04:33:53PM -0300, Jason Gunthorpe wrote:
> > > My primary concern with this is that ascribes a level of generality
> > > that just isn't there for peer-to-peer dma operations. "Peer"
> > > addresses are not "DMA" addresses, and the rules about what can and
> > > can't do peer-DMA are not generically known to the block layer.
> > 
> > ?? The P2P infrastructure produces a DMA bus address for the
> > initiating device that is is absolutely a DMA address. There is some
> > intermediate CPU centric representation, but after mapping it is the
> > same as any other DMA bus address.
> > 
> > The map function can tell if the device pair combination can do p2p or
> > not.
> 
> At the PCIe level there is no such thing as a DMA address, it all
> is bus address with MMIO and DMA in the same address space (without
> that P2P would have not chance of actually working obviously).  But
> that bus address space is different per "bus" (which would be an
> root port in PCIe), and we need to be careful about that.

Sure, that is how dma_addr_t is supposed to work - it is always a
device specific value that can be used only by the device that it was
created for, and different devices could have different dma_addr_t
values for the same memory. 

So when Logan goes and puts dma_addr_t into the block stack he must
also invert things so that the DMA map happens at the start of the
process to create the right dma_addr_t early.

I'm not totally clear if this series did that inversion, if it didn't
then it should not be using the dma_addr_t label at all, or refering
to anything as a 'dma address' as it is just confusing.

BTW, it is not just offset right? It is possible that the IOMMU can
generate unique dma_addr_t values for each device?? Simple offset is
just something we saw in certain embedded cases, IIRC.

Jason
