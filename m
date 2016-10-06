From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 11/17] ibcm: Flatten libibcm/src,include into libibcm/
Date: Thu,  6 Oct 2016 14:51:37 -0600
Message-ID: <1475787103-13283-12-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The top level dir produces the library and examples/ produces
the example program.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                            | 2 +-
 libibcm/{src => }/CMakeLists.txt          | 4 ++--
 libibcm/{src => }/cm.c                    | 0
 libibcm/{include/infiniband => }/cm.h     | 0
 libibcm/{include/infiniband => }/cm_abi.h | 0
 libibcm/{src => }/libibcm.map             | 0
 6 files changed, 3 insertions(+), 3 deletions(-)
 rename libibcm/{src => }/CMakeLists.txt (74%)
 rename libibcm/{src => }/cm.c (100%)
 rename libibcm/{include/infiniband => }/cm.h (100%)
 rename libibcm/{include/infiniband => }/cm_abi.h (100%)
 rename libibcm/{src => }/libibcm.map (100%)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index ae6b5ed5eb0b..f857f9118a11 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -257,7 +257,7 @@ add_subdirectory(libibverbs/src)
 add_subdirectory(libibverbs/man)
 add_subdirectory(librdmacm/src)
 add_subdirectory(librdmacm/man)
-add_subdirectory(libibcm/src)
+add_subdirectory(libibcm)
 
 # Providers
 add_subdirectory(providers/cxgb3)
diff --git a/libibcm/src/CMakeLists.txt b/libibcm/CMakeLists.txt
similarity index 74%
rename from libibcm/src/CMakeLists.txt
rename to libibcm/CMakeLists.txt
index 66b3362ec7a0..7087859ee8e3 100644
--- a/libibcm/src/CMakeLists.txt
+++ b/libibcm/CMakeLists.txt
@@ -1,6 +1,6 @@
 publish_headers(infiniband
-  ../include/infiniband/cm.h
-  ../include/infiniband/cm_abi.h
+  cm.h
+  cm_abi.h
   )
 
 rdma_library(ibcm libibcm.map
diff --git a/libibcm/src/cm.c b/libibcm/cm.c
similarity index 100%
rename from libibcm/src/cm.c
rename to libibcm/cm.c
diff --git a/libibcm/include/infiniband/cm.h b/libibcm/cm.h
similarity index 100%
rename from libibcm/include/infiniband/cm.h
rename to libibcm/cm.h
diff --git a/libibcm/include/infiniband/cm_abi.h b/libibcm/cm_abi.h
similarity index 100%
rename from libibcm/include/infiniband/cm_abi.h
rename to libibcm/cm_abi.h
diff --git a/libibcm/src/libibcm.map b/libibcm/libibcm.map
similarity index 100%
rename from libibcm/src/libibcm.map
rename to libibcm/libibcm.map
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
