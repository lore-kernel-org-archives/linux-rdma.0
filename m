From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Wed, 5 Jun 2013 10:09:37 +0300
Message-ID: <51AEE431.2090702@mellanox.com>
References: <EF66BBEB19BADC41AC8CCF5F684F07FC4F643196@xmb-rcd-x01.cisco.com> <CAJZOPZJc2Dq2jQgRspP_2c1j=4aJ40UxcBEcyiY_mhHPX1ptPw@mail.gmail.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F657918@xmb-rcd-x01.cisco.com> <51ADA761.2080107@mellanox.com> <51ADB948.5080903@mellanox.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F659155@xmb-rcd-x01.cisco.com> <51ADD489.3020902@mellanox.com> <20130604170441.GA13745@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130604170441.GA13745-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/06/2013 20:04, Jason Gunthorpe wrote:
> Thus, I assume, on-demand allows pages that are 'absent' in the larger
> page table to generate faults to the CPU?
Yes, that's correct.

> So how does lifetime work here?
> 
>  - Can you populate the larger page table as soon as registration
>    happens, relying on mmu notifier and HCA faults to keep it
>    consistent?
We prefer not to keep the entire page table in sync, since we want to
allow registration of larger portions of the virtual address space, and
much of that memory isn't needed by the HCA.

>  - After a fault happens are the faulted pages pinned?
After a page fault happens the faulted pages are mapped in using
get_user_pages, but they are immediately released.

> How does lifetime work here? What happens when the kernel wants to
> evict a page that has currently ongoing RDMA?
If the kernel tries to evict a page that is currently ongoing RDMA, the
driver will update the HCA before the kernel can free the page. If the
RDMA operation is still ongoing, it will trigger a page fault.

> What happens if user space munmaps something while the remote is
> doing RDMA to it?
We want to allow the user to register memory areas that are unmapped. We
only require that the user have some VMA backing the addresses used for
RDMA operations, during the course of these operations. If the user
munmaps something in the middle of an RDMA operation, this will trigger
a page fault, which will in turn close the QP doing the operation with
an error.

>  - If I recall the presentation, the fault-in operation was very slow,
>    what is the cause for this?
Page faults involve stopping the QP, reading the WQE to get the page
ranges needed, bringing the pages to memory using get_user_pages,
updating the HCA's page table (and flushing its caches) and resuming the
QP. With short messages, the commands sent to the device are dominant,
while with larger messages, get_user_pages becomes dominant.

> 
>>> He was very concerned about what the size of the TLB on the HCA,
>>> and therefore what the actual run-time behavior would be for
>>> sending around large messages via MPI -- i.e., would RDMA'ing 1GB
>>> messages now incur this
>>> HCA-must-reload-its-TLB-and-therefore-incur-RNR-NAKs behavior?
>>>
>> We have a mechanism to prefetch the pages needed for a large message
>> upon the first page fault, which can also help amortizing the cost of
>> the page fault for larger messages.
> 
> My reaction was that a pre-fault WR is needed to make this performant.
> 
> But, I also don't fully understand why we need so many faults from the
> HCA in the first place. If you've properly solved the lifetime issues
> then the initial registration can meaningfully pre-initialize the page
> table in many cases, and computing the physical address of a page
> should not be so expensive.

We have implemented a prefetching verb, but I think that in many cases,
with smart enough prefetching logic in the page fault handler, it won't
be needed.

Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
