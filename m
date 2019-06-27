From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Thu, 27 Jun 2019 03:32:23 -0300
Message-ID: <20190627063223.GA7736@ziepe.ca>
References: <20190625072008.GB30350@lst.de>
 <f0f002bf-2b94-cd18-d18f-5d0b08311495@deltatee.com>
 <20190625170115.GA9746@lst.de>
 <41235a05-8ed1-e69a-e7cd-48cae7d8a676@deltatee.com>
 <20190626065708.GB24531@lst.de>
 <c15d5997-9ba4-f7db-0e7a-a69e75df316c@deltatee.com>
 <20190626202107.GA5850@ziepe.ca>
 <8a0a08c3-a537-bff6-0852-a5f337a70688@deltatee.com>
 <20190626210018.GB6392@ziepe.ca>
 <c25d3333-dcd5-3313-089b-7fbbd6fbd876@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c25d3333-dcd5-3313-089b-7fbbd6fbd876@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 26, 2019 at 03:18:07PM -0600, Logan Gunthorpe wrote:
> > I don't think we should make drives do that. What if it got CMB memory
> > on some other device?
> 
> Huh? A driver submitting P2P requests finds appropriate memory to use
> based on the DMA device that will be doing the mapping. It *has* to. It
> doesn't necessarily have control over which P2P provider it might find
> (ie. it may get CMB memory from a random NVMe device), but it easily
> knows the NVMe device it got the CMB memory for. Look at the existing
> code in the nvme target.

No, this all thinking about things from the CMB perspective. With CMB
you don't care about the BAR location because it is just a temporary
buffer. That is a unique use model.

Every other case has data residing in BAR memory that can really only
reside in that one place (ie on a GPU/FPGA DRAM or something). When an IO
against that is run it should succeed, even if that means bounce
buffering the IO - as the user has really asked for this transfer to
happen.

We certainly don't get to generally pick where the data resides before
starting the IO, that luxury is only for CMB.

> > I think with some simple caching this will become negligible for cases
> > you care about
> 
> Well *maybe* it will be negligible performance wise, but it's also a lot
> more complicated, code wise. Tree lookups will always be a lot more
> expensive than just checking a flag.

Interval trees are pretty simple API wise, and if we only populate
them with P2P providers you probably find the tree depth is negligible
in current systems with one or two P2P providers.

Jason
