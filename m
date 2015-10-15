From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-cm] IB/core: Fix use after free of ifa
Date: Thu, 15 Oct 2015 15:01:03 +0300
Message-ID: <1444910463-5688-2-git-send-email-matanb@mellanox.com>
References: <1444910463-5688-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444910463-5688-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When using ifup/ifdown while executing enum_netdev_ipv4_ips,
ifa could become invalid and cause use after free error.
Fixing it by protecting with RCU lock.

Fixes: 03db3a2d81e6 ('IB/core: Add RoCE GID table management')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Hi Doug,

This patch fixes a bug in RoCE GID table implementation. Under stress conditions
where ifup/ifdown are used, the ifa pointer could become invalid. Using a
RCU lock in order to avoid freeing the ifa node (as done in other inet functions
(for example, inet_addr_onlink).

Our QA team verified that this patch fixes this issue.

Thanks,
Matan

 drivers/infiniband/core/roce_gid_mgmt.c | 35 +++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 6b24cba..178f984 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -250,25 +250,44 @@ static void enum_netdev_ipv4_ips(struct ib_device *ib_dev,
 				 u8 port, struct net_device *ndev)
 {
 	struct in_device *in_dev;
+	struct sin_list {
+		struct list_head	list;
+		struct sockaddr_in	ip;
+	};
+	struct sin_list *sin_iter;
+	struct sin_list *sin_temp;
 
+	LIST_HEAD(sin_list);
 	if (ndev->reg_state >= NETREG_UNREGISTERING)
 		return;
 
-	in_dev = in_dev_get(ndev);
-	if (!in_dev)
+	rcu_read_lock();
+	in_dev = __in_dev_get_rcu(ndev);
+	if (!in_dev) {
+		rcu_read_unlock();
 		return;
+	}
 
 	for_ifa(in_dev) {
-		struct sockaddr_in ip;
+		struct sin_list *entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 
-		ip.sin_family = AF_INET;
-		ip.sin_addr.s_addr = ifa->ifa_address;
-		update_gid_ip(GID_ADD, ib_dev, port, ndev,
-			      (struct sockaddr *)&ip);
+		if (!entry) {
+			pr_warn("roce_gid_mgmt: couldn't allocate entry for IPv4 update\n");
+			continue;
+		}
+		entry->ip.sin_family = AF_INET;
+		entry->ip.sin_addr.s_addr = ifa->ifa_address;
+		list_add_tail(&entry->list, &sin_list);
 	}
 	endfor_ifa(in_dev);
+	rcu_read_unlock();
 
-	in_dev_put(in_dev);
+	list_for_each_entry_safe(sin_iter, sin_temp, &sin_list, list) {
+		update_gid_ip(GID_ADD, ib_dev, port, ndev,
+			      (struct sockaddr *)&sin_iter->ip);
+		list_del(&sin_iter->list);
+		kfree(sin_iter);
+	}
 }
 
 static void enum_netdev_ipv6_ips(struct ib_device *ib_dev,
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
