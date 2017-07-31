From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/6] Detect if libsystemd is present
Date: Mon, 31 Jul 2017 14:25:40 -0600
Message-ID: <1501532745-28378-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501532745-28378-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501532745-28378-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is needed for systemd integration in the daemons.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                             |  7 +++++++
 buildlib/FindSystemd.cmake                 | 30 ++++++++++++++++++++++++++++++
 buildlib/cbuild                            | 18 ++++++++++++------
 buildlib/fixup-include/systemd-sd-daemon.h | 11 +++++++++++
 debian/control                             |  1 +
 rdma-core.spec                             |  3 +++
 redhat/rdma-core.spec                      |  1 +
 7 files changed, 65 insertions(+), 6 deletions(-)
 create mode 100644 buildlib/FindSystemd.cmake
 create mode 100644 buildlib/fixup-include/systemd-sd-daemon.h

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 1e9b1a363b7436..5de86f13f5ac19 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -328,6 +328,10 @@ CHECK_C_SOURCE_COMPILES("
  int main(int argc,const char *argv[]) {return 0;}"
   HAVE_COHERENT_DMA)
 
+find_package(Systemd)
+include_directories(${SYSTEMD_INCLUDE_DIRS})
+RDMA_DoFixup("${SYSTEMD_FOUND}" "systemd/sd-daemon.h")
+
 #-------------------------
 # Apply fixups
 
@@ -478,6 +482,9 @@ else()
     message(STATUS " netlink/route/link.h and net/if.h NOT co-includable (old headers)")
   endif()
 endif()
+if (NOT SYSTEMD_FOUND)
+  message(STATUS " libsystemd NOT found (disabling features)")
+endif()
 if (NOT UDEV_FOUND)
   message(STATUS " libudev NOT found (disabling features)")
 endif()
diff --git a/buildlib/FindSystemd.cmake b/buildlib/FindSystemd.cmake
new file mode 100644
index 00000000000000..fbced4028e823e
--- /dev/null
+++ b/buildlib/FindSystemd.cmake
@@ -0,0 +1,30 @@
+# COPYRIGHT (c) 2015 Obsidian Research Corporation.
+# Licensed under BSD (MIT variant) or GPLv2. See COPYING.
+
+find_path(LIBSYSTEMD_INCLUDE_DIRS "systemd/sd-journal.h")
+
+if (LIBSYSTEMD_INCLUDE_DIRS)
+  set(SYSTEMD_INCLUDE_DIRS ${LIBSYSTEMD_INCLUDE_DIRS})
+  find_library(LIBSYSTEMD_LIBRARY NAMES systemd libsystemd)
+  # Older systemd uses a split library
+  if (NOT LIBSYSTEMD_LIBRARY)
+    find_library(LIBSYSTEMD_JOURNAL_LIBRARY NAMES systemd-journal libsystemd-journal)
+    find_library(LIBSYSTEMD_ID128_LIBRARY NAMES systemd-id128 libsystemd-id128)
+    find_library(LIBSYSTEMD_DAEMON_LIBRARY NAMES systemd-daemon libsystemd-daemon)
+
+    if (LIBSYSTEMD_JOURNAL_LIBRARY AND LIBSYSTEMD_ID128_LIBRARY AND LIBSYSTEMD_DAEMON_LIBRARY)
+      set(SYSTEMD_LIBRARIES
+	${LIBSYSTEMD_JOURNAL_LIBRARY}
+	${LIBSYSTEMD_ID128_LIBRARY}
+	${LIBSYSTEMD_DAEMON_LIBRARY})
+    endif()
+  else()
+    set(SYSTEMD_LIBRARIES ${LIBSYSTEMD_LIBRARY})
+  endif()
+  set(SYSTEMD_INCLUDE_DIRS)
+endif()
+
+include(FindPackageHandleStandardArgs)
+find_package_handle_standard_args(Systemd REQUIRED_VARS SYSTEMD_LIBRARIES LIBSYSTEMD_INCLUDE_DIRS)
+
+mark_as_advanced(LIBSYSTEMD_LIBRARY LIBSYSTEMD_JOURNAL_LIBRARY LIBSYSTEMD_ID128_LIBRARY LIBSYSTEMD_DAEMON_LIBRARY)
diff --git a/buildlib/cbuild b/buildlib/cbuild
index 888fae6ccca692..9b49fa5343c8b4 100755
--- a/buildlib/cbuild
+++ b/buildlib/cbuild
@@ -107,7 +107,7 @@ class centos6(YumEnvironment):
 
 class centos7(YumEnvironment):
     docker_parent = "centos:7";
