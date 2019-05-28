From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH v15 05/17] arms64: untag user pointers passed to memory
 syscalls
Date: Tue, 28 May 2019 17:33:04 -0600
Message-ID: <11193998209cc6ff34e7d704f081206b8787b174.camel@oracle.com>
References: <cover.1557160186.git.andreyknvl@google.com>
 <00eb4c63fefc054e2c8d626e8fedfca11d7c2600.1557160186.git.andreyknvl@google.com>
 <20190527143719.GA59948@MBP.local>
 <20190528145411.GA709@e119886-lin.cambridge.arm.com>
 <20190528154057.GD32006@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190528154057.GD32006@arrakis.emea.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Catalin Marinas <catalin.marinas@arm.com>, Andrew Murray <andrew.murray@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, Christian Koenig <Christian.Koenig@amd.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Will Deacon <will.deacon@arm.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Lee Smith <Lee.Smith@arm.com>, linux-kselftest@vger.kernel.org, Vincenzo Frascino <vincenzo.frascino@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Evgeniy Stepanov <eugenis@google.com>, linux-media@vger.kernel.org, Kees Cook <keescook@chromium.org>, Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>, Andrey Konovalov <andreyknvl@google.com>, Kevin Brodsky <kevin.brodsky@arm.com>, Alex Williamson <alex.williamson@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>Dmitry Vyukov <d>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2019-05-28 at 16:40 +0100, Catalin Marinas wrote:
> On Tue, May 28, 2019 at 03:54:11PM +0100, Andrew Murray wrote:
> > On Mon, May 27, 2019 at 03:37:20PM +0100, Catalin Marinas wrote:
> > > On Mon, May 06, 2019 at 06:30:51PM +0200, Andrey Konovalov wrote:
> > > > This patch is a part of a series that extends arm64 kernel ABI
> > > > to allow to
> > > > pass tagged user pointers (with the top byte set to something
> > > > else other
> > > > than 0x00) as syscall arguments.
> > > > 
> > > > This patch allows tagged pointers to be passed to the following
> > > > memory
> > > > syscalls: brk, get_mempolicy, madvise, mbind, mincore, mlock,
> > > > mlock2,
> > > > mmap, mmap_pgoff, mprotect, mremap, msync, munlock, munmap,
> > > > remap_file_pages, shmat and shmdt.
> > > > 
> > > > This is done by untagging pointers passed to these syscalls in
> > > > the
> > > > prologues of their handlers.
> > > > 
> > > > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > > 
> > > Actually, I don't think any of these wrappers get called (have
> > > you
> > > tested this patch?). Following commit 4378a7d4be30 ("arm64:
> > > implement
> > > syscall wrappers"), I think we have other macro names for
> > > overriding the
> > > sys_* ones.
> > 
> > What is the value in adding these wrappers?
> 
> Not much value, initially proposed just to keep the core changes
> small.
> I'm fine with moving them back in the generic code (but see below).
> 
> I think another aspect is how we define the ABI. Is allowing tags to
> mlock() for example something specific to arm64 or would sparc ADI
> need
> the same? In the absence of other architectures defining such ABI, my
> preference would be to keep the wrappers in the arch code.
> 
> Assuming sparc won't implement untagged_addr(), we can place the
> macros
> back in the generic code but, as per the review here, we need to be
> more
> restrictive on where we allow tagged addresses. For example, if
> mmap()
> gets a tagged address with MAP_FIXED, is it expected to return the
> tag?

I would recommend against any ABI differences between ARM64 MTE/TBI and
sparc ADI unless it simply can not be helped. My understanding of
MTE/TBI is limited, so I will explain how sparc ADI works. On sparc, a
tagged address has no meaning until following steps happen:

1. set the user mode PSTATE.mcde bit. This acts as the master switch to
enable ADI for a process.

2. set TTE.mcd bit on TLB entries that match the address range ADI is
being enabled on.

3. Store version tag for the range of addresses userspace wants ADI
enabled on using "stxa" instruction. These tags are stored in physical
memory by the memory controller.

Steps 1 and 2 are accomplished by userspace by calling mprotect() with
PROT_ADI. Tags are set by storing tags in a loop, for example:

        version = 10;
        tmp_addr = shmaddr;
        end = shmaddr + BUFFER_SIZE;
        while (tmp_addr < end) {
                asm volatile(
                        "stxa %1, [%0]0x90\n\t"
                        :
                        : "r" (tmp_addr), "r" (version));
                tmp_addr += adi_blksz;
        }

With these semantics, giving mmap() or shamat() a tagged address is
meaningless since no tags have been stored at the addresses mmap() will
allocate and one can not store tags before memory range has been
allocated. If we choose to allow tagged addresses to come into mmap()
and shmat(), sparc code can strip the tags unconditionally and that may
help simplify ABI and/or code.

> 
> My thoughts on allowing tags (quick look):
> 
> brk - no
> get_mempolicy - yes
> madvise - yes
> mbind - yes
> mincore - yes
> mlock, mlock2, munlock - yes
> mmap - no (we may change this with MTE but not for TBI)
> mmap_pgoff - not used on arm64
> mprotect - yes
> mremap - yes for old_address, no for new_address (on par with mmap)
> msync - yes
> munmap - probably no (mmap does not return tagged ptrs)
> remap_file_pages - no (also deprecated syscall)
> shmat, shmdt - shall we allow tagged addresses on shared memory?
> 
> The above is only about the TBI ABI while ignoring hardware MTE. For
> the
> latter, we may want to change the mmap() to allow pre-colouring on
> page
> fault which means that munmap()/mprotect() should also support tagged
> pointers. Possibly mremap() as well but we need to decide whether it
> should allow re-colouring the page (probably no, in which case
> old_address and new_address should have the same tag). For some of
> these
> we'll end up with arm64 specific wrappers again, unless sparc ADI
> adopts
> exactly the same ABI restrictions.
> 

Let us keep any restrictions common across ARM64 and sparc. pre-
coloring on sparc in the kernel would mean kernel will have to execute
stxa instructions in a loop for each page being faulted in. Not that
big a deal but doesn't that assume the entire page has the same tag
which is dedcued from the upper bits of address? Shouldn't we support
tags at the same granularity level as what the hardware supports? We
went through this discussion for sparc and decision was to support tags
at the same granularity as hardware. That means we can not deduce tags
from the first address that pioints into an mmap or shmat region. Those
tags and the upper bytes of colored address could change for every
cacheline sized block (64-bytes on sparc M7). We can try to store tags
for an entire region in vma but that is expensive, plus on sparc tags
are set in userspace with no participation from kernel and now we need
a way for userspace to communicate the tags to kernel. From sparc point
of view, making kernel responsible for assigning tags to a page on page
fault is full of pitfalls.

Thanks,
Khalid
