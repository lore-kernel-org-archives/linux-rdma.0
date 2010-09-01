From: James A Simmons <uja-1Heg1YXhbW8@public.gmane.org>
Subject: Makefile fix for infinipath-psm
Date: Wed, 01 Sep 2010 11:23:41 -0400
Message-ID: <1283354621.14487.80.camel@bohr.ornl.gov>
Reply-To: simmonsja-1Heg1YXhbW8@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-pugaclqFxPARQRf7QKod"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OFED <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-pugaclqFxPARQRf7QKod
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch allows make to work. The arch command has gone away with new
coreutils so it is recommended to use uname -m instead.


--=-pugaclqFxPARQRf7QKod
Content-Disposition: attachment; filename=make.diff
Content-Type: text/x-patch; name=make.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- Makefile.orig	2010-09-01 10:57:58.000000000 -0400
+++ Makefile	2010-09-01 10:58:40.000000000 -0400
@@ -69,14 +69,14 @@
 include $(top_srcdir)/buildflags.mak
 lib_build_dir := $(build_dir)
 
-ifneq (x86_64,$(arch))
-   ifneq (i386,$(arch))
-      $(error Unsupported architecture $(arch))
+ifneq (x86_64,$(shell uname -m))
+   ifneq (i386,$(shell uname -m))
+      $(error Unsupported architecture $(shell uname -m))
    endif
 endif
 
 ifndef LIBDIR
-   ifeq (${arch},x86_64)
+   ifeq ($(shell uname -m),x86_64)
       INSTALL_LIB_TARG=/usr/lib64
    else
       INSTALL_LIB_TARG=/usr/lib

--=-pugaclqFxPARQRf7QKod--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
