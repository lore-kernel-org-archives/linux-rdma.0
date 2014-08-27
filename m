From: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 2/5] libibverbs: add support for s390x platform
Date: Wed, 27 Aug 2014 12:24:37 +0200
Message-ID: <1409135080-44991-3-git-send-email-aishchuk@linux.vnet.ibm.com>
References: <1409135080-44991-1-git-send-email-aishchuk@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409135080-44991-1-git-send-email-aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, martin.schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, frank.blaschka-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds the required platform specific code to allow execution of
the libibverbs functions on the s390x platform.

Signed-off-by: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 include/infiniband/arch.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/infiniband/arch.h
+++ b/include/infiniband/arch.h
@@ -115,6 +115,13 @@ static inline uint64_t ntohll(uint64_t x
 #define wmb()	 mb()
 #define wc_wmb() wmb()
 
+#elif defined(__s390x__)
+
+#define mb()	{ asm volatile("" : : : "memory"); }	/* for s390x */
+#define rmb()	mb()					/* for s390x */
+#define wmb()	mb()					/* for s390x */
+#define wc_wmb() wmb()					/* for s390x */
+
 #else
 
 #warning No architecture specific defines found.  Using generic implementation.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
