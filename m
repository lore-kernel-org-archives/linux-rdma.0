From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [PATCH v15 17/17] selftests, arm64: add a selftest for passing
 tagged pointers to kernel
Date: Fri, 31 May 2019 16:21:48 +0200
Message-ID: <CAAeHK+wUerHQOV2PuaTwTxcCucZHZodLwg48228SB+ymxEqT2A@mail.gmail.com>
References: <cover.1557160186.git.andreyknvl@google.com> <e31d9364eb0c2eba8ce246a558422e811d82d21b.1557160186.git.andreyknvl@google.com>
 <20190522141612.GA28122@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190522141612.GA28122@arrakis.emea.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Christian Koenig <Christian.Koenig@amd.com>, Mauro Carvalho Chehab <mchehab@kernel>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 22, 2019 at 4:16 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Mon, May 06, 2019 at 06:31:03PM +0200, Andrey Konovalov wrote:
> > This patch is a part of a series that extends arm64 kernel ABI to allow to
> > pass tagged user pointers (with the top byte set to something else other
> > than 0x00) as syscall arguments.
> >
> > This patch adds a simple test, that calls the uname syscall with a
> > tagged user pointer as an argument. Without the kernel accepting tagged
> > user pointers the test fails with EFAULT.
>
> That's probably sufficient for a simple example. Something we could add
> to Documentation maybe is a small library that can be LD_PRELOAD'ed so
> that you can run a lot more tests like LTP.

Should I add this into this series, or should this go into Vincenzo's patchset?

>
> We could add this to selftests but I think it's too glibc specific.
>
> --------------------8<------------------------------------
> #include <stdlib.h>
>
> #define TAG_SHIFT       (56)
> #define TAG_MASK        (0xffUL << TAG_SHIFT)
>
> void *__libc_malloc(size_t size);
> void __libc_free(void *ptr);
> void *__libc_realloc(void *ptr, size_t size);
> void *__libc_calloc(size_t nmemb, size_t size);
>
> static void *tag_ptr(void *ptr)
> {
>         unsigned long tag = rand() & 0xff;
>         if (!ptr)
>                 return ptr;
>         return (void *)((unsigned long)ptr | (tag << TAG_SHIFT));
> }
>
> static void *untag_ptr(void *ptr)
> {
>         return (void *)((unsigned long)ptr & ~TAG_MASK);
> }
>
> void *malloc(size_t size)
> {
>         return tag_ptr(__libc_malloc(size));
> }
>
> void free(void *ptr)
> {
>         __libc_free(untag_ptr(ptr));
> }
>
> void *realloc(void *ptr, size_t size)
> {
>         return tag_ptr(__libc_realloc(untag_ptr(ptr), size));
> }
>
> void *calloc(size_t nmemb, size_t size)
> {
>         return tag_ptr(__libc_calloc(nmemb, size));
> }
