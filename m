From: Evgenii Stepanov <eugenis@google.com>
Subject: Re: [PATCH v17 03/15] arm64: Introduce prctl() options to control the
 tagged user addresses ABI
Date: Mon, 17 Jun 2019 14:59:29 -0700
Message-ID: <CAFKCwrhuQ+x-KprJV=CPCrnQR9Ky9qL=M5q_pa3fGj27oo4mng@mail.gmail.com>
References: <cover.1560339705.git.andreyknvl@google.com> <a7a2933bea5fe57e504891b7eec7e9432e5e1c1a.1560339705.git.andreyknvl@google.com>
 <20190617135636.GC1367@arrakis.emea.arm.com> <CAFKCwrjJ+0ijNKa3ioOP7xa91QmZU0NhkO=tNC-Q_ThC69vTug@mail.gmail.com>
 <20190617171813.GC34565@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617171813.GC34565@arrakis.emea.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 17, 2019 at 10:18 AM Catalin Marinas
<catalin.marinas@arm.com> wrote:
>
> On Mon, Jun 17, 2019 at 09:57:36AM -0700, Evgenii Stepanov wrote:
> > On Mon, Jun 17, 2019 at 6:56 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > On Wed, Jun 12, 2019 at 01:43:20PM +0200, Andrey Konovalov wrote:
> > > > From: Catalin Marinas <catalin.marinas@arm.com>
> > > >
> > > > It is not desirable to relax the ABI to allow tagged user addresses into
> > > > the kernel indiscriminately. This patch introduces a prctl() interface
> > > > for enabling or disabling the tagged ABI with a global sysctl control
> > > > for preventing applications from enabling the relaxed ABI (meant for
> > > > testing user-space prctl() return error checking without reconfiguring
> > > > the kernel). The ABI properties are inherited by threads of the same
> > > > application and fork()'ed children but cleared on execve().
> > > >
> > > > The PR_SET_TAGGED_ADDR_CTRL will be expanded in the future to handle
> > > > MTE-specific settings like imprecise vs precise exceptions.
> > > >
> > > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > >
> > > A question for the user-space folk: if an application opts in to this
> > > ABI, would you want the sigcontext.fault_address and/or siginfo.si_addr
> > > to contain the tag? We currently clear it early in the arm64 entry.S but
> > > we could find a way to pass it down if needed.
> >
> > For HWASan this would not be useful because we instrument memory
> > accesses with explicit checks anyway. For MTE, on the other hand, it
> > would be very convenient to know the fault address tag without
> > disassembling the code.
>
> I could as this differently: does anything break if, once the user
> opts in to TBI, fault_address and/or si_addr have non-zero top byte?

I think it would be fine.

> Alternatively, we could present the original FAR_EL1 register as a
> separate field as we do with ESR_EL1, independently of whether the user
> opted in to TBI or not.
>
> --
> Catalin
