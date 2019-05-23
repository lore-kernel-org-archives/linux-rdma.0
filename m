From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v15 00/17] arm64: untag user pointers passed to the kernel
Date: Thu, 23 May 2019 18:00:27 +0100
Message-ID: <20190523170026.nso2me5qnrrjbrdr@mbp>
References: <20190517144931.GA56186@arrakis.emea.arm.com>
 <CAFKCwrj6JEtp4BzhqO178LFJepmepoMx=G+YdC8sqZ3bcBp3EQ@mail.gmail.com>
 <20190521182932.sm4vxweuwo5ermyd@mbp>
 <201905211633.6C0BF0C2@keescook>
 <20190522101110.m2stmpaj7seezveq@mbp>
 <CAJgzZoosKBwqXRyA6fb8QQSZXFqfHqe9qO9je5TogHhzuoGXJQ@mail.gmail.com>
 <20190522163527.rnnc6t4tll7tk5zw@mbp>
 <201905221316.865581CF@keescook>
 <20190523144449.waam2mkyzhjpqpur@mbp>
 <CAJgzZoqX--Kd9=Kjpnfz-5cjVJ=TdsXM5dJM_EjLFKniVbny2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJgzZoqX--Kd9=Kjpnfz-5cjVJ=TdsXM5dJM_EjLFKniVbny2w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: enh <enh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Evgenii Stepanov <eugenis@google.com>, Andrey Konovalov <andreyknvl@google.com>, Khalid Aziz <khalid.aziz@oracle.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Yishai Hadas <yishaih@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 23, 2019 at 08:44:12AM -0700, enh wrote:
> On Thu, May 23, 2019 at 7:45 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Wed, May 22, 2019 at 01:47:36PM -0700, Kees Cook wrote:
> > > For userspace, how would a future binary choose TBI over MTE? If it's
> > > a library issue, we can't use an ELF bit, since the choice may be
> > > "late" after ELF load (this implies the need for a prctl().) If it's
> > > binary-only ("built with HWKASan") then an ELF bit seems sufficient.
> > > And without the marking, I'd expect the kernel to enforce MTE when
> > > there are high bits.
> >
> > The current plan is that a future binary issues a prctl(), after
> > checking the HWCAP_MTE bit (as I replied to Elliot, the MTE instructions
> > are not in the current NOP space). I'd expect this to be done by the
> > libc or dynamic loader under the assumption that the binaries it loads
> > do _not_ use the top pointer byte for anything else.
> 
> yeah, it sounds like to support hwasan and MTE, the dynamic linker
> will need to not use either itself.
> 
> > With hwasan compiled objects this gets more confusing (any ELF note
> > to identify them?).
> 
> no, at the moment code that wants to know checks for the presence of
> __hwasan_init. (and bionic doesn't actually look at any ELF notes
> right now.) but we can always add something if we need to.

It's a userspace decision to make. In the kernel, we are proposing that
bionic calls a prctl() to enable MTE explicitly. It could first check
for the presence of __hwasan_init.

-- 
Catalin
