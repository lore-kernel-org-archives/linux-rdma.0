From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 06/10] mlx4: Remove include of asm/unistd.h
Date: Thu,  9 Feb 2017 14:53:28 -0700
Message-ID: <1486677212-3188-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486677212-3188-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This header should never be included from userspace.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mlx4/mmio.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/providers/mlx4/mmio.h b/providers/mlx4/mmio.h
index f907661ddcf950..a1a296658fdbb0 100644
--- a/providers/mlx4/mmio.h
+++ b/providers/mlx4/mmio.h
@@ -4,7 +4,6 @@
 #define MMIO_H
 
 #include <unistd.h>
-#include <asm/unistd.h>
 #include <sys/syscall.h>
 #ifdef __s390x__
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
