From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Fri, 21 Jun 2019 14:47:24 -0300
Message-ID: <20190621174724.GV19891@ziepe.ca>
References: <20190620161240.22738-1-logang@deltatee.com>
 <CAPcyv4ijztOK1FUjLuFing7ps4LOHt=6z=eO=98HHWauHA+yog@mail.gmail.com>
 <20190620193353.GF19891@ziepe.ca>
 <CAPcyv4jyNRBvtWhr9+aHbzWP6=D4qAME+=hWMtOYJ17BVHdy2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4jyNRBvtWhr9+aHbzWP6=D4qAME+=hWMtOYJ17BVHdy2w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 20, 2019 at 01:18:13PM -0700, Dan Williams wrote:

> > This P2P is quite distinct from DAX as the struct page* would point to
> > non-cacheable weird memory that few struct page users would even be
> > able to work with, while I understand DAX use cases focused on CPU
> > cache coherent memory, and filesystem involvement.
> 
> What I'm poking at is whether this block layer capability can pick up
> users outside of RDMA, more on this below...

The generic capability is to do a transfer through the block layer and
scatter/gather the resulting data to some PCIe BAR memory. Currently
the block layer can only scatter/gather data into CPU cache coherent
memory.

We know of several useful places to put PCIe BAR memory already:
 - On a GPU (or FPGA, acclerator, etc), ie the GB's of GPU private
   memory that is standard these days.
 - On a NVMe CMB. This lets the NVMe drive avoid DMA entirely
 - On a RDMA NIC. Mellanox NICs have a small amount of BAR memory that
   can be used like a CMB and avoids a DMA

RDMA doesn't really get so involved here, except that RDMA is often
the prefered way to source/sink the data buffers after the block layer has
scatter/gathered to them. (and of course RDMA is often for a block
driver, ie NMVe over fabrics)

> > > My primary concern with this is that ascribes a level of generality
> > > that just isn't there for peer-to-peer dma operations. "Peer"
> > > addresses are not "DMA" addresses, and the rules about what can and
> > > can't do peer-DMA are not generically known to the block layer.
> >
> > ?? The P2P infrastructure produces a DMA bus address for the
> > initiating device that is is absolutely a DMA address. There is some
> > intermediate CPU centric representation, but after mapping it is the
> > same as any other DMA bus address.
> 
> Right, this goes back to the confusion caused by the hardware / bus /
> address that a dma-engine would consume directly, and Linux "DMA"
> address as a device-specific translation of host memory.

I don't think there is a confusion :) Logan explained it, the
dma_addr_t is always the thing you program into the DMA engine of the
device it was created for, and this changes nothing about that.

Think of the dma vec as the same as a dma mapped SGL, just with no
available struct page.

> Is the block layer representation of this address going to go through
> a peer / "bus" address translation when it reaches the RDMA driver? 

No, it is just like any other dma mapped SGL, it is ready to go for
the device it was mapped for, and can be used for nothing other than
programming DMA on that device.

> > ie GPU people wouuld really like to do read() and have P2P
> > transparently happen to on-GPU pages. With GPUs having huge amounts of
> > memory loading file data into them is really a performance critical
> > thing.
> 
> A direct-i/o read(2) into a page-less GPU mapping? 

The interesting case is probably an O_DIRECT read into a
DEVICE_PRIVATE page owned by the GPU driver and mmaped into the
process calling read(). The GPU driver can dynamically arrange for
that DEVICE_PRIVATE page to linked to P2P targettable BAR memory so
the HW is capable of a direct CPU bypass transfer from the underlying
block device (ie NVMe or RDMA) to the GPU.

One way to approach this problem is to use this new dma_addr path in
the block layer.

Another way is to feed the DEVICE_PRIVATE pages into the block layer
and have it DMA map them to a P2P address.

In either case we have a situation where the block layer cannot touch
the target struct page buffers with the CPU because there is no cache
coherent CPU mapping for them, and we have to create a CPU clean path
in the block layer.

At best you could do memcpy to/from on these things, but if a GPU is
involved even that is incredibly inefficient. The GPU can do the
memcpy with DMA much faster than a memcpy_to/from_io.

Jason
