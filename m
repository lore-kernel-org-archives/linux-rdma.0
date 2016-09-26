From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] utils: Create utils directory to put all
 common code and move min/max into it
Date: Mon, 26 Sep 2016 11:17:46 -0600
Message-ID: <20160926171746.GA22965@obsidianresearch.com>
References: <1474786207-2149-1-git-send-email-leon@kernel.org>
 <1474786207-2149-3-git-send-email-leon@kernel.org>
 <20160926070520.GJ4088@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160926070520.GJ4088-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 26, 2016 at 10:05:20AM +0300, Leon Romanovsky wrote:

> Can you give me a suggestion where and how should I use include_directories
> command to be able to write "#include <utils/math.h>"?

You were close, you did 'include_directories(util/)' which causes
something like 'gcc -I../util' - but that already stripped the util/
prefix, you'd need something like 'include_directories(.)'

However, let us continue to use the publish_headers scheme, so I
recommend you squish this into your series:

>From 406b60c89bd928d54b98e097e914f2131794ea62 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Mon, 26 Sep 2016 11:15:09 -0600
Subject: [PATCH] Use the publish_headers scheme for internal utils headers too

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                    |  7 +------
 buildlib/publish_headers.cmake    | 18 ++++++++++++++----
 ibacm/linux/osd.h                 |  2 +-
 libibverbs/examples/rc_pingpong.c |  2 +-
 libmlx5/src/mlx5.h                |  4 ++--
 libocrdma/src/ocrdma_main.c       |  2 +-
 libocrdma/src/ocrdma_main.h       |  2 +-
 libocrdma/src/ocrdma_verbs.c      |  2 +-
 librdmacm/src/cma.h               |  2 +-
 utils/CMakeLists.txt              |  4 ++++
 10 files changed, 27 insertions(+), 18 deletions(-)
 create mode 100644 utils/CMakeLists.txt

diff --git a/CMakeLists.txt b/CMakeLists.txt
index c997c6d90f3c..b28977550c39 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -38,8 +38,6 @@ set(BUILD_INCLUDE ${CMAKE_BINARY_DIR}/include)
 set(BUILD_BIN ${CMAKE_BINARY_DIR}/bin)
 # Libraries
 set(BUILD_LIB ${CMAKE_BINARY_DIR}/lib)
-# Common code
-set(COMMON_CODE utils)
 
 # Location to place provider .driver files
 set(CONFIG_DIR "${CMAKE_INSTALL_FULL_SYSCONFDIR}/libibverbs.d")
