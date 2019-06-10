From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v16 02/16] arm64: untag user pointers in access_ok and
 __uaccess_mask_ptr
Date: Mon, 10 Jun 2019 13:36:04 -0700
Message-ID: <201906101335.DF80D631@keescook>
References: <cover.1559580831.git.andreyknvl@google.com>
 <4327b260fb17c4776a1e3c844f388e4948cfb747.1559580831.git.andreyknvl@google.com>
 <20190610175326.GC25803@arrakis.emea.arm.com>
 <201906101106.3CA50745E3@keescook>
 <20190610185329.xhjawzfy4uddrkrj@mbp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190610185329.xhjawzfy4uddrkrj@mbp>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Christian Koenig <Christian.Koenig@amd.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Jens Wiklander <jens.wiklander@linaro.>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 10, 2019 at 07:53:30PM +0100, Catalin Marinas wrote:
> On Mon, Jun 10, 2019 at 11:07:03AM -0700, Kees Cook wrote:
> > On Mon, Jun 10, 2019 at 06:53:27PM +0100, Catalin Marinas wrote:
> > > diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> > > index 3767fb21a5b8..fd191c5b92aa 100644
> > > --- a/arch/arm64/kernel/process.c
> > > +++ b/arch/arm64/kernel/process.c
> > > @@ -552,3 +552,18 @@ void arch_setup_new_exec(void)
> > >  
> > >  	ptrauth_thread_init_user(current);
> > >  }
> > > +
> > > +/*
> > > + * Enable the relaxed ABI allowing tagged user addresses into the kernel.
> > > + */
> > > +int untagged_uaddr_set_mode(unsigned long arg)
> > > +{
> > > +	if (is_compat_task())
> > > +		return -ENOTSUPP;
> > > +	if (arg)
> > > +		return -EINVAL;
> > > +
> > > +	set_thread_flag(TIF_UNTAGGED_UADDR);
> > > +
> > > +	return 0;
> > > +}
> > 
> > I think this should be paired with a flag clearing in copy_thread(),
> > yes? (i.e. each binary needs to opt in)
> 
> It indeed needs clearing though not in copy_thread() as that's used on
> clone/fork but rather in flush_thread(), called on the execve() path.

Ah! Yes, thanks.

> And a note to myself: I think PR_UNTAGGED_ADDR (not UADDR) looks better
> in a uapi header, the user doesn't differentiate between uaddr and
> kaddr.

Good point. I would agree. :)

-- 
Kees Cook
