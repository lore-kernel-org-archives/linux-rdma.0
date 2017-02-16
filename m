From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 01/14] mlx5: Use stdatomic for the in_use barrier
Date: Thu, 16 Feb 2017 12:22:56 -0700
Message-ID: <1487272989-8215-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since this is not a DMA barrier we do not want to use wmb() here.

Replace it with a weak atomic fence.

For x86-64 this has no change to the assembly output.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/mlx5/mlx5.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index be52a0a75dded0..e63164c2caea7b 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -35,6 +35,7 @@
 
 #include <stddef.h>
 #include <stdio.h>
+#include <stdatomic.h>
 #include <util/compiler.h>
 
 #include <infiniband/driver.h>
@@ -683,7 +684,11 @@ static inline int mlx5_spin_lock(struct mlx5_spinlock *lock)
 		abort();
 	} else {
 		lock->in_use = 1;
-		wmb();
+		/*
+		 * This fence is not at all correct, but it increases the
+		 * chance that in_use is detected by another thread without
+		 * much runtime cost. */
+		atomic_thread_fence(memory_order_acq_rel);
 	}
 
 	return 0;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
