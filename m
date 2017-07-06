From: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/cma: Fix reference count leak when no ipv4 addresses are set
Date: Thu, 6 Jul 2017 23:22:11 +0300
Message-ID: <1499372531-25392-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: michal.kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, ariel.elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Once in_dev_get is called to receive in_device pointer, the
in_device reference counter is increased, but if there are
no ipv4 addresses configured on the net-device the ifa_list
will be null, resulting in a flow that doesn't call in_dev_put
to decrease the ref_cnt.
This was exposed when running RoCE over ipv6 without any ipv4
addresses configured

Fixes: commit 8e3867310c90 ("IB/cma: Fix a race condition in iboe_addr_get_sgid()")

Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

---
 include/rdma/ib_addr.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 4b34c51..b73a14e 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -205,11 +205,13 @@ static inline void iboe_addr_get_sgid(struct rdma_dev_addr *dev_addr,
 	dev = dev_get_by_index(&init_net, dev_addr->bound_dev_if);
 	if (dev) {
 		ip4 = in_dev_get(dev);
-		if (ip4 && ip4->ifa_list && ip4->ifa_list->ifa_address) {
+		if (ip4 && ip4->ifa_list && ip4->ifa_list->ifa_address)
 			ipv6_addr_set_v4mapped(ip4->ifa_list->ifa_address,
 					       (struct in6_addr *)gid);
+
+		if (ip4)
 			in_dev_put(ip4);
-		}
+
 		dev_put(dev);
 	}
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
