From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Thu, 27 Jun 2019 11:01:54 +0200
Message-ID: <20190627090154.GA11548@lst.de>
References: <20190620161240.22738-1-logang@deltatee.com> <20190624072752.GA3954@lst.de> <558a27ba-e7c9-9d94-cad0-377b8ee374a6@deltatee.com> <20190625072008.GB30350@lst.de> <f0f002bf-2b94-cd18-d18f-5d0b08311495@deltatee.com> <20190625170115.GA9746@lst.de> <41235a05-8ed1-e69a-e7cd-48cae7d8a676@deltatee.com> <20190626065708.GB24531@lst.de> <c15d5997-9ba4-f7db-0e7a-a69e75df316c@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c15d5997-9ba4-f7db-0e7a-a69e75df316c@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 26, 2019 at 12:31:08PM -0600, Logan Gunthorpe wrote:
> > we have a hole behind len where we could store flag.  Preferably
> > optionally based on a P2P or other magic memory types config
> > option so that 32-bit systems with 32-bit phys_addr_t actually
> > benefit from the smaller and better packing structure.
> 
> That seems sensible. The one thing that's unclear though is how to get
> the PCI Bus address when appropriate. Can we pass that in instead of the
> phys_addr with an appropriate flag? Or will we need to pass the actual
> physical address and then, at the map step, the driver has to some how
> lookup the PCI device to figure out the bus offset?

Yes, I think we'll need a lookup mechanism of some kind.
