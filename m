From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Mon, 24 Jun 2019 12:28:33 -0600
Message-ID: <bbd81ef9-b4f7-3ba7-7f93-85f602495e19@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
 <CAPcyv4ijztOK1FUjLuFing7ps4LOHt=6z=eO=98HHWauHA+yog@mail.gmail.com>
 <20190620193353.GF19891@ziepe.ca> <20190624073126.GB3954@lst.de>
 <20190624134641.GA8268@ziepe.ca> <20190624135024.GA11248@lst.de>
 <20190624135550.GB8268@ziepe.ca>
 <7210ba39-c923-79ca-57bb-7cf9afe21d54@deltatee.com>
 <20190624181632.GC8268@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190624181632.GC8268@ziepe.ca>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org



On 2019-06-24 12:16 p.m., Jason Gunthorpe wrote:
> On Mon, Jun 24, 2019 at 10:53:38AM -0600, Logan Gunthorpe wrote:
>>> It is only a very narrow case where you can take shortcuts with
>>> dma_addr_t, and I don't think shortcuts like are are appropriate for
>>> the mainline kernel..
>>
>> I don't think it's that narrow and it opens up a lot of avenues for
>> system design that people are wanting to go. If your high speed data
>> path can avoid the root complex and CPU, you can design a system which a
>> much smaller CPU and fewer lanes directed at the CPU.
> 
> I mean the shortcut that something generates dma_addr_t for Device A
> and then passes it to Device B - that is too hacky for mainline.

Oh, that's not a shortcut. It's completely invalid and not likely to
work in any case. If you're mapping something you have to pass the
device that the dma_addr_t is being programmed into.

> Sounded like this series does generate the dma_addr for the correct
> device..

This series doesn't generate any DMA addresses with dma_map(). The
current p2pdma code ensures everything is behind the same root port and
only uses the pci bus address. This is valid and correct, but yes it's
something to expand upon.

I'll be doing some work shortly to add transactions that go through the
IOMMU and calls dma_map_* when appropriate.

Logan
