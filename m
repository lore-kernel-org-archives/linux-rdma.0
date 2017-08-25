From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCHv2 rdma-core 6/6] rdma-core.spec: remove top spec file
Date: Fri, 25 Aug 2017 17:29:50 +0200
Message-ID: <12cb42aa-b5f2-3bef-3232-b5d2bf121818@suse.de>
References: <20170825151651.GB1027@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170825151651.GB1027-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It is now unused as both redhat and suse provide theirs.
Update versioning documentation for the new files.

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 Documentation/versioning.md |  49 ++++++++-------
 rdma-core.spec              | 146 --------------------------------------------
 2 files changed, 26 insertions(+), 169 deletions(-)
 delete mode 100644 rdma-core.spec

diff --git a/Documentation/versioning.md b/Documentation/versioning.md
index dca092d7..1d4a41b8 100644
--- a/Documentation/versioning.md
+++ b/Documentation/versioning.md
@@ -17,50 +17,53 @@ When the PACKAGE_VERSION is changed, the packaging files should be updated:
 
 ```diff
 diff --git a/CMakeLists.txt b/CMakeLists.txt
-index 8f7a47580f7b95..45cbc4e018b296 100644
+index a2464ec5..cf237904 100644
 --- a/CMakeLists.txt
 +++ b/CMakeLists.txt
 @@ -44,7 +44,7 @@ endif()
  set(PACKAGE_NAME "RDMA")
  
  # See Documentation/versioning.md
--set(PACKAGE_VERSION "12")
-+set(PACKAGE_VERSION "13")
- 
- #-------------------------
- # Basic standard paths
+-set(PACKAGE_VERSION "14")
++set(PACKAGE_VERSION "15")
+ # When this is changed the values in these files need changing too:
+ #   debian/libibverbs1.symbols
+ #   libibverbs/libibverbs.map
 diff --git a/debian/changelog b/debian/changelog
-index 6cabcc483ca85e..3defc050c5e457 100644
+index 86b402f4..9ee7fe16 100644
 --- a/debian/changelog
 +++ b/debian/changelog
 @@ -1,4 +1,4 @@
--rdma-core (12-1) unstable; urgency=low
-+rdma-core (13-1) unstable; urgency=low
+-rdma-core (14-1) unstable; urgency=low
++rdma-core (15-1) unstable; urgency=low
  
    * New version.
    * Adding debian/copyright.
-diff --git a/rdma-core.spec b/rdma-core.spec
-index 41eedb2813c52d..6519bc370a230a 100644
---- a/rdma-core.spec
-+++ b/rdma-core.spec
-@@ -1,5 +1,5 @@
- Name: rdma-core
--Version: 12
-+Version: 13
- Release: 1%{?dist}
- Summary: RDMA core userspace libraries and daemons
- 
 diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
-index 4271e7c9817e67..f2198ee3cd9410 100644
+index cc0c3ba0..62334730 100644
 --- a/redhat/rdma-core.spec
 +++ b/redhat/rdma-core.spec
 @@ -1,5 +1,5 @@
  Name: rdma-core
--Version: 12
-+Version: 13
+-Version: 14
++Version: 15
  Release: 1%{?dist}
  Summary: RDMA core userspace libraries and daemons
  
+diff --git a/suse/rdma-core.spec b/suse/rdma-core.spec
+index 76ca7286..a19f9e01 100644
+--- a/suse/rdma-core.spec
++++ b/suse/rdma-core.spec
+@@ -19,7 +19,7 @@
+ %bcond_without  systemd
+ %define         git_ver %{nil}
+ Name:           rdma-core
+-Version:        14
++Version:        15
+ Release:        0
+ Summary:        RDMA core userspace libraries and daemons
+ License:        GPL-2.0 or BSD-2-Clause
+
 ```
 
 # Shared Library Versions
