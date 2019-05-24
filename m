From: Evgenii Stepanov <eugenis@google.com>
Subject: Re: [PATCH v15 05/17] arms64: untag user pointers passed to memory syscalls
Date: Thu, 23 May 2019 21:23:13 -0700
Message-ID: <CAFKCwrgk0+yR48Z5nhuZG5f7g==vRb4u+CS-4FS0mM7Eriavgw@mail.gmail.com>
References: <cover.1557160186.git.andreyknvl@google.com> <00eb4c63fefc054e2c8d626e8fedfca11d7c2600.1557160186.git.andreyknvl@google.com>
 <20190522114910.emlckebwzv2qz42i@mbp> <CAFKCwrjyP+x0JJy=qpBFsp4pub3He6UkvU0qnf1UOKt6W1LPRQ@mail.gmail.com>
 <20190523090427.GA44383@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190523090427.GA44383@arrakis.emea.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 23, 2019 at 2:04 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Wed, May 22, 2019 at 02:16:57PM -0700, Evgenii Stepanov wrote:
> > On Wed, May 22, 2019 at 4:49 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > On Mon, May 06, 2019 at 06:30:51PM +0200, Andrey Konovalov wrote:
> > > > This patch is a part of a series that extends arm64 kernel ABI to allow to
> > > > pass tagged user pointers (with the top byte set to something else other
> > > > than 0x00) as syscall arguments.
> > > >
> > > > This patch allows tagged pointers to be passed to the following memory
> > > > syscalls: brk, get_mempolicy, madvise, mbind, mincore, mlock, mlock2,
> > > > mmap, mmap_pgoff, mprotect, mremap, msync, munlock, munmap,
> > > > remap_file_pages, shmat and shmdt.
> > > >
> > > > This is done by untagging pointers passed to these syscalls in the
> > > > prologues of their handlers.
> > >
> > > I'll go through them one by one to see if we can tighten the expected
> > > ABI while having the MTE in mind.
> > >
> > > > diff --git a/arch/arm64/kernel/sys.c b/arch/arm64/kernel/sys.c
> > > > index b44065fb1616..933bb9f3d6ec 100644
> > > > --- a/arch/arm64/kernel/sys.c
> > > > +++ b/arch/arm64/kernel/sys.c
> > > > @@ -35,10 +35,33 @@ SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
> > > >  {
> > > >       if (offset_in_page(off) != 0)
> > > >               return -EINVAL;
> > > > -
> > > > +     addr = untagged_addr(addr);
> > > >       return ksys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
> > > >  }
> > >
> > > If user passes a tagged pointer to mmap() and the address is honoured
> > > (or MAP_FIXED is given), what is the expected return pointer? Does it
> > > need to be tagged with the value from the hint?
> >
> > For HWASan the most convenient would be to use the tag from the hint.
> > But since in the TBI (not MTE) mode the kernel has no idea what
> > meaning userspace assigns to pointer tags, perhaps it should not try
> > to guess, and should return raw (zero-tagged) address instead.
>
> Then, just to relax the ABI for hwasan, shall we simply disallow tagged
> pointers on mmap() arguments? We can leave them in for
> mremap(old_address), madvise().

I think this would be fine. We should allow tagged in pointers in
mprotect though.

> > > With MTE, we may want to use this as a request for the default colour of
> > > the mapped pages (still under discussion).
> >
> > I like this - and in that case it would make sense to return the
> > pointer that can be immediately dereferenced without crashing the
> > process, i.e. with the matching tag.
>
> This came up from the Android investigation work where large memory
> allocations (using mmap) could be more efficiently pre-tagged by the
> kernel on page fault. Not sure about the implementation details yet.
>
> --
> Catalin
