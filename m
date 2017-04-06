From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/6] ipath/hfi: Enable sparse from travis
Date: Thu,  6 Apr 2017 16:42:21 -0600
Message-ID: <1491518545-14746-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1491518545-14746-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491518545-14746-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These are clean now.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index e5074f6e100637..77f46eed0f4422 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -390,8 +390,8 @@ add_subdirectory(providers/qedr) # NO SPARSE
 add_subdirectory(providers/vmw_pvrdma) # NO SPARSE
 endif()
 
-add_subdirectory(providers/hfi1verbs) # NO SPARSE
-add_subdirectory(providers/ipathverbs) # NO SPARSE
+add_subdirectory(providers/hfi1verbs)
+add_subdirectory(providers/ipathverbs)
 add_subdirectory(providers/rxe)
 add_subdirectory(providers/rxe/man)
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
