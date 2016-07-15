From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Add flow control to the portmapper
Date: Fri, 15 Jul 2016 11:59:57 -0500
Message-ID: <1468601997-63396-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add flow control to port-mapper by changing ibnl unicast
to use netlink messaging with blocking.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/netlink.c |  4 ++--
 include/net/netlink.h             | 17 +++++++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 9b8c20c..6b09580 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -229,7 +229,7 @@ static void ibnl_rcv(struct sk_buff *skb)
 int ibnl_unicast(struct sk_buff *skb, struct nlmsghdr *nlh,
 			__u32 pid)
 {
-	return nlmsg_unicast(nls, skb, pid);
+	return nlmsg_unicast_block(nls, skb, pid);
 }
 EXPORT_SYMBOL(ibnl_unicast);
 
@@ -251,7 +251,7 @@ int __init ibnl_init(void)
 		pr_warn("Failed to create netlink socket\n");
 		return -ENOMEM;
 	}
-
+	nls->sk_sndtimeo = 10 * HZ;
 	return 0;
 }
 
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 254a0fc..5434279 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -598,6 +598,23 @@ static inline int nlmsg_unicast(struct sock *sk, struct sk_buff *skb, u32 portid
 }
 
 /**
+ * nlmsg_unicast_block - unicast a netlink message with blocking
+ * @sk: netlink socket to spread message to
+ * @skb: netlink message as socket buffer
+ * @portid: netlink portid of the destination socket
+ */
+static inline int nlmsg_unicast_block(struct sock *sk, struct sk_buff *skb, u32 portid)
+{
+	int err;
+
+	err = netlink_unicast(sk, skb, portid, 0);
+	if (err > 0)
+		err = 0;
+
+	return err;
+}
+
+/**
  * nlmsg_for_each_msg - iterate over a stream of messages
  * @pos: loop counter, set to current message
  * @head: head of message stream
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
