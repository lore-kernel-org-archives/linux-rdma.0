From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Fri, 21 Jun 2019 10:54:03 -0700
Message-ID: <CAPcyv4h6CjzxbWLg3upmUiaYQ2eqP-ZyHxMBfh6kkQpwHX9HWg@mail.gmail.com>
References: <20190620161240.22738-1-logang@deltatee.com> <CAPcyv4ijztOK1FUjLuFing7ps4LOHt=6z=eO=98HHWauHA+yog@mail.gmail.com>
 <20190620193353.GF19891@ziepe.ca> <CAPcyv4jyNRBvtWhr9+aHbzWP6=D4qAME+=hWMtOYJ17BVHdy2w@mail.gmail.com>
 <20190621174724.GV19891@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190621174724.GV19891@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Logan Gunthorpe <logang@deltatee.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 21, 2019 at 10:47 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Thu, Jun 20, 2019 at 01:18:13PM -0700, Dan Williams wrote:
>
> > > This P2P is quite distinct from DAX as the struct page* would point to
> > > non-cacheable weird memory that few struct page users would even be
> > > able to work with, while I understand DAX use cases focused on CPU
> > > cache coherent memory, and filesystem involvement.
> >
> > What I'm poking at is whether this block layer capability can pick up
> > users outside of RDMA, more on this below...
>
> The generic capability is to do a transfer through the block layer and
> scatter/gather the resulting data to some PCIe BAR memory. Currently
> the block layer can only scatter/gather data into CPU cache coherent
> memory.
>
> We know of several useful places to put PCIe BAR memory already:
>  - On a GPU (or FPGA, acclerator, etc), ie the GB's of GPU private
>    memory that is standard these days.
>  - On a NVMe CMB. This lets the NVMe drive avoid DMA entirely
>  - On a RDMA NIC. Mellanox NICs have a small amount of BAR memory that
>    can be used like a CMB and avoids a DMA
>
> RDMA doesn't really get so involved here, except that RDMA is often
> the prefered way to source/sink the data buffers after the block layer has
> scatter/gathered to them. (and of course RDMA is often for a block
> driver, ie NMVe over fabrics)
>
> > > > My primary concern with this is that ascribes a level of generality
> > > > that just isn't there for peer-to-peer dma operations. "Peer"
> > > > addresses are not "DMA" addresses, and the rules about what can and
> > > > can't do peer-DMA are not generically known to the block layer.
> > >
> > > ?? The P2P infrastructure produces a DMA bus address for the
> > > initiating device that is is absolutely a DMA address. There is some
> > > intermediate CPU centric representation, but after mapping it is the
> > > same as any other DMA bus address.
> >
> > Right, this goes back to the confusion caused by the hardware / bus /
> > address that a dma-engine would consume directly, and Linux "DMA"
> > address as a device-specific translation of host memory.
>
> I don't think there is a confusion :) Logan explained it, the
> dma_addr_t is always the thing you program into the DMA engine of the
> device it was created for, and this changes nothing about that.

Yup, Logan and I already settled that point on our last exchange and
offered to make that clearer in the changelog.
