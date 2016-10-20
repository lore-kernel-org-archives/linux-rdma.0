From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core v2 4/4] redhat/spec: build split rpm packages
Date: Thu, 20 Oct 2016 11:33:57 -0400
Message-ID: <20161020153357.27286-5-jarod@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161020153357.27286-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161020153357.27286-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We're thinking that the upgrade path for our users will be simpler and
less surprising if we take rdma-core and split out the end result into the
same packages we currently ship in our distributions, save the libibverbs
providers, which are all merged into libibverbs. End result with this
spec:

Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/rdma-core-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/rdma-core-devel-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libibverbs-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libibverbs-utils-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/ibacm-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/iwpmd-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libibcm-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libibumad-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/librdmacm-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/librdmacm-utils-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/srp_daemon-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/rdma-core-debuginfo-11-1.el7.x86_64.rpm

Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 redhat/rdma-core.spec | 360 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 326 insertions(+), 34 deletions(-)

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 47b7d87..6fc35b5 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -7,10 +7,11 @@ Summary: RDMA core userspace libraries and daemons
 #  providers/ipathverbs/ Dual licensed using a BSD license with an extra patent clause
 #  providers/rxe/ Incorporates code from ipathverbs and contains the patent clause
 #  providers/hfi1verbs Uses the 3 Clause BSD license
-License: (GPLv2 or BSD) and (GPLv2 or PathScale-BSD)
+License: GPLv2 or BSD
 Url: http://openfabrics.org/
 Source: rdma-core-%{version}.tgz
-BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
+# https://github.com/linux-rdma/rdma-core
+BuildRoot: %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
 
 BuildRequires: binutils
 BuildRequires: cmake >= 2.8.11
@@ -19,20 +20,15 @@ BuildRequires: pkgconfig
 BuildRequires: pkgconfig(libnl-3.0)
 BuildRequires: pkgconfig(libnl-route-3.0)
 BuildRequires: valgrind-devel
+BuildRequires: libnl3-devel
+
+# Red Hat/Fedora previously shipped redhat/ as a stand-alone
+# package called 'rdma', which we're supplanting here.
+Provides: rdma = %{version}-%{release}
+Obsoletes: rdma < %{version}-%{release}
 
 # Since we recommend developers use Ninja, so should packagers, for consistency.
 %define CMAKE_FLAGS %{nil}
-%if 0%{?suse_version}
-# SuSE releases have it, and sometime around cmake 3.3.2-1.2 the macros learned to use it.
-BuildRequires: ninja,make
-%define __builder ninja
-# cmake_install,make_jobs is specified by opensuse
-
-# Tumbleweed's cmake RPM macro adds -Wl,--no-undefined to the module flags
-# which is totally inappropriate and breaks building 'ENABLE_EXPORTS' style
-# module libraries (eg ibacmp).
-%define CMAKE_FLAGS -DCMAKE_MODULE_LINKER_FLAGS=""
-%else
 %if 0%{?fedora} >= 23
 # Ninja was introduced in FC23
 BuildRequires: ninja-build
@@ -45,12 +41,161 @@ BuildRequires: make
 %define make_jobs make -v %{?_smp_mflags}
 %define cmake_install DESTDIR=%{buildroot} make install
 %endif
+
+%define systemd_dep systemd-units
+%if 0%{?fedora} >= 18
+%define systemd_dep systemd
 %endif
 
 %description
