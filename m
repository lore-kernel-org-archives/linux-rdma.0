From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core v2 1/4] Install end user focused documentation files
Date: Thu, 20 Oct 2016 11:33:54 -0400
Message-ID: <20161020153357.27286-2-jarod@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161020153357.27286-1-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161020153357.27286-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We recommend that all distros ship these.

v2: installing README.md and MAINTAINERS as well.

Suggested-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 CMakeLists.txt                   |  3 ++-
 Documentation/CMakeLists.txt     | 10 ++++++++++
 debian/ibacm.install             |  1 +
 debian/ibverbs-providers.install |  1 +
 debian/libibcm1.install          |  1 +
 debian/libibverbs1.install       |  1 +
 debian/librdmacm1.install        |  1 +
 debian/srptools.install          |  1 +
 rdma-core.spec                   |  6 +++++-
 9 files changed, 23 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/CMakeLists.txt

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 4d291d2..8dec772 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -21,7 +21,7 @@
 #      Use the historical search path for providers, in the standard system library.
 
 cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
-project(RDMA C)
+project(rdma-core C)
 
 # CMake likes to use -rdynamic too much, they fixed it in 3.4.
 if(POLICY CMP0065)
@@ -259,6 +259,7 @@ configure_file("${BUILDLIB}/config.h.in" "${BUILD_INCLUDE}/config.h" ESCAPE_QUOT
 # Sub-directories
 add_subdirectory(ccan)
 add_subdirectory(util)
+add_subdirectory(Documentation)
 # Libraries
 add_subdirectory(libibumad)
 add_subdirectory(libibumad/man)
diff --git a/Documentation/CMakeLists.txt b/Documentation/CMakeLists.txt
new file mode 100644
index 0000000..6170b5f
--- /dev/null
+++ b/Documentation/CMakeLists.txt
@@ -0,0 +1,10 @@
+install(FILES
+  ibacm.md
+  ibsrpdm.md
+  libibcm.md
+  libibverbs.md
+  librdmacm.md
+  rxe.md
+  ../README.md
+  ../MAINTAINERS
+  DESTINATION "${CMAKE_INSTALL_DOCDIR}")
diff --git a/debian/ibacm.install b/debian/ibacm.install
index 2bb9591..f2a6c53 100644
--- a/debian/ibacm.install
+++ b/debian/ibacm.install
@@ -8,3 +8,4 @@ usr/share/man/man1/ib_acme.1
 usr/share/man/man1/ibacm.1
 usr/share/man/man7/ibacm.7
 usr/share/man/man7/ibacm_prov.7
+usr/share/doc/rdma-core/ibacm.md usr/share/doc/ibacm/
diff --git a/debian/ibverbs-providers.install b/debian/ibverbs-providers.install
index 1b41218..7458540 100644
--- a/debian/ibverbs-providers.install
+++ b/debian/ibverbs-providers.install
@@ -5,3 +5,4 @@ usr/lib/truescale-serdes.cmds
 usr/share/man/man8/rxe_cfg.8
 usr/share/man/man7/rxe.7
 usr/bin/rxe_cfg
+usr/share/doc/rdma-core/rxe.md usr/share/doc/ibverbs-providers/
diff --git a/debian/libibcm1.install b/debian/libibcm1.install
index 6f270b7..a0ace6e 100644
--- a/debian/libibcm1.install
+++ b/debian/libibcm1.install
@@ -1 +1,2 @@
 usr/lib/*/libibcm*.so.*
+usr/share/doc/rdma-core/libibcm.md usr/share/doc/libibcm1/
diff --git a/debian/libibverbs1.install b/debian/libibverbs1.install
index 78a7f76..83bdd80 100644
--- a/debian/libibverbs1.install
+++ b/debian/libibverbs1.install
@@ -1 +1,2 @@
 usr/lib/*/libibverbs*.so.*
+usr/share/doc/rdma-core/libibverbs.md usr/share/doc/libibverbs1/
diff --git a/debian/librdmacm1.install b/debian/librdmacm1.install
index c17048e..09140ab 100644
--- a/debian/librdmacm1.install
+++ b/debian/librdmacm1.install
@@ -1,2 +1,3 @@
 usr/lib/*/librdmacm*.so.*
 usr/lib/*/rsocket/librspreload*.so*
+usr/share/doc/rdma-core/librdmacm.md usr/share/doc/librdmacm1/
diff --git a/debian/srptools.install b/debian/srptools.install
index 17b909d..9c07015 100644
--- a/debian/srptools.install
+++ b/debian/srptools.install
@@ -6,3 +6,4 @@ usr/sbin/ibsrpdm
 usr/sbin/srp_daemon
 usr/share/man/man1/ibsrpdm.1
 usr/share/man/man1/srp_daemon.1
+usr/share/doc/rdma-core/ibsrpdm.md usr/share/doc/srptools/
diff --git a/rdma-core.spec b/rdma-core.spec
index 96c86fe..39be6a0 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -85,7 +85,8 @@ This is a simple example without the split sub packages to get things started.
          -DCMAKE_INSTALL_SYSCONFDIR:PATH=%{_sysconfdir} \
 	 -DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=%{my_unitdir} \
 	 -DCMAKE_INSTALL_INITDDIR:PATH=%{_initrddir} \
-	 -DCMAKE_INSTALL_RUNDIR:PATH=%{_rundir}
+	 -DCMAKE_INSTALL_RUNDIR:PATH=%{_rundir} \
+	 -DCMAKE_INSTALL_DOCDIR:PATH=%{_docdir}/%{name}-%{version}
 %make_jobs
 
 %install
@@ -102,6 +103,8 @@ rm -rf %{buildroot}/%{my_unitdir}/
 
 %files
 %doc %{_mandir}/man*/*
+%doc %{_docdir}/%{name}-%{version}/README.md
+%doc %{_docdir}/%{name}-%{version}/MAINTAINERS
 %{_bindir}/*
 %{_includedir}/*
 %{_libdir}/lib*.so*
@@ -110,6 +113,7 @@ rm -rf %{buildroot}/%{my_unitdir}/
 %{_libdir}/rsocket/*
 %{_sbindir}/*
 %{_libexecdir}/*
+%{_docdir}/%{name}-%{version}/*
 %if 0%{?_unitdir:1}
 %{_unitdir}/*
 %else
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
