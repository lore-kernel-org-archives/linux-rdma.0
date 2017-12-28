From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH] infiniband: drop unknown function from core_priv.h
Date: Wed, 27 Dec 2017 16:33:57 -0800
Message-ID: <a74802df-c00b-922b-bafa-8fba947a53c8@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Delete ibnl_chk_listeners() and its kernel-doc comments from the
core_priv.h header file.  There is no such function.

Fixes 233c1955835b ("RDMA/netlink: Reduce exposure of RDMA netlink functions")

Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/core/core_priv.h |    7 -------
 1 file changed, 7 deletions(-)

--- linux-next-20171222.orig/drivers/infiniband/core/core_priv.h
+++ linux-next-20171222/drivers/infiniband/core/core_priv.h
@@ -191,13 +191,6 @@ void ib_sa_cleanup(void);
 int rdma_nl_init(void);
 void rdma_nl_exit(void);
 
-/**
- * Check if there are any listeners to the netlink group
- * @group: the netlink group ID
- * Returns 0 on success or a negative for no listeners.
- */
-int ibnl_chk_listeners(unsigned int group);
-
 int ib_nl_handle_resolve_resp(struct sk_buff *skb,
 			      struct nlmsghdr *nlh,
 			      struct netlink_ext_ack *extack);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
