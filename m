From: <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/4] RDMA/libocrdma: Increment abi version count
Date: Fri, 21 Feb 2014 11:01:44 +0530
Message-ID: <1392960704-10871-4-git-send-email-devesh.sharma@emulex.com>
References: <1392960704-10871-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392960704-10871-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Increment the driver/library abi version count.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 src/ocrdma_abi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/ocrdma_abi.h b/src/ocrdma_abi.h
index 9b44cd3..88498a9 100644
--- a/src/ocrdma_abi.h
+++ b/src/ocrdma_abi.h
@@ -37,7 +37,7 @@
 
 #include <infiniband/kern-abi.h>
 
-#define OCRDMA_ABI_VERSION	1
+#define OCRDMA_ABI_VERSION	2
 
 #define Bit(_b) (1 << (_b))
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
