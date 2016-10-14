From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 7/8] Enable -Wformat=2
Date: Fri, 14 Oct 2016 16:14:16 -0600
Message-ID: <1476483257-16308-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1476483257-16308-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476483257-16308-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is useful to detect functions that are handling format strings but
not marked with __attribute__(format), as well as other sorts
for format related mistakes.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index bd58a7039618..8f21ba384c12 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -113,6 +113,7 @@ RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WARNINGS
 RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WMISSING_PROTOTYPES "-Wmissing-prototypes")
 RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WMISSING_DECLARATIONS "-Wmissing-declarations")
 RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WWRITE_STRINGS "-Wwrite-strings")
+RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WFORMAT_2 "-Wformat=2")
 
 # At some point around 5.4 gcc fixed missing-field-initializers to ignore this
 # common idiom we use extensively. Since this is a useful warning for
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
