From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 1/1] IB/core: Fix static analysis warning in ib_policy_change_task
Date: Wed,  5 Jul 2017 16:15:21 +0300
Message-ID: <1499260521-5294-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

ib_get_cached_subnet_prefix can technically fail, but the only way it
could is not possible based on the loop conditions. Check the return
value before using the variable sp to resolve a static analysis warning.

Fixes: 8f408ab64be6 ("selinux lsm IB/core: Implement LSM notification
system")
Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-v1:
- Fix check to !ret. Paul Moore
---
 drivers/infiniband/core/device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 631eaa9..a5dfab6 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -376,7 +376,8 @@ static void ib_policy_change_task(struct work_struct *work)
 			WARN_ONCE(ret,
 				  "ib_get_cached_subnet_prefix err: %d, this should never happen here\n",
 				  ret);
-			ib_security_cache_change(dev, i, sp);
+			if (!ret)
+				ib_security_cache_change(dev, i, sp);
 		}
 	}
 	up_read(&lists_rwsem);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