-    pkgs = centos6.pkgs;
+    pkgs = centos6.pkgs | {'systemd-devel'};
     name = "centos7";
     use_make = True;
     specfile = "redhat/rdma-core.spec";
@@ -152,7 +152,7 @@ class APTEnvironment(Environment):
 
 class trusty(APTEnvironment):
     docker_parent = "ubuntu:14.04";
-    pkgs = {
+    common_pkgs = {
         'build-essential',
         'cmake',
         'debhelper',
@@ -167,30 +167,35 @@ class trusty(APTEnvironment):
         'python',
         'valgrind',
         };
+    pkgs = common_pkgs | {
+        'libsystemd-daemon-dev',
+        'libsystemd-id128-dev',
+        'libsystemd-journal-dev',
+        };
     name = "ubuntu-14.04";
     aliases = {"trusty"};
 
 class xenial(APTEnvironment):
     docker_parent = "ubuntu:16.04"
-    pkgs = trusty.pkgs;
+    pkgs = trusty.common_pkgs | {"libsystemd-dev"};
     name = "ubuntu-16.04";
     aliases = {"xenial"};
 
 class jessie(APTEnvironment):
     docker_parent = "debian:8"
-    pkgs = trusty.pkgs;
+    pkgs = xenial.pkgs;
     name = "debian-8";
     aliases = {"jessie"};
 
 class stretch(APTEnvironment):
     docker_parent = "debian:9"
-    pkgs = trusty.pkgs;
+    pkgs = jessie.pkgs;
     name = "debian-9";
     aliases = {"stretch"};
 
 class debian_experimental(APTEnvironment):
     docker_parent = "debian:experimental"
-    pkgs = (trusty.pkgs ^ {"gcc"}) | {"gcc-7"};
+    pkgs = (stretch.pkgs ^ {"gcc"}) | {"gcc-7"};
     name = "debian-experimental";
 
     def get_docker_file(self):
@@ -299,6 +304,7 @@ class harlequin(ZypperEnvironment):
         'pkg-config',
         'python',
         'rpm-build',
+        'systemd-devel',
         'valgrind-devel',
     };
     name = "opensuse-13.2";
diff --git a/buildlib/fixup-include/systemd-sd-daemon.h b/buildlib/fixup-include/systemd-sd-daemon.h
new file mode 100644
index 00000000000000..bd111bc6d21cd9
--- /dev/null
+++ b/buildlib/fixup-include/systemd-sd-daemon.h
@@ -0,0 +1,11 @@
+#define SD_LISTEN_FDS_START 3
+
+static inline int sd_listen_fds(int unset_environment)
+{
+	return 0;
+}
+
+static inline int sd_is_socket(int fd, int family, int type, int listening)
+{
+	return 0;
+}
diff --git a/debian/control b/debian/control
index 444b0eaa047ba8..156cec8fbc1a27 100644
--- a/debian/control
+++ b/debian/control
@@ -10,6 +10,7 @@ Build-Depends: cmake (>= 2.8.11),
                dpkg-dev (>= 1.17),
                libnl-3-dev,
                libnl-route-3-dev,
+               libsystemd-dev,
                libudev-dev,
                ninja-build,
                pkg-config,
diff --git a/rdma-core.spec b/rdma-core.spec
index b923a5d7636548..9d767a29eb1bba 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -20,6 +20,9 @@ BuildRequires: pkgconfig(libnl-3.0)
 BuildRequires: pkgconfig(libnl-route-3.0)
 BuildRequires: valgrind-devel
 BuildRequires: python
+%if 0%{?_unitdir:1}
+BuildRequires: systemd-devel
+%endif
 
 # Since we recommend developers use Ninja, so should packagers, for consistency.
 %define CMAKE_FLAGS %{nil}
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 4413418ffc44cc..e5a59e073b7afd 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -20,6 +20,7 @@ BuildRequires: pkgconfig(libnl-3.0)
 BuildRequires: pkgconfig(libnl-route-3.0)
 BuildRequires: valgrind-devel
 BuildRequires: systemd
+BuildRequires: systemd-devel
 BuildRequires: python
 
 Requires: dracut, kmod, systemd
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
