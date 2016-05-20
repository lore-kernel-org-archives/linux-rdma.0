From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/2] libibverbs: add ARM64 memory barrier macros
Date: Fri, 20 May 2016 11:56:12 -0700
Message-ID: <20160520200055.7DB95E0B9D@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The default generic barriers are not correct for ARM64. This results
in data corruption.  The correct macros are based on the ARM Compiler
Toolchain Assembler Reference documenation.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 include/infiniband/arch.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/arch.h b/include/infiniband/arch.h
index bc1738a..3808bb2 100644
--- a/include/infiniband/arch.h
+++ b/include/infiniband/arch.h
@@ -122,6 +122,14 @@ static inline uint64_t ntohll(uint64_t x) { return x; }
 #define wmb()	mb()					/* for s390x */
 #define wc_wmb() wmb()					/* for s390x */
 
+#elif defined(__aarch64__)
+
+/* Perhaps dmb would be sufficient? Let us be conservative for now. */
+#define mb() 	asm volatile("dsb sy" ::: "memory")
+#define rmb()	asm volatile("dsb ld" ::: "memory")
+#define wmb()	asm volatile("dsb st" ::: "memory")
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