-Temporary packaging
+RDMA core userspace infrastructure and documentation.
+
+%package devel
+Summary: RDMA core development libraries and headers
+Provides: libibverbs-devel = %{version}-%{release}
+Obsoletes: libibverbs-devel < %{version}-%{release}
+Provides: libibcm-devel = %{version}-%{release}
+Obsoletes: libibcm-devel < %{version}-%{release}
+Provides: libibumad-devel = %{version}-%{release}
+Obsoletes: libibumad-devel < %{version}-%{release}
+Provides: librdmacm-devel = %{version}-%{release}
+Obsoletes: librdmacm-devel < %{version}-%{release}
+Provides: ibacm-devel = %{version}-%{release}
+Obsoletes: ibacm-devel < %{version}-%{release}
+
+%description devel
+RDMA core development libraries and headers.
+
+%package -n libibverbs
+Summary: A library and drivers for direct userspace use of RDMA (InfiniBand/iWARP) hardware
+Requires(post): /sbin/ldconfig
+Requires(postun): /sbin/ldconfig
+Requires: rdma-core
+Provides: libcxgb3 = %{version}-%{release}
+Obsoletes: libcxgb3 < %{version}-%{release}
+Provides: libcxgb4 = %{version}-%{release}
+Obsoletes: libcxgb4 < %{version}-%{release}
+Provides: libhfi1 = %{version}-%{release}
+Obsoletes: libhfi1 < %{version}-%{release}
+Provides: libi40iw = %{version}-%{release}
+Obsoletes: libi40iw < %{version}-%{release}
+Provides: libipathverbs = %{version}-%{release}
+Obsoletes: libipathverbs < %{version}-%{release}
+Provides: libmlx4 = %{version}-%{release}
+Obsoletes: libmlx4 < %{version}-%{release}
+Provides: libmlx5 = %{version}-%{release}
+Obsoletes: libmlx5 < %{version}-%{release}
+Provides: libmthca = %{version}-%{release}
+Obsoletes: libmthca < %{version}-%{release}
+Provides: libnes = %{version}-%{release}
+Obsoletes: libnes < %{version}-%{release}
+Provides: libocrdma = %{version}-%{release}
+Obsoletes: libocrdma < %{version}-%{release}
+Provides: librxe = %{version}-%{release}
+Obsoletes: librxe < %{version}-%{release}
+
+%description -n libibverbs
+libibverbs is a library that allows userspace processes to use RDMA
+"verbs" as described in the InfiniBand Architecture Specification and
+the RDMA Protocol Verbs Specification.  This includes direct hardware
+access from userspace to InfiniBand/iWARP adapters (kernel bypass) for
+fast path operations.
+
+Device-specific plug-in ibverbs userspace drivers are included:
+
+- libcxgb3: Chelsio T3 iWARP HCA
+- libcxgb4: Chelsio T4 iWARP HCA
+- libhfi1: Intel Omni-Path HFI
+- libi40iw: Intel Ethernet Connection X722 RDMA
+- libipathverbs: QLogic InfiniPath HCA
+- libmlx4: Mellanox ConnectX-3 InfiniBand HCA
+- libmlx5: Mellanox Connect-IB/X-4+ InfiniBand HCA
+- libmthca: Mellanox InfiniBand HCA
+- libnes: NetEffect RNIC
+- libocrdma: Emulex OneConnect RDMA/RoCE Device
+- librxe: A software implementation of the RoCE protocol
+
+%package -n libibverbs-utils
+Summary: Examples for the libibverbs library
+Requires: libibverbs%{?_isa} = %{version}-%{release}
+
+%description -n libibverbs-utils
+Useful libibverbs example programs such as ibv_devinfo, which
+displays information about RDMA devices.
+
+%package -n ibacm
+Summary: InfiniBand Communication Manager Assistant
+Requires(post): %{systemd_dep}
+Requires(preun): %{systemd_dep}
+Requires(postun): %{systemd_dep}
+Requires: rdma-core
+
+%description -n ibacm
+The ibacm daemon helps reduce the load of managing path record lookups on
+large InfiniBand fabrics by providing a user space implementation of what
+is functionally similar to an ARP cache.  The use of ibacm, when properly
+configured, can reduce the SA packet load of a large IB cluster from O(n^2)
+to O(n).  The ibacm daemon is started and normally runs in the background,
+user applications need not know about this daemon as long as their app
+uses librdmacm to handle connection bring up/tear down.  The librdmacm
+library knows how to talk directly to the ibacm daemon to retrieve data.
+
+%package -n iwpmd
+Summary: iWarp Port Mapper userspace daemon
+Requires(post): %{systemd_dep}
+Requires(preun): %{systemd_dep}
+Requires(postun): %{systemd_dep}
+Requires: rdma-core
+
+%description -n iwpmd
+iwpmd provides a userspace service for iWarp drivers to claim
+tcp ports through the standard socket interface.
+
+%package -n libibcm
+Summary: Userspace InfiniBand Connection Manager
+ExcludeArch: s390 s390x
+Requires: rdma-core
+
+%description -n libibcm
+libibcm provides a userspace library that handles the majority of the low
+level work required to open an RDMA connection between two machines.
+
+%package -n libibumad
+Summary: OpenFabrics Alliance InfiniBand umad (userspace management datagram) library
+Requires: rdma-core
+
+%description -n libibumad
+libibumad provides the userspace management datagram (umad) library
+functions, which sit on top of the umad modules in the kernel. These
+are used by the IB diagnostic and management tools, including OpenSM.
+
+%package -n librdmacm
+Summary: Userspace RDMA Connection Manager
+Requires: rdma-core
+
+%description -n librdmacm
+librdmacm provides a userspace RDMA Communication Managment API.
+
+%package -n librdmacm-utils
+Summary: Examples for the librdmacm library
+Requires: librdmacm%{?_isa} = %{version}-%{release}
+
+%description -n librdmacm-utils
+Example test programs for the librdmacm library.
 
