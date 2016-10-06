From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 17/17] Debian Packaging
Date: Thu,  6 Oct 2016 14:51:43 -0600
Message-ID: <1475787103-13283-18-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is based on the packaging used in Debian Unstable and attempts
to largely duplicate that output. The significant difference is
the ibverbs-providers package that incorporates all the providers.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 Documentation/versioning.md      |  10 ++
 buildlib/ninja-wrapper           |  16 +++
 debian/changelog                 |   5 +
 debian/compat                    |   1 +
 debian/control                   | 299 +++++++++++++++++++++++++++++++++++++++
 debian/ibacm.install             |  10 ++
 debian/ibverbs-providers.install |   7 +
 debian/ibverbs-utils.install     |  16 +++
 debian/iwpmd.install             |   7 +
 debian/libibcm-dev.install       |   3 +
 debian/libibcm1.install          |   1 +
 debian/libibcm1.symbols          |  23 +++
 debian/libibumad-dev.install     |   3 +
 debian/libibumad3.install        |   2 +
 debian/libibumad3.symbols        |  38 +++++
 debian/libibverbs-dev.install    |  12 ++
 debian/libibverbs1.install       |   1 +
 debian/libibverbs1.postinst      |  10 ++
 debian/libibverbs1.symbols       | 134 ++++++++++++++++++
 debian/librdmacm-dev.install     |  57 ++++++++
 debian/librdmacm1.install        |   2 +
 debian/librdmacm1.symbols        |  64 +++++++++
 debian/rdmacm-utils.install      |  24 ++++
 debian/rules                     |  99 +++++++++++++
 debian/srptools.install          |   8 ++
 25 files changed, 852 insertions(+)
 create mode 100644 buildlib/ninja-wrapper
 create mode 100644 debian/changelog
 create mode 100644 debian/compat
 create mode 100644 debian/control
 create mode 100644 debian/ibacm.install
 create mode 100644 debian/ibverbs-providers.install
 create mode 100644 debian/ibverbs-utils.install
 create mode 100644 debian/iwpmd.install
 create mode 100644 debian/libibcm-dev.install
 create mode 100644 debian/libibcm1.install
 create mode 100644 debian/libibcm1.symbols
 create mode 100644 debian/libibumad-dev.install
 create mode 100644 debian/libibumad3.install
 create mode 100644 debian/libibumad3.symbols
 create mode 100644 debian/libibverbs-dev.install
 create mode 100644 debian/libibverbs1.install
 create mode 100644 debian/libibverbs1.postinst
 create mode 100644 debian/libibverbs1.symbols
 create mode 100644 debian/librdmacm-dev.install
 create mode 100644 debian/librdmacm1.install
 create mode 100644 debian/librdmacm1.symbols
 create mode 100644 debian/rdmacm-utils.install
 create mode 100755 debian/rules
 create mode 100644 debian/srptools.install

diff --git a/Documentation/versioning.md b/Documentation/versioning.md
index a7c9a7bdcfc2..b887b26e7b58 100644
--- a/Documentation/versioning.md
+++ b/Documentation/versioning.md
@@ -39,6 +39,16 @@ index d1407ee9e24b..fca79ccf57e5 100644
 +Version: 12
  Release: 1%{?dist}
  Summary: Userspace components for the Linux Kernel\'s drivers/infiniband stack
