From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] redhat/spec: further cleanups to depdendencies, descriptions, formatting
Date: Thu, 22 Dec 2016 13:02:20 -0500
Message-ID: <20161222180220.49558-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These are numerous additional little fixups for the Fedora/Red Hat spec
file, stemming from Fedora package review.

- Per https://fedoraproject.org/wiki/Packaging:Systemd it seems we need to
  have systemd as a BuildRequires for %{_unitdir} to evaluate properly.

- Add explicit dependencies on kmod, initscripts and systemd, as there
  are container and vm cases where there might not be a kernel installed

- Add missing Requires to rdma-core-devel on each sub-package it provides
  devel headers and libs for

- Update summary of libibverbs to mention RoCE too

- Add requirement on logrotate to srp_daemon

- Make -DCMAKE_* spaces/tabs indentation consistent

- Make sure srp_daemon.sh is executable

- Fix librdmacm files list so librsocket.so.* is included as well

Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 redhat/rdma-core.spec | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 3bb16ed..360382c 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -19,8 +19,9 @@ BuildRequires: pkgconfig
 BuildRequires: pkgconfig(libnl-3.0)
 BuildRequires: pkgconfig(libnl-route-3.0)
 BuildRequires: valgrind-devel
+BuildRequires: systemd
 
-Requires: dracut
+Requires: dracut, kmod, initscripts, systemd
 # Red Hat/Fedora previously shipped redhat/ as a stand-alone
 # package called 'rdma', which we're supplanting here.
 Provides: rdma = %{version}-%{release}
@@ -48,14 +49,20 @@ dracut rules, and the rdma-ndd utility.
 
 %package devel
 Summary: RDMA core development libraries and headers
+Requires: %{name}%{?_isa} = %{version}-%{release}
+Requires: libibverbs = %{version}-%{release}
 Provides: libibverbs-devel = %{version}-%{release}
 Obsoletes: libibverbs-devel < %{version}-%{release}
+Requires: libibcm = %{version}-%{release}
 Provides: libibcm-devel = %{version}-%{release}
 Obsoletes: libibcm-devel < %{version}-%{release}
+Requires: libibumad = %{version}-%{release}
 Provides: libibumad-devel = %{version}-%{release}
 Obsoletes: libibumad-devel < %{version}-%{release}
+Requires: librdmacm = %{version}-%{release}
 Provides: librdmacm-devel = %{version}-%{release}
 Obsoletes: librdmacm-devel < %{version}-%{release}
+Requires: ibacm = %{version}-%{release}
 Provides: ibacm-devel = %{version}-%{release}
 Obsoletes: ibacm-devel < %{version}-%{release}
 
@@ -63,7 +70,7 @@ Obsoletes: ibacm-devel < %{version}-%{release}
 RDMA core development libraries and headers.
 
 %package -n libibverbs
-Summary: A library and drivers for direct userspace use of RDMA (InfiniBand/iWARP) hardware
+Summary: A library and drivers for direct userspace use of RDMA (InfiniBand/iWARP/RoCE) hardware
 Requires(post): /sbin/ldconfig
 Requires(postun): /sbin/ldconfig
 Requires: %{name}%{?_isa} = %{version}-%{release}
@@ -188,6 +195,7 @@ Requires(post): systemd-units
 Requires(preun): systemd-units
 Requires(postun): systemd-units
 Requires: %{name}%{?_isa} = %{version}-%{release}
+Requires: logrotate
 
 %description -n srp_daemon
 In conjunction with the kernel ib_srp driver, srp_daemon allows you to
@@ -217,11 +225,11 @@ discover and use SCSI devices via the SCSI RDMA Protocol over InfiniBand.
          -DCMAKE_INSTALL_INFODIR:PATH=%{_infodir} \
          -DCMAKE_INSTALL_MANDIR:PATH=%{_mandir} \
          -DCMAKE_INSTALL_SYSCONFDIR:PATH=%{_sysconfdir} \
-	 -DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=%{_unitdir} \
-	 -DCMAKE_INSTALL_INITDDIR:PATH=%{_initrddir} \
-	 -DCMAKE_INSTALL_RUNDIR:PATH=%{_rundir} \
-	 -DCMAKE_INSTALL_DOCDIR:PATH=%{_docdir}/%{name}-%{version} \
-	 -DCMAKE_INSTALL_UDEV_RULESDIR:PATH=%{_udevrulesdir}
+         -DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=%{_unitdir} \
+         -DCMAKE_INSTALL_INITDDIR:PATH=%{_initrddir} \
+         -DCMAKE_INSTALL_RUNDIR:PATH=%{_rundir} \
+         -DCMAKE_INSTALL_DOCDIR:PATH=%{_docdir}/%{name}-%{version} \
+         -DCMAKE_INSTALL_UDEV_RULESDIR:PATH=%{_udevrulesdir}
 %make_jobs
 
 %install
@@ -263,6 +271,7 @@ install -D -m0644 redhat/ibacm.service %{buildroot}%{_unitdir}/
 
 # srp_daemon
 install -D -m0644 redhat/srp_daemon.service %{buildroot}%{_unitdir}/
+chmod a+x %{buildroot}%{_sbindir}/srp_daemon.sh
 
 # Delete the package's init.d scripts
 rm -rf %{buildroot}/%{_initrddir}/
@@ -389,7 +398,7 @@ rm -rf %{buildroot}/%{_initrddir}/
 %files -n librdmacm
 %{_libdir}/librdmacm*.so.*
 %dir %{_libdir}/rsocket
-%{_libdir}/rsocket/*.so
+%{_libdir}/rsocket/librsocket.so*
 %doc %{_docdir}/%{name}-%{version}/librdmacm.md
 %{_mandir}/man7/rsocket.*
 
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
