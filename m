From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 2/3] util/mmio.c: Fix compilation errors when __SSE__ is not set on 32 bit
Date: Mon, 13 Nov 2017 08:08:05 +0200
Message-ID: <20171113060806.27354-3-leon@kernel.org>
References: <20171113060806.27354-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113060806.27354-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When building for 32 bit, the compilation may fail with the following
errors in case that __SSE__ is not set:

In file included from ../util/mmio.c:37:0:
/usr/lib/gcc/x86_64-linux-gnu/4.8/include/xmmintrin.h:31:3: error: #error "SSE instruction set not enabled"

Signed-off-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 util/mmio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/util/mmio.c b/util/mmio.c
index b362a65e..cea4a727 100644
--- a/util/mmio.c
+++ b/util/mmio.c
@@ -33,7 +33,7 @@ static void pthread_mmio_write64_be(void *addr, __be64 val)
 	mmio_wc_spinunlock(&mmio_spinlock);
 }
 
-#if defined(__i386__)
+#if defined(__i386__) && defined(__SSE__)
 #include <xmmintrin.h>
 #include <cpuid.h>
 
@@ -73,7 +73,7 @@ write64_fn_t resolve_mmio_write64_be(void) __asm__("mmio_write64_be");
 
 write64_fn_t resolve_mmio_write64_be(void)
 {
-#if defined(__i386__)
+#if defined(__i386__) && defined(__SSE__)
 	if (have_sse())
 		return &sse_mmio_write64_be;
 #endif
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
