From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 15/17] Combined RPM Spec file
Date: Thu,  6 Oct 2016 14:51:41 -0600
Message-ID: <1475787103-13283-16-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is just a temporary starting point, a single package.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 Documentation/versioning.md |  10 ++++
 rdma-core.spec              | 123 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+)
 create mode 100644 rdma-core.spec

diff --git a/Documentation/versioning.md b/Documentation/versioning.md
index 0cc542aa6b79..a7c9a7bdcfc2 100644
--- a/Documentation/versioning.md
+++ b/Documentation/versioning.md
@@ -29,6 +29,16 @@ index 389feee1e0f9..63854fe8f07f 100644
  
  #-------------------------
  # Basic standard paths
+diff --git a/rdma-core.spec b/rdma-core.spec
+index d1407ee9e24b..fca79ccf57e5 100644
+--- a/rdma-core.spec
++++ b/rdma-core.spec
+@@ -1,5 +1,5 @@
+ Name: rdma-core
+-Version: 11
++Version: 12
+ Release: 1%{?dist}
+ Summary: Userspace components for the Linux Kernel\'s drivers/infiniband stack
 ```
 
 # Shared Library Versions
diff --git a/rdma-core.spec b/rdma-core.spec
new file mode 100644
index 000000000000..96c86fe06f3a
--- /dev/null
+++ b/rdma-core.spec
@@ -0,0 +1,123 @@
+Name: rdma-core
+Version: 11
+Release: 1%{?dist}
+Summary: RDMA core userspace libraries and daemons
+
+# Almost everything is licensed under the OFA dual GPLv2, 2 Clause BSD license
+#  providers/ipathverbs/ Dual licensed using a BSD license with an extra patent clause
+#  providers/rxe/ Incorporates code from ipathverbs and contains the patent clause
+#  providers/hfi1verbs Uses the 3 Clause BSD license
+License: (GPLv2 or BSD) and (GPLv2 or PathScale-BSD)
+Url: http://openfabrics.org/
+Source: rdma-core-%{version}.tgz
+BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
+
+BuildRequires: binutils
+BuildRequires: cmake >= 2.8.11
+BuildRequires: gcc
+BuildRequires: pkgconfig
+BuildRequires: pkgconfig(libnl-3.0)
+BuildRequires: pkgconfig(libnl-route-3.0)
+BuildRequires: valgrind-devel
+
+# Since we recommend developers use Ninja, so should packagers, for consistency.
+%define CMAKE_FLAGS %{nil}
+%if 0%{?suse_version}
+# SuSE releases have it, and sometime around cmake 3.3.2-1.2 the macros learned to use it.
+BuildRequires: ninja,make
+%define __builder ninja
+# cmake_install,make_jobs is specified by opensuse
+
+# Tumbleweed's cmake RPM macro adds -Wl,--no-undefined to the module flags
+# which is totally inappropriate and breaks building 'ENABLE_EXPORTS' style
+# module libraries (eg ibacmp).
+%define CMAKE_FLAGS -DCMAKE_MODULE_LINKER_FLAGS=""
+%else
+%if 0%{?fedora} >= 23
+# Ninja was introduced in FC23
+BuildRequires: ninja-build
+%define CMAKE_FLAGS -GNinja
+%define make_jobs ninja -v %{?_smp_mflags}
+%define cmake_install DESTDIR=%{buildroot} ninja-build install
+%else
+# Fallback to make otherwise
+BuildRequires: make
+%define make_jobs make -v %{?_smp_mflags}
+%define cmake_install DESTDIR=%{buildroot} make install
+%endif
+%endif
+
+%description
+Temporary packaging
+
+This is a simple example without the split sub packages to get things started.
+
+%prep
+%setup
+
+%build
+
+# Detect if systemd is supported on this system
+%if 0%{?_unitdir:1}
+%define my_unitdir %{_unitdir}
+%else
+%define my_unitdir /tmp/
+%endif
+
+# New RPM defines _rundir, usually as /run
+%if 0%{?_rundir:1}
+%else
+%define _rundir /var/run
+%endif
+
+# Pass all of the rpm paths directly to GNUInstallDirs and our other defines.
+%cmake %{CMAKE_FLAGS} \
+         -DCMAKE_BUILD_TYPE=Release \
+         -DCMAKE_INSTALL_BINDIR:PATH=%{_bindir} \
+         -DCMAKE_INSTALL_SBINDIR:PATH=%{_sbindir} \
+         -DCMAKE_INSTALL_LIBDIR:PATH=%{_libdir} \
+         -DCMAKE_INSTALL_LIBEXECDIR:PATH=%{_libexecdir} \
+         -DCMAKE_INSTALL_LOCALSTATEDIR:PATH=%{_localstatedir} \
+         -DCMAKE_INSTALL_SHAREDSTATEDIR:PATH=%{_sharedstatedir} \
+         -DCMAKE_INSTALL_INCLUDEDIR:PATH=%{_includedir} \
+         -DCMAKE_INSTALL_INFODIR:PATH=%{_infodir} \
+         -DCMAKE_INSTALL_MANDIR:PATH=%{_mandir} \
+         -DCMAKE_INSTALL_SYSCONFDIR:PATH=%{_sysconfdir} \
+	 -DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=%{my_unitdir} \
+	 -DCMAKE_INSTALL_INITDDIR:PATH=%{_initrddir} \
+	 -DCMAKE_INSTALL_RUNDIR:PATH=%{_rundir}
+%make_jobs
+
+%install
+%cmake_install
+
+%if 0%{?_unitdir:1}
+rm -rf %{buildroot}/%{_initrddir}/
+%else
+rm -rf %{buildroot}/%{my_unitdir}/
+%endif
+
+%post -p /sbin/ldconfig
+%postun -p /sbin/ldconfig
+
+%files
+%doc %{_mandir}/man*/*
+%{_bindir}/*
+%{_includedir}/*
+%{_libdir}/lib*.so*
+%{_libdir}/libibverbs/*
+%{_libdir}/ibacm/*
+%{_libdir}/rsocket/*
+%{_sbindir}/*
+%{_libexecdir}/*
+%if 0%{?_unitdir:1}
+%{_unitdir}/*
+%else
+%config %{_initrddir}/*
+%endif
+%config %{_sysconfdir}/iwpmd.conf
+%config %{_sysconfdir}/srp_daemon.conf
+%config %{_sysconfdir}/libibverbs.d/*
+%config %{_sysconfdir}/logrotate.d/srp_daemon
+%{_sysconfdir}/modprobe.d/*
+%config %{_sysconfdir}/rsyslog.d/srp_daemon.conf
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
