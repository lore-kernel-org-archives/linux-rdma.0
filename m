From: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/5] perftest: support for the s390x platform
Date: Mon, 14 Apr 2014 19:01:09 +0200
Message-ID: <1397494869-43842-6-git-send-email-alexey_ishchuk@ru.ibm.com>
References: <1397494869-43842-1-git-send-email-alexey_ishchuk@ru.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1397494869-43842-1-git-send-email-alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds the required platform specific code to allow execution of
the perftest package applications on the s390x platform.

Signed-off-by: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
---
 README          |    2 ++
 src/get_clock.c |    6 ++++++
 src/get_clock.h |    8 ++++++++
 3 files changed, 16 insertions(+)

--- a/README
+++ b/README
@@ -234,3 +234,5 @@ Special feature detailed explanation in
     Please use the same perftest version on both sides to ensure consistency of benchmark results.
 
  6. This version (5.0) won't work with previous versions of perftest.
+
+ 7. In the s390x platform virtualized environment the results shown by package test applications can be incorrect.
--- a/src/get_clock.c
+++ b/src/get_clock.c
@@ -132,6 +132,7 @@ static double sample_get_cpu_mhz(void)
 	return b;
 }
 
+#ifndef __s390x__
 static double proc_get_cpu_mhz(int no_cpu_freq_fail)
 {
 	FILE* f;
@@ -181,9 +182,13 @@ static double proc_get_cpu_mhz(int no_cp
 	return mhz;
 }
 
+#endif
 
 double get_cpu_mhz(int no_cpu_freq_fail)
 {
+#ifdef __s390x__
+	return sample_get_cpu_mhz();
+#else
 	double sample, proc, delta;
 	sample = sample_get_cpu_mhz();
 	proc = proc_get_cpu_mhz(no_cpu_freq_fail);
@@ -199,4 +204,5 @@ double get_cpu_mhz(int no_cpu_freq_fail)
 			return sample;
 	}
 	return proc;
+#endif
 }
--- a/src/get_clock.h
+++ b/src/get_clock.h
@@ -70,7 +70,15 @@ static inline cycles_t get_cycles()
 	asm volatile ("mov %0=ar.itc" : "=r" (ret));
 	return ret;
 }
+#elif defined(__s390x__)
+typedef unsigned long long cycles_t;
+static inline cycles_t get_cycles(void)
+{
+	cycles_t	clk;
 
+	asm volatile("stck %0" : "=Q" (clk) : : "cc");
+	return clk >> 2;
+}
 #else
 #warning get_cycles not implemented for this architecture: attempt asm/timex.h
 #include <asm/timex.h>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
