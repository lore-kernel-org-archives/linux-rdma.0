From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] util: Add common mmio macros
Date: Tue, 18 Apr 2017 11:28:52 -0600
Message-ID: <20170418172852.GD7181@obsidianresearch.com>
References: <1492123127-6266-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1492123127-6266-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <b35958cf-5e87-3149-5413-eb754ec89b4d@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b35958cf-5e87-3149-5413-eb754ec89b4d-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 18, 2017 at 06:52:00PM +0300, Yishai Hadas wrote:

> >+/* When the arch does not have a 32 bit store we provide an emulation that
> You mean a 64 bit store, correct ?

Yep, thanks

> >+write64_fn_t resolve_mmio_write64_be(void)
> >+{
> >+#if defined(__i386__)
> >+	if (have_sse())
> >+		return &sse_mmio_write64_be;
> >+#endif
> >+	return &pthread_mmio_write64_be;
> 
> This will bring in 32 bit systems code that uses global spinlock comparing
> current usage where a specific spinlock is used, isn't it ?

Yes, that is mostly right. libutil is statically linked to each
provider, so every provider gets its own instance of the global lock.

The only case this would seem to matter is if multiple devices using
the same provider are run concurrently.

We could use a hash scheme or something to multiple the lock, but I'm
really not sure that 32 bit performance matters to anyone anymore?

> see mlx4_write64() which is replaced by that code in downstream patches.

Yes, it will be easier to migrate the entire code base if we don't
have to add more special locking. Since this brings back lockless SSE
on ia32 I feel there are very few systems that would actually hit this
lock and care about the performance of the lock ??

> >+/* The first step is to define the 'raw' accessors. To make this very safe
> >+   with sparse we define two versions of each, a le and a be - however the
> >+   code is always identical.
> >+*/

[..]

> >+#define MAKE_WRITE(_NAME_, _SZ_)                                               \
> >+	static inline void _NAME_##_be(void *addr, __be##_SZ_ value)           \
> >+	{                                                                      \
> >+		s390_mmio_write(addr, &value, sizeof(value));                  \
> >+	}                                                                      \
> >+	static inline void _NAME_##_le(void *addr, __le##_SZ_ value)           \
> >+	{                                                                      \
> >+		s390_mmio_write(addr, &value, sizeof(value));                  \
> >+	}
> 
> I believe that you introduced two different versions (i.e. le/be only for
> semantic reasons as code is really similar, is that correct ?

Yes, as the comment above says.

> >+static inline void mmio_read8(void *addr, uint8_t value)
> 
> Did you refer here to mmio_write8 ?

Yep, I can't even compile test the s390 stuff..

> >+#define MAKE_WRITE(_NAME_, _SZ_)                                               \
> >+	static inline void _NAME_##_be(void *addr, __be##_SZ_ value)           \
> >+	{                                                                      \
> >+		atomic_store_explicit((_Atomic(uint##_SZ_##_t) *)addr,         \
> >+				      (__force uint##_SZ_##_t)value,           \
> >+				      memory_order_relaxed);                   \
> 
> Mightn't this code introduce some overhead comparing direct assignment which
> is used (i.e. mlx5_write64) and replaced by that in downstream patches ?

All of the generated assembly I have inspected says this is at least
identical.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
