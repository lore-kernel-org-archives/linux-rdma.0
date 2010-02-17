From: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: is it possible to avoid syncing after an rdma write?
Date: Wed, 17 Feb 2010 11:54:44 -0800
Message-ID: <4B7C4984.9050004@oracle.com>
References: <4B7B2A6C.80101@oracle.com> <20100217005827.GF16490@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100217005827.GF16490-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> On Tue, Feb 16, 2010 at 03:29:48PM -0800, Andy Grover wrote:
>> Right now, RDS follows each RDMA write op with a Send op, which 1)
>> causes an interrupt and 2) includes the info we need to call
>> ib_dma_sync_sg_for_cpu() for the target of the rdma write.
>>
>> We want to omit the Send. If we don't do the sync on the machine that is
>> the target of the RDMA write, the result is... what exactly? I assume
>> the write to memory is snooped by CPUs, so their cachelines will be
>> properly invalidated. However, Linux DMA-API docs seem pretty clear in
>> insisting on the sync.

<snip>

> What do you intend to replace the SEND with? spin on last byte? There
> are other issues to consider like ordering within the PCI-E fabric..

Well, hopefully nothing. What I'm looking for is to write to a target
region multiple times, as efficiently as possible, but be able to
occasionally read it on the target machine and get consistent results. I
definitely don't want to take an event, and avoiding the CQE would be nice.

What I'm hearing is that I don't have to worry about what the Linux
DMA-API docs say about noncoherent mappings, but I need to be mindful of
IB spec 9.5 section o9-20:

---
o9-20: An application shall not depend of the contents of an RDMA WRITE
buffer at the responder until one of the following has occurred:
* Arrival and Completion of the last RDMA WRITE request packet when
  used with Immediate data.
* Arrival and completion of a subsequent SEND message.
* Update of a memory element by a subsequent ATOMIC operation.
---

So if I do an RDMA write and follow it up with an atomic op, it sounds
like I can achieve the behavior I want, and without an event or CQE.
Although for my particular use case with ongoing writes, the CPU
couldn't fetch more than one value (64bit?) without potentially reading
data from a later write, I would think.

Regards -- Andy

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
