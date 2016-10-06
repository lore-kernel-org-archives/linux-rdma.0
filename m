From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 14/17] rdmacm: Flatten librdmacm/src,include into librdmacm/
Date: Thu,  6 Oct 2016 14:51:40 -0600
Message-ID: <1475787103-13283-15-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The top level dir produces the library and examples/ produces
the example programs.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                              |  2 +-
 librdmacm/{src => }/CMakeLists.txt          | 10 +++++-----
 librdmacm/{src => }/acm.c                   |  0
 librdmacm/{src => }/addrinfo.c              |  0
 librdmacm/{src => }/cma.c                   |  0
 librdmacm/{src => }/cma.h                   |  0
 librdmacm/{include/infiniband => }/ib.h     |  0
 librdmacm/{src => }/indexer.c               |  0
 librdmacm/{src => }/indexer.h               |  0
 librdmacm/{src => }/librdmacm.map           |  0
 librdmacm/{src => }/librspreload.map        |  0
 librdmacm/{src => }/preload.c               |  0
 librdmacm/{include/rdma => }/rdma_cma.h     |  0
 librdmacm/{include/rdma => }/rdma_cma_abi.h |  0
 librdmacm/{include/rdma => }/rdma_verbs.h   |  0
 librdmacm/{src => }/rsocket.c               |  0
 librdmacm/{include/rdma => }/rsocket.h      |  0
 17 files changed, 6 insertions(+), 6 deletions(-)
 rename librdmacm/{src => }/CMakeLists.txt (89%)
 rename librdmacm/{src => }/acm.c (100%)
 rename librdmacm/{src => }/addrinfo.c (100%)
 rename librdmacm/{src => }/cma.c (100%)
 rename librdmacm/{src => }/cma.h (100%)
 rename librdmacm/{include/infiniband => }/ib.h (100%)
 rename librdmacm/{src => }/indexer.c (100%)
 rename librdmacm/{src => }/indexer.h (100%)
 rename librdmacm/{src => }/librdmacm.map (100%)
 rename librdmacm/{src => }/librspreload.map (100%)
 rename librdmacm/{src => }/preload.c (100%)
 rename librdmacm/{include/rdma => }/rdma_cma.h (100%)
 rename librdmacm/{include/rdma => }/rdma_cma_abi.h (100%)
 rename librdmacm/{include/rdma => }/rdma_verbs.h (100%)
 rename librdmacm/{src => }/rsocket.c (100%)
 rename librdmacm/{include/rdma => }/rsocket.h (100%)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index a0ec5ecd9da0..64f9797c980c 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -255,7 +255,7 @@ add_subdirectory(libibumad)
 add_subdirectory(libibumad/man)
 add_subdirectory(libibverbs)
 add_subdirectory(libibverbs/man)
-add_subdirectory(librdmacm/src)
+add_subdirectory(librdmacm)
 add_subdirectory(librdmacm/man)
 add_subdirectory(libibcm)
 
diff --git a/librdmacm/src/CMakeLists.txt b/librdmacm/CMakeLists.txt
similarity index 89%
rename from librdmacm/src/CMakeLists.txt
rename to librdmacm/CMakeLists.txt
index bff631ea7f0d..b3dafba0bc6a 100644
--- a/librdmacm/src/CMakeLists.txt
+++ b/librdmacm/CMakeLists.txt
@@ -1,11 +1,11 @@
 publish_headers(rdma
-  ../include/rdma/rdma_cma.h
-  ../include/rdma/rdma_cma_abi.h
-  ../include/rdma/rdma_verbs.h
-  ../include/rdma/rsocket.h
+  rdma_cma.h
+  rdma_cma_abi.h
+  rdma_verbs.h
+  rsocket.h
   )
 publish_headers(infiniband
-  ../include/infiniband/ib.h
+  ib.h
   )
 
 rdma_library(rdmacm librdmacm.map
diff --git a/librdmacm/src/acm.c b/librdmacm/acm.c
similarity index 100%
rename from librdmacm/src/acm.c
rename to librdmacm/acm.c
diff --git a/librdmacm/src/addrinfo.c b/librdmacm/addrinfo.c
similarity index 100%
rename from librdmacm/src/addrinfo.c
rename to librdmacm/addrinfo.c
diff --git a/librdmacm/src/cma.c b/librdmacm/cma.c
similarity index 100%
rename from librdmacm/src/cma.c
rename to librdmacm/cma.c
diff --git a/librdmacm/src/cma.h b/librdmacm/cma.h
similarity index 100%
rename from librdmacm/src/cma.h
rename to librdmacm/cma.h
diff --git a/librdmacm/include/infiniband/ib.h b/librdmacm/ib.h
similarity index 100%
rename from librdmacm/include/infiniband/ib.h
rename to librdmacm/ib.h
diff --git a/librdmacm/src/indexer.c b/librdmacm/indexer.c
similarity index 100%
rename from librdmacm/src/indexer.c
rename to librdmacm/indexer.c
diff --git a/librdmacm/src/indexer.h b/librdmacm/indexer.h
similarity index 100%
rename from librdmacm/src/indexer.h
rename to librdmacm/indexer.h
diff --git a/librdmacm/src/librdmacm.map b/librdmacm/librdmacm.map
similarity index 100%
rename from librdmacm/src/librdmacm.map
rename to librdmacm/librdmacm.map
diff --git a/librdmacm/src/librspreload.map b/librdmacm/librspreload.map
similarity index 100%
rename from librdmacm/src/librspreload.map
rename to librdmacm/librspreload.map
diff --git a/librdmacm/src/preload.c b/librdmacm/preload.c
similarity index 100%
rename from librdmacm/src/preload.c
rename to librdmacm/preload.c
diff --git a/librdmacm/include/rdma/rdma_cma.h b/librdmacm/rdma_cma.h
similarity index 100%
rename from librdmacm/include/rdma/rdma_cma.h
rename to librdmacm/rdma_cma.h
diff --git a/librdmacm/include/rdma/rdma_cma_abi.h b/librdmacm/rdma_cma_abi.h
similarity index 100%
rename from librdmacm/include/rdma/rdma_cma_abi.h
rename to librdmacm/rdma_cma_abi.h
diff --git a/librdmacm/include/rdma/rdma_verbs.h b/librdmacm/rdma_verbs.h
similarity index 100%
rename from librdmacm/include/rdma/rdma_verbs.h
rename to librdmacm/rdma_verbs.h
diff --git a/librdmacm/src/rsocket.c b/librdmacm/rsocket.c
similarity index 100%
rename from librdmacm/src/rsocket.c
rename to librdmacm/rsocket.c
diff --git a/librdmacm/include/rdma/rsocket.h b/librdmacm/rsocket.h
similarity index 100%
rename from librdmacm/include/rdma/rsocket.h
rename to librdmacm/rsocket.h
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
