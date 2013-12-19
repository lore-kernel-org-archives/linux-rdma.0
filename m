From: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] DAPL: Support for Linux on System z in dapl package
Date: Thu, 19 Dec 2013 12:53:15 +0100
Message-ID: <1387453998-27416-3-git-send-email-alexey_ishchuk@ru.ibm.com>
References: <1387453998-27416-1-git-send-email-alexey_ishchuk@ru.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387453998-27416-1-git-send-email-alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, klaus.wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

s390: Add support for Linux on System z

This patch adds the required code to support Linux on System z.


diff -aurp /usr/src/packages/BUILD/dapl-2.0.38/dapl/udapl/linux/dapl_osd.h dapl-2.0.38/dapl/udapl/linux/dapl_osd.h
--- /usr/src/packages/BUILD/dapl-2.0.38/dapl/udapl/linux/dapl_osd.h	2013-07-22 21:30:02.000000000 +0200
+++ dapl-2.0.38/dapl/udapl/linux/dapl_osd.h	2013-12-12 10:16:35.943796712 +0100
@@ -49,7 +49,7 @@
 #error UNDEFINED OS TYPE
 #endif /* __linux__ */
 
-#if !defined (__i386__) && !defined (__ia64__) && !defined(__x86_64__) && !defined(__PPC__) && !defined(__PPC64__)
+#if !defined (__i386__) && !defined (__ia64__) && !defined(__x86_64__) && !defined(__PPC__) && !defined(__PPC64__) && !defined(__s390x__)
 #error UNDEFINED ARCH
 #endif
 
@@ -156,6 +156,22 @@ int dapl_os_get_env_val (
 
 
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
@@ -179,6 +195,11 @@ dapl_os_atomic_inc (
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
 
@@ -218,6 +239,11 @@ dapl_os_atomic_dec (
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
 
@@ -273,6 +299,13 @@ dapl_os_atomic_assign (
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
diff -aurp /usr/src/packages/BUILD/dapl-2.0.38/dat/common/dat_strerror.c dapl-2.0.38/dat/common/dat_strerror.c
--- /usr/src/packages/BUILD/dapl-2.0.38/dat/common/dat_strerror.c	2013-06-07 02:42:48.000000000 +0200
+++ dapl-2.0.38/dat/common/dat_strerror.c	2013-12-12 10:16:35.943796712 +0100
@@ -43,6 +43,10 @@
 #include <dat2/udat.h>
 #endif				/* __UDAPL__ */
 
+#ifndef NULL
+#define NULL ((void *) 0)
+#endif
+
 /*********************************************************************
  *                                                                   *
  * Internal Function Declarations                                    *

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
