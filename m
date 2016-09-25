From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core 1/5] cmake: Update build instructions in CmakeList
Date: Sun, 25 Sep 2016 09:50:03 +0300
Message-ID: <1474786207-2149-2-git-send-email-leon@kernel.org>
References: <1474786207-2149-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474786207-2149-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 CMakeLists.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index a829cd4..557d3a8 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -1,6 +1,7 @@
 # COPYRIGHT (c) 2016 Obsidian Research Corporation. See COPYING file
 # Run cmake as:
 #  mkdir build
+#  cd build
 #  cmake -GNinja ..
 #  ninja
 #
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
