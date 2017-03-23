From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] fix udma_to_device_barrier on aarch64
Date: Wed, 22 Mar 2017 22:12:24 -0400
Message-ID: <20170323021224.35722-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The definition for udma_to_device_barrier on aarch64 is missing. Looks
like an oversight in the commit that removed the old barrier macros and
added this one.

Fixes: 85a5529dead5 ("Remove the old barrier macros")
CC: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 util/udma_barrier.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util/udma_barrier.h b/util/udma_barrier.h
index 86578af5..9932a687 100644
--- a/util/udma_barrier.h
+++ b/util/udma_barrier.h
@@ -93,7 +93,7 @@
 #elif defined(__sparc_v9__)
 #define udma_to_device_barrier() asm volatile("membar #StoreStore" ::: "memory")
 #elif defined(__aarch64__)
-#define wmb() asm volatile("dsb st" ::: "memory");
+#define udma_to_device_barrier() asm volatile("dsb st" ::: "memory");
 #elif defined(__sparc__) || defined(__s390x__)
 #define udma_to_device_barrier() asm volatile("" ::: "memory")
 #else
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
