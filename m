From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] Add new configure flag to enable/disable
 the rdma-ndd build
Date: Thu, 05 Feb 2015 07:19:15 -0500
Message-ID: <54D35FC3.60407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add new flag --enable-rdma-ndd (default=yes) 

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/Makefile.am b/Makefile.am
index 4e08c2b..63c4b48 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -15,9 +15,11 @@ sbin_PROGRAMS = src/ibaddr src/ibnetdiscover src/ibping src/ibportstate \
 	        src/perfquery src/sminfo src/smpdump src/smpquery \
 	        src/saquery src/vendstat src/iblinkinfo \
 		src/ibqueryerrors src/ibcacheedit src/ibccquery \
-		src/ibccconfig \
-		src/dump_fts \
-		src/rdma-ndd
+		src/ibccconfig src/dump_fts
+
+if ENABLE_RDMA_NDD
+sbin_PROGRAMS += src/rdma-ndd
+endif
 
 if ENABLE_TEST_UTILS
 sbin_PROGRAMS += src/ibsendtrap src/mcm_rereg_test
@@ -71,10 +73,13 @@ man_MANS = doc/man/ibaddr.8 \
 		doc/man/smpquery.8 \
 		doc/man/vendstat.8 \
 		doc/man/infiniband-diags.8 \
-		doc/man/rdma-ndd.8 \
 		man/dump_lfts.8 \
 		man/dump_mfts.8
 
+if ENABLE_RDMA_NDD
+man_MANS += doc/man/rdma-ndd.8
+endif
+
 # define this for the dist target
 compat_man_pages = man/ibdiscover.8 man/ibcheckerrors.8 man/ibcheckerrs.8 \
 		man/ibchecknet.8 man/ibchecknode.8 man/ibcheckport.8 \
@@ -161,6 +166,8 @@ install-data-hook:
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/error_thresholds $(DESTDIR)/$(sysconfdir)/infiniband-diags
 	$(top_srcdir)/config/install-sh -c -m 400 $(top_srcdir)/etc/ibdiag.conf $(DESTDIR)/$(sysconfdir)/infiniband-diags
 
+if ENABLE_RDMA_NDD
 install-exec-hook:
 	$(top_srcdir)/config/install-sh -m 755 -d $(DESTDIR)/$(sysconfdir)/init.d
 	$(top_srcdir)/config/install-sh -m 755 $(top_srcdir)/etc/rdma-ndd.init $(DESTDIR)/$(sysconfdir)/init.d/rdma-ndd
+endif
diff --git a/configure.ac b/configure.ac
index ed1b834..11f47f7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -180,6 +180,18 @@ fi
 AC_SUBST(ibnetdisc_api_version)
 dnl End libibnetdisc stuff
 
+dnl with or with rdma-ndd
+AC_MSG_CHECKING(for --enable-rdma-ndd)
+AC_ARG_ENABLE(rdma-ndd,
+[  --enable-rdma-ndd build rdma-ndd (default=yes)],
+[case "${enableval}" in
+  yes) rdmandd=yes ;;
+  no)  rdmandd=no ;;
+  *) AC_MSG_ERROR(bad value ${enableval} for --enable-rdma-ndd) ;;
+esac],[rdmandd=yes])
+AM_CONDITIONAL(ENABLE_RDMA_NDD, test x$rdmandd = xyes)
+AC_MSG_RESULT(${rdmandd=no})
+
 dnl configures for rdma-ndd startup script
 default_rdma_service=openibd
 AC_ARG_WITH([rdma_service],
@@ -198,9 +210,12 @@ default_start="null"
 AC_SUBST(DEFAULT_START, $default_start)
 AC_SUBST(DEFAULT_STOP, $default_stop)
 
-AC_CHECK_HEADER(libudev.h, with_udev="yes", with_udev="no")
-AC_CHECK_LIB(udev, udev_monitor_ref, [], AC_MSG_ERROR(libudev is required for rdma-ndd...))
-AC_CHECK_FUNCS_ONCE(udev_get_sys_path)
+if test x$rdmandd = xyes; then
+    AC_CHECK_HEADER(libudev.h, with_udev="yes", with_udev="no")
+    AC_CHECK_LIB(udev, udev_monitor_ref, [], AC_MSG_ERROR(libudev is required for rdma-ndd...))
+    AC_CONFIG_FILES([doc/man/rdma-ndd.8 etc/rdma-ndd.init])
+    AC_CHECK_FUNCS_ONCE(udev_get_sys_path)
+fi
 
 dnl Generate doc/man/*.in files if possible
 DOC_DATE="`date +%Y-%m-%d`"
@@ -275,8 +290,6 @@ AC_CONFIG_FILES([\
 	doc/man/smpquery.8 \
 	doc/man/vendstat.8 \
 	doc/man/infiniband-diags.8 \
-	doc/man/rdma-ndd.8 \
-	etc/rdma-ndd.init \
 	libibnetdisc/Makefile \
 ])
 AC_OUTPUT
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
