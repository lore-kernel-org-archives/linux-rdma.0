From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/cma: Add a missing rcu_read_unlock()
Date: Fri, 20 Nov 2015 11:04:12 -0800
Message-ID: <564F6EAC.7070608@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ensure that validate_ipv4_net_dev() calls rcu_read_unlock() if
fib_lookup() fails. Detected by sparse. Compile-tested only.

Fixes: "IB/cma: Validate routing of incoming requests" (commit f887f2ac87c2).
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 69e5477..f8dfc63 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1126,10 +1126,7 @@ static bool validate_ipv4_net_dev(struct net_device *net_dev,
 
 	rcu_read_lock();
 	err = fib_lookup(dev_net(net_dev), &fl4, &res, 0);
-	if (err)
-		return false;
-
-	ret = FIB_RES_DEV(res) == net_dev;
+	ret = err == 0 && FIB_RES_DEV(res) == net_dev;
 	rcu_read_unlock();
 
 	return ret;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
