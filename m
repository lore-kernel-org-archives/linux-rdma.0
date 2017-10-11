From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 20/45] RDMA/i40iw: Fix a race condition
Date: Wed, 11 Oct 2017 10:49:02 -0700
Message-ID: <20171011174927.25113-21-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use the proper primitives to dereference the RCU pointer
upper_dev->ip_ptr. Compile-tested only.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Reviewed-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index e52dbbb4165e..7304189b62ef 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -168,11 +168,16 @@ int i40iw_inetaddr_event(struct notifier_block *notifier,
 	if (netdev != event_netdev)
 		return NOTIFY_DONE;
 
-	if (upper_dev)
-		local_ipaddr = ntohl(
-			((struct in_device *)upper_dev->ip_ptr)->ifa_list->ifa_address);
-	else
+	if (upper_dev) {
+		struct in_device *in;
+
+		rcu_read_lock();
+		in = __in_dev_get_rcu(upper_dev);
+		local_ipaddr = ntohl(in->ifa_list->ifa_address);
+		rcu_read_unlock();
+	} else {
 		local_ipaddr = ntohl(ifa->ifa_address);
+	}
 	switch (event) {
 	case NETDEV_DOWN:
 		action = I40IW_ARP_DELETE;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
