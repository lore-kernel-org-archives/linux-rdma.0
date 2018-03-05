From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 07/10] nvme-pci: Use PCI p2pmem subsystem to manage the
 CMB
Date: Mon, 5 Mar 2018 21:57:27 +0200
Message-ID: <36c78987-006a-a97f-1d18-b0a08cbea9d4@grimberg.me>
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

Keith, while we're on this, regardless of cmb, is SQE memcopy and DB 
update ordering always guaranteed?

If you look at mlx4 (rdma device driver) that works exactly the same as
nvme you will find:
--
                 qp->sq.head += nreq;

                 /*
                  * Make sure that descriptors are written before
                  * doorbell record.
                  */
                 wmb();

                 writel(qp->doorbell_qpn,
                        to_mdev(ibqp->device)->uar_map + 
MLX4_SEND_DOORBELL);

                 /*
                  * Make sure doorbells don't leak out of SQ spinlock
                  * and reach the HCA out of order.
                  */
                 mmiowb();
--

That seems to explicitly make sure to place a barrier before updating
the doorbell. So as I see it, either ordering is guaranteed and the
above code is redundant, or nvme needs to do the same.

Thoughts?
