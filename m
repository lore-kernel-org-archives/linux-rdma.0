From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 6/9] Remove old compat definitions of wmb/rmb/etc
Date: Thu, 29 Sep 2016 14:47:53 -0600
Message-ID: <1475182076-5411-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The canonical place for these is infiniband/arch.h, nothing else
should declare them.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libmlx4/src/mlx4.h   | 24 ------------------------
 libmlx5/src/mlx5.h   | 22 ----------------------
 libmthca/src/mthca.h |  8 --------
 3 files changed, 54 deletions(-)

diff --git a/libmlx4/src/mlx4.h b/libmlx4/src/mlx4.h
index 4551141d2007..1855cfbcbe48 100644
--- a/libmlx4/src/mlx4.h
+++ b/libmlx4/src/mlx4.h
@@ -49,30 +49,6 @@
 
 #include <valgrind/memcheck.h>
 
-#ifndef rmb
-#  define rmb() mb()
-#endif
-
-#ifndef wmb
-#  define wmb() mb()
-#endif
-
-#ifndef wc_wmb
-
-#if defined(__i386__)
-#define wc_wmb() asm volatile("lock; addl $0,0(%%esp) " ::: "memory")
-#elif defined(__x86_64__)
-#define wc_wmb() asm volatile("sfence" ::: "memory")
-#elif defined(__ia64__)
-#define wc_wmb() asm volatile("fwb" ::: "memory")
-#elif defined(__s390x__)
-#define wc_wmb { asm volatile("" : : : "memory") }
-#else
-#define wc_wmb() wmb()
-#endif
-
-#endif
-
 #define HIDDEN		__attribute__((visibility ("hidden")))
 
 #define PFX		"mlx4: "
diff --git a/libmlx5/src/mlx5.h b/libmlx5/src/mlx5.h
index aa8b6feceb4e..c209a7964768 100644
--- a/libmlx5/src/mlx5.h
+++ b/libmlx5/src/mlx5.h
@@ -54,28 +54,6 @@
 
 #include <valgrind/memcheck.h>
 
-#ifndef rmb
-#  define rmb() mb()
-#endif
-
-#ifndef wmb
-#  define wmb() mb()
-#endif
-
-#ifndef wc_wmb
-
-#if defined(__i386__)
-#define wc_wmb() asm volatile("lock; addl $0, 0(%%esp) " ::: "memory")
-#elif defined(__x86_64__)
-#define wc_wmb() asm volatile("sfence" ::: "memory")
-#elif defined(__ia64__)
-#define wc_wmb() asm volatile("fwb" ::: "memory")
-#else
-#define wc_wmb() wmb()
-#endif
-
-#endif
-
 #define HIDDEN		__attribute__((visibility("hidden")))
 
 #ifdef HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
diff --git a/libmthca/src/mthca.h b/libmthca/src/mthca.h
index 18d52291343f..da53010cec69 100644
--- a/libmthca/src/mthca.h
+++ b/libmthca/src/mthca.h
@@ -41,14 +41,6 @@
 
 #include <valgrind/memcheck.h>
 
-#ifndef rmb
-#  define rmb() mb()
-#endif
-
-#ifndef wmb
-#  define wmb() mb()
-#endif
-
 #define HIDDEN		__attribute__((visibility ("hidden")))
 
 #define PFX		"mthca: "
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
