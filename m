From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Status of "ummunot" branch?
Date: Tue, 4 Jun 2013 11:04:41 -0600
Message-ID: <20130604170441.GA13745@obsidianresearch.com>
References: <EF66BBEB19BADC41AC8CCF5F684F07FC4F643196@xmb-rcd-x01.cisco.com>
 <CAJZOPZJc2Dq2jQgRspP_2c1j=4aJ40UxcBEcyiY_mhHPX1ptPw@mail.gmail.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F657918@xmb-rcd-x01.cisco.com>
 <51ADA761.2080107@mellanox.com>
 <51ADB948.5080903@mellanox.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F659155@xmb-rcd-x01.cisco.com>
 <51ADD489.3020902@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51ADD489.3020902-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 04, 2013 at 02:50:33PM +0300, Haggai Eran wrote:

> Our HCAs use their own page tables, in addition to a TLB cache. A miss
> in the TLB cache that can be filled from the HCA's page tables will not
> cause an RNR NAK, since the HCA can fill it relatively fast without the
> help of the operating system. If the page is missing from the HCA's page
> table though it will trigger a page fault and ask the OS to bring that
> page. Since this might take longer, in these cases we send an RNR NAK.

I also saw the presentation at the OFA conference and had several
questions..

So, my assumption:
 - There is a fast small TLB inside the HCA
 - There is a larger page table the HCA accesses inside the host
   memory

AFAIK, this is basically the construction we have today, and the
larger page table is expected to be fully populated.

Thus, I assume, on-demand allows pages that are 'absent' in the larger
page table to generate faults to the CPU?

So how does lifetime work here?

 - Can you populate the larger page table as soon as registration
   happens, relying on mmu notifier and HCA faults to keep it
   consistent?
 - After a fault happens are the faulted pages pinned? How does
   lifetime work here? What happens when the kernel wants to evict
   a page that has currently ongoing RDMA? What happens if user space
   munmaps something while the remote is doing RDMA to it?
 - If I recall the presentation, the fault-in operation was very slow,
   what is the cause for this?

> > He was very concerned about what the size of the TLB on the HCA,
> > and therefore what the actual run-time behavior would be for
> > sending around large messages via MPI -- i.e., would RDMA'ing 1GB
> > messages now incur this
> > HCA-must-reload-its-TLB-and-therefore-incur-RNR-NAKs behavior?
> > 
> We have a mechanism to prefetch the pages needed for a large message
> upon the first page fault, which can also help amortizing the cost of
> the page fault for larger messages.

My reaction was that a pre-fault WR is needed to make this performant.

But, I also don't fully understand why we need so many faults from the
HCA in the first place. If you've properly solved the lifetime issues
then the initial registration can meaningfully pre-initialize the page
table in many cases, and computing the physical address of a page
should not be so expensive.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
