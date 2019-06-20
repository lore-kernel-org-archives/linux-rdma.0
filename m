From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Thu, 20 Jun 2019 11:45:38 -0700
Message-ID: <CAPcyv4ijztOK1FUjLuFing7ps4LOHt=6z=eO=98HHWauHA+yog@mail.gmail.com>
References: <20190620161240.22738-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620161240.22738-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 20, 2019 at 9:13 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
> For eons there has been a debate over whether or not to use
> struct pages for peer-to-peer DMA transactions. Pro-pagers have
> argued that struct pages are necessary for interacting with
> existing code like scatterlists or the bio_vecs. Anti-pagers
> assert that the tracking of the memory is unecessary and
> allocating the pages is a waste of memory. Both viewpoints are
> valid, however developers working on GPUs and RDMA tend to be
> able to do away with struct pages relatively easily

Presumably because they have historically never tried to be
inter-operable with the block layer or drivers outside graphics and
RDMA.

>  compared to
> those wanting to work with NVMe devices through the block layer.
> So it would be of great value to be able to universally do P2PDMA
> transactions without the use of struct pages.

Please spell out the value, it is not immediately obvious to me
outside of some memory capacity savings.

> Previously, there have been multiple attempts[1][2] to replace
> struct page usage with pfn_t but this has been unpopular seeing
> it creates dangerous edge cases where unsuspecting code might
> run accross pfn_t's they are not ready for.

That's not the conclusion I arrived at because pfn_t is specifically
an opaque type precisely to force "unsuspecting" code to throw
compiler assertions. Instead pfn_t was dealt its death blow here:

https://lore.kernel.org/lkml/CA+55aFzON9617c2_Amep0ngLq91kfrPiSccdZakxir82iekUiA@mail.gmail.com/

...and I think that feedback also reads on this proposal.

> Currently, we have P2PDMA using struct pages through the block layer
> and the dangerous cases are avoided by using a queue flag that
> indicates support for the special pages.
>
> This RFC proposes a new solution: allow the block layer to take
> DMA addresses directly for queues that indicate support. This will
> provide a more general path for doing P2PDMA-like requests and will
> allow us to remove the struct pages that back P2PDMA memory thus paving
> the way to build a more uniform P2PDMA ecosystem.

My primary concern with this is that ascribes a level of generality
that just isn't there for peer-to-peer dma operations. "Peer"
addresses are not "DMA" addresses, and the rules about what can and
can't do peer-DMA are not generically known to the block layer. At
least with a side object there's a chance to describe / recall those
restrictions as these things get passed around the I/O stack, but an
undecorated "DMA" address passed through the block layer with no other
benefit to any subsystem besides RDMA does not feel like it advances
the state of the art.

Again, what are the benefits of plumbing this RDMA special case?