@@ -141,10 +139,6 @@ RDMA_AddOptCFlag(CMAKE_SHARED_LINKER_FLAGS SUPPORTS_NO_UNDEFINED "-Wl,--no-undef
 find_package(LDSymVer REQUIRED)
 
 #-------------------------
-# Common code
-include_directories(${COMMON_CODE})
-
-#-------------------------
 # Find libraries
 # pthread
 FIND_PACKAGE (Threads REQUIRED)
@@ -228,6 +222,7 @@ configure_file("${BUILDLIB}/config.h.in" "${BUILD_INCLUDE}/config.h" ESCAPE_QUOT
 
 #-------------------------
 # Sub-directories
+add_subdirectory(utils)
 # Libraries
 add_subdirectory(libibumad/src)
 add_subdirectory(libibumad/man)
diff --git a/buildlib/publish_headers.cmake b/buildlib/publish_headers.cmake
index ccd22960c141..c1909d677586 100644
--- a/buildlib/publish_headers.cmake
+++ b/buildlib/publish_headers.cmake
@@ -1,10 +1,9 @@
 # COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
 
-# Copy headers from the source directory to the proper place in the
-# build/include directory
-function(PUBLISH_HEADERS DEST)
+# Same as publish_headers but does not install them during the install phase
+function(publish_internal_headers DEST)
   if(NOT ARGN)
-    message(SEND_ERROR "Error: PUBLISH_HEADERS called without any files")
+    message(SEND_ERROR "Error: publish_internal_headers called without any files")
     return()
   endif()
 
@@ -15,6 +14,17 @@ function(PUBLISH_HEADERS DEST)
     get_filename_component(FIL ${SFIL} NAME)
     execute_process(COMMAND "ln" "-Tsf"
       "${CMAKE_CURRENT_SOURCE_DIR}/${SFIL}" "${DDIR}/${FIL}")
+  endforeach()
+endfunction()
+
+# Copy headers from the source directory to the proper place in the
+# build/include directory. This also installs them into /usr/include/xx during
+# the install phase
+function(publish_headers DEST)
+  publish_internal_headers("${DEST}" ${ARGN})
+
+  foreach(SFIL ${ARGN})
+    get_filename_component(FIL ${SFIL} NAME)
     install(FILES "${SFIL}" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/${DEST}/" RENAME "${FIL}")
   endforeach()
 endfunction()
diff --git a/ibacm/linux/osd.h b/ibacm/linux/osd.h
index 1a738e0bfc6b..2094e859e7eb 100644
--- a/ibacm/linux/osd.h
+++ b/ibacm/linux/osd.h
@@ -46,7 +46,7 @@
 #include <sys/time.h>
 #include <netinet/in.h>
 
-#include "../../utils/math.h"
+#include <utils/math.h>
 
 #define ACM_CONF_DIR  IBACM_CONFIG_PATH
 #define ACM_ADDR_FILE "ibacm_addr.cfg"
diff --git a/libibverbs/examples/rc_pingpong.c b/libibverbs/examples/rc_pingpong.c
index cc45741be152..59f369c2e1fc 100644
--- a/libibverbs/examples/rc_pingpong.c
+++ b/libibverbs/examples/rc_pingpong.c
@@ -49,7 +49,7 @@
 
 #include "pingpong.h"
 
-#include "../../utils/math.h"
+#include <utils/math.h>
 
 enum {
 	PINGPONG_RECV_WRID = 1,
diff --git a/libmlx5/src/mlx5.h b/libmlx5/src/mlx5.h
index 739249941650..aa270288e840 100644
--- a/libmlx5/src/mlx5.h
+++ b/libmlx5/src/mlx5.h
@@ -41,8 +41,8 @@
 #include "mlx5-abi.h"
 #include "bitmap.h"
 
-#include "../../utils/math.h"
-#include "../../utils/list.h"
+#include <utils/math.h>
+#include <utils/list.h>
 
 #ifdef __GNUC__
 #define likely(x)	__builtin_expect((x), 1)
diff --git a/libocrdma/src/ocrdma_main.c b/libocrdma/src/ocrdma_main.c
index 6bd892c1f799..d86b2d779dc1 100644
--- a/libocrdma/src/ocrdma_main.c
+++ b/libocrdma/src/ocrdma_main.c
@@ -46,7 +46,7 @@
 
 #include "ocrdma_main.h"
 #include "ocrdma_abi.h"
-#include "../../utils/list.h"
+#include <utils/list.h>
 
 #include <sys/types.h>
 #include <sys/stat.h>
diff --git a/libocrdma/src/ocrdma_main.h b/libocrdma/src/ocrdma_main.h
index c7359c8ffaef..dc96cd214aff 100644
--- a/libocrdma/src/ocrdma_main.h
+++ b/libocrdma/src/ocrdma_main.h
@@ -42,7 +42,7 @@
 #include <infiniband/driver.h>
 #include <infiniband/arch.h>
 
-#include "../../utils/list.h"
+#include <utils/list.h>
 
 #define ocrdma_err(format, arg...) printf(format, ##arg)
 
diff --git a/libocrdma/src/ocrdma_verbs.c b/libocrdma/src/ocrdma_verbs.c
index 3efc8bbdb623..0507e7c8252a 100644
--- a/libocrdma/src/ocrdma_verbs.c
+++ b/libocrdma/src/ocrdma_verbs.c
@@ -51,7 +51,7 @@
 
 #include "ocrdma_main.h"
 #include "ocrdma_abi.h"
-#include "../../utils/list.h"
+#include <utils/list.h>
 
 static void ocrdma_ring_cq_db(struct ocrdma_cq *cq, uint32_t armed,
 			      int solicited, uint32_t num_cqe);
diff --git a/librdmacm/src/cma.h b/librdmacm/src/cma.h
index 83d98b0d0a84..c01c3c0cc35c 100644
--- a/librdmacm/src/cma.h
+++ b/librdmacm/src/cma.h
@@ -47,7 +47,7 @@
 #include <rdma/rdma_cma.h>
 #include <infiniband/ib.h>
 
-#include "../../utils/math.h"
+#include <utils/math.h>
 
 #ifdef INCLUDE_VALGRIND
 #   include <valgrind/memcheck.h>
diff --git a/utils/CMakeLists.txt b/utils/CMakeLists.txt
new file mode 100644
index 000000000000..2ad8d90d5a75
--- /dev/null
+++ b/utils/CMakeLists.txt
@@ -0,0 +1,4 @@
+publish_internal_headers(utils
+  list.h
+  math.h
+  )
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
