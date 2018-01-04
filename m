From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
Date: Thu, 4 Jan 2018 16:44:00 -0700
Message-ID: <3e8391a9-8924-be6d-8c43-162a360d75b6@deltatee.com>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-7-logang@deltatee.com> <20180104192225.GS11348@ziepe.ca>
 <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com>
 <20180104221337.GV11348@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20180104221337.GV11348@ziepe.ca>
Content-Language: en-US
Sender: linux-pci-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, Stephen Bates <sbates@raithlin.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-Id: linux-rdma@vger.kernel.org



On 04/01/18 03:13 PM, Jason Gunthorpe wrote:
> On Thu, Jan 04, 2018 at 12:52:24PM -0700, Logan Gunthorpe wrote:
>> We tried things like this in an earlier iteration[1] which assumed the SG
>> was homogenous (all P2P or all regular memory). This required serious
>> ugliness to try and ensure SGs were in fact homogenous[2].
> 
> I'm confused, these patches already assume the sg is homogenous,
> right? Sure looks that way. So [2] is just debugging??

Yes, but it's a bit different to expect that someone calling 
pci_p2pmem_map_sg() will know what they're doing and provide a 
homogenous SG. It is relatively clear by convention that the entire SG 
must be homogenous given they're calling a pci_p2pmem function. Where 
as, allowing P2P SGs into the core DMA code means all we can do is hope 
that future developers don't screw it up and allow P2P pages to mix in 
with regular pages.

It's also very difficult to add similar functionality to dma_map_page 
seeing dma_unmap_page won't have any way to know what it's dealing with. 
It just seems confusing to support P2P in the SG version and not the 
page version.

> What I meant is to rely on the fact it is already homogenous and
> create a function like this:
> 
> static inline bool sg_is_table_p2p(struct scatterlist *sg)
> {
>      return is_pci_p2p_page(sg_page(sg));
> }
> 
> And then insert
> 
>    if (sg_is_table_p2p(sg))
>         return pci_p2pmem_map_sg(...);

Yes, this is almost identical to the earlier patch I referenced...

> Then we don't need to patch RDMA because RDMA is not special when it
> comes to P2P. P2P should work with everything.

Yes, I agree this would be very nice. But it's challenging at this time 
to do it safely. And something like this can still be done in future 
work after this patch set gets merged. The changes in this set to the 
RDMA and block layers are fairly small and the majority of the block 
layer changes would still be required anyway to ensure a given 
queue/driver supports P2P requests.
>>> The signature of pci_p2pmem_map_sg also doesn't look very good, it
>>> should mirror the usual dma_map_sg, otherwise it needs more revision
>>> to extend this to do P2P through a root complex.
>>
>> Generally, the feedback that I get is to not make changes that try to
>> anticipate the future. It would be easy enough to add those arguments when
>> the code for going through the RC is made (which I expect will be very
>> involved anyway).
> 
> Yes, but DMA mapping fundamentally requires the arguments to
> dma_map_sg, so it is hard to accept an API called dma_map without
> them.. Maybe just a naming issue.

I don't agree that this is a fundamental requirement. But if no one else 
objects to adding unused arguments I'd be fine with adding them.

Logan
