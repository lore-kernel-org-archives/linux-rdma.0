From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V3] Add flow control to the portmapper
Date: Thu, 28 Jul 2016 15:02:26 -0500
Message-ID: <1469736146-17640-1-git-send-email-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

During connection establishment with a large number of
connections, it is possible that the connection requests
might fail. Adding flow control prevents this failure.
Change ibnl_unicast to use blocking to enable flow control.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

V3: update to use blocking ver. of netlink_unicast() in 
ibnl_unicast(), instead of creating new function in 
netlink header for this purpose; as was done in V1.

V2: update commit message with justification for flow control. 
CC'ing linux-netdev mailing list.

 drivers/infiniband/core/netlink.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 9b8c20c..a6b3acb 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -229,7 +229,13 @@ static void ibnl_rcv(struct sk_buff *skb)
 int ibnl_unicast(struct sk_buff *skb, struct nlmsghdr *nlh,
 			__u32 pid)
 {
-	return nlmsg_unicast(nls, skb, pid);
+	int err;
+
+	err = netlink_unicast(nls, skb, pid, 0);
+	if (err > 0)
+		err = 0;
+
+	return err;
 }
 EXPORT_SYMBOL(ibnl_unicast);
 
@@ -252,6 +258,7 @@ int __init ibnl_init(void)
 		return -ENOMEM;
 	}
 
+	nls->sk_sndtimeo = 10 * HZ;
 	return 0;
 }
 
-- 
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
