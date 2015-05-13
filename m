From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] dapl: aarch64 support for linux
Date: Wed, 13 May 2015 15:05:33 -0400
Message-ID: <1431543933-27781-1-git-send-email-msalter@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add atomic ops to fix builds for aarch64 Linux.

Signed-off-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 dapl/udapl/linux/dapl_osd.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/dapl/udapl/linux/dapl_osd.h b/dapl/udapl/linux/dapl_osd.h
index 10f71b0..2b255d0 100644
--- a/dapl/udapl/linux/dapl_osd.h
+++ b/dapl/udapl/linux/dapl_osd.h
@@ -50,7 +50,8 @@
 #endif /* __linux__ */
 
 #if !defined (__i386__) && !defined (__ia64__) && !defined(__x86_64__) && \
-    !defined(__PPC__) && !defined(__PPC64__) && !defined(__s390x__)
+    !defined(__PPC__) && !defined(__PPC64__) && !defined(__s390x__) && \
+    !defined(__aarch64__)
 #error UNDEFINED ARCH
 #endif
 
@@ -214,6 +215,8 @@ dapl_os_atomic_inc (
 	: "=&r" (tmp), "+m" (v)
 	: "b" (v)
 	: "cc");
+#elif defined(__aarch64__)
+    __atomic_fetch_add(v, 1, __ATOMIC_ACQ_REL);
 #else  /* !__ia64__ */
     __asm__ __volatile__ (
 	"lock;" "incl %0"
@@ -258,6 +261,8 @@ dapl_os_atomic_dec (
 	: "=&r" (tmp), "+m" (v)
 	: "b" (v)
 	: "cc");
+#elif defined(__aarch64__)
+    __atomic_fetch_add(v, -1, __ATOMIC_ACQ_REL);
 #else  /* !__ia64__ */
     __asm__ __volatile__ (
 	"lock;" "decl %0"
@@ -322,6 +327,10 @@ dapl_os_atomic_assign (
         : "=&r" (current_value), "=m" (*v)
         : "r" (v), "r" (match_value), "r" (new_value), "m" (*v)
         : "cc", "memory");
+#elif defined(__aarch64__)
+    current_value = match_value;
+    __atomic_compare_exchange_n(v, &current_value, new_value, 1,
+				__ATOMIC_ACQ_REL, __ATOMIC_RELAXED);
 #else
     __asm__ __volatile__ (
         "lock; cmpxchgl %1, %2"
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
