From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/cma: Fix a race condition in iboe_addr_get_sgid()
Date: Fri, 16 Dec 2016 14:39:12 +0100
Message-ID: <811914f1-3bcc-a0a4-e20a-86e8b5853ac7@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Moni,

Commit 7b85627b9f02 ("IB/cma: IBoE (RoCE) IP-based GID addressing") introduced code that
dereferences an RCU pointer without using rcu_read_lock(). Can you check whether the patch
below is the correct way to fix this?

Thanks,

Bart.

---
 include/rdma/ib_addr.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 931a47ba4571..1beab5532035 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -205,10 +205,12 @@ static inline void iboe_addr_get_sgid(struct rdma_dev_addr *dev_addr,
 
 	dev = dev_get_by_index(&init_net, dev_addr->bound_dev_if);
 	if (dev) {
-		ip4 = (struct in_device *)dev->ip_ptr;
-		if (ip4 && ip4->ifa_list && ip4->ifa_list->ifa_address)
+		ip4 = in_dev_get(dev);
+		if (ip4 && ip4->ifa_list && ip4->ifa_list->ifa_address) {
 			ipv6_addr_set_v4mapped(ip4->ifa_list->ifa_address,
 					       (struct in6_addr *)gid);
+			in_dev_put(ip4);
+		}
 		dev_put(dev);
 	}
 }
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
