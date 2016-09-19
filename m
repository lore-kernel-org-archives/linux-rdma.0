From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 3/9] remove README files in the provider directories
Date: Mon, 19 Sep 2016 08:56:27 -0700
Message-ID: <1474300593-31922-4-git-send-email-hch@lst.de>
References: <1474300593-31922-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474300593-31922-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These were all almost the same and add no real value over the top-level
README.md file.  The only lost information is the exact names of supported
cards for some providers, but that already is information duplicated from
the kernel drivers and bound to get out of sync anyway.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/cxgb3/README      | 19 ---------------
 providers/cxgb4/README      | 19 ---------------
 providers/hfi1verbs/README  | 23 ------------------
 providers/ipathverbs/README | 24 ------------------
 providers/mlx4/README       | 58 --------------------------------------------
 providers/mlx5/README       | 14 -----------
 providers/mthca/README      | 59 ---------------------------------------------
 providers/ocrdma/README     | 19 ---------------
 8 files changed, 235 deletions(-)
 delete mode 100644 providers/cxgb3/README
 delete mode 100644 providers/cxgb4/README
 delete mode 100644 providers/hfi1verbs/README
 delete mode 100644 providers/ipathverbs/README
 delete mode 100644 providers/mlx4/README
 delete mode 100644 providers/mlx5/README
 delete mode 100644 providers/mthca/README
 delete mode 100644 providers/ocrdma/README

