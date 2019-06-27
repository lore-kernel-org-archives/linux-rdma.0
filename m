From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC PATCH 00/28] Removing struct page from P2PDMA
Date: Thu, 27 Jun 2019 10:49:43 -0600
Message-ID: <4894142c-3233-a3bb-f9a3-4a4985136e9b@deltatee.com>
References: <20190625170115.GA9746@lst.de>
 <41235a05-8ed1-e69a-e7cd-48cae7d8a676@deltatee.com>
 <20190626065708.GB24531@lst.de>
 <c15d5997-9ba4-f7db-0e7a-a69e75df316c@deltatee.com>
 <20190626202107.GA5850@ziepe.ca>
 <8a0a08c3-a537-bff6-0852-a5f337a70688@deltatee.com>
 <20190626210018.GB6392@ziepe.ca>
 <c25d3333-dcd5-3313-089b-7fbbd6fbd876@deltatee.com>
 <20190627063223.GA7736@ziepe.ca>
 <6afe4027-26c8-df4e-65ce-49df07dec54d@deltatee.com>
 <20190627163504.GB9568@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190627163504.GB9568@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Stephen Bates <sbates@raithlin.com>
List-Id: linux-rdma@vger.kernel.org



On 2019-06-27 10:35 a.m., Jason Gunthorpe wrote:
> On Thu, Jun 27, 2019 at 10:09:41AM -0600, Logan Gunthorpe wrote:
>>
>>
>> On 2019-06-27 12:32 a.m., Jason Gunthorpe wrote:
>>> On Wed, Jun 26, 2019 at 03:18:07PM -0600, Logan Gunthorpe wrote:
>>>>> I don't think we should make drives do that. What if it got CMB memory
>>>>> on some other device?
>>>>
>>>> Huh? A driver submitting P2P requests finds appropriate memory to use
>>>> based on the DMA device that will be doing the mapping. It *has* to. It
>>>> doesn't necessarily have control over which P2P provider it might find
>>>> (ie. it may get CMB memory from a random NVMe device), but it easily
>>>> knows the NVMe device it got the CMB memory for. Look at the existing
>>>> code in the nvme target.
>>>
>>> No, this all thinking about things from the CMB perspective. With CMB
>>> you don't care about the BAR location because it is just a temporary
>>> buffer. That is a unique use model.
>>>
>>> Every other case has data residing in BAR memory that can really only
>>> reside in that one place (ie on a GPU/FPGA DRAM or something). When an IO
>>> against that is run it should succeed, even if that means bounce
>>> buffering the IO - as the user has really asked for this transfer to
>>> happen.
>>>
>>> We certainly don't get to generally pick where the data resides before
>>> starting the IO, that luxury is only for CMB.
>>
>> I disagree. If we we're going to implement a "bounce" we'd probably want
>> to do it in two DMA requests.
> 
> How do you mean?
> 
>> So the GPU/FPGA driver would first decide whether it can do it P2P
>> directly and, if it can't, would want to submit a DMA request copy
>> the data to host memory and then submit an IO normally to the data's
>> final destination.
> 
> I don't think a GPU/FPGA driver will be involved, this would enter the
> block layer through the O_DIRECT path or something generic.. This the
> general flow I was suggesting to Dan earlier

I would say the O_DIRECT path has to somehow call into the driver
backing the VMA to get an address to appropriate memory (in some way
vaguely similar to how we were discussing at LSF/MM). If P2P can't be
done at that point, then the provider driver would do the copy to system
memory, in the most appropriate way, and return regular pages for
O_DIRECT to submit to the block device.

>> I think it would be a larger layering violation to have the NVMe driver
>> (for example) memcpy data off a GPU's bar during a dma_map step to
>> support this bouncing. And it's even crazier to expect a DMA transfer to
>> be setup in the map step.
> 
> Why? Don't we already expect the DMA mapper to handle bouncing for
> lots of cases, how is this case different? This is the best place to
> place it to make it shared.

This is different because it's special memory where the DMA mapper can't
possibly know the best way to transfer the data. The best way to
transfer the data is almost certainly going to be a DMA request handled
by the GPU/FPGA. So, one way or another, the GPU/FPGA driver has to be
involved.

One could argue that the hook to the GPU/FPGA driver could be in the
mapping step but then we'd have to do lookups based on an address --
where as the VMA could more easily have a hook back to whatever driver
exported it.

Logan
