From: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Subject: [patch 1/1] drivers/infiniband/core/cm.c: convert to using idr_alloc_cyclic()
Date: Fri, 15 Nov 2013 14:16:37 -0800
Message-ID: <20131115221638.B53C31E418F@corp2gmr1-2.eem.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: drivers/infiniband/core/cm.c: convert to using idr_alloc_cyclic()

commit 3e6628c4b347 ("idr: introduce idr_alloc_cyclic()") adds a new
idr_alloc_cyclic routine and converts several of these users to it.  This
is just a missed one - add it.

Signed-off-by: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---

 drivers/infiniband/core/cm.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/infiniband/core/cm.c~drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic drivers/infiniband/core/cm.c
--- a/drivers/infiniband/core/cm.c~drivers-infiniband-core-cmc-convert-to-using-idr_alloc_cyclic
+++ a/drivers/infiniband/core/cm.c
@@ -383,14 +383,11 @@ static int cm_alloc_id(struct cm_id_priv
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
_
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
