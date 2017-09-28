From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-4.14-rc] RDMA/netlink: Restore nlmsg_len calculation in ibnl_put_attr
Date: Thu, 28 Sep 2017 06:49:53 -0500
Message-ID: <20170928114953.9600-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit 1a1c116f3dcf removes nlmsg_len calculation in
ibnl_put_attr causing netlink messages to be rejected due
to incorrect length.

Restore the netlink message header length calculation
to include the added attribute.

Fixes: 1a1c116f3dcf ("RDMA/netlink: Simplify the put_msg and put_attr")
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index e685148..889d091 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -150,10 +150,14 @@ EXPORT_SYMBOL(ibnl_put_msg);
 int ibnl_put_attr(struct sk_buff *skb, struct nlmsghdr *nlh,
 		  int len, void *data, int type)
 {
+	unsigned char *prev_tail;
+
+	prev_tail = skb_tail_pointer(skb);
 	if (nla_put(skb, type, len, data)) {
 		nlmsg_cancel(skb, nlh);
 		return -EMSGSIZE;
 	}
+	nlh->nlmsg_len += skb_tail_pointer(skb) - prev_tail;
 	return 0;
 }
 EXPORT_SYMBOL(ibnl_put_attr);
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
