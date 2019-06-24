From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Mon, 24 Jun 2019 10:53:38 -0600
Message-ID: <7210ba39-c923-79ca-57bb-7cf9afe21d54@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
 <CAPcyv4ijztOK1FUjLuFing7ps4LOHt=6z=eO=98HHWauHA+yog@mail.gmail.com>
 <20190620193353.GF19891@ziepe.ca> <20190624073126.GB3954@lst.de>
 <20190624134641.GA8268@ziepe.ca> <20190624135024.GA11248@lst.de>
 <20190624135550.GB8268@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190624135550.GB8268@ziepe.ca>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org



On 2019-06-24 7:55 a.m., Jason Gunthorpe wrote:
> On Mon, Jun 24, 2019 at 03:50:24PM +0200, Christoph Hellwig wrote:
>> On Mon, Jun 24, 2019 at 10:46:41AM -0300, Jason Gunthorpe wrote:
>>> BTW, it is not just offset right? It is possible that the IOMMU can
>>> generate unique dma_addr_t values for each device?? Simple offset is
>>> just something we saw in certain embedded cases, IIRC.
>>
>> Yes, it could.  If we are trying to do P2P between two devices on
>> different root ports and with the IOMMU enabled we'll generate
>> a new bus address for the BAR on the other side dynamically everytime
>> we map.
> 
> Even with the same root port if ACS is turned on could behave like this.

Yup.

> It is only a very narrow case where you can take shortcuts with
> dma_addr_t, and I don't think shortcuts like are are appropriate for
> the mainline kernel..

I don't think it's that narrow and it opens up a lot of avenues for
system design that people are wanting to go. If your high speed data
path can avoid the root complex and CPU, you can design a system which a
much smaller CPU and fewer lanes directed at the CPU.

Logan
