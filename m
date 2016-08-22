From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [RFCv2 07/15] hfi/ipath: Use the name of the provider for the .driver file
Date: Mon, 22 Aug 2016 12:13:30 -0600
Message-ID: <1471889618-1605-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471889618-1605-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The standard is to use the same name for the library and .driver
file. The library is called hfi1verbs/ipathverbs so should the .driver,
add the verbs suffix.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libhfi1verbs/Makefile.am                          | 4 ++--
 libhfi1verbs/{hfi1.driver => hfi1verbs.driver}    | 0
 libipathverbs/Makefile.am                         | 4 ++--
 libipathverbs/{ipath.driver => ipathverbs.driver} | 0
 4 files changed, 4 insertions(+), 4 deletions(-)
 rename libhfi1verbs/{hfi1.driver => hfi1verbs.driver} (100%)
 rename libipathverbs/{ipath.driver => ipathverbs.driver} (100%)

diff --git a/libhfi1verbs/Makefile.am b/libhfi1verbs/Makefile.am
index 2c690b0570fb..d86ea3dd57e6 100644
--- a/libhfi1verbs/Makefile.am
+++ b/libhfi1verbs/Makefile.am
@@ -63,7 +63,7 @@ if HAVE_IBV_DEVICE_LIBRARY_EXTENSION
     src_libhfi1verbs_la_LDFLAGS = -avoid-version -release @IBV_DEVICE_LIBRARY_EXTENSION@ \
         $(hfiverbs_version_script)
     hfiverbsconfdir = $(sysconfdir)/libibverbs.d
-    hfiverbsconf_DATA = hfi1.driver
+    hfiverbsconf_DATA = hfi1verbs.driver
 else
     hfiverbslibdir = $(libdir)/infiniband
     hfiverbslib_LTLIBRARIES = src/hfiverbs.la
@@ -77,7 +77,7 @@ EXTRA_DIST = src/hfiverbs.h \
     config \
     autom4te.cache \
     libhfi1verbs.spec.in \
-    hfi1.driver
+    hfi1verbs.driver
 
 dist-hook: libhfi1verbs.spec
 	cp libhfi1verbs.spec $(distdir)
diff --git a/libhfi1verbs/hfi1.driver b/libhfi1verbs/hfi1verbs.driver
similarity index 100%
rename from libhfi1verbs/hfi1.driver
rename to libhfi1verbs/hfi1verbs.driver
diff --git a/libipathverbs/Makefile.am b/libipathverbs/Makefile.am
index f9d4698c5e2c..4d3e9258d989 100644
--- a/libipathverbs/Makefile.am
+++ b/libipathverbs/Makefile.am
@@ -45,7 +45,7 @@ if HAVE_IBV_DEVICE_LIBRARY_EXTENSION
     src_libipathverbs_la_LDFLAGS = -avoid-version -release @IBV_DEVICE_LIBRARY_EXTENSION@ \
         $(ipathverbs_version_script)
     ipathverbsconfdir = $(sysconfdir)/libibverbs.d
-    ipathverbsconf_DATA = ipath.driver
+    ipathverbsconf_DATA = ipathverbs.driver
 else
     ipathverbslibdir = $(libdir)/infiniband
     ipathverbslib_LTLIBRARIES = src/ipathverbs.la
@@ -59,7 +59,7 @@ EXTRA_DIST = src/ipathverbs.h \
     src/ipath-abi.h \
     src/ipathverbs.map \
     libipathverbs.spec.in \
-    ipath.driver \
+    ipathverbs.driver \
     truescale-serdes.cmds \
     truescale.conf
 
diff --git a/libipathverbs/ipath.driver b/libipathverbs/ipathverbs.driver
similarity index 100%
rename from libipathverbs/ipath.driver
rename to libipathverbs/ipathverbs.driver
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