+diff --git a/debian/changelog b/debian/changelog
+index 0e6cba0be464..a12ac6b60028 100644
+--- a/debian/changelog
++++ b/debian/changelog
+@@ -1,4 +1,4 @@
+-rdma-core (11-1) unstable; urgency=low
++rdma-core (12-1) unstable; urgency=low
+ 
+   * New version
+ 
 ```
 
 # Shared Library Versions
diff --git a/buildlib/ninja-wrapper b/buildlib/ninja-wrapper
new file mode 100644
index 000000000000..0759c2b890e6
--- /dev/null
+++ b/buildlib/ninja-wrapper
@@ -0,0 +1,16 @@
+# This is so we can use Ninja as the build engine but still present a Makefile
+# interface to debhelper.
+
+# We want to use Ninja because it is all that is tested regularly and produces
+# usable build output, not an unreadable mess like the cmake version does.
+
+export DESTDIR
+
+all:
+	ninja -v
+
+install:
+	ninja install
+
+clean:
+	ninja clean
diff --git a/debian/changelog b/debian/changelog
new file mode 100644
index 000000000000..995252d9244c
--- /dev/null
+++ b/debian/changelog
@@ -0,0 +1,5 @@
+rdma-core (11-1) unstable; urgency=low
+
+  * New version
+
+ -- Jason Gunthorpe <jgg-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>  Mon, 12 Sep 2016 13:44:24 -0600
diff --git a/debian/compat b/debian/compat
new file mode 100644
index 000000000000..ec635144f600
--- /dev/null
+++ b/debian/compat
@@ -0,0 +1 @@
+9
diff --git a/debian/control b/debian/control
new file mode 100644
index 000000000000..2335d1f4814d
--- /dev/null
+++ b/debian/control
@@ -0,0 +1,299 @@
+Source: rdma-core
+Maintainer: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
+Section: net
+Priority: extra
+Build-Depends: build-essential,
+	       cmake (>= 2.8.11),
+	       debhelper (>= 9),
+	       dh-systemd,
+	       dpkg-dev (>= 1.17),
+	       gcc,
+	       libnl-3-dev,
+	       libnl-route-3-dev,
+	       make,
+	       ninja,
+	       pkg-config,
+	       valgrind
+Standards-Version: 3.9.8
+Vcs-Git: https://github.com/linux-rdma/rdma-core.git
+Vcs-Browser: https://github.com/linux-rdma/rdma-core
+
+Package: ibacm
+Architecture: any
+Depends: ${shlibs:Depends}, ${misc:Depends}
+Description: InfiniBand Communication Manager Assistant (ACM)
+ The IB ACM implements and provides a framework for name, address, and
+ route (path) resolution services over InfiniBand.
+ It is intended to address connection setup scalability issues running
+ MPI applications on large clusters.  The IB ACM provides information
+ needed to establish a connection, but does not implement the CM protocol.
+ A primary user of the ibacm service is the librdmacm library.
+
+Package: ibverbs-utils
+Section: net
+Architecture: linux-any
+Depends: ${shlibs:Depends}, ${misc:Depends}
+Description: Examples for the libibverbs library
+ libibverbs is a library that allows userspace processes to use RDMA
+ "verbs" as described in the InfiniBand Architecture Specification and
+ the RDMA Protocol Verbs Specification.  iWARP ethernet NICs support
+ RDMA over hardware-offloaded TCP/IP, while InfiniBand is a
+ high-throughput, low-latency networking technology.  InfiniBand host
+ channel adapters (HCAs) and iWARP NICs commonly support direct
+ hardware access from userspace (kernel bypass), and libibverbs
+ supports this when available.
+ .
+ This package contains useful libibverbs1 example programs such as
+ ibv_devinfo, which displays information about InfiniBand devices.
+
+Package: ibverbs-providers
+Section: net
+Architecture: linux-any
+Depends: ${shlibs:Depends}, ${misc:Depends}, ${perl:Depends}
+Provides: libcxgb3-1, libipathverbs1, libmlx4-1, libmlx5-1, libmthca1, libnes1
+Replaces: libcxgb3-1, libipathverbs1, libmlx4-1, libmlx5-1, libmthca1, libnes1
+Breaks: libcxgb3-1, libipathverbs1, libmlx4-1, libmlx5-1, libmthca1, libnes1
+Description: User space provider drivers for libibverbs
+ libibverbs is a library that allows userspace processes to use RDMA
+ "verbs" as described in the InfiniBand Architecture Specification and
+ the RDMA Protocol Verbs Specification.  iWARP ethernet NICs support
+ RDMA over hardware-offloaded TCP/IP, while InfiniBand is a
+ high-throughput, low-latency networking technology.  InfiniBand host
+ channel adapters (HCAs) and iWARP NICs commonly support direct
+ hardware access from userspace (kernel bypass), and libibverbs
+ supports this when available.
+ .
+ A RDMA driver consists of a kernel portion and a user space portion.
+ This package contains the user space verbs drivers.
+
+Package: libibcm1
+Architecture: linux-any
+Depends: ${misc:Depends}, ${shlibs:Depends}
+Description: InfiniBand Communication Manager (CM) library
+ libibcm provides a userspace implementation of an InfiniBand
+ Communication Manager (CM). The CM handles both connection
+ establishment as well as service ID resolution.
+ .
+ This package contains the shared library.
+
+Package: libibcm1-dbg
+Section: debug
+Architecture: linux-any
+Depends: ${misc:Depends}
+Description: InfiniBand Communication Manager (CM) library
+ libibcm provides a userspace implementation of an InfiniBand
+ Communication Manager (CM). The CM handles both connection
+ establishment as well as service ID resolution.
+ .
+ This package contains the debugging symbols associated with
+ libibcm1. They will automatically be used by gdb for debugging
+ libibcm-related issues.
+
+Package: libibcm-dev
+Section: libdevel
+Architecture: linux-any
+Depends: libibcm1 (= ${binary:Version}), ${misc:Depends}
+Description: Development files for the libibcm library
+ libibcm provides a userspace implementation of an InfiniBand
+ Communication Manager (CM). The CM handles both connection
+ establishment as well as service ID resolution.
+ .
+ This package is needed to compile programs against libibcm1.
+ It contains the header files and static libraries (optionally)
+ needed for compiling.
+
+Package: libibumad3
+Architecture: linux-any
+Section: libs
+Pre-Depends: ${misc:Pre-Depends}
+Depends: ${shlibs:Depends}, ${misc:Depends}
+Description: InfiniBand Userspace Management Datagram (uMAD) library
+ libibumad provides userspace Infiniband Management Datagram (uMAD)
+ functions which sit on top of the uMAD modules in the kernel.
+ These are used by InfiniBand diagnostic and management tools.
+ .
+ This package contains the shared library.
+
+Package: libibumad3-dbg
+Section: debug
+Architecture: linux-any
+Depends: ${misc:Depends}
+Description: InfiniBand Userspace Management Datagram (uMAD) library
+ libibumad provides userspace Infiniband Management Datagram (uMAD)
+ functions which sit on top of the uMAD modules in the kernel.
+ These are used by InfiniBand diagnostic and management tools.
+ .
+ This package contains the debugging symbols associated with
+ libibumad3. They will automatically be used by gdb for debugging
+ libibumad-related issues.
+
+Package: libibumad-dev
+Section: libdevel
+Architecture: linux-any
+Depends: libibumad3 (= ${binary:Version}), ${misc:Depends}
+Description: Development files for libibumad
+ libibumad provides userspace Infiniband Management Datagram (uMAD)
+ functions which sit on top of the uMAD modules in the kernel.
+ These are used by InfiniBand diagnostic and management tools.
+ .
+ This package is needed to compile programs against libibumad.
+ It contains the header files and static libraries (optionally)
+ needed for compiling.
+
+Package: libibverbs1
+Architecture: linux-any
+Section: libs
+Pre-Depends: ${misc:Pre-Depends}
+Depends: ${shlibs:Depends}, ${misc:Depends}, adduser
+Recommends: ibverbs-providers
+Description: Library for direct userspace use of RDMA (InfiniBand/iWARP)
+ libibverbs is a library that allows userspace processes to use RDMA
+ "verbs" as described in the InfiniBand Architecture Specification and
+ the RDMA Protocol Verbs Specification.  iWARP ethernet NICs support
+ RDMA over hardware-offloaded TCP/IP, while InfiniBand is a
+ high-throughput, low-latency networking technology.  InfiniBand host
+ channel adapters (HCAs) and iWARP NICs commonly support direct
+ hardware access from userspace (kernel bypass), and libibverbs
+ supports this when available.
+ .
+ For this library to be useful, a device-specific plug-in module
+ should also be installed.
+ .
+ This package contains the shared library.
+
+Package: libibverbs1-dbg
+Section: debug
+Architecture: linux-any
+Depends: ${misc:Depends}, libibverbs1 (= ${binary:Version})
+Description: Debugging symbols for the libibverbs library
+ libibverbs is a library that allows userspace processes to use RDMA
+ "verbs" as described in the InfiniBand Architecture Specification and
+ the RDMA Protocol Verbs Specification.  iWARP ethernet NICs support
+ RDMA over hardware-offloaded TCP/IP, while InfiniBand is a
+ high-throughput, low-latency networking technology.  InfiniBand host
+ channel adapters (HCAs) and iWARP NICs commonly support direct
+ hardware access from userspace (kernel bypass), and libibverbs
+ supports this when available.
+ .
+ This package contains the debugging symbols associated with
+ libibverbs1. They will automatically be used by gdb for debugging
+ libibverbs-related issues.
+
+Package: libibverbs-dev
+Section: libdevel
+Architecture: linux-any
+Depends: ${misc:Depends}, libibverbs1 (= ${binary:Version})
+Description: Development files for the libibverbs library
+ libibverbs is a library that allows userspace processes to use RDMA
+ "verbs" as described in the InfiniBand Architecture Specification and
+ the RDMA Protocol Verbs Specification.  iWARP ethernet NICs support
+ RDMA over hardware-offloaded TCP/IP, while InfiniBand is a
+ high-throughput, low-latency networking technology.  InfiniBand host
+ channel adapters (HCAs) and iWARP NICs commonly support direct
+ hardware access from userspace (kernel bypass), and libibverbs
+ supports this when available.
+ .
+ This package is needed to compile programs against libibverbs1.
+ It contains the header files and static libraries (optionally)
+ needed for compiling.
+
+Package: librdmacm1
+Architecture: linux-any
+Section: libs
+Pre-Depends: ${misc:Pre-Depends}
+Depends: ${misc:Depends}, ${shlibs:Depends}
+Description: Library for managing RDMA connections
+ librdmacm is a library that allows applications to set up reliable
+ connected and unreliable datagram transfers when using RDMA adapters.
+ It provides a transport-neutral interface in the sense that the same
+ code can be used for both InfiniBand and iWARP adapters.  The
+ interface is based on sockets, but adapted for queue pair (QP) based
+ semantics: communication must use a specific RDMA device, and data
+ transfers are message-based.
+ .
+ librdmacm only provides communication management (connection setup
+ and tear-down) and works in conjunction with the verbs interface
+ provided by libibverbs, which provides the interface used to actually
+ transfer data.
+ .
+ This package contains the shared library.
+
+Package: librdmacm1-dbg
+Section: debug
+Architecture: linux-any
+Depends: librdmacm1 (= ${binary:Version}), ${misc:Depends}
+Description: Debugging symbols for the librdmacm library
+ librdmacm is a library that allows applications to set up reliable
+ connected and unreliable datagram transfers when using RDMA adapters.
+ It provides a transport-neutral interface in the sense that the same
+ code can be used for both InfiniBand and iWARP adapters.  The
+ interface is based on sockets, but adapted for queue pair (QP) based
+ semantics: communication must use a specific RDMA device, and data
+ transfers are message-based.
+ .
+ librdmacm only provides communication management (connection setup
+ and tear-down) and works in conjunction with the verbs interface
+ provided by libibverbs, which provides the interface used to actually
+ transfer data.
+ .
+ This package contains the debugging symbols associated with
+ librdmacm1. They will automatically be used by gdb for debugging
+ librdmacm-related issues.
+
+Package: librdmacm-dev
+Section: libdevel
+Architecture: linux-any
+Depends: libibverbs-dev, librdmacm1 (= ${binary:Version}), ${misc:Depends}
+Description: Development files for the librdmacm library
+ librdmacm is a library that allows applications to set up reliable
+ connected and unreliable datagram transfers when using RDMA adapters.
+ It provides a transport-neutral interface in the sense that the same
+ code can be used for both InfiniBand and iWARP adapters.  The
+ interface is based on sockets, but adapted for queue pair (QP) based
+ semantics: communication must use a specific RDMA device, and data
+ transfers are message-based.
+ .
+ librdmacm only provides communication management (connection setup
+ and tear-down) and works in conjunction with the verbs interface
+ provided by libibverbs, which provides the interface used to actually
+ transfer data.
+ .
+ This package is needed to compile programs against librdmacm1.
+ It contains the header files and static libraries (optionally)
+ needed for compiling.
+
+Package: rdmacm-utils
+Section: net
+Architecture: linux-any
+Depends: ${misc:Depends}, ${shlibs:Depends}
+Description: Examples for the librdmacm library
+ librdmacm is a library that allows applications to set up reliable
+ connected and unreliable datagram transfers when using RDMA adapters.
+ It provides a transport-neutral interface in the sense that the same
+ code can be used for both InfiniBand and iWARP adapters.  The
+ interface is based on sockets, but adapted for queue pair (QP) based
+ semantics: communication must use a specific RDMA device, and data
+ transfers are message-based.
+ .
+ librdmacm only provides communication management (connection setup
+ and tear-down) and works in conjunction with the verbs interface
+ provided by libibverbs, which provides the interface used to actually
+ transfer data.
+ .
+ This package contains useful librdmacm1 example programs such as
+ rping and udaddy.
+
+Package: srptools
+Architecture: linux-any
+Depends: ${shlibs:Depends}, ${misc:Depends}, infiniband-diags
+Description: Tools for Infiniband attached storage (SRP)
+ In conjunction with the kernel ib_srp driver, srptools allows you to
+ discover and use Infiniband attached storage devices which use the
+ SCSI RDMA Protocol (SRP).
+
+Package: iwpmd
+Architecture: linux-any
+Depends: ${shlibs:Depends}, ${misc:Depends}, infiniband-diags
+Description:Userspace component for iWarp RDMA services
+ iwpmd provides a userspace service for iWarp drivers to claim
+ tcp ports through the standard socket interface.
diff --git a/debian/ibacm.install b/debian/ibacm.install
new file mode 100644
index 000000000000..2bb9591c051d
--- /dev/null
+++ b/debian/ibacm.install
@@ -0,0 +1,10 @@
+etc/init.d/ibacm
+usr/bin/ib_acme
+usr/sbin/ibacm
+usr/include/infiniband/acm.h
+usr/include/infiniband/acm_prov.h
+usr/lib/x86_64-linux-gnu/ibacm/libibacmp.so
+usr/share/man/man1/ib_acme.1
+usr/share/man/man1/ibacm.1
+usr/share/man/man7/ibacm.7
+usr/share/man/man7/ibacm_prov.7
diff --git a/debian/ibverbs-providers.install b/debian/ibverbs-providers.install
new file mode 100644
index 000000000000..1b4121874b2c
--- /dev/null
+++ b/debian/ibverbs-providers.install
@@ -0,0 +1,7 @@
+usr/lib/*/libibverbs/lib*-rdmav2.so
+etc/libibverbs.d/
+etc/modprobe.d/truescale.conf
+usr/lib/truescale-serdes.cmds
+usr/share/man/man8/rxe_cfg.8
+usr/share/man/man7/rxe.7
+usr/bin/rxe_cfg
diff --git a/debian/ibverbs-utils.install b/debian/ibverbs-utils.install
new file mode 100644
index 000000000000..170b8d268437
--- /dev/null
+++ b/debian/ibverbs-utils.install
@@ -0,0 +1,16 @@
+usr/bin/ibv_asyncwatch
+usr/bin/ibv_devices
+usr/bin/ibv_devinfo
+usr/bin/ibv_rc_pingpong
+usr/bin/ibv_srq_pingpong
+usr/bin/ibv_uc_pingpong
+usr/bin/ibv_ud_pingpong
+usr/bin/ibv_xsrq_pingpong
+usr/share/man/man1/ibv_asyncwatch.1
+usr/share/man/man1/ibv_devices.1
+usr/share/man/man1/ibv_devinfo.1
+usr/share/man/man1/ibv_rc_pingpong.1
+usr/share/man/man1/ibv_srq_pingpong.1
+usr/share/man/man1/ibv_uc_pingpong.1
+usr/share/man/man1/ibv_ud_pingpong.1
+usr/share/man/man1/ibv_xsrq_pingpong.1
diff --git a/debian/iwpmd.install b/debian/iwpmd.install
new file mode 100644
index 000000000000..c80b1c9c4857
--- /dev/null
+++ b/debian/iwpmd.install
@@ -0,0 +1,7 @@
+etc/init.d/ibacm
+etc/init.d/iwpmd
+etc/iwpmd.conf
+lib/systemd/system/iwpmd.service
+usr/bin/iwpmd
+usr/share/man/man1/iwpmd.1
+usr/share/man/man5/iwpmd.conf.5
diff --git a/debian/libibcm-dev.install b/debian/libibcm-dev.install
new file mode 100644
index 000000000000..ee1bd14cf57f
--- /dev/null
+++ b/debian/libibcm-dev.install
@@ -0,0 +1,3 @@
+usr/lib/*/libibcm*.so
+usr/include/infiniband/cm.h
+usr/include/infiniband/cm_abi.h
diff --git a/debian/libibcm1.install b/debian/libibcm1.install
new file mode 100644
index 000000000000..6f270b7f3bfa
--- /dev/null
+++ b/debian/libibcm1.install
@@ -0,0 +1 @@
+usr/lib/*/libibcm*.so.*
diff --git a/debian/libibcm1.symbols b/debian/libibcm1.symbols
new file mode 100644
index 000000000000..1ce04b06096c
--- /dev/null
+++ b/debian/libibcm1.symbols
@@ -0,0 +1,23 @@
+libibcm.so.1 libibcm1 #MINVER#
+ IBCM_1.0@IBCM_1.0 1.0.11
+ ib_cm_ack_event@IBCM_1.0 1.0.11
+ ib_cm_attr_id@IBCM_1.0 1.0.11
+ ib_cm_close_device@IBCM_1.0 1.0.11
+ ib_cm_create_id@IBCM_1.0 1.0.11
+ ib_cm_destroy_id@IBCM_1.0 1.0.11
+ ib_cm_get_event@IBCM_1.0 1.0.11
+ ib_cm_init_qp_attr@IBCM_1.0 1.0.11
+ ib_cm_listen@IBCM_1.0 1.0.11
+ ib_cm_notify@IBCM_1.0 1.0.11
+ ib_cm_open_device@IBCM_1.0 1.0.11
+ ib_cm_send_apr@IBCM_1.0 1.0.11
+ ib_cm_send_drep@IBCM_1.0 1.0.11
+ ib_cm_send_dreq@IBCM_1.0 1.0.11
+ ib_cm_send_lap@IBCM_1.0 1.0.11
+ ib_cm_send_mra@IBCM_1.0 1.0.11
+ ib_cm_send_rej@IBCM_1.0 1.0.11
+ ib_cm_send_rep@IBCM_1.0 1.0.11
+ ib_cm_send_req@IBCM_1.0 1.0.11
+ ib_cm_send_rtu@IBCM_1.0 1.0.11
+ ib_cm_send_sidr_rep@IBCM_1.0 1.0.11
+ ib_cm_send_sidr_req@IBCM_1.0 1.0.11
diff --git a/debian/libibumad-dev.install b/debian/libibumad-dev.install
new file mode 100644
index 000000000000..a05a65c993ee
--- /dev/null
+++ b/debian/libibumad-dev.install
@@ -0,0 +1,3 @@
+usr/lib/*/libibumad*.so
+usr/include/infiniband/umad*.h
+usr/share/man/man3/umad_*
diff --git a/debian/libibumad3.install b/debian/libibumad3.install
new file mode 100644
index 000000000000..94f2e44d38ac
--- /dev/null
+++ b/debian/libibumad3.install
@@ -0,0 +1,2 @@
+usr/lib/*/libibumad*.so.*
+
diff --git a/debian/libibumad3.symbols b/debian/libibumad3.symbols
new file mode 100644
index 000000000000..267ded36857f
--- /dev/null
+++ b/debian/libibumad3.symbols
@@ -0,0 +1,38 @@
+libibumad.so.3 libibumad3 #MINVER#
+ IBUMAD_1.0@IBUMAD_1.0 1.3.9
+ umad_addr_dump@IBUMAD_1.0 1.3.9
+ umad_attribute_str@IBUMAD_1.0 1.3.10.2
+ umad_class_str@IBUMAD_1.0 1.3.10.2
+ umad_close_port@IBUMAD_1.0 1.3.9
+ umad_common_mad_status_str@IBUMAD_1.0 1.3.10.2
+ umad_debug@IBUMAD_1.0 1.3.9
+ umad_done@IBUMAD_1.0 1.3.9
+ umad_dump@IBUMAD_1.0 1.3.9
+ umad_get_ca@IBUMAD_1.0 1.3.9
+ umad_get_ca_portguids@IBUMAD_1.0 1.3.9
+ umad_get_cas_names@IBUMAD_1.0 1.3.9
+ umad_get_fd@IBUMAD_1.0 1.3.9
+ umad_get_issm_path@IBUMAD_1.0 1.3.9
+ umad_get_mad@IBUMAD_1.0 1.3.9
+ umad_get_mad_addr@IBUMAD_1.0 1.3.9
+ umad_get_pkey@IBUMAD_1.0 1.3.9
+ umad_get_port@IBUMAD_1.0 1.3.9
+ umad_init@IBUMAD_1.0 1.3.9
+ umad_method_str@IBUMAD_1.0 1.3.10.2
+ umad_open_port@IBUMAD_1.0 1.3.9
+ umad_poll@IBUMAD_1.0 1.3.9
+ umad_recv@IBUMAD_1.0 1.3.9
+ umad_register2@IBUMAD_1.0 1.3.10.2
+ umad_register@IBUMAD_1.0 1.3.9
+ umad_register_oui@IBUMAD_1.0 1.3.9
+ umad_release_ca@IBUMAD_1.0 1.3.9
+ umad_release_port@IBUMAD_1.0 1.3.9
+ umad_sa_mad_status_str@IBUMAD_1.0 1.3.10.2
+ umad_send@IBUMAD_1.0 1.3.9
+ umad_set_addr@IBUMAD_1.0 1.3.9
+ umad_set_addr_net@IBUMAD_1.0 1.3.9
+ umad_set_grh@IBUMAD_1.0 1.3.9
+ umad_set_pkey@IBUMAD_1.0 1.3.9
+ umad_size@IBUMAD_1.0 1.3.9
+ umad_status@IBUMAD_1.0 1.3.9
+ umad_unregister@IBUMAD_1.0 1.3.9
diff --git a/debian/libibverbs-dev.install b/debian/libibverbs-dev.install
new file mode 100644
index 000000000000..2dbac6fe5887
--- /dev/null
+++ b/debian/libibverbs-dev.install
@@ -0,0 +1,12 @@
+usr/lib/*/libibverbs*.so
+usr/share/man/man3/ibv_*
+usr/include/infiniband/arch.h
+usr/include/infiniband/driver.h
+usr/include/infiniband/kern-abi.h
+usr/include/infiniband/marshall.h
+usr/include/infiniband/opcode.h
+usr/include/infiniband/sa.h
+usr/include/infiniband/sa-kern-abi.h
+usr/include/infiniband/verbs.h
+usr/share/man/man3/mbps_to_ibv_rate.3
+usr/share/man/man3/mult_to_ibv_rate.3
diff --git a/debian/libibverbs1.install b/debian/libibverbs1.install
new file mode 100644
index 000000000000..78a7f76d39c3
--- /dev/null
+++ b/debian/libibverbs1.install
@@ -0,0 +1 @@
+usr/lib/*/libibverbs*.so.*
diff --git a/debian/libibverbs1.postinst b/debian/libibverbs1.postinst
new file mode 100644
index 000000000000..784458a6e0b5
--- /dev/null
+++ b/debian/libibverbs1.postinst
@@ -0,0 +1,10 @@
+#!/bin/sh
+# postinst script for libibverbs1
+
+set -e
+
+if [ "$1" = configure ]; then
+    getent group rdma > /dev/null 2>&1 || addgroup --system --quiet rdma
+fi
+
+#DEBHELPER#
diff --git a/debian/libibverbs1.symbols b/debian/libibverbs1.symbols
new file mode 100644
index 000000000000..b9c12f6b87ee
--- /dev/null
+++ b/debian/libibverbs1.symbols
@@ -0,0 +1,134 @@
+libibverbs.so.1 libibverbs1 #MINVER#
+ IBVERBS_1.0@IBVERBS_1.0 1.1.6
+ IBVERBS_1.1@IBVERBS_1.1 1.1.6
+ ibv_ack_async_event@IBVERBS_1.0 1.1.6
+ ibv_ack_async_event@IBVERBS_1.1 1.1.6
+ ibv_ack_cq_events@IBVERBS_1.0 1.1.6
+ ibv_ack_cq_events@IBVERBS_1.1 1.1.6
+ ibv_alloc_pd@IBVERBS_1.0 1.1.6
+ ibv_alloc_pd@IBVERBS_1.1 1.1.6
+ ibv_attach_mcast@IBVERBS_1.0 1.1.6
+ ibv_attach_mcast@IBVERBS_1.1 1.1.6
+ ibv_close_device@IBVERBS_1.0 1.1.6
+ ibv_close_device@IBVERBS_1.1 1.1.6
+ ibv_cmd_alloc_mw@IBVERBS_1.1 1.2.1
+ ibv_cmd_alloc_pd@IBVERBS_1.0 1.1.6
+ ibv_cmd_attach_mcast@IBVERBS_1.0 1.1.6
+ ibv_cmd_close_xrcd@IBVERBS_1.1 1.1.8
+ ibv_cmd_create_ah@IBVERBS_1.0 1.1.6
+ ibv_cmd_create_cq@IBVERBS_1.0 1.1.6
+ ibv_cmd_create_cq_ex@IBVERBS_1.0 1.2.1
+ ibv_cmd_create_flow@IBVERBS_1.0 1.1.8
+ ibv_cmd_create_qp@IBVERBS_1.0 1.1.6
+ ibv_cmd_create_qp_ex2@IBVERBS_1.1 1.2.1
+ ibv_cmd_create_qp_ex@IBVERBS_1.1 1.1.8
+ ibv_cmd_create_srq@IBVERBS_1.0 1.1.6
+ ibv_cmd_create_srq_ex@IBVERBS_1.1 1.1.8
+ ibv_cmd_dealloc_mw@IBVERBS_1.1 1.2.1
+ ibv_cmd_dealloc_pd@IBVERBS_1.0 1.1.6
+ ibv_cmd_dereg_mr@IBVERBS_1.0 1.1.6
+ ibv_cmd_destroy_ah@IBVERBS_1.0 1.1.6
+ ibv_cmd_destroy_cq@IBVERBS_1.0 1.1.6
+ ibv_cmd_destroy_flow@IBVERBS_1.0 1.1.8
+ ibv_cmd_destroy_qp@IBVERBS_1.0 1.1.6
+ ibv_cmd_destroy_srq@IBVERBS_1.0 1.1.6
+ ibv_cmd_detach_mcast@IBVERBS_1.0 1.1.6
+ ibv_cmd_get_context@IBVERBS_1.0 1.1.6
+ ibv_cmd_modify_qp@IBVERBS_1.0 1.1.6
+ ibv_cmd_modify_srq@IBVERBS_1.0 1.1.6
+ ibv_cmd_open_qp@IBVERBS_1.1 1.1.8
+ ibv_cmd_open_xrcd@IBVERBS_1.1 1.1.8
+ ibv_cmd_poll_cq@IBVERBS_1.0 1.1.6
+ ibv_cmd_post_recv@IBVERBS_1.0 1.1.6
+ ibv_cmd_post_send@IBVERBS_1.0 1.1.6
+ ibv_cmd_post_srq_recv@IBVERBS_1.0 1.1.6
+ ibv_cmd_query_device@IBVERBS_1.0 1.1.6
+ ibv_cmd_query_device_ex@IBVERBS_1.0 1.2.0
+ ibv_cmd_query_port@IBVERBS_1.0 1.1.6
+ ibv_cmd_query_qp@IBVERBS_1.0 1.1.6
+ ibv_cmd_query_srq@IBVERBS_1.0 1.1.6
+ ibv_cmd_reg_mr@IBVERBS_1.0 1.1.6
+ ibv_cmd_req_notify_cq@IBVERBS_1.0 1.1.6
+ ibv_cmd_rereg_mr@IBVERBS_1.1 1.2.1
+ ibv_cmd_resize_cq@IBVERBS_1.0 1.1.6
+ ibv_copy_ah_attr_from_kern@IBVERBS_1.1 1.1.6
+ ibv_copy_path_rec_from_kern@IBVERBS_1.0 1.1.6
+ ibv_copy_path_rec_to_kern@IBVERBS_1.0 1.1.6
+ ibv_copy_qp_attr_from_kern@IBVERBS_1.0 1.1.6
+ ibv_create_ah@IBVERBS_1.0 1.1.6
+ ibv_create_ah@IBVERBS_1.1 1.1.6
+ ibv_create_ah_from_wc@IBVERBS_1.1 1.1.6
+ ibv_create_comp_channel@IBVERBS_1.0 1.1.6
+ ibv_create_cq@IBVERBS_1.0 1.1.6
+ ibv_create_cq@IBVERBS_1.1 1.1.6
+ ibv_create_qp@IBVERBS_1.0 1.1.6
+ ibv_create_qp@IBVERBS_1.1 1.1.6
+ ibv_create_srq@IBVERBS_1.0 1.1.6
+ ibv_create_srq@IBVERBS_1.1 1.1.6
+ ibv_dealloc_pd@IBVERBS_1.0 1.1.6
+ ibv_dealloc_pd@IBVERBS_1.1 1.1.6
+ ibv_dereg_mr@IBVERBS_1.0 1.1.6
+ ibv_dereg_mr@IBVERBS_1.1 1.1.6
+ ibv_destroy_ah@IBVERBS_1.0 1.1.6
+ ibv_destroy_ah@IBVERBS_1.1 1.1.6
+ ibv_destroy_comp_channel@IBVERBS_1.0 1.1.6
+ ibv_destroy_cq@IBVERBS_1.0 1.1.6
+ ibv_destroy_cq@IBVERBS_1.1 1.1.6
+ ibv_destroy_qp@IBVERBS_1.0 1.1.6
+ ibv_destroy_qp@IBVERBS_1.1 1.1.6
+ ibv_destroy_srq@IBVERBS_1.0 1.1.6
+ ibv_destroy_srq@IBVERBS_1.1 1.1.6
+ ibv_detach_mcast@IBVERBS_1.0 1.1.6
+ ibv_detach_mcast@IBVERBS_1.1 1.1.6
+ ibv_dofork_range@IBVERBS_1.1 1.1.6
+ ibv_dontfork_range@IBVERBS_1.1 1.1.6
+ ibv_event_type_str@IBVERBS_1.1 1.1.6
+ ibv_fork_init@IBVERBS_1.1 1.1.6
+ ibv_free_device_list@IBVERBS_1.0 1.1.6
+ ibv_free_device_list@IBVERBS_1.1 1.1.6
+ ibv_get_async_event@IBVERBS_1.0 1.1.6
+ ibv_get_async_event@IBVERBS_1.1 1.1.6
+ ibv_get_cq_event@IBVERBS_1.0 1.1.6
+ ibv_get_cq_event@IBVERBS_1.1 1.1.6
+ ibv_get_device_guid@IBVERBS_1.0 1.1.6
+ ibv_get_device_guid@IBVERBS_1.1 1.1.6
+ ibv_get_device_list@IBVERBS_1.0 1.1.6
+ ibv_get_device_list@IBVERBS_1.1 1.1.6
+ ibv_get_device_name@IBVERBS_1.0 1.1.6
+ ibv_get_device_name@IBVERBS_1.1 1.1.6
+ ibv_get_sysfs_path@IBVERBS_1.0 1.1.6
+ ibv_init_ah_from_wc@IBVERBS_1.1 1.1.6
+ ibv_modify_qp@IBVERBS_1.0 1.1.6
+ ibv_modify_qp@IBVERBS_1.1 1.1.6
+ ibv_modify_srq@IBVERBS_1.0 1.1.6
+ ibv_modify_srq@IBVERBS_1.1 1.1.6
+ ibv_node_type_str@IBVERBS_1.1 1.1.6
+ ibv_open_device@IBVERBS_1.0 1.1.6
+ ibv_open_device@IBVERBS_1.1 1.1.6
+ ibv_port_state_str@IBVERBS_1.1 1.1.6
+ ibv_query_device@IBVERBS_1.0 1.1.6
+ ibv_query_device@IBVERBS_1.1 1.1.6
+ ibv_query_gid@IBVERBS_1.0 1.1.6
+ ibv_query_gid@IBVERBS_1.1 1.1.6
+ ibv_query_pkey@IBVERBS_1.0 1.1.6
+ ibv_query_pkey@IBVERBS_1.1 1.1.6
+ ibv_query_port@IBVERBS_1.0 1.1.6
+ ibv_query_port@IBVERBS_1.1 1.1.6
+ ibv_query_qp@IBVERBS_1.0 1.1.6
+ ibv_query_qp@IBVERBS_1.1 1.1.6
+ ibv_query_srq@IBVERBS_1.0 1.1.6
+ ibv_query_srq@IBVERBS_1.1 1.1.6
+ ibv_rate_to_mbps@IBVERBS_1.1 1.1.8
+ ibv_rate_to_mult@IBVERBS_1.0 1.1.6
+ ibv_read_sysfs_file@IBVERBS_1.0 1.1.6
+ ibv_reg_mr@IBVERBS_1.0 1.1.6
+ ibv_reg_mr@IBVERBS_1.1 1.1.6
+ ibv_register_driver@IBVERBS_1.1 1.1.6
+ ibv_rereg_mr@IBVERBS_1.1 1.2.1
+ ibv_resize_cq@IBVERBS_1.0 1.1.6
+ ibv_resize_cq@IBVERBS_1.1 1.1.6
+ ibv_resolve_eth_l2_from_gid@IBVERBS_1.1 1.2.0
+ ibv_wc_status_str@IBVERBS_1.1 1.1.6
+ mbps_to_ibv_rate@IBVERBS_1.1 1.1.8
+ mult_to_ibv_rate@IBVERBS_1.0 1.1.6
+ verbs_register_driver@IBVERBS_1.1 1.1.8
diff --git a/debian/librdmacm-dev.install b/debian/librdmacm-dev.install
new file mode 100644
index 000000000000..d42d1da5f652
--- /dev/null
+++ b/debian/librdmacm-dev.install
@@ -0,0 +1,57 @@
+usr/lib/*/librdmacm*.so
+usr/include/rdma/rdma_cma.h
+usr/include/rdma/rdma_cma_abi.h
+usr/include/rdma/rdma_verbs.h
+usr/include/rdma/rsocket.h
+usr/include/infiniband/ib.h
+usr/share/man/man3/rdma_accept.3
+usr/share/man/man3/rdma_ack_cm_event.3
+usr/share/man/man3/rdma_bind_addr.3
+usr/share/man/man3/rdma_connect.3
+usr/share/man/man3/rdma_create_ep.3
+usr/share/man/man3/rdma_create_event_channel.3
+usr/share/man/man3/rdma_create_id.3
+usr/share/man/man3/rdma_create_qp.3
+usr/share/man/man3/rdma_create_srq.3
+usr/share/man/man3/rdma_dereg_mr.3
+usr/share/man/man3/rdma_destroy_ep.3
+usr/share/man/man3/rdma_destroy_event_channel.3
+usr/share/man/man3/rdma_destroy_id.3
+usr/share/man/man3/rdma_destroy_qp.3
+usr/share/man/man3/rdma_destroy_srq.3
+usr/share/man/man3/rdma_disconnect.3
+usr/share/man/man3/rdma_event_str.3
+usr/share/man/man3/rdma_free_devices.3
+usr/share/man/man3/rdma_get_cm_event.3
+usr/share/man/man3/rdma_get_devices.3
+usr/share/man/man3/rdma_get_dst_port.3
+usr/share/man/man3/rdma_get_local_addr.3
+usr/share/man/man3/rdma_get_peer_addr.3
+usr/share/man/man3/rdma_get_recv_comp.3
+usr/share/man/man3/rdma_get_request.3
+usr/share/man/man3/rdma_get_send_comp.3
+usr/share/man/man3/rdma_get_src_port.3
+usr/share/man/man3/rdma_getaddrinfo.3
+usr/share/man/man3/rdma_join_multicast.3
+usr/share/man/man3/rdma_leave_multicast.3
+usr/share/man/man3/rdma_listen.3
+usr/share/man/man3/rdma_migrate_id.3
+usr/share/man/man3/rdma_notify.3
+usr/share/man/man3/rdma_post_read.3
+usr/share/man/man3/rdma_post_readv.3
+usr/share/man/man3/rdma_post_recv.3
+usr/share/man/man3/rdma_post_recvv.3
+usr/share/man/man3/rdma_post_send.3
+usr/share/man/man3/rdma_post_sendv.3
+usr/share/man/man3/rdma_post_ud_send.3
+usr/share/man/man3/rdma_post_write.3
+usr/share/man/man3/rdma_post_writev.3
+usr/share/man/man3/rdma_reg_msgs.3
+usr/share/man/man3/rdma_reg_read.3
+usr/share/man/man3/rdma_reg_write.3
+usr/share/man/man3/rdma_reject.3
+usr/share/man/man3/rdma_resolve_addr.3
+usr/share/man/man3/rdma_resolve_route.3
+usr/share/man/man3/rdma_set_option.3
+usr/share/man/man7/rdma_cm.7
+usr/share/man/man7/rsocket.7
diff --git a/debian/librdmacm1.install b/debian/librdmacm1.install
new file mode 100644
index 000000000000..c17048e6e463
--- /dev/null
+++ b/debian/librdmacm1.install
@@ -0,0 +1,2 @@
+usr/lib/*/librdmacm*.so.*
+usr/lib/*/rsocket/librspreload*.so*
diff --git a/debian/librdmacm1.symbols b/debian/librdmacm1.symbols
new file mode 100644
index 000000000000..7cec5c6b1746
--- /dev/null
+++ b/debian/librdmacm1.symbols
@@ -0,0 +1,64 @@
+librdmacm.so.1 librdmacm1 #MINVER#
+ RDMACM_1.0@RDMACM_1.0 1.0.15
+ raccept@RDMACM_1.0 1.0.16
+ rbind@RDMACM_1.0 1.0.16
+ rclose@RDMACM_1.0 1.0.16
+ rconnect@RDMACM_1.0 1.0.16
+ rdma_accept@RDMACM_1.0 1.0.15
+ rdma_ack_cm_event@RDMACM_1.0 1.0.15
+ rdma_bind_addr@RDMACM_1.0 1.0.15
+ rdma_connect@RDMACM_1.0 1.0.15
+ rdma_create_ep@RDMACM_1.0 1.0.15
+ rdma_create_event_channel@RDMACM_1.0 1.0.15
+ rdma_create_id@RDMACM_1.0 1.0.15
+ rdma_create_qp@RDMACM_1.0 1.0.15
+ rdma_create_qp_ex@RDMACM_1.0 1.0.19
+ rdma_create_srq@RDMACM_1.0 1.0.15
+ rdma_create_srq_ex@RDMACM_1.0 1.0.19
+ rdma_destroy_ep@RDMACM_1.0 1.0.15
+ rdma_destroy_event_channel@RDMACM_1.0 1.0.15
+ rdma_destroy_id@RDMACM_1.0 1.0.15
+ rdma_destroy_qp@RDMACM_1.0 1.0.15
+ rdma_destroy_srq@RDMACM_1.0 1.0.15
+ rdma_disconnect@RDMACM_1.0 1.0.15
+ rdma_event_str@RDMACM_1.0 1.0.15
+ rdma_free_devices@RDMACM_1.0 1.0.15
+ rdma_freeaddrinfo@RDMACM_1.0 1.0.15
+ rdma_get_cm_event@RDMACM_1.0 1.0.15
+ rdma_get_devices@RDMACM_1.0 1.0.15
+ rdma_get_dst_port@RDMACM_1.0 1.0.19
+ rdma_get_request@RDMACM_1.0 1.0.15
+ rdma_get_src_port@RDMACM_1.0 1.0.19
+ rdma_getaddrinfo@RDMACM_1.0 1.0.15
+ rdma_join_multicast@RDMACM_1.0 1.0.15
+ rdma_leave_multicast@RDMACM_1.0 1.0.15
+ rdma_listen@RDMACM_1.0 1.0.15
+ rdma_migrate_id@RDMACM_1.0 1.0.15
+ rdma_notify@RDMACM_1.0 1.0.15
+ rdma_reject@RDMACM_1.0 1.0.15
+ rdma_resolve_addr@RDMACM_1.0 1.0.15
+ rdma_resolve_route@RDMACM_1.0 1.0.15
+ rdma_set_option@RDMACM_1.0 1.0.15
+ rfcntl@RDMACM_1.0 1.0.16
+ rgetpeername@RDMACM_1.0 1.0.16
+ rgetsockname@RDMACM_1.0 1.0.16
+ rgetsockopt@RDMACM_1.0 1.0.16
+ riomap@RDMACM_1.0 1.0.19
+ riounmap@RDMACM_1.0 1.0.19
+ riowrite@RDMACM_1.0 1.0.19
+ rlisten@RDMACM_1.0 1.0.16
+ rpoll@RDMACM_1.0 1.0.16
+ rread@RDMACM_1.0 1.0.16
+ rreadv@RDMACM_1.0 1.0.16
+ rrecv@RDMACM_1.0 1.0.16
+ rrecvfrom@RDMACM_1.0 1.0.16
+ rrecvmsg@RDMACM_1.0 1.0.16
+ rselect@RDMACM_1.0 1.0.16
+ rsend@RDMACM_1.0 1.0.16
+ rsendmsg@RDMACM_1.0 1.0.16
+ rsendto@RDMACM_1.0 1.0.16
+ rsetsockopt@RDMACM_1.0 1.0.16
+ rshutdown@RDMACM_1.0 1.0.16
+ rsocket@RDMACM_1.0 1.0.16
+ rwrite@RDMACM_1.0 1.0.16
+ rwritev@RDMACM_1.0 1.0.16
diff --git a/debian/rdmacm-utils.install b/debian/rdmacm-utils.install
new file mode 100644
index 000000000000..49e63a255b85
--- /dev/null
+++ b/debian/rdmacm-utils.install
@@ -0,0 +1,24 @@
+usr/bin/cmtime
+usr/bin/mckey
+usr/bin/rcopy
+usr/bin/rdma_client
+usr/bin/rdma_server
+usr/bin/rdma_xclient
+usr/bin/rdma_xserver
+usr/bin/riostream
+usr/bin/rping
+usr/bin/rstream
+usr/bin/ucmatose
+usr/bin/udaddy
+usr/bin/udpong
+usr/share/man/man1/mckey.1
+usr/share/man/man1/rcopy.1
+usr/share/man/man1/rdma_client.1
+usr/share/man/man1/rdma_server.1
+usr/share/man/man1/rdma_xclient.1
+usr/share/man/man1/rdma_xserver.1
+usr/share/man/man1/riostream.1
+usr/share/man/man1/rping.1
+usr/share/man/man1/rstream.1
+usr/share/man/man1/ucmatose.1
+usr/share/man/man1/udaddy.1
diff --git a/debian/rules b/debian/rules
new file mode 100755
index 000000000000..e6ec8c824f8a
--- /dev/null
+++ b/debian/rules
@@ -0,0 +1,99 @@
+#!/usr/bin/make -f
+
+
+DH_OPTS := --builddirectory=build-deb
+our_version = $(shell dpkg-parsechangelog -S version)
+debian_version = -$(lastword $(subst -, ,$(our_version)))
+
+# For aesthetic reasons we want to use the shared libary ABI version as the
+# Debian package version, not the overall source package version. See
+# Documentation/versioning.md
+get_lib_version = $(patsubst build-deb/lib/$(1).so.%,%,$(wildcard build-deb/lib/$(1).so.*.*))
+libibcm_version = $(call get_lib_version,libibcm)
+libibumad_version = $(call get_lib_version,libibumad)
+libibverbs_version = $(call get_lib_version,libibverbs)
+librdmacm_version = $(call get_lib_version,librdmacm)
+
+# Upstream wishes to use CMAKE_BUILD_TYPE=Release, and ensures that has a
+# sensible basis of options (eg no -O3, including -g). Debian specific options
+# come from CFLAGS as usual.
+
+# Upstream encourages the use of Ninja to build the source, convince dh to use
+# it until someone writes native support for dh+cmake+ninja.
+override_dh_auto_configure:
+	dh_auto_configure $(DH_OPTS) -- -GNinja \
+			-DDISTRO_FLAVOUR=Debian \
+			-DCMAKE_BUILD_TYPE=Release \
+			-DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc \
+			-DCMAKE_INSTALL_SYSTEMD_SERVICEDIR:PATH=/lib/systemd/system \
+			-DCMAKE_INSTALL_INITDDIR:PATH=/etc/init.d \
+			-DCMAKE_INSTALL_LIBEXECDIR:PATH=/usr/lib
+	cp buildlib/ninja-wrapper build-deb/Makefile
+
+# The following files are not used on Debian
+# FIXME: should they be?
+INST_EXCLUDE := "etc/rsyslog.d/srp_daemon.conf" \
+		"usr/sbin/run_srp_daemon" \
+		"usr/sbin/srp_daemon.sh"
+INST_EXCLUDE := $(addprefix -X,$(INST_EXCLUDE))
+override_dh_install:
+	dh_install --fail-missing $(INST_EXCLUDE)
+
+# cmake installs the correct init scripts in the correct place, just setup the
+# pre-postrms
+override_dh_installinit:
+	dh_installinit -pibacm --onlyscripts
+	dh_installinit -piwpmd --onlyscripts
+	dh_installinit -psrptools --onlyscripts
+	dh_installinit --remaining-packages
+
+# Provider plugin libaries are not shared libraries and do not belong in the
+# shlibs file.
+# librspreload is a LD_PRELOAD library and does not belong in the shlib files
+SHLIBS_EXCLUDE = "/libibverbs/" "librspreload"
+SHLIBS_EXCLUDE := $(addprefix --exclude=,$(SHLIBS_EXCLUDE))
+override_dh_makeshlibs:
+	dh_makeshlibs -plibibcm1 $(SHLIBS_EXCLUDE) -- -v$(libibcm_version)$(debian_version)
+	dh_makeshlibs -plibibverbs1 $(SHLIBS_EXCLUDE) -- -v$(libibverbs_version)$(debian_version)
+	dh_makeshlibs -plibrdmacm1 $(SHLIBS_EXCLUDE) -- -v$(librdmacm_version)$(debian_version)
+	dh_makeshlibs -plibibumad3 $(SHLIBS_EXCLUDE) -- -v$(libibumad_version)$(debian_version)
+
+	dh_makeshlibs --remaining-packages $(SHLIBS_EXCLUDE)
+
+# Inject the version numbers that are different from the source version
+override_dh_gencontrol:
+	dh_gencontrol -plibibcm1 -- -v$(libibcm_version)$(debian_version)
+	dh_gencontrol -plibibumad3 -- -v$(libibumad_version)$(debian_version)
+	dh_gencontrol -plibibverbs1 -- -v$(libibverbs_version)$(debian_version)
+	dh_gencontrol -plibrdmacm1 -- -v$(librdmacm_version)$(debian_version)
+
+	dh_gencontrol -plibibcm1-dbg -- -v$(libibcm_version)$(debian_version)
+	dh_gencontrol -plibibumad3-dbg -- -v$(libibumad_version)$(debian_version)
+	dh_gencontrol -plibibverbs1-dbg -- -v$(libibverbs_version)$(debian_version)
+	dh_gencontrol -plibrdmacm1-dbg -- -v$(librdmacm_version)$(debian_version)
+
+	dh_gencontrol -plibibcm-dev -- -v$(libibcm_version)$(debian_version)
+	dh_gencontrol -plibibumad-dev -- -v$(libibumad_version)$(debian_version)
+	dh_gencontrol -plibibverbs-dev -- -v$(libibverbs_version)$(debian_version)
+	dh_gencontrol -plibrdmacm-dev -- -v$(librdmacm_version)$(debian_version)
+
+	dh_gencontrol --remaining-packages
+
+# Create dbg packages.
+# FIXME: should we just have a rdma-core-dbg package ?
+override_dh_strip:
+	dh_strip -plibibcm1 --dbg-package=libibcm1-dbg
+	dh_strip -plibibumad3 --dbg-package=libibumad3-dbg
+	dh_strip -plibibverbs1 --dbg-package=libibverbs1-dbg
+	dh_strip -plibrdmacm1 --dbg-package=librdmacm1-dbg
+
+	dh_strip --remaining-packages
+
+# Upstream encourages the use of 'build' as the developer build output
+# directory, allow that directory to be present and still allow dh to work.
+.PHONY: build
+build:
+	dh $@ --with systemd $(DH_OPTS)
+
+%:
+	dh $@ --with systemd $(DH_OPTS)
diff --git a/debian/srptools.install b/debian/srptools.install
new file mode 100644
index 000000000000..17b909d721a9
--- /dev/null
+++ b/debian/srptools.install
@@ -0,0 +1,8 @@
+etc/default/srptools
+etc/init.d/srptools
+etc/logrotate.d/srp_daemon
+etc/srp_daemon.conf
+usr/sbin/ibsrpdm
+usr/sbin/srp_daemon
+usr/share/man/man1/ibsrpdm.1
+usr/share/man/man1/srp_daemon.1
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
