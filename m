From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 3/4] glue/redhat: copy stock spec for RH customization
Date: Fri, 14 Oct 2016 15:21:35 -0400
Message-ID: <20161014192136.11731-4-jarod@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161014192136.11731-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We're going to need to do a bit of majorly invasive surgery, and we're not
sure everyone else is going to want to package things this way, so we'll
make a copy of our own spec here, starting from the one in the tree.

Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 glue/redhat/rdma-core.spec | 127 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 127 insertions(+)
 create mode 100644 glue/redhat/rdma-core.spec

diff --git a/glue/redhat/rdma-core.spec b/glue/redhat/rdma-core.spec
new file mode 100644
index 0000000..609b910
--- /dev/null
+++ b/glue/redhat/rdma-core.spec
@@ -0,0 +1,127 @@
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
+mkdir -p %{buildroot}/%{_docdir}/%{name}-%{version}
+install -m0644 Documentation/{ibacm,ibsrpdm,libibcm,libibverbs,librdmacm,rxe}.md %{buildroot}/%{_docdir}/%{name}-%{version}/
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
+%{_docdir}/%{name}-%{version}/*
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
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
