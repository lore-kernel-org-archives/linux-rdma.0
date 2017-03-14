From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/7] Drop debugging print in CMakeLists.txt
Date: Tue, 14 Mar 2017 10:21:08 -0600
Message-ID: <1489508474-16664-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1489508474-16664-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489508474-16664-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt | 1 -
 1 file changed, 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 7ebf8edfee7686..358bfd543e7785 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -135,7 +135,6 @@ RDMA_BuildType()
 include_directories(${BUILD_INCLUDE})
 
 RDMA_CheckSparse()
-message(STATUS "SPARSE1 ${HAVE_SPARSE}")
 
 # Require GNU99 mode
 RDMA_EnableCStd()
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
