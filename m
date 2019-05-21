From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v15 00/17] arm64: untag user pointers passed to the kernel
Date: Tue, 21 May 2019 15:48:56 -0300
Message-ID: <20190521184856.GC2922@ziepe.ca>
References: <cover.1557160186.git.andreyknvl@google.com>
 <20190517144931.GA56186@arrakis.emea.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190517144931.GA56186@arrakis.emea.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, Yishai Hadas <yishaih@mellanox.com>, Felix Kuehling <Felix.Kuehling@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Christian Koenig <Christian.Koenig@amd.com>, Mauro Carvalho Chehab <mchehab@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 17, 2019 at 03:49:31PM +0100, Catalin Marinas wrote:

> The tagged pointers (whether hwasan or MTE) should ideally be a
> transparent feature for the application writer but I don't think we can
> solve it entirely and make it seamless for the multitude of ioctls().
> I'd say you only opt in to such feature if you know what you are doing
> and the user code takes care of specific cases like ioctl(), hence the
> prctl() proposal even for the hwasan.

I'm not sure such a dire view is warrented.. 

The ioctl situation is not so bad, other than a few special cases,
most drivers just take a 'void __user *' and pass it as an argument to
some function that accepts a 'void __user *'. sparse et al verify
this. 

As long as the core functions do the right thing the drivers will be
OK.

The only place things get dicy is if someone casts to unsigned long
(ie for vma work) but I think that reflects that our driver facing
APIs for VMAs are compatible with static analysis (ie I have no
earthly idea why get_user_pages() accepts an unsigned long), not that
this is too hard.

Jason
