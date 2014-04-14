From: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5] dapl: add support for the s390x platform
Date: Mon, 14 Apr 2014 19:01:08 +0200
Message-ID: <1397494869-43842-5-git-send-email-alexey_ishchuk@ru.ibm.com>
References: <1397494869-43842-1-git-send-email-alexey_ishchuk@ru.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397494869-43842-1-git-send-email-alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds the dapl_os_atopmic_inc, dapl_os_atomic_dec, and
dapl_os_atomic_assign function implementatios to the dapl userspace package
to provide the DAPL API support on the s390x platform by adding Assembler
language implemenation of those platform specific functions.

Signed-off-by: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
---
 dapl/udapl/linux/dapl_osd.h |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

--- a/dapl/udapl/linux/dapl_osd.h
+++ b/dapl/udapl/linux/dapl_osd.h
@@ -49,7 +49,9 @@
 #error UNDEFINED OS TYPE
 #endif /* __linux__ */
 
-#if !defined (__i386__) && !defined (__ia64__) && !defined(__x86_64__) && !defined(__PPC__) && !defined(__PPC64__)
+#if !defined(__i386__) && !defined(__ia64__) \
+&& !defined(__x86_64__) && !defined(__PPC__) && !defined(__PPC64__) \
+&& !defined(__s390x__)
 #error UNDEFINED ARCH
 #endif
 
@@ -156,6 +158,22 @@ int dapl_os_get_env_val (
 
 
 /* atomic functions */
+#ifdef __s390x__
+#define DAPL_CS_ADD(ptr, op_val) ({		\
+	int old_val, new_val;				\
+	__asm__ __volatile__(				\
+		"	l	%0,%2\n"		\
+		"0:	lr	%1,%0\n"		\
+		"	ar	%1,%3\n"		\
+		"	cs	%0,%1,%2\n"		\
+		"	jl	0b"			\
+		: "=&d" (old_val), "=&d" (new_val),	\
+		  "=Q" (*ptr)				\
+		: "d" (op_val), "Q" (*ptr)		\
+		: "cc", "memory");			\
+	new_val;					\
+})
+#endif
 
 /* dapl_os_atomic_inc
  *
@@ -179,6 +197,11 @@ dapl_os_atomic_inc (
 #else
 	IA64_FETCHADD(old_value,v,1,4);
 #endif
+#elif defined(__s390x__)
+	DAT_COUNT	tmp;
+	DAT_COUNT	delta = 1;
+
+	tmp = DAPL_CS_ADD(v, delta);
 #elif defined(__PPC__) || defined(__PPC64__)
 	int tmp;
 
@@ -218,6 +241,11 @@ dapl_os_atomic_dec (
 #else
 	IA64_FETCHADD(old_value,v,-1,4);
 #endif
+#elif defined(__s390x__)
+	DAT_COUNT	tmp;
+	DAT_COUNT	delta = -1;
+
+	tmp = DAPL_CS_ADD(v, delta);
 #elif defined (__PPC__) || defined(__PPC64__)
 	int tmp;
 
@@ -273,6 +301,13 @@ dapl_os_atomic_assign (
 #else
     current_value = ia64_cmpxchg(acq,v,match_value,new_value,4);
 #endif /* __ia64__ */
+#elif defined(__s390x__)
+	__asm__ __volatile__(
+		"	cs	%0,%2,%1\n"
+		: "+d" (match_value), "=Q" (*v)
+		: "d" (new_value), "Q" (*v)
+		: "cc", "memory");
+	current_value = match_value;
 #elif defined(__PPC__) || defined(__PPC64__)
         __asm__ __volatile__ (
 "       lwsync\n\

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
