From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/4] rpm spec: install documentation too
Date: Fri, 14 Oct 2016 16:52:04 -0600
Message-ID: <20161014225204.GB16509@obsidianresearch.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014192136.11731-2-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161014192136.11731-2-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2016 at 03:21:33PM -0400, Jarod Wilson wrote:
> At least in the Red Hat world, we like to install the documentation files
> provided in a given source tree.

I think other distros would like to do this too, can you use this
patch instead?

>From a23838ccc05574b1975741770abcbd66f7587293 Mon Sep 17 00:00:00 2001
From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Fri, 14 Oct 2016 15:21:33 -0400
Subject: [PATCH] Install end user focused documentation files

We recommend that all distros ship these.

Suggested-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                   | 3 ++-
 Documentation/CMakeLists.txt     | 8 ++++++++
 debian/ibacm.install             | 1 +
 debian/ibverbs-providers.install | 1 +
 debian/libibcm1.install          | 1 +
 debian/libibverbs1.install       | 1 +
 debian/librdmacm1.install        | 1 +
 debian/srptools.install          | 1 +
 rdma-core.spec                   | 4 +++-
 9 files changed, 19 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/CMakeLists.txt

diff --git a/CMakeLists.txt b/CMakeLists.txt
index a23aa860e6d3f2..6d2960e22b77b2 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -21,7 +21,7 @@
 #      Use the historical search path for providers, in the standard system library.
 
 cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
-project(RDMA C)
+project(rdma-core C)
 
 # CMake likes to use -rdynamic too much, they fixed it in 3.4.
 if(POLICY CMP0065)
@@ -321,6 +321,7 @@ configure_file("${BUILDLIB}/config.h.in" "${BUILD_INCLUDE}/config.h" ESCAPE_QUOT
 # Sub-directories
 add_subdirectory(ccan)
 add_subdirectory(util)
+add_subdirectory(Documentation)
 # Libraries
 add_subdirectory(libibumad)
 add_subdirectory(libibumad/man)
diff --git a/Documentation/CMakeLists.txt b/Documentation/CMakeLists.txt
new file mode 100644
index 00000000000000..619b8587f11f11
--- /dev/null
+++ b/Documentation/CMakeLists.txt
@@ -0,0 +1,8 @@
+install(FILES
+  ibacm.md
+  ibsrpdm.md
+  libibcm.md
+  libibverbs.md
+  librdmacm.md
+  rxe.md
+  DESTINATION "${CMAKE_INSTALL_DOCDIR}")
diff --git a/debian/ibacm.install b/debian/ibacm.install
index 2bb9591c051dbe..f2a6c53eb79d02 100644
--- a/debian/ibacm.install
+++ b/debian/ibacm.install
@@ -8,3 +8,4 @@ usr/share/man/man1/ib_acme.1
 usr/share/man/man1/ibacm.1
 usr/share/man/man7/ibacm.7
 usr/share/man/man7/ibacm_prov.7
+usr/share/doc/rdma-core/ibacm.md usr/share/doc/ibacm/
diff --git a/debian/ibverbs-providers.install b/debian/ibverbs-providers.install
index 1b4121874b2cc1..7458540b37714d 100644
--- a/debian/ibverbs-providers.install
+++ b/debian/ibverbs-providers.install
@@ -5,3 +5,4 @@ usr/lib/truescale-serdes.cmds
 usr/share/man/man8/rxe_cfg.8
 usr/share/man/man7/rxe.7
 usr/bin/rxe_cfg
+usr/share/doc/rdma-core/rxe.md usr/share/doc/ibverbs-providers/
diff --git a/debian/libibcm1.install b/debian/libibcm1.install
index 6f270b7f3bfac3..a0ace6ebf2eac3 100644
--- a/debian/libibcm1.install
+++ b/debian/libibcm1.install
@@ -1 +1,2 @@
 usr/lib/*/libibcm*.so.*
+usr/share/doc/rdma-core/libibcm.md usr/share/doc/libibcm1/
diff --git a/debian/libibverbs1.install b/debian/libibverbs1.install
index 78a7f76d39c3e4..83bdd802b48d5c 100644
--- a/debian/libibverbs1.install
+++ b/debian/libibverbs1.install
@@ -1 +1,2 @@
 usr/lib/*/libibverbs*.so.*
+usr/share/doc/rdma-core/libibverbs.md usr/share/doc/libibverbs1/
diff --git a/debian/librdmacm1.install b/debian/librdmacm1.install
index c17048e6e46307..09140ab84de7dc 100644
--- a/debian/librdmacm1.install
+++ b/debian/librdmacm1.install
@@ -1,2 +1,3 @@
 usr/lib/*/librdmacm*.so.*
 usr/lib/*/rsocket/librspreload*.so*
+usr/share/doc/rdma-core/librdmacm.md usr/share/doc/librdmacm1/
diff --git a/debian/srptools.install b/debian/srptools.install
index 17b909d721a978..9c0701526e3cd8 100644
--- a/debian/srptools.install
+++ b/debian/srptools.install
@@ -6,3 +6,4 @@ usr/sbin/ibsrpdm
 usr/sbin/srp_daemon
 usr/share/man/man1/ibsrpdm.1
 usr/share/man/man1/srp_daemon.1
+usr/share/doc/rdma-core/ibsrpdm.md usr/share/doc/srptools/
diff --git a/rdma-core.spec b/rdma-core.spec
index 96c86fe06f3ae9..47b7d87e403219 100644
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
@@ -110,6 +111,7 @@ rm -rf %{buildroot}/%{my_unitdir}/
 %{_libdir}/rsocket/*
 %{_sbindir}/*
 %{_libexecdir}/*
+%{_docdir}/%{name}-%{version}/*
 %if 0%{?_unitdir:1}
 %{_unitdir}/*
 %else
-- 
2.7.4



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
