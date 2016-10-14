From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 4/4] glue/redhat/spec: build split rpm packages
Date: Fri, 14 Oct 2016 15:21:36 -0400
Message-ID: <20161014192136.11731-5-jarod@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161014192136.11731-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We're thinking that the upgrade path for our users will be simpler and
less surprising if we take rdma-core and split out the end result into the
same packages we currently ship in our distributions. End result with this
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
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libcxgb3-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libcxgb4-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libhfi1-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libi40iw-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libipathverbs-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libmlx4-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libmlx5-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libmthca-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libnes-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/libocrdma-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/librxe-11-1.el7.x86_64.rpm
Wrote: /home/jwilson/rpmbuild/RPMS/x86_64/rdma-core-debuginfo-11-1.el7.x86_64.rpm

Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 glue/redhat/rdma-core.spec | 477 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 442 insertions(+), 35 deletions(-)

diff --git a/glue/redhat/rdma-core.spec b/glue/redhat/rdma-core.spec
index 609b910..177d78b 100644
--- a/glue/redhat/rdma-core.spec
+++ b/glue/redhat/rdma-core.spec
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
+# Red Hat/Fedora previously shipped glue/redhat/ as a stand-alone
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
@@ -45,12 +41,225 @@ BuildRequires: make
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
+Provides: libibcm-devel = %{version}-%{release}
+Provides: libibumad-devel = %{version}-%{release}
+Provides: libibverbs-devel = %{version}-%{release}
+Provides: librdmacm-devel = %{version}-%{release}
+
+%description devel
+RDMA core development libraries and headers.
+
+%package -n libibverbs
+Summary: A library for direct userspace use of RDMA (InfiniBand/iWARP) hardware
+Requires(post): /sbin/ldconfig
+Requires(postun): /sbin/ldconfig
+Requires: rdma-core
+
+%description -n libibverbs
+libibverbs is a library that allows userspace processes to use RDMA
+"verbs" as described in the InfiniBand Architecture Specification and
+the RDMA Protocol Verbs Specification.  This includes direct hardware
+access from userspace to InfiniBand/iWARP adapters (kernel bypass) for
+fast path operations.
+
+For this library to be useful, a device-specific plug-in module should
+also be installed.
+
+%package -n libibverbs-utils
+Summary: Examples for the libibverbs library
+Requires: libibverbs%{?_isa} = %{version}-%{release}
+Requires: libibverbs-driver.%{_arch}
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
+
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
+
+%package -n libcxgb3
+Summary: Chelsio T3 iWARP HCA Userspace Driver
+Provides: libibverbs-driver.%{_arch}
+
+%description -n libcxgb3
+Userspace hardware driver for use with the libibverbs InfiniBand/iWARP verbs
+library.  This driver enables Chelsio iWARP capable ethernet devices.
+
+%package -n libcxgb4
+Summary: Chelsio T4 iWARP HCA Userspace Driver
+Provides: libibverbs-driver.%{_arch}
+
+%description -n libcxgb4
+Userspace hardware driver for use with the libibverbs InfiniBand/iWARP verbs
+library.  This driver enables Chelsio T4 based iWARP capable Ethernet devices.
+
+%package -n libhfi1
+Summary: Intel Omni-Path HFI Userspace Driver
+Provides: libibverbs-driver.%{_arch}
+
+%description -n libhfi1
+libhfi1 provides a device-specific userspace driver for Intel Host
+Fabric interface cards. This driver is designed for use with the
+libibverbs library.
+
+%package -n libi40iw
+Summary: Intel Ethernet Connection X722 RDMA Userspace Library
+Provides: libibverbs-driver.%{_arch}
+
+%description -n libi40iw
+libi40iw provides a device-specific RDMA userspace library for Intel
+Ethernet Connection X722 for use with the libibverbs library.
+
+%package -n libipathverbs
+Summary: QLogic InfiniPath HCA Userspace Driver
+Provides: libibverbs-driver.%{_arch}
+
+%description -n libipathverbs
+QLogic hardware driver for use with libibverbs user space verbs access
+library.  This driver supports QLogic InfiniPath based cards.
+
+%package -n libmlx4
+Summary: Mellanox ConnectX-3 InfiniBand HCA Userspace Driver
+Provides: libibverbs-driver.%{_arch}
+
+%description -n libmlx4
+libmlx4 provides a device-specific userspace driver for Mellanox
+ConnectX-3 HCAs for use with the libibverbs library.
+
+%package -n libmlx5
+Summary: Mellanox Connect-IB/X-4+ InfiniBand HCA Userspace Driver
+Provides: libibverbs-driver.%{_arch}
+
+%description -n libmlx5
+bmlx5 provides a device-specific userspace driver for Mellanox
+Connect-IB/X-4+ HCAs for use with the libibverbs library.
+
+%package -n libmthca
+Summary: Mellanox InfiniBand HCA Userspace Driver
+Provides: libibverbs-driver.%{_arch}
+
+%description -n libmthca
+libmthca provides a device-specific userspace driver for Mellanox HCAs
+(MT23108 InfiniHost and MT25208 InfiniHost III Ex) for use with the
+libibverbs library.
 
