From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Mon, 24 Jun 2019 10:07:56 -0600
Message-ID: <558a27ba-e7c9-9d94-cad0-377b8ee374a6@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
 <20190624072752.GA3954@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190624072752.GA3954@lst.de>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org



On 2019-06-24 1:27 a.m., Christoph Hellwig wrote:
> This is not going to fly.
> 
> For one passing a dma_addr_t through the block layer is a layering
> violation, and one that I think will also bite us in practice.
> The host physical to PCIe bus address mapping can have offsets, and
> those offsets absolutely can be different for differnet root ports.
> So with your caller generated dma_addr_t everything works fine with
> a switched setup as the one you are probably testing on, but on a
> sufficiently complicated setup with multiple root ports it can break.

I don't follow this argument. Yes, I understand PCI Bus offsets and yes
I understand that they only apply beyond the bus they're working with.
But this isn't *that* complicated and it should be the responsibility of
the P2PDMA code to sort out and provide a dma_addr_t for. The dma_addr_t
that's passed through the block layer could be a bus address or it could
be the result of a dma_map_* request (if the transaction is found to go
through an RC) depending on the requirements of the devices being used.

> Also duplicating the whole block I/O stack, including hooks all over
> the fast path is pretty much a no-go.

There was very little duplicate code in the patch set. (Really just the
mapping code). There are a few hooks, but in practice not that many if
we ignore the WARN_ONs. We might be able to work to reduce this further.
The main hooks are: when we skip bouncing, when we skip integrity prep,
when we split, and when we map. And the patchset drops the PCI_P2PDMA
hook when we map. So we're talking about maybe three or four extra ifs
that would likely normally be fast due to the branch predictor.

> I've been pondering for a while if we wouldn't be better off just
> passing a phys_addr_t + len instead of the page, offset, len tuple
> in the bio_vec, though.  If you look at the normal I/O path here
> is what we normally do:
> 
>  - we get a page as input, either because we have it at hand (e.g.
>    from the page cache) or from get_user_pages (which actually caculates
>    it from a pfn in the page tables)
>  - once in the bio all the merging decisions are based on the physical
>    address, so we have to convert it to the physical address there,
>    potentially multiple times
>  - then dma mapping all works off the physical address, which it gets
>    from the page at the start
>  - then only the dma address is used for the I/O
>  - on I/O completion we often but not always need the page again.  In
>    the direct I/O case for reference counting and dirty status, in the
>    file system also for things like marking the page uptodate
> 
> So if we move to a phys_addr_t we'd need to go back to the page at least
> once.  But because of how the merging works we really only need to do
> it once per segment, as we can just do pointer arithmerics do get the
> following pages.  As we generally go at least once from a physical
> address to a page in the merging code even a relatively expensive vmem_map
> looks shouldn't be too bad.  Even more so given that the super hot path
> (small blkdev direct I/O) can actually trivially cache the affected pages
> as well.

I've always wondered why it wasn't done this way. Passing around a page
pointer *and* an offset always seemed less efficient than just a
physical address. If we did do this, the proposed dma_addr_t and
phys_addr_t paths through the block layer could be a lot more similar as
things like the split calculation could work on either address type.
We'd just have to prevent bouncing and integrity and change have a hook
on how it's mapped.

> Linus kinda hates the pfn approach, but part of that was really that
> it was proposed for file system data, which we all found out really
> can't work as-is without pages the hard way.  Another part probably
> was potential performance issue, but between the few page lookups, and
> the fact that using a single phys_addr_t instead of pfn/page + offset
> should avoid quite a few calculations performance should not actually
> be affected, although we'll have to be careful to actually verify that.

Yes, I'd agree that removing the offset should make things simpler. But
that requires changing a lot of stuff and doesn't really help what I'm
trying to do.

Logan
