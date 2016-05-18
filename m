From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RFC] libibverbs: add ARM64 memory barrier macros
Date: Wed, 18 May 2016 14:16:39 -0700
Message-ID: <20160518220302.81260E09E9@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The default generic barriers are not correct for ARM64. This results in
data corruption.  The correct macros are lifted from the linux kernel.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

I wonder why the linux kernel doesn't export these?  Also, if the hw
platform is unknown, I don't think libibverbs should pick a default
implementation that might cause data corruption.  Rather, I think it
should just fail a compile on that platform.

Thoughts?

---
 include/infiniband/arch.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/arch.h b/include/infiniband/arch.h
index bc1738a..71f02f8 100644
--- a/include/infiniband/arch.h
+++ b/include/infiniband/arch.h
@@ -122,6 +122,15 @@ static inline uint64_t ntohll(uint64_t x) { return x; }
 #define wmb()	mb()					/* for s390x */
 #define wc_wmb() wmb()					/* for s390x */
 
+#elif defined(__aarch64__)
+
+#define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
+
+#define mb()	dsb(sy)
+#define rmb()	dsb(ld)
+#define wmb()	dsb(st)
+#define wc_wmb() wmb()
+
 #else
 
 #warning No architecture specific defines found.  Using generic implementation.
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
