From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [For help] rdma-roce build quesiton
Date: Wed, 26 Oct 2016 15:23:38 +0800
Message-ID: <581059FA.6070507@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi, Jason
I am building my userspace library code using cmake.
after i fix some lines, it is failed.

I directly called the min() from the ccan/minmax.h, the min()
as follows:

#if HAVE_BUILTIN_TYPES_COMPATIBLE_P
#define MINMAX_ASSERT_COMPATIBLE(a, b) \
BUILD_ASSERT(__builtin_types_compatible_p(a, b))
#else
#define MINMAX_ASSERT_COMPATIBLE(a, b) \
do { } while (0)
#endif

#define min(a, b) \
({ \
typeof(a) _a = (a); \
typeof(b) _b = (b); \
MINMAX_ASSERT_COMPATIBLE(typeof(_a), typeof(_b)); \
_a < _b ? _a : _b; \
})

and use #include <ccan/minmax.h> in my .c file where is used the min()

according to the modification, I use the cmd as follows:
CC=aarch64-linux-gnu-gcc cmake -GNinja -DENABLE_RESOLVE_NEIGH=0 -DHAVE_ARCH_ARM64=1 ..

the build is fail and the print log as follows:

error: size of unnamed array is negative
attr->cap.max_recv_wr = min(context->max_qp_wr, attr->cap.max_recv_wr);

Now, after fixed, the error is elimed. the fix as follows:
Fix the HAVE_BUILTIN_TYPES_COMPATIBLE_P for 0 in config.h.in or use the origin definition in my .h file

the origin defintion:
#define min(a, b) \
({ \
typeof(a) _a = (a); \
typeof(b) _b = (b); \
_a < _b ? _a : _b; \
})

but I think that the above modification is not a better approach
I try to change the Optimization Option(from -O0 to -O2) in aarch64-linux-gnu-gcc by finded some material.
CC=aarch64-linux-gnu-gcc cmake -O2 -GNinja -DENABLE_RESOLVE_NEIGH=0 -DHAVE_ARCH_ARM64=1 ..

But the error is not elimed.

Can you give me some guide?

thanks
Lijun ou

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
