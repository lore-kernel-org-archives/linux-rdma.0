From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Thu, 27 Jun 2019 10:30:42 -0600
Message-ID: <89889319-e778-7772-ab36-dc55b59826be@deltatee.com>
References: <20190624072752.GA3954@lst.de>
 <558a27ba-e7c9-9d94-cad0-377b8ee374a6@deltatee.com>
 <20190625072008.GB30350@lst.de>
 <f0f002bf-2b94-cd18-d18f-5d0b08311495@deltatee.com>
 <20190625170115.GA9746@lst.de>
 <41235a05-8ed1-e69a-e7cd-48cae7d8a676@deltatee.com>
 <20190626065708.GB24531@lst.de>
 <c15d5997-9ba4-f7db-0e7a-a69e75df316c@deltatee.com>
 <20190626202107.GA5850@ziepe.ca>
 <8a0a08c3-a537-bff6-0852-a5f337a70688@deltatee.com>
 <20190627090843.GB11548@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190627090843.GB11548@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org



On 2019-06-27 3:08 a.m., Christoph Hellwig wrote:
> On Wed, Jun 26, 2019 at 02:45:38PM -0600, Logan Gunthorpe wrote:
>>> The bar info would give the exporting struct device and any other info
>>> we need to make the iommu mapping.
>>
>> Well, the IOMMU mapping is the normal thing the mapping driver will
>> always do. We'd really just need the submitting driver to, when
>> appropriate, inform the mapping driver that this is a pci bus address
>> and not to call dma_map_xxx(). Then, for special mappings for the CMB
>> like Christoph is talking about, it's simply a matter of doing a range
>> compare on the PCI Bus address and converting the bus address to a BAR
>> and offset.
> 
> Well, range compare on the physical address.  We have a few different
> options here:
> 
>  (a) a range is normal RAM, DMA mapping works as usual
>  (b) a range is another devices BAR, in which case we need to do a
>      map_resource equivalent (which really just means don't bother with
>      cache flush on non-coherent architectures) and apply any needed
>      offset, fixed or iommu based

Well I would split this into two cases: (b1) ranges in another device's
BAR that will pass through the root complex and require a map_resource
equivalent and (b2) ranges in another device's bar that don't pass
through the root complex and require applying an offset to the bus
address. Both require rather different handling and the submitting
driver should already know ahead of time what type we have.

>  (c) a range points to a BAR on the acting device. In which case we
>      don't need to DMA map at all, because no dma is happening but just an
>      internal transfer.  And depending on the device that might also require
>      a different addressing mode

I think (c) is actually just a special case of (b2). Any device that has
a special protocol for addressing the local BAR can just do a range
compare on the address to determine if it's local or not. Devices that
don't have a special protocol for this would handle both (c) and (b2)
the same.

> I guess it might make sense to just have a block layer flag that (b) or
> (c) might be contained in a bio.  Then we always look up the data
> structure, but can still fall back to (a) if nothing was found.  That
> even allows free mixing and matching of memory types, at least as long
> as they are contained to separate bio_vec segments.

IMO these three cases should be reflected in flags in the bio_vec. We'd
probably still need a queue flag to indicate support for mapping these,
but a flag on the bio that indicates special cases *might* exist in the
bio_vec and the driver has to do extra work to somehow distinguish the
three types doesn't seem useful. bio_vec flags also make it easy to
support mixing segments from different memory types.

Logan
