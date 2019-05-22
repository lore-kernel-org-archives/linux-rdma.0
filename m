From: Evgenii Stepanov <eugenis@google.com>
Subject: Re: [PATCH v15 00/17] arm64: untag user pointers passed to the kernel
Date: Wed, 22 May 2019 16:03:36 -0700
Message-ID: <CAFKCwrjOjdJAbcABp3qxwyYy+hgfyQirvmqGkDSJVJe5pSz0Uw@mail.gmail.com>
References: <cover.1557160186.git.andreyknvl@google.com> <20190517144931.GA56186@arrakis.emea.arm.com>
 <CAFKCwrj6JEtp4BzhqO178LFJepmepoMx=G+YdC8sqZ3bcBp3EQ@mail.gmail.com>
 <20190521182932.sm4vxweuwo5ermyd@mbp> <201905211633.6C0BF0C2@keescook>
 <20190522101110.m2stmpaj7seezveq@mbp> <CAJgzZoosKBwqXRyA6fb8QQSZXFqfHqe9qO9je5TogHhzuoGXJQ@mail.gmail.com>
 <20190522163527.rnnc6t4tll7tk5zw@mbp> <201905221316.865581CF@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201905221316.865581CF@keescook>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, enh <enh@google.com>, Andrey Konovalov <andreyknvl@google.com>, Khalid Aziz <khalid.aziz@oracle.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Yishai Hadas <yishaih@mellanox.com>, Felix
List-Id: linux-rdma@vger.kernel.org

On Wed, May 22, 2019 at 1:47 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, May 22, 2019 at 05:35:27PM +0100, Catalin Marinas wrote:
> > The two hard requirements I have for supporting any new hardware feature
> > in Linux are (1) a single kernel image binary continues to run on old
> > hardware while making use of the new feature if available and (2) old
> > user space continues to run on new hardware while new user space can
> > take advantage of the new feature.
>
> Agreed! And I think the series meets these requirements, yes?
>
> > For MTE, we just can't enable it by default since there are applications
> > who use the top byte of a pointer and expect it to be ignored rather
> > than failing with a mismatched tag. Just think of a hwasan compiled
> > binary where TBI is expected to work and you try to run it with MTE
> > turned on.
>
> Ah! Okay, here's the use-case I wasn't thinking of: the concern is TBI
> conflicting with MTE. And anything that starts using TBI suddenly can't
> run in the future because it's being interpreted as MTE bits? (Is that
> the ABI concern? I feel like we got into the weeds about ioctl()s and
> one-off bugs...)
>
> So there needs to be some way to let the kernel know which of three
> things it should be doing:
> 1- leaving userspace addresses as-is (present)
> 2- wiping the top bits before using (this series)
> 3- wiping the top bits for most things, but retaining them for MTE as
>    needed (the future)
>
> I expect MTE to be the "default" in the future. Once a system's libc has
> grown support for it, everything will be trying to use MTE. TBI will be
> the special case (but TBI is effectively a prerequisite).
>
> AFAICT, the only difference I see between 2 and 3 will be the tag handling
> in usercopy (all other places will continue to ignore the top bits). Is
> that accurate?
>
> Is "1" a per-process state we want to keep? (I assume not, but rather it
> is available via no TBI/MTE CONFIG or a boot-time option, if at all?)
>
> To choose between "2" and "3", it seems we need a per-process flag to
> opt into TBI (and out of MTE). For userspace, how would a future binary
> choose TBI over MTE? If it's a library issue, we can't use an ELF bit,
> since the choice may be "late" after ELF load (this implies the need
> for a prctl().) If it's binary-only ("built with HWKASan") then an ELF
> bit seems sufficient. And without the marking, I'd expect the kernel to
> enforce MTE when there are high bits.
>
> > I would also expect the C library or dynamic loader to check for the
> > presence of a HWCAP_MTE bit before starting to tag memory allocations,
> > otherwise it would get SIGILL on the first MTE instruction it tries to
> > execute.
>
> I've got the same question as Elliot: aren't MTE instructions just NOP
> to older CPUs? I.e. if the CPU (or kernel) don't support it, it just
> gets entirely ignored: checking is only needed to satisfy curiosity
> or behavioral expectations.

MTE instructions are not NOP. Most of them have side effects (changing
register values, zeroing memory).
This only matters for stack tagging, though. Heap tagging is a runtime
decision in the allocator.

If an image needs to run on old hardware, it will have to do heap tagging only.

> To me, the conflict seems to be using TBI in the face of expecting MTE to
> be the default state of the future. (But the internal changes needed
> for TBI -- this series -- is a prereq for MTE.)
>
> --
> Kees Cook
