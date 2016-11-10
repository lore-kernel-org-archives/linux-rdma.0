From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 8/8] mlx4: Push COPYING file into individual files
Date: Thu, 10 Nov 2016 11:47:40 -0700
Message-ID: <1478803660-27959-9-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1478803660-27959-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478803660-27959-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add missing copyright headers and delete the COPYING file.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mlx4/COPYING | 378 -------------------------------------------------
 providers/mlx4/mmio.h  |   2 +
 2 files changed, 2 insertions(+), 378 deletions(-)
 delete mode 100644 providers/mlx4/COPYING

diff --git a/providers/mlx4/COPYING b/providers/mlx4/COPYING
deleted file mode 100644
index add3d1990bc1..000000000000
diff --git a/providers/mlx4/mmio.h b/providers/mlx4/mmio.h
index 0304fd7efa5e..f907661ddcf9 100644
--- a/providers/mlx4/mmio.h
+++ b/providers/mlx4/mmio.h
@@ -1,3 +1,5 @@
+/* Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See COPYING.md
+ */
 #ifndef MMIO_H
 #define MMIO_H
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
