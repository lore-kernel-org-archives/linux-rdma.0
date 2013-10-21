From: konrad wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] BUG: bad page map under Xen
Date: Mon, 21 Oct 2013 09:57:36 -0400
Message-ID: <526532D0.7040402@oracle.com>
References: <20131021115740.GN20913@ics.muni.cz> <52652534.2040303@oracle.com> <526545E002000078000FC5F1@nat28.tlf.novell.com> <52652E95.3020305@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52652E95.3020305-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: Lukas Hejtmanek <xhejtman-8qz54MUs51PtwjQa/ONI9g@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On 10/21/2013 9:39 AM, konrad wilk wrote:
>
> On 10/21/2013 9:18 AM, Jan Beulich wrote:
>>>>> On 21.10.13 at 14:59, konrad wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>> It is a bug in the drivers I believe. The issue is that the mapping
>>> created for the second mmap
>>> call is done without VM_IO and on an PFN that is RAM (and not the BAR).
>> So while putting together the reply that I had sent to Lukas a
>> minute ago I was actually hunting for that VM_IO -> _PAGE_IOMAP
>> translation, and wasn't able to find it anywhere. As you say it
>> nevertheless exists - what am I overlooking (and why would then
>> pci_mmap_page_range() nevertheless have to set _PAGE_IOMAP
>> by hand)?
>
> The P2M (arch/x86/xen/p2m.c) is consulted which for the MMIO gaps and
> E820_RESV has the MFNs set to the PFN. This is the 1-1 pfn/mfn stuff 
> that I implemented
> some time ago - as hpa was opposed to having the _PAGE_IOMAP being 
> stuck on any macro
> call to pgprot_writecombine|noncached|etc. Or perhaps that was on the 
> arch_something_prot.

This is the one that Jeremy cooked up some time ago:
http://lkml.indiana.edu/hypermail/linux/kernel/1010.2/03012.html

And here was the thread:
http://www.spinics.net/lists/linux-rdma/msg07085.html

which I thought had been fixed by the P2M identity code.
>
> Anyhow, the odd thing is that looking at the code:
>
>  669                 if (io_remap_pfn_range(vma, vma->vm_start,
>  670 to_mucontext(context)->uar.pfn +
>  671 dev->dev->caps.num_uars,
>  672                                        PAGE_SIZE, 
> vma->vm_page_prot))
>
> The PFN in question (uar.pfn) is in mlx4_uar_alloc is set to:
>
> 159         uar->pfn = (pci_resource_start(dev->pdev, 2) >> 
> PAGE_SHIFT) + offset;
>
> So is the BAR not in the MMIO region? Or is it the 64-bit type MMIO 
> that lays outside the 4GB and
> hence when the P2M is consulted it thinks its INVALID_P2M_ENTRY?
>
> Which comes back to the bug you (Jan) discovered when you pointed out 
> that PVH needs to setup MMIO entries
> for 64-bit MMIO regions which can be outside the 4GB region <sigh>. 
> And that is something the pvops kernel
> completly ignores as it assumes that any region past the E820 can be 
> used for ballooning.
>
> Anyhow, one easy thing to figure out is to get the lspci -v output 
> from the InfiniBand card
> to see where its BARs are, and also the start of the kernel. You 
> should see an E820 map (please also boot with
> "debug" on the Linux command line).
>
>> Jan
>>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
