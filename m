From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Thu, 20 Jun 2019 16:40:40 -0700
Message-ID: <CAPcyv4gPOXaL3qks6RMufu==O9RV2m_-7bBmJqKOFYTf4v_jXQ@mail.gmail.com>
References: <20190620161240.22738-1-logang@deltatee.com> <CAPcyv4ijztOK1FUjLuFing7ps4LOHt=6z=eO=98HHWauHA+yog@mail.gmail.com>
 <91eba9a0-27b4-08b4-7c12-86e24e1bfe85@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <91eba9a0-27b4-08b4-7c12-86e24e1bfe85@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 20, 2019 at 12:35 PM Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
>
> On 2019-06-20 12:45 p.m., Dan Williams wrote:
> > On Thu, Jun 20, 2019 at 9:13 AM Logan Gunthorpe <logang@deltatee.com> wrote:
> >>
> >> For eons there has been a debate over whether or not to use
> >> struct pages for peer-to-peer DMA transactions. Pro-pagers have
> >> argued that struct pages are necessary for interacting with
> >> existing code like scatterlists or the bio_vecs. Anti-pagers
> >> assert that the tracking of the memory is unecessary and
> >> allocating the pages is a waste of memory. Both viewpoints are
> >> valid, however developers working on GPUs and RDMA tend to be
> >> able to do away with struct pages relatively easily
> >
> > Presumably because they have historically never tried to be
> > inter-operable with the block layer or drivers outside graphics and
> > RDMA.
>
> Yes, but really there are three main sets of users for P2P right now:
> graphics, RDMA and NVMe. And every time a patch set comes from GPU/RDMA
> people they don't bother with struct page. I seem to be the only one
> trying to push P2P with NVMe and it seems to be a losing battle.
>
> > Please spell out the value, it is not immediately obvious to me
> > outside of some memory capacity savings.
>
> There are a few things:
>
> * Have consistency with P2P efforts as most other efforts have been
> avoiding struct page. Nobody else seems to want
> pci_p2pdma_add_resource() or any devm_memremap_pages() call.
>
> * Avoid all arch-specific dependencies for P2P. With struct page the IO
> memory must fit in the linear mapping. This requires some work with
> RISC-V and I remember some complaints from the powerpc people regarding
> this. Certainly not all arches will be able to fit the IO region into
> the linear mapping space.
>
> * Remove a bunch of PCI P2PDMA special case mapping stuff from the block
> layer and RDMA interface (which I've been hearing complaints over).

This seems to be the most salient point. I was missing the fact that
this replaces custom hacks and "special" pages with an explicit "just
pass this pre-mapped address down the stack". It's functionality that
might plausibly be used outside of p2p, as long as the driver can
assert that it never needs to touch the data with the cpu before
handing it off to a dma-engine.
