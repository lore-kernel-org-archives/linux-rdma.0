From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [Ksummit-discuss] [TECH TOPIC] IRQ affinity
Date: Wed, 15 Jul 2015 21:24:29 +0300
Message-ID: <55A6A55D.2040205@dev.mellanox.co.il>
References: <20150715120708.GA24534@infradead.org>
 <alpine.DEB.2.11.1507151408570.18576@nanos> <55A67F11.1030709@sandisk.com>
 <alpine.LNX.2.00.1507151700300.15930@localhost.lm.intel.com>
 <55A697A3.3090305@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55A697A3.3090305@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@infradead.org>, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org, ksummit-discuss@lists.linuxfoundation.org
List-Id: linux-rdma@vger.kernel.org

On 7/15/2015 8:25 PM, Jens Axboe wrote:
> On 07/15/2015 11:19 AM, Keith Busch wrote:
>> On Wed, 15 Jul 2015, Bart Van Assche wrote:
>>> * With blk-mq and scsi-mq optimal performance can only be achieved if
>>>  the relationship between MSI-X vector and NUMA node does not change
>>>  over time. This is necessary to allow a blk-mq/scsi-mq driver to
>>>  ensure that interrupts are processed on the same NUMA node as the
>>>  node on which the data structures for a communication channel have
>>>  been allocated. However, today there is no API that allows
>>>  blk-mq/scsi-mq drivers and irqbalanced to exchange information
>>>  about the relationship between MSI-X vector ranges and NUMA nodes.
>>
>> We could have low-level drivers provide blk-mq the controller's irq
>> associated with a particular h/w context, and the block layer can provide
>> the context's cpumask to irqbalance with the smp affinity hint.
>>
>> The nvme driver already uses the hwctx cpumask to set hints, but this
>> doesn't seems like it should be a driver responsibility. It currently
>> doesn't work correctly anyway with hot-cpu since blk-mq could rebalance
>> the h/w contexts without syncing with the low-level driver.
>>
>> If we can add this to blk-mq, one additional case to consider is if the
>> same interrupt vector is used with multiple h/w contexts. Blk-mq's cpu
>> assignment needs to be aware of this to prevent sharing a vector across
>> NUMA nodes.
>
> Exactly. I may have promised to do just that at the last LSF/MM
> conference, just haven't done it yet. The point is to share the mask,
> I'd ideally like to take it all the way where the driver just asks for a
> number of vecs through a nice API that takes care of all this. Lots of
> duplicated code in drivers for this these days, and it's a mess.
>

These are all good points.

But I'm not sure the block layer is always the correct place to take
care of msix vector assignments. It's probably a perfect fit for NVME
and other storage devices, but if we take RDMA for example, block
storage co-exists with file storage, Ethernet traffic and user-space 
applications that do RDMA. All of which share the device MSI-X vectors.
So in this case, the block layer would not be a suitable place to set
IRQ affinity since each deployment might present different constraints.

In any event, the irqbalance daemon is not helping here. Unfortunately
the common practice is to just turn it off in order to get optimized
performance.

Sagi.
