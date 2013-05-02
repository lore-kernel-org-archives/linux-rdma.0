From: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] drivers/infiniband/core/cm: convert to using idr_alloc_cyclic()
Date: Thu, 2 May 2013 11:01:48 +0800
Message-ID: <5181D71C.2010106@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The commit 3e6628c4b347 ("idr: introduce idr_alloc_cyclic()") adds a new 
idr_alloc_cyclic routine and converts several of these users to it. This
is just a miss one, add it.

Signed-off-by: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/cm.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 784b97c..f2ef7ef 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -383,14 +383,11 @@ static int cm_alloc_id(struct cm_id_private *cm_id_priv)
 {
 	unsigned long flags;
 	int id;
-	static int next_id;
 
 	idr_preload(GFP_KERNEL);
 	spin_lock_irqsave(&cm.lock, flags);
 
-	id = idr_alloc(&cm.local_id_table, cm_id_priv, next_id, 0, GFP_NOWAIT);
-	if (id >= 0)
-		next_id = max(id + 1, 0);
+	id = idr_alloc_cyclic(&cm.local_id_table, cm_id_priv, 0, 0, GFP_NOWAIT);
 
 	spin_unlock_irqrestore(&cm.lock, flags);
 	idr_preload_end();
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
