From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Fri, 28 Jun 2019 14:29:26 -0300
Message-ID: <20190628172926.GA3877@ziepe.ca>
References: <20190626202107.GA5850@ziepe.ca>
 <8a0a08c3-a537-bff6-0852-a5f337a70688@deltatee.com>
 <20190626210018.GB6392@ziepe.ca>
 <c25d3333-dcd5-3313-089b-7fbbd6fbd876@deltatee.com>
 <20190627063223.GA7736@ziepe.ca>
 <6afe4027-26c8-df4e-65ce-49df07dec54d@deltatee.com>
 <20190627163504.GB9568@ziepe.ca>
 <4894142c-3233-a3bb-f9a3-4a4985136e9b@deltatee.com>
 <20190628045705.GD3705@ziepe.ca>
 <8022a2a4-4069-d256-11da-e6d9b2ffbf60@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8022a2a4-4069-d256-11da-e6d9b2ffbf60@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 28, 2019 at 10:22:06AM -0600, Logan Gunthorpe wrote:

> > Why not?  If we have a 'bar info' structure that could have data
> > transfer op callbacks, infact, I think we might already have similar
> > callbacks for migrating to/from DEVICE_PRIVATE memory with DMA..
> 
> Well it could, in theory be done, but It just seems wrong to setup and
> wait for more DMA requests while we are in mid-progress setting up
> another DMA request. Especially when the block layer has historically
> had issues with stack sizes. It's also possible you might have multiple
> bio_vec's that have to each do a migration and with a hook here they'd
> have to be done serially.

*shrug* this is just standard bounce buffering stuff...
 
> > I think the best reason to prefer a uniform phys_addr_t is that it
> > does give us the option to copy the data to/from CPU memory. That
> > option goes away as soon as the bio sometimes provides a dma_addr_t.
> 
> Not really. phys_addr_t alone doesn't give us a way to copy data. You
> need a lookup table on that address and a couple of hooks.

Yes, I'm not sure how you envision using phys_addr_t without a
lookup.. At the end of the day we must get the src and target 'struct
device' in the dma_map area (at the minimum to compute the offset to
translate phys_addr_t to dma_addr_t) and the only way to do that from
phys_addr_t is via lookup??

> > At least for RDMA, we do have some cases (like siw/rxe, hfi) where
> > they sometimes need to do that copy. I suspect the block stack is
> > similar, in the general case.
> 
> But the whole point of the use cases I'm trying to serve is to avoid the
> root complex. 

Well, I think this is sort of a seperate issue. Generically I think
the dma layer should continue to work largely transparently, and if I
feed in BAR memory that can't be P2P'd it should bounce, just like
all the other DMA limitations it already supports. That is pretty much
its whole purpose in life.

The issue of having the caller optimize what it sends is kind of
separate - yes you definately still need the egress DMA device to
drive CMB buffer selection, and DEVICE_PRIVATE also needs it to decide
if it should migrate or not.

What I see as the question is how to layout the BIO. 

If we agree the bio should only have phys_addr_t then we need some
'bar info' (ie at least the offset) in the dma map and some 'bar info'
(ie the DMA device) during the bio construciton.

What you are trying to do is optimize the passing of that 'bar info'
with a limited number of bits in the BIO.

A single flag means an interval tree, 4-8 bits could build a probably
O(1) hash lookup, 64 bits could store a pointer, etc.

If we can spare 4-8 bits in the bio then I suggest a 'perfect hash
table'. Assign each registered P2P 'bar info' a small 4 bit id and
hash on that. It should be fast enough to not worry about the double
lookup.

Jason
