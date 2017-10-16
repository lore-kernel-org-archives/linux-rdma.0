From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 4/6] IB/core: Fix use workqueue without WQ_MEM_RECLAIM
Date: Mon, 16 Oct 2017 08:45:15 +0300
Message-ID: <20171016054517.30643-5-leon@kernel.org>
References: <20171016054517.30643-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016054517.30643-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The IB/core provides address resolution service and invokes callback
handler when address resolve request completes of requester in worker
thread context.

Such caller might allocate or free memory in callback handler
depending on the completion status to make further progress or to
terminate a connection. Most ULPs resolve route which involves
allocating route entry and path record elements in callback event handler.

It has been noticed that WQ_MEM_RECLAIM flag should not be used for
workers that tend to allocate memory in this [1] thread discussion.

In order to mitigate this situation, WQ_MEM_RECLAIM flag was dropped for
other such WQs in this [2] patch.

Similar problem might arise with address resolution path, though its not
yet noticed. The ib_addr workqueue is not memory reclaim path due to its
nature of invoking callback that might allocate memory or don't free any
memory under memory pressure.

[1] https://www.spinics.net/lists/linux-rdma/msg53239.html
[2] https://www.spinics.net/lists/linux-rdma/msg53416.html

Fixes: f54816261c2b ("IB/addr: Remove deprecated create_singlethread_workqueue")
Fixes: 5fff41e1f89d ("IB/core: Fix race condition in resolving IP to MAC")
Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 12523f630b61..d2f74721b3ba 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -852,7 +852,7 @@ static struct notifier_block nb = {
 
 int addr_init(void)
 {
-	addr_wq = alloc_ordered_workqueue("ib_addr", WQ_MEM_RECLAIM);
+	addr_wq = alloc_ordered_workqueue("ib_addr", 0);
 	if (!addr_wq)
 		return -ENOMEM;
 
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
