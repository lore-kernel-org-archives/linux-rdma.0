From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Mon, 24 Jun 2019 10:55:50 -0300
Message-ID: <20190624135550.GB8268@ziepe.ca>
References: <20190620161240.22738-1-logang@deltatee.com>
 <CAPcyv4ijztOK1FUjLuFing7ps4LOHt=6z=eO=98HHWauHA+yog@mail.gmail.com>
 <20190620193353.GF19891@ziepe.ca>
 <20190624073126.GB3954@lst.de>
 <20190624134641.GA8268@ziepe.ca>
 <20190624135024.GA11248@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190624135024.GA11248@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Logan Gunthorpe <logang@deltatee.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 24, 2019 at 03:50:24PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 24, 2019 at 10:46:41AM -0300, Jason Gunthorpe wrote:
> > BTW, it is not just offset right? It is possible that the IOMMU can
> > generate unique dma_addr_t values for each device?? Simple offset is
> > just something we saw in certain embedded cases, IIRC.
> 
> Yes, it could.  If we are trying to do P2P between two devices on
> different root ports and with the IOMMU enabled we'll generate
> a new bus address for the BAR on the other side dynamically everytime
> we map.

Even with the same root port if ACS is turned on could behave like this.

It is only a very narrow case where you can take shortcuts with
dma_addr_t, and I don't think shortcuts like are are appropriate for
the mainline kernel..

Jason
