From: Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/4] DAPL: Support for Linux on System z in perftest package
Date: Thu, 19 Dec 2013 12:53:18 +0100
Message-ID: <1387453998-27416-6-git-send-email-alexey_ishchuk@ru.ibm.com>
References: <1387453998-27416-1-git-send-email-alexey_ishchuk@ru.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387453998-27416-1-git-send-email-alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, klaus.wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

s390: Add support for Linux on System z

This patch adds the required code to support Linux on System z.


diff -aurp /usr/src/packages/BUILD/perftest-2.0/src/get_clock.c perftest-2.0/src/get_clock.c
--- /usr/src/packages/BUILD/perftest-2.0/src/get_clock.c	2013-06-27 14:36:35.000000000 +0200
+++ perftest-2.0/src/get_clock.c	2013-12-17 11:18:44.765167244 +0100
@@ -132,6 +132,7 @@ static double sample_get_cpu_mhz(void)
 	return b;
 }
 
+#ifndef __s390x__
 static double proc_get_cpu_mhz(int no_cpu_freq_fail)
 {
 	FILE* f;
@@ -177,9 +178,13 @@ static double proc_get_cpu_mhz(int no_cp
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
@@ -195,4 +200,5 @@ double get_cpu_mhz(int no_cpu_freq_fail)
 			return sample;
 	}
 	return proc;
+#endif
 }
diff -aurp /usr/src/packages/BUILD/perftest-2.0/src/get_clock.h perftest-2.0/src/get_clock.h
--- /usr/src/packages/BUILD/perftest-2.0/src/get_clock.h	2013-01-09 10:46:27.000000000 +0100
+++ perftest-2.0/src/get_clock.h	2013-12-17 11:18:44.765167244 +0100
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
