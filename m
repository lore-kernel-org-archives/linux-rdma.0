From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 02/17] Update COPYING to reflect recent cxgb4 merge
Date: Thu,  6 Oct 2016 14:51:28 -0600
Message-ID: <1475787103-13283-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475787103-13283-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475787103-13283-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

queue.h is gone and all files have a copying header.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 COPYING.md       |  7 +------
 libcxgb4/COPYING | 29 -----------------------------
 2 files changed, 1 insertion(+), 35 deletions(-)
 delete mode 100644 libcxgb4/COPYING

diff --git a/COPYING.md b/COPYING.md
index d3a3919dc2d4..3d55eb9f5ef1 100644
--- a/COPYING.md
+++ b/COPYING.md
@@ -1,7 +1,7 @@
 # Default Dual License
 
 Unless otherwise stated this software is available to you under a choice of
-one of two licenses.  You may choose to be licensed under the terms of the the
+one of two licenses.  You may choose to be licensed under the terms of the
 OpenIB.org BSD (MIT variant) license (see COPYING.BSD_MIT) or the GNU General
 Public License (GPL) Version 2 (see COPYING.GPL2), both included in this
 package.
@@ -36,11 +36,6 @@ several licenses:
 The following providers use a different license than the Default Dual
 License. Refer to files in each directory for details.
 
-cxbg4
-: A combination of the
-    - Default Dual License
-    - cxgb4/src/queue.h: BSD 3 clause license.
-
 hfi1verbs
 : Dual License: GPLv2 or Intel 3 clause BSD license
 
diff --git a/libcxgb4/COPYING b/libcxgb4/COPYING
deleted file mode 100644
index 93b666faf583..000000000000
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