-This is a simple example without the split sub packages to get things started.
+%package -n libnes
+Summary: NetEffect RNIC Userspace Driver
+Provides: libibverbs-driver.%{_arch}
+
+%description -n libnes
+Userspace hardware driver for use with the libibverbs InfiniBand/iWARP verbs
+library.  This driver enables NetEffect iWARP capable ethernet devices.
+
+%package -n libocrdma
+Summary: Userspace Library for Emulex OneConnect RDMA/RoCE Device
+Provides: libibverbs-driver.%{_arch}
+
+%description -n libocrdma
+libocrdma provides a device-specific userspace driver for Emulex OneConnect
+RDMA/RoCE Adapters for use with the libibverbs library.
+
+%package -n librxe
+Summary: A software implementation of the RoCE protocol
+Provides: libibverbs-driver.%{_arch}
+
+%description -n librxe
+This is a software implementation of the RoCE protocol, which transports the
+full OFED RDMA protocol set (kernel and user mode) over layer 2 Ethernet.
+Infiniband (IB) transport and GRH headers are encapsulated in Ethernet packets
+of ether type 0x8915.
+
+Once a RXE instance has been created, communicating via RXE is the same as
+communicating via any OFED compatible Infiniband HCA, albeit in some cases with
+addressing implications.
+
+In particular, while the use of a GRH header is optional within IB subnets, it
+is mandatory with RoCE. Verbs applications written over IB verbs should work
+seamlessly, but they require provisioning of GRH information when creating address
+vectors. The library and driver are modified to provide for mapping from GID to
+MAC addresses required by the hardware.
 
 %prep
 %setup
@@ -91,8 +300,55 @@ This is a simple example without the split sub packages to get things started.
 %install
 %cmake_install
 
+mkdir -p %{buildroot}/%{_sysconfdir}/rdma
 mkdir -p %{buildroot}/%{_docdir}/%{name}-%{version}
