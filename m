From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v5 2/4] IB/core: Check the presence of netlink multicast group listeners
Date: Thu, 11 Jun 2015 13:03:43 -0400
Message-ID: <1434042225-4975-3-git-send-email-kaike.wan@intel.com>
References: <1434042225-4975-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434042225-4975-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds a function to check if listeners for a netlink multicast
group are present.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/netlink.c |    8 ++++++++
 include/rdma/rdma_netlink.h       |    7 +++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 23dd5a5..e0fc913 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -49,6 +49,14 @@ static DEFINE_MUTEX(ibnl_mutex);
 static struct sock *nls;
 static LIST_HEAD(client_list);
 
+int ibnl_chk_listeners(unsigned int group)
+{
+	if (netlink_has_listeners(nls, group) == 0)
+		return -1;
+	return 0;
+}
+EXPORT_SYMBOL(ibnl_chk_listeners);
+
 int ibnl_add_client(int index, int nops,
 		    const struct ibnl_client_cbs cb_table[])
 {
diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index 0790882..5852661 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -77,4 +77,11 @@ int ibnl_unicast(struct sk_buff *skb, struct nlmsghdr *nlh,
 int ibnl_multicast(struct sk_buff *skb, struct nlmsghdr *nlh,
 			unsigned int group, gfp_t flags);
 
+/**
+ * Check if there are any listeners to the netlink group
+ * @group: the netlink group ID
+ * Returns 0 on success or a negative for no listeners.
+ */
+int ibnl_chk_listeners(unsigned int group);
+
 #endif /* _RDMA_NETLINK_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