-This is a simple example without the split sub packages to get things started.
+%package -n srp_daemon
+Summary: Tools for using the InfiniBand SRP protocol devices
+Obsoletes: srptools <= 1.0.3
+Provides: srptools = %{version}-%{release}
+Obsoletes: openib-srptools <= 0.0.6
+Requires(post): %{systemd_dep}
+Requires(preun): %{systemd_dep}
+Requires(postun): %{systemd_dep}
+Requires: rdma-core
+
+%description -n srp_daemon
+In conjunction with the kernel ib_srp driver, srptools allows you to
+discover and use SCSI devices via the SCSI RDMA Protocol over InfiniBand.
 
 %prep
 %setup
@@ -92,6 +237,43 @@ This is a simple example without the split sub packages to get things started.
 %install
 %cmake_install
 
+mkdir -p %{buildroot}/%{_sysconfdir}/rdma
+
+# Red Hat specific glue
+%global dracutlibdir %{_prefix}/lib/dracut
+%global sysmodprobedir %{_prefix}/lib/modprobe.d
+mkdir -p %{buildroot}/%{_sysconfdir}/sysconfig/network-scripts
+mkdir -p %{buildroot}%{_sysconfdir}/udev/rules.d
+mkdir -p %{buildroot}%{_libexecdir}
+mkdir -p %{buildroot}%{_udevrulesdir}
+mkdir -p %{buildroot}%{dracutlibdir}/modules.d/05rdma
+mkdir -p %{buildroot}%{sysmodprobedir}
+install -D -m0644 redhat/rdma.conf %{buildroot}/%{_sysconfdir}/rdma/rdma.conf
+install -D -m0644 redhat/rdma.sriov-vfs %{buildroot}/%{_sysconfdir}/rdma/sriov-vfs
+install -D -m0644 redhat/rdma.mlx4.conf %{buildroot}/%{_sysconfdir}/rdma/mlx4.conf
+install -D -m0755 redhat/rdma.ifup-ib %{buildroot}/%{_sysconfdir}/sysconfig/network-scripts/ifup-ib
+install -D -m0755 redhat/rdma.ifdown-ib %{buildroot}/%{_sysconfdir}/sysconfig/network-scripts/ifdown-ib
+install -D -m0644 redhat/rdma.service %{buildroot}%{_unitdir}/rdma.service
+install -D -m0644 redhat/rdma.udev-ipoib-naming.rules %{buildroot}%{_sysconfdir}/udev/rules.d/70-persistent-ipoib.rules
+install -D -m0644 redhat/rdma.mlx4.user.modprobe %{buildroot}%{_sysconfdir}/modprobe.d/mlx4.conf
+install -D -m0755 redhat/rdma.modules-setup.sh %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
+install -D -m0644 redhat/rdma.udev-rules %{buildroot}%{_udevrulesdir}/98-rdma.rules
+install -D -m0644 redhat/rdma.mlx4.sys.modprobe %{buildroot}%{sysmodprobedir}/libmlx4.conf
+install -D -m0644 redhat/rdma.cxgb3.sys.modprobe %{buildroot}%{sysmodprobedir}/cxgb3.conf
+install -D -m0644 redhat/rdma.cxgb4.sys.modprobe %{buildroot}%{sysmodprobedir}/cxgb4.conf
+install -D -m0755 redhat/rdma.kernel-init %{buildroot}%{_libexecdir}/rdma-init-kernel
+install -D -m0755 redhat/rdma.sriov-init %{buildroot}%{_libexecdir}/rdma-set-sriov-vf
+install -D -m0644 redhat/rdma.fixup-mtrr.awk %{buildroot}%{_libexecdir}/rdma-fixup-mtrr.awk
+install -D -m0755 redhat/rdma.mlx4-setup.sh %{buildroot}%{_libexecdir}/mlx4-setup.sh
+
+# ibacm
+%{buildroot}/%{_bindir}/ib_acme -D . -O
+install -D -m0644 ibacm_opts.cfg %{buildroot}%{_sysconfdir}/rdma/
+install -D -m0644 redhat/ibacm.service %{buildroot}%{_unitdir}/
+
+# srp_daemon
+install -D -m0644 redhat/srp_daemon.service %{buildroot}%{_unitdir}/
+
 %if 0%{?_unitdir:1}
 rm -rf %{buildroot}/%{_initrddir}/
 %else