-install -m0644 Documentation/{ibacm,ibsrpdm,libibcm,libibverbs,librdmacm,rxe}.md %{buildroot}/%{_docdir}/%{name}-%{version}/
+install -D -m0644 Documentation/{ibacm,ibsrpdm,libibcm,libibverbs,librdmacm,rxe}.md %{buildroot}/%{_docdir}/%{name}-%{version}/
+install -D -m0644 README.md %{buildroot}/%{_docdir}/%{name}-%{version}/
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
+install -D -m0644 glue/redhat/rdma.conf %{buildroot}/%{_sysconfdir}/rdma/rdma.conf
+install -D -m0644 glue/redhat/rdma.sriov-vfs %{buildroot}/%{_sysconfdir}/rdma/sriov-vfs
+install -D -m0644 glue/redhat/rdma.mlx4.conf %{buildroot}/%{_sysconfdir}/rdma/mlx4.conf
+install -D -m0755 glue/redhat/rdma.ifup-ib %{buildroot}/%{_sysconfdir}/sysconfig/network-scripts/ifup-ib
+install -D -m0755 glue/redhat/rdma.ifdown-ib %{buildroot}/%{_sysconfdir}/sysconfig/network-scripts/ifdown-ib
+install -D -m0644 glue/redhat/rdma.service %{buildroot}%{_unitdir}/rdma.service
+install -D -m0644 glue/redhat/rdma.udev-ipoib-naming.rules %{buildroot}%{_sysconfdir}/udev/rules.d/70-persistent-ipoib.rules
+install -D -m0644 glue/redhat/rdma.mlx4.user.modprobe %{buildroot}%{_sysconfdir}/modprobe.d/mlx4.conf
+install -D -m0755 glue/redhat/rdma.modules-setup.sh %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
+install -D -m0644 glue/redhat/rdma.udev-rules %{buildroot}%{_udevrulesdir}/98-rdma.rules
+install -D -m0644 glue/redhat/rdma.mlx4.sys.modprobe %{buildroot}%{sysmodprobedir}/libmlx4.conf
+install -D -m0644 glue/redhat/rdma.cxgb3.sys.modprobe %{buildroot}%{sysmodprobedir}/cxgb3.conf
+install -D -m0644 glue/redhat/rdma.cxgb4.sys.modprobe %{buildroot}%{sysmodprobedir}/cxgb4.conf
+install -D -m0755 glue/redhat/rdma.kernel-init %{buildroot}%{_libexecdir}/rdma-init-kernel
+install -D -m0755 glue/redhat/rdma.sriov-init %{buildroot}%{_libexecdir}/rdma-set-sriov-vf
+install -D -m0644 glue/redhat/rdma.fixup-mtrr.awk %{buildroot}%{_libexecdir}/rdma-fixup-mtrr.awk
+install -D -m0755 glue/redhat/rdma.mlx4-setup.sh %{buildroot}%{_libexecdir}/mlx4-setup.sh
+
+# ibacm
+%{buildroot}/%{_bindir}/ib_acme -D . -O
+# Fixup a multilib conflict in ibacm_opts.cfg:
+sed -i -e '/^# Specifies the directory of the provider libraries$/ a\
+# Use /usr/lib64/ibacm on 64bit, /usr/lib/libacm on 32bit.
+' -e 's%^\(# provider_lib_path /usr/\)lib\(64\)\?/ibacm$%\1lib64/ibacm%' ibacm_opts.cfg
+install -D -m0644 ibacm_opts.cfg %{buildroot}%{_sysconfdir}/rdma/
+install -D -m0644 glue/redhat/ibacm.service %{buildroot}%{_unitdir}/
+install -D -m0644 ibacm/man/*.1 %{buildroot}/%{_mandir}/man1/
+install -D -m0644 ibacm/man/*.7 %{buildroot}/%{_mandir}/man7/
+sed -e 's|@ACM_PROVIDER_DIR@|%{libdir}/%{name}/|g' -e 's|@CMAKE_INSTALL_FULL_LOCALSTATEDIR@|%{_localstatedir}|g' ibacm/man/ibacm_prov.7.in > %{buildroot}/%{_mandir}/man7/ibacm_prov.7
+
+# iwpmd
+install -D -m0644 glue/redhat/iwpmd.service %{buildroot}%{_unitdir}/
+
+# srp_daemon
+install -D -m0644 glue/redhat/srp_daemon.service %{buildroot}%{_unitdir}/
 
 %if 0%{?_unitdir:1}
 rm -rf %{buildroot}/%{_initrddir}/
@@ -103,25 +359,176 @@ rm -rf %{buildroot}/%{my_unitdir}/
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
+%license COPYING.*
+
+%files devel
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
+%{_libdir}/libibverbs*.so.*
+%dir %{_libdir}/libibverbs
+%doc %{_docdir}/%{name}-%{version}/libibverbs.md
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
+
+%files -n libcxgb3
+%{_libdir}/libibverbs/libcxgb3-rdmav2.so
+%config(noreplace) %{_sysconfdir}/libibverbs.d/cxgb3.driver
+
+%files -n libcxgb4
+%{_libdir}/libibverbs/libcxgb4-rdmav2.so
+%config(noreplace) %{_sysconfdir}/libibverbs.d/cxgb4.driver
+
+%files -n libhfi1
+%{_libdir}/libibverbs/libhfi1verbs-rdmav2.so
+%config(noreplace) %{_sysconfdir}/libibverbs.d/hfi1verbs.driver
+
+%files -n libi40iw
+%{_libdir}/libibverbs/libi40iw-rdmav2.so
+%config(noreplace) %{_sysconfdir}/libibverbs.d/i40iw.driver
+
+%files -n libipathverbs
+%{_libdir}/libibverbs/libipathverbs-rdmav2.so
+%config(noreplace) %{_sysconfdir}/libibverbs.d/ipathverbs.driver
+%config(noreplace) %{_sysconfdir}/modprobe.d/truescale.conf
+%{_libexecdir}/truescale-serdes.cmds
+
+%files -n libmlx4
+%{_libdir}/libibverbs/libmlx4-rdmav2.so
+%config(noreplace) %{_sysconfdir}/libibverbs.d/mlx4.driver
+
+%files -n libmlx5
+%{_libdir}/libibverbs/libmlx5-rdmav2.so
+%config(noreplace) %{_sysconfdir}/libibverbs.d/mlx5.driver
+
+%files -n libmthca
+%{_libdir}/libibverbs/libmthca-rdmav2.so
+%config(noreplace) %{_sysconfdir}/libibverbs.d/mthca.driver
+
+%files -n libnes
+%{_libdir}/libibverbs/libnes-rdmav2.so
+%config(noreplace) %{_sysconfdir}/libibverbs.d/nes.driver
+
+%files -n libocrdma
+%{_libdir}/libibverbs/libocrdma-rdmav2.so
+%config(noreplace) %{_sysconfdir}/libibverbs.d/ocrdma.driver
+
+%files -n librxe
+%{_bindir}/rxe_cfg
+%{_mandir}/man7/rxe*
+%{_mandir}/man8/rxe*
+%{_libdir}/libibverbs/librxe-rdmav2.so
+%config(noreplace) %{_sysconfdir}/libibverbs.d/rxe.driver
+%doc %{_docdir}/%{name}-%{version}/rxe.md
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
