From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 05/17] rdmacm: Drop SONAME in rspreload
Date: Thu,  6 Oct 2016 14:51:31 -0600
Message-ID: <1475787103-13283-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A LD_PRELOAD library should not have a SONAME, switch cmake from
SHARED to MODEL mode.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 librdmacm/src/CMakeLists.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/librdmacm/src/CMakeLists.txt b/librdmacm/src/CMakeLists.txt
index 0a60786c5f7a..bff631ea7f0d 100644
--- a/librdmacm/src/CMakeLists.txt
+++ b/librdmacm/src/CMakeLists.txt
@@ -22,10 +22,12 @@ target_link_libraries(rdmacm LINK_PRIVATE ${CMAKE_THREAD_LIBS_INIT})
 
 # The preload library is a bit special, it needs to be open coded
 # Since it is a LD_PRELOAD it has no soname, and is installed in sub dir
-add_library(rspreload SHARED
+add_library(rspreload MODULE
   preload.c
   indexer.c
   )
+# Even though this is a module we still want to use Wl,--no-undefined
+set_target_properties(rspreload PROPERTIES LINK_FLAGS ${CMAKE_SHARED_LINKER_FLAGS})
 set_target_properties(rspreload PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${BUILD_LIB}")
 rdma_set_library_map(rspreload librspreload.map)
 target_link_libraries(rspreload LINK_PRIVATE
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
