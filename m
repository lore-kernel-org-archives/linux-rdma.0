From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v15 00/17] arm64: untag user pointers passed to the kernel
Date: Fri, 24 May 2019 11:11:40 +0100
Message-ID: <20190524101139.36yre4af22bkvatx@mbp>
References: <cover.1557160186.git.andreyknvl@google.com>
 <20190517144931.GA56186@arrakis.emea.arm.com>
 <CAFKCwrj6JEtp4BzhqO178LFJepmepoMx=G+YdC8sqZ3bcBp3EQ@mail.gmail.com>
 <20190521182932.sm4vxweuwo5ermyd@mbp>
 <201905211633.6C0BF0C2@keescook>
 <6049844a-65f5-f513-5b58-7141588fef2b@oracle.com>
 <20190523201105.oifkksus4rzcwqt4@mbp>
 <ffe58af3-7c70-d559-69f6-1f6ebcb0fec6@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ffe58af3-7c70-d559-69f6-1f6ebcb0fec6@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Kees Cook <keescook@chromium.org>, Evgenii Stepanov <eugenis@google.com>, Andrey Konovalov <andreyknvl@google.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 23, 2019 at 03:49:05PM -0600, Khalid Aziz wrote:
> On 5/23/19 2:11 PM, Catalin Marinas wrote:
> > On Thu, May 23, 2019 at 11:51:40AM -0600, Khalid Aziz wrote:
> >> On 5/21/19 6:04 PM, Kees Cook wrote:
> >>> As an aside: I think Sparc ADI support in Linux actually side-stepped
> >>> this[1] (i.e. chose "solution 1"): "All addresses passed to kernel must
> >>> be non-ADI tagged addresses." (And sadly, "Kernel does not enable ADI
> >>> for kernel code.") I think this was a mistake we should not repeat for
> >>> arm64 (we do seem to be at least in agreement about this, I think).
> >>>
> >>> [1] https://lore.kernel.org/patchwork/patch/654481/
> >>
> >> That is a very early version of the sparc ADI patch. Support for tagged
> >> addresses in syscalls was added in later versions and is in the patch
> >> that is in the kernel.
> > 
> > I tried to figure out but I'm not familiar with the sparc port. How did
> > you solve the tagged address going into various syscall implementations
> > in the kernel (e.g. sys_write)? Is the tag removed on kernel entry or it
> > ends up deeper in the core code?
> 
> Another spot I should point out in ADI patch - Tags are not stored in
> VMAs and IOMMU does not support ADI tags on M7. ADI tags are stripped
> before userspace addresses are passed to IOMMU in the following snippet
> from the patch:
> 
> diff --git a/arch/sparc/mm/gup.c b/arch/sparc/mm/gup.c
> index 5335ba3c850e..357b6047653a 100644
> --- a/arch/sparc/mm/gup.c
> +++ b/arch/sparc/mm/gup.c
> @@ -201,6 +202,24 @@ int __get_user_pages_fast(unsigned long start, int
> nr_pages
> , int write,
>         pgd_t *pgdp;
>         int nr = 0;
> 
> +#ifdef CONFIG_SPARC64
> +       if (adi_capable()) {
> +               long addr = start;
> +
> +               /* If userspace has passed a versioned address, kernel
> +                * will not find it in the VMAs since it does not store
> +                * the version tags in the list of VMAs. Storing version
> +                * tags in list of VMAs is impractical since they can be
> +                * changed any time from userspace without dropping into
> +                * kernel. Any address search in VMAs will be done with
> +                * non-versioned addresses. Ensure the ADI version bits
> +                * are dropped here by sign extending the last bit before
> +                * ADI bits. IOMMU does not implement version tags.
> +                */
> +               addr = (addr << (long)adi_nbits()) >> (long)adi_nbits();
> +               start = addr;
> +       }
> +#endif
>         start &= PAGE_MASK;
>         addr = start;
>         len = (unsigned long) nr_pages << PAGE_SHIFT;

Thanks Khalid. I missed that sparc does not enable HAVE_GENERIC_GUP, so
you fix this case here. If we add the generic untagged_addr() macro in
the generic code, I think sparc can start making use of it rather than
open-coding the shifts.

There are a few other other places where tags can leak and the core code
would get confused (for example, madvise()). I presume your user space
doesn't exercise them. On arm64 we plan to just allow the C library to
tag any new memory allocation, so those core code paths would need to be
covered.

And similarly, devices, IOMMU, any DMA would ignore tags.

-- 
Catalin
