From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 04/23] mlx5: Add cmake options to replace --with-mlx5_debug/mw_debug
Date: Wed, 21 Sep 2016 16:08:30 -0600
Message-ID: <1474495729-17604-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Simply enable -D flags when building.

Use as:
  $ cmake -DMLX5_DEBUG=TRUE -DMLX5_MW_DEBUG=TRUE

Reported-by: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libmlx5/src/CMakeLists.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/libmlx5/src/CMakeLists.txt b/libmlx5/src/CMakeLists.txt
index a34a8063eeb2..44df83b47d96 100644
--- a/libmlx5/src/CMakeLists.txt
+++ b/libmlx5/src/CMakeLists.txt
@@ -1,3 +1,15 @@
+set(MLX5_DEBUG "FALSE" CACHE BOOL
+  "Enable expensive runtime logging options for the mlx5 verbs provider")
+if (MLX5_DEBUG)
+  add_definitions("-DMLX5_DEBUG")
+endif()
+
+set(MLX5_MW_DEBUG "FALSE" CACHE BOOL
+  "Enable extra validation of memory windows for the mlx5 verbs provider")
+if (MLX5_MW_DEBUG)
+  add_definitions("-DMW_DEBUG")
+endif()
+
 rdma_provider(mlx5
   buf.c
   cq.c
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
