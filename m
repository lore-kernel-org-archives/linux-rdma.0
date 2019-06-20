From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Thu, 20 Jun 2019 16:33:53 -0300
Message-ID: <20190620193353.GF19891@ziepe.ca>
References: <20190620161240.22738-1-logang@deltatee.com>
 <CAPcyv4ijztOK1FUjLuFing7ps4LOHt=6z=eO=98HHWauHA+yog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4ijztOK1FUjLuFing7ps4LOHt=6z=eO=98HHWauHA+yog@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 20, 2019 at 11:45:38AM -0700, Dan Williams wrote:

> > Previously, there have been multiple attempts[1][2] to replace
> > struct page usage with pfn_t but this has been unpopular seeing
> > it creates dangerous edge cases where unsuspecting code might
> > run accross pfn_t's they are not ready for.
> 
> That's not the conclusion I arrived at because pfn_t is specifically
> an opaque type precisely to force "unsuspecting" code to throw
> compiler assertions. Instead pfn_t was dealt its death blow here:
> 
> https://lore.kernel.org/lkml/CA+55aFzON9617c2_Amep0ngLq91kfrPiSccdZakxir82iekUiA@mail.gmail.com/
> 
> ...and I think that feedback also reads on this proposal.

I read through Linus's remarks and it he seems completely right that
anything that touches a filesystem needs a struct page, because FS's
rely heavily on that.

It is much less clear to me why a GPU BAR or a NVME CMB that never
touches a filesystem needs a struct page.. The best reason I've seen
is that it must have struct page because the block layer heavily
depends on struct page.

Since that thread was so DAX/pmem centric (and Linus did say he liked
the __pfn_t), maybe it is worth checking again, but not for DAX/pmem
users?

This P2P is quite distinct from DAX as the struct page* would point to
non-cacheable weird memory that few struct page users would even be
able to work with, while I understand DAX use cases focused on CPU
cache coherent memory, and filesystem involvement.

> My primary concern with this is that ascribes a level of generality
> that just isn't there for peer-to-peer dma operations. "Peer"
> addresses are not "DMA" addresses, and the rules about what can and
> can't do peer-DMA are not generically known to the block layer.

?? The P2P infrastructure produces a DMA bus address for the
initiating device that is is absolutely a DMA address. There is some
intermediate CPU centric representation, but after mapping it is the
same as any other DMA bus address.

The map function can tell if the device pair combination can do p2p or
not.

> Again, what are the benefits of plumbing this RDMA special case?

It is not just RDMA, this is interesting for GPU and vfio use cases
too. RDMA is just the most complete in-tree user we have today.

ie GPU people wouuld really like to do read() and have P2P
transparently happen to on-GPU pages. With GPUs having huge amounts of
memory loading file data into them is really a performance critical
thing.

Jason
