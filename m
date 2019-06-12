From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [PATCH v16 16/16] selftests, arm64: add a selftest for passing
 tagged pointers to kernel
Date: Wed, 12 Jun 2019 13:14:30 +0200
Message-ID: <CAAeHK+x4sHKfQx31uQ9zSO48oRs3XLATfymY=vgEHQ1FLNmeig@mail.gmail.com>
References: <cover.1559580831.git.andreyknvl@google.com> <9e1b5998a28f82b16076fc85ab4f88af5381cf74.1559580831.git.andreyknvl@google.com>
 <20190611150122.GB63588@arrakis.emea.arm.com> <CAAeHK+wZrVXxAnDXBjoUy8JK9iG553G2Bp8uPWQ0u1u5gts0vQ@mail.gmail.com>
 <20190611175037.pflr6q6ob67zjj25@mbp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190611175037.pflr6q6ob67zjj25@mbp>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Christian Koenig <Christian.Koenig@>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 11, 2019 at 7:50 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Tue, Jun 11, 2019 at 07:18:04PM +0200, Andrey Konovalov wrote:
> > On Tue, Jun 11, 2019 at 5:01 PM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > static void *tag_ptr(void *ptr)
> > > {
> > >         static int tagged_addr_err = 1;
> > >         unsigned long tag = 0;
> > >
> > >         if (tagged_addr_err == 1)
> > >                 tagged_addr_err = prctl(PR_SET_TAGGED_ADDR_CTRL,
> > >                                         PR_TAGGED_ADDR_ENABLE, 0, 0, 0);
> >
> > I think this requires atomics. malloc() can be called from multiple threads.
>
> It's slightly racy but I assume in a real libc it can be initialised
> earlier than the hook calls while still in single-threaded mode (I had
> a quick attempt with __attribute__((constructor)) but didn't get far).
>
> Even with the race, under normal circumstances calling the prctl() twice
> is not a problem. I think the risk here is that someone disables the ABI
> via sysctl and the ABI is enabled for some of the threads only.

OK, I'll keep the code racy, but add a comment pointing it out. Thanks!

>
> --
> Catalin
