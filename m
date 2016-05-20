From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/2] Fail compiles if no platform specific memory barriers exist
Date: Fri, 20 May 2016 12:06:40 -0700
Message-ID: <20160520200057.8B9E7E0B9D@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently there is a "generic" implementation for the memory barrier
macros in arch.h.  These turned out to be insuffient for ARM64 causing
memory corruption problems when doing RDMA operations.  So going forward,
fail a compile on a platform w/o platform-specific memory barrier macros.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 include/infiniband/arch.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/include/infiniband/arch.h b/include/infiniband/arch.h
index 3808bb2..de932d4 100644
--- a/include/infiniband/arch.h
+++ b/include/infiniband/arch.h
@@ -132,12 +132,7 @@ static inline uint64_t ntohll(uint64_t x) { return x; }
 
 #else
 
-#warning No architecture specific defines found.  Using generic implementation.
-
-#define mb()	 asm volatile("" ::: "memory")
-#define rmb()	 mb()
-#define wmb()	 mb()
-#define wc_wmb() wmb()
+#error No architecture specific memory barrier defines found!
 
 #endif
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