diff --git a/providers/cxgb3/README b/providers/cxgb3/README
deleted file mode 100644
index 9d0dd49..0000000
--- a/providers/cxgb3/README
+++ /dev/null
@@ -1,19 +0,0 @@
-Introduction
-============
-
-libcxgb3 is a userspace driver for the Chelsio T3 iWARP RNIC.  It works
-as a plug-in module for libibverbs that allows programs to use Chelsio
-RNICs directly from userspace.  See the libibverbs package for more
-information.
-
-Using libcxgb3
-===================
-
-libcxgb3 will be loaded and used automatically by programs linked with
-libibverbs.  The iw_cxgb3 kernel module must be loaded for Chelsio RNIC
-devices to be detected and used.
-
-Supported Hardware
-==================
-
-libcxgb3 supports the Chelsio T3 family of adapters.
diff --git a/providers/cxgb4/README b/providers/cxgb4/README
deleted file mode 100644
index a4ee33a..0000000
--- a/providers/cxgb4/README
+++ /dev/null
@@ -1,19 +0,0 @@
-Introduction
-============
-
-libcxgb4 is a userspace driver for the Chelsio T4/T5 iWARP RNICs.  It works
-as a plug-in module for libibverbs that allows programs to use Chelsio
-RNICs directly from userspace.  See the libibverbs package for more
-information.
-
-Using libcxgb4
-===================
-
-libcxgb4 will be loaded and used automatically by programs linked with
-libibverbs.  The iw_cxgb4 kernel module must be loaded for Chelsio RNIC
-devices to be detected and used.
-
-Supported Hardware
-==================
-
-libcxgb4 supports the Chelsio T4/T5 family of adapters.
diff --git a/providers/hfi1verbs/README b/providers/hfi1verbs/README
deleted file mode 100644
index 9b6f812..0000000
--- a/providers/hfi1verbs/README
+++ /dev/null
@@ -1,23 +0,0 @@
-Introduction
-============
-
-libhfiverbs is a userspace driver for the Intel Host Fabric
-interface.
-
-It works as a plug-in module for libibverbs that allows programs to use
-Intel HFI's directly from userspace.  See the libibverbs package for
-more information.
-
-Using libhfiverbs
-===================
-
-libhfiverbs will be loaded and used automatically by programs linked
-with libibverbs.  The hfi kernel module must be loaded for Intel
-fabric devices to be detected and used.
-
-Supported Hardware
-==================
-
-libhfiverbs currently supports the following Intel Host fabric
-interfaces:
-	TBR
diff --git a/providers/ipathverbs/README b/providers/ipathverbs/README
deleted file mode 100644
index a05997f..0000000
--- a/providers/ipathverbs/README
+++ /dev/null
@@ -1,24 +0,0 @@
-Introduction
-============
-
-libipathverbs is a userspace driver for the Intel InfiniBand HCAs.
-It works as a plug-in module for libibverbs that allows programs to use
-Intel HCAs directly from userspace.  See the libibverbs package for
-more information.
-
-Using libipathverbs
-===================
-
-libipathverbs will be loaded and used automatically by programs linked
-with libibverbs.  The ib_ipath kernel module must be loaded for Intel
-HCA devices to be detected and used.
-
-Supported Hardware
-==================
-
-libipathverbs currently supports the following Intel HCAs:
-
-	InfiniPath QLE7140 PCIe Adapter
-	InfiniPath QMI7140 PCIe Adapter
-	InfiniPath QHT7040 HyperTransport Adapter
-	InfiniPath QHT7140 HyperTransport Adapter
diff --git a/providers/mlx4/README b/providers/mlx4/README
deleted file mode 100644
index 5c027ef..0000000
--- a/providers/mlx4/README
+++ /dev/null
@@ -1,58 +0,0 @@
-Introduction
-============
-
-libmlx4 is a userspace driver for Mellanox ConnectX InfiniBand HCAs.
-It is a plug-in module for libibverbs that allows programs to use
-Mellanox hardware directly from userspace.  See the libibverbs package
-for more information.
-
-Using libmlx4
-==============
-
-libmlx4 will be loaded and used automatically by programs linked with
-libibverbs.  The mlx4_ib kernel module must be loaded for HCA devices
-to be detected and used.
-
-Supported Hardware
-==================
-
-libmlx4 currently supports HCAs based on the following Mellanox chip:
-
-    MT25408 ConnectX (PCI Express)
-
-These HCAs use the mlx4_ib kernel driver.  Support for other Mellanox
-HCAs, which use the ib_mthca kernel driver, is provided by the
-libmthca userspace driver.
-
-Valgrind Support
-================
-
-When running applications that use libibverbs under the Valgrind
-memory-checking debugger, Valgrind will falsely report "read from
-uninitialized" for memory that was initialized by the kernel drivers
-or HCA hardware.  Specifically, Valgrind cannot see when kernel
-drivers or HCA hardware write to userspace memory, so when the process
-reads from that memory, Valgrind incorrectly assumes that the memory
-contents are uninitialized, and therefore raises a warning.
-
-libmlx4 can be built with specific support for the Valgrind
-memory-checking debugger by specifying the --with-valgrind command
-line argument to configure.  This flag enables code in libibverbs to
-tell Valgrind "this memory may look uninitialized, but it's really
-OK," which therefore suppresses the incorrect "read from
-uninitialized" warnings.  This code adds trivial overhead to the
-critical performance path, so it is disabled by default.  The intent
-is that production users can use a "normal" build of libmlx4 and
-developers can use the "valgrind debug" build by simply switching
-their OPENIB_DRIVER_PATH environment variables.
-
-Libmlx4 needs some header files from Valgrind in order to compile this
-support; it is important to use the header files from the same version
-of Valgrind that will be used at run time.  You may need to specify
-the directory where Valgrind's header files are installed as an
-argument to --with-valgrind.  For example
-
-	./configure --with-valgrind=/opt/valgrind
-
-will make the libmlx4 build look for valgrind headers in
-/opt/valgrind/include
diff --git a/providers/mlx5/README b/providers/mlx5/README
deleted file mode 100644
index 6c713e6..0000000
--- a/providers/mlx5/README
+++ /dev/null
@@ -1,14 +0,0 @@
-Introduction
-============
-
-libmlx5 is a userspace driver for Mellanox ConnectX InfiniBand HCAs.
-It is a plug-in module for libibverbs that allows programs to use
-Mellanox hardware directly from userspace.  See the libibverbs package
-for more information.
-
-Using libmlx5
-==============
-
-libmlx5 will be loaded and used automatically by programs linked with
-libibverbs.  The mlx5_ib kernel module must be loaded for HCA devices
-to be detected and used.
diff --git a/providers/mthca/README b/providers/mthca/README
deleted file mode 100644
index 88636f8..0000000
--- a/providers/mthca/README
+++ /dev/null
@@ -1,59 +0,0 @@
-Introduction
-============
-
-libmthca is a userspace driver for Mellanox InfiniBand HCAs.  It works
-as a plug-in module for libibverbs that allows programs to use
-Mellanox hardware directly from userspace.  See the libibverbs package
-for more information.
-
-Using libmthca
-==============
-
-libmthca will be loaded and used automatically by programs linked with
-libibverbs.  The ib_mthca kernel module must be loaded for HCA devices
-to be detected and used.
-
-Supported Hardware
-==================
-
-libmthca currently supports HCAs based on the following Mellanox chips:
-
-    MT23108 InfiniHost (PCI-X)
-    MT25208 InfiniHost III Ex (PCI Express)
-    MT25204 InfiniHost III Lx (PCI Express)
-
-Both non-DDR and DDR HCAs are supported, and the MT25208 is supported
-with both MT23108-compatible and native MemFree firmware.
-
-Valgrind Support
-================
-
-When running applications that use libibverbs under the Valgrind
-memory-checking debugger, Valgrind will falsely report "read from
-uninitialized" for memory that was initialized by the kernel drivers
-or HCA hardware.  Specifically, Valgrind cannot see when kernel
-drivers or HCA hardware write to userspace memory, so when the process
-reads from that memory, Valgrind incorrectly assumes that the memory
-contents are uninitialized, and therefore raises a warning.
-
-libmthca can be built with specific support for the Valgrind
-memory-checking debugger by specifying the --with-valgrind command
-line argument to configure.  This flag enables code in libibverbs to
-tell Valgrind "this memory may look uninitialized, but it's really
-OK," which therefore suppresses the incorrect "read from
-uninitialized" warnings.  This code adds trivial overhead to the
-critical performance path, so it is disabled by default.  The intent
-is that production users can use a "normal" build of libmthca and
-developers can use the "valgrind debug" build by simply switching
-their OPENIB_DRIVER_PATH environment variables.
-
-Libmthca needs some header files from Valgrind in order to compile
-this support; it is important to use the header files from the same
-version of Valgrind that will be used at run time.  You may need to
-specify the directory where Valgrind's header files are installed as
-an argument to --with-valgrind.  For example
-
-	./configure --with-valgrind=/opt/valgrind
-
-will make the libmthca build look for valgrind headers in
-/opt/valgrind/include
diff --git a/providers/ocrdma/README b/providers/ocrdma/README
deleted file mode 100644
index 6ae30fe..0000000
--- a/providers/ocrdma/README
+++ /dev/null
@@ -1,19 +0,0 @@
-Introduction
-============
-
-libocrdma is a userspace driver for Emulex OneConnect RDMA Adapters.
-It is a plug-in module for libibverbs that allows programs to use
-Emulex RDMA hardware directly from userspace. See the libibverbs
-package for more information.
-
-Using libocrdma
-===============
-
-libocrdma will be loaded and used automatically by programs linked
-with libibverbs. The ocrdma kernel modules must be loaded for RDMA
-devices to be detected and used.
-
-Supported Hardware
-==================
-
-libocrdma supports all RDMA capable  Emulex adapters.
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
