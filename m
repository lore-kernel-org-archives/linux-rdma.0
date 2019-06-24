From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Mon, 24 Jun 2019 13:37:10 -0600
Message-ID: <980b6d6b-0232-51b6-5aae-03fa8e7fc8e5@deltatee.com>
References: <20190620161240.22738-1-logang@deltatee.com>
 <CAPcyv4ijztOK1FUjLuFing7ps4LOHt=6z=eO=98HHWauHA+yog@mail.gmail.com>
 <20190620193353.GF19891@ziepe.ca> <20190624073126.GB3954@lst.de>
 <20190624134641.GA8268@ziepe.ca> <20190624135024.GA11248@lst.de>
 <20190624135550.GB8268@ziepe.ca>
 <7210ba39-c923-79ca-57bb-7cf9afe21d54@deltatee.com>
 <20190624181632.GC8268@ziepe.ca>
 <bbd81ef9-b4f7-3ba7-7f93-85f602495e19@deltatee.com>
 <20190624185444.GD8268@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190624185444.GD8268@ziepe.ca>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org



On 2019-06-24 12:54 p.m., Jason Gunthorpe wrote:
> On Mon, Jun 24, 2019 at 12:28:33PM -0600, Logan Gunthorpe wrote:
> 
>>> Sounded like this series does generate the dma_addr for the correct
>>> device..
>>
>> This series doesn't generate any DMA addresses with dma_map(). The
>> current p2pdma code ensures everything is behind the same root port and
>> only uses the pci bus address. This is valid and correct, but yes it's
>> something to expand upon.
> 
> I think if you do this it still has to be presented as the same API
> like dma_map that takes in the target device * and produces the device
> specific dma_addr_t

Yes, once we consider the case where it can go through the root complex,
we will need an API similar to dma_map(). We got rid of that API because
it wasn't yet required or used by anything and, per our best practices,
we don't add features that aren't used as that is more confusing for
people reading/reworking the code.

> Otherwise this whole thing is confusing and looks like *all* of it can
> only work under the switch assumption

Hopefully it'll be clearer once we do the work to map for going through
the root complex. It's not that confusing to me. But it's all orthogonal
to the dma_addr_t through the block layer concept.

Logan
