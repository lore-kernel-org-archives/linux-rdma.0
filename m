From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v17 15/15] selftests, arm64: add a selftest for passing
 tagged pointers to kernel
Date: Wed, 12 Jun 2019 16:00:42 +0100
Message-ID: <20190612150040.GH28951@C02TF0J2HF1T.local>
References: <cover.1560339705.git.andreyknvl@google.com>
 <e024234e652f23be4d76d63227de114e7def5dff.1560339705.git.andreyknvl@google.com>
 <7cd942c0-d4c1-0cf4-623a-bce6ef14d992@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <7cd942c0-d4c1-0cf4-623a-bce6ef14d992@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Will Deacon <Will.Deacon@arm.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Khalid Aziz <khalid.aziz@oracle.com>, "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, Felix Kuehling <Felix.Kuehling@amd.com>, Vincenzo Frascino <Vincenzo.Frascino@arm.com>nd <nd@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Leon Romanovsky <leon@kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>, Christoph Hellwig <hch@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dmitry Vyukov <dvyukov@google.com>, Dave P Martin <Dave.Martin@arm.com>, Evgeniy Stepanov <eugenis@google.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 12, 2019 at 01:30:36PM +0100, Szabolcs Nagy wrote:
> On 12/06/2019 12:43, Andrey Konovalov wrote:
> > --- /dev/null
> > +++ b/tools/testing/selftests/arm64/tags_lib.c
> > @@ -0,0 +1,62 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <stdlib.h>
> > +#include <sys/prctl.h>
> > +
> > +#define TAG_SHIFT	(56)
> > +#define TAG_MASK	(0xffUL << TAG_SHIFT)
> > +
> > +#define PR_SET_TAGGED_ADDR_CTRL	55
> > +#define PR_GET_TAGGED_ADDR_CTRL	56
> > +#define PR_TAGGED_ADDR_ENABLE	(1UL << 0)
> > +
> > +void *__libc_malloc(size_t size);
> > +void __libc_free(void *ptr);
> > +void *__libc_realloc(void *ptr, size_t size);
> > +void *__libc_calloc(size_t nmemb, size_t size);
> 
> this does not work on at least musl.
> 
> the most robust solution would be to implement
> the malloc apis with mmap/munmap/mremap, if that's
> too cumbersome then use dlsym RTLD_NEXT (although
> that has the slight wart that in glibc it may call
> calloc so wrapping calloc that way is tricky).
> 
> in simple linux tests i'd just use static or
> stack allocations or mmap.
> 
> if a generic preloadable lib solution is needed
> then do it properly with pthread_once to avoid
> races etc.

Thanks for the feedback Szabolcs. I guess we can go back to the initial
simple test that Andrey had and drop the whole LD_PRELOAD hack (I'll
just use it for my internal testing).

BTW, when you get some time, please review Vincenzo's ABI documentation
patches from a user/libc perspective. Once agreed, they should become
part of this series.

-- 
Catalin
