From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] rdma-ndd: add systemd support
Date: Sun, 15 May 2016 03:29:45 -0400
Message-ID: <1463297385-28459-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Also clean up pre/post install scripts for spec files.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am              |    4 ++++
 configure.ac             |   26 +++++++++++++++++++++++++-
 etc/rdma-ndd.service.in  |   12 ++++++++++++
 infiniband-diags.spec.in |   32 ++++++++++++++++----------------
 4 files changed, 57 insertions(+), 17 deletions(-)
 create mode 100644 etc/rdma-ndd.service.in

diff --git a/Makefile.am b/Makefile.am
index 93af707..76d3e90 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -177,6 +177,10 @@ install-data-hook:
 
 if ENABLE_RDMA_NDD
 install-exec-hook:
+if SYSTEMD_SYSTEM_UNIT_DIR
+	$(top_srcdir)/config/install-sh -m 755 $(top_srcdir)/etc/rdma-ndd.service $(DESTDIR)/$(prefix)/$(SYSTEMD_SYSTEM_UNIT_DIR)/rdma-ndd.service
+else
 	$(top_srcdir)/config/install-sh -m 755 -d $(DESTDIR)/$(sysconfdir)/init.d
 	$(top_srcdir)/config/install-sh -m 755 $(top_srcdir)/etc/rdma-ndd.init $(DESTDIR)/$(sysconfdir)/init.d/rdma-ndd
 endif
+endif
diff --git a/configure.ac b/configure.ac
index 9a5e47a..2310bb4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -180,6 +180,28 @@ fi
 AC_SUBST(ibnetdisc_api_version)
 dnl End libibnetdisc stuff
 
+dnl Begin determine the systemd use and location
+use_systemd=`cat /proc/1/comm`
+with_sysemdsystemunitdir="no"
+specfile_install="%{_sysconfdir}/init.d/rdma-ndd"
+if test "x$use_systemd" == xsystemd; then
+	def_systemdsystemunitdir="lib/systemd/system"
+	AC_ARG_WITH([systemdsystemunitdir],
+			AS_HELP_STRING([--with-systemdsystemunitdir=DIR],
+					[Directory for systemd service files]),
+			[with_systemdsystemunitdir=$withval],
+			[with_sysemdsystemunitdir=$def_systemdsystemunitdir])
+	if test "x$with_sysemdsystemunitdir" != xno; then
+		AC_SUBST(SYSTEMD_SYSTEM_UNIT_DIR, [$with_sysemdsystemunitdir])
+		AC_SUBST(SYSTEMD_BUILD_REQUIRES, "BuildRequires: systemd")
+		specfile_install="%{_prefix}/lib/systemd/system/rdma-ndd.service"
+	fi
+fi
+AM_CONDITIONAL(SYSTEMD_SYSTEM_UNIT_DIR, test "x$with_sysemdsystemunitdir" != xno)
+AC_SUBST(SPEC_FILE_RDMA_NDD_INSTALL, $specfile_install)
+dnl End systemd stuff
+
+
 dnl with or with rdma-ndd
 AC_MSG_CHECKING(for --enable-rdma-ndd)
 AC_ARG_ENABLE(rdma-ndd,
@@ -212,7 +234,9 @@ AC_SUBST(DEFAULT_STOP, $default_stop)
 
 AS_IF([test x$rdmandd = xyes], [
     PKG_CHECK_MODULES([UDEV], [libudev])
-    AC_CONFIG_FILES([doc/man/rdma-ndd.8 etc/rdma-ndd.init])
+    AC_CONFIG_FILES([doc/man/rdma-ndd.8 \
+			etc/rdma-ndd.init \
+			etc/rdma-ndd.service])
     AC_SUBST([UDEV_CFLAGS])
     AC_SUBST([UDEV_LIBS])
     if test "$with_udev" = "yes"; then
diff --git a/etc/rdma-ndd.service.in b/etc/rdma-ndd.service.in
new file mode 100644
index 0000000..ef0962b
--- /dev/null
+++ b/etc/rdma-ndd.service.in
@@ -0,0 +1,12 @@
+[Unit]
+Description=RDMA Node Description Daemon
+After=rdma.service
+
+[Service]
+Type=forking
+EnvironmentFile=@IBDIAG_CONFIG_PATH@/ibdiag.conf
+ExecStart=@exec_prefix@/sbin/rdma-ndd
+
+[Install]
+WantedBy=multi-user.target
+
diff --git a/infiniband-diags.spec.in b/infiniband-diags.spec.in
index ab4e182..3ff8c7b 100644
--- a/infiniband-diags.spec.in
+++ b/infiniband-diags.spec.in
@@ -12,6 +12,7 @@ BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
 Source: http://www.openfabrics.org/downloads/management/@TARBALL@
 Url: http://openfabrics.org/
 BuildRequires: libibmad-devel, opensm-devel, libibumad-devel, glib2-devel, libudev-devel
+@SYSTEMD_BUILD_REQUIRES@
 Requires: libibmad, opensm-libs, libibumad, glib2
 Provides: perl(IBswcountlimits)
 Obsoletes: openib-diags
@@ -167,36 +168,35 @@ rm -rf $RPM_BUILD_ROOT
 %define _perldir %(perl -e 'use Config; $T=$Config{installvendorlib}; print $T;')
 %{_perldir}/*
 %{_sysconfdir}/infiniband-diags/*
-%{_sysconfdir}/init.d/rdma-ndd
+@SPEC_FILE_RDMA_NDD_INSTALL@
 %doc README COPYING ChangeLog
 
 
 %post
 if [ $1 = 1 ]; then
-    if [ -e /sbin/chkconfig ]; then
+    if [ -e /etc/init.d/rdma-ndd ] && [ -e /sbin/chkconfig ]; then
         /sbin/chkconfig --add rdma-ndd
-        /sbin/chkconfig rdma-ndd on
-    elif [ -e /usr/sbin/update-rc.d ]; then
-        /usr/sbin/update-rc.d rdma-ndd defaults
-    else
-        /usr/lib/lsb/install_initd /etc/init.d/rdma-ndd
     fi
     if type systemctl >/dev/null 2>&1; then
-        systemctl --system daemon-reload
+        systemctl daemon-reload
     fi
-else
-    /etc/init.d/rdma-ndd condrestart
 fi
 
 %preun
 if [ $1 = 0 ]; then
-    /etc/init.d/rdma-ndd stop
-    if [ -e /sbin/chkconfig ]; then
+    if [ -e /etc/init.d/rdma-ndd ] && [ -e /sbin/chkconfig ]; then
+    	/etc/init.d/rdma-ndd stop
         /sbin/chkconfig --del rdma-ndd
-    elif [ -e /usr/sbin/update-rc.d ]; then
-        /usr/sbin/update-rc.d -f rdma-ndd remove
-    else
-        /usr/lib/lsb/remove_initd /etc/init.d/rdma-ndd
+    fi
+    if type systemctl >/dev/null 2>&1; then
+        systemctl stop rdma-ndd
+    fi
+fi
+
+%postun
+if [ $1 = 0 ]; then
+    if type systemctl >/dev/null 2>&1; then
+        systemctl daemon-reload
     fi
 fi
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
