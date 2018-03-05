From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH v2 07/10] nvme-pci: Use PCI p2pmem subsystem to manage the
 CMB
Date: Mon, 5 Mar 2018 13:02:57 -0500
Message-ID: <f4f69d48-97b2-ebeb-6c97-83878ea4c419@codeaurora.org>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-8-logang@deltatee.com>
 <CAOSf1CEj1vmLLd27-642=XSnL9ODkpEC0qLHA2_W5_7rV5+4Pg@mail.gmail.com>
 <20180305160004.GA30975@localhost.localdomain>
 <3f56c76d-6a5c-7c2f-5442-c9209749b598@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3f56c76d-6a5c-7c2f-5442-c9209749b598@deltatee.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>, Keith Busch <keith.busch@intel.com>, Oliver <oohall@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On 3/5/2018 12:10 PM, Logan Gunthorpe wrote:
> 
> 
> On 05/03/18 09:00 AM, Keith Busch wrote:
>> On Mon, Mar 05, 2018 at 12:33:29PM +1100, Oliver wrote:
>>> On Thu, Mar 1, 2018 at 10:40 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
>>>> @@ -429,10 +429,7 @@ static void __nvme_submit_cmd(struct nvme_queue *nvmeq,
>>>>   {
>>>>          u16 tail = nvmeq->sq_tail;
>>>
>>>> -       if (nvmeq->sq_cmds_io)
>>>> -               memcpy_toio(&nvmeq->sq_cmds_io[tail], cmd, sizeof(*cmd));
>>>> -       else
>>>> -               memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
>>>> +       memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
>>>
>>> Hmm, how safe is replacing memcpy_toio() with regular memcpy()? On PPC
>>> the _toio() variant enforces alignment, does the copy with 4 byte
>>> stores, and has a full barrier after the copy. In comparison our
>>> regular memcpy() does none of those things and may use unaligned and
>>> vector load/stores. For normal (cacheable) memory that is perfectly
>>> fine, but they can cause alignment faults when targeted at MMIO
>>> (cache-inhibited) memory.
>>>
>>> I think in this particular case it might be ok since we know SEQs are
>>> aligned to 64 byte boundaries and the copy is too small to use our
>>> vectorised memcpy(). I'll assume we don't need explicit ordering
>>> between writes of SEQs since the existing code doesn't seem to care
>>> unless the doorbell is being rung, so you're probably fine there too.
>>> That said, I still think this is a little bit sketchy and at the very
>>> least you should add a comment explaining what's going on when the CMB
>>> is being used. If someone more familiar with the NVMe driver could
>>> chime in I would appreciate it.
>>
>> I may not be understanding the concern, but I'll give it a shot.
>>
>> You're right, the start of any SQE is always 64-byte aligned, so that
>> should satisfy alignment requirements.
>>
>> The order when writing multiple/successive SQEs in a submission queue
>> does matter, and this is currently serialized through the q_lock.
>>
>> The order in which the bytes of a single SQE is written doesn't really
>> matter as long as the entire SQE is written into the CMB prior to writing
>> that SQ's doorbell register.
>>
>> The doorbell register is written immediately after copying a command
>> entry into the submission queue (ignore "shadow buffer" features),
>> so the doorbells written to commands submitted is 1:1.
>>
>> If a CMB SQE and DB order is not enforced with the memcpy, then we do
>> need a barrier after the SQE's memcpy and before the doorbell's writel.
> 
> 
> Thanks for the information Keith.
> 
> Adding to this: regular memcpy generally also enforces alignment as unaligned access to regular memory is typically bad in some way on most arches. The generic memcpy_toio also does not have any barrier as it is just a call to memcpy. Arm64 also does not appear to have a barrier in its implementation and in the short survey I did I could not find any implementation with a barrier. I also did not find a ppc implementation in the tree but it would be weird for it to add a barrier when other arches do not appear to need it.
> 
> We've been operating on the assumption that memory mapped by devm_memremap_pages() can be treated as regular memory. This is emphasized by the fact that it does not return an __iomem pointer. If this assumption does not hold for an arch then we cannot support P2P DMA without an overhaul of many kernel interfaces or creating other backend interfaces into the drivers which take different data types (ie. we'd have to bypass the entire block layer when trying to write data in p2pmem to an nvme device. This is very undesirable.
> 

writel has a barrier inside on ARM64.

https://elixir.bootlin.com/linux/latest/source/arch/arm64/include/asm/io.h#L143

Why do you need another barrier?


ACCESSING DEVICES
-----------------

Many devices can be memory mapped, and so appear to the CPU as if they're just
a set of memory locations.  To control such a device, the driver usually has to
make the right memory accesses in exactly the right order.

However, having a clever CPU or a clever compiler creates a potential problem
in that the carefully sequenced accesses in the driver code won't reach the
device in the requisite order if the CPU or the compiler thinks it is more
efficient to reorder, combine or merge accesses - something that would cause
the device to malfunction.

Inside of the Linux kernel, I/O should be done through the appropriate accessor
routines - such as inb() or writel() - which know how to make such accesses
appropriately sequential. 


> Logan
> 
> 
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