@@ -101,25 +283,135 @@ rm -rf %{buildroot}/%{my_unitdir}/
 %post -p /sbin/ldconfig
 %postun -p /sbin/ldconfig
 
+%post -n ibacm
+%systemd_post ibacm.service
+
+%preun -n ibacm
+%systemd_preun ibacm.service
+
+%postun -n ibacm
+%systemd_postun_with_restart ibacm.service
+
+%post -n libibcm -p /sbin/ldconfig
+%postun -n libibcm -p /sbin/ldconfig
+
 %files
-%doc %{_mandir}/man*/*
-%{_bindir}/*
+%dir %{_sysconfdir}/rdma
+%doc %{_docdir}/%{name}-%{version}/README.md
+%config(noreplace) %{_sysconfdir}/rdma/*
+%config(noreplace) %{_sysconfdir}/udev/rules.d/*
+%config(noreplace) %{_sysconfdir}/modprobe.d/mlx4.conf
+%config(noreplace) %{_sysconfdir}/modprobe.d/truescale.conf
+%{_sysconfdir}/sysconfig/network-scripts/*
+%{_unitdir}/rdma.service
+%dir %{dracutlibdir}/modules.d/05rdma
+%{dracutlibdir}/modules.d/05rdma/module-setup.sh
+%{_udevrulesdir}/*
+%{sysmodprobedir}/libmlx4.conf
+%{sysmodprobedir}/cxgb3.conf
+%{sysmodprobedir}/cxgb4.conf
+%{_libexecdir}/rdma-init-kernel
+%{_libexecdir}/rdma-set-sriov-vf
+%{_libexecdir}/rdma-fixup-mtrr.awk
+%{_libexecdir}/mlx4-setup.sh
+%{_libexecdir}/truescale-serdes.cmds
+%license COPYING.*
+
+%files devel
+%doc %{_docdir}/%{name}-%{version}/MAINTAINERS
 %{_includedir}/*
-%{_libdir}/lib*.so*
-%{_libdir}/libibverbs/*
+%{_libdir}/lib*.so
+%{_libdir}/rsocket/*.so
+%{_mandir}/man3/ibv_*
+%{_mandir}/man3/rdma*
+%{_mandir}/man3/umad*
+%{_mandir}/man3/*_to_ibv_rate.*
+%{_mandir}/man7/rdma_cm.*
+%{_mandir}/man7/rsocket.*
+
+%files -n libibverbs
+%dir %{_sysconfdir}/libibverbs.d
+%dir %{_libdir}/libibverbs
+%{_libdir}/libibverbs*.so.*
+%{_libdir}/libibverbs/*.so
+%config(noreplace) %{_sysconfdir}/libibverbs.d/*.driver
+%doc %{_docdir}/%{name}-%{version}/libibverbs.md
+%doc %{_docdir}/%{name}-%{version}/rxe.md
+%{_bindir}/rxe_cfg
+%{_mandir}/man7/rxe*
+%{_mandir}/man8/rxe*
+
+%files -n libibverbs-utils
+%{_bindir}/ibv_*
+%{_mandir}/man1/ibv_*
+
+%files -n ibacm
+%config(noreplace) %{_sysconfdir}/rdma/ibacm_opts.cfg
+%{_bindir}/ib_acme
+%{_sbindir}/ibacm
+%{_mandir}/man1/ibacm.*
+%{_mandir}/man1/ib_acme.*
+%{_mandir}/man7/ibacm.*
+%{_mandir}/man7/ibacm_prov.*
+%{_unitdir}/ibacm.service
+%dir %{_libdir}/ibacm
 %{_libdir}/ibacm/*
-%{_libdir}/rsocket/*
-%{_sbindir}/*
-%{_libexecdir}/*
-%{_docdir}/%{name}-%{version}/*
-%if 0%{?_unitdir:1}
-%{_unitdir}/*
-%else
-%config %{_initrddir}/*
-%endif
-%config %{_sysconfdir}/iwpmd.conf
-%config %{_sysconfdir}/srp_daemon.conf
-%config %{_sysconfdir}/libibverbs.d/*
-%config %{_sysconfdir}/logrotate.d/srp_daemon
-%{_sysconfdir}/modprobe.d/*
-%config %{_sysconfdir}/rsyslog.d/srp_daemon.conf
+%doc %{_docdir}/%{name}-%{version}/ibacm.md
+
+%files -n iwpmd
+%{_bindir}/iwpmd
+%{_unitdir}/iwpmd.service
+%config(noreplace) %{_sysconfdir}/iwpmd.conf
+%{_mandir}/man1/iwpmd.*
+%{_mandir}/man5/iwpmd.*
+
+%files -n libibcm
+%{_libdir}/libibcm*.so.*
+%doc %{_docdir}/%{name}-%{version}/libibcm.md
+
+%files -n libibumad
+%{_libdir}/libibumad*.so.*
+
+%files -n librdmacm
+%{_libdir}/librdmacm*.so.*
+%{_libdir}/rsocket/*.so.*
+%doc %{_docdir}/%{name}-%{version}/librdmacm.md
+
+%files -n librdmacm-utils
+%{_bindir}/cmtime
+%{_bindir}/mckey
+%{_bindir}/rcopy
+%{_bindir}/rdma_client
+%{_bindir}/rdma_server
+%{_bindir}/rdma_xclient
+%{_bindir}/rdma_xserver
+%{_bindir}/riostream
+%{_bindir}/rping
+%{_bindir}/rstream
+%{_bindir}/ucmatose
+%{_bindir}/udaddy
+%{_bindir}/udpong
+%{_mandir}/man1/mckey.*
+%{_mandir}/man1/rcopy.*
+%{_mandir}/man1/rdma_client.*
+%{_mandir}/man1/rdma_server.*
+%{_mandir}/man1/rdma_xclient.*
+%{_mandir}/man1/rdma_xserver.*
+%{_mandir}/man1/riostream.*
+%{_mandir}/man1/rping.*
+%{_mandir}/man1/rstream.*
+%{_mandir}/man1/ucmatose.*
+%{_mandir}/man1/udaddy.*
+
+%files -n srp_daemon
+%config(noreplace) %{_sysconfdir}/srp_daemon.conf
+%config(noreplace) %{_sysconfdir}/logrotate.d/srp_daemon
+%config(noreplace) %{_sysconfdir}/rsyslog.d/srp_daemon.conf
+%{_unitdir}/srp_daemon.service
+%{_sbindir}/ibsrpdm
+%{_sbindir}/srp_daemon
+%{_sbindir}/srp_daemon.sh
+%{_sbindir}/run_srp_daemon
+%{_mandir}/man1/ibsrpdm.1*
+%{_mandir}/man1/srp_daemon.1*
+%doc %{_docdir}/%{name}-%{version}/ibsrpdm.md
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