diff --git a/rdma-core.spec b/rdma-core.spec
deleted file mode 100644
index 47e1ebe6..00000000
--- a/rdma-core.spec
+++ /dev/null
@@ -1,146 +0,0 @@
-Name: rdma-core
-Version: 15
-Release: 1%{?dist}
-Summary: RDMA core userspace libraries and daemons
-
-# Almost everything is licensed under the OFA dual GPLv2, 2 Clause BSD license
-#  providers/ipathverbs/ Dual licensed using a BSD license with an extra patent clause
-#  providers/rxe/ Incorporates code from ipathverbs and contains the patent clause
-#  providers/hfi1verbs Uses the 3 Clause BSD license
-License: (GPLv2 or BSD) and (GPLv2 or PathScale-BSD)
-Url: https://github.com/linux-rdma/rdma-core
-Source: rdma-core-%{version}.tgz
-
-BuildRequires: binutils
-BuildRequires: cmake >= 2.8.11
-BuildRequires: gcc
-BuildRequires: libudev-devel
-BuildRequires: pkgconfig
-BuildRequires: pkgconfig(libnl-3.0)
-BuildRequires: pkgconfig(libnl-route-3.0)
-BuildRequires: valgrind-devel
-BuildRequires: python
-%if 0%{?_unitdir:1}
-BuildRequires: systemd-devel
-%endif
-
-# Since we recommend developers use Ninja, so should packagers, for consistency.
-%define CMAKE_FLAGS %{nil}
-%if 0%{?suse_version}
-# SuSE releases have it, and sometime around cmake 3.3.2-1.2 the macros learned to use it.
-BuildRequires: ninja,make
-%define __builder ninja
-# cmake_install is specified by opensuse. It also specifies make_jobs, but it
-# doesn't work with __builder as other rpm macro packages define it too.
-%define make_jobs ninja -v %{?_smp_mflags}
-
-# Tumbleweed's cmake RPM macro adds -Wl,--no-undefined to the module flags
-# which is totally inappropriate and breaks building 'ENABLE_EXPORTS' style
-# module libraries (eg ibacmp).
-%define CMAKE_FLAGS -DCMAKE_MODULE_LINKER_FLAGS=""
-%else
-%if 0%{?fedora} >= 23
-# Ninja was introduced in FC23
-BuildRequires: ninja-build
-%define CMAKE_FLAGS -GNinja
-%define make_jobs ninja-build -v %{?_smp_mflags}
-%define cmake_install DESTDIR=%{buildroot} ninja-build install
-%else
-# Fallback to make otherwise
-BuildRequires: make
-%define make_jobs make -v %{?_smp_mflags}
-%define cmake_install DESTDIR=%{buildroot} make install
-%endif
-%endif
-
-# Detect if systemd is supported on this system
-%if 0%{?_unitdir:1}
-Requires(post): systemd-units
-Requires(preun): systemd-units
-Requires(postun): systemd-units
-%endif
-
-%description
-Temporary packaging
-
-This is a simple example without the split sub packages to get things started.
-
-%prep
-%setup
-
-%build
-
-# Detect if systemd is supported on this system
-%if 0%{?_unitdir:1}
-%define my_unitdir %{_unitdir}
-%else
-%define my_unitdir /tmp/
-%endif
-
-# New RPM defines _rundir, usually as /run
-%if 0%{?_rundir:1}
-%else
-%define _rundir /var/run
-%endif
-
-# New RPM defines _udevrulesdir, usually as /usr/lib/udev/rules.d
-%if 0%{?_udevrulesdir:1}
-%else
-# This is the old path (eg for C6)
-%define _udevrulesdir /lib/udev/rules.d
-%endif
-
-# Pass all of the rpm paths directly to GNUInstallDirs and our other defines.
-%cmake %{CMAKE_FLAGS} \
-         -DCMAKE_BUILD_TYPE=Release \
-         -DCMAKE_INSTALL_BINDIR:PATH=%{_bindir} \
-         -DCMAKE_INSTALL_SBINDIR:PATH=%{_sbindir} \
-         -DCMAKE_INSTALL_LIBDIR:PATH=%{_libdir} \
-         -DCMAKE_INSTALL_LIBEXECDIR:PATH=%{_libexecdir} \
-         -DCMAKE_INSTALL_LOCALSTATEDIR:PATH=%{_localstatedir} \
-         -DCMAKE_INSTALL_SHAREDSTATEDIR:PATH=%{_sharedstatedir} \
-         -DCMAKE_INSTALL_INCLUDEDIR:PATH=%{_includedir} \
-         -DCMAKE_INSTALL_INFODIR:PATH=%{_infodir} \
-         -DCMAKE_INSTALL_MANDIR:PATH=%{_mandir} \
-         -DCMAKE_INSTALL_SYSCONFDIR:PATH=%{_sysconfdir} \
-	 -DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=%{my_unitdir} \
-	 -DCMAKE_INSTALL_INITDDIR:PATH=%{_initrddir} \
-	 -DCMAKE_INSTALL_RUNDIR:PATH=%{_rundir} \
-	 -DCMAKE_INSTALL_DOCDIR:PATH=%{_docdir}/%{name}-%{version} \
-	 -DCMAKE_INSTALL_UDEV_RULESDIR:PATH=%{_udevrulesdir}
-%make_jobs
-
-%install
-%cmake_install
-
-%if 0%{?_unitdir:1}
-rm -rf %{buildroot}/%{_initrddir}/
-%else
-rm -rf %{buildroot}/%{my_unitdir}/
-%endif
-
-%post -p /sbin/ldconfig
-%postun -p /sbin/ldconfig
-
-%files
-%doc %{_mandir}/man*/*
-%{_bindir}/*
-%{_includedir}/*
-%{_libdir}/lib*.so*
-%{_libdir}/libibverbs/*
-%{_libdir}/ibacm/*
-%{_libdir}/rsocket/*
-%{_sbindir}/*
-%{_libexecdir}/*
-%{_udevrulesdir}/*
-%doc %{_docdir}/%{name}-%{version}/*
-%if 0%{?_unitdir:1}
-%{_unitdir}/*
-%else
-%config %{_initrddir}/*
-%endif
-%config %{_sysconfdir}/iwpmd.conf
-%config %{_sysconfdir}/srp_daemon.conf
-%config %{_sysconfdir}/libibverbs.d/*
-%config %{_sysconfdir}/rdma/modules/*
-%{_sysconfdir}/modprobe.d/*
-- 
2.14.1.252.gf15771ee3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
