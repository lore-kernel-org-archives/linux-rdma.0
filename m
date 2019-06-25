From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Tue, 25 Jun 2019 13:54:21 -0600
Message-ID: <41235a05-8ed1-e69a-e7cd-48cae7d8a676@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
 <20190624072752.GA3954@lst.de>
 <558a27ba-e7c9-9d94-cad0-377b8ee374a6@deltatee.com>
 <20190625072008.GB30350@lst.de>
 <f0f002bf-2b94-cd18-d18f-5d0b08311495@deltatee.com>
 <20190625170115.GA9746@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190625170115.GA9746@lst.de>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org



On 2019-06-25 11:01 a.m., Christoph Hellwig wrote:
> On Tue, Jun 25, 2019 at 09:57:52AM -0600, Logan Gunthorpe wrote:
>>> You assume all addressing is done by the PCI bus address.  If a device
>>> is addressing its own BAR there is no reason to use the PCI bus address,
>>> as it might have much more intelligent schemes (usually bar + offset).
>>
>> Yes, that will be a bit tricky regardless of what we do.
> 
> At least right now it isn't at all.  I've implemented support for
> a draft NVMe proposal for that, and it basically boils down to this
> in the p2p path:
> 
> 	addr = sg_phys(sg);
> 
> 	if (page->pgmap->dev == ctrl->dev && HAS_RELATIVE_ADDRESSING)
> 		addr -= ctrl->cmb_start_addr;
> 
> 		// set magic flag in the SGL
> 	} else {
> 		addr -= pgmap->pci_p2pdma_bus_offset;
> 	}
> 
> without the pagemap it would require a range compare instead, which
> isn't all that hard either.
> 
>>>>> Also duplicating the whole block I/O stack, including hooks all over
>>>>> the fast path is pretty much a no-go.
>>>>
>>>> There was very little duplicate code in the patch set. (Really just the
>>>> mapping code). There are a few hooks, but in practice not that many if
>>>> we ignore the WARN_ONs. We might be able to work to reduce this further.
>>>> The main hooks are: when we skip bouncing, when we skip integrity prep,
>>>> when we split, and when we map. And the patchset drops the PCI_P2PDMA
>>>> hook when we map. So we're talking about maybe three or four extra ifs
>>>> that would likely normally be fast due to the branch predictor.
>>>
>>> And all of those add code to the block layer fast path.
>>
>> If we can't add any ifs to the block layer, there's really nothing we
>> can do.
> 
> That is not what I said.  Of course we can.  But we rather have a
> really good reason.  And adding a parallel I/O path violating the
> highlevel model is not one.
> 
>> So then we're committed to using struct page for P2P?
> 
> Only until we have a significantly better soltution.  And I think
> using physical address in some form instead of pages is that,
> adding a parallel path with dma_addr_t is not, it actually is worse
> than the current code in many respects.

Well whether it's dma_addr_t, phys_addr_t, pfn_t the result isn't all
that different. You still need roughly the same 'if' hooks for any
backed memory that isn't in the linear mapping and you can't get a
kernel mapping for directly.

It wouldn't be too hard to do a similar patch set that uses something
like phys_addr_t instead and have a request and queue flag for support
of non-mappable memory. But you'll end up with very similar 'if' hooks
and we'd have to clean up all bio-using drivers that access the struct
pages directly.

Though, we'd also still have the problem of how to recognize when the
address points to P2PDMA and needs to be translated to the bus offset.
The map-first inversion was what helped here because the driver
submitting the requests had all the information. Though it could be
another request flag and indicating non-mappable memory could be a flag
group like REQ_NOMERGE_FLAGS -- REQ_NOMAP_FLAGS.

If you think any of the above ideas sound workable I'd be happy to try
to code up another prototype.

Logan
