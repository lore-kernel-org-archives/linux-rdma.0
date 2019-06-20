From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC PATCH 04/28] block: Never bounce dma-direct bios
Date: Thu, 20 Jun 2019 12:38:13 -0600
Message-ID: <6e4caa21-a148-00d1-a46f-18517fb744d6@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
 <20190620161240.22738-5-logang@deltatee.com>
 <20190620172347.GE19891@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620172347.GE19891@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org



On 2019-06-20 11:23 a.m., Jason Gunthorpe wrote:
> On Thu, Jun 20, 2019 at 10:12:16AM -0600, Logan Gunthorpe wrote:
>> It is expected the creator of the dma-direct bio will ensure the
>> target device can access the DMA address it's creating bios for.
>> It's also not possible to bounce a dma-direct bio seeing the block
>> layer doesn't have any way to access the underlying data behind
>> the DMA address.
>>
>> Thus, never bounce dma-direct bios.
> 
> I wonder how feasible it would be to implement a 'dma vec' copy
> from/to? 

> That is about the only operation you could safely do on P2P BAR
> memory. 
> 
> I wonder if a copy implementation could somehow query the iommu layer
> to get a kmap of the memory pointed at by the dma address so we don't
> need to carry struct page around?

That sounds a bit nasty. First we'd have to determine what the
dma_addr_t points to; and with P2P it may be a bus address or it may be
an IOVA address and it would probably have to be based on whether the
IOVA is reserved or not (PCI bus addresses should all be reserved).
Second, if it is an IOVA then the we'd have to get the physical address
back from the IOMMU tables and hope we can then get it back to a
sensible kernel mapping -- and if it points to a PCI bus address we'd
then have to somehow get back to the kernel mapping which could be
anywhere in the VMALLOC region as we no longer have the linear mapping
that struct page provides.

I think if we need access to the memory, then this is the wrong approach
and we should keep struct page or try pfn_t so we can map the memory in
a way that would perform better.

In theory, I could relatively easily do the same thing I did for dma_vec
but with a pfn_t_vec. Though we'd still have the problem of determining
virtual address from physical address for memory that isn't linearly
mapped. We'd probably have to introduce some arch-specific thing to
linearly map an io region or something which may be possible on some
arches on not on others (same problems we have with struct page).

Logan
