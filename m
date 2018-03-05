From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 07/10] nvme-pci: Use PCI p2pmem subsystem to manage the
 CMB
Date: Mon, 5 Mar 2018 10:10:41 -0700
Message-ID: <3f56c76d-6a5c-7c2f-5442-c9209749b598@deltatee.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-8-logang@deltatee.com>
 <CAOSf1CEj1vmLLd27-642=XSnL9ODkpEC0qLHA2_W5_7rV5+4Pg@mail.gmail.com>
 <20180305160004.GA30975@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180305160004.GA30975-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver <oohall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 05/03/18 09:00 AM, Keith Busch wrote:
> On Mon, Mar 05, 2018 at 12:33:29PM +1100, Oliver wrote:
>> On Thu, Mar 1, 2018 at 10:40 AM, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:
>>> @@ -429,10 +429,7 @@ static void __nvme_submit_cmd(struct nvme_queue *nvmeq,
>>>   {
>>>          u16 tail = nvmeq->sq_tail;
>>
>>> -       if (nvmeq->sq_cmds_io)
>>> -               memcpy_toio(&nvmeq->sq_cmds_io[tail], cmd, sizeof(*cmd));
>>> -       else
>>> -               memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
>>> +       memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
>>
>> Hmm, how safe is replacing memcpy_toio() with regular memcpy()? On PPC
>> the _toio() variant enforces alignment, does the copy with 4 byte
>> stores, and has a full barrier after the copy. In comparison our
>> regular memcpy() does none of those things and may use unaligned and
>> vector load/stores. For normal (cacheable) memory that is perfectly
>> fine, but they can cause alignment faults when targeted at MMIO
>> (cache-inhibited) memory.
>>
>> I think in this particular case it might be ok since we know SEQs are
>> aligned to 64 byte boundaries and the copy is too small to use our
>> vectorised memcpy(). I'll assume we don't need explicit ordering
>> between writes of SEQs since the existing code doesn't seem to care
>> unless the doorbell is being rung, so you're probably fine there too.
>> That said, I still think this is a little bit sketchy and at the very
>> least you should add a comment explaining what's going on when the CMB
>> is being used. If someone more familiar with the NVMe driver could
>> chime in I would appreciate it.
> 
> I may not be understanding the concern, but I'll give it a shot.
> 
> You're right, the start of any SQE is always 64-byte aligned, so that
> should satisfy alignment requirements.
> 
> The order when writing multiple/successive SQEs in a submission queue
> does matter, and this is currently serialized through the q_lock.
> 
> The order in which the bytes of a single SQE is written doesn't really
> matter as long as the entire SQE is written into the CMB prior to writing
> that SQ's doorbell register.
> 
> The doorbell register is written immediately after copying a command
> entry into the submission queue (ignore "shadow buffer" features),
> so the doorbells written to commands submitted is 1:1.
> 
> If a CMB SQE and DB order is not enforced with the memcpy, then we do
> need a barrier after the SQE's memcpy and before the doorbell's writel.


Thanks for the information Keith.

Adding to this: regular memcpy generally also enforces alignment as 
unaligned access to regular memory is typically bad in some way on most 
arches. The generic memcpy_toio also does not have any barrier as it is 
just a call to memcpy. Arm64 also does not appear to have a barrier in 
its implementation and in the short survey I did I could not find any 
implementation with a barrier. I also did not find a ppc implementation 
in the tree but it would be weird for it to add a barrier when other 
arches do not appear to need it.

We've been operating on the assumption that memory mapped by 
devm_memremap_pages() can be treated as regular memory. This is 
emphasized by the fact that it does not return an __iomem pointer. If 
this assumption does not hold for an arch then we cannot support P2P DMA 
without an overhaul of many kernel interfaces or creating other backend 
interfaces into the drivers which take different data types (ie. we'd 
have to bypass the entire block layer when trying to write data in 
p2pmem to an nvme device. This is very undesirable.

Logan
